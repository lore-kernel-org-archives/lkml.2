Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519Ab2FEDmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:42:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761478Ab2FEDl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:41:27 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        fengguang.wu@intel.com, hughd@google.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] block: add q->nr_rqs[] and move q->rq.elvpriv to q->nr_rqs_elvpriv
Date: Mon,  4 Jun 2012 20:40:58 -0700
Message-Id: <1338867660-4689-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338867660-4689-1-git-send-email-tj@kernel.org>
References: <1338867660-4689-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add q->nr_rqs[] which currently behaves the same as q->rq.count[] and
move q->rq.elvpriv to q->nr_rqs_elvpriv.  blk_drain_queue() is updated
to use q->nr_rqs[] instead of q->rq.count[].

These counters separates queue-wide request statistics from the
request list and allow implementation of per-queue request allocation.

While at it, properly indent fields of struct request_list.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c       |   13 +++++++------
 include/linux/blkdev.h |   11 ++++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ada4bc0..8149c76 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -386,7 +386,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		if (!list_empty(&q->queue_head) && q->request_fn)
 			__blk_run_queue(q);
 
-		drain |= q->rq.elvpriv;
+		drain |= q->nr_rqs_elvpriv;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
@@ -396,7 +396,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		if (drain_all) {
 			drain |= !list_empty(&q->queue_head);
 			for (i = 0; i < 2; i++) {
-				drain |= q->rq.count[i];
+				drain |= q->nr_rqs[i];
 				drain |= q->in_flight[i];
 				drain |= !list_empty(&q->flush_queue[i]);
 			}
@@ -513,7 +513,6 @@ static int blk_init_free_list(struct request_queue *q)
 
 	rl->count[BLK_RW_SYNC] = rl->count[BLK_RW_ASYNC] = 0;
 	rl->starved[BLK_RW_SYNC] = rl->starved[BLK_RW_ASYNC] = 0;
-	rl->elvpriv = 0;
 	init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
 	init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
 
@@ -778,9 +777,10 @@ static void freed_request(struct request_queue *q, unsigned int flags)
 	struct request_list *rl = &q->rq;
 	int sync = rw_is_sync(flags);
 
+	q->nr_rqs[sync]--;
 	rl->count[sync]--;
 	if (flags & REQ_ELVPRIV)
-		rl->elvpriv--;
+		q->nr_rqs_elvpriv--;
 
 	__freed_request(q, sync);
 
@@ -889,6 +889,7 @@ static struct request *__get_request(struct request_queue *q, int rw_flags,
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
 		return NULL;
 
+	q->nr_rqs[is_sync]++;
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
@@ -904,7 +905,7 @@ static struct request *__get_request(struct request_queue *q, int rw_flags,
 	 */
 	if (blk_rq_should_init_elevator(bio) && !blk_queue_bypass(q)) {
 		rw_flags |= REQ_ELVPRIV;
-		rl->elvpriv++;
+		q->nr_rqs_elvpriv++;
 		if (et->icq_cache && ioc)
 			icq = ioc_lookup_icq(ioc, q);
 	}
@@ -965,7 +966,7 @@ fail_elvpriv:
 	rq->elv.icq = NULL;
 
 	spin_lock_irq(q->queue_lock);
-	rl->elvpriv--;
+	q->nr_rqs_elvpriv--;
 	spin_unlock_irq(q->queue_lock);
 	goto out;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..0c6f527 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -51,11 +51,10 @@ struct request_list {
 	 * count[], starved[], and wait[] are indexed by
 	 * BLK_RW_SYNC/BLK_RW_ASYNC
 	 */
-	int count[2];
-	int starved[2];
-	int elvpriv;
-	mempool_t *rq_pool;
-	wait_queue_head_t wait[2];
+	int			count[2];
+	int			starved[2];
+	mempool_t		*rq_pool;
+	wait_queue_head_t	wait[2];
 };
 
 /*
@@ -282,6 +281,8 @@ struct request_queue {
 	struct list_head	queue_head;
 	struct request		*last_merge;
 	struct elevator_queue	*elevator;
+	int			nr_rqs[2];	/* # allocated [a]sync rqs */
+	int			nr_rqs_elvpriv;	/* # allocated rqs w/ elvpriv */
 
 	/*
 	 * the queue request freelist, one for reads and one for writes
-- 
1.7.7.3

