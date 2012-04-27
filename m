Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558Ab2D0PUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:20:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473Ab2D0PUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:20:44 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 05/19] PCI: correctly flush workqueue when destroy pcie hotplug controller
Date: Fri, 27 Apr 2012 23:16:46 +0800
Message-Id: <1335539820-11232-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

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

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/pciehp_hpc.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index a960fae..98b775f 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -889,8 +889,20 @@ static int pcie_init_slot(struct controller *ctrl)
 static void pcie_cleanup_slot(struct controller *ctrl)
 {
 	struct slot *slot = ctrl->slot;
-	cancel_delayed_work(&slot->work);
+
+	/*
+	 * Following workqueue flushing logic is to deal with the special
+	 * call path:
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

