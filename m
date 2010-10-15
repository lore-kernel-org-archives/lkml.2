Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0JOOrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:47:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:44052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0JOOrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:47:40 -0400
Message-ID: <4CB8698A.8030202@kernel.org>
Date: Fri, 15 Oct 2010 16:47:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
References: <4CB86966.5020606@kernel.org>
In-Reply-To: <4CB86966.5020606@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 14:47:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rename shpchp_wq to shpchp_ordered_wq and add non-ordered shpchp_wq
  which is used instead of the system workqueue.  This is to remove
  the use of flush_scheduled_work() which is deprecated and scheduled
  for removal.

* With cmwq in place, there's no point in creating workqueues lazily.
  Create both shpchp_wq and shpchp_ordered_wq upfront.

* Include workqueue.h from shpchp.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/pci/hotplug/shpchp.h      |    2 ++
 drivers/pci/hotplug/shpchp_core.c |   20 ++++++++++++++++++--
 drivers/pci/hotplug/shpchp_ctrl.c |    7 +++----
 drivers/pci/hotplug/shpchp_hpc.c  |   26 ++------------------------
 4 files changed, 25 insertions(+), 30 deletions(-)

Index: work/drivers/pci/hotplug/shpchp_core.c
===================================================================
--- work.orig/drivers/pci/hotplug/shpchp_core.c
+++ work/drivers/pci/hotplug/shpchp_core.c
@@ -33,7 +33,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <linux/workqueue.h>
 #include "shpchp.h"

 /* Global variables */
@@ -41,6 +40,7 @@ int shpchp_debug;
 int shpchp_poll_mode;
 int shpchp_poll_time;
 struct workqueue_struct *shpchp_wq;
+struct workqueue_struct *shpchp_ordered_wq;

 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -174,8 +174,8 @@ void cleanup_slots(struct controller *ct
 		slot = list_entry(tmp, struct slot, slot_list);
 		list_del(&slot->slot_list);
 		cancel_delayed_work(&slot->work);
-		flush_scheduled_work();
 		flush_workqueue(shpchp_wq);
+		flush_workqueue(shpchp_ordered_wq);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
 }
@@ -360,9 +360,23 @@ static int __init shpcd_init(void)
 {
 	int retval = 0;

+	shpchp_wq = alloc_ordered_workqueue("shpchp", 0);
+	if (!shpchp_wq)
+		return -ENOMEM;
+
+	shpchp_ordered_wq = alloc_ordered_workqueue("shpchp_ordered", 0);
+	if (!shpchp_ordered_wq) {
+		destroy_workqueue(shpchp_wq);
+		return -ENOMEM;
+	}
+
 	retval = pci_register_driver(&shpc_driver);
 	dbg("%s: pci_register_driver = %d\n", __func__, retval);
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	if (retval) {
+		destroy_workqueue(shpchp_ordered_wq);
+		destroy_workqueue(shpchp_wq);
+	}
 	return retval;
 }

@@ -370,6 +384,8 @@ static void __exit shpcd_cleanup(void)
 {
 	dbg("unload_shpchpd()\n");
 	pci_unregister_driver(&shpc_driver);
+	destroy_workqueue(shpchp_ordered_wq);
+	destroy_workqueue(shpchp_wq);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }

Index: work/drivers/pci/hotplug/shpchp_ctrl.c
===================================================================
--- work.orig/drivers/pci/hotplug/shpchp_ctrl.c
+++ work/drivers/pci/hotplug/shpchp_ctrl.c
@@ -32,7 +32,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <linux/workqueue.h>
 #include "../pci.h"
 #include "shpchp.h"

@@ -52,7 +51,7 @@ static int queue_interrupt_event(struct
 	info->p_slot = p_slot;
 	INIT_WORK(&info->work, interrupt_event_handler);

-	schedule_work(&info->work);
+	queue_work(shpchp_wq, &info->work);

 	return 0;
 }
@@ -457,7 +456,7 @@ void shpchp_queue_pushbutton_work(struct
 		kfree(info);
 		goto out;
 	}
