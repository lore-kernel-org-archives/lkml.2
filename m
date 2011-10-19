Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1JSE04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1JSE0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] block: fix request_queue lifetime handling by making blk_queue_cleanup() proper shutdown
Date: Tue, 18 Oct 2011 21:26:24 -0700
Message-Id: <1318998384-22525-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_queue is refcounted but actually depdends on lifetime
management from the queue owner - on blk_cleanup_queue(), block layer
expects that there's no request passing through request_queue and no
new one will.

This is fundamentally broken.  The queue owner (e.g. SCSI layer)
doesn't have a way to know whether there are other active users before
calling blk_cleanup_queue() and other users (e.g. bsg) don't have any
guarantee that the queue is and would stay valid while it's holding a
reference.

With delay added in blk_queue_bio() before queue_lock is grabbed, the
following oops can be easily triggered when a device is removed with
in-flight IOs.

 sd 0:0:1:0: [sdb] Stopping disk
 ata1.01: disabled
 general protection fault: 0000 [#1] PREEMPT SMP
 CPU 2
 Modules linked in:

 Pid: 648, comm: test_rawio Not tainted 3.1.0-rc3-work+ #56 Bochs Bochs
 RIP: 0010:[<ffffffff8137d651>]  [<ffffffff8137d651>] elv_rqhash_find+0x61/0x100
 ...
 Process test_rawio (pid: 648, threadinfo ffff880019efa000, task ffff880019ef8a80)
 ...
 Call Trace:
  [<ffffffff8137d774>] elv_merge+0x84/0xe0
  [<ffffffff81385b54>] blk_queue_bio+0xf4/0x400
  [<ffffffff813838ea>] generic_make_request+0xca/0x100
  [<ffffffff81383994>] submit_bio+0x74/0x100
  [<ffffffff811c53ec>] dio_bio_submit+0xbc/0xc0
  [<ffffffff811c610e>] __blockdev_direct_IO+0x92e/0xb40
  [<ffffffff811c39f7>] blkdev_direct_IO+0x57/0x60
  [<ffffffff8113b1c5>] generic_file_aio_read+0x6d5/0x760
  [<ffffffff8118c1ca>] do_sync_read+0xda/0x120
  [<ffffffff8118ce55>] vfs_read+0xc5/0x180
  [<ffffffff8118cfaa>] sys_pread64+0x9a/0xb0
  [<ffffffff81afaf6b>] system_call_fastpath+0x16/0x1b

This happens because blk_queue_cleanup() destroys the queue and
elevator whether IOs are in progress or not and DEAD tests are
sprinkled in the request processing path without proper
synchronization.

Similar problem exists for blk-throtl.  On queue cleanup, blk-throtl
is shutdown whether it has requests in it or not.  Depending on
timing, it either oopses or throttled bios are lost putting tasks
which are waiting for bio completion into eternal D state.

The way it should work is having the usual clear distinction between
shutdown and release.  Shutdown drains all currently pending requests,
marks the queue dead, and performs partial teardown of the now
unnecessary part of the queue.  Even after shutdown is complete,
reference holders are still allowed to issue requests to the queue
although they will be immmediately failed.  The rest of teardown
happens on release.

This patch makes the following changes to make blk_queue_cleanup()
behave as proper shutdown.

* QUEUE_FLAG_DEAD is now set while holding both q->exit_mutex and
  queue_lock.

* Unsynchronized DEAD check in generic_make_request_checks() removed.
  This couldn't make any meaningful difference as the queue could die
  after the check.

* blk_drain_queue() updated such that it can drain all requests and is
  now called during cleanup.

* blk_throtl updated such that it checks DEAD on grabbing queue_lock,
  drains all throttled bios during cleanup and free td when queue is
  released.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |   54 ++++++++++++++++++++++++++++++-------------------
 block/blk-sysfs.c    |    1 +
 block/blk-throttle.c |   50 ++++++++++++++++++++++++++++++++++++++++-----
 block/blk.h          |    6 ++++-
 block/elevator.c     |    2 +-
 5 files changed, 84 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2425989..007d401 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -349,11 +349,13 @@ EXPORT_SYMBOL(blk_put_queue);
 /**
  * blk_drain_queue - drain requests from request_queue
  * @q: queue to drain
+ * @drain_all: whether to drain all requests or only the ones w/ ELVPRIV
  *
- * Drain ELV_PRIV requests from @q.  The caller is responsible for ensuring
- * that no new requests which need to be drained are queued.
+ * Drain requests from @q.  If @drain_all is set, all requests are drained.
+ * If not, only ELVPRIV requests are drained.  The caller is responsible
+ * for ensuring that no new requests which need to be drained are queued.
  */
-void blk_drain_queue(struct request_queue *q)
+void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
 	while (true) {
 		int nr_rqs;
@@ -361,9 +363,15 @@ void blk_drain_queue(struct request_queue *q)
 		spin_lock_irq(q->queue_lock);
 
 		elv_drain_elevator(q);
+		if (drain_all)
+			blk_throtl_drain(q);
 
 		__blk_run_queue(q);
-		nr_rqs = q->rq.elvpriv;
+
+		if (drain_all)
+			nr_rqs = q->rq.count[0] + q->rq.count[1];
+		else
+			nr_rqs = q->rq.elvpriv;
 
 		spin_unlock_irq(q->queue_lock);
 
@@ -373,29 +381,36 @@ void blk_drain_queue(struct request_queue *q)
 	}
 }
 
