Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab1J2Xtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60795 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab1J2Xtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:53 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] block, cfq: replace current_io_context() with create_io_context()
Date: Sat, 29 Oct 2011 16:49:38 -0700
Message-Id: <1319932187-7631-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When called under queue_lock, current_io_context() triggers lockdep
warning if it hits allocation path.  This is because io_context
installation is protected by task_lock which is not IRQ safe, so it
triggers irq-unsafe-lock -> irq -> irq-safe-lock -> irq-unsafe-lock
deadlock warning.

Given the restriction, accessor + creator rolled into one doesn't work
too well.  Drop current_io_context() and let the users access
task->io_context directly inside queue_lock combined with explicit
creation using create_io_context().

Future ioc updates will further consolidate ioc access and the create
interface will be unexported.

While at it, relocate ioc internal interface declarations in blk.h and
add section comments before and after.

This patch does not introduce functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c    |   25 ++++++++++++++++----
 block/blk-ioc.c     |   62 ++++++++++++++-------------------------------------
 block/blk.h         |   36 +++++++++++++++++++++++++++--
 block/cfq-iosched.c |    2 +-
 4 files changed, 71 insertions(+), 54 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 39f1289..74b44ab 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -766,9 +766,12 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 {
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
-	struct io_context *ioc = NULL;
+	struct io_context *ioc;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
+	bool retried = false;
 	int may_queue;
+retry:
+	ioc = current->io_context;
 
 	if (unlikely(blk_queue_dead(q)))
 		return NULL;
@@ -779,7 +782,20 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 
 	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
 		if (rl->count[is_sync]+1 >= q->nr_requests) {
-			ioc = current_io_context(GFP_ATOMIC, q->node);
+			/*
+			 * We want ioc to record batching state.  If it's
+			 * not already there, creating a new one requires
+			 * dropping queue_lock, which in turn requires
+			 * retesting conditions to avoid queue hang.
+			 */
+			if (!ioc && !retried) {
+				spin_unlock_irq(q->queue_lock);
+				create_io_context(current, gfp_mask, q->node);
+				spin_lock_irq(q->queue_lock);
+				retried = true;
+				goto retry;
+			}
+
 			/*
 			 * The queue will fill after this allocation, so set
 			 * it as full, and mark this process as "batching".
@@ -887,7 +903,6 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 	rq = get_request(q, rw_flags, bio, GFP_NOIO);
 	while (!rq) {
 		DEFINE_WAIT(wait);
-		struct io_context *ioc;
 		struct request_list *rl = &q->rq;
 
 		if (unlikely(blk_queue_dead(q)))
@@ -907,8 +922,8 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		 * up to a big batch of them for a small period time.
 		 * See ioc_batching, ioc_set_batching
 		 */
-		ioc = current_io_context(GFP_NOIO, q->node);
-		ioc_set_batching(q, ioc);
+		create_io_context(current, GFP_NOIO, q->node);
+		ioc_set_batching(q, current->io_context);
 
 		spin_lock_irq(q->queue_lock);
 		finish_wait(&rl->wait[is_sync], &wait);
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index fb23965..e23c797 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -205,16 +205,15 @@ void exit_io_context(struct task_struct *task)
 	put_io_context(ioc, NULL);
 }
 
-static struct io_context *create_task_io_context(struct task_struct *task,
-						 gfp_t gfp_flags, int node,
-						 bool take_ref)
+void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
+				int node)
 {
 	struct io_context *ioc;
 
 	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags | __GFP_ZERO,
 				    node);
 	if (unlikely(!ioc))
-		return NULL;
+		return;
 
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
@@ -226,42 +225,13 @@ static struct io_context *create_task_io_context(struct task_struct *task,
 
 	/* try to install, somebody might already have beaten us to it */
 	task_lock(task);
-
-	if (!task->io_context && !(task->flags & PF_EXITING)) {
+	if (!task->io_context && !(task->flags & PF_EXITING))
 		task->io_context = ioc;
-	} else {
+	else
 		kmem_cache_free(iocontext_cachep, ioc);
-		ioc = task->io_context;
-	}
-
-	if (ioc && take_ref)
-		get_io_context(ioc);
-
 	task_unlock(task);
-	return ioc;
 }
