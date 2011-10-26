Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1JZBs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:48:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1JZBsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:48:55 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/13] block: make ioc get/put interface more conventional and fix race on alloction
Date: Tue, 25 Oct 2011 18:48:30 -0700
Message-Id: <1319593719-19132-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring copy_io() during fork, io_context can be allocated from two
places - current_io_context() and set_task_ioprio().  The former is
always called from local task while the latter can be called from
different task.  The synchornization between them are peculiar and
dubious.

* current_io_context() doesn't grab task_lock() and assumes that if it
  saw %NULL ->io_context, it would stay that way until allocation and
  assignment is complete.  It has smp_wmb() between alloc/init and
  assignment.

* set_task_ioprio() grabs task_lock() for assignment and does
  smp_read_barrier_depends() between "ioc = task->io_context" and "if
  (ioc)".  Unfortunately, this doesn't achieve anything - the latter
  is not a dependent load of the former.  ie, if ioc itself were being
  dereferenced "ioc->xxx", it would mean something (not sure what tho)
  but as the code currently stands, the dependent read barrier is
  noop.

As only one of the the two test-assignment sequences is task_lock()
protected, the task_lock() can't do much about race between the two.
Nothing prevents current_io_context() and set_task_ioprio() allocating
its own ioc for the same task and overwriting the other's.

Also, set_task_ioprio() can race with exiting task and create a new
ioc after exit_io_context() is finished.

ioc get/put doesn't have any reason to be complex.  The only hot path
is accessing the existing ioc of %current, which is simple to achieve
given that ->io_context is never destroyed as long as the task is
alive.  All other paths can happily go through task_lock() like all
other task sub structures without impacting anything.

This patch updates ioc get/put so that it becomes more conventional.

* alloc_io_context() is replaced with get_task_io_context().  This is
  the only interface which can acquire access to ioc of another task.
  On return, the caller has an explicit reference to the object which
  should be put using put_io_context() afterwards.

* The functionality of current_io_context() remains the same but when
  creating a new ioc, it shares the code path with
  get_task_io_context() and always goes through task_lock().

* get_io_context() now means incrementing ref on an ioc which the
  caller already has access to (be that an explicit refcnt or implicit
  %current one).

* PF_EXITING inhibits creation of new io_context and once
  exit_io_context() is finished, it's guaranteed that both ioc
  acquisition functions return %NULL.

* All users are updated.  Most are trivial but
  smp_read_barrier_depends() removal from cfq_get_io_context() needs a
  bit of explanation.  I suppose the original intention was to ensure
  ioc->ioprio is visible when set_task_ioprio() allocates new
  io_context and installs it; however, this wouldn't have worked
  because set_task_ioprio() doesn't have wmb between init and install.
  There are other problems with this which will be fixed in another
  patch.

* While at it, use NUMA_NO_NODE instead of -1 for wildcard node
  specification.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c        |    9 ++--
 block/blk-ioc.c           |   99 ++++++++++++++++++++++++++++++---------------
 block/blk.h               |    4 ++
 block/cfq-iosched.c       |   18 ++++----
 fs/ioprio.c               |   21 +--------
 include/linux/iocontext.h |    4 +-
 kernel/fork.c             |    8 ++-
 7 files changed, 94 insertions(+), 69 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8f630ce..4b001dc 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1645,11 +1645,12 @@ static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	struct io_context *ioc;
 
-	task_lock(tsk);
-	ioc = tsk->io_context;
-	if (ioc)
+	/* we don't lose anything even if ioc allocation fails */
+	ioc = get_task_io_context(tsk, GFP_ATOMIC, NUMA_NO_NODE);
+	if (ioc) {
 		ioc->cgroup_changed = 1;
-	task_unlock(tsk);
+		put_io_context(ioc);
+	}
 }
 
 void blkio_policy_register(struct blkio_policy_type *blkiop)
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 8bebf06..b13ed96 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -16,6 +16,19 @@
  */
 static struct kmem_cache *iocontext_cachep;
 
