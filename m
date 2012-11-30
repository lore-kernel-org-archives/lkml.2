Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031707Ab2K3TOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:14:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:59448 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992931Ab2K3TCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>, Jens Axboe <axboe@kernel.dk>
Subject: [ 23/54] block: Dont access request after it might be freed
Date: Fri, 30 Nov 2012 10:55:54 -0800
Message-Id: <20121130185210.229189810@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 893d290f1d7496db97c9471bc352ad4a11dc8a25 upstream.

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-exec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -52,11 +52,17 @@ void blk_execute_rq_nowait(struct reques
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
 
@@ -71,7 +77,7 @@ void blk_execute_rq_nowait(struct reques
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
+	if (is_pm_resume)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }


