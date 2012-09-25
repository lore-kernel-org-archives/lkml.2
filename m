Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2IYOdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:33:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36607 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2IYOdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:33:41 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 3/7] ACPI/pci_bind: correctly update binding relationship for PCI hotplug
Date: Tue, 25 Sep 2012 22:29:26 +0800
Message-Id: <1348583370-11006-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
References: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Currently pci_bind.c is used to maintain binding relationship between
ACPI and PCI devices. But it's broken when handling PCI hotplug events.

For the acpiphp driver, it's designed to update the binding relationship
when PCI hotplug event happens, but the implementation is broken.
For PCI device hot-adding:
enable_device()
    pci_scan_slot()
    acpiphp_bus_add()
        acpi_bus_add()
	    acpi_pci_bind()
		acpi_get_pci_dev()
		    return NULL because dev->archdata.acpi_handle is
		    still unset
		return without updating actual binding relationship
    pci_bus_add_devices()
	pci_bus_add_device()
	    device_add()
		platform_notify()
		    acpi_bind_one()
			set dev->archdata.acpi_handle

For PCI device hot-removal,
disable_device()
    pci_stop_bus_device()
    __pci_remove_bus_device()
    acpiphp_bus_trim()
	acpi_bus_remove()
	    acpi_pci_unbind()
		return without really unbinding because PCI device has
		already been destroyed

For other PCI hotplug drivers, they even don't bother to update binding
relationships. So hook into acpi_bind_one()/acpi_unbind_one() in
drivers/acpi/glue.c to update PCI<->ACPI binding relationship.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Reviewed-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/glue.c     |   14 ++++--
 drivers/acpi/internal.h |    3 ++
 drivers/acpi/pci_bind.c |  110 +++++++++++++++++++++++++++++------------------
 drivers/acpi/pci_root.c |   40 ++++-------------
 4 files changed, 91 insertions(+), 76 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 243ee85..bb232d3 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -121,7 +121,6 @@ acpi_handle acpi_get_child(acpi_handle parent, u64 address)
 			    1, do_acpi_find_child, NULL, &find, NULL);
 	return find.handle;
 }
-
 EXPORT_SYMBOL(acpi_get_child);
 
 /* Link ACPI devices with physical devices */
@@ -142,7 +141,6 @@ struct device *acpi_get_physical_device(acpi_handle handle)
 		return get_device(dev);
 	return NULL;
 }
-
 EXPORT_SYMBOL(acpi_get_physical_device);
 
 static int acpi_bind_one(struct device *dev, acpi_handle handle)
@@ -163,7 +161,12 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
 	dev->archdata.acpi_handle = handle;
 
 	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (!ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status))
+		acpi_dev = NULL;
+
+	acpi_pci_bind_notify(acpi_dev, dev, true);
+
+	if (acpi_dev) {
 		int ret;
 
 		ret = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
@@ -191,7 +194,10 @@ static int acpi_unbind_one(struct device *dev)
 					&acpi_dev)) {
 			sysfs_remove_link(&dev->kobj, "firmware_node");
 			sysfs_remove_link(&acpi_dev->dev.kobj, "physical_node");
-		}
+		} else
+			acpi_dev = NULL;
+
+		acpi_pci_bind_notify(acpi_dev, dev, false);
 
 		acpi_detach_data(dev->archdata.acpi_handle,
 				 acpi_glue_data_handler);
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index ca75b9c..16a692b 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -93,4 +93,7 @@ static inline int suspend_nvs_save(void) { return 0; }
 static inline void suspend_nvs_restore(void) {}
 #endif
 
+void acpi_pci_bind_notify(struct acpi_device *acpi_dev, struct device *dev,
+			  bool bind);
+
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 2ef0409..66c5f4a 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -35,43 +35,44 @@
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_bind");
 
