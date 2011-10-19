Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1JSE0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44380 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1JSE0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:51 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] block: drop @tsk from attempt_plug_merge() and explain sync rules
Date: Tue, 18 Oct 2011 21:26:23 -0700
Message-Id: <1318998384-22525-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attempt_plug_merge() accesses elevator without holding queue_lock and
may call into ->elevator_bio_merge_fn().  The elvator is guaranteed to
be valid because it's accessed iff the plugged list has requests and
elevator is never exited with live requests, so as long as the
elevator method can deal with unlocked access, this is safe.

Explain the sync rules around attempt_plug_merge() and drop the
unnecessary @tsk parameter.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c         |   28 +++++++++++++++++++++-------
 include/linux/elevator.h |    6 ++++++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fc10f53..2425989 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1204,18 +1204,32 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	return true;
 }
 
-/*
- * Attempts to merge with the plugged list in the current process. Returns
- * true if merge was successful, otherwise false.
+/**
+ * attempt_plug_merge - try to merge with %current's plugged list
+ * @q: request_queue new bio is being queued at
+ * @bio: new bio being queued
+ * @request_count: out parameter for number of traversed plugged requests
+ *
+ * Determine whether @bio being queued on @q can be merged with a request
+ * on %current's plugged list.  Returns %true if merge was successful,
+ * otherwise %false.
+ *
+ * This function is called without @q->queue_lock; however, elevator is
+ * accessed iff there already are requests on the plugged list which in
+ * turn guarantees validity of the elevator.
+ *
+ * Note that, on successful merge, elevator operation
+ * elevator_bio_merged_fn() will be called without queue lock.  Elevator
+ * must be ready for this.
  */
-static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
-			       struct bio *bio, unsigned int *request_count)
+static bool attempt_plug_merge(struct request_queue *q, struct bio *bio,
+			       unsigned int *request_count)
 {
 	struct blk_plug *plug;
 	struct request *rq;
 	bool ret = false;
 
-	plug = tsk->plug;
+	plug = current->plug;
 	if (!plug)
 		goto out;
 	*request_count = 0;
@@ -1283,7 +1297,7 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
-	if (attempt_plug_merge(current, q, bio, &request_count))
+	if (attempt_plug_merge(q, bio, &request_count))
 		return;
 
 	spin_lock_irq(q->queue_lock);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d800d51..1d0f7a2 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -38,6 +38,12 @@ struct elevator_ops
 	elevator_merged_fn *elevator_merged_fn;
 	elevator_merge_req_fn *elevator_merge_req_fn;
 	elevator_allow_merge_fn *elevator_allow_merge_fn;
+
+	/*
+	 * Used for both plugged list and elevator merging and in the
+	 * former case called without queue_lock.  Read comment on top of
+	 * attempt_plug_merge() for details.
+	 */
 	elevator_bio_merged_fn *elevator_bio_merged_fn;
 
 	elevator_dispatch_fn *elevator_dispatch_fn;
-- 
1.7.3.1

