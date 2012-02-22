Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2BVBr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:47:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2BVBrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.211.131 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/36] block: extend queue bypassing to cover blkcg policies
Date: Tue, 21 Feb 2012 17:46:34 -0800
Message-Id: <1329875223-5102-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
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
index bf6332c..0f1bbdd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -372,8 +372,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		if (q->elevator)
 			elv_drain_elevator(q);
 
-		if (drain_all)
-			blk_throtl_drain(q);
+		blk_throtl_drain(q);
 
 		/*
 		 * This function might be called on a queue which failed
@@ -415,8 +414,8 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
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
@@ -461,6 +460,11 @@ void blk_cleanup_queue(struct request_queue *q)
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

