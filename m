Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2DGSWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 14:22:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33768 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2DGSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 14:21:33 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, matsumoto.hiroo@jp.fujitsu.com,
        Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH 2/2] PCI: fix four race windows in shpchp driver
Date: Sun,  8 Apr 2012 02:18:55 +0800
Message-Id: <1333822735-10902-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333822735-10902-1-git-send-email-jiang.liu@huawei.com>
References: <1333822735-10902-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current shpchp implementation, interrupt is enabled before corresponding
slot data structures are created. If interrupt happens immediately after
enabling the hotplug interrupt, shpchp_find_slot() may return NULL, thus
causes NULL pointer dereference. So create slot data structures before
enabling interrupt.

The second one is, shpc_isr() may cause invalid memory access if it walks
the slot list when cleanup_slots() is modifying the list. So only call
cleanup_slots() after disabling interrupt/removing the poll timer.

The third one is, del_timer() can't reliabily remove the poll timer, so
use del_timer_sync() instead.

The fourth one is, cleanup_slots() can't reliabily flush all work items.
So tune the workqueue flushing logic to reliabily flush all work items.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
Hi all,
	These issues are identified by code analysis and I have no hardware
platform to verify the patches. Could anybody give me a hand here to test
these patches?
	Thanks!
	Gerry
---
 drivers/pci/hotplug/shpchp.h      |    1 +
 drivers/pci/hotplug/shpchp_core.c |    8 ++++----
 drivers/pci/hotplug/shpchp_hpc.c  |   36 +++++++++++++++++++++---------------
 3 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index ca64932..6691dc4 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -182,6 +182,7 @@ extern int shpchp_unconfigure_device(struct slot *p_slot);
 extern void cleanup_slots(struct controller *ctrl);
 extern void shpchp_queue_pushbutton_work(struct work_struct *work);
 extern int shpc_init( struct controller *ctrl, struct pci_dev *pdev);
+extern void shpc_enable_intr(struct controller *ctrl);
 
 static inline const char *slot_name(struct slot *slot)
 {
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 7414fd9..19762b3 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -173,8 +173,8 @@ void cleanup_slots(struct controller *ctrl)
 	list_for_each_safe(tmp, next, &ctrl->slot_list) {
 		slot = list_entry(tmp, struct slot, slot_list);
 		list_del(&slot->slot_list);
-		cancel_delayed_work(&slot->work);
 		flush_workqueue(shpchp_wq);
+		cancel_delayed_work_sync(&slot->work);
 		flush_workqueue(shpchp_ordered_wq);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
@@ -318,14 +318,14 @@ static int shpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_release_ctlr;
 	}
 
+	shpc_enable_intr(ctrl);
+
 	rc = shpchp_create_ctrl_files(ctrl);
 	if (rc)
-		goto err_cleanup_slots;
+		goto err_out_release_ctlr;
 
 	return 0;
 
-err_cleanup_slots:
-	cleanup_slots(ctrl);
 err_out_release_ctlr:
 	ctrl->hpc_ops->release_ctlr(ctrl);
 err_out_free_ctrl:
diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index 75ba231..ff63887 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -592,6 +592,13 @@ static void hpc_release_ctlr(struct controller *ctrl)
 		shpc_writel(ctrl, SLOT_REG(i), slot_reg);
 	}
 
+	if (shpchp_poll_mode)
+		del_timer_sync(&ctrl->poll_timer);
+	else {
+		free_irq(ctrl->pci_dev->irq, ctrl);
+		pci_disable_msi(ctrl->pci_dev);
+	}
+
 	cleanup_slots(ctrl);
 
 	/*
@@ -603,13 +610,6 @@ static void hpc_release_ctlr(struct controller *ctrl)
 	serr_int &= ~SERR_INTR_RSVDZ_MASK;
 	shpc_writel(ctrl, SERR_INTR_ENABLE, serr_int);
 
-	if (shpchp_poll_mode)
-		del_timer(&ctrl->poll_timer);
-	else {
-		free_irq(ctrl->pci_dev->irq, ctrl);
-		pci_disable_msi(ctrl->pci_dev);
-	}
-
 	iounmap(ctrl->creg);
 	release_mem_region(ctrl->mmio_base, ctrl->mmio_size);
 }
@@ -1081,6 +1081,20 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 	shpc_get_max_bus_speed(ctrl);
 	shpc_get_cur_bus_speed(ctrl);
 
+	return 0;
+
+	/* We end up here for the many possible ways to fail this API.  */
+abort_iounmap:
+	iounmap(ctrl->creg);
+abort:
+	return rc;
+}
+
+void shpc_enable_intr(struct controller *ctrl)
+{
+	u8 hp_slot;
+	u32 tempdword, slot_reg;
+
 	/*
 	 * Unmask all event interrupts of all slots
 	 */
@@ -1102,12 +1116,4 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 		tempdword = shpc_readl(ctrl, SERR_INTR_ENABLE);
 		ctrl_dbg(ctrl, "SERR_INTR_ENABLE = %x\n", tempdword);
 	}
-
-	return 0;
-
-	/* We end up here for the many possible ways to fail this API.  */
-abort_iounmap:
-	iounmap(ctrl->creg);
-abort:
-	return rc;
 }
-- 
1.7.5.4

