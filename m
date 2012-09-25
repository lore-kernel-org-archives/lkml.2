Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2IYOeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:34:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2IYOeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:34:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 7/7] PCI/acpiphp: serialize access to the bridge_list list
Date: Tue, 25 Sep 2012 22:29:30 +0800
Message-Id: <1348583370-11006-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
References: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Serialize access to the bridge_list in the acpiphp driver.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 1fb0eb7..348afd7 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -53,6 +53,7 @@
 #include "../pci.h"
 #include "acpiphp.h"
 
+static DEFINE_MUTEX(bridge_mutex);
 static LIST_HEAD(bridge_list);
 
 #define MY_NAME "acpiphp_glue"
@@ -497,8 +498,10 @@ static int add_bridge(acpi_handle handle)
 	}
 
 	/* search P2P bridges under this host bridge */
+	mutex_lock(&bridge_mutex);
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     find_p2p_bridge, NULL, NULL, NULL);
+	mutex_unlock(&bridge_mutex);
 
 	if (ACPI_FAILURE(status))
 		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
@@ -595,6 +598,8 @@ static void remove_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
 
+	mutex_lock(&bridge_mutex);
+
 	/* cleanup p2p bridges under this host bridge
 	   in a depth-first manner */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
@@ -613,6 +618,8 @@ static void remove_bridge(acpi_handle handle)
 	else
 		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					   handle_hotplug_event_bridge);
+
+	mutex_unlock(&bridge_mutex);
 }
 
 static int power_on_slot(struct acpiphp_slot *slot)
@@ -1415,11 +1422,13 @@ static void acpiphp_hp_notify_add(struct pci_dev *dev)
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
@@ -1430,11 +1439,13 @@ static void acpiphp_hp_notify_del(struct pci_dev *dev)
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

