Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0JOOrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:47:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:44042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0JOOrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:47:06 -0400
Message-ID: <4CB86966.5020606@kernel.org>
Date: Fri, 15 Oct 2010 16:47:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7 1/2] pciehp: update workqueue usage
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 14:47:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rename pciehp_wq to pciehp_ordered_wq and add non-ordered pciehp_wq
  which is used instead of the system workqueue.  This is to remove
  the use of flush_scheduled_work() which is deprecated and scheduled
  for removal.

* With cmwq in place, there's no point in creating workqueues lazily.
  Create both pciehp_wq and pciehp_ordered_wq upfront.

* Include workqueue.h from pciehp.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Both patches are only compile tested.  They should be safe but please
proceed with caution.

Thank you.

 drivers/pci/hotplug/pciehp.h      |    2 ++
 drivers/pci/hotplug/pciehp_core.c |   18 +++++++++++++++++-
 drivers/pci/hotplug/pciehp_ctrl.c |    9 ++++-----
 drivers/pci/hotplug/pciehp_hpc.c  |   20 +-------------------
 4 files changed, 24 insertions(+), 25 deletions(-)

Index: work/drivers/pci/hotplug/pciehp.h
===================================================================
--- work.orig/drivers/pci/hotplug/pciehp.h
+++ work/drivers/pci/hotplug/pciehp.h
@@ -36,6 +36,7 @@
 #include <linux/sched.h>		/* signal_pending() */
 #include <linux/pcieport_if.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>

 #define MY_NAME	"pciehp"

@@ -44,6 +45,7 @@ extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
 extern struct workqueue_struct *pciehp_wq;
+extern struct workqueue_struct *pciehp_ordered_wq;

 #define dbg(format, arg...)						\
 do {									\
Index: work/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- work.orig/drivers/pci/hotplug/pciehp_core.c
+++ work/drivers/pci/hotplug/pciehp_core.c
@@ -43,6 +43,7 @@ int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
 struct workqueue_struct *pciehp_wq;
+struct workqueue_struct *pciehp_ordered_wq;

 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -340,18 +341,33 @@ static int __init pcied_init(void)
 {
 	int retval = 0;

+	pciehp_wq = alloc_workqueue("pciehp", 0, 0);
+	if (!pciehp_wq)
+		return -ENOMEM;
+
+	pciehp_ordered_wq = alloc_ordered_workqueue("pciehp_ordered", 0);
+	if (!pciehp_ordered_wq) {
+		destroy_workqueue(pciehp_wq);
+		return -ENOMEM;
+	}
+
 	pciehp_firmware_init();
 	retval = pcie_port_service_register(&hpdriver_portdrv);
  	dbg("pcie_port_service_register = %d\n", retval);
   	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
- 	if (retval)
+ 	if (retval) {
+		destroy_workqueue(pciehp_ordered_wq);
+		destroy_workqueue(pciehp_wq);
 		dbg("Failure to register service\n");
+	}
 	return retval;
 }

 static void __exit pcied_cleanup(void)
 {
 	dbg("unload_pciehpd()\n");
+	destroy_workqueue(pciehp_ordered_wq);
+	destroy_workqueue(pciehp_wq);
 	pcie_port_service_unregister(&hpdriver_portdrv);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
Index: work/drivers/pci/hotplug/pciehp_ctrl.c
===================================================================
--- work.orig/drivers/pci/hotplug/pciehp_ctrl.c
+++ work/drivers/pci/hotplug/pciehp_ctrl.c
@@ -32,7 +32,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <linux/workqueue.h>
 #include "../pci.h"
 #include "pciehp.h"

@@ -50,7 +49,7 @@ static int queue_interrupt_event(struct
 	info->p_slot = p_slot;
 	INIT_WORK(&info->work, interrupt_event_handler);

-	schedule_work(&info->work);
+	queue_work(pciehp_wq, &info->work);

 	return 0;
 }
@@ -345,7 +344,7 @@ void pciehp_queue_pushbutton_work(struct
 		kfree(info);
 		goto out;
 	}
-	queue_work(pciehp_wq, &info->work);
+	queue_work(pciehp_ordered_wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }
@@ -378,7 +377,7 @@ static void handle_button_press_event(st
 		if (ATTN_LED(ctrl))
 			pciehp_set_attention_status(p_slot, 0);

-		schedule_delayed_work(&p_slot->work, 5*HZ);
+		queue_delayed_work(pciehp_wq, &p_slot->work, 5*HZ);
 		break;
 	case BLINKINGOFF_STATE:
 	case BLINKINGON_STATE:
@@ -440,7 +439,7 @@ static void handle_surprise_event(struct
 	else
 		p_slot->state = POWERON_STATE;

-	queue_work(pciehp_wq, &info->work);
+	queue_work(pciehp_ordered_wq, &info->work);
 }

 static void interrupt_event_handler(struct work_struct *work)
Index: work/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- work.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ work/drivers/pci/hotplug/pciehp_hpc.c
@@ -41,8 +41,6 @@
 #include "../pci.h"
 #include "pciehp.h"

-static atomic_t pciehp_num_controllers = ATOMIC_INIT(0);
-
 static inline int pciehp_readw(struct controller *ctrl, int reg, u16 *value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
@@ -805,8 +803,8 @@ static void pcie_cleanup_slot(struct con
 {
 	struct slot *slot = ctrl->slot;
 	cancel_delayed_work(&slot->work);
-	flush_scheduled_work();
 	flush_workqueue(pciehp_wq);
+	flush_workqueue(pciehp_ordered_wq);
 	kfree(slot);
 }

@@ -912,16 +910,6 @@ struct controller *pcie_init(struct pcie
 	/* Disable sotfware notification */
 	pcie_disable_notification(ctrl);

-	/*
-	 * If this is the first controller to be initialized,
-	 * initialize the pciehp work queue
-	 */
-	if (atomic_add_return(1, &pciehp_num_controllers) == 1) {
-		pciehp_wq = create_singlethread_workqueue("pciehpd");
-		if (!pciehp_wq)
-			goto abort_ctrl;
-	}
-
 	ctrl_info(ctrl, "HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n",
 		  pdev->vendor, pdev->device, pdev->subsystem_vendor,
 		  pdev->subsystem_device);
@@ -941,11 +929,5 @@ void pciehp_release_ctrl(struct controll
 {
 	pcie_shutdown_notification(ctrl);
 	pcie_cleanup_slot(ctrl);
-	/*
-	 * If this is the last controller to be released, destroy the
-	 * pciehp work queue
-	 */
-	if (atomic_dec_and_test(&pciehp_num_controllers))
-		destroy_workqueue(pciehp_wq);
 	kfree(ctrl);
 }
