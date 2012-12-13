Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2LMOiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:38:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2LMOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>, Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 139/241] block: Don't access request after it might be freed
Date: Thu, 13 Dec 2012 11:58:24 -0200
Message-Id: <1355407206-17100-140-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 block/blk-exec.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..9925fbe 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -49,8 +49,16 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	bool is_pm_resume;
 
 	WARN_ON(irqs_disabled());
+
+	/*
+	 * need to check this before __blk_run_queue(), because rq can
+	 * be freed before that returns.
+	 */
+	is_pm_resume = rq->cmd_type == REQ_TYPE_PM_RESUME;
+
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dead(q))) {
@@ -66,7 +74,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
+	if (is_pm_resume)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }
-- 
1.7.9.5

