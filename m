Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1JSE12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:27:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab1JSE0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:48 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] block: make get_request[_wait]() fail if queue is dead
Date: Tue, 18 Oct 2011 21:26:22 -0700
Message-Id: <1318998384-22525-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently get_request[_wait]() allocates request whether queue is dead
or not.  This patch makes get_request[_wait]() return NULL if @q is
dead.  blk_queue_bio() is updated to fail the submitted bio if request
allocation fails.  While at it, add docbook comments for
get_request[_wait]().

Note that the current code has rather unclear (there are spurious DEAD
tests scattered around) assumption that the owner of a queue
guarantees that no request travels block layer if the queue is dead
and this patch in itself doesn't change much; however, this will allow
fixing the broken assumption in the next patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   54 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7a90317..fc10f53 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -710,10 +710,19 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
 	return true;
 }
 
-/*
- * Get a free request, queue_lock must be held.
- * Returns NULL on failure, with queue_lock held.
- * Returns !NULL on success, with queue_lock *not held*.
+/**
+ * get_request - get a free request
+ * @q: request_queue to allocate request from
+ * @rw_flags: RW and SYNC flags
+ * @bio: bio to allocate request for (can be %NULL)
+ * @gfp_mask: allocation mask
+ *
+ * Get a free request from @q.  This function may fail under memory
+ * pressure or if @q is dead.
+ *
+ * Must be callled with @q->queue_lock held and,
+ * Returns %NULL on failure, with @q->queue_lock held.
+ * Returns !%NULL on success, with @q->queue_lock *not held*.
  */
 static struct request *get_request(struct request_queue *q, int rw_flags,
 				   struct bio *bio, gfp_t gfp_mask)
@@ -724,6 +733,9 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
@@ -816,11 +828,18 @@ out:
 	return rq;
 }
 
-/*
- * No available requests for this queue, wait for some requests to become
- * available.
+/**
+ * get_request_wait - get a free request with retry
+ * @q: request_queue to allocate request from
+ * @rw_flags: RW and SYNC flags
+ * @bio: bio to allocate request for (can be %NULL)
  *
- * Called with q->queue_lock held, and returns with it unlocked.
+ * Get a free request from @q.  This function keeps retrying under memory
+ * pressure and fails iff @q is dead.
+ *
+ * Must be callled with @q->queue_lock held and,
+ * Returns %NULL on failure, with @q->queue_lock held.
+ * Returns !%NULL on success, with @q->queue_lock *not held*.
  */
 static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 					struct bio *bio)
@@ -834,6 +853,9 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		struct io_context *ioc;
 		struct request_list *rl = &q->rq;
 
+		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+			return NULL;
+
 		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				TASK_UNINTERRUPTIBLE);
 
@@ -864,19 +886,15 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	struct request *rq;
 
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
-		return NULL;
-
 	BUG_ON(rw != READ && rw != WRITE);
 
 	spin_lock_irq(q->queue_lock);
-	if (gfp_mask & __GFP_WAIT) {
+	if (gfp_mask & __GFP_WAIT)
 		rq = get_request_wait(q, rw, NULL);
-	} else {
+	else
 		rq = get_request(q, rw, NULL, gfp_mask);
-		if (!rq)
-			spin_unlock_irq(q->queue_lock);
-	}
+	if (!rq)
+		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
 
 	return rq;
@@ -1300,6 +1318,10 @@ get_rq:
 	 * Returns with the queue unlocked.
 	 */
 	req = get_request_wait(q, rw_flags, bio);
+	if (unlikely(!req)) {
+		bio_endio(bio, -ENODEV);	/* @q is dead */
+		goto out_unlock;
+	}
 
 	/*
 	 * After dropping the lock and possibly sleeping here, our request
-- 
1.7.3.1

