Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2FDFUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:20:34 -0400
Received: from szxga03-in.huawei.com ([58.251.152.66]:35274 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2FDFUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:20:32 -0400
Date: Mon, 04 Jun 2012 13:16:59 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: [RFC PATCH v1 3/6] PCI, ACPI: correctly update binding info when PCI
 hotplug event happens
In-reply-to: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
X-Originating-IP: [10.107.208.49]
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Len Brown <lenb@kernel.org>, Alexander Chiang <achiang@hp.com>,
        Rui Zhang <rui.zhang@intel.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1338787022-400-3-git-send-email-jiang.liu@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.msysgit.0
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
References: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

Currently acpi/pci_bind.c is used to maintain binding relationship
among ACPI and PCI devices. But it's broken when dealing PCI hotplug
events.

For the acpiphp driver, it's designed to update the binding relationship
when PCI hotplug event happensr, but the implementation is broken.
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

For other PCI hotplug drivers, such as pciehp etc, they even don't
bother to update binding relationship. So hook into acpi_bind_one()
and acpi_unbind_one() in drivers/acpi/glue.c to update PCI/ACPI
binding relationship.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/acpi/glue.c     |    4 ++
 drivers/acpi/internal.h |    2 +
 drivers/acpi/pci_bind.c |  103 ++++++++++++++++++++++++++++++-----------------
 drivers/acpi/pci_root.c |   22 ----------
 4 files changed, 72 insertions(+), 59 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 29a4a5c..1a07c3c 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -160,6 +160,8 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
 	}
 	dev->archdata.acpi_handle = handle;
 
+	acpi_pci_bind_notify(dev->archdata.acpi_handle, dev, true);
+
 	status = acpi_bus_get_device(handle, &acpi_dev);
 	if (!ACPI_FAILURE(status)) {
 		int ret;
@@ -191,6 +193,8 @@ static int acpi_unbind_one(struct device *dev)
 			sysfs_remove_link(&acpi_dev->dev.kobj, "physical_node");
 		}
 
+		acpi_pci_bind_notify(dev->archdata.acpi_handle, dev, false);
+
 		acpi_detach_data(dev->archdata.acpi_handle,
 				 acpi_glue_data_handler);
 		dev->archdata.acpi_handle = NULL;
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index ca75b9c..5396b20 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -93,4 +93,6 @@ static inline int suspend_nvs_save(void) { return 0; }
 static inline void suspend_nvs_restore(void) {}
 #endif
 
+void acpi_pci_bind_notify(acpi_handle handle, struct device *dev, bool bind);
+
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 2ef0409..208e6cd 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -35,54 +35,56 @@
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_bind");
 
-static int acpi_pci_unbind(struct acpi_device *device)
-{
-	struct pci_dev *dev;
+static int acpi_pci_bind(struct acpi_device *device);
 
-	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		goto out;
-
-	device_set_run_wake(&dev->dev, false);
+static int __acpi_pci_unbind(struct acpi_device *device, struct pci_dev *pdev)
+{
+	device_set_run_wake(&pdev->dev, false);
 	pci_acpi_remove_pm_notifier(device);
 
-	if (!dev->subordinate)
-		goto out;
+	if (pdev->subordinate) {
+		acpi_pci_irq_del_prt(pdev->subordinate);
+		device->ops.bind = NULL;
+		device->ops.unbind = NULL;
+	}
 
-	acpi_pci_irq_del_prt(dev->subordinate);
+	return 0;
+}
 
-	device->ops.bind = NULL;
-	device->ops.unbind = NULL;
+static int acpi_pci_unbind(struct acpi_device *device)
+{
+	int rc = 0;
+	struct pci_dev *pdev;
 
-out:
-	pci_dev_put(dev);
-	return 0;
+	pdev = acpi_get_pci_dev(device->handle);
+	if (pdev) {
+		rc = __acpi_pci_unbind(device, pdev);
+		pci_dev_put(pdev);
+	}
+
+	return rc;
 }
 
-static int acpi_pci_bind(struct acpi_device *device)
+static int __acpi_pci_bind(struct acpi_device *device, struct pci_dev *pdev)
 {
 	acpi_status status;
 	acpi_handle handle;
 	struct pci_bus *bus;
-	struct pci_dev *dev;
 
-	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		return 0;
-
-	pci_acpi_add_pm_notifier(device, dev);
+	pci_acpi_add_pm_notifier(device, pdev);
 	if (device->wakeup.flags.run_wake)
-		device_set_run_wake(&dev->dev, true);
+		device_set_run_wake(&pdev->dev, true);
 
 	/*
 	 * Install the 'bind' function to facilitate callbacks for
 	 * children of the P2P bridge.
 	 */
-	if (dev->subordinate) {
+	if (pdev->subordinate) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Device %04x:%02x:%02x.%d is a PCI bridge\n",
-				  pci_domain_nr(dev->bus), dev->bus->number,
-				  PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn)));
+				  pci_domain_nr(pdev->bus), pdev->bus->number,
+				  PCI_SLOT(pdev->devfn),
+				  PCI_FUNC(pdev->devfn)));
 		device->ops.bind = acpi_pci_bind;
 		device->ops.unbind = acpi_pci_unbind;
 	}
@@ -96,19 +98,29 @@ static int acpi_pci_bind(struct acpi_device *device)
 	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
 	 */
 	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
-	if (ACPI_FAILURE(status))
-		goto out;
+	if (ACPI_SUCCESS(status)) {
+		if (pdev->subordinate)
+			bus = pdev->subordinate;
+		else
+			bus = pdev->bus;
+		acpi_pci_irq_add_prt(device->handle, bus);
+	}
+
+	return 0;
+}
 
-	if (dev->subordinate)
-		bus = dev->subordinate;
-	else
-		bus = dev->bus;
+static int acpi_pci_bind(struct acpi_device *device)
+{
+	int rc = 0;
+	struct pci_dev *pdev;
 
-	acpi_pci_irq_add_prt(device->handle, bus);
+	pdev = acpi_get_pci_dev(device->handle);
+	if (pdev) {
+		rc = __acpi_pci_bind(device, pdev);
+		pci_dev_put(pdev);
+	}
 
-out:
-	pci_dev_put(dev);
-	return 0;
+	return rc;
 }
 
 int acpi_pci_bind_root(struct acpi_device *device)
@@ -118,3 +130,20 @@ int acpi_pci_bind_root(struct acpi_device *device)
 
 	return 0;
 }
+
+void acpi_pci_bind_notify(acpi_handle handle, struct device *dev, bool bind)
+{
+	struct acpi_device *acpi_dev;
+
+	if (!dev_is_pci(dev))
+		return;
+	if (acpi_bus_get_device(handle, &acpi_dev))
+		return;
+	if (!acpi_dev || !acpi_dev->parent)
+		return;
+
+	if (bind && acpi_dev->parent->ops.bind)
+		__acpi_pci_bind(acpi_dev, to_pci_dev(dev));
+	else if (acpi_dev->parent->ops.unbind)
+		__acpi_pci_unbind(acpi_dev, to_pci_dev(dev));
+}
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7aff631..cd2f7af 100644
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
@@ -557,12 +541,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
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
1.7.1


