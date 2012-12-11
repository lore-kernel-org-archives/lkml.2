Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2LKNhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:37:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4706 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2LKNhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:37:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6922"; a="13143288"
From: Tanya Brokhman <tlinder@codeaurora.org>
To: jaxboe@fusionio.com
Cc: linux-arm-msm@vger.kernel.org, philippedeswert@gmail.com, jengelh@inai.de,
        jh80.chung@samsung.com, tgih.jun@samsung.com, arnd.bergmann@linaro.org,
        venkat@linaro.org, linux-mmc@vger.kernel.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/2] block: Add API for urgent request handling
Date: Tue, 11 Dec 2012 15:36:55 +0200
Message-Id: <1355233015-25196-3-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1355233015-25196-1-git-send-email-tlinder@codeaurora.org>
References: <1355233015-25196-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatyana Brokhman <tlinder@codeaurora.org>

This patch add support in block & elevator layers for handling
urgent requests. The decision if a request is urgent or not is taken
by the scheduler. Urgent request notification is passed to the underlying
block device driver (eMMC for example). Block device driver may decide to
interrupt the currently running low priority request to serve the new
urgent request. By doing so READ latency is greatly reduced in read&write
collision scenarios.

Note that if the current scheduler doesn't implement the urgent request
mechanism, this code path is never activated.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
v3:
  - Commenting update
  - Add boolean flag indicating if an urgent request was dispatched,
    instead of a pointer to the request itself
  - In elv_completed_request() use test_bit() to verify if the completed
    request was urgent or not
v1: Initial version

diff --git a/block/blk-core.c b/block/blk-core.c
index f8f6762..eb0f2ae 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -300,13 +300,26 @@ EXPORT_SYMBOL(blk_sync_queue);
  * Description:
  *    See @blk_run_queue. This variant must be called with the queue lock
  *    held and interrupts disabled.
+ *    Device driver will be notified of an urgent request
+ *    pending under the following conditions:
+ *    1. The driver and the current scheduler support urgent reques handling
+ *    2. There is an urgent request pending in the scheduler
+ *    3. There isn't already an urgent request in flight, meaning previously
+ *       notified urgent request completed (!q->notified_urgent)
  */
 void __blk_run_queue(struct request_queue *q)
 {
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	q->request_fn(q);
+	if (!q->notified_urgent &&
+		q->elevator->type->ops.elevator_is_urgent_fn &&
+		q->urgent_request_fn &&
+		q->elevator->type->ops.elevator_is_urgent_fn(q)) {
+		q->notified_urgent = true;
+		q->urgent_request_fn(q);
+	} else
+		q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -2232,8 +2245,17 @@ struct request *blk_fetch_request(struct request_queue *q)
 	struct request *rq;
 
 	rq = blk_peek_request(q);
-	if (rq)
+	if (rq) {
+		/*
+		 * Assumption: the next request fetched from scheduler after we
+		 * notified "urgent request pending" - will be the urgent one
+		 */
+		if (q->notified_urgent && !q->dispatched_urgent) {
+			q->dispatched_urgent = true;
+			(void)blk_mark_rq_urgent(rq);
+		}
 		blk_start_request(rq);
+	}
 	return rq;
 }
 EXPORT_SYMBOL(blk_fetch_request);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 779bb76..6d594c4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -100,6 +100,18 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
 /**
+ * blk_urgent_request() - Set an urgent_request handler function for queue
+ * @q:		queue
+ * @fn:		handler for urgent requests
+ *
+ */
+void blk_urgent_request(struct request_queue *q, request_fn_proc *fn)
+{
+	q->urgent_request_fn = fn;
+}
+EXPORT_SYMBOL(blk_urgent_request);
+
+/**
  * blk_set_default_limits - reset limits to default values
  * @lim:  the queue_limits structure to reset
  *
diff --git a/block/blk.h b/block/blk.h
index ca51543..5fba856 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -42,6 +42,7 @@ void blk_add_timer(struct request *);
  */
 enum rq_atomic_flags {
 	REQ_ATOM_COMPLETE = 0,
+	REQ_ATOM_URGENT = 1,
 };
 
 /*
@@ -58,6 +59,16 @@ static inline void blk_clear_rq_complete(struct request *rq)
 	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
+static inline int blk_mark_rq_urgent(struct request *rq)
+{
+	return test_and_set_bit(REQ_ATOM_URGENT, &rq->atomic_flags);
+}
+
+static inline void blk_clear_rq_urgent(struct request *rq)
+{
+	clear_bit(REQ_ATOM_URGENT, &rq->atomic_flags);
+}
+
 /*
  * Internal elevator interface
  */
diff --git a/block/elevator.c b/block/elevator.c
index 0ff6c5a..2104368 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -756,6 +756,11 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	if (test_bit(REQ_ATOM_URGENT, &rq->atomic_flags)) {
+		q->notified_urgent = false;
+		q->dispatched_urgent = false;
+		blk_clear_rq_urgent(rq);
+	}
 	/*
 	 * request is released from the driver, io must be done
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e725303..db5e1bc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -303,6 +303,7 @@ struct request_queue {
 	struct request_list	root_rl;
 
 	request_fn_proc		*request_fn;
+	request_fn_proc		*urgent_request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
@@ -391,6 +392,8 @@ struct request_queue {
 #endif
 
 	struct queue_limits	limits;
+	bool			notified_urgent;
+	bool			dispatched_urgent;
 
 	/*
 	 * sg stuff
@@ -894,6 +897,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
+extern void blk_urgent_request(struct request_queue *q, request_fn_proc *fn);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index f70d05d..9b13913 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -24,6 +24,7 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_reinsert_req_fn) (struct request_queue *,
 					struct request *);
+typedef bool (elevator_is_urgent_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -50,6 +51,7 @@ struct elevator_ops
 	elevator_dispatch_fn *elevator_dispatch_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
 	elevator_reinsert_req_fn *elevator_reinsert_req_fn;
+	elevator_is_urgent_fn *elevator_is_urgent_fn;
 
 	elevator_activate_req_fn *elevator_activate_req_fn;
 	elevator_deactivate_req_fn *elevator_deactivate_req_fn;
-- 
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. 
Is a member of Code Aurora Forum, hosted by the Linux Foundation
