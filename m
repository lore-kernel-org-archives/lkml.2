Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2D0PWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:22:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2D0PV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:58 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 13/19] PCI: trivial code clean up in cpci_hotplug_core.c
Date: Fri, 27 Apr 2012 23:16:54 +0800
Message-Id: <1335539820-11232-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

1) get rid of redundant lock operations in cpcihp_core.
2) return suitable error code instead of -1.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/cpci_hotplug_core.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index 3fadf2f..7898023 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -304,7 +304,7 @@ cpci_hp_unregister_bus(struct pci_bus *bus)
 	down_write(&list_rwsem);
 	if (!slots) {
 		up_write(&list_rwsem);
-		return -1;
+		return -ENODEV;
 	}
 	list_for_each_entry_safe(slot, tmp, &slot_list, slot_list) {
 		if (slot->bus == bus) {
@@ -357,11 +357,6 @@ init_slots(int clear_ins)
 	struct pci_dev* dev;
 
 	dbg("%s - enter", __func__);
-	down_read(&list_rwsem);
-	if (!slots) {
-		up_read(&list_rwsem);
-		return -1;
-	}
 	list_for_each_entry(slot, &slot_list, slot_list) {
 		dbg("%s - looking at slot %s", __func__, slot_name(slot));
 		if (clear_ins && cpci_check_and_clear_ins(slot))
@@ -376,7 +371,6 @@ init_slots(int clear_ins)
 			slot->dev = dev;
 		}
 	}
-	up_read(&list_rwsem);
 	dbg("%s - exit", __func__);
 	return 0;
 }
@@ -585,7 +579,7 @@ cpci_hp_register_controller(struct cpci_hp_controller *new_controller)
 	int status = 0;
 
 	if (controller)
-		return -1;
+		return -EBUSY;
 	if (!(new_controller && new_controller->ops))
 		return -EINVAL;
 	if (new_controller->irq) {
@@ -620,15 +614,11 @@ cleanup_slots(void)
 	 * and free up all memory that we had allocated.
 	 */
 	down_write(&list_rwsem);
-	if (!slots)
-		goto cleanup_null;
 	list_for_each_entry_safe(slot, tmp, &slot_list, slot_list) {
 		list_del(&slot->slot_list);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
-cleanup_null:
 	up_write(&list_rwsem);
-	return;
 }
 
 int
@@ -663,9 +653,9 @@ cpci_hp_start(void)
 		up_read(&list_rwsem);
 		return -ENODEV;
 	}
+	status = init_slots(first);
 	up_read(&list_rwsem);
 
-	status = init_slots(first);
 	if (first)
 		first = 0;
 	if (status)
-- 
1.7.5.4

