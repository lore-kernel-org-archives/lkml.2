Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2FDFS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:18:59 -0400
Received: from szxga04-in.huawei.com ([58.251.152.67]:52176 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756262Ab2FDFSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:18:48 -0400
Date: Mon, 04 Jun 2012 13:17:01 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: [RFC PATCH v1 5/6] PCI, ACPI: update ACPI hotplug slot information
 when PCI hotplug event happens
In-reply-to: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
X-Originating-IP: [10.107.208.49]
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Chiang <achiang@hp.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1338787022-400-5-git-send-email-jiang.liu@huawei.com>
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

Currently the acpiphp driver fails to update hotplug slot information under
several conditions, such as:
1) The bridge device is removed through /sys/bus/pci/devices/.../remove
2) The bridge device is added/removed by PCI hotplug driver other than the
   acpiphp driver itself. For example, if an IO expansion box with ACPI
   hotplug slots available is hot-added by the pciehp driver, all ACPI
   hotplug slots won't be discovered by the acpiphp driver.

So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
update ACPI hotplug slot information when PCI hotplug event happens.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   64 ++++++++++++++++++++++++++++++++++--
 1 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 73af337..44d055c 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,6 +61,7 @@ static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
+static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle);
 
 /* callback routine to check for the existence of a pci dock device */
 static acpi_status
@@ -377,7 +378,7 @@ static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
 
 
 /* allocate and initialize host bridge data structure */
-static void add_host_bridge(acpi_handle *handle)
+static void add_host_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
 	struct acpi_pci_root *root = acpi_pci_find_root(handle);
@@ -396,12 +397,14 @@ static void add_host_bridge(acpi_handle *handle)
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
@@ -1419,6 +1422,58 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
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
@@ -1439,6 +1494,8 @@ int __init acpiphp_glue_init(void)
 	else
 		acpi_pci_register_driver(&acpi_pci_hp_driver);
 
+	bus_register_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
+
 	return 0;
 }
 
@@ -1450,6 +1507,7 @@ int __init acpiphp_glue_init(void)
  */
 void  acpiphp_glue_exit(void)
 {
+	bus_unregister_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
 	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
 }
 
-- 
1.7.1


