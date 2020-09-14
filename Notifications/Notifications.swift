//
//  Notifications.swift
//  Notifications
//
//  Created by user on 14/09/2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationsCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
          notificationsCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
              print("Prmission granted: \(granted)")
              
              guard granted else { return }
              self.getNotificationSettings()
          }
      }
      
      func getNotificationSettings() {
          notificationsCenter.getNotificationSettings { (settings) in
              print(settings)
          }
      }
      
      func scheduleNotification(notificationType: String) {
          
          let content = UNMutableNotificationContent()
          let userAction = "User Action"
          
          content.title = notificationType
          content.body = "This is example how to create"
          content.sound = UNNotificationSound.default
          content.badge = 1
          content.categoryIdentifier = userAction
          
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
          
          let identifire = "Local Notification"
          let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
          
          notificationsCenter.add(request) { (error) in
              if let error = error {
                  print("Error \(error.localizedDescription)")
              }
          }
          
          
          let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
          let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
          
          let category = UNNotificationCategory(
              identifier: userAction,
              actions: [snoozeAction, deleteAction],
              intentIdentifiers: [],
              options: [])
          
          notificationsCenter.setNotificationCategories([category])
          
          
          
      }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert, .sound])
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           
           print(response.notification.request.identifier)
           
           if response.notification.request.identifier == "Local Notification" {
               print("Handling notification with the Local Notofocation Identifire")
           }
           
           switch response.actionIdentifier {
           case UNNotificationDismissActionIdentifier:
               print("Dismis Action")
           case UNNotificationDefaultActionIdentifier:
               print("Default")
           case "Snooze":
               print("Snooze")
               scheduleNotification(notificationType: "Reminder")
           case "Delete":
               print("Delete")
           default:
               fatalError()
           }
           
           completionHandler()
       }

}
