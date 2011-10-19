Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1JSE0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab1JSE0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:42 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] block: reorganize queue draining
Date: Tue, 18 Oct 2011 21:26:20 -0700
Message-Id: <1318998384-22525-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize queue draining related code in preparation of queue exit
changes.

* Factor out actual draining from elv_quiesce_start() to
  blk_drain_queue().

* Make elv_quiesce_start/end() responsible for their own locking.

* Replace open-coded ELVSWITCH clearing in elevator_switch() with
  elv_quiesce_end().

This patch doesn't cause any visible functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   28 ++++++++++++++++++++++++++++
 block/blk.h      |    1 +
 block/elevator.c |   37 +++++++++++--------------------------
 3 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fafa669..50e3144 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -28,6 +28,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/fault-inject.h>
 #include <linux/list_sort.h>
+#include <linux/delay.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -345,6 +346,33 @@ void blk_put_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_put_queue);
 
+/**
+ * blk_drain_queue - drain requests from request_queue
+ * @q: queue to drain
+ *
+ * Drain ELV_PRIV requests from @q.  The caller is responsible for ensuring
+ * that no new requests which need to be drained are queued.
+ */
+void blk_drain_queue(struct request_queue *q)
+{
+	while (true) {
+		int nr_rqs;
+
+		spin_lock_irq(q->queue_lock);
+
+		elv_drain_elevator(q);
+
+		__blk_run_queue(q);
+		nr_rqs = q->rq.elvpriv;
+
+		spin_unlock_irq(q->queue_lock);
+
+		if (!nr_rqs)
+			break;
+		msleep(10);
+	}
+}
+
 /*
  * Note: If a driver supplied the queue lock, it should not zap that lock
  * unexpectedly as some queue cleanup components like elevator_exit() and
diff --git a/block/blk.h b/block/blk.h
index da247ba..2b66dc2 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -15,6 +15,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio);
+void blk_drain_queue(struct request_queue *q);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
diff --git a/block/elevator.c b/block/elevator.c
index cb332cb..74a277f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/compiler.h>
-#include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/hash.h>
 #include <linux/uaccess.h>
@@ -606,43 +605,35 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
+
+	lockdep_assert_held(q->queue_lock);
+
 	while (q->elevator->ops->elevator_dispatch_fn(q, 1))
 		;
-	if (q->nr_sorted == 0)
-		return;
-	if (printed++ < 10) {
+	if (q->nr_sorted && printed++ < 10) {
 		printk(KERN_ERR "%s: forced dispatching is broken "
 		       "(nr_sorted=%u), please report this\n",
 		       q->elevator->elevator_type->elevator_name, q->nr_sorted);
 	}
 }
 
-/*
- * Call with queue lock held, interrupts disabled
- */
 void elv_quiesce_start(struct request_queue *q)
 {
 	if (!q->elevator)
 		return;
 
+	spin_lock_irq(q->queue_lock);
 	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
+	spin_unlock_irq(q->queue_lock);
 
-	/*
-	 * make sure we don't have any requests in flight
-	 */
-	elv_drain_elevator(q);
-	while (q->rq.elvpriv) {
-		__blk_run_queue(q);
-		spin_unlock_irq(q->queue_lock);
-		msleep(10);
-		spin_lock_irq(q->queue_lock);
-		elv_drain_elevator(q);
-	}
+	blk_drain_queue(q);
 }
 
 void elv_quiesce_end(struct request_queue *q)
 {
+	spin_lock_irq(q->queue_lock);
 	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
+	spin_unlock_irq(q->queue_lock);
 }
 
 void __elv_add_request(struct request_queue *q, struct request *rq, int where)
@@ -972,7 +963,6 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	/*
 	 * Turn on BYPASS and drain all requests w/ elevator private data
 	 */
-	spin_lock_irq(q->queue_lock);
 	elv_quiesce_start(q);
 
 	/*
@@ -983,8 +973,8 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	/*
 	 * attach and start new elevator
 	 */
+	spin_lock_irq(q->queue_lock);
 	elevator_attach(q, e, data);
-
 	spin_unlock_irq(q->queue_lock);
 
 	if (old_elevator->registered) {
@@ -999,9 +989,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	 * finally exit old elevator and turn off BYPASS.
 	 */
 	elevator_exit(old_elevator);
-	spin_lock_irq(q->queue_lock);
 	elv_quiesce_end(q);
-	spin_unlock_irq(q->queue_lock);
 
 	blk_add_trace_msg(q, "elv switch: %s", e->elevator_type->elevator_name);
 
@@ -1015,10 +1003,7 @@ fail_register:
 	elevator_exit(e);
 	q->elevator = old_elevator;
 	elv_register_queue(q);
-
-	spin_lock_irq(q->queue_lock);
-	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
-	spin_unlock_irq(q->queue_lock);
+	elv_quiesce_end(q);
 
 	return err;
 }
-- 
1.7.3.1

