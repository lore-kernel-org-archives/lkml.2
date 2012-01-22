Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2AVD0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:26:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2AVDZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:25:44 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/17] block: implement blk_queue_bypass_start/end()
Date: Sat, 21 Jan 2012 19:25:13 -0800
Message-Id: <1327202725-3383-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327202725-3383-1-git-send-email-tj@kernel.org>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename and extend elv_queisce_start/end() to
blk_queue_bypass_start/end() which are exported and supports nesting
via @q->bypass_depth.  Also add blk_queue_bypass() to test bypass
state.

This will be further extended and used for blkio_group management.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c       |   39 +++++++++++++++++++++++++++++++++++++--
 block/blk.h            |    6 ++----
 block/elevator.c       |   25 +++----------------------
 include/linux/blkdev.h |    5 ++++-
 4 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e6c05a9..c2e39de 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -403,6 +403,42 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 }
 
 /**
+ * blk_queue_bypass_start - enter queue bypass mode
+ * @q: queue of interest
+ *
+ * In bypass mode, only the dispatch FIFO queue of @q is used.  This
+ * function makes @q enter bypass mode and drains all requests which were
+ * issued before.  On return, it's guaranteed that no request has ELVPRIV
+ * set.
+ */
+void blk_queue_bypass_start(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	q->bypass_depth++;
+	queue_flag_set(QUEUE_FLAG_BYPASS, q);
+	spin_unlock_irq(q->queue_lock);
+
+	blk_drain_queue(q, false);
+}
+EXPORT_SYMBOL_GPL(blk_queue_bypass_start);
+
+/**
+ * blk_queue_bypass_end - leave queue bypass mode
+ * @q: queue of interest
+ *
+ * Leave bypass mode and restore the normal queueing behavior.
+ */
+void blk_queue_bypass_end(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!--q->bypass_depth)
+		queue_flag_clear(QUEUE_FLAG_BYPASS, q);
+	WARN_ON_ONCE(q->bypass_depth < 0);
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL_GPL(blk_queue_bypass_end);
+
+/**
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
  *
@@ -859,8 +895,7 @@ retry:
 	 * Also, lookup icq while holding queue_lock.  If it doesn't exist,
 	 * it will be created after releasing queue_lock.
 	 */
-	if (blk_rq_should_init_elevator(bio) &&
-	    !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags)) {
+	if (blk_rq_should_init_elevator(bio) && !blk_queue_bypass(q)) {
 		rw_flags |= REQ_ELVPRIV;
 		rl->elvpriv++;
 		if (et->icq_cache && ioc)
diff --git a/block/blk.h b/block/blk.h
index 7efd772..33897f6 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -23,7 +23,8 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio);
-void blk_drain_queue(struct request_queue *q, bool drain_all);
+void blk_queue_bypass_start(struct request_queue *q);
+void blk_queue_bypass_end(struct request_queue *q);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
@@ -142,9 +143,6 @@ void blk_queue_congestion_threshold(struct request_queue *q);
 
 int blk_dev_init(void);
 
-void elv_quiesce_start(struct request_queue *q);
-void elv_quiesce_end(struct request_queue *q);
-
 
 /*
  * Return the threshold (number of used requests) at which the queue is
diff --git a/block/elevator.c b/block/elevator.c
index 8dc65b1..078a491 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -600,25 +600,6 @@ void elv_drain_elevator(struct request_queue *q)
 	}
 }
 
-void elv_quiesce_start(struct request_queue *q)
-{
-	if (!q->elevator)
-		return;
-
-	spin_lock_irq(q->queue_lock);
-	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
-	spin_unlock_irq(q->queue_lock);
-
-	blk_drain_queue(q, false);
-}
-
-void elv_quiesce_end(struct request_queue *q)
-{
-	spin_lock_irq(q->queue_lock);
-	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
-	spin_unlock_irq(q->queue_lock);
-}
-
 void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
@@ -950,7 +931,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	 * using INSERT_BACK.  All requests have SOFTBARRIER set and no
 	 * merge happens either.
 	 */
-	elv_quiesce_start(q);
+	blk_queue_bypass_start(q);
 
 	/* unregister and clear all auxiliary data of the old elevator */
 	if (registered)
@@ -980,7 +961,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 
 	/* done, kill the old one and finish */
 	elevator_exit(old);
-	elv_quiesce_end(q);
+	blk_queue_bypass_end(q);
 
 	blk_add_trace_msg(q, "elv switch: %s", e->type->elevator_name);
 
@@ -992,7 +973,7 @@ fail_init:
 	/* switch failed, restore and re-register old elevator */
 	q->elevator = old;
 	elv_register_queue(q);
-	elv_quiesce_end(q);
+	blk_queue_bypass_end(q);
 
 	return err;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6c6a1f0..f10958b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -389,6 +389,8 @@ struct request_queue {
 
 	struct mutex		sysfs_lock;
 
+	int			bypass_depth;
+
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
 	int			bsg_job_size;
@@ -409,7 +411,7 @@ struct request_queue {
 #define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
 #define QUEUE_FLAG_ASYNCFULL	4	/* write queue has been filled */
 #define QUEUE_FLAG_DEAD		5	/* queue being torn down */
-#define QUEUE_FLAG_ELVSWITCH	6	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_BYPASS	6	/* act as dumb FIFO queue */
 #define QUEUE_FLAG_BIDI		7	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES     8	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	9	/* complete on same CPU-group */
@@ -497,6 +499,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
+#define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
-- 
1.7.7.3