+/**
+ * get_io_context - increment reference count to io_context
+ * @ioc: io_context to get
+ *
+ * Increment reference count to @ioc.
+ */
+void get_io_context(struct io_context *ioc)
+{
+	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
+	atomic_long_inc(&ioc->refcount);
+}
+EXPORT_SYMBOL(get_io_context);
+
 static void cfq_dtor(struct io_context *ioc)
 {
 	if (!hlist_empty(&ioc->cic_list)) {
@@ -71,6 +84,9 @@ void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
 
+	/* PF_EXITING prevents new io_context from being attached to @task */
+	WARN_ON_ONCE(!(current->flags & PF_EXITING));
+
 	task_lock(task);
 	ioc = task->io_context;
 	task->io_context = NULL;
@@ -82,7 +98,9 @@ void exit_io_context(struct task_struct *task)
 	put_io_context(ioc);
 }
 
-struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
+static struct io_context *create_task_io_context(struct task_struct *task,
+						 gfp_t gfp_flags, int node,
+						 bool take_ref)
 {
 	struct io_context *ioc;
 
@@ -98,6 +116,20 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->cic_list);
 
+	/* try to install, somebody might already have beaten us to it */
+	task_lock(task);
+
+	if (!task->io_context && !(task->flags & PF_EXITING)) {
+		task->io_context = ioc;
+	} else {
+		kmem_cache_free(iocontext_cachep, ioc);
+		ioc = task->io_context;
+	}
+
+	if (ioc && take_ref)
+		get_io_context(ioc);
+
+	task_unlock(task);
 	return ioc;
 }
 
@@ -114,46 +146,47 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
  */
 struct io_context *current_io_context(gfp_t gfp_flags, int node)
 {
-	struct task_struct *tsk = current;
-	struct io_context *ret;
-
-	ret = tsk->io_context;
-	if (likely(ret))
-		return ret;
-
-	ret = alloc_io_context(gfp_flags, node);
-	if (ret) {
-		/* make sure set_task_ioprio() sees the settings above */
-		smp_wmb();
-		tsk->io_context = ret;
-	}
+	might_sleep_if(gfp_flags & __GFP_WAIT);
 
-	return ret;
+	if (current->io_context)
+		return current->io_context;
+
+	return create_task_io_context(current, gfp_flags, node, false);
 }
+EXPORT_SYMBOL(current_io_context);
 
-/*
- * If the current task has no IO context then create one and initialise it.
- * If it does have a context, take a ref on it.
+/**
+ * get_task_io_context - get io_context of a task
+ * @task: task of interest
+ * @gfp_flags: allocation flags, used if allocation is necessary
+ * @node: allocation node, used if allocation is necessary
+ *
+ * Return io_context of @task.  If it doesn't exist, it is created with
+ * @gfp_flags and @node.  The returned io_context has its reference count
+ * incremented.
  *
- * This is always called in the context of the task which submitted the I/O.
+ * This function always goes through task_lock() and it's better to use
+ * current_io_context() + get_io_context() for %current.
  */
-struct io_context *get_io_context(gfp_t gfp_flags, int node)
+struct io_context *get_task_io_context(struct task_struct *task,
+				       gfp_t gfp_flags, int node)
 {
-	struct io_context *ioc = NULL;
-
-	/*
-	 * Check for unlikely race with exiting task. ioc ref count is
-	 * zero when ioc is being detached.
-	 */
-	do {
-		ioc = current_io_context(gfp_flags, node);
-		if (unlikely(!ioc))
-			break;
-	} while (!atomic_long_inc_not_zero(&ioc->refcount));
+	struct io_context *ioc;
 
-	return ioc;
+	might_sleep_if(gfp_flags & __GFP_WAIT);
+
+	task_lock(task);
+	ioc = task->io_context;
+	if (likely(ioc)) {
+		get_io_context(ioc);
+		task_unlock(task);
+		return ioc;
+	}
+	task_unlock(task);
+
+	return create_task_io_context(task, gfp_flags, node, true);
 }
-EXPORT_SYMBOL(get_io_context);
+EXPORT_SYMBOL(get_task_io_context);
 
 static int __init blk_ioc_init(void)
 {
diff --git a/block/blk.h b/block/blk.h
index 1a97609..f2b36d8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -123,6 +123,7 @@ static inline int blk_should_fake_timeout(struct request_queue *q)
 }
 #endif
 
