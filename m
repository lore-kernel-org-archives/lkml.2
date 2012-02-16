Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2BPWiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:38:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35363 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2BPWiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:38:10 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] block: restructure get_request()
Date: Thu, 16 Feb 2012 14:37:52 -0800
Message-Id: <1329431878-28300-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329431878-28300-1-git-send-email-tj@kernel.org>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_request() is structured a bit unusually in that failure path is
inlined in the usual flow with goto labels atop and inside it.
Relocate the error path to the end of the function.

This is to prepare for icq handling changes in get_request() and
doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c |   60 ++++++++++++++++++++++++++---------------------------
 1 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf06d1d..69fa8c4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -825,7 +825,7 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
 static struct request *get_request(struct request_queue *q, int rw_flags,
 				   struct bio *bio, gfp_t gfp_mask)
 {
-	struct request *rq = NULL;
+	struct request *rq;
 	struct request_list *rl = &q->rq;
 	struct elevator_type *et;
 	struct io_context *ioc;
@@ -877,7 +877,7 @@ retry:
 					 * process is not a "batcher", and not
 					 * exempted by the IO scheduler
 					 */
-					goto out;
+					return NULL;
 				}
 			}
 		}
@@ -890,7 +890,7 @@ retry:
 	 * allocated with any setting of ->nr_requests
 	 */
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
-		goto out;
+		return NULL;
 
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
@@ -920,36 +920,12 @@ retry:
 	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
 		icq = ioc_create_icq(q, gfp_mask);
 		if (!icq)
-			goto fail_icq;
+			goto fail_alloc;
 	}
 
 	rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
-
-fail_icq:
-	if (unlikely(!rq)) {
-		/*
-		 * Allocation failed presumably due to memory. Undo anything
-		 * we might have messed up.
-		 *
-		 * Allocating task should really be put onto the front of the
-		 * wait queue, but this is pretty rare.
-		 */
-		spin_lock_irq(q->queue_lock);
-		freed_request(q, rw_flags);
-
-		/*
-		 * in the very unlikely event that allocation failed and no
-		 * requests for this direction was pending, mark us starved
-		 * so that freeing of a request in the other direction will
-		 * notice us. another possible fix would be to split the
-		 * rq mempool into READ and WRITE
-		 */
-rq_starved:
-		if (unlikely(rl->count[is_sync] == 0))
-			rl->starved[is_sync] = 1;
-
-		goto out;
-	}
+	if (unlikely(!rq))
+		goto fail_alloc;
 
 	/*
 	 * ioc may be NULL here, and ioc_batching will be false. That's
@@ -961,8 +937,30 @@ rq_starved:
 		ioc->nr_batch_requests--;
 
 	trace_block_getrq(q, bio, rw_flags & 1);
-out:
 	return rq;
+
+fail_alloc:
+	/*
+	 * Allocation failed presumably due to memory. Undo anything we
+	 * might have messed up.
+	 *
+	 * Allocating task should really be put onto the front of the wait
+	 * queue, but this is pretty rare.
+	 */
+	spin_lock_irq(q->queue_lock);
+	freed_request(q, rw_flags);
+
+	/*
+	 * in the very unlikely event that allocation failed and no
+	 * requests for this direction was pending, mark us starved so that
+	 * freeing of a request in the other direction will notice
+	 * us. another possible fix would be to split the rq mempool into
+	 * READ and WRITE
+	 */
+rq_starved:
+	if (unlikely(rl->count[is_sync] == 0))
+		rl->starved[is_sync] = 1;
+	return NULL;
 }
 
 /**
-- 
1.7.7.3

