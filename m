Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1CCRBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:01:43 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:56303 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab1CCRBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:01:42 -0500
X-ASG-Debug-ID: 1299171695-01de280c5312f7d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D6FC96B.5050009@fusionio.com>
Date: Thu, 3 Mar 2011 12:01:31 -0500
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Important fixes for 2.6.38
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Important fixes for 2.6.38
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299171695
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.56948
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a LOT larger than I would like at this point in time,
but all of them are fixing important bugs. Well except the kerneldoc
change, but that is harmless.

- The block BKL conversion introduced a deadlock in loop, since the
  mutex isn't recursive like the BKL is. This private mutex isn't
  needed, so get rid of it.

- Fix a problem where blktrace does not detect the right request type.
  So we miss things like a SYNC tag.

- Fix a bug triggering on IDE due to how we handle flush completions.
  This is causing crashes.

- Fix a deadlock in the throttling code due to using kblockd.

Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Ben Hutchings (1):
      block: fix kernel-doc format for blkdev_issue_zeroout

Petr Uzel (1):
      block: kill loop_mutex

Tao Ma (1):
      blktrace: Remove blk_fill_rwbs_rq.

Tejun Heo (2):
      block: add @force_kblockd to __blk_run_queue()
      block: blk-flush shouldn't call directly into q->request_fn() __blk_run_queue()

Vivek Goyal (1):
      blk-throttle: Do not use kblockd workqueue for throtl work

 block/blk-core.c                 |   18 ++++++------------
 block/blk-flush.c                |    8 +++++---
 block/blk-lib.c                  |    2 +-
 block/blk-throttle.c             |   29 ++++++++++++++++++-----------
 block/cfq-iosched.c              |    6 +++---
 block/elevator.c                 |    4 ++--
 drivers/block/loop.c             |    5 -----
 drivers/scsi/scsi_lib.c          |    2 +-
 drivers/scsi/scsi_transport_fc.c |    2 +-
 include/linux/blkdev.h           |    5 +----
 include/linux/blktrace_api.h     |    1 -
 include/trace/events/block.h     |    6 +++---
 kernel/trace/blktrace.c          |   16 ----------------
 13 files changed, 41 insertions(+), 63 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2f4002f..518dd42 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -352,7 +352,7 @@ void blk_start_queue(struct request_queue *q)
 	WARN_ON(!irqs_disabled());
 
 	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
-	__blk_run_queue(q);
+	__blk_run_queue(q, false);
 }
 EXPORT_SYMBOL(blk_start_queue);
 
@@ -403,13 +403,14 @@ EXPORT_SYMBOL(blk_sync_queue);
 /**
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
+ * @force_kblockd: Don't run @q->request_fn directly.  Use kblockd.
  *
  * Description:
  *    See @blk_run_queue. This variant must be called with the queue lock
  *    held and interrupts disabled.
  *
  */
-void __blk_run_queue(struct request_queue *q)
+void __blk_run_queue(struct request_queue *q, bool force_kblockd)
 {
 	blk_remove_plug(q);
 
@@ -423,7 +424,7 @@ void __blk_run_queue(struct request_queue *q)
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
-	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
+	if (!force_kblockd && !queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
 		q->request_fn(q);
 		queue_flag_clear(QUEUE_FLAG_REENTER, q);
 	} else {
@@ -446,7 +447,7 @@ void blk_run_queue(struct request_queue *q)
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_run_queue(q);
+	__blk_run_queue(q, false);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_run_queue);
@@ -1053,7 +1054,7 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 
 	drive_stat_acct(rq, 1);
 	__elv_add_request(q, rq, where, 0);
-	__blk_run_queue(q);
+	__blk_run_queue(q, false);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_insert_request);
@@ -2610,13 +2611,6 @@ int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-int kblockd_schedule_delayed_work(struct request_queue *q,
-			struct delayed_work *dwork, unsigned long delay)
-{
-	return queue_delayed_work(kblockd_workqueue, dwork, delay);
-}
-EXPORT_SYMBOL(kblockd_schedule_delayed_work);
-
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 54b123d..b27d020 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -66,10 +66,12 @@ static void blk_flush_complete_seq_end_io(struct request_queue *q,
 
 	/*
 	 * Moving a request silently to empty queue_head may stall the
-	 * queue.  Kick the queue in those cases.
+	 * queue.  Kick the queue in those cases.  This function is called
+	 * from request completion path and calling directly into
+	 * request_fn may confuse the driver.  Always use kblockd.
 	 */
 	if (was_empty && next_rq)
-		__blk_run_queue(q);
+		__blk_run_queue(q, true);
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -130,7 +132,7 @@ static struct request *queue_next_fseq(struct request_queue *q)
 		BUG();
 	}
 
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
 	return rq;
 }
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1a320d2..eec78be 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -132,7 +132,7 @@ static void bio_batch_end_io(struct bio *bio, int err)
 }
 
 /**
- * blkdev_issue_zeroout generate number of zero filed write bios
+ * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a89043a..e36cc10 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -20,6 +20,11 @@ static int throtl_quantum = 32;
 /* Throttling is performed over 100ms slice and after that slice is renewed */
 static unsigned long throtl_slice = HZ/10;	/* 100 ms */
 
