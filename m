Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0FNVlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:41:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:46992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab0FNVj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:59 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 29/30] libata: take advantage of cmwq and remove concurrency limitations
Date: Mon, 14 Jun 2010 23:37:46 +0200
Message-Id: <1276551467-21246-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata has two concurrency related limitations.

a. ata_wq which is used for polling PIO has single thread per CPU.  If
   there are multiple devices doing polling PIO on the same CPU, they
   can't be executed simultaneously.

b. ata_aux_wq which is used for SCSI probing has single thread.  In
   cases where SCSI probing is stalled for extended period of time
   which is possible for ATAPI devices, this will stall all probing.

#a is solved by increasing maximum concurrency of ata_wq.  Please note
that polling PIO might be used under allocation path and thus needs to
be served by a separate wq with a rescuer.

#b is solved by using the default wq instead and achieving exclusion
via per-port mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/ata/libata-core.c |   20 +++++---------------
 drivers/ata/libata-eh.c   |    4 ++--
 drivers/ata/libata-scsi.c |   10 ++++++----
 drivers/ata/libata-sff.c  |    9 +--------
 drivers/ata/libata.h      |    1 -
 include/linux/libata.h    |    1 +
 6 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ddf8e48..4f78741 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -98,8 +98,6 @@ static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
 
-struct workqueue_struct *ata_aux_wq;
-
 struct ata_force_param {
 	const char	*name;
 	unsigned int	cbl;
@@ -5611,6 +5609,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->msg_enable = ATA_MSG_DRV | ATA_MSG_ERR | ATA_MSG_WARN;
 #endif
 
+	mutex_init(&ap->scsi_scan_mutex);
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
@@ -6549,29 +6548,20 @@ static int __init ata_init(void)
 
 	ata_parse_force_param();
 
-	ata_aux_wq = create_singlethread_workqueue("ata_aux");
-	if (!ata_aux_wq)
-		goto fail;
-
 	rc = ata_sff_init();
-	if (rc)
-		goto fail;
+	if (rc) {
+		kfree(ata_force_tbl);
+		return rc;
+	}
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
-
-fail:
-	kfree(ata_force_tbl);
-	if (ata_aux_wq)
-		destroy_workqueue(ata_aux_wq);
-	return rc;
 }
 
 static void __exit ata_exit(void)
 {
 	ata_sff_exit();
 	kfree(ata_force_tbl);
-	destroy_workqueue(ata_aux_wq);
 }
 
 subsys_initcall(ata_init);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f77a673..4d2af82 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -727,7 +727,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 	if (ap->pflags & ATA_PFLAG_LOADING)
 		ap->pflags &= ~ATA_PFLAG_LOADING;
 	else if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
-		queue_delayed_work(ata_aux_wq, &ap->hotplug_task, 0);
+		schedule_delayed_work(&ap->hotplug_task, 0);
 
 	if (ap->pflags & ATA_PFLAG_RECOVERED)
 		ata_port_printk(ap, KERN_INFO, "EH complete\n");
@@ -2944,7 +2944,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ehc->i.flags |= ATA_EHI_SETMODE;
 
 			/* schedule the scsi_rescan_device() here */
-			queue_work(ata_aux_wq, &(ap->scsi_rescan_task));
+			schedule_work(&(ap->scsi_rescan_task));
 		} else if (dev->class == ATA_DEV_UNKNOWN &&
 			   ehc->tries[dev->devno] &&
 			   ata_class_enabled(ehc->classes[dev->devno])) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a54273d..d75c9c4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3435,7 +3435,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 				"                  switching to async\n");
 	}
 
-	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
+	queue_delayed_work(system_long_wq, &ap->hotplug_task,
 			   round_jiffies_relative(HZ));
 }
 
@@ -3582,6 +3582,7 @@ void ata_scsi_hotplug(struct work_struct *work)
 	}
 
 	DPRINTK("ENTER\n");
+	mutex_lock(&ap->scsi_scan_mutex);
 
 	/* Unplug detached devices.  We cannot use link iterator here
 	 * because PMP links have to be scanned even if PMP is
@@ -3595,6 +3596,7 @@ void ata_scsi_hotplug(struct work_struct *work)
 	/* scan for new ones */
 	ata_scsi_scan_host(ap, 0);
 
+	mutex_unlock(&ap->scsi_scan_mutex);
 	DPRINTK("EXIT\n");
 }
 
@@ -3673,9 +3675,7 @@ static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
  *	@work: Pointer to ATA port to perform scsi_rescan_device()
  *
  *	After ATA pass thru (SAT) commands are executed successfully,
- *	libata need to propagate the changes to SCSI layer.  This
- *	function must be executed from ata_aux_wq such that sdev
- *	attach/detach don't race with rescan.
+ *	libata need to propagate the changes to SCSI layer.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -3688,6 +3688,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	struct ata_device *dev;
 	unsigned long flags;
 
+	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
 	ata_for_each_link(link, ap, EDGE) {
@@ -3707,6 +3708,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
+	mutex_unlock(&ap->scsi_scan_mutex);
 }
 
 /**
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index efa4a18..dd57815 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3318,14 +3318,7 @@ void ata_sff_port_init(struct ata_port *ap)
 
 int __init ata_sff_init(void)
 {
-	/*
-	 * FIXME: In UP case, there is only one workqueue thread and if you
-	 * have more than one PIO device, latency is bloody awful, with
-	 * occasional multi-second "hiccups" as one PIO device waits for
-	 * another.  It's an ugly wart that users DO occasionally complain
-	 * about; luckily most users have at most one PIO polled device.
-	 */
-	ata_sff_wq = create_workqueue("ata_sff");
+	ata_sff_wq = __create_workqueue("ata_sff", WQ_RESCUER, WQ_MAX_ACTIVE);
 	if (!ata_sff_wq)
 		return -ENOMEM;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 4b84ed6..9ce1ecc 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -54,7 +54,6 @@ enum {
 };
 
 extern unsigned int ata_print_id;
-extern struct workqueue_struct *ata_aux_wq;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b85f3ff..f010f18 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -751,6 +751,7 @@ struct ata_port {
 	struct ata_host		*host;
 	struct device 		*dev;
 
+	struct mutex		scsi_scan_mutex;
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;
 
-- 
1.6.4.2

