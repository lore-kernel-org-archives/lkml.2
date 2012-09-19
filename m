Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2ISS6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:58:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19809 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab2ISSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 35/40] ACPI, PCI: Protect global lists in drivers/acpi/pci_root.c
Date: Wed, 19 Sep 2012 11:54:49 -0700
Message-Id: <1348080894-23412-36-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

There are two global lists inf file drivers/acpi/pci_root.c.
One is for registered acpi_pci_drivers, the other is for
enumerated ACPI PCI root bridge objects. These two global
lists may change dynamically when registering/deregistering
acpi_pci_drivers or adding/removing ACPI PCI root bridge
objects. So protect them by mutex lock.

-v2: remove -rcu

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   70 +++++++++++++++++++++++++++--------------------
 1 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 0ea5ad0..67f7733 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/pci.h>
@@ -71,6 +71,8 @@ static struct acpi_driver acpi_pci_root_driver = {
 		},
 };
 
+/* Lock to protect both acpi_pci_roots and acpi_pci_drivers lists */
+static DEFINE_MUTEX(acpi_pci_root_lock);
 static LIST_HEAD(acpi_pci_roots);
 static LIST_HEAD(acpi_pci_drivers);
 
@@ -81,47 +83,46 @@ int acpi_pci_register_driver(struct acpi_pci_driver *driver)
 	int n = 0;
 	struct acpi_pci_root *root;
 
+	mutex_lock(&acpi_pci_root_lock);
 	list_add_tail(&driver->node, &acpi_pci_drivers);
-
-	if (!driver->add)
-		return 0;
-
-	list_for_each_entry(root, &acpi_pci_roots, node) {
-		driver->add(root);
-		n++;
-	}
+	if (driver->add)
+		list_for_each_entry(root, &acpi_pci_roots, node) {
+			driver->add(root);
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
-		driver->remove(root);
+	if (driver->remove)
+		list_for_each_entry(root, &acpi_pci_roots, node)
+			driver->remove(root);
+	mutex_unlock(&acpi_pci_root_lock);
 }
-
 EXPORT_SYMBOL(acpi_pci_unregister_driver);
 
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int seg, unsigned int bus)
 {
 	struct acpi_pci_root *root;
-	
+	struct acpi_handle *handle = NULL;
+
 	list_for_each_entry(root, &acpi_pci_roots, node)
 		if ((root->segment == (u16) seg) &&
-		    (root->secondary.start == (u16) bus))
-			return root->device->handle;
-	return NULL;		
-}
+		    (root->secondary.start == (u16) bus)) {
+			handle = root->device->handle;
+			break;
+		}
 
+	return handle;
+}
 EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
 
 /**
@@ -459,7 +460,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		printk(KERN_ERR PREFIX "can't evaluate _SEG\n");
 		result = -ENODEV;
-		goto end;
+		goto out_free;
 	}
 
 	/* Check _CRS first, then _BBN.  If no _BBN, default to zero. */
@@ -484,7 +485,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 		else {
 			printk(KERN_ERR PREFIX "can't evaluate _BBN\n");
 			result = -ENODEV;
-			goto end;
+			goto out_free;
 		}
 	}
 
@@ -508,7 +509,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 * TBD: Need PCI interface for enumeration/configuration of roots.
 	 */
 
-	/* TBD: Locking */
+	mutex_lock(&acpi_pci_root_lock);
 	list_add_tail(&root->node, &acpi_pci_roots);
 
 	printk(KERN_INFO PREFIX "%s [%s] (domain %04x %pR)\n",
@@ -528,7 +529,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 			    "Bus %04x:%02x not present in PCI namespace\n",
 			    root->segment, (unsigned int)root->secondary.start);
 		result = -ENODEV;
-		goto end;
+		goto out_del_root;
 	}
 
 	/*
@@ -538,7 +539,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 */
 	result = acpi_pci_bind_root(device);
 	if (result)
-		goto end;
+		goto out_del_root;
 
 	/*
 	 * PCI Routing Table
@@ -621,11 +622,14 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
 
+	mutex_unlock(&acpi_pci_root_lock);
+
 	return 0;
 
-end:
-	if (!list_empty(&root->node))
-		list_del(&root->node);
+out_del_root:
+	list_del(&root->node);
+	mutex_unlock(&acpi_pci_root_lock);
+out_free:
 	kfree(root);
 	return result;
 }
@@ -635,11 +639,14 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
+	mutex_lock(&acpi_pci_root_lock);
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->add)
 			driver->add(root);
 
 	pci_bus_add_devices(root->bus);
+	mutex_unlock(&acpi_pci_root_lock);
+
 	return 0;
 }
 
@@ -650,6 +657,8 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
+	mutex_lock(&acpi_pci_root_lock);
+
 	/* that root bus could be removed already */
 	if (!pci_find_bus(root->segment, root->secondary.start)) {
 		dev_printk(KERN_DEBUG, &device->dev,
@@ -677,6 +686,7 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 
 out:
 	list_del(&root->node);
+	mutex_unlock(&acpi_pci_root_lock);
 	kfree(root);
 
 	return 0;
-- 
1.7.7

