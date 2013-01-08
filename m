Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3AHQwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:52:50 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33602 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3AHQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:52:47 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 3/6] ACPI/pci_slot: update PCI slot information when PCI hotplug event happens
Date: Wed,  9 Jan 2013 00:52:22 +0800
Message-Id: <1357663945-16054-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
References: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the pci_slot driver doesn't update PCI slot information
when PCI device hotplug event happens, which may cause memory leak
and returning stale information to user.

So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
update PCI slot information when PCI hotplug event happens.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/acpi/pci_slot.c |   86 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index d22585f..e04ea8e 100644
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
@@ -145,6 +141,15 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (device < 0)
 		return AE_OK;
 
+	/* Avoid duplicated records for the same slot */
+	list_for_each_entry(slot, &slot_list, list) {
+		pci_slot = slot->pci_slot;
+		if (pci_slot && pci_slot->bus == pci_bus &&
+		    pci_slot->number == device) {
+			return AE_OK;
+		}
+	}
+
 	slot = kmalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot) {
 		err("%s: cannot allocate memory\n", __func__);
@@ -162,9 +167,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	slot->root_handle = parent_context->root_handle;
 	slot->pci_slot = pci_slot;
 	INIT_LIST_HEAD(&slot->list);
-	mutex_lock(&slot_list_lock);
 	list_add(&slot->list, &slot_list);
-	mutex_unlock(&slot_list_lock);
 
 	get_device(&pci_bus->dev);
 
@@ -274,7 +277,9 @@ acpi_pci_slot_add(struct acpi_pci_root *root)
 {
 	acpi_status status;
 
+	mutex_lock(&slot_list_lock);
 	status = walk_root_bridge(root, register_slot);
+	mutex_unlock(&slot_list_lock);
 	if (ACPI_FAILURE(status))
 		err("%s: register_slot failure - %d\n", __func__, status);
 
@@ -330,17 +335,82 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
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
+	mutex_lock(&slot_list_lock);
+	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	context.root_handle = acpi_find_root_bridge_handle(dev);
+	if (handle && context.root_handle) {
+		context.pci_bus = dev->subordinate;
+		context.user_function = register_slot;
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				    register_slot, NULL, &context, NULL);
+	}
+	mutex_unlock(&slot_list_lock);
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
+	list_for_each_entry_safe(slot, tmp, &slot_list, list)
+		if (slot->pci_slot && slot->pci_slot->bus == bus) {
+			list_del(&slot->list);
+			pci_destroy_slot(slot->pci_slot);
+			put_device(&bus->dev);
+			kfree(slot);
+		}
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
1.7.9.5

