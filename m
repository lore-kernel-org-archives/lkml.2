Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1DKRSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:18:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39536 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1DKRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dHaelo5/j7nyb8qhcf/YF3aO4HJShjsu/ibgPcbIdO5DIn1Yoelua+KEmgSlKzunGo
         eEFsQZIYxZs9RUGmGbduRrBFRJSNftWctBImhPTUF/B6B4Xr60Nfevd2vcvvFHqF4+Vh
         iZ44dviKa7eJa+ZnEHk6TAg/PUU2QNKzslFw8=
Date: Tue, 12 Apr 2011 02:18:03 +0900
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110411171803.GG9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302533763.2596.23.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing James.  The original message is http://lkml.org/lkml/2011/4/11/175 )

Please read from the bottom up.

On Mon, Apr 11, 2011 at 03:56:03PM +0100, Steven Whitehouse wrote:
>  [<ffffffff8167b8e5>] schedule_timeout+0x295/0x310
>  [<ffffffff8167a650>] wait_for_common+0x120/0x170
>  [<ffffffff8167a748>] wait_for_completion+0x18/0x20
>  [<ffffffff810aba4c>] wait_on_cpu_work+0xec/0x100
>  [<ffffffff810abb3b>] wait_on_work+0xdb/0x150
>  [<ffffffff810abc33>] __cancel_work_timer+0x83/0x130
>  [<ffffffff810abced>] cancel_delayed_work_sync+0xd/0x10

4. which in turn tries to sync cancel q->delay_work.  Oops, deadlock.

>  [<ffffffff813b24b4>] blk_sync_queue+0x24/0x50

3. and calls into blk_sync_queue()

