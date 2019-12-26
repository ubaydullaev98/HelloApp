//
//  HelloTableViewController.swift
//  HelloApp
//
//  Created by Dilmurod Ubaydullaev on 12/26/19.
//  Copyright © 2019 Dilmurod Ubaydullaev. All rights reserved.
//

import UIKit
import CoreData

class HelloTableViewController: UITableViewController {
    
    var hellos : Array<String> = Array()
    
    override func viewWillAppear(_ animated: Bool) {
        hellos.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hello")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                hellos.append(data.value(forKey: "name") as! String)
          }
            
        } catch {
            
            print("Failed")
        }
    }

   //how many
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hellos.count
    }

    //each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = hellos[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hellos.remove(at: indexPath.row)
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hello")
        request.returnsObjectsAsFaults = false
        var count = 0
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                count += 1
                if count == 1  {
                    break
                }
                
          }
            
        } catch {
            
            print("Failed")
        }
         appDelegate.saveContext()
    }
    
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Hello", in: context)
        let newRecord = NSManagedObject(entity: entity!, insertInto: context)
        newRecord.setValue("Hello!", forKey: "name")
        appDelegate.saveContext()
        hellos.append("Hello!")
        tableView.reloadData()
    }
    
}