-	queue_work(shpchp_wq, &info->work);
+	queue_work(shpchp_ordered_wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }
@@ -505,7 +504,7 @@ static void handle_button_press_event(st
 		p_slot->hpc_ops->green_led_blink(p_slot);
 		p_slot->hpc_ops->set_attention_status(p_slot, 0);

-		schedule_delayed_work(&p_slot->work, 5*HZ);
+		queue_delayed_work(shpchp_wq, &p_slot->work, 5*HZ);
 		break;
 	case BLINKINGOFF_STATE:
 	case BLINKINGON_STATE:
Index: work/drivers/pci/hotplug/shpchp_hpc.c
===================================================================
--- work.orig/drivers/pci/hotplug/shpchp_hpc.c
+++ work/drivers/pci/hotplug/shpchp_hpc.c
@@ -179,8 +179,6 @@
 #define SLOT_EVENT_LATCH	0x2
 #define SLOT_SERR_INT_MASK	0x3

-static atomic_t shpchp_num_controllers = ATOMIC_INIT(0);
-
 static irqreturn_t shpc_isr(int irq, void *dev_id);
 static void start_int_poll_timer(struct controller *ctrl, int sec);
 static int hpc_check_cmd_status(struct controller *ctrl);
@@ -614,13 +612,6 @@ static void hpc_release_ctlr(struct cont

 	iounmap(ctrl->creg);
 	release_mem_region(ctrl->mmio_base, ctrl->mmio_size);
-
-	/*
-	 * If this is the last controller to be released, destroy the
-	 * shpchpd work queue
-	 */
-	if (atomic_dec_and_test(&shpchp_num_controllers))
-		destroy_workqueue(shpchp_wq);
 }

 static int hpc_power_on_slot(struct slot * slot)
@@ -1077,9 +1068,8 @@ int shpc_init(struct controller *ctrl, s

 		rc = request_irq(ctrl->pci_dev->irq, shpc_isr, IRQF_SHARED,
 				 MY_NAME, (void *)ctrl);
-		ctrl_dbg(ctrl, "request_irq %d for hpc%d (returns %d)\n",
-			 ctrl->pci_dev->irq,
-		    atomic_read(&shpchp_num_controllers), rc);
+		ctrl_dbg(ctrl, "request_irq %d (returns %d)\n",
+			 ctrl->pci_dev->irq, rc);
 		if (rc) {
 			ctrl_err(ctrl, "Can't get irq %d for the hotplug "
 				 "controller\n", ctrl->pci_dev->irq);
@@ -1092,18 +1082,6 @@ int shpc_init(struct controller *ctrl, s
 	shpc_get_cur_bus_speed(ctrl);

 	/*
-	 * If this is the first controller to be initialized,
-	 * initialize the shpchpd work queue
-	 */
-	if (atomic_add_return(1, &shpchp_num_controllers) == 1) {
-		shpchp_wq = create_singlethread_workqueue("shpchpd");
-		if (!shpchp_wq) {
-			rc = -ENOMEM;
-			goto abort_iounmap;
-		}
-	}
-
-	/*
 	 * Unmask all event interrupts of all slots
 	 */
 	for (hp_slot = 0; hp_slot < ctrl->num_slots; hp_slot++) {
Index: work/drivers/pci/hotplug/shpchp.h
===================================================================
--- work.orig/drivers/pci/hotplug/shpchp.h
+++ work/drivers/pci/hotplug/shpchp.h
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>	/* signal_pending(), struct timer_list */
 #include <linux/mutex.h>
+#include <linux/workqueue.h>

 #if !defined(MODULE)
 	#define MY_NAME	"shpchp"
@@ -46,6 +47,7 @@ extern int shpchp_poll_mode;
 extern int shpchp_poll_time;
 extern int shpchp_debug;
 extern struct workqueue_struct *shpchp_wq;
+extern struct workqueue_struct *shpchp_ordered_wq;

 #define dbg(format, arg...)						\
 do {									\
