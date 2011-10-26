Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1JZBsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:48:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42275 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab1JZBsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:48:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/13] block: misc ioc cleanups
Date: Tue, 25 Oct 2011 18:48:29 -0700
Message-Id: <1319593719-19132-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* int return from put_io_context() wasn't used by anybody.  Make it
  return void like other put functions and docbook-fy the function
  comment.

* Reorder dummy declarations for !CONFIG_BLOCK case a bit.

* Make alloc_ioc_context() use __GFP_ZERO allocation, take init out of
  if block and drop 0'ing.

* Docbook-fy current_io_context() comment.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-ioc.c           |   72 ++++++++++++++++++++++----------------------
 include/linux/iocontext.h |   12 ++-----
 2 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 6f9bbd9..8bebf06 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -27,26 +27,28 @@ static void cfq_dtor(struct io_context *ioc)
 	}
 }
 
-/*
- * IO Context helper functions. put_io_context() returns 1 if there are no
- * more users of this io context, 0 otherwise.
+/**
+ * put_io_context - put a reference of io_context
+ * @ioc: io_context to put
+ *
+ * Decrement reference count of @ioc and release it if the count reaches
+ * zero.
  */
-int put_io_context(struct io_context *ioc)
+void put_io_context(struct io_context *ioc)
 {
 	if (ioc == NULL)
-		return 1;
+		return;
 
-	BUG_ON(atomic_long_read(&ioc->refcount) == 0);
+	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
 
-	if (atomic_long_dec_and_test(&ioc->refcount)) {
-		rcu_read_lock();
-		cfq_dtor(ioc);
-		rcu_read_unlock();
+	if (!atomic_long_dec_and_test(&ioc->refcount))
+		return;
 
-		kmem_cache_free(iocontext_cachep, ioc);
-		return 1;
-	}
-	return 0;
+	rcu_read_lock();
+	cfq_dtor(ioc);
+	rcu_read_unlock();
+
+	kmem_cache_free(iocontext_cachep, ioc);
 }
 EXPORT_SYMBOL(put_io_context);
 
@@ -84,33 +86,31 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 {
 	struct io_context *ioc;
 
-	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
-	if (ioc) {
-		atomic_long_set(&ioc->refcount, 1);
-		atomic_set(&ioc->nr_tasks, 1);
-		spin_lock_init(&ioc->lock);
-		ioc->ioprio_changed = 0;
-		ioc->ioprio = 0;
-		ioc->last_waited = 0; /* doesn't matter... */
-		ioc->nr_batch_requests = 0; /* because this is 0 */
-		INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
-		INIT_HLIST_HEAD(&ioc->cic_list);
-		ioc->ioc_data = NULL;
-#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
-		ioc->cgroup_changed = 0;
-#endif
-	}
+	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags | __GFP_ZERO,
+				    node);
+	if (unlikely(!ioc))
+		return NULL;
+
+	/* initialize */
+	atomic_long_set(&ioc->refcount, 1);
+	atomic_set(&ioc->nr_tasks, 1);
+	spin_lock_init(&ioc->lock);
+	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
+	INIT_HLIST_HEAD(&ioc->cic_list);
 
 	return ioc;
 }
 
-/*
- * If the current task has no IO context then create one and initialise it.
- * Otherwise, return its existing IO context.
+/**
+ * current_io_context - get io_context of %current
+ * @gfp_flags: allocation flags, used if allocation is necessary
+ * @node: allocation node, used if allocation is necessary
  *
- * This returned IO context doesn't have a specifically elevated refcount,
- * but since the current task itself holds a reference, the context can be
- * used in general code, so long as it stays within `current` context.
+ * Return io_context of %current.  If it doesn't exist, it is created with
+ * @gfp_flags and @node.  The returned io_context does NOT have its
+ * reference count incremented.  Because io_context is exited only on task
+ * exit, %current can be sure that the returned io_context is valid and
+ * alive as long as it is executing.
  */
 struct io_context *current_io_context(gfp_t gfp_flags, int node)
 {
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 5037a0a..8a6ecb66 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -76,20 +76,14 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 
 struct task_struct;
 #ifdef CONFIG_BLOCK
-int put_io_context(struct io_context *ioc);
+void put_io_context(struct io_context *ioc);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
 #else
-static inline void exit_io_context(struct task_struct *task)
-{
-}
-
 struct io_context;
-static inline int put_io_context(struct io_context *ioc)
-{
-	return 1;
-}
+static inline void put_io_context(struct io_context *ioc) { }
+static inline void exit_io_context(struct task_struct *task) { }
 #endif
 
 #endif
-- 
1.7.3.1