-/*
+/**
+ * blk_cleanup_queue - shutdown a request queue
+ * @q: request queue to shutdown
+ *
+ * Mark @q DEAD, drain all pending requests, destroy and put it.  All
+ * future requests will be failed immediately with -ENODEV.
  * Note: If a driver supplied the queue lock, it should not zap that lock
- * unexpectedly as some queue cleanup components like elevator_exit() and
- * blk_throtl_exit() need queue lock.
+ * unexpectedly as queue cleanup needs queue lock.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
-	/*
-	 * We know we have process context here, so we can be a little
-	 * cautious and ensure that pending block actions on this device
-	 * are done before moving on. Going into this function, we should
-	 * not have processes doing IO to this device.
-	 */
-	blk_sync_queue(q);
-
-	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
+	/* mark @q DEAD, no new request or merges will be allowed afterwards */
 	mutex_lock(&q->sysfs_lock);
-	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
+	spin_lock_irq(q->queue_lock);
+	queue_flag_set(QUEUE_FLAG_NOMERGES, q);
+	queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
+	queue_flag_set(QUEUE_FLAG_DEAD, q);
+	spin_unlock_irq(q->queue_lock);
 	mutex_unlock(&q->sysfs_lock);
 
+	/* drain all requests queued before DEAD marking */
+	blk_drain_queue(q, true);
+
+	/* @q won't process any more request, flush async actions */
+	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
+	blk_sync_queue(q);
+
+	/* @q is and will stay empty, shutdown and put */
 	if (q->elevator)
 		elevator_exit(q->elevator);
-
 	blk_throtl_exit(q);
 
 	blk_put_queue(q);
@@ -1510,9 +1525,6 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
-		goto end_io;
-
 	part = bio->bi_bdev->bd_part;
 	if (should_fail_request(part, bio->bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 7171b78..1b21459 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -485,6 +485,7 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	blk_throtl_release(q);
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 900a0c9..8edb949 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -309,6 +309,10 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	struct blkio_cgroup *blkcg;
 	struct request_queue *q = td->queue;
 
+	/* no throttling for dead queue */
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
 	tg = throtl_find_tg(td, blkcg);
@@ -1001,11 +1005,6 @@ static void throtl_release_tgs(struct throtl_data *td)
 	}
 }
 
-static void throtl_td_free(struct throtl_data *td)
-{
-	kfree(td);
-}
-
 /*
  * Blk cgroup controller notification saying that blkio_group object is being
  * delinked as associated cgroup object is going away. That also means that
@@ -1204,6 +1203,41 @@ out:
 	return throttled;
 }
 
+/**
+ * blk_throtl_drain - drain throttled bios
+ * @q: request_queue to drain throttled bios for
+ *
+ * Dispatch all currently throttled bios on @q through ->make_request_fn().
+ */
+void blk_throtl_drain(struct request_queue *q)
+	__releases(q->queue_lock) __acquires(q->queue_lock)
+{
+	struct throtl_data *td = q->td;
+	struct throtl_rb_root *st = &td->tg_service_tree;
+	struct throtl_grp *tg;
+	struct bio_list bl;
+	struct bio *bio;
+
+	lockdep_is_held(q->queue_lock);
+
+	bio_list_init(&bl);
+
+	while ((tg = throtl_rb_first(st))) {
+		throtl_dequeue_tg(td, tg);
+
+		while ((bio = bio_list_peek(&tg->bio_lists[READ])))
+			tg_dispatch_one_bio(td, tg, bio_data_dir(bio), &bl);
+		while ((bio = bio_list_peek(&tg->bio_lists[WRITE])))
+			tg_dispatch_one_bio(td, tg, bio_data_dir(bio), &bl);
+	}
+	spin_unlock_irq(q->queue_lock);
+
+	while ((bio = bio_list_pop(&bl)))
+		generic_make_request(bio);
+
+	spin_lock_irq(q->queue_lock);
+}
+
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
@@ -1276,7 +1310,11 @@ void blk_throtl_exit(struct request_queue *q)
 	 * it.
 	 */
 	throtl_shutdown_wq(q);
-	throtl_td_free(td);
+}
+
+void blk_throtl_release(struct request_queue *q)
+{
+	kfree(q->td);
 }
 
 static int __init throtl_init(void)
diff --git a/block/blk.h b/block/blk.h
index c018dba..3f6551b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -15,7 +15,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio);
-void blk_drain_queue(struct request_queue *q);
+void blk_drain_queue(struct request_queue *q, bool drain_all);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
@@ -191,15 +191,19 @@ static inline int blk_do_io_stat(struct request *rq)
 
 #ifdef CONFIG_BLK_DEV_THROTTLING
 extern bool blk_throtl_bio(struct request_queue *q, struct bio *bio);
+extern void blk_throtl_drain(struct request_queue *q);
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
+extern void blk_throtl_release(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 {
 	return false;
 }
+static inline void blk_throtl_drain(struct request_queue *q) { }
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
+static inline void blk_throtl_release(struct request_queue *q) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
 #endif /* BLK_INTERNAL_H */
diff --git a/block/elevator.c b/block/elevator.c
index 74a277f..66343d6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -626,7 +626,7 @@ void elv_quiesce_start(struct request_queue *q)
 	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
 	spin_unlock_irq(q->queue_lock);
 
-	blk_drain_queue(q);
+	blk_drain_queue(q, false);
 }
 
 void elv_quiesce_end(struct request_queue *q)
-- 
1.7.3.1