+void get_io_context(struct io_context *ioc);
 struct io_context *current_io_context(gfp_t gfp_flags, int node);
 
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
@@ -210,4 +211,7 @@ static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_release(struct request_queue *q) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
+extern char __blk_test_mode[2];
+#define blk_test_mode	(__blk_test_mode[0])
+
 #endif /* BLK_INTERNAL_H */
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ec3f5e8b..d42d89c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -14,6 +14,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include "blk.h"
 #include "cfq.h"
 
 /*
@@ -3194,13 +3195,13 @@ static struct cfq_io_context *
 cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
 	struct io_context *ioc = NULL;
-	struct cfq_io_context *cic;
+	struct cfq_io_context *cic = NULL;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	ioc = get_io_context(gfp_mask, cfqd->queue->node);
+	ioc = current_io_context(gfp_mask, cfqd->queue->node);
 	if (!ioc)
-		return NULL;
+		goto err;
 
 	cic = cfq_cic_lookup(cfqd, ioc);
 	if (cic)
@@ -3211,10 +3212,10 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 		goto err;
 
 	if (cfq_cic_link(cfqd, ioc, cic, gfp_mask))
-		goto err_free;
-
+		goto err;
 out:
-	smp_read_barrier_depends();
+	get_io_context(ioc);
+
 	if (unlikely(ioc->ioprio_changed))
 		cfq_ioc_set_ioprio(ioc);
 
@@ -3223,10 +3224,9 @@ out:
 		cfq_ioc_set_cgroup(ioc);
 #endif
 	return cic;
-err_free:
-	cfq_cic_free(cic);
 err:
-	put_io_context(ioc);
+	if (cic)
+		cfq_cic_free(cic);
 	return NULL;
 }
 
diff --git a/fs/ioprio.c b/fs/ioprio.c
index 7da2a06..a4cb730 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -47,28 +47,13 @@ int set_task_ioprio(struct task_struct *task, int ioprio)
 	if (err)
 		return err;
 
-	task_lock(task);
-	do {
-		ioc = task->io_context;
-		/* see wmb() in current_io_context() */
-		smp_read_barrier_depends();
-		if (ioc)
-			break;
-
-		ioc = alloc_io_context(GFP_ATOMIC, -1);
-		if (!ioc) {
-			err = -ENOMEM;
-			break;
-		}
-		task->io_context = ioc;
-	} while (1);
-
-	if (!err) {
+	ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
+	if (ioc) {
 		ioc->ioprio = ioprio;
 		ioc->ioprio_changed = 1;
+		put_io_context(ioc);
 	}
 
-	task_unlock(task);
 	return err;
 }
 EXPORT_SYMBOL_GPL(set_task_ioprio);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 8a6ecb66..28bb621 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -78,8 +78,8 @@ struct task_struct;
 #ifdef CONFIG_BLOCK
 void put_io_context(struct io_context *ioc);
 void exit_io_context(struct task_struct *task);
-struct io_context *get_io_context(gfp_t gfp_flags, int node);
-struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
+struct io_context *get_task_io_context(struct task_struct *task,
+				       gfp_t gfp_flags, int node);
 #else
 struct io_context;
 static inline void put_io_context(struct io_context *ioc) { }
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..11da931 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -878,6 +878,7 @@ static int copy_io(unsigned long clone_flags, struct task_struct *tsk)
 {
 #ifdef CONFIG_BLOCK
 	struct io_context *ioc = current->io_context;
+	struct io_context *new_ioc;
 
 	if (!ioc)
 		return 0;
@@ -889,11 +890,12 @@ static int copy_io(unsigned long clone_flags, struct task_struct *tsk)
 		if (unlikely(!tsk->io_context))
 			return -ENOMEM;
 	} else if (ioprio_valid(ioc->ioprio)) {
-		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
-		if (unlikely(!tsk->io_context))
+		new_ioc = get_task_io_context(tsk, GFP_KERNEL, NUMA_NO_NODE);
+		if (unlikely(!new_ioc))
 			return -ENOMEM;
 
-		tsk->io_context->ioprio = ioc->ioprio;
+		new_ioc->ioprio = ioc->ioprio;
+		put_io_context(new_ioc);
 	}
 #endif
 	return 0;
-- 
1.7.3.1