+/* A workqueue to queue throttle related work */
+static struct workqueue_struct *kthrotld_workqueue;
+static void throtl_schedule_delayed_work(struct throtl_data *td,
+				unsigned long delay);
+
 struct throtl_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
@@ -345,10 +350,9 @@ static void throtl_schedule_next_dispatch(struct throtl_data *td)
 	update_min_dispatch_time(st);
 
 	if (time_before_eq(st->min_disptime, jiffies))
-		throtl_schedule_delayed_work(td->queue, 0);
+		throtl_schedule_delayed_work(td, 0);
 	else
-		throtl_schedule_delayed_work(td->queue,
-				(st->min_disptime - jiffies));
+		throtl_schedule_delayed_work(td, (st->min_disptime - jiffies));
 }
 
 static inline void
@@ -815,10 +819,10 @@ void blk_throtl_work(struct work_struct *work)
 }
 
 /* Call with queue lock held */
-void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay)
+static void
+throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 {
 
-	struct throtl_data *td = q->td;
 	struct delayed_work *dwork = &td->throtl_work;
 
 	if (total_nr_queued(td) > 0) {
@@ -827,12 +831,11 @@ void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay)
 		 * Cancel that and schedule a new one.
 		 */
 		__cancel_delayed_work(dwork);
-		kblockd_schedule_delayed_work(q, dwork, delay);
+		queue_delayed_work(kthrotld_workqueue, dwork, delay);
 		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
 				delay, jiffies);
 	}
 }
-EXPORT_SYMBOL(throtl_schedule_delayed_work);
 
 static void
 throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
