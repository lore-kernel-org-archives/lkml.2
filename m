Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1FXG67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:58:59 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:32832 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1FXG66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:58:58 -0400
X-ASG-Debug-ID: 1308898735-01de280c1e7e3f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E0435AC.4060402@fusionio.com>
Date: Fri, 24 Jun 2011 08:58:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 3.0-rc4
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block fixes for 3.0-rc4
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308898735
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66962
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes for the current cycle. Most of these
are stable material as well.

- Fix a long standing race around the ioc lookup cache in cfq-iosched.
  Very elusive bug, as the window is really small. Seemed to reproduce
  most easily on single CPU systems.

- Add REQ_SECURE to the shared bio/rq mask.

- Bad types in throtl_log() prints.

- A small series of continued fixes disk event notification and bdev
  claiming from Tejun.


Please pull.


  git://git.kernel.dk/linux-block.git for-linus

Jens Axboe (1):
      cfq-iosched: fix locking around ioc->ioc_data assignment

Joe Perches (1):
      block: Add __attribute__((format(printf...) and fix fallout

Namhyung Kim (1):
      block: add REQ_SECURE to REQ_COMMON_MASK

Tejun Heo (4):
      block: don't use non-syncing event blocking in disk_check_events()
      block: remove non-syncing __disk_block_events() and fold it into disk_block_events()
      block: make disk_block_events() properly wait for work cancellation
      block: use the passed in @bdev when claiming if partno is zero

 block/blk-throttle.c         |    4 +-
 block/cfq-iosched.c          |   16 +++++---
 block/genhd.c                |   79 ++++++++++++++++++++++++------------------
 fs/block_dev.c               |   14 +++++++-
 include/linux/blk_types.h    |    2 +-
 include/linux/blktrace_api.h |    3 +-
 6 files changed, 73 insertions(+), 45 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a62be8d..3689f83 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -927,7 +927,7 @@ static int throtl_dispatch(struct request_queue *q)
 
 	bio_list_init(&bio_list_on_stack);
 
-	throtl_log(td, "dispatch nr_queued=%lu read=%u write=%u",
+	throtl_log(td, "dispatch nr_queued=%d read=%u write=%u",
 			total_nr_queued(td), td->nr_queued[READ],
 			td->nr_queued[WRITE]);
 
@@ -1204,7 +1204,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 queue_bio:
-	throtl_log_tg(td, tg, "[%c] bio. bdisp=%u sz=%u bps=%llu"
+	throtl_log_tg(td, tg, "[%c] bio. bdisp=%llu sz=%u bps=%llu"
 			" iodisp=%u iops=%u queued=%d/%d",
 			rw == READ ? 'R' : 'W',
 			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3c7b537..f379943 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -988,9 +988,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
-			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
-			iops_mode(cfqd), cfqq->nr_sectors);
+	cfq_log_cfqq(cfqq->cfqd, cfqq,
+		     "sl_used=%u disp=%u charge=%u iops=%u sect=%lu",
+		     used_sl, cfqq->slice_dispatch, charge,
+		     iops_mode(cfqd), cfqq->nr_sectors);
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl,
 					  unaccounted_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
@@ -2023,8 +2024,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 */
 	if (sample_valid(cic->ttime_samples) &&
 	    (cfqq->slice_end - jiffies < cic->ttime_mean)) {
-		cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%d",
-				cic->ttime_mean);
+		cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%lu",
+			     cic->ttime_mean);
 		return;
 	}
 
@@ -2772,8 +2773,11 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	smp_wmb();
 	cic->key = cfqd_dead_key(cfqd);
 
-	if (ioc->ioc_data == cic)
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
diff --git a/block/genhd.c b/block/genhd.c
index 95822ae..3608289 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1371,6 +1371,7 @@ struct disk_events {
 	struct gendisk		*disk;		/* the associated disk */
 	spinlock_t		lock;
 
+	struct mutex		block_mutex;	/* protects blocking */
 	int			block;		/* event blocking depth */
 	unsigned int		pending;	/* events already sent out */
 	unsigned int		clearing;	/* events being cleared */
@@ -1414,22 +1415,44 @@ static unsigned long disk_events_poll_jiffies(struct gendisk *disk)
 	return msecs_to_jiffies(intv_msecs);
 }
 
-static void __disk_block_events(struct gendisk *disk, bool sync)
+/**
+ * disk_block_events - block and flush disk event checking
+ * @disk: disk to block events for
+ *
+ * On return from this function, it is guaranteed that event checking
+ * isn't in progress and won't happen until unblocked by
+ * disk_unblock_events().  Events blocking is counted and the actual
+ * unblocking happens after the matching number of unblocks are done.
+ *
+ * Note that this intentionally does not block event checking from
+ * disk_clear_events().
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+void disk_block_events(struct gendisk *disk)
 {
 	struct disk_events *ev = disk->ev;
 	unsigned long flags;
 	bool cancel;
 
+	if (!ev)
+		return;
+
+	/*
+	 * Outer mutex ensures that the first blocker completes canceling
+	 * the event work before further blockers are allowed to finish.
+	 */
+	mutex_lock(&ev->block_mutex);
+
 	spin_lock_irqsave(&ev->lock, flags);
 	cancel = !ev->block++;
 	spin_unlock_irqrestore(&ev->lock, flags);
 
-	if (cancel) {
-		if (sync)
-			cancel_delayed_work_sync(&disk->ev->dwork);
-		else
-			cancel_delayed_work(&disk->ev->dwork);
-	}
+	if (cancel)
+		cancel_delayed_work_sync(&disk->ev->dwork);
+
+	mutex_unlock(&ev->block_mutex);
 }
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
@@ -1461,27 +1484,6 @@ out_unlock:
 }
 
 /**
- * disk_block_events - block and flush disk event checking
- * @disk: disk to block events for
- *
- * On return from this function, it is guaranteed that event checking
- * isn't in progress and won't happen until unblocked by
- * disk_unblock_events().  Events blocking is counted and the actual
- * unblocking happens after the matching number of unblocks are done.
- *
- * Note that this intentionally does not block event checking from
- * disk_clear_events().
- *
- * CONTEXT:
- * Might sleep.
- */
-void disk_block_events(struct gendisk *disk)
-{
-	if (disk->ev)
-		__disk_block_events(disk, true);
-}
-
-/**
  * disk_unblock_events - unblock disk event checking
  * @disk: disk to unblock events for
  *
@@ -1508,10 +1510,18 @@ void disk_unblock_events(struct gendisk *disk)
  */
 void disk_check_events(struct gendisk *disk)
 {
-	if (disk->ev) {
-		__disk_block_events(disk, false);
-		__disk_unblock_events(disk, true);
+	struct disk_events *ev = disk->ev;
+	unsigned long flags;
+
+	if (!ev)
+		return;
+
+	spin_lock_irqsave(&ev->lock, flags);
+	if (!ev->block) {
+		cancel_delayed_work(&ev->dwork);
+		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	}
+	spin_unlock_irqrestore(&ev->lock, flags);
 }
 EXPORT_SYMBOL_GPL(disk_check_events);
 
@@ -1546,7 +1556,7 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	spin_unlock_irq(&ev->lock);
 
 	/* uncondtionally schedule event check and wait for it to finish */
-	__disk_block_events(disk, true);
+	disk_block_events(disk);
 	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
@@ -1664,7 +1674,7 @@ static ssize_t disk_events_poll_msecs_store(struct device *dev,
 	if (intv < 0 && intv != -1)
 		return -EINVAL;
 
-	__disk_block_events(disk, true);
+	disk_block_events(disk);
 	disk->ev->poll_msecs = intv;
 	__disk_unblock_events(disk, true);
 
@@ -1750,6 +1760,7 @@ static void disk_add_events(struct gendisk *disk)
 	INIT_LIST_HEAD(&ev->node);
 	ev->disk = disk;
 	spin_lock_init(&ev->lock);
+	mutex_init(&ev->block_mutex);
 	ev->block = 1;
 	ev->poll_msecs = -1;
 	INIT_DELAYED_WORK(&ev->dwork, disk_events_workfn);
@@ -1770,7 +1781,7 @@ static void disk_del_events(struct gendisk *disk)
 	if (!disk->ev)
 		return;
 
-	__disk_block_events(disk, true);
+	disk_block_events(disk);
 
 	mutex_lock(&disk_events_mutex);
 	list_del_init(&disk->ev->node);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a2421f..610e8e0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -762,7 +762,19 @@ static struct block_device *bd_start_claiming(struct block_device *bdev,
 	if (!disk)
 		return ERR_PTR(-ENXIO);
 
-	whole = bdget_disk(disk, 0);
+	/*
+	 * Normally, @bdev should equal what's returned from bdget_disk()
+	 * if partno is 0; however, some drivers (floppy) use multiple
+	 * bdev's for the same physical device and @bdev may be one of the
+	 * aliases.  Keep @bdev if partno is 0.  This means claimer
+	 * tracking is broken for those devices but it has always been that
+	 * way.
+	 */
+	if (partno)
+		whole = bdget_disk(disk, 0);
+	else
+		whole = bdgrab(bdev);
+
 	module_put(disk->fops->owner);
 	put_disk(disk);
 	if (!whole)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2a7cea5..6395692 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -167,7 +167,7 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index b22fb0d..8c7c2de 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -169,7 +169,8 @@ extern void blk_trace_shutdown(struct request_queue *);
 extern int do_blk_trace_setup(struct request_queue *q, char *name,
 			      dev_t dev, struct block_device *bdev,
 			      struct blk_user_trace_setup *buts);
-extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
+extern __attribute__((format(printf, 2, 3)))
+void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 
 /**
  * blk_add_trace_msg - Add a (simple) message to the blktrace stream

-- 
Jens Axboe

