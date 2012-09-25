Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2IYOdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:33:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2IYOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:33:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 4/7] ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
Date: Tue, 25 Sep 2012 22:29:27 +0800
Message-Id: <1348583370-11006-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
References: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Now ACPI devices are created before/destroyed after corresponding PCI
devices, and acpi_platform_notify/acpi_platform_notify_remove will
update PCI<->ACPI binding relationship when creating/destroying PCI
devices, there's no need to invoke bind/unbind callbacks from ACPI
device probe/destroy routines anymore. So remove bind/unbind callbacks
from acpi_device_ops.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Reviewed-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_bind.c     |   95 ++++++++++---------------------------------
 drivers/acpi/pci_root.c     |    9 ----
 drivers/acpi/scan.c         |   21 +---------
 include/acpi/acpi_bus.h     |    4 --
 include/acpi/acpi_drivers.h |    1 -
 5 files changed, 23 insertions(+), 107 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 66c5f4a..aac7f9a 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -35,58 +35,33 @@
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_bind");
 
-static int acpi_pci_bind_cb(struct acpi_device *acpi_dev);
-
 static int acpi_pci_unbind(struct acpi_device *acpi_dev, struct pci_dev *dev)
 {
-	device_set_run_wake(&dev->dev, false);
-	pci_acpi_remove_pm_notifier(acpi_dev);
+	if (acpi_dev) {
+		device_set_run_wake(&dev->dev, false);
+		pci_acpi_remove_pm_notifier(acpi_dev);
+	}
 
-	if (dev->subordinate) {
+	if (dev->subordinate)
 		acpi_pci_irq_del_prt(dev->subordinate);
-		acpi_dev->ops.bind = NULL;
-		acpi_dev->ops.unbind = NULL;
-	}
 
 	return 0;
 }
 
-static int acpi_pci_unbind_cb(struct acpi_device *acpi_dev)
-{
-	int rc = 0;
-	struct pci_dev *dev;
-
-	dev = acpi_get_pci_dev(acpi_dev->handle);
-	if (dev) {
-		rc = acpi_pci_unbind(acpi_dev, dev);
-		pci_dev_put(dev);
-	}
-
-	return rc;
-}
-
 static int acpi_pci_bind(struct acpi_device *acpi_dev, struct pci_dev *dev)
 {
 	acpi_status status;
-	acpi_handle tmp_hdl;
 	struct pci_bus *bus;
+	acpi_handle tmp_hdl;
+	acpi_handle handle;
 
-	pci_acpi_add_pm_notifier(acpi_dev, dev);
-	if (acpi_dev->wakeup.flags.run_wake)
-		device_set_run_wake(&dev->dev, true);
-
-	/*
-	 * Install the 'bind' function to facilitate callbacks for
-	 * children of the P2P bridge.
-	 */
-	if (dev->subordinate) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Device %04x:%02x:%02x.%d is a PCI bridge\n",
-				  pci_domain_nr(dev->bus), dev->bus->number,
-				  PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn)));
-		acpi_dev->ops.bind = acpi_pci_bind_cb;
-		acpi_dev->ops.unbind = acpi_pci_unbind_cb;
-	}
+	if (acpi_dev) {
+		pci_acpi_add_pm_notifier(acpi_dev, dev);
+		if (acpi_dev->wakeup.flags.run_wake)
+			device_set_run_wake(&dev->dev, true);
+		handle = acpi_dev->handle;
+	} else
+		handle = DEVICE_ACPI_HANDLE(&dev->dev);
 
 	/*
 	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
@@ -96,53 +71,25 @@ static int acpi_pci_bind(struct acpi_device *acpi_dev, struct pci_dev *dev)
 	 *
 	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
 	 */
