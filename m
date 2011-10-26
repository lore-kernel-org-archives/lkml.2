Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1JZBCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:02:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52209 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1JZBCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:02:15 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] block, sx8: kill blk_insert_request()
Date: Tue, 25 Oct 2011 18:02:02 -0700
Message-Id: <1319590927-15791-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319590927-15791-1-git-send-email-tj@kernel.org>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user left for blk_insert_request() is sx8 and it can be
trivially switched to use blk_execute_rq_nowait() - special requests
aren't included in io stat and sx8 doesn't use block layer tagging.
Switch sx8 and kill blk_insert_requeset().

This patch doesn't introduce any functional difference.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       |   48 ------------------------------------------------
 drivers/block/sx8.c    |   12 ++++++++----
 include/linux/blkdev.h |    1 -
 3 files changed, 8 insertions(+), 53 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f658711..a36738b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1005,54 +1005,6 @@ static void add_acct_request(struct request_queue *q, struct request *rq,
 	__elv_add_request(q, rq, where);
 }
 
-/**
- * blk_insert_request - insert a special request into a request queue
- * @q:		request queue where request should be inserted
- * @rq:		request to be inserted
- * @at_head:	insert request at head or tail of queue
- * @data:	private data
- *
- * Description:
- *    Many block devices need to execute commands asynchronously, so they don't
- *    block the whole kernel from preemption during request execution.  This is
- *    accomplished normally by inserting aritficial requests tagged as
- *    REQ_TYPE_SPECIAL in to the corresponding request queue, and letting them
- *    be scheduled for actual execution by the request queue.
- *
- *    We have the option of inserting the head or the tail of the queue.
- *    Typically we use the tail for new ioctls and so forth.  We use the head
- *    of the queue for things like a QUEUE_FULL message from a device, or a
- *    host that is unable to accept a particular command.
- */
-void blk_insert_request(struct request_queue *q, struct request *rq,
-			int at_head, void *data)
-{
-	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
-	unsigned long flags;
-
-	/*
-	 * tell I/O scheduler that this isn't a regular read/write (ie it
-	 * must not attempt merges on this) and that it acts as a soft
-	 * barrier
-	 */
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-
-	rq->special = data;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-
-	/*
-	 * If command is tagged, release the tag
-	 */
-	if (blk_rq_tagged(rq))
-		blk_queue_end_tag(q, rq);
-
-	add_acct_request(q, rq, where);
-	__blk_run_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-EXPORT_SYMBOL(blk_insert_request);
-
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index b70f0fc..e7472f5 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -619,8 +619,10 @@ static int carm_array_info (struct carm_host *host, unsigned int array_idx)
 	       host->state == HST_DEV_SCAN);
 	spin_unlock_irq(&host->lock);
 
-	DPRINTK("blk_insert_request, tag == %u\n", idx);
-	blk_insert_request(host->oob_q, crq->rq, 1, crq);
+	DPRINTK("blk_execute_rq_nowait, tag == %u\n", idx);
+	crq->rq->cmd_type = REQ_TYPE_SPECIAL;
+	crq->rq->special = crq;
+	blk_execute_rq_nowait(host->oob_q, NULL, crq->rq, true, NULL);
 
 	return 0;
 
@@ -658,8 +660,10 @@ static int carm_send_special (struct carm_host *host, carm_sspc_t func)
 	BUG_ON(rc < 0);
 	crq->msg_bucket = (u32) rc;
 
-	DPRINTK("blk_insert_request, tag == %u\n", idx);
-	blk_insert_request(host->oob_q, crq->rq, 1, crq);
+	DPRINTK("blk_execute_rq_nowait, tag == %u\n", idx);
+	crq->rq->cmd_type = REQ_TYPE_SPECIAL;
+	crq->rq->special = crq;
+	blk_execute_rq_nowait(host->oob_q, NULL, crq->rq, true, NULL);
 
 	return 0;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5267cd2..45563b0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -660,7 +660,6 @@ extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
-extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
-- 
1.7.3.1