-
-/**
- * current_io_context - get io_context of %current
- * @gfp_flags: allocation flags, used if allocation is necessary
- * @node: allocation node, used if allocation is necessary
- *
- * Return io_context of %current.  If it doesn't exist, it is created with
- * @gfp_flags and @node.  The returned io_context does NOT have its
- * reference count incremented.  Because io_context is exited only on task
- * exit, %current can be sure that the returned io_context is valid and
- * alive as long as it is executing.
- */
-struct io_context *current_io_context(gfp_t gfp_flags, int node)
-{
-	might_sleep_if(gfp_flags & __GFP_WAIT);
-
-	if (current->io_context)
-		return current->io_context;
-
-	return create_task_io_context(current, gfp_flags, node, false);
-}
-EXPORT_SYMBOL(current_io_context);
+EXPORT_SYMBOL(create_io_context_slowpath);
 
 /**
  * get_task_io_context - get io_context of a task
@@ -274,7 +244,7 @@ EXPORT_SYMBOL(current_io_context);
  * incremented.
  *
  * This function always goes through task_lock() and it's better to use
- * current_io_context() + get_io_context() for %current.
+ * %current->io_context + get_io_context() for %current.
  */
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node)
@@ -283,16 +253,18 @@ struct io_context *get_task_io_context(struct task_struct *task,
 
 	might_sleep_if(gfp_flags & __GFP_WAIT);
 
-	task_lock(task);
-	ioc = task->io_context;
-	if (likely(ioc)) {
-		get_io_context(ioc);
+	do {
+		task_lock(task);
+		ioc = task->io_context;
+		if (likely(ioc)) {
+			get_io_context(ioc);
+			task_unlock(task);
+			return ioc;
+		}
 		task_unlock(task);
-		return ioc;
-	}
-	task_unlock(task);
+	} while (create_io_context(task, gfp_flags, node));
 
-	return create_task_io_context(task, gfp_flags, node, true);
+	return NULL;
 }
 EXPORT_SYMBOL(get_task_io_context);
 
diff --git a/block/blk.h b/block/blk.h
index 8d42115..5bca266 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -127,9 +127,6 @@ static inline int blk_should_fake_timeout(struct request_queue *q)
 }
 #endif
 
-void get_io_context(struct io_context *ioc);
-struct io_context *current_io_context(gfp_t gfp_flags, int node);
-
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
 		     struct bio *bio);
 int ll_front_merge_fn(struct request_queue *q, struct request *req, 
@@ -198,6 +195,39 @@ static inline int blk_do_io_stat(struct request *rq)
 	        (rq->cmd_flags & REQ_DISCARD));
 }
 
+/*
+ * Internal io_context interface
+ */
+void get_io_context(struct io_context *ioc);
+
+void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_mask,
+				int node);
+
+/**
+ * create_io_context - try to create task->io_context
+ * @task: target task
+ * @gfp_mask: allocation mask
+ * @node: allocation node
+ *
+ * If @task->io_context is %NULL, allocate a new io_context and install it.
+ * Returns the current @task->io_context which may be %NULL if allocation
+ * failed.
+ *
+ * Note that this function can't be called with IRQ disabled because
+ * task_lock which protects @task->io_context is IRQ-unsafe.
+ */
+static inline struct io_context *create_io_context(struct task_struct *task,
+						   gfp_t gfp_mask, int node)
+{
+	WARN_ON_ONCE(irqs_disabled());
+	if (unlikely(!task->io_context))
+		create_io_context_slowpath(task, gfp_mask, node);
+	return task->io_context;
+}
+
+/*
+ * Internal throttling interface
+ */
 #ifdef CONFIG_BLK_DEV_THROTTLING
 extern bool blk_throtl_bio(struct request_queue *q, struct bio *bio);
 extern void blk_throtl_drain(struct request_queue *q);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3b07ce1..5f7e4d1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3012,7 +3012,7 @@ static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	/* allocate stuff */
-	ioc = current_io_context(gfp_mask, q->node);
+	ioc = create_io_context(current, gfp_mask, q->node);
 	if (!ioc)
 		goto out;
 
-- 
1.7.3.1