-	status = acpi_get_handle(acpi_dev->handle, METHOD_NAME__PRT, &tmp_hdl);
+	status = acpi_get_handle(handle, METHOD_NAME__PRT, &tmp_hdl);
 	if (ACPI_SUCCESS(status)) {
 		if (dev->subordinate)
 			bus = dev->subordinate;
 		else
 			bus = dev->bus;
-		acpi_pci_irq_add_prt(acpi_dev->handle, bus);
-	}
-
-	return 0;
-}
-
-static int acpi_pci_bind_cb(struct acpi_device *acpi_dev)
-{
-	int rc = 0;
-	struct pci_dev *dev;
-
-	dev = acpi_get_pci_dev(acpi_dev->handle);
-	if (dev) {
-		rc = acpi_pci_bind(acpi_dev, dev);
-		pci_dev_put(dev);
+		acpi_pci_irq_add_prt(handle, bus);
 	}
 
-	return rc;
-}
-
-int acpi_pci_bind_root(struct acpi_device *acpi_dev)
-{
-	acpi_dev->ops.bind = acpi_pci_bind_cb;
-	acpi_dev->ops.unbind = acpi_pci_unbind_cb;
-
 	return 0;
 }
 
 void acpi_pci_bind_notify(struct acpi_device *acpi_dev, struct device *dev,
 			  bool bind)
 {
-	if (!dev_is_pci(dev))
-		return;
-
-	if (acpi_dev && acpi_dev->parent) {
-		if (bind) {
-			if (acpi_dev->parent->ops.bind)
-				acpi_pci_bind(acpi_dev, to_pci_dev(dev));
-		} else {
-			if (acpi_dev->parent->ops.unbind)
-				acpi_pci_unbind(acpi_dev, to_pci_dev(dev));
-		}
+	if (dev_is_pci(dev)) {
+		if (bind)
+			acpi_pci_bind(acpi_dev, to_pci_dev(dev));
+		else
+			acpi_pci_unbind(acpi_dev, to_pci_dev(dev));
 	}
 }
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7509034..25d8ad4 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -505,15 +505,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	/* TBD: Locking */
 	list_add_tail(&root->node, &acpi_pci_roots);
 
-	/*
-	 * Attach ACPI-PCI Context
-	 * -----------------------
-	 * Thus binding the ACPI and PCI devices.
-	 */
-	result = acpi_pci_bind_root(device);
-	if (result)
-		goto end;
-
 	printk(KERN_INFO PREFIX "%s [%s] (domain %04x %pR)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       root->segment, &root->secondary);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d1ecca2..f31cb2f 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1232,17 +1232,8 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
 	device_release_driver(&dev->dev);
 
-	if (!rmdevice)
-		return 0;
-
-	/*
-	 * unbind _ADR-Based Devices when hot removal
-	 */
-	if (dev->flags.bus_address) {
-		if ((dev->parent) && (dev->parent->ops.unbind))
-			dev->parent->ops.unbind(dev);
-	}
-	acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
+	if (rmdevice)
+		acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
 
 	return 0;
 }
@@ -1319,14 +1310,6 @@ static int acpi_add_single_object(struct acpi_device **child,
 
 	result = acpi_device_register(device);
 
-	/*
-	 * Bind _ADR-Based Devices when hot add
-	 */
-	if (device->flags.bus_address) {
-		if (device->parent && device->parent->ops.bind)
-			device->parent->ops.bind(device);
-	}
-
 end:
 	if (!result) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..ef5babf 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -120,8 +120,6 @@ struct acpi_device;
 typedef int (*acpi_op_add) (struct acpi_device * device);
 typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
 typedef int (*acpi_op_start) (struct acpi_device * device);
-typedef int (*acpi_op_bind) (struct acpi_device * device);
-typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
 
 struct acpi_bus_ops {
@@ -133,8 +131,6 @@ struct acpi_device_ops {
 	acpi_op_add add;
 	acpi_op_remove remove;
 	acpi_op_start start;
-	acpi_op_bind bind;
-	acpi_op_unbind unbind;
 	acpi_op_notify notify;
 };
 
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index bb145e4..fb1c0d5 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -100,7 +100,6 @@ void acpi_pci_irq_del_prt(struct pci_bus *bus);
 struct pci_bus;
 
 struct pci_dev *acpi_get_pci_dev(acpi_handle);
-int acpi_pci_bind_root(struct acpi_device *device);
 
 /* Arch-defined function to add a bus to the system */
 
-- 
1.7.9.5

