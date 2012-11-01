Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935789Ab2KAMWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:22:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5613 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab2KAMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:22:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6882"; a="3454346"
From: tlinder <tlinder@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, philippedeswert@gmail.com, jengelh@inai.de,
        jh80.chung@samsung.com, tgih.jun@samsung.com, arnd.bergmann@linaro.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v2 1/2] block: Add support for reinsert a dispatched req
Date: Thu,  1 Nov 2012 14:21:52 +0200
Message-Id: <1351772516-10423-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatyana Brokhman <tlinder@codeaurora.org>

Add support for reinserting a dispatched request back to the
schedulers internal data structures.
Add API for verifying whether the current scheduler
supports reinserting requests mechanism

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index b421289..8881e46 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1177,6 +1177,45 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL(blk_requeue_request);
 
+/**
+ * blk_reinsert_request() - Insert a request back to the scheduler
+ * @q:		request queue
+ * @rq:		request to be inserted
+ *
+ * This function inserts the request back to the scheduler as if
+ * it was never dispatched.
+ *
+ * Return: 0 on success, error code on fail
+ */
+int blk_reinsert_request(struct request_queue *q, struct request *rq)
+{
+	blk_delete_timer(rq);
+	blk_clear_rq_complete(rq);
+	trace_block_rq_requeue(q, rq);
+
+	if (blk_rq_tagged(rq))
+		blk_queue_end_tag(q, rq);
+
+	BUG_ON(blk_queued_rq(rq));
+
+	return elv_reinsert_request(q, rq);
+}
+EXPORT_SYMBOL(blk_reinsert_request);
+
+/**
+ * blk_reinsert_req_sup() - check whether the scheduler supports
+ *          reinsertion of requests
+ * @q:		request queue
+ *
+ * Returns true if the current scheduler supports reinserting
+ * request. False otherwise
+ */
+bool blk_reinsert_req_sup(struct request_queue *q)
+{
+	return q->elevator->type->ops.elevator_reinsert_req_fn ? true : false;
+}
+EXPORT_SYMBOL(blk_reinsert_req_sup);
+
 static void add_acct_request(struct request_queue *q, struct request *rq,
 			     int where)
 {
diff --git a/block/elevator.c b/block/elevator.c
index 9b1d42b..121a351 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -539,6 +539,36 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
+/**
+ * elv_reinsert_request() - Insert a request back to the scheduler
+ * @q:		request queue where request should be inserted
+ * @rq:		request to be inserted
+ *
+ * This function returns the request back to the scheduler to be
+ * inserted as if it was never dispatched
+ *
+ * Return: 0 on success, error code on failure
+ */
+int elv_reinsert_request(struct request_queue *q, struct request *rq)
+{
+	if (!q->elevator->type->ops.elevator_reinsert_req_fn)
+		return -EPERM;
+	/*
+	 * it already went through dequeue, we need to decrement the
+	 * in_flight count again
+	 */
+	if (blk_account_rq(rq)) {
+		q->in_flight[rq_is_sync(rq)]--;
+		if (rq->cmd_flags & REQ_SORTED)
+			elv_deactivate_rq(q, rq);
+	}
+
+	rq->cmd_flags &= ~REQ_STARTED;
+	q->nr_sorted++;
+
+	return q->elevator->type->ops.elevator_reinsert_req_fn(q, rq);
+}
+
 void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1756001..e725303 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -722,6 +722,8 @@ extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
 extern void blk_requeue_request(struct request_queue *, struct request *);
+extern int blk_reinsert_request(struct request_queue *q, struct request *rq);
+extern bool blk_reinsert_req_sup(struct request_queue *q);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c03af76..f70d05d 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -22,6 +22,8 @@ typedef void (elevator_bio_merged_fn) (struct request_queue *,
 typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
+typedef int (elevator_reinsert_req_fn) (struct request_queue *,
+					struct request *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -47,6 +49,8 @@ struct elevator_ops
 
 	elevator_dispatch_fn *elevator_dispatch_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
+	elevator_reinsert_req_fn *elevator_reinsert_req_fn;
+
 	elevator_activate_req_fn *elevator_activate_req_fn;
 	elevator_deactivate_req_fn *elevator_deactivate_req_fn;
 
@@ -123,6 +127,7 @@ extern void elv_merged_request(struct request_queue *, struct request *, int);
 extern void elv_bio_merged(struct request_queue *q, struct request *,
 				struct bio *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
+extern int elv_reinsert_request(struct request_queue *, struct request *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
-- 
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. 
Is a member of Code Aurora Forum, hosted by the Linux Foundation

