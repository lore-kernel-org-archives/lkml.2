Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab1JZBut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:50:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43501 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1JZBtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:03 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/13] block, cfq: move ioc ioprio/cgroup changed handling to cic
Date: Tue, 25 Oct 2011 18:48:33 -0700
Message-Id: <1319593719-19132-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioprio/cgroup change was handled by marking the changed state in ioc
and, on the following access to the ioc, performing RCU-protected
iteration through all cic's grabbing the matching queue_lock.

This patch moves the changed state to each cic.  When ioprio or cgroup
changes, the respective bit is set on all cic's of the ioc and when
each of those cic (not ioc) is accessed, change is applied for that
specific ioc-queue pair.

This also fixes the following two race conditions between setting and
clearing of changed states.

* Missing barrier between assign/load of ioprio and ioprio_changed
  allowed applying old ioprio.

* Change requests could happen between application of change and
  clearing of changed variables.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c        |    2 +-
 block/blk-ioc.c           |   45 +++++++++++++++++++++++++++++++++++++++++++++
 block/cfq-iosched.c       |   28 +++++++++-------------------
 fs/ioprio.c               |    3 +--
 include/linux/iocontext.h |   14 +++++++++-----
 5 files changed, 65 insertions(+), 27 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4b001dc..dc00835 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1648,7 +1648,7 @@ static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	/* we don't lose anything even if ioc allocation fails */
 	ioc = get_task_io_context(tsk, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
-		ioc->cgroup_changed = 1;
+		ioc_cgroup_changed(ioc);
 		put_io_context(ioc);
 	}
 }
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index b13ed96..6f59fba 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -188,6 +188,51 @@ struct io_context *get_task_io_context(struct task_struct *task,
 }
 EXPORT_SYMBOL(get_task_io_context);
 
+void ioc_set_changed(struct io_context *ioc, int which)
+{
+	struct cfq_io_context *cic;
+	struct hlist_node *n;
+
+	hlist_for_each_entry(cic, n, &ioc->cic_list, cic_list)
+		set_bit(which, &cic->changed);
+}
+
+/**
+ * ioc_ioprio_changed - notify ioprio change
+ * @ioc: io_context of interest
+ * @ioprio: new ioprio
+ *
+ * @ioc's ioprio has changed to @ioprio.  Set %CIC_IOPRIO_CHANGED for all
+ * cic's.  iosched is responsible for checking the bit and applying it on
+ * request issue path.
+ */
+void ioc_ioprio_changed(struct io_context *ioc, int ioprio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	ioc->ioprio = ioprio;
+	ioc_set_changed(ioc, CIC_IOPRIO_CHANGED);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+}
+
+/**
+ * ioc_cgroup_changed - notify cgroup change
+ * @ioc: io_context of interest
+ *
+ * @ioc's cgroup has changed.  Set %CIC_CGROUP_CHANGED for all cic's.
+ * iosched is responsible for checking the bit and applying it on request
+ * issue path.
+ */
+void ioc_cgroup_changed(struct io_context *ioc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	ioc_set_changed(ioc, CIC_CGROUP_CHANGED);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+}
+
 static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a612ca6..51aece2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2904,7 +2904,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
-static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
+static void changed_ioprio(struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *cfqq;
@@ -2933,12 +2933,6 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
-static void cfq_ioc_set_ioprio(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, changed_ioprio);
-	ioc->ioprio_changed = 0;
-}
-
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			  pid_t pid, bool is_sync)
 {
@@ -2960,7 +2954,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
+static void changed_cgroup(struct cfq_io_context *cic)
 {
 	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
@@ -2986,12 +2980,6 @@ static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
-
-static void cfq_ioc_set_cgroup(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, changed_cgroup);
-	ioc->cgroup_changed = 0;
-}
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue *
@@ -3222,13 +3210,15 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 out:
 	get_io_context(ioc);
 
-	if (unlikely(ioc->ioprio_changed))
-		cfq_ioc_set_ioprio(ioc);
-
+	if (unlikely(cic->changed)) {
+		if (test_and_clear_bit(CIC_IOPRIO_CHANGED, &cic->changed))
+			changed_ioprio(cic);
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-	if (unlikely(ioc->cgroup_changed))
-		cfq_ioc_set_cgroup(ioc);
+		if (test_and_clear_bit(CIC_CGROUP_CHANGED, &cic->changed))
+			changed_cgroup(cic);
 #endif
+	}
+
 	return cic;
 err:
 	if (cic)
diff --git a/fs/ioprio.c b/fs/ioprio.c
index a4cb730..f8d8429 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -49,8 +49,7 @@ int set_task_ioprio(struct task_struct *task, int ioprio)
 
 	ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
-		ioc->ioprio = ioprio;
-		ioc->ioprio_changed = 1;
+		ioc_ioprio_changed(ioc, ioprio);
 		put_io_context(ioc);
 	}
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 079aea8..2c2b6da 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -13,6 +13,11 @@ struct cfq_ttime {
 	unsigned long ttime_mean;
 };
 
+enum {
+	CIC_IOPRIO_CHANGED,
+	CIC_CGROUP_CHANGED,
+};
+
 struct cfq_io_context {
 	void *key;
 	struct request_queue *q;
@@ -26,6 +31,8 @@ struct cfq_io_context {
 	struct list_head queue_list;
 	struct hlist_node cic_list;
 
+	unsigned long changed;
+
 	void (*dtor)(struct io_context *); /* destructor */
 	void (*exit)(struct io_context *); /* called on task exit */
 
@@ -44,11 +51,6 @@ struct io_context {
 	spinlock_t lock;
 
 	unsigned short ioprio;
-	unsigned short ioprio_changed;
-
-#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
-	unsigned short cgroup_changed;
-#endif
 
 	/*
 	 * For request batching
@@ -81,6 +83,8 @@ void put_io_context(struct io_context *ioc);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node);
+void ioc_ioprio_changed(struct io_context *ioc, int ioprio);
+void ioc_cgroup_changed(struct io_context *ioc);
 #else
 struct io_context;
 static inline void put_io_context(struct io_context *ioc) { }
-- 
1.7.3.1

