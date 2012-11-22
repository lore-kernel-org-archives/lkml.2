Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2KVTUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:20:16 -0500
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:48371 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965176Ab2KVTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:20:09 -0500
From: Roland Dreier <roland@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Don't access request after it might be freed
Date: Thu, 22 Nov 2012 02:00:11 -0800
Message-Id: <1353578411-23527-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

After we've done __elv_add_request() and __blk_run_queue() in
blk_execute_rq_nowait(), the request might finish and be freed
immediately.  Therefore checking if the type is REQ_TYPE_PM_RESUME
isn't safe afterwards, because if it isn't, rq might be gone.
Instead, check beforehand and stash the result in a temporary.

This fixes crashes in blk_execute_rq_nowait() I get occasionally when
running with lots of memory debugging options enabled -- I think this
race is usually harmless because the window for rq to be reallocated
is so small.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 block/blk-exec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 8b6dc5b..f71eac3 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -52,11 +52,17 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	bool is_pm_resume;
 
 	WARN_ON(irqs_disabled());
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
+	/*
+	 * need to check this before __blk_run_queue(), because rq can
+	 * be freed before that returns.
+	 */
+	is_pm_resume = rq->cmd_type == REQ_TYPE_PM_RESUME;
 
 	spin_lock_irq(q->queue_lock);
 
@@ -71,7 +77,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
+	if (is_pm_resume)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }
-- 
1.7.10.4

