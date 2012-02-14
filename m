Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2BNSMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:12:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52202 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2BNSMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:12:51 -0500
Date: Tue, 14 Feb 2012 10:12:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, ShaohuaLishli@kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH block/for-linus 1/3] block: replace icq->changed with
 icq->flags
Message-ID: <20120214181245.GS12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

icq->changed was used for ICQ_*_CHANGED bits.  Rename it to flags and
access it under ioc->lock instead of using atomic bitops.
ioc_get_changed() is added so that the changed part can be fetched and
cleared as before.

icq->flags will be used to carry other flags.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Jens, these three patches are to fix the swap heavy workload
regression reported by Shaohua.

Shaohua, I ended up changing the second patch, which shouldn't change
anything but it would be great if you can verify this series once
more.

Thank you!

 block/blk-ioc.c           |   30 ++++++++++++++++++++++++++----
 block/cfq-iosched.c       |   12 ++++++------
 include/linux/iocontext.h |    9 ++++++---
 3 files changed, 38 insertions(+), 13 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -363,13 +363,13 @@ struct io_cq *ioc_create_icq(struct requ
 	return icq;
 }
 
-void ioc_set_changed(struct io_context *ioc, int which)
+void ioc_set_icq_flags(struct io_context *ioc, unsigned int flags)
 {
 	struct io_cq *icq;
 	struct hlist_node *n;
 
 	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node)
-		set_bit(which, &icq->changed);
+		icq->flags |= flags;
 }
 
 /**
@@ -387,7 +387,7 @@ void ioc_ioprio_changed(struct io_contex
 
 	spin_lock_irqsave(&ioc->lock, flags);
 	ioc->ioprio = ioprio;
-	ioc_set_changed(ioc, ICQ_IOPRIO_CHANGED);
+	ioc_set_icq_flags(ioc, ICQ_IOPRIO_CHANGED);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
@@ -404,11 +404,33 @@ void ioc_cgroup_changed(struct io_contex
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->lock, flags);
-	ioc_set_changed(ioc, ICQ_CGROUP_CHANGED);
+	ioc_set_icq_flags(ioc, ICQ_CGROUP_CHANGED);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 EXPORT_SYMBOL(ioc_cgroup_changed);
 
+/**
+ * icq_get_changed - fetch and clear icq changed mask
+ * @icq: icq of interest
+ *
+ * Fetch and clear ICQ_*_CHANGED bits from @icq.  Grabs and releases
+ * @icq->ioc->lock.
+ */
+unsigned icq_get_changed(struct io_cq *icq)
+{
+	unsigned int changed = 0;
+	unsigned long flags;
+
+	if (unlikely(icq->flags & ICQ_CHANGED_MASK)) {
+		spin_lock_irqsave(&icq->ioc->lock, flags);
+		changed = icq->flags & ICQ_CHANGED_MASK;
+		icq->flags &= ~ICQ_CHANGED_MASK;
+		spin_unlock_irqrestore(&icq->ioc->lock, flags);
+	}
+	return changed;
+}
+EXPORT_SYMBOL(icq_get_changed);
+
 static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -3470,20 +3470,20 @@ cfq_set_request(struct request_queue *q,
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
+	unsigned int changed;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	spin_lock_irq(q->queue_lock);
 
 	/* handle changed notifications */
-	if (unlikely(cic->icq.changed)) {
-		if (test_and_clear_bit(ICQ_IOPRIO_CHANGED, &cic->icq.changed))
-			changed_ioprio(cic);
+	changed = icq_get_changed(&cic->icq);
+	if (unlikely(changed & ICQ_IOPRIO_CHANGED))
+		changed_ioprio(cic);
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-		if (test_and_clear_bit(ICQ_CGROUP_CHANGED, &cic->icq.changed))
-			changed_cgroup(cic);
+	if (unlikely(changed & ICQ_CGROUP_CHANGED))
+		changed_cgroup(cic);
 #endif
-	}
 
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
Index: work/include/linux/iocontext.h
===================================================================
--- work.orig/include/linux/iocontext.h
+++ work/include/linux/iocontext.h
@@ -6,8 +6,10 @@
 #include <linux/workqueue.h>
 
 enum {
-	ICQ_IOPRIO_CHANGED,
-	ICQ_CGROUP_CHANGED,
+	ICQ_IOPRIO_CHANGED	= 1 << 0,
+	ICQ_CGROUP_CHANGED	= 1 << 1,
+
+	ICQ_CHANGED_MASK	= ICQ_IOPRIO_CHANGED | ICQ_CGROUP_CHANGED,
 };
 
 /*
@@ -88,7 +90,7 @@ struct io_cq {
 		struct rcu_head		__rcu_head;
 	};
 
-	unsigned long		changed;
+	unsigned int		flags;
 };
 
 /*
@@ -139,6 +141,7 @@ struct io_context *get_task_io_context(s
 				       gfp_t gfp_flags, int node);
 void ioc_ioprio_changed(struct io_context *ioc, int ioprio);
 void ioc_cgroup_changed(struct io_context *ioc);
+unsigned int icq_get_changed(struct io_cq *icq);
 #else
 struct io_context;
 static inline void put_io_context(struct io_context *ioc) { }
