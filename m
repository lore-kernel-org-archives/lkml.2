Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2IBV4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:56:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23287 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab2IBV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:56:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part5 3/7] ACPI, PCI: Protect global lists in drivers/acpi/pci_root.c
Date: Sun,  2 Sep 2012 14:56:01 -0700
Message-Id: <1346622965-30937-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
References: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

There are two global lists inf file drivers/acpi/pci_root.c.
One is for registered acpi_pci_drivers, the other is for
enumerated ACPI PCI root bridge objects. These two global
lists may change dynamically when registering/deregistering
acpi_pci_drivers or adding/removing ACPI PCI root bridge
objects. So protect them by mutex lock and RCU list.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   87 ++++++++++++++++++++++++++++------------------
 1 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 9ba516b..f3402df 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -27,7 +27,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/pci.h>
@@ -71,6 +72,8 @@ static struct acpi_driver acpi_pci_root_driver = {
 		},
 };
 
+/* Lock to protect both acpi_pci_roots and acpi_pci_drivers lists */
+static DEFINE_MUTEX(acpi_pci_root_lock);
 static LIST_HEAD(acpi_pci_roots);
 static LIST_HEAD(acpi_pci_drivers);
 
@@ -81,47 +84,48 @@ int acpi_pci_register_driver(struct acpi_pci_driver *driver)
 	int n = 0;
 	struct acpi_pci_root *root;
 
+	mutex_lock(&acpi_pci_root_lock);
 	list_add_tail(&driver->node, &acpi_pci_drivers);
-
-	if (!driver->add)
-		return 0;
-
-	list_for_each_entry(root, &acpi_pci_roots, node) {
-		driver->add(root->device->handle);
-		n++;
-	}
+	if (driver->add)
+		list_for_each_entry_rcu(root, &acpi_pci_roots, node) {
+			driver->add(root->device->handle);
+			n++;
+		}
+	mutex_unlock(&acpi_pci_root_lock);
 
 	return n;
 }
-
 EXPORT_SYMBOL(acpi_pci_register_driver);
 
 void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
 {
 	struct acpi_pci_root *root;
 
+	mutex_lock(&acpi_pci_root_lock);
 	list_del(&driver->node);
-
-	if (!driver->remove)
-		return;
-
-	list_for_each_entry(root, &acpi_pci_roots, node)
-		driver->remove(root->device->handle);
+	if (driver->remove)
+		list_for_each_entry_rcu(root, &acpi_pci_roots, node)
+			driver->remove(root->device->handle);
+	mutex_unlock(&acpi_pci_root_lock);
 }
-
 EXPORT_SYMBOL(acpi_pci_unregister_driver);
 
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int seg, unsigned int bus)
 {
 	struct acpi_pci_root *root;
+	struct acpi_handle *handle = NULL;
 	
-	list_for_each_entry(root, &acpi_pci_roots, node)
+	rcu_read_lock();
+	list_for_each_entry_rcu(root, &acpi_pci_roots, node)
 		if ((root->segment == (u16) seg) &&
-		    (root->secondary.start == (u16) bus))
-			return root->device->handle;
-	return NULL;		
-}
+		    (root->secondary.start == (u16) bus)) {
+			handle = root->device->handle;
+			break;
+		}
+	rcu_read_unlock();
 
+	return handle;
+}
 EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
 
 /**
@@ -268,10 +272,15 @@ struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
 {
 	struct acpi_pci_root *root;
 
-	list_for_each_entry(root, &acpi_pci_roots, node) {
-		if (root->device->handle == handle)
+	rcu_read_lock();
+	list_for_each_entry_rcu(root, &acpi_pci_roots, node) {
+		if (root->device->handle == handle) {
+			rcu_read_unlock();
 			return root;
+		}
 	}
+	rcu_read_unlock();
+
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(acpi_pci_find_root);
@@ -459,7 +468,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		printk(KERN_ERR PREFIX "can't evaluate _SEG\n");
 		result = -ENODEV;
-		goto end;
+		goto out_free;
 	}
 
 	/* Check _CRS first, then _BBN.  If no _BBN, default to zero. */
@@ -484,7 +493,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 		else {
 			printk(KERN_ERR PREFIX "can't evaluate _BBN\n");
 			result = -ENODEV;
-			goto end;
+			goto out_free;
 		}
 	}
 
@@ -508,8 +517,8 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 * TBD: Need PCI interface for enumeration/configuration of roots.
 	 */
 
-	/* TBD: Locking */
-	list_add_tail(&root->node, &acpi_pci_roots);
+	mutex_lock(&acpi_pci_root_lock);
+	list_add_tail_rcu(&root->node, &acpi_pci_roots);
 
 	printk(KERN_INFO PREFIX "%s [%s] (domain %04x %pR)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
@@ -528,7 +537,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 			    "Bus %04x:%02x not present in PCI namespace\n",
 			    root->segment, (unsigned int)root->secondary.start);
 		result = -ENODEV;
-		goto end;
+		goto out_del_root;
 	}
 
 	/*
@@ -538,7 +547,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 */
 	result = acpi_pci_bind_root(device);
 	if (result)
-		goto end;
+		goto out_del_root;
 
 	/*
 	 * PCI Routing Table
@@ -614,11 +623,15 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
 
+	mutex_unlock(&acpi_pci_root_lock);
+
 	return 0;
 
-end:
-	if (!list_empty(&root->node))
-		list_del(&root->node);
+out_del_root:
+	list_del_rcu(&root->node);
+	mutex_unlock(&acpi_pci_root_lock);
+	synchronize_rcu();
+out_free:
 	kfree(root);
 	return result;
 }
@@ -628,11 +641,13 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
+	mutex_lock(&acpi_pci_root_lock);
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->add)
 			driver->add(device->handle);
 
 	pci_bus_add_devices(root->bus);
+	mutex_unlock(&acpi_pci_root_lock);
 
 	return 0;
 }
@@ -642,6 +657,8 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
+	mutex_lock(&acpi_pci_root_lock);
+
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->remove)
 			driver->remove(root->device->handle);
@@ -661,7 +678,9 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	pci_stop_and_remove_bus(root->bus);
 
 out:
-	list_del(&root->node);
+	list_del_rcu(&root->node);
+	mutex_unlock(&acpi_pci_root_lock);
+	synchronize_rcu();
 	kfree(root);
 
 	return 0;
-- 
1.7.7

