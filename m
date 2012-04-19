Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2DSX3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:29:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42641 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2DSX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:29:34 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] block: fix elvpriv allocation failure handling
Date: Thu, 19 Apr 2012 16:29:22 -0700
Message-Id: <1334878164-24788-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334878164-24788-1-git-send-email-tj@kernel.org>
References: <1334878164-24788-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request allocation is mempool backed to guarantee forward progress
under memory pressure; unfortunately, this property got broken while
adding elvpriv data.  Failures during elvpriv allocation, including
ioc and icq creation failures, currently make get_request() fail as
whole.  There's no forward progress guarantee for these allocations -
they may fail indefinitely under memory pressure stalling IO and
deadlocking the system.

This patch updates get_request() such that elvpriv allocation failure
doesn't make the whole function fail.  If elvpriv allocation fails,
the allocation is degraded into !ELVPRIV.  This will force the request
to ELEVATOR_INSERT_BACK disturbing scheduling but elvpriv alloc
failures should be rare (nothing is per-request) and anything is
better than deadlocking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   53 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f6f68b0..6cf13df 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -29,6 +29,7 @@
 #include <linux/fault-inject.h>
 #include <linux/list_sort.h>
 #include <linux/delay.h>
+#include <linux/ratelimit.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -930,17 +931,6 @@ retry:
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
-	/* create icq if missing */
-	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
-		create_io_context(gfp_mask, q->node);
-		ioc = rq_ioc(bio);
-		if (!ioc)
-			goto fail_alloc;
-		icq = ioc_create_icq(ioc, q, gfp_mask);
-		if (!icq)
-			goto fail_alloc;
-	}
-
 	/* allocate and init request */
 	rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 	if (!rq)
@@ -949,17 +939,28 @@ retry:
 	blk_rq_init(q, rq);
 	rq->cmd_flags = rw_flags | REQ_ALLOCED;
 
+	/* init elvpriv */
 	if (rw_flags & REQ_ELVPRIV) {
-		rq->elv.icq = icq;
-		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
-			mempool_free(rq, q->rq.rq_pool);
-			goto fail_alloc;
+		if (unlikely(et->icq_cache && !icq)) {
+			create_io_context(gfp_mask, q->node);
+			ioc = rq_ioc(bio);
+			if (!ioc)
+				goto fail_elvpriv;
+
+			icq = ioc_create_icq(ioc, q, gfp_mask);
+			if (!icq)
+				goto fail_elvpriv;
 		}
-		/* @rq->elv.icq holds on to io_context until @rq is freed */
+
+		rq->elv.icq = icq;
+		if (unlikely(elv_set_request(q, rq, bio, gfp_mask)))
+			goto fail_elvpriv;
+
+		/* @rq->elv.icq holds io_context until @rq is freed */
 		if (icq)
 			get_io_context(icq->ioc);
 	}
-
+out:
 	/*
 	 * ioc may be NULL here, and ioc_batching will be false. That's
 	 * OK, if the queue is under the request limit then requests need
@@ -972,6 +973,24 @@ retry:
 	trace_block_getrq(q, bio, rw_flags & 1);
 	return rq;
 
+fail_elvpriv:
+	/*
+	 * elvpriv init failed.  ioc, icq and elvpriv aren't mempool backed
+	 * and may fail indefinitely under memory pressure and thus
+	 * shouldn't stall IO.  Treat this request as !elvpriv.  This will
+	 * disturb iosched and blkcg but weird is bettern than dead.
+	 */
+	printk_ratelimited(KERN_WARNING "%s: request aux data allocation failed, iosched may be disturbed\n",
+			   dev_name(q->backing_dev_info.dev));
+
+	rq->cmd_flags &= ~REQ_ELVPRIV;
+	rq->elv.icq = NULL;
+
+	spin_lock_irq(q->queue_lock);
+	rl->elvpriv--;
+	spin_unlock_irq(q->queue_lock);
+	goto out;
+
 fail_alloc:
 	/*
 	 * Allocation failed presumably due to memory. Undo anything we
-- 
1.7.7.3

