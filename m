Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2DSXhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:37:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab2DSXh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:37:28 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] block: collapse blk_alloc_request() into get_request()
Date: Thu, 19 Apr 2012 16:29:21 -0700
Message-Id: <1334878164-24788-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334878164-24788-1-git-send-email-tj@kernel.org>
References: <1334878164-24788-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocation failure handling in get_request() is about to be updated.
To ease the update, collapse blk_alloc_request() into get_request().

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   46 +++++++++++++++++-----------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3b02ba3..f6f68b0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,33 +719,6 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 	mempool_free(rq, q->rq.rq_pool);
 }
 
-static struct request *
-blk_alloc_request(struct request_queue *q, struct bio *bio, struct io_cq *icq,
-		  unsigned int flags, gfp_t gfp_mask)
-{
-	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
-
-	if (!rq)
-		return NULL;
-
-	blk_rq_init(q, rq);
-
-	rq->cmd_flags = flags | REQ_ALLOCED;
-
-	if (flags & REQ_ELVPRIV) {
-		rq->elv.icq = icq;
-		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
-			mempool_free(rq, q->rq.rq_pool);
-			return NULL;
-		}
-		/* @rq->elv.icq holds on to io_context until @rq is freed */
-		if (icq)
-			get_io_context(icq->ioc);
-	}
-
-	return rq;
-}
-
 /*
  * ioc_batching returns true if the ioc is a valid batching request and
  * should be given priority access to a request.
@@ -968,10 +941,25 @@ retry:
 			goto fail_alloc;
 	}
 
-	rq = blk_alloc_request(q, bio, icq, rw_flags, gfp_mask);
-	if (unlikely(!rq))
+	/* allocate and init request */
+	rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
+	if (!rq)
 		goto fail_alloc;
 
+	blk_rq_init(q, rq);
+	rq->cmd_flags = rw_flags | REQ_ALLOCED;
+
+	if (rw_flags & REQ_ELVPRIV) {
+		rq->elv.icq = icq;
+		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
+			mempool_free(rq, q->rq.rq_pool);
+			goto fail_alloc;
+		}
+		/* @rq->elv.icq holds on to io_context until @rq is freed */
+		if (icq)
+			get_io_context(icq->ioc);
+	}
+
 	/*
 	 * ioc may be NULL here, and ioc_batching will be false. That's
 	 * OK, if the queue is under the request limit then requests need
-- 
1.7.7.3

