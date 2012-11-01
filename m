Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431Ab2KAMlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:41:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49755 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KAMl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:41:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6882"; a="3397784"
From: tlinder <tlinder@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, philippedeswert@gmail.com, jengelh@inai.de,
        jh80.chung@samsung.com, tgih.jun@samsung.com, arnd.bergmann@linaro.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v2 2/2]block:row: Add support for urgent request handling
Date: Thu,  1 Nov 2012 14:41:19 +0200
Message-Id: <1351773679-19680-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatyana Brokhman <tlinder@codeaurora.org>

This patch add support for handling urgent requests.
ROW queue can be marked as "urgent" so if it was un-served and a
request was added to it - it will trigger issuing urgent request
to the mmc driver.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/row-iosched.c b/block/row-iosched.c
index 62789a4..fdf7618 100644
--- a/block/row-iosched.c
+++ b/block/row-iosched.c
@@ -27,6 +27,8 @@
 #include <linux/blktrace_api.h>
 #include <linux/jiffies.h>
 
+#include "blk.h"
+
 /*
  * enum row_queue_prio - Priorities of the ROW queues
  *
@@ -58,6 +60,17 @@ static const bool queue_idling_enabled[] = {
 	false,	/* ROWQ_PRIO_LOW_SWRITE */
 };
 
+/* Flags indicating whether the queue can notify on urgent requests */
+static const bool urgent_queues[] = {
+	true,	/* ROWQ_PRIO_HIGH_READ */
+	true,	/* ROWQ_PRIO_REG_READ */
+	false,	/* ROWQ_PRIO_HIGH_SWRITE */
+	false,	/* ROWQ_PRIO_REG_SWRITE */
+	false,	/* ROWQ_PRIO_REG_WRITE */
+	false,	/* ROWQ_PRIO_LOW_READ */
+	false,	/* ROWQ_PRIO_LOW_SWRITE */
+};
+
 /* Default values for row queues quantums in each dispatch cycle */
 static const int queue_quantum[] = {
 	100,	/* ROWQ_PRIO_HIGH_READ */
@@ -269,7 +282,13 @@ static void row_add_request(struct request_queue *q,
 		rqueue->idle_data.idle_trigger_time =
 			jiffies + msecs_to_jiffies(rd->read_idle.freq);
 	}
-	row_log_rowq(rd, rqueue->prio, "added request");
+	if (urgent_queues[rqueue->prio] &&
+	    row_rowq_unserved(rd, rqueue->prio)) {
+		row_log_rowq(rd, rqueue->prio,
+			     "added urgent req curr_queue = %d",
+			     rd->curr_queue);
+	} else
+		row_log_rowq(rd, rqueue->prio, "added request");
 }
 
 /*
@@ -289,7 +308,12 @@ static int row_reinsert_req(struct request_queue *q,
 	struct row_queue   *rqueue = RQ_ROWQ(rq);
 
 	/* Verify rqueue is legitimate */
-	BUG_ON(rqueue != &rd->row_queues[rqueue->prio].rqueue);
+	if (rqueue->prio >= ROWQ_MAX_PRIO) {
+		pr_err("\n\nROW BUG: row_reinsert_req() rqueue->prio = %d\n",
+			   rqueue->prio);
+		blk_dump_rq_flags(rq, "");
+		return -EIO;
+	}
 
 	list_add(&rq->queuelist, &rqueue->fifo);
 	rd->nr_reqs[rq_data_dir(rq)]++;
@@ -299,6 +323,29 @@ static int row_reinsert_req(struct request_queue *q,
 	return 0;
 }
 
+/*
+ * row_urgent_pending() - Return TRUE if there is an urgent
+ *			  request on scheduler
+ * @q:	dispatch queue
+ *
+ */
+static bool row_urgent_pending(struct request_queue *q)
+{
+	struct row_data *rd = q->elevator->elevator_data;
+	int i;
+
+	for (i = 0; i < ROWQ_MAX_PRIO; i++)
+		if (urgent_queues[i] && row_rowq_unserved(rd, i) &&
+		    !list_empty(&rd->row_queues[i].rqueue.fifo)) {
+			row_log_rowq(rd, i,
+				     "Urgent request pending (curr=%i)",
+				     rd->curr_queue);
+			return true;
+		}
+
+	return false;
+}
+
 /**
  * row_remove_request() -  Remove given request from scheduler
  * @q:	requests queue
@@ -684,6 +731,7 @@ static struct elevator_type iosched_row = {
 		.elevator_dispatch_fn		= row_dispatch_requests,
 		.elevator_add_req_fn		= row_add_request,
 		.elevator_reinsert_req_fn	= row_reinsert_req,
+		.elevator_is_urgent_fn		= row_urgent_pending,
 		.elevator_former_req_fn		= elv_rb_former_request,
 		.elevator_latter_req_fn		= elv_rb_latter_request,
 		.elevator_set_req_fn		= row_set_request,
-- 
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. 
Is a member of Code Aurora Forum, hosted by the Linux Foundation

