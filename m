Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0FAVEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:04:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0FAVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:04:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/6] USB-BKL: Remove BKL use for usb serial driver probing
Date: Tue,  1 Jun 2010 23:04:42 +0200
Message-Id: <1275426285-9088-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19MCojos9GiOd35/fI/+2x+nJdhlUt8CMVhqU/
 yEs84cBmyoBU7aHp6MRkLYF7drPr7qFBoWOPK9GG/t7KOsFZ4D
 9PBsoGv9Th2zIWP4yGpMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The usb serial driver initialization tried to use the BKL to stop
driver modules from unloading, but that didn't work anyways.

There was already some code to do proper try_module_get,
but it was conditional on having a new probe interface.
I checked all the low level drivers and they all have proper
.owner = THIS_MODULE, so it's ok to always use.

The other problem was the usb_serial_driver_list needing
protection by a lock. This was broken anyways because unregister
did not necessarily have the BKL.

I extended the extending table_lock mutex to protect this case too.

With these changes the BKL can be removed here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/serial/usb-serial.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 941c2d4..443468e 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -653,6 +653,7 @@ exit:
 	return id;
 }
 
+/* Caller must hold table_lock */
 static struct usb_serial_driver *search_serial_device(
 					struct usb_interface *iface)
 {
@@ -718,17 +719,23 @@ int usb_serial_probe(struct usb_interface *interface,
 	int num_ports = 0;
 	int max_endpoints;
 
-	lock_kernel(); /* guard against unloading a serial driver module */
+	mutex_lock(&table_lock);
 	type = search_serial_device(interface);
 	if (!type) {
-		unlock_kernel();
+		mutex_unlock(&table_lock);
 		dbg("none matched");
 		return -ENODEV;
 	}
 
+	if (!try_module_get(type->driver.owner)) {
+		mutex_unlock(&table_lock);
+		dev_err(&interface->dev, "module get failed, exiting\n");
+		return -EIO;
+	}
+	mutex_unlock(&table_lock);
+
 	serial = create_serial(dev, interface, type);
 	if (!serial) {
-		unlock_kernel();
 		dev_err(&interface->dev, "%s - out of memory\n", __func__);
 		return -ENOMEM;
 	}
@@ -737,20 +744,11 @@ int usb_serial_probe(struct usb_interface *interface,
 	if (type->probe) {
 		const struct usb_device_id *id;
 
-		if (!try_module_get(type->driver.owner)) {
-			unlock_kernel();
-			dev_err(&interface->dev,
-				"module get failed, exiting\n");
-			kfree(serial);
-			return -EIO;
-		}
-
 		id = get_iface_id(type, interface);
 		retval = type->probe(serial, id);
 		module_put(type->driver.owner);
 
 		if (retval) {
-			unlock_kernel();
 			dbg("sub driver rejected device");
 			kfree(serial);
 			return retval;
@@ -822,7 +820,6 @@ int usb_serial_probe(struct usb_interface *interface,
 		 * properly during a later invocation of usb_serial_probe
 		 */
 		if (num_bulk_in == 0 || num_bulk_out == 0) {
-			unlock_kernel();
 			dev_info(&interface->dev, "PL-2303 hack: descriptors matched but endpoints did not\n");
 			kfree(serial);
 			return -ENODEV;
@@ -835,7 +832,6 @@ int usb_serial_probe(struct usb_interface *interface,
 	if (type == &usb_serial_generic_device) {
 		num_ports = num_bulk_out;
 		if (num_ports == 0) {
-			unlock_kernel();
 			dev_err(&interface->dev,
 			    "Generic device with no bulk out, not allowed.\n");
 			kfree(serial);
@@ -847,7 +843,6 @@ int usb_serial_probe(struct usb_interface *interface,
 		/* if this device type has a calc_num_ports function, call it */
 		if (type->calc_num_ports) {
 			if (!try_module_get(type->driver.owner)) {
-				unlock_kernel();
 				dev_err(&interface->dev,
 					"module get failed, exiting\n");
 				kfree(serial);
@@ -878,7 +873,6 @@ int usb_serial_probe(struct usb_interface *interface,
 	max_endpoints = max(max_endpoints, num_interrupt_out);
 	max_endpoints = max(max_endpoints, (int)serial->num_ports);
 	serial->num_port_pointers = max_endpoints;
-	unlock_kernel();
 
 	dbg("%s - setting up %d port structures for this device",
 						__func__, max_endpoints);
@@ -1349,6 +1343,7 @@ int usb_serial_register(struct usb_serial_driver *driver)
 		driver->description = driver->driver.name;
 
 	/* Add this device to our list of devices */
+	mutex_lock(&table_lock);
 	list_add(&driver->driver_list, &usb_serial_driver_list);
 
 	retval = usb_serial_bus_register(driver);
@@ -1360,6 +1355,7 @@ int usb_serial_register(struct usb_serial_driver *driver)
 		printk(KERN_INFO "USB Serial support registered for %s\n",
 						driver->description);
 
+	mutex_unlock(&table_lock);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(usb_serial_register);
@@ -1370,8 +1366,10 @@ void usb_serial_deregister(struct usb_serial_driver *device)
 	/* must be called with BKL held */
 	printk(KERN_INFO "USB Serial deregistering driver %s\n",
 	       device->description);
+	mutex_lock(&table_lock);
 	list_del(&device->driver_list);
 	usb_serial_bus_deregister(device);
+	mutex_unlock(&table_lock);
 }
 EXPORT_SYMBOL_GPL(usb_serial_deregister);
 
-- 
1.7.0.4

