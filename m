Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1B1PwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:52:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab1B1PwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:52:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: stable@kernel.org, dk@in-telegence.net, tj@kernel.org, vgoyal@redhat.com
Subject: [PATCH] blk-thrttole: Do not use kblockd workqueue for throtl work
Date: Mon, 28 Feb 2011 10:51:45 -0500
Message-Id: <1298908305-12032-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Dominik Klein reported a system hang issue while doing some blkio throttling
  testing.

  https://lkml.org/lkml/2011/2/24/173

o Some tracing revealed that CFQ was not dispatching any more jobs as queue
  unplug was not happening. And queue unplug was not happening because unplug
  work was not being called as there was one throttling work on same cpu
  which as not finished yet. And throttling work had not finished as it
  was tyring to dispatch a bio to CFQ but all the request descriptors were
  consume to it was put to sleep.

o So basically it is a cyclic dependecny between CFQ unplug work and throtl
  dispatch work. Tejun suggested that use separate workqueue for such cases.

o This patch uses a separate workqueue for throttle related work and does not
  rely on kblockd workqueue anymore.

Cc: stable@kernel.org
Reported-by: Dominik Klein <dk@in-telegence.net>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c       |    7 -------
 block/blk-throttle.c   |   29 ++++++++++++++++++-----------
 include/linux/blkdev.h |    3 ---
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3cc17e6..30bf0bc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2623,13 +2623,6 @@ int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e3ee74f..63b4cff 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1095,7 +1095,6 @@ static inline void put_dev_sector(Sector p)
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
-int kblockd_schedule_delayed_work(struct request_queue *q, struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
@@ -1143,7 +1142,6 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
-extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
 extern void throtl_shutdown_timer_wq(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
@@ -1153,7 +1151,6 @@ static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
 
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
-static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
 static inline void throtl_shutdown_timer_wq(struct request_queue *q) {}
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
-- 
1.7.2.3

