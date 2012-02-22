Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2BVBwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:52:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab2BVBrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.229.33 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/36] blkcg: add blkcg_{init|drain|exit}_queue()
Date: Tue, 21 Feb 2012 17:46:46 -0800
Message-Id: <1329875223-5102-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently block core calls directly into blk-throttle for init, drain
and exit.  This patch adds blkcg_{init|drain|exit}_queue() which wraps
the blk-throttle functions.  This is to give more control and
visiblity to blkcg core layer for proper layering.  Further patches
will add logic common to blkcg policies to the functions.

While at it, collapse blk_throtl_release() into blk_throtl_exit().
There's no reason to keep them separate.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h   |    7 +++++++
 block/blk-core.c     |    7 ++++---
 block/blk-sysfs.c    |    4 ++--
 block/blk-throttle.c |    3 ---
 block/blk.h          |    2 --
 6 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 803c3b1..eadc21c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -20,6 +20,7 @@
 #include <linux/genhd.h>
 #include <linux/delay.h>
 #include "blk-cgroup.h"
+#include "blk.h"
 
 #define MAX_KEY_LEN 100
 
@@ -1448,6 +1449,47 @@ done:
 	return &blkcg->css;
 }
 
+/**
+ * blkcg_init_queue - initialize blkcg part of request queue
+ * @q: request_queue to initialize
+ *
+ * Called from blk_alloc_queue_node(). Responsible for initializing blkcg
+ * part of new request_queue @q.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int blkcg_init_queue(struct request_queue *q)
+{
+	might_sleep();
+
+	return blk_throtl_init(q);
+}
+
+/**
+ * blkcg_drain_queue - drain blkcg part of request_queue
+ * @q: request_queue to drain
+ *
+ * Called from blk_drain_queue().  Responsible for draining blkcg part.
+ */
+void blkcg_drain_queue(struct request_queue *q)
+{
+	lockdep_assert_held(q->queue_lock);
+
+	blk_throtl_drain(q);
+}
+
+/**
+ * blkcg_exit_queue - exit and release blkcg part of request_queue
+ * @q: request_queue being released
+ *
+ * Called from blk_release_queue().  Responsible for exiting blkcg part.
+ */
+void blkcg_exit_queue(struct request_queue *q)
+{
+	blk_throtl_exit(q);
+}
+
 /*
  * We cannot support shared io contexts, as we have no mean to support
  * two tasks with the same ioc in two different groups without major rework
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ca1fc63..3bc1710 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -215,6 +215,10 @@ struct blkio_policy_type {
 	enum blkio_policy_id plid;
 };
 
+extern int blkcg_init_queue(struct request_queue *q);
+extern void blkcg_drain_queue(struct request_queue *q);
+extern void blkcg_exit_queue(struct request_queue *q);
+
 /* Blkio controller policy registration */
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
@@ -233,6 +237,9 @@ struct blkio_group {
 struct blkio_policy_type {
 };
 
+static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
+static inline void blkcg_drain_queue(struct request_queue *q) { }
+static inline void blkcg_exit_queue(struct request_queue *q) { }
 static inline void blkio_policy_register(struct blkio_policy_type *blkiop) { }
 static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
 static inline void blkg_destroy_all(struct request_queue *q) { }
diff --git a/block/blk-core.c b/block/blk-core.c
index 4557be3..ad862dc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -34,6 +34,7 @@
 #include <trace/events/block.h>
 
 #include "blk.h"
+#include "blk-cgroup.h"
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
@@ -280,7 +281,7 @@ EXPORT_SYMBOL(blk_stop_queue);
  *
  *     This function does not cancel any asynchronous activity arising
  *     out of elevator or throttling code. That would require elevaotor_exit()
- *     and blk_throtl_exit() to be called with queue lock initialized.
+ *     and blkcg_exit_queue() to be called with queue lock initialized.
  *
  */
 void blk_sync_queue(struct request_queue *q)
@@ -372,7 +373,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		if (q->elevator)
 			elv_drain_elevator(q);
 
-		blk_throtl_drain(q);
+		blkcg_drain_queue(q);
 
 		/*
 		 * This function might be called on a queue which failed
@@ -561,7 +562,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	 */
 	q->queue_lock = &q->__queue_lock;
 
-	if (blk_throtl_init(q))
+	if (blkcg_init_queue(q))
 		goto fail_id;
 
 	return q;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cf15001..00cdc98 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -9,6 +9,7 @@
 #include <linux/blktrace_api.h>
 
 #include "blk.h"
+#include "blk-cgroup.h"
 
 struct queue_sysfs_entry {
 	struct attribute attr;
@@ -486,7 +487,7 @@ static void blk_release_queue(struct kobject *kobj)
 		elevator_exit(q->elevator);
 	}
 
-	blk_throtl_exit(q);
+	blkcg_exit_queue(q);
 
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
@@ -494,7 +495,6 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
-	blk_throtl_release(q);
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index fe6a442..ac6d0fe 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1226,10 +1226,7 @@ void blk_throtl_exit(struct request_queue *q)
 	 * it.
 	 */
 	throtl_shutdown_wq(q);
-}
 
-void blk_throtl_release(struct request_queue *q)
-{
 	kfree(q->td);
 }
 
diff --git a/block/blk.h b/block/blk.h
index 7422f31..de15f92 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -236,7 +236,6 @@ extern bool blk_throtl_bio(struct request_queue *q, struct bio *bio);
 extern void blk_throtl_drain(struct request_queue *q);
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
-extern void blk_throtl_release(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 {
@@ -245,7 +244,6 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 static inline void blk_throtl_drain(struct request_queue *q) { }
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
-static inline void blk_throtl_release(struct request_queue *q) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
 #endif /* BLK_INTERNAL_H */
-- 
1.7.7.3

