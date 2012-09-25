Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2IYOeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:34:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2IYOeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:34:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 6/7] PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug happens
Date: Tue, 25 Sep 2012 22:29:29 +0800
Message-Id: <1348583370-11006-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
References: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Currently the acpiphp driver fails to update hotplug slot information under
several conditions, such as:
1) The bridge device is removed through /sys/bus/pci/devices/.../remove
2) The bridge device is added/removed by PCI hotplug driver other than the
   acpiphp driver itself. For example, if an IO expansion box with ACPI
   hotplug slots available is hot-added by the pciehp driver, all ACPI
   hotplug slots won't be discovered by the acpiphp driver.

So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
update ACPI hotplug slot information when PCI hotplug event happens.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   64 ++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 7be4ca5..1fb0eb7 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,6 +61,7 @@ static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
+static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle);
 
 /* callback routine to check for the existence of a pci dock device */
 static acpi_status
@@ -382,7 +383,7 @@ static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
 
 
 /* allocate and initialize host bridge data structure */
-static void add_host_bridge(acpi_handle *handle)
+static void add_host_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
 	struct acpi_pci_root *root = acpi_pci_find_root(handle);
@@ -399,12 +400,14 @@ static void add_host_bridge(acpi_handle *handle)
 	init_bridge_misc(bridge);
 }
 
-
 /* allocate and initialize PCI-to-PCI bridge data structure */
-static void add_p2p_bridge(acpi_handle *handle)
+static void add_p2p_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
 
+	if (acpiphp_handle_to_bridge(handle))
+		return;
+
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
 	if (bridge == NULL) {
 		err("out of memory\n");
@@ -1405,6 +1408,58 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK ;
 }
 
+static void acpiphp_hp_notify_add(struct pci_dev *dev)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+
+	if (!dev->subordinate || !handle)
+		return;
+
+	/* check if this bridge has ejectable slots */
+	if (detect_ejectable_slots(handle) > 0) {
+		dbg("found PCI-to-PCI bridge at PCI %s\n", pci_name(dev));
+		add_p2p_bridge(handle);
+	}
+}
+
+static void acpiphp_hp_notify_del(struct pci_dev *dev)
+{
+	struct acpiphp_bridge *bridge, *tmp;
+	struct pci_bus *bus = dev->subordinate;
+
+	if (!bus)
+		return;
+
+	list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
+		if (bridge->pci_bus == bus) {
+			cleanup_bridge(bridge);
+			break;
+		}
+}
+
+static int acpi_pci_hp_notify_fn(struct notifier_block *nb,
+				 unsigned long event, void *data)
+{
+	struct device *dev = data;
+
+	switch (event) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		acpiphp_hp_notify_add(to_pci_dev(dev));
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		acpiphp_hp_notify_del(to_pci_dev(dev));
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_pci_hp_notifier = {
+	.notifier_call = &acpi_pci_hp_notify_fn,
+};
+
 static struct acpi_pci_driver acpi_pci_hp_driver = {
 	.add =		add_bridge,
 	.remove =	remove_bridge,
@@ -1425,6 +1480,8 @@ int __init acpiphp_glue_init(void)
 	else
 		acpi_pci_register_driver(&acpi_pci_hp_driver);
 
+	bus_register_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
+
 	return 0;
 }
 
@@ -1436,6 +1493,7 @@ int __init acpiphp_glue_init(void)
  */
 void  acpiphp_glue_exit(void)
 {
+	bus_unregister_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
 	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
 }
 
-- 
1.7.9.5

