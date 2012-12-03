Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2LCOvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:51:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43698 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339Ab2LCOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:11 -0500
Message-Id: <20121203143158.858703795@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>, Jens Axboe <axboe@kernel.dk>
Subject: [ 80/89] block: Dont access request after it might be freed
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-exec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -49,6 +49,7 @@ void blk_execute_rq_nowait(struct reques
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	bool is_pm_resume;
 
 	if (unlikely(blk_queue_dead(q))) {
 		rq->errors = -ENXIO;
@@ -59,12 +60,18 @@ void blk_execute_rq_nowait(struct reques
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
+	/*
+	 * need to check this before __blk_run_queue(), because rq can
+	 * be freed before that returns.
+	 */
+	is_pm_resume = rq->cmd_type == REQ_TYPE_PM_RESUME;
+
 	WARN_ON(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
+	if (is_pm_resume)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }


