Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573Ab2D0PU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:20:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363Ab2D0PUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:20:54 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 06/19] PCI: prepare for serializing hotplug operations triggered by pciehp driver
Date: Fri, 27 Apr 2012 23:16:47 +0800
Message-Id: <1335539820-11232-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Split pciehp_wq into two workqueues to avoid possible deadlock issues
when using PCI hotplug lock to serialize hotplug operations triggered
by pciehp driver.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/pciehp.h      |    3 ++-
 drivers/pci/hotplug/pciehp_core.c |   18 +++++++++++++-----
 drivers/pci/hotplug/pciehp_ctrl.c |    8 ++++----
 drivers/pci/hotplug/pciehp_hpc.c  |   11 ++++++-----
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 4b7cce1..c8a1a27 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -44,7 +44,8 @@ extern bool pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern bool pciehp_debug;
 extern bool pciehp_force;
-extern struct workqueue_struct *pciehp_wq;
+extern struct workqueue_struct *pciehp_wq_event;
+extern struct workqueue_struct *pciehp_wq_power;
 
 #define dbg(format, arg...)						\
 do {									\
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 365c6b9..4ceefe3 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -42,7 +42,8 @@ bool pciehp_debug;
 bool pciehp_poll_mode;
 int pciehp_poll_time;
 bool pciehp_force;
-struct workqueue_struct *pciehp_wq;
+struct workqueue_struct *pciehp_wq_event;
+struct workqueue_struct *pciehp_wq_power;
 
 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -340,16 +341,22 @@ static int __init pcied_init(void)
 {
 	int retval = 0;
 
-	pciehp_wq = alloc_workqueue("pciehp", 0, 0);
-	if (!pciehp_wq)
+	pciehp_wq_event = alloc_workqueue("pciehp_event", 0, 0);
+	if (!pciehp_wq_event)
 		return -ENOMEM;
+	pciehp_wq_power = alloc_workqueue("pciehp_power", 0, 0);
+	if (!pciehp_wq_power) {
+		destroy_workqueue(pciehp_wq_event);
+		return -ENOMEM;
+	}
 
 	pciehp_firmware_init();
 	retval = pcie_port_service_register(&hpdriver_portdrv);
  	dbg("pcie_port_service_register = %d\n", retval);
   	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
  	if (retval) {
-		destroy_workqueue(pciehp_wq);
+		destroy_workqueue(pciehp_wq_event);
+		destroy_workqueue(pciehp_wq_power);
 		dbg("Failure to register service\n");
 	}
 	return retval;
@@ -359,7 +366,8 @@ static void __exit pcied_cleanup(void)
 {
 	dbg("unload_pciehpd()\n");
 	pcie_port_service_unregister(&hpdriver_portdrv);
-	destroy_workqueue(pciehp_wq);
+	destroy_workqueue(pciehp_wq_event);
+	destroy_workqueue(pciehp_wq_power);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
 
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 27f4429..8f4d261 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -49,7 +49,7 @@ static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
 	info->p_slot = p_slot;
 	INIT_WORK(&info->work, interrupt_event_handler);
 
-	queue_work(pciehp_wq, &info->work);
+	queue_work(pciehp_wq_event, &info->work);
 
 	return 0;
 }
@@ -344,7 +344,7 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 		kfree(info);
 		goto out;
 	}
-	queue_work(pciehp_wq, &info->work);
+	queue_work(pciehp_wq_power, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }
@@ -377,7 +377,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		if (ATTN_LED(ctrl))
 			pciehp_set_attention_status(p_slot, 0);
 
-		queue_delayed_work(pciehp_wq, &p_slot->work, 5*HZ);
+		queue_delayed_work(pciehp_wq_event, &p_slot->work, 5*HZ);
 		break;
 	case BLINKINGOFF_STATE:
 	case BLINKINGON_STATE:
@@ -439,7 +439,7 @@ static void handle_surprise_event(struct slot *p_slot)
 	else
 		p_slot->state = POWERON_STATE;
 
-	queue_work(pciehp_wq, &info->work);
+	queue_work(pciehp_wq_power, &info->work);
 }
 
 static void interrupt_event_handler(struct work_struct *work)
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 98b775f..d5c826d 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -894,14 +894,15 @@ static void pcie_cleanup_slot(struct controller *ctrl)
 	 * Following workqueue flushing logic is to deal with the special
 	 * call path:
 	 * 1) pcie_isr() -> pciehp_handle_xxx() ->
-	 *    queue_interrupt_event(pciehp_wq_event)->queue_work(pciehp_wq)
+	 *    queue_interrupt_event(pciehp_wq_event)->
+	 *    queue_work(pciehp_wq_event)
 	 * 2) interrupt_event_handler() -> handle_button_press_event() ->
-	 *    queue_delayed_work(pciehp_wq)
-	 * 3) pciehp_queue_pushbutton_work() -> queue_work(pciehp_wq)
+	 *    queue_delayed_work(pciehp_wq_event)
+	 * 3) pciehp_queue_pushbutton_work() -> queue_work(pciehp_wq_power)
 	 */
-	flush_workqueue(pciehp_wq);
+	flush_workqueue(pciehp_wq_event);
 	cancel_delayed_work_sync(&slot->work);
-	flush_workqueue(pciehp_wq);
+	flush_workqueue(pciehp_wq_power);
 
 	kfree(slot);
 }
-- 
1.7.5.4

