Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386Ab2KAMlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:41:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49718 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KAMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:41:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6882"; a="3397767"
From: tlinder <tlinder@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, philippedeswert@gmail.com, jengelh@inai.de,
        jh80.chung@samsung.com, tgih.jun@samsung.com, arnd.bergmann@linaro.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v2 1/2] block:row: Adding support for reinsert already dispatched req
Date: Thu,  1 Nov 2012 14:41:03 +0200
Message-Id: <1351773663-19604-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatyana Brokhman <tlinder@codeaurora.org>

Add support for reinserting already dispatched request back to the
schedulers internal data structures.
The request will be reinserted back to the queue (head) it was
dispatched from as if it was never dispatched.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/row-iosched.c b/block/row-iosched.c
index b7965c6..62789a4 100644
--- a/block/row-iosched.c
+++ b/block/row-iosched.c
@@ -273,6 +273,33 @@ static void row_add_request(struct request_queue *q,
 }
 
 /*
+ * row_reinsert_req() - Reinsert request back to the scheduler
+ * @q:	dispatch queue
+ * @rq:	request to add
+ *
+ * Reinsert the given request back to the queue it was
+ * dispatched from as if it was never dispatched.
+ *
+ * Returns 0 on success, error code otherwise
+ */
+static int row_reinsert_req(struct request_queue *q,
+			    struct request *rq)
+{
+	struct row_data    *rd = q->elevator->elevator_data;
+	struct row_queue   *rqueue = RQ_ROWQ(rq);
+
+	/* Verify rqueue is legitimate */
+	BUG_ON(rqueue != &rd->row_queues[rqueue->prio].rqueue);
+
+	list_add(&rq->queuelist, &rqueue->fifo);
+	rd->nr_reqs[rq_data_dir(rq)]++;
+
+	row_log_rowq(rd, rqueue->prio, "request reinserted");
+
+	return 0;
+}
+
+/**
  * row_remove_request() -  Remove given request from scheduler
  * @q:	requests queue
  * @rq:	request to remove
@@ -656,6 +683,7 @@ static struct elevator_type iosched_row = {
 		.elevator_merge_req_fn		= row_merged_requests,
 		.elevator_dispatch_fn		= row_dispatch_requests,
 		.elevator_add_req_fn		= row_add_request,
+		.elevator_reinsert_req_fn	= row_reinsert_req,
 		.elevator_former_req_fn		= elv_rb_former_request,
 		.elevator_latter_req_fn		= elv_rb_latter_request,
 		.elevator_set_req_fn		= row_set_request,
-- 
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. 
Is a member of Code Aurora Forum, hosted by the Linux Foundation

