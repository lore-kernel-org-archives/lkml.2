Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2IPJNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 05:13:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31670 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2IPJNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 05:13:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6836"; a="237335691"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 1/2] row: Adding support for reinsert already dispatched req
Date: Sun, 16 Sep 2012 12:12:55 +0300
Message-Id: <1347786776-8327-2-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1347786776-8327-1-git-send-email-tlinder@codeaurora.org>
References: <1347786776-8327-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for reinserting already dispatched request back to the
schedulers internal data structures.
The request will be reinserted back to the queue (head) it was
dispatched from as if it was never dispatched.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 block/row-iosched.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/block/row-iosched.c b/block/row-iosched.c
index c99863a..9135416 100644
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
@@ -650,6 +677,7 @@ static struct elevator_type iosched_row = {
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