-static int acpi_pci_unbind(struct acpi_device *device)
-{
-	struct pci_dev *dev;
-
-	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		goto out;
+static int acpi_pci_bind_cb(struct acpi_device *acpi_dev);
 
+static int acpi_pci_unbind(struct acpi_device *acpi_dev, struct pci_dev *dev)
+{
 	device_set_run_wake(&dev->dev, false);
-	pci_acpi_remove_pm_notifier(device);
+	pci_acpi_remove_pm_notifier(acpi_dev);
+
+	if (dev->subordinate) {
+		acpi_pci_irq_del_prt(dev->subordinate);
+		acpi_dev->ops.bind = NULL;
+		acpi_dev->ops.unbind = NULL;
+	}
 
-	if (!dev->subordinate)
-		goto out;
+	return 0;
+}
 
-	acpi_pci_irq_del_prt(dev->subordinate);
+static int acpi_pci_unbind_cb(struct acpi_device *acpi_dev)
+{
+	int rc = 0;
+	struct pci_dev *dev;
 
-	device->ops.bind = NULL;
-	device->ops.unbind = NULL;
+	dev = acpi_get_pci_dev(acpi_dev->handle);
+	if (dev) {
+		rc = acpi_pci_unbind(acpi_dev, dev);
+		pci_dev_put(dev);
+	}
 
-out:
-	pci_dev_put(dev);
-	return 0;
+	return rc;
 }
 
-static int acpi_pci_bind(struct acpi_device *device)
+static int acpi_pci_bind(struct acpi_device *acpi_dev, struct pci_dev *dev)
 {
 	acpi_status status;
-	acpi_handle handle;
+	acpi_handle tmp_hdl;
 	struct pci_bus *bus;
-	struct pci_dev *dev;
 
-	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		return 0;
-
-	pci_acpi_add_pm_notifier(device, dev);
-	if (device->wakeup.flags.run_wake)
+	pci_acpi_add_pm_notifier(acpi_dev, dev);
+	if (acpi_dev->wakeup.flags.run_wake)
 		device_set_run_wake(&dev->dev, true);
 
 	/*
@@ -83,8 +84,8 @@ static int acpi_pci_bind(struct acpi_device *device)
 				  "Device %04x:%02x:%02x.%d is a PCI bridge\n",
 				  pci_domain_nr(dev->bus), dev->bus->number,
 				  PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn)));
-		device->ops.bind = acpi_pci_bind;
-		device->ops.unbind = acpi_pci_unbind;
+		acpi_dev->ops.bind = acpi_pci_bind_cb;
+		acpi_dev->ops.unbind = acpi_pci_unbind_cb;
 	}
 
 	/*
@@ -95,26 +96,53 @@ static int acpi_pci_bind(struct acpi_device *device)
 	 *
 	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
 	 */
-	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
-	if (ACPI_FAILURE(status))
-		goto out;
+	status = acpi_get_handle(acpi_dev->handle, METHOD_NAME__PRT, &tmp_hdl);
+	if (ACPI_SUCCESS(status)) {
+		if (dev->subordinate)
+			bus = dev->subordinate;
+		else
+			bus = dev->bus;
+		acpi_pci_irq_add_prt(acpi_dev->handle, bus);
+	}
 
-	if (dev->subordinate)
-		bus = dev->subordinate;
-	else
-		bus = dev->bus;
+	return 0;
+}
 
-	acpi_pci_irq_add_prt(device->handle, bus);
+static int acpi_pci_bind_cb(struct acpi_device *acpi_dev)
+{
+	int rc = 0;
+	struct pci_dev *dev;
 
-out:
-	pci_dev_put(dev);
-	return 0;
+	dev = acpi_get_pci_dev(acpi_dev->handle);
+	if (dev) {
+		rc = acpi_pci_bind(acpi_dev, dev);
+		pci_dev_put(dev);
+	}
+
+	return rc;
 }
 
-int acpi_pci_bind_root(struct acpi_device *device)
+int acpi_pci_bind_root(struct acpi_device *acpi_dev)
 {
-	device->ops.bind = acpi_pci_bind;
-	device->ops.unbind = acpi_pci_unbind;
+	acpi_dev->ops.bind = acpi_pci_bind_cb;
+	acpi_dev->ops.unbind = acpi_pci_unbind_cb;
 
 	return 0;
 }
+
+void acpi_pci_bind_notify(struct acpi_device *acpi_dev, struct device *dev,
+			  bool bind)
+{
+	if (!dev_is_pci(dev))
+		return;
+
+	if (acpi_dev && acpi_dev->parent) {
+		if (bind) {
+			if (acpi_dev->parent->ops.bind)
+				acpi_pci_bind(acpi_dev, to_pci_dev(dev));
+		} else {
+			if (acpi_dev->parent->ops.unbind)
+				acpi_pci_unbind(acpi_dev, to_pci_dev(dev));
+		}
+	}
+}
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 72a2c98..7509034 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -195,21 +195,6 @@ static acpi_status try_get_root_bridge_busnr(acpi_handle handle,
 	return AE_OK;
 }
 
-static void acpi_pci_bridge_scan(struct acpi_device *device)
-{
-	int status;
-	struct acpi_device *child = NULL;
-
-	if (device->flags.bus_address)
-		if (device->parent && device->parent->ops.bind) {
-			status = device->parent->ops.bind(device);
-			if (!status) {
-				list_for_each_entry(child, &device->children, node)
-					acpi_pci_bridge_scan(child);
-			}
-		}
-}
-
 static u8 pci_osc_uuid_str[] = "33DB4D5B-1FF7-401C-9657-7441C03DD766";
 
 static acpi_status acpi_pci_run_osc(acpi_handle handle,
@@ -456,7 +441,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	int result;
 	struct acpi_pci_root *root;
 	acpi_handle handle;
-	struct acpi_device *child;
 	u32 flags, base_flags;
 
 	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
@@ -521,6 +505,15 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	/* TBD: Locking */
 	list_add_tail(&root->node, &acpi_pci_roots);
 
+	/*
+	 * Attach ACPI-PCI Context
+	 * -----------------------
+	 * Thus binding the ACPI and PCI devices.
+	 */
+	result = acpi_pci_bind_root(device);
+	if (result)
+		goto end;
+
 	printk(KERN_INFO PREFIX "%s [%s] (domain %04x %pR)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       root->segment, &root->secondary);
@@ -542,15 +535,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	}
 
 	/*
-	 * Attach ACPI-PCI Context
-	 * -----------------------
-	 * Thus binding the ACPI and PCI devices.
-	 */
-	result = acpi_pci_bind_root(device);
-	if (result)
-		goto end;
-
-	/*
 	 * PCI Routing Table
 	 * -----------------
 	 * Evaluate and parse _PRT, if exists.
@@ -559,12 +543,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (ACPI_SUCCESS(status))
 		result = acpi_pci_irq_add_prt(device->handle, root->bus);
 
-	/*
-	 * Scan and bind all _ADR-Based Devices
-	 */
-	list_for_each_entry(child, &device->children, node)
-		acpi_pci_bridge_scan(child);
-
 	/* Indicate support for various _OSC capabilities. */
 	if (pci_ext_cfg_avail(root->bus->self))
 		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
-- 
1.7.9.5

