Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2BVBsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:48:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2BVBsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:48:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.244.68 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/36] block: interface update for ioc/icq creation functions
Date: Tue, 21 Feb 2012 17:46:58 -0800
Message-Id: <1329875223-5102-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following interface updates to prepare for future ioc related
changes.

* create_io_context() returning ioc only works for %current because it
  doesn't increment ref on the ioc.  Drop @task parameter from it and
  always assume %current.

* Make create_io_context_slowpath() return 0 or -errno and rename it
  to create_task_io_context().

* Make ioc_create_icq() take @ioc as parameter instead of assuming
  that of %current.  The caller, get_request(), is updated to create
  ioc explicitly and then pass it into ioc_create_icq().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c |    8 +++++---
 block/blk-ioc.c  |   22 ++++++++++------------
 block/blk.h      |   24 +++++++++++-------------
 3 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 69fa8c4..195c5f7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -854,7 +854,7 @@ retry:
 			 */
 			if (!ioc && !retried) {
 				spin_unlock_irq(q->queue_lock);
-				create_io_context(current, gfp_mask, q->node);
+				create_io_context(gfp_mask, q->node);
 				spin_lock_irq(q->queue_lock);
 				retried = true;
 				goto retry;
@@ -918,7 +918,9 @@ retry:
 
 	/* create icq if missing */
 	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
-		icq = ioc_create_icq(q, gfp_mask);
+		ioc = create_io_context(gfp_mask, q->node);
+		if (ioc)
+			icq = ioc_create_icq(ioc, q, gfp_mask);
 		if (!icq)
 			goto fail_alloc;
 	}
@@ -1004,7 +1006,7 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		 * up to a big batch of them for a small period time.
 		 * See ioc_batching, ioc_set_batching
 		 */
-		create_io_context(current, GFP_NOIO, q->node);
+		create_io_context(GFP_NOIO, q->node);
 		ioc_set_batching(q, current->io_context);
 
 		spin_lock_irq(q->queue_lock);
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 92bf555..1092874 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -212,15 +212,14 @@ void ioc_clear_queue(struct request_queue *q)
 	}
 }
 
-void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
-				int node)
+int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 {
 	struct io_context *ioc;
 
 	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags | __GFP_ZERO,
 				    node);
 	if (unlikely(!ioc))
-		return;
+		return -ENOMEM;
 
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
@@ -244,6 +243,8 @@ void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
 	else
 		kmem_cache_free(iocontext_cachep, ioc);
 	task_unlock(task);
+
+	return 0;
 }
 
 /**
@@ -275,7 +276,7 @@ struct io_context *get_task_io_context(struct task_struct *task,
 			return ioc;
 		}
 		task_unlock(task);
-	} while (create_io_context(task, gfp_flags, node));
+	} while (!create_task_io_context(task, gfp_flags, node));
 
 	return NULL;
 }
@@ -319,26 +320,23 @@ EXPORT_SYMBOL(ioc_lookup_icq);
 
 /**
  * ioc_create_icq - create and link io_cq
+ * @ioc: io_context of interest
  * @q: request_queue of interest
  * @gfp_mask: allocation mask
  *
- * Make sure io_cq linking %current->io_context and @q exists.  If either
- * io_context and/or icq don't exist, they will be created using @gfp_mask.
+ * Make sure io_cq linking @ioc and @q exists.  If icq doesn't exist, they
+ * will be created using @gfp_mask.
  *
  * The caller is responsible for ensuring @ioc won't go away and @q is
  * alive and will stay alive until this function returns.
  */
-struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask)
+struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
+			     gfp_t gfp_mask)
 {
 	struct elevator_type *et = q->elevator->type;
-	struct io_context *ioc;
 	struct io_cq *icq;
 
 	/* allocate stuff */
-	ioc = create_io_context(current, gfp_mask, q->node);
-	if (!ioc)
-		return NULL;
-
 	icq = kmem_cache_alloc_node(et->icq_cache, gfp_mask | __GFP_ZERO,
 				    q->node);
 	if (!icq)
diff --git a/block/blk.h b/block/blk.h
index de15f92..aa81afd 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -200,32 +200,30 @@ static inline int blk_do_io_stat(struct request *rq)
  */
 void get_io_context(struct io_context *ioc);
 struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q);
-struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask);
+struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
+			     gfp_t gfp_mask);
 void ioc_clear_queue(struct request_queue *q);
 
-void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_mask,
-				int node);
+int create_task_io_context(struct task_struct *task, gfp_t gfp_mask, int node);
 
 /**
  * create_io_context - try to create task->io_context
- * @task: target task
  * @gfp_mask: allocation mask
  * @node: allocation node
  *
- * If @task->io_context is %NULL, allocate a new io_context and install it.
- * Returns the current @task->io_context which may be %NULL if allocation
- * failed.
+ * If %current->io_context is %NULL, allocate a new io_context and install
+ * it.  Returns the current %current->io_context which may be %NULL if
+ * allocation failed.
  *
  * Note that this function can't be called with IRQ disabled because
- * task_lock which protects @task->io_context is IRQ-unsafe.
+ * task_lock which protects %current->io_context is IRQ-unsafe.
  */
-static inline struct io_context *create_io_context(struct task_struct *task,
-						   gfp_t gfp_mask, int node)
+static inline struct io_context *create_io_context(gfp_t gfp_mask, int node)
 {
 	WARN_ON_ONCE(irqs_disabled());
-	if (unlikely(!task->io_context))
-		create_io_context_slowpath(task, gfp_mask, node);
-	return task->io_context;
+	if (unlikely(!current->io_context))
+		create_task_io_context(current, gfp_mask, node);
+	return current->io_context;
 }
 
 /*
-- 
1.7.7.3

