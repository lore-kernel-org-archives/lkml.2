Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2DMUNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:13:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2DMUL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:11:57 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Date: Fri, 13 Apr 2012 13:11:31 -0700
Message-Id: <1334347895-6268-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous change to guarantee bypass visiblity for RCU read
lock regions, entering bypass mode involves non-trivial overhead and
future changes are scheduled to make use of bypass mode during init
path.  Combined it may end up adding noticeable delay during boot.

This patch makes request_queue start its life in bypass mode, which is
ended on queue init completion at the end of
blk_init_allocated_queue(), and updates blk_queue_bypass_start() such
that draining and RCU synchronization are performed only when the
queue actually enters bypass mode.

This avoids unnecessarily switching in and out of bypass mode during
init avoiding the overhead and any nasty surprises which may step from
leaving bypass mode on half-initialized queues.

The boot time overhead was pointed out by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a4b3eaf..86027cd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -421,14 +421,18 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
  */
 void blk_queue_bypass_start(struct request_queue *q)
 {
+	bool drain;
+
 	spin_lock_irq(q->queue_lock);
-	q->bypass_depth++;
+	drain = !q->bypass_depth++;
 	queue_flag_set(QUEUE_FLAG_BYPASS, q);
 	spin_unlock_irq(q->queue_lock);
 
-	blk_drain_queue(q, false);
-	/* ensure blk_queue_bypass() is %true inside RCU read lock */
-	synchronize_rcu();
+	if (drain) {
+		blk_drain_queue(q, false);
+		/* ensure blk_queue_bypass() is %true inside RCU read lock */
+		synchronize_rcu();
+	}
 }
 EXPORT_SYMBOL_GPL(blk_queue_bypass_start);
 
@@ -569,6 +573,15 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	 */
 	q->queue_lock = &q->__queue_lock;
 
+	/*
+	 * A queue starts its life with bypass turned on to avoid
+	 * unnecessary bypass on/off overhead and nasty surprises during
+	 * init.  The initial bypass will be finished at the end of
+	 * blk_init_allocated_queue().
+	 */
+	q->bypass_depth = 1;
+	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
+
 	if (blkcg_init_queue(q))
 		goto fail_id;
 
@@ -664,15 +677,15 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 
 	q->sg_reserved_size = INT_MAX;
 
-	/*
-	 * all done
-	 */
-	if (!elevator_init(q, NULL)) {
-		blk_queue_congestion_threshold(q);
-		return q;
-	}
+	/* init elevator */
+	if (elevator_init(q, NULL))
+		return NULL;
 
-	return NULL;
+	blk_queue_congestion_threshold(q);
+
+	/* all done, end the initial bypass */
+	blk_queue_bypass_end(q);
+	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
 
-- 
1.7.7.3

