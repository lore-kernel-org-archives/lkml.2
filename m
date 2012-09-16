Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2IPJHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 05:07:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10098 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2IPJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 05:07:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6836"; a="237335293"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 2/2] block: Add API for urgent request handling
Date: Sun, 16 Sep 2012 12:06:42 +0300
Message-Id: <1347786402-7339-3-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1347786402-7339-1-git-send-email-tlinder@codeaurora.org>
References: <1347786402-7339-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support in block & elevator layers for handling
urgent requests.
Urgent request notification passed to underlying driver (eMMC for
example) and causes interruption of low priority current request in
order to execute the urgent one.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 block/blk-core.c         |   29 +++++++++++++++++++++++++++--
 block/blk-settings.c     |   12 ++++++++++++
 block/blk.h              |   11 +++++++++++
 block/elevator.c         |    5 +++++
 include/linux/blkdev.h   |    4 ++++
 include/linux/elevator.h |    3 +++
 6 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 69142d1..dcda53d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -305,7 +305,23 @@ void __blk_run_queue(struct request_queue *q)
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	q->request_fn(q);
+	/*
+	 * Notify the driver of urgent request pending under the folowing
+	 * conditions:
+	 * 1. There isn't already an urgent request in flight, meaning
+	 * previously notified urgent request completed (!q->notified_urgent)
+	 * 2. The driver and the current scheduler support urgent request
+	 * handling
+	 * 3. There is an urgent request pending in the scheduler
+	 */
+	if (!q->notified_urgent &&
+		q->elevator->type->ops.elevator_is_urgent_fn &&
+	    q->urgent_request_fn &&
+	    q->elevator->type->ops.elevator_is_urgent_fn(q)) {
+		q->urgent_request_fn(q);
+		q->notified_urgent = true;
+	} else
+		q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -2221,8 +2237,17 @@ struct request *blk_fetch_request(struct request_queue *q)
 	struct request *rq;
 
 	rq = blk_peek_request(q);
-	if (rq)
+	if (rq) {
+		/*
+		 * Assumption: the next request fetched from scheduler after we
+		 * notified "urgent request pending" - will be the urgent one
+		 */
+		if (q->notified_urgent && !q->urgent_req) {
+			q->urgent_req = rq;
+			(void)blk_mark_rq_urgent(rq);
+		}
 		blk_start_request(rq);
+	}
 	return rq;
 }
 EXPORT_SYMBOL(blk_fetch_request);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 565a678..e169844 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -100,6 +100,18 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
 /**
+ * blk_urgent_request - Set an urgent_request handler function for queue
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
index 2a0ea32..6519965 100644
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
index 9bd4eda..ad1bd62 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -744,6 +744,11 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	if (blk_mark_rq_urgent(rq)) {
+		q->notified_urgent = false;
+		q->urgent_req = NULL;
+	}
+	blk_clear_rq_urgent(rq);
 	/*
 	 * request is released from the driver, io must be done
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d042f55..ed70a5a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -302,6 +302,7 @@ struct request_queue {
 	struct request_list	root_rl;
 
 	request_fn_proc		*request_fn;
+	request_fn_proc		*urgent_request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
@@ -390,6 +391,8 @@ struct request_queue {
 #endif
 
 	struct queue_limits	limits;
+	bool				notified_urgent;
+	struct request		*urgent_req;
 
 	/*
 	 * sg stuff
@@ -850,6 +853,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
+extern void blk_urgent_request(struct request_queue *q, request_fn_proc *fn);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index f70d05d..910f878 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -24,6 +24,8 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_reinsert_req_fn) (struct request_queue *,
 					struct request *);
+typedef bool (elevator_is_urgent_fn) (struct request_queue *);
+
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -50,6 +52,7 @@ struct elevator_ops
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
