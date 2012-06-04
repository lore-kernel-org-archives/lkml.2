Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2FDFUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:20:41 -0400
Received: from szxga03-in.huawei.com ([58.251.152.66]:35274 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2FDFUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:20:38 -0400
Date: Mon, 04 Jun 2012 13:17:00 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: [RFC PATCH v1 4/6] PCI, ACPI: update PCI slot information when PCI
 hotplug event happens
In-reply-to: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
X-Originating-IP: [10.107.208.49]
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alexander Chiang <achiang@hp.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1338787022-400-4-git-send-email-jiang.liu@huawei.com>
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

Currently the pci_slot driver doesn't update PCI slot information
when PCI device hotplug event happens, which may cause memory leak
and returning stale information to user.

So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
update PCI slot information when PCI hotplug event happens.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/acpi/pci_slot.c |   84 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index e50e31a..22cc00e 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -32,6 +32,7 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <linux/pci-acpi.h>
 #include <linux/dmi.h>
 
 static bool debug;
@@ -123,12 +124,7 @@ struct callback_args {
 /*
  * register_slot
  *
- * Called once for each SxFy object in the namespace. Don't worry about
- * calling pci_create_slot multiple times for the same pci_bus:device,
- * since each subsequent call simply bumps the refcount on the pci_slot.
- *
- * The number of calls to pci_destroy_slot from unregister_slot is
- * symmetrical.
+ * Called once for each SxFy object in the namespace.
  */
 static acpi_status
 register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
@@ -145,6 +141,18 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (device < 0)
 		return AE_OK;
 
+	/* Avoid duplicated records for the same slot */
+	mutex_lock(&slot_list_lock);
+	list_for_each_entry(slot, &slot_list, list) {
+		pci_slot = slot->pci_slot;
+		if (pci_slot && pci_slot->bus == pci_bus &&
+		    pci_slot->number == device) {
+			mutex_unlock(&slot_list_lock);
+			return AE_OK;
+		}
+	}
+	mutex_unlock(&slot_list_lock);
+
 	slot = kmalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot) {
 		err("%s: cannot allocate memory\n", __func__);
@@ -354,17 +362,81 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
 	{}
 };
 
+static void acpi_pci_slot_notify_add(struct pci_dev *dev)
+{
+	acpi_handle handle;
+	struct callback_args context;
+
+	if (!dev->subordinate)
+		return;
+
+	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	context.root_handle = acpi_find_root_bridge_handle(dev);
+	if (handle && context.root_handle) {
+		context.pci_bus = dev->subordinate;
+		context.user_function = register_slot;
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				    register_slot, NULL, &context, NULL);
+	}
+}
+
+static void acpi_pci_slot_notify_del(struct pci_dev *dev)
+{
+	struct acpi_pci_slot *slot, *tmp;
+	struct pci_bus *bus = dev->subordinate;
+
+	if (!bus)
+		return;
+
+	mutex_lock(&slot_list_lock);
+	list_for_each_entry_safe(slot, tmp, &slot_list, list) {
+		if (slot->pci_slot && slot->pci_slot->bus == bus) {
+			list_del(&slot->list);
+			pci_destroy_slot(slot->pci_slot);
+			put_device(&bus->dev);
+			kfree(slot);
+		}
+	}
+	mutex_unlock(&slot_list_lock);
+}
+
+static int acpi_pci_slot_notify_fn(struct notifier_block *nb,
+				   unsigned long event, void *data)
+{
+	struct device *dev = data;
+
+	switch (event) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		acpi_pci_slot_notify_add(to_pci_dev(dev));
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		acpi_pci_slot_notify_del(to_pci_dev(dev));
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_pci_slot_notifier = {
+	.notifier_call = &acpi_pci_slot_notify_fn,
+};
+
 static int __init
 acpi_pci_slot_init(void)
 {
 	dmi_check_system(acpi_pci_slot_dmi_table);
 	acpi_pci_register_driver(&acpi_pci_slot_driver);
+	bus_register_notifier(&pci_bus_type, &acpi_pci_slot_notifier);
+
 	return 0;
 }
 
 static void __exit
 acpi_pci_slot_exit(void)
 {
+	bus_unregister_notifier(&pci_bus_type, &acpi_pci_slot_notifier);
 	acpi_pci_unregister_driver(&acpi_pci_slot_driver);
 }
 
-- 
1.7.1


