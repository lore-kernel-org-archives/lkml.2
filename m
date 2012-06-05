Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469Ab2FEDlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:41:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43604 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FEDlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:41:23 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        fengguang.wu@intel.com, hughd@google.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] block: allocate io_context upfront
Date: Mon,  4 Jun 2012 20:40:56 -0700
Message-Id: <1338867660-4689-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338867660-4689-1-git-send-email-tj@kernel.org>
References: <1338867660-4689-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block layer very lazy allocation of ioc.  It waits until the moment
ioc is absolutely necessary; unfortunately, that time could be inside
queue lock and __get_request() performs unlock - try alloc - retry
dancing.

Just allocate it up-front on entry to block layer.  We're not saving
the rain forest by deferring it to the last possible moment and
complicating things unnecessarily.

This patch is to prepare for further updates to request allocation
path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |   42 +++++++++++++++---------------------------
 block/blk-throttle.c |    3 ---
 2 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9b25d73..ada4bc0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -842,15 +842,11 @@ static struct request *__get_request(struct request_queue *q, int rw_flags,
 {
 	struct request *rq;
 	struct request_list *rl = &q->rq;
-	struct elevator_type *et;
-	struct io_context *ioc;
+	struct elevator_type *et = q->elevator->type;
+	struct io_context *ioc = rq_ioc(bio);
 	struct io_cq *icq = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	bool retried = false;
 	int may_queue;
-retry:
-	et = q->elevator->type;
-	ioc = rq_ioc(bio);
 
 	if (unlikely(blk_queue_dead(q)))
 		return NULL;
@@ -862,20 +858,6 @@ retry:
 	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
 		if (rl->count[is_sync]+1 >= q->nr_requests) {
 			/*
-			 * We want ioc to record batching state.  If it's
-			 * not already there, creating a new one requires
-			 * dropping queue_lock, which in turn requires
-			 * retesting conditions to avoid queue hang.
-			 */
-			if (!ioc && !retried) {
-				spin_unlock_irq(q->queue_lock);
-				create_io_context(gfp_mask, q->node);
-				spin_lock_irq(q->queue_lock);
-				retried = true;
-				goto retry;
-			}
-
-			/*
 			 * The queue will fill after this allocation, so set
 			 * it as full, and mark this process as "batching".
 			 * This process will be allowed to complete a batch of
@@ -942,12 +924,8 @@ retry:
 	/* init elvpriv */
 	if (rw_flags & REQ_ELVPRIV) {
 		if (unlikely(et->icq_cache && !icq)) {
-			create_io_context(gfp_mask, q->node);
-			ioc = rq_ioc(bio);
-			if (!ioc)
-				goto fail_elvpriv;
-
-			icq = ioc_create_icq(ioc, q, gfp_mask);
+			if (ioc)
+				icq = ioc_create_icq(ioc, q, gfp_mask);
 			if (!icq)
 				goto fail_elvpriv;
 		}
@@ -1058,7 +1036,6 @@ retry:
 	 * to allocate at least one request, and up to a big batch of them
 	 * for a small period time.  See ioc_batching, ioc_set_batching
 	 */
-	create_io_context(GFP_NOIO, q->node);
 	ioc_set_batching(q, current->io_context);
 
 	spin_lock_irq(q->queue_lock);
@@ -1073,6 +1050,9 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 
 	BUG_ON(rw != READ && rw != WRITE);
 
+	/* create ioc upfront */
+	create_io_context(gfp_mask, q->node);
+
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, rw, NULL, gfp_mask);
 	if (!rq)
@@ -1685,6 +1665,14 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	/*
+	 * Various block parts want %current->io_context and lazy ioc
+	 * allocation ends up trading a lot of pain for a small amount of
+	 * memory.  Just allocate it upfront.  This may fail and block
+	 * layer knows how to live with it.
+	 */
+	create_io_context(GFP_ATOMIC, q->node);
+
 	if (blk_throtl_bio(q, bio))
 		return false;	/* throttled, will be resubmitted later */
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5b06595..e287c19 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1123,9 +1123,6 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		goto out;
 	}
 
-	/* bio_associate_current() needs ioc, try creating */
-	create_io_context(GFP_ATOMIC, q->node);
-
 	/*
 	 * A throtl_grp pointer retrieved under rcu can be used to access
 	 * basic fields like stats and io rates. If a group has no rules,
-- 
1.7.7.3

