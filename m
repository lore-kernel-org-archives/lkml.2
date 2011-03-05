Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1CEBDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:03:33 -0500
Received: from kroah.org ([198.145.64.141]:50467 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357Ab1CEBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.538433327@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [61/73] blk-throttle: Do not use kblockd workqueue for throtl work
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vivek Goyal <vgoyal@redhat.com>

commit 450adcbe518ab3a3953d8475309525d22de77cba upstream.

o Dominik Klein reported a system hang issue while doing some blkio
  throttling testing.

  https://lkml.org/lkml/2011/2/24/173

o Some tracing revealed that CFQ was not dispatching any more jobs as
  queue unplug was not happening. And queue unplug was not happening
  because unplug work was not being called as there was one throttling
  work on same cpu which as not finished yet. And throttling work had not
  finished as it was tyring to dispatch a bio to CFQ but all the request
  descriptors were consume to it was put to sleep.

o So basically it is a cyclic dependecny between CFQ unplug work and
  throtl dispatch work. Tejun suggested that use separate workqueue for
  such cases.

o This patch uses a separate workqueue for throttle related work and
  does not rely on kblockd workqueue anymore.

Reported-by: Dominik Klein <dk@in-telegence.net>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c       |    7 -------
 block/blk-throttle.c   |   29 ++++++++++++++++++-----------
 include/linux/blkdev.h |    3 ---
 3 files changed, 18 insertions(+), 21 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2610,13 +2610,6 @@ int kblockd_schedule_work(struct request
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
@@ -337,10 +342,9 @@ static void throtl_schedule_next_dispatc
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
@@ -807,10 +811,10 @@ void blk_throtl_work(struct work_struct
 }
 
 /* Call with queue lock held */
-void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay)
+static void
+throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 {
 
-	struct throtl_data *td = q->td;
 	struct delayed_work *dwork = &td->throtl_work;
 
 	if (total_nr_queued(td) > 0) {
@@ -819,12 +823,11 @@ void throtl_schedule_delayed_work(struct
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
@@ -912,7 +915,7 @@ static void throtl_update_blkio_group_re
 	smp_mb__after_atomic_inc();
 
 	/* Schedule a work now to process the limit change */
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_write_bps(void *key,
@@ -926,7 +929,7 @@ static void throtl_update_blkio_group_wr
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_read_iops(void *key,
@@ -940,7 +943,7 @@ static void throtl_update_blkio_group_re
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_write_iops(void *key,
@@ -954,7 +957,7 @@ static void throtl_update_blkio_group_wr
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 void throtl_shutdown_timer_wq(struct request_queue *q)
@@ -1127,6 +1130,10 @@ void blk_throtl_exit(struct request_queu
 
 static int __init throtl_init(void)
 {
+	kthrotld_workqueue = alloc_workqueue("kthrotld", WQ_MEM_RECLAIM, 0);
+	if (!kthrotld_workqueue)
+		panic("Failed to create kthrotld\n");
+
 	blkio_policy_register(&blkio_policy_throtl);
 	return 0;
 }
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1089,7 +1089,6 @@ static inline void put_dev_sector(Sector
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
-int kblockd_schedule_delayed_work(struct request_queue *q, struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
@@ -1137,7 +1136,6 @@ static inline uint64_t rq_io_start_time_
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
-extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
 extern void throtl_shutdown_timer_wq(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
@@ -1147,7 +1145,6 @@ static inline int blk_throtl_bio(struct
 
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
-static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
 static inline void throtl_shutdown_timer_wq(struct request_queue *q) {}
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 


