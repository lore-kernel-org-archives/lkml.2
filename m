Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2DGSVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 14:21:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33768 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2DGSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 14:21:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, matsumoto.hiroo@jp.fujitsu.com,
        Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH 1/2] PCI: correctly flush workqueue when destroy pcie hotplug controller
Date: Sun,  8 Apr 2012 02:18:54 +0800
Message-Id: <1333822735-10902-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When destroying a PCIe hotplug controller, all work items associated with
that controller should be flushed.  Function pcie_cleanup_slot() calls
cancel_delayed_work() and flush_workqueue() to achieve that.
Function flush_workqueue() will flush all work items already submitted,
but new work items submitted by those already submitted work items may
still be in live state when returning from flush_workqueue().

For the extreme case, pciehp driver may expierence following calling path:
1) pcie_isr() -> pciehp_handle_xxx() -> queue_interrupt_event()->queue_work()
2) interrupt_event_handler() -> handle_button_press_event() ->
   queue_delayed_work()
3) pciehp_queue_pushbutton_work() -> queue_work()

So enhance pcie_cleanup_slot() to correctly flush workqueue when destroying
PCIe hotplug controller.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/hotplug/pciehp_hpc.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index d4fa705..9a48a51 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -890,8 +890,19 @@ static int pcie_init_slot(struct controller *ctrl)
 static void pcie_cleanup_slot(struct controller *ctrl)
 {
 	struct slot *slot = ctrl->slot;
-	cancel_delayed_work(&slot->work);
+
+	/*
+	 * Following workqueue flushing logic is to deal with the special call path:
+	 * 1) pcie_isr() -> pciehp_handle_xxx() ->
+	 *    queue_interrupt_event(pciehp_wq_event)->queue_work(pciehp_wq)
+	 * 2) interrupt_event_handler() -> handle_button_press_event() ->
+	 *    queue_delayed_work(pciehp_wq)
+	 * 3) pciehp_queue_pushbutton_work() -> queue_work(pciehp_wq)
+	 */
 	flush_workqueue(pciehp_wq);
+	cancel_delayed_work_sync(&slot->work);
+	flush_workqueue(pciehp_wq);
+
 	kfree(slot);
 }
 
-- 
1.7.5.4

