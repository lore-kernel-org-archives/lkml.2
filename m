Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3AHQwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:52:55 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:64025 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3AHQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:52:51 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 5/6] PCI/acpiphp: serialize access to the bridge_list list
Date: Wed,  9 Jan 2013 00:52:24 +0800
Message-Id: <1357663945-16054-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
References: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serialize access to the bridge_list in the acpiphp driver.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 16fe692..884cbf4 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -53,6 +53,7 @@
 #include "../pci.h"
 #include "acpiphp.h"
 
+static DEFINE_MUTEX(bridge_mutex);
 static LIST_HEAD(bridge_list);
 
 #define MY_NAME "acpiphp_glue"
@@ -519,8 +520,10 @@ static int add_bridge(struct acpi_pci_root *root)
 	}
 
 	/* search P2P bridges under this host bridge */
+	mutex_lock(&bridge_mutex);
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     find_p2p_bridge, NULL, NULL, NULL);
+	mutex_unlock(&bridge_mutex);
 
 	if (ACPI_FAILURE(status))
 		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
@@ -618,6 +621,8 @@ static void remove_bridge(struct acpi_pci_root *root)
 	struct acpiphp_bridge *bridge;
 	acpi_handle handle = root->device->handle;
 
+	mutex_lock(&bridge_mutex);
+
 	/* cleanup p2p bridges under this host bridge
 	   in a depth-first manner */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
@@ -636,6 +641,8 @@ static void remove_bridge(struct acpi_pci_root *root)
 	else
 		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					   handle_hotplug_event_bridge);
+
+	mutex_unlock(&bridge_mutex);
 }
 
 static int power_on_slot(struct acpiphp_slot *slot)
@@ -1438,11 +1445,13 @@ static void acpiphp_hp_notify_add(struct pci_dev *dev)
 	if (!dev->subordinate || !handle)
 		return;
 
+	mutex_lock(&bridge_mutex);
 	/* check if this bridge has ejectable slots */
 	if (detect_ejectable_slots(handle) > 0) {
 		dbg("found PCI-to-PCI bridge at PCI %s\n", pci_name(dev));
 		add_p2p_bridge(handle);
 	}
+	mutex_unlock(&bridge_mutex);
 }
 
 static void acpiphp_hp_notify_del(struct pci_dev *dev)
@@ -1453,11 +1462,13 @@ static void acpiphp_hp_notify_del(struct pci_dev *dev)
 	if (!bus)
 		return;
 
+	mutex_lock(&bridge_mutex);
 	list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
 		if (bridge->pci_bus == bus) {
 			cleanup_bridge(bridge);
 			break;
 		}
+	mutex_unlock(&bridge_mutex);
 }
 
 static int acpi_pci_hp_notify_fn(struct notifier_block *nb,
-- 
1.7.9.5

