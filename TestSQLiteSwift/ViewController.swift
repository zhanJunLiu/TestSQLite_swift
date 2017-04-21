//
//  ViewController.swift
//  TestSQLiteSwift
//
//  Created by phantom_zj on 2017/4/21.
//  Copyright © 2017年 phantom_zj. All rights reserved.
//

import UIKit
import SQLite


class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtID: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    // 1.创建仓库
    var db: Connection! = nil
    // 2.创建列表
    let users = Table("users")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 3.为仓库创建路径 (注意: 如果Documents文件下没有db.sqlite3这个文件,就会获取这个文件, 如果有就直接使用这个文件)
        do{
            db = try Connection(NSHomeDirectory()+"/Documents/db.sqlite3")
            print("数据库地址: ")
            print(NSHomeDirectory()+"/Documents/db.sqlite3")
            // 5.创建table初始化属性
            try db.run(users.create{ t in
                t.column(id, primaryKey:true)
                t.column(name)
                t.column(email)
            })
        }catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func insert(_ sender: Any) {
        
        do{
            // 6.创建完数据之后
            let insert = users.insert(name<-txtName.text!, email<-txtEmail.text!)
            // 7.添加完数据之后需要运行数据库(添加的数据)
            try db.run(insert)
        }catch{
            print(error)
        }
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let lzj = users.filter(id == 3)
        do{
            try db.run(lzj.delete())
        }catch{
            print(error)
        }
        
    }
    
    @IBAction func update(_ sender: Any) {
        
        let lzj = users.filter(id == 2)
        do{
            try db.run(lzj.update(name <- name.replace("LiuzhanJun", with: "LZJ")))
        }catch{
            print(error)
        }
        
    }
    
    @IBAction func selete(_ sender: Any) {
        do{
            for user in try db.prepare(users){
                print("id:\(user[id]), name:\(user[name]), email:\(user[email])")
            }
        }catch {
            print(error)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtID.resignFirstResponder()
    }
    
}

