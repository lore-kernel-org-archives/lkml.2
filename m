Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab2D0PVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:21:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581Ab2D0PVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 10/19] PCI: serialize hotplug operaitons triggered by the shpchp driver
Date: Fri, 27 Apr 2012 23:16:51 +0800
Message-Id: <1335539820-11232-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCI hotplug lock to serialize hotplug operations triggered by the
shpchp driver.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/shpchp.h      |    2 ++
 drivers/pci/hotplug/shpchp_core.c |    3 ++-
 drivers/pci/hotplug/shpchp_ctrl.c |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index 6691dc4..07f3b2d 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -157,6 +157,7 @@ struct controller {
 #define BLINKINGOFF_STATE		2
 #define POWERON_STATE			3
 #define POWEROFF_STATE			4
+#define SHUTDOWN_STATE			5
 
 /* Error messages */
 #define INTERLOCK_OPEN			0x00000002
@@ -179,6 +180,7 @@ extern u8 shpchp_handle_presence_change(u8 hp_slot, struct controller *ctrl);
 extern u8 shpchp_handle_power_fault(u8 hp_slot, struct controller *ctrl);
 extern int shpchp_configure_device(struct slot *p_slot);
 extern int shpchp_unconfigure_device(struct slot *p_slot);
+extern void shpchp_shutdown_slot(struct slot *slot);
 extern void cleanup_slots(struct controller *ctrl);
 extern void shpchp_queue_pushbutton_work(struct work_struct *work);
 extern int shpc_init( struct controller *ctrl, struct pci_dev *pdev);
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 19762b3..71cc5f2 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -172,10 +172,11 @@ void cleanup_slots(struct controller *ctrl)
 
 	list_for_each_safe(tmp, next, &ctrl->slot_list) {
 		slot = list_entry(tmp, struct slot, slot_list);
-		list_del(&slot->slot_list);
 		flush_workqueue(shpchp_wq);
 		cancel_delayed_work_sync(&slot->work);
+		shpchp_shutdown_slot(slot);
 		flush_workqueue(shpchp_ordered_wq);
+		list_del(&slot->slot_list);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
 }
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index b00b09b..7b8e3a6 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <linux/pci.h>
 #include "../pci.h"
 #include "shpchp.h"
@@ -406,6 +407,18 @@ static void shpchp_pushbutton_thread(struct work_struct *work)
 	struct pushbutton_work_info *info =
 		container_of(work, struct pushbutton_work_info, work);
 	struct slot *p_slot = info->p_slot;
+	bool shutdown;
+
+	/* Break possible deadlock by using pci_hotplug_try_enter() */
+	while (!pci_hotplug_try_enter()) {
+		mutex_lock(&p_slot->lock);
+		shutdown = p_slot->state == SHUTDOWN_STATE;
+		mutex_unlock(&p_slot->lock);
+		if (shutdown)
+			goto out;
+		else
+			mdelay(1);
+	}
 
 	mutex_lock(&p_slot->lock);
 	switch (p_slot->state) {
@@ -427,6 +440,9 @@ static void shpchp_pushbutton_thread(struct work_struct *work)
 	}
 	mutex_unlock(&p_slot->lock);
 
+	pci_hotplug_exit();
+
+out:
 	kfree(info);
 }
 
@@ -729,3 +745,19 @@ int shpchp_sysfs_disable_slot(struct slot *p_slot)
 
 	return retval;
 }
+
+void shpchp_shutdown_slot(struct slot *slot)
+{
+	u8 getstatus;
+
+	mutex_lock(&slot->lock);
+	slot->state = SHUTDOWN_STATE;
+	mutex_unlock(&slot->lock);
+
+	slot->hpc_ops->set_attention_status(slot, 0);
+	slot->hpc_ops->get_power_status(slot, &getstatus);
+	if (getstatus)
+		slot->hpc_ops->green_led_on(slot);
+	else
+		slot->hpc_ops->green_led_off(slot);
+}
-- 
1.7.5.4