>  [<ffffffff813b24ef>] blk_cleanup_queue+0xf/0x60
>  [<ffffffff81479a89>] scsi_free_queue+0x9/0x10
>  [<ffffffff8147d30b>] scsi_device_dev_release_usercontext+0xeb/0x140
>  [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0

2. It triggers SCSI device release

>  [<ffffffff8147d1f7>] scsi_device_dev_release+0x17/0x20
>  [<ffffffff814609f2>] device_release+0x22/0x90
>  [<ffffffff813c8165>] kobject_release+0x45/0x90
>  [<ffffffff813c9767>] kref_put+0x37/0x70
>  [<ffffffff813c8027>] kobject_put+0x27/0x60
>  [<ffffffff81460822>] put_device+0x12/0x20
>  [<ffffffff81478bd9>] scsi_request_fn+0xb9/0x4a0
>  [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
>  [<ffffffff813b1f66>] blk_delay_work+0x26/0x40

1. Workqueue starting execution of q->delay_work and scsi_request_fn()
   is run from there.

>  [<ffffffff810aa9c7>] process_one_work+0x197/0x520
>  [<ffffffff810acfec>] worker_thread+0x15c/0x330
>  [<ffffffff810b1f16>] kthread+0xa6/0xb0
>  [<ffffffff81687064>] kernel_thread_helper+0x4/0x10

So, q->delay_work ends up waiting for itself.  I'd like to blame SCSI
(as it also fits my agenda to kill execute_in_process_context ;-) for
diving all the way into blk_cleanup_queue() directly from request_fn.

Does the following patch fix the problem?

Thanks.

Subject: scsi: don't use execute_in_process_context()

SCSI is the only subsystem which uses execute_in_process_context() and
its use is racy against module unload.  ie. the reap work is not
properly flushed and could still be running after the scsi module is
unloaded.

Although execute_in_process_context() can be more efficient when the
caller already has a context, in this case, the call paths are quite
cold and the difference is practically meaningless.  With commit
c8efcc25 (workqueue: allow chained queueing during destruction), the
race condition can easily be fixed by using a dedicated workqueue and
destroying it on module unload.

Create and use scsi_wq instead of execute_in_process_context().

* scsi_device->ew is replaced with release_work.  scsi_target->ew is
  replaced with reap_work.

* Both works are initialized with the respective release/reap function
  during device/target init.  scsi_target_reap_usercontext() is moved
  upwards to avoid needing forward declaration.

* scsi_alloc_target() now explicitly flushes the reap_work of the
  found dying target before putting it instead of depending on
  flush_scheduled_work().

For more info on the issues, please read the following thread.

 http://thread.gmane.org/gmane.linux.scsi/62923

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi.c        |   15 +++++++++++++--
 drivers/scsi/scsi_scan.c   |   26 +++++++++++++-------------
 drivers/scsi/scsi_sysfs.c  |    8 +++++---
 include/scsi/scsi_device.h |    6 ++++--
 4 files changed, 35 insertions(+), 20 deletions(-)

Index: work/drivers/scsi/scsi_scan.c
===================================================================
--- work.orig/drivers/scsi/scsi_scan.c
+++ work/drivers/scsi/scsi_scan.c
@@ -362,6 +362,16 @@ int scsi_is_target_device(const struct d
 }
 EXPORT_SYMBOL(scsi_is_target_device);
 
+static void scsi_target_reap_usercontext(struct work_struct *work)
+{
+	struct scsi_target *starget =
+		container_of(work, struct scsi_target, reap_work);
+
+	transport_remove_device(&starget->dev);
+	device_del(&starget->dev);
+	scsi_target_destroy(starget);
+}
+
 static struct scsi_target *__scsi_find_target(struct device *parent,
 					      int channel, uint id)
 {
@@ -427,6 +437,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	INIT_WORK(&starget->reap_work, scsi_target_reap_usercontext);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -462,21 +473,11 @@ static struct scsi_target *scsi_alloc_ta
 	}
 	/* Unfortunately, we found a dying target; need to
 	 * wait until it's dead before we can get a new one */
+	flush_work(&found_target->reap_work);
 	put_device(&found_target->dev);
-	flush_scheduled_work();
 	goto retry;
 }
 
-static void scsi_target_reap_usercontext(struct work_struct *work)
-{
-	struct scsi_target *starget =
-		container_of(work, struct scsi_target, ew.work);
-
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	scsi_target_destroy(starget);
-}
-
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  * @starget: target to be checked
@@ -507,8 +508,7 @@ void scsi_target_reap(struct scsi_target
 	if (state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		queue_work(scsi_wq, &starget->reap_work);
 }
 
 /**
Index: work/drivers/scsi/scsi_sysfs.c
===================================================================
--- work.orig/drivers/scsi/scsi_sysfs.c
+++ work/drivers/scsi/scsi_sysfs.c
@@ -300,7 +300,7 @@ static void scsi_device_dev_release_user
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
-	sdev = container_of(work, struct scsi_device, ew.work);
+	sdev = container_of(work, struct scsi_device, release_work);
 
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
@@ -343,8 +343,8 @@ static void scsi_device_dev_release_user
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+
+	queue_work(scsi_wq, &sdp->release_work);
 }
 
 static struct class sdev_class = {
@@ -1069,6 +1069,8 @@ void scsi_sysfs_device_initialize(struct
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = starget->scsi_level;
+	INIT_WORK(&sdev->release_work, scsi_device_dev_release_usercontext);
+
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
Index: work/include/scsi/scsi_device.h
===================================================================
--- work.orig/include/scsi/scsi_device.h
+++ work/include/scsi/scsi_device.h
@@ -168,7 +168,7 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
-	struct execute_work	ew; /* used to get process context on put */
+	struct work_struct	release_work; /* for process context on put */
 
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
@@ -259,7 +259,7 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
-	struct execute_work	ew;
+	struct work_struct	reap_work;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
@@ -277,6 +277,8 @@ static inline struct scsi_target *scsi_t
 #define starget_printk(prefix, starget, fmt, a...)	\
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)
 
+extern struct workqueue_struct *scsi_wq;
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
Index: work/drivers/scsi/scsi.c
===================================================================
--- work.orig/drivers/scsi/scsi.c
+++ work/drivers/scsi/scsi.c
@@ -70,6 +70,11 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/scsi.h>
 
+/*
+ * Utility multithreaded workqueue for SCSI.
+ */
+struct workqueue_struct *scsi_wq;
+
 static void scsi_done(struct scsi_cmnd *cmd);
 
 /*
@@ -1306,11 +1311,14 @@ MODULE_PARM_DESC(scsi_logging_level, "a
 
 static int __init init_scsi(void)
 {
-	int error;
+	int error = -ENOMEM;
 
+	scsi_wq = alloc_workqueue("scsi", 0, 0);
+	if (!scsi_wq)
+		return error;
 	error = scsi_init_queue();
 	if (error)
-		return error;
+		goto cleanup_wq;
 	error = scsi_init_procfs();
 	if (error)
 		goto cleanup_queue;
@@ -1342,6 +1350,8 @@ cleanup_procfs:
 	scsi_exit_procfs();
 cleanup_queue:
 	scsi_exit_queue();
+cleanup_wq:
+	destroy_workqueue(scsi_wq);
 	printk(KERN_ERR "SCSI subsystem failed to initialize, error = %d\n",
 	       -error);
 	return error;
@@ -1356,6 +1366,7 @@ static void __exit exit_scsi(void)
 	scsi_exit_devinfo();
 	scsi_exit_procfs();
 	scsi_exit_queue();
+	destroy_workqueue(scsi_wq);
 }
 
 subsys_initcall(init_scsi);
