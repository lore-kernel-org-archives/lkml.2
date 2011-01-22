Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1AVBSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:18:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:45839 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1AVBSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:18:03 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 06/10] block: kill request allocation batching
Date: Sat, 22 Jan 2011 01:17:25 +0000
Message-Id: <1295659049-2688-7-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-core.c       |   81 ++---------------------------------------------
 block/blk-settings.c   |    1 -
 block/blk.h            |    6 ---
 include/linux/blkdev.h |    1 -
 4 files changed, 4 insertions(+), 85 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7ab6620..54b5987 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -593,40 +593,6 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 	return rq;
 }
 
-/*
- * ioc_batching returns true if the ioc is a valid batching request and
- * should be given priority access to a request.
- */
-static inline int ioc_batching(struct request_queue *q, struct io_context *ioc)
-{
-	if (!ioc)
-		return 0;
-
-	/*
-	 * Make sure the process is able to allocate at least 1 request
-	 * even if the batch times out, otherwise we could theoretically
-	 * lose wakeups.
-	 */
-	return ioc->nr_batch_requests == q->nr_batching ||
-		(ioc->nr_batch_requests > 0
-		&& time_before(jiffies, ioc->last_waited + BLK_BATCH_TIME));
-}
-
-/*
- * ioc_set_batching sets ioc to be a new "batcher" if it is not one. This
- * will cause the process to be a "batcher" on all queues in the system. This
- * is the behaviour we want though - once it gets a wakeup it should be given
- * a nice run.
- */
-static void ioc_set_batching(struct request_queue *q, struct io_context *ioc)
-{
-	if (!ioc || ioc_batching(q, ioc))
-		return;
-
-	ioc->nr_batch_requests = q->nr_batching;
-	ioc->last_waited = jiffies;
-}
-
 static void __freed_request(struct request_queue *q, int sync)
 {
 	struct request_list *rl = &q->rq;
@@ -670,7 +636,6 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 {
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
-	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue, priv;
 
@@ -679,30 +644,11 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		goto rq_starved;
 
 	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
-		if (rl->count[is_sync]+1 >= q->nr_requests) {
-			ioc = current_io_context(GFP_ATOMIC, q->node);
-			/*
-			 * The queue will fill after this allocation, so set
-			 * it as full, and mark this process as "batching".
-			 * This process will be allowed to complete a batch of
-			 * requests, others will be blocked.
-			 */
-			if (!blk_queue_full(q, is_sync)) {
-				ioc_set_batching(q, ioc);
-				blk_set_queue_full(q, is_sync);
-			} else {
-				if (may_queue != ELV_MQUEUE_MUST
-						&& !ioc_batching(q, ioc)) {
-					/*
-					 * The queue is full and the allocating
-					 * process is not a "batcher", and not
-					 * exempted by the IO scheduler
-					 */
-					goto out;
-				}
-			}
-		}
 		blk_set_queue_congested(q, is_sync);
+
+		if (rl->count[is_sync]+1 >= q->nr_requests)
+			if (may_queue != ELV_MQUEUE_MUST)
+				goto out;
 	}
 
 	/*
@@ -750,15 +696,6 @@ rq_starved:
 		goto out;
 	}
 
-	/*
-	 * ioc may be NULL here, and ioc_batching will be false. That's
-	 * OK, if the queue is under the request limit then requests need
-	 * not count toward the nr_batch_requests limit. There will always
-	 * be some limit enforced by BLK_BATCH_TIME.
-	 */
-	if (ioc_batching(q, ioc))
-		ioc->nr_batch_requests--;
-
 	trace_block_getrq(q, bio, rw_flags & 1);
 out:
 	return rq;
@@ -779,7 +716,6 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 	rq = get_request(q, rw_flags, bio, GFP_NOIO);
 	while (!rq) {
 		DEFINE_WAIT(wait);
-		struct io_context *ioc;
 		struct request_list *rl = &q->rq;
 
 		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
@@ -790,15 +726,6 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		spin_unlock_irq(q->queue_lock);
 		io_schedule();
 
-		/*
-		 * After sleeping, we become a "batching" process and
-		 * will be able to allocate at least one request, and
-		 * up to a big batch of them for a small period time.
-		 * See ioc_batching, ioc_set_batching
-		 */
-		ioc = current_io_context(GFP_NOIO, q->node);
-		ioc_set_batching(q, ioc);
-
 		spin_lock_irq(q->queue_lock);
 		finish_wait(&rl->wait[is_sync], &wait);
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8d6892..35420f2 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -162,7 +162,6 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->make_request_fn = mfn;
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
-	q->nr_batching = BLK_BATCH_REQ;
 
 	blk_set_default_limits(&q->limits);
 	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
diff --git a/block/blk.h b/block/blk.h
index 2c3d2e7..6db2e75 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -1,12 +1,6 @@
 #ifndef BLK_INTERNAL_H
 #define BLK_INTERNAL_H
 
-/* Amount of time in which a process may batch requests */
-#define BLK_BATCH_TIME	(HZ/50UL)
-
-/* Number of requests a "batching" process may submit */
-#define BLK_BATCH_REQ	32
-
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index dfb6ffd..ebaf9d6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -326,7 +326,6 @@ struct request_queue
 	unsigned long		nr_requests;	/* Max # of requests */
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
-	unsigned int		nr_batching;
 
 	void			*dma_drain_buffer;
 	unsigned int		dma_drain_size;
-- 
1.7.3.2.146.gca209