@@ -920,7 +923,7 @@ static void throtl_update_blkio_group_read_bps(void *key,
 	smp_mb__after_atomic_inc();
 
 	/* Schedule a work now to process the limit change */
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_write_bps(void *key,
@@ -934,7 +937,7 @@ static void throtl_update_blkio_group_write_bps(void *key,
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_read_iops(void *key,
@@ -948,7 +951,7 @@ static void throtl_update_blkio_group_read_iops(void *key,
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_write_iops(void *key,
@@ -962,7 +965,7 @@ static void throtl_update_blkio_group_write_iops(void *key,
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 void throtl_shutdown_timer_wq(struct request_queue *q)
@@ -1135,6 +1138,10 @@ void blk_throtl_exit(struct request_queue *q)
 
 static int __init throtl_init(void)
 {
+	kthrotld_workqueue = alloc_workqueue("kthrotld", WQ_MEM_RECLAIM, 0);
+	if (!kthrotld_workqueue)
+		panic("Failed to create kthrotld\n");
+
 	blkio_policy_register(&blkio_policy_throtl);
 	return 0;
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7be4c79..ea83a4f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3355,7 +3355,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			    cfqd->busy_queues > 1) {
 				cfq_del_timer(cfqd, cfqq);
 				cfq_clear_cfqq_wait_request(cfqq);
-				__blk_run_queue(cfqd->queue);
+				__blk_run_queue(cfqd->queue, false);
 			} else {
 				cfq_blkiocg_update_idle_time_stats(
 						&cfqq->cfqg->blkg);
@@ -3370,7 +3370,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 * this new queue is RT and the current one is BE
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
-		__blk_run_queue(cfqd->queue);
+		__blk_run_queue(cfqd->queue, false);
 	}
 }
 
@@ -3731,7 +3731,7 @@ static void cfq_kick_queue(struct work_struct *work)
 	struct request_queue *q = cfqd->queue;
 
 	spin_lock_irq(q->queue_lock);
-	__blk_run_queue(cfqd->queue);
+	__blk_run_queue(cfqd->queue, false);
 	spin_unlock_irq(q->queue_lock);
 }
 
diff --git a/block/elevator.c b/block/elevator.c
index 2569512..236e93c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -602,7 +602,7 @@ void elv_quiesce_start(struct request_queue *q)
 	 */
 	elv_drain_elevator(q);
 	while (q->rq.elvpriv) {
-		__blk_run_queue(q);
+		__blk_run_queue(q, false);
 		spin_unlock_irq(q->queue_lock);
 		msleep(10);
 		spin_lock_irq(q->queue_lock);
@@ -651,7 +651,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 *   with anything.  There's no point in delaying queue
 		 *   processing.
 		 */
-		__blk_run_queue(q);
+		__blk_run_queue(q, false);
 		break;
 
 	case ELEVATOR_INSERT_SORT:
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 49e6a54..dbf31ec 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -78,7 +78,6 @@
 
 #include <asm/uaccess.h>
 
-static DEFINE_MUTEX(loop_mutex);
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
@@ -1501,11 +1500,9 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
 
-	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
-	mutex_unlock(&loop_mutex);
 
 	return 0;
 }
@@ -1515,7 +1512,6 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 	struct loop_device *lo = disk->private_data;
 	int err;
 
-	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
@@ -1540,7 +1536,6 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
 out_unlocked:
-	mutex_unlock(&loop_mutex);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9045c52..fb2bb35 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -443,7 +443,7 @@ static void scsi_run_queue(struct request_queue *q)
 					&sdev->request_queue->queue_flags);
 		if (flagset)
 			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
-		__blk_run_queue(sdev->request_queue);
+		__blk_run_queue(sdev->request_queue, false);
 		if (flagset)
 			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..5c3ccfc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3829,7 +3829,7 @@ fc_bsg_goose_queue(struct fc_rport *rport)
 		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
 	if (flagset)
 		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q);
+	__blk_run_queue(rport->rqst_q, false);
 	if (flagset)
 		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
 	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d18ff3..d5063e1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -699,7 +699,7 @@ extern void blk_start_queue(struct request_queue *q);
 extern void blk_stop_queue(struct request_queue *q);
 extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
-extern void __blk_run_queue(struct request_queue *);
+extern void __blk_run_queue(struct request_queue *q, bool force_kblockd);
 extern void blk_run_queue(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
@@ -1088,7 +1088,6 @@ static inline void put_dev_sector(Sector p)
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
-int kblockd_schedule_delayed_work(struct request_queue *q, struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
@@ -1136,7 +1135,6 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
-extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
 extern void throtl_shutdown_timer_wq(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
@@ -1146,7 +1144,6 @@ static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
 
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
-static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
 static inline void throtl_shutdown_timer_wq(struct request_queue *q) {}
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3395cf7..b22fb0d 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -245,7 +245,6 @@ static inline int blk_cmd_buf_len(struct request *rq)
 
 extern void blk_dump_cmd(char *buf, struct request *rq);
 extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
-extern void blk_fill_rwbs_rq(char *rwbs, struct request *rq);
 
 #endif /* CONFIG_EVENT_TRACING && CONFIG_BLOCK */
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index aba421d..78f18ad 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 					0 : blk_rq_sectors(rq);
 		__entry->errors    = rq->errors;
 
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
@@ -118,7 +118,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__entry->bytes     = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 					blk_rq_bytes(rq) : 0;
 
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		blk_dump_cmd(__get_str(cmd), rq);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -563,7 +563,7 @@ TRACE_EVENT(block_rq_remap,
 		__entry->nr_sector	= blk_rq_sectors(rq);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d95721f..cbafed7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1827,21 +1827,5 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 	rwbs[i] = '\0';
 }
 
-void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
-{
-	int rw = rq->cmd_flags & 0x03;
-	int bytes;
-
-	if (rq->cmd_flags & REQ_DISCARD)
-		rw |= REQ_DISCARD;
-
-	if (rq->cmd_flags & REQ_SECURE)
-		rw |= REQ_SECURE;
-
-	bytes = blk_rq_bytes(rq);
-
-	blk_fill_rwbs(rwbs, rw, bytes);
-}
-
 #endif /* CONFIG_EVENT_TRACING */
 

-- 
Jens Axboe

