Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2BAUxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:53:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33552 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2BAUut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:50:49 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/16] block: extend queue bypassing to cover blkcg policies
Date: Wed,  1 Feb 2012 12:50:19 -0800
Message-Id: <1328129429-11823-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328129429-11823-1-git-send-email-tj@kernel.org>
References: <1328129429-11823-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend queue bypassing such that dying queue is always bypassing and
blk-throttle is drained on bypass.  With blkcg policies updated to
test blk_queue_bypass() instead of blk_queue_dead(), this ensures that
no bio or request is held by or going through blkcg policies on a
bypassing queue.

This will be used to implement blkg cleanup on elevator switches and
policy changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |   12 ++++++++----
 block/blk-throttle.c |    4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c2e39de..c6c61c0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -366,8 +366,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		spin_lock_irq(q->queue_lock);
 
 		elv_drain_elevator(q);
-		if (drain_all)
-			blk_throtl_drain(q);
+		blk_throtl_drain(q);
 
 		/*
 		 * This function might be called on a queue which failed
@@ -408,8 +407,8 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
  *
  * In bypass mode, only the dispatch FIFO queue of @q is used.  This
  * function makes @q enter bypass mode and drains all requests which were
- * issued before.  On return, it's guaranteed that no request has ELVPRIV
- * set.
+ * throttled or issued before.  On return, it's guaranteed that no request
+ * is being throttled or has ELVPRIV set.
  */
 void blk_queue_bypass_start(struct request_queue *q)
 {
@@ -454,6 +453,11 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 
 	spin_lock_irq(lock);
+
+	/* dead queue is permanently in bypass mode till released */
+	q->bypass_depth++;
+	queue_flag_set(QUEUE_FLAG_BYPASS, q);
+
 	queue_flag_set(QUEUE_FLAG_NOMERGES, q);
 	queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5eed6a7..702c0e6 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -310,7 +310,7 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	struct request_queue *q = td->queue;
 
 	/* no throttling for dead queue */
-	if (unlikely(blk_queue_dead(q)))
+	if (unlikely(blk_queue_bypass(q)))
 		return NULL;
 
 	rcu_read_lock();
@@ -335,7 +335,7 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	spin_lock_irq(q->queue_lock);
 
 	/* Make sure @q is still alive */
-	if (unlikely(blk_queue_dead(q))) {
+	if (unlikely(blk_queue_bypass(q))) {
 		kfree(tg);
 		return NULL;
 	}
-- 
1.7.7.3

