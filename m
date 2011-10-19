Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1JSE2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:28:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab1JSE0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:38 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] block: pass around REQ_* flags instead of broken down booleans during request alloc/free
Date: Tue, 18 Oct 2011 21:26:18 -0700
Message-Id: <1318998384-22525-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_alloc_request() and freed_request() take different combinations of
REQ_* @flags, @priv and @is_sync when @flags is superset of the latter
two.  Make them take @flags only.  This cleans up the code a bit and
will ease updating allocation related REQ_* flags.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a995141..fafa669 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -575,7 +575,7 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, unsigned int flags, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -586,12 +586,10 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
-	if (priv) {
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
-			mempool_free(rq, q->rq.rq_pool);
-			return NULL;
-		}
-		rq->cmd_flags |= REQ_ELVPRIV;
+	if ((flags & REQ_ELVPRIV) &&
+	    unlikely(elv_set_request(q, rq, gfp_mask))) {
+		mempool_free(rq, q->rq.rq_pool);
+		return NULL;
 	}
 
 	return rq;
@@ -650,12 +648,13 @@ static void __freed_request(struct request_queue *q, int sync)
  * A request has just been released.  Account for it, update the full and
  * congestion status, wake up any waiters.   Called under q->queue_lock.
  */
-static void freed_request(struct request_queue *q, int sync, int priv)
+static void freed_request(struct request_queue *q, unsigned int flags)
 {
 	struct request_list *rl = &q->rq;
+	int sync = rw_is_sync(flags);
 
 	rl->count[sync]--;
-	if (priv)
+	if (flags & REQ_ELVPRIV)
 		rl->elvpriv--;
 
 	__freed_request(q, sync);
@@ -695,7 +694,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	int may_queue, priv = 0;
+	int may_queue;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -739,17 +738,17 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
-	if (blk_rq_should_init_elevator(bio)) {
-		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
-		if (priv)
-			rl->elvpriv++;
+	if (blk_rq_should_init_elevator(bio) &&
+	    !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags)) {
+		rw_flags |= REQ_ELVPRIV;
+		rl->elvpriv++;
 	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, rw_flags, gfp_mask);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
@@ -759,7 +758,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		 * wait queue, but this is pretty rare.
 		 */
 		spin_lock_irq(q->queue_lock);
-		freed_request(q, is_sync, priv);
+		freed_request(q, rw_flags);
 
 		/*
 		 * in the very unlikely event that allocation failed and no
@@ -1051,14 +1050,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	 * it didn't come out of our reserved rq pools
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
-		int is_sync = rq_is_sync(req) != 0;
-		int priv = req->cmd_flags & REQ_ELVPRIV;
+		unsigned int flags = req->cmd_flags;
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(!hlist_unhashed(&req->hash));
 
 		blk_free_request(q, req);
-		freed_request(q, is_sync, priv);
+		freed_request(q, flags);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
-- 
1.7.3.1

