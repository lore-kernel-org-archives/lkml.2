Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1DMN5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1DMN5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:57:17 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302686454.2613.4.camel@dolmen>
References: <1302621261.2604.18.camel@mulgrave.site>
	 <1302624266.2661.21.camel@dolmen> <1302625621.2604.24.camel@mulgrave.site>
	 <1302627097.2661.25.camel@dolmen> <1302630090.2604.30.camel@mulgrave.site>
	 <1302633208.2661.29.camel@dolmen> <1302638216.2604.35.camel@mulgrave.site>
	 <1302640226.2661.34.camel@dolmen> <1302641036.2604.40.camel@mulgrave.site>
	 <20110413051846.GD24161@mtj.dyndns.org>
	 <20110413060651.GA27823@mtj.dyndns.org>  <1302686454.2613.4.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 13 Apr 2011 15:00:08 +0100
Message-ID: <1302703208.2613.18.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-04-13 at 10:20 +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Wed, 2011-04-13 at 15:06 +0900, Tejun Heo wrote:
> > On Wed, Apr 13, 2011 at 02:18:46PM +0900, Tejun Heo wrote:
> > > Steven, can you be enticed to try the combination?  I'll prep a
> > > combined patch and post it but please beware that I'm currently in a
> > > rather zombish state - sleep deprived, jet lagged and malfunctioning
> > > digestion - so the likelihood of doing something stupid is pretty
> > > high.
> > 
> > Does the following completely untested version work?
> > 
> Almost. With one small change (q->queue_lock is already a pointer to a
> spinlock, so it doesn't require an &) it seems to work for me. Let me
> know if you'd like me to do any more tests. I've attached an updated
> patch below,
> 
> Steve.
> 
Apologies, some gfs2 bits got included by accident. Here is a cleaned up
version,

Steve.

diff --git a/block/blk-core.c b/block/blk-core.c
index 90f22cc..90de9ac 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -359,6 +359,14 @@ void blk_put_queue(struct request_queue *q)
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
+	/* mark @q stopped and dead */
+	mutex_lock(&q->sysfs_lock);
+	spin_lock_irq(q->queue_lock);
+	queue_flag_set(QUEUE_FLAG_STOPPED, q);
+	queue_flag_set(QUEUE_FLAG_DEAD, q);
+	spin_unlock_irq(q->queue_lock);
+	mutex_unlock(&q->sysfs_lock);
+
 	/*
 	 * We know we have process context here, so we can be a little
 	 * cautious and ensure that pending block actions on this device
@@ -368,9 +376,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_sync_queue(q);
 
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
-	mutex_lock(&q->sysfs_lock);
-	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
-	mutex_unlock(&q->sysfs_lock);
 
 	if (q->elevator)
 		elevator_exit(q->elevator);
@@ -1456,7 +1461,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
  * generic_make_request and the drivers it calls may use bi_next if this
  * bio happens to be merged with someone else, and may change bi_dev and
  * bi_sector for remaps as it sees fit.  So the values of these fields
- * should NOT be depended on after the call to generic_make_request.
+ * should NOT be depended on after thes call to generic_make_request.
  */
 static inline void __generic_make_request(struct bio *bio)
 {
diff --git a/block/blk.h b/block/blk.h
index 6126346..4df474d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -62,7 +62,8 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2aeb2e9..12ebcbc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
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
@@ -1306,11 +1311,14 @@ MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
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
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087821f..4222b58 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -362,6 +362,16 @@ int scsi_is_target_device(const struct device *dev)
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
@@ -427,6 +437,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	INIT_WORK(&starget->reap_work, scsi_target_reap_usercontext);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -462,21 +473,11 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
@@ -507,8 +508,7 @@ void scsi_target_reap(struct scsi_target *starget)
 	if (state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		queue_work(scsi_wq, &starget->reap_work);
 }
 
 /**
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e44ff64..e030091 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -300,7 +300,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
-	sdev = container_of(work, struct scsi_device, ew.work);
+	sdev = container_of(work, struct scsi_device, release_work);
 
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
@@ -323,7 +323,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	}
 
 	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
 		scsi_free_queue(sdev->request_queue);
 		/* temporary expedient, try to catch use of queue lock
@@ -343,8 +342,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+
+	queue_work(scsi_wq, &sdp->release_work);
 }
 
 static struct class sdev_class = {
@@ -937,6 +936,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+	sdev->request_queue->queuedata = NULL;
 	put_device(dev);
 }
 
@@ -1069,6 +1069,8 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = starget->scsi_level;
+	INIT_WORK(&sdev->release_work, scsi_device_dev_release_usercontext);
+
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2d3ec50..1d11750 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
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
@@ -277,6 +277,8 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 #define starget_printk(prefix, starget, fmt, a...)	\
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)
 
+extern struct workqueue_struct *scsi_wq;
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,


