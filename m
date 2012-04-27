Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab2D0PVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:21:18 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50093 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760588Ab2D0PVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 08/19] PCI: fix two race windows when probing/removing SHPC controller
Date: Fri, 27 Apr 2012 23:16:49 +0800
Message-Id: <1335539820-11232-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

With current shpchp implementation, interrupt is enabled before corresponding
slot data structures are created. If interrupt happens immediately after
enabling the hotplug interrupt, shpchp_find_slot() may return NULL, thus
causes NULL pointer dereference. So create slot data structures before
enabling interrupt.

And cleanup_slots() is called to destroy slot data structures before disabling
interrupt, which may cause invalid memory access in shpc_isr().  So call
cleanup_slots() after disabling interrupt/removing the poll timer.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/shpchp.h      |    1 +
 drivers/pci/hotplug/shpchp_core.c |    6 +++---
 drivers/pci/hotplug/shpchp_hpc.c  |   36 +++++++++++++++++++++---------------
 3 files changed, 25 insertions(+), 18 deletions(-)

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
index 7414fd9..aaa66be 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
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
index 75ba231..2bc6182 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -592,6 +592,13 @@ static void hpc_release_ctlr(struct controller *ctrl)
 		shpc_writel(ctrl, SLOT_REG(i), slot_reg);
 	}
 
+	if (shpchp_poll_mode)
+		del_timer(&ctrl->poll_timer);
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

