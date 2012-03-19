Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab2CSWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:11:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab2CSWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:11:16 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] block: remove ioc_*_changed()
Date: Mon, 19 Mar 2012 15:10:59 -0700
Message-Id: <1332195059-2750-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332195059-2750-1-git-send-email-tj@kernel.org>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous patch to cfq, there's no ioc_get_changed() user
left.  This patch yanks out ioc_{ioprio|cgroup|get}_changed() and all
related stuff.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c        |   19 ------------
 block/blk-ioc.c           |   68 ---------------------------------------------
 fs/ioprio.c               |    2 +-
 include/linux/iocontext.h |    7 ----
 4 files changed, 1 insertions(+), 95 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 30e0730..a74019b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -47,8 +47,6 @@ static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
 static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
 			      struct cgroup_taskset *);
-static void blkiocg_attach(struct cgroup_subsys *, struct cgroup *,
-			   struct cgroup_taskset *);
 static int blkiocg_pre_destroy(struct cgroup_subsys *, struct cgroup *);
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
@@ -63,7 +61,6 @@ struct cgroup_subsys blkio_subsys = {
 	.name = "blkio",
 	.create = blkiocg_create,
 	.can_attach = blkiocg_can_attach,
-	.attach = blkiocg_attach,
 	.pre_destroy = blkiocg_pre_destroy,
 	.destroy = blkiocg_destroy,
 	.populate = blkiocg_populate,
@@ -1729,22 +1726,6 @@ static int blkiocg_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	return ret;
 }
 
-static void blkiocg_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			   struct cgroup_taskset *tset)
-{
-	struct task_struct *task;
-	struct io_context *ioc;
-
-	cgroup_taskset_for_each(task, cgrp, tset) {
-		/* we don't lose anything even if ioc allocation fails */
-		ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
-		if (ioc) {
-			ioc_cgroup_changed(ioc);
-			put_io_context(ioc);
-		}
-	}
-}
-
 static void blkcg_bypass_start(void)
 	__acquires(&all_q_mutex)
 {
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 439ec21..3f3dd51 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -388,74 +388,6 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 	return icq;
 }
 
-void ioc_set_icq_flags(struct io_context *ioc, unsigned int flags)
-{
-	struct io_cq *icq;
-	struct hlist_node *n;
-
-	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node)
-		icq->flags |= flags;
-}
-
-/**
- * ioc_ioprio_changed - notify ioprio change
- * @ioc: io_context of interest
- * @ioprio: new ioprio
- *
- * @ioc's ioprio has changed to @ioprio.  Set %ICQ_IOPRIO_CHANGED for all
- * icq's.  iosched is responsible for checking the bit and applying it on
- * request issue path.
- */
-void ioc_ioprio_changed(struct io_context *ioc, int ioprio)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioc->lock, flags);
-	ioc->ioprio = ioprio;
-	ioc_set_icq_flags(ioc, ICQ_IOPRIO_CHANGED);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-}
-
-/**
- * ioc_cgroup_changed - notify cgroup change
- * @ioc: io_context of interest
- *
- * @ioc's cgroup has changed.  Set %ICQ_CGROUP_CHANGED for all icq's.
- * iosched is responsible for checking the bit and applying it on request
- * issue path.
- */
-void ioc_cgroup_changed(struct io_context *ioc)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioc->lock, flags);
-	ioc_set_icq_flags(ioc, ICQ_CGROUP_CHANGED);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-}
-EXPORT_SYMBOL(ioc_cgroup_changed);
-
-/**
- * icq_get_changed - fetch and clear icq changed mask
- * @icq: icq of interest
- *
- * Fetch and clear ICQ_*_CHANGED bits from @icq.  Grabs and releases
- * @icq->ioc->lock.
- */
-unsigned icq_get_changed(struct io_cq *icq)
-{
-	unsigned int changed = 0;
-	unsigned long flags;
-
-	if (unlikely(icq->flags & ICQ_CHANGED_MASK)) {
-		spin_lock_irqsave(&icq->ioc->lock, flags);
-		changed = icq->flags & ICQ_CHANGED_MASK;
-		icq->flags &= ~ICQ_CHANGED_MASK;
-		spin_unlock_irqrestore(&icq->ioc->lock, flags);
-	}
-	return changed;
-}
-EXPORT_SYMBOL(icq_get_changed);
-
 static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
diff --git a/fs/ioprio.c b/fs/ioprio.c
index 0f1b951..4864437 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -50,7 +50,7 @@ int set_task_ioprio(struct task_struct *task, int ioprio)
 
 	ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
-		ioc_ioprio_changed(ioc, ioprio);
+		ioc->ioprio = ioprio;
 		put_io_context(ioc);
 	}
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 6f1a260..df38db2 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -6,11 +6,7 @@
 #include <linux/workqueue.h>
 
 enum {
-	ICQ_IOPRIO_CHANGED	= 1 << 0,
-	ICQ_CGROUP_CHANGED	= 1 << 1,
 	ICQ_EXITED		= 1 << 2,
-
-	ICQ_CHANGED_MASK	= ICQ_IOPRIO_CHANGED | ICQ_CGROUP_CHANGED,
 };
 
 /*
@@ -152,9 +148,6 @@ void put_io_context_active(struct io_context *ioc);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node);
-void ioc_ioprio_changed(struct io_context *ioc, int ioprio);
-void ioc_cgroup_changed(struct io_context *ioc);
-unsigned int icq_get_changed(struct io_cq *icq);
 #else
 struct io_context;
 static inline void put_io_context(struct io_context *ioc) { }
-- 
1.7.7.3

