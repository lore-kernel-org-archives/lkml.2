Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2BPWkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:40:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57140 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2BPWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:38:06 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9] blkcg: use double locking instead of RCU for blkg synchronization
Date: Thu, 16 Feb 2012 14:37:50 -0800
Message-Id: <1329431878-28300-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329431878-28300-1-git-send-email-tj@kernel.org>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkgs are chained from both blkcgs and request_queues and thus
subjected to two locks - blkcg->lock and q->queue_lock.  As both blkcg
and q can go away anytime, locking during removal is tricky.  It's
currently solved by wrapping removal inside RCU, which makes the
synchronization complex.  There are three locks to worry about - the
outer RCU, q lock and blkcg lock, and it leads to nasty subtle
complications like conditional synchronize_rcu() on queue exit paths.

For all other paths, blkcg lock is naturally nested inside q lock and
the only exception is blkcg removal path, which is a very cold path
and can be implemented as clumsy but conceptually-simple reverse
double lock dancing.

This patch updates blkg removal path such that blkgs are removed while
holding both q and blkcg locks, which is trivial for request queue
exit path - blkg_destroy_all().  The blkcg removal path,
blkiocg_pre_destroy(), implements reverse double lock dancing
essentially identical to ioc_release_fn().

This simplifies blkg locking - no half-dead blkgs to worry about.  Now
unnecessary RCU annotations will be removed by the next patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  136 +++++++++++++++++++--------------------------------
 block/blk-cgroup.h |    4 --
 block/cfq.h        |   10 ----
 3 files changed, 51 insertions(+), 99 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ce2dd15..aee71ef 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -620,32 +620,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(blkg_lookup_create);
 
-static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
-{
-	hlist_del_init_rcu(&blkg->blkcg_node);
-}
-
-/*
- * returns 0 if blkio_group was still on cgroup list. Otherwise returns 1
- * indicating that blk_group was unhashed by the time we got to it.
- */
-int blkiocg_del_blkio_group(struct blkio_group *blkg)
-{
-	struct blkio_cgroup *blkcg = blkg->blkcg;
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&blkcg->lock, flags);
-	if (!hlist_unhashed(&blkg->blkcg_node)) {
-		__blkiocg_del_blkio_group(blkg);
-		ret = 0;
-	}
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(blkiocg_del_blkio_group);
-
 /* called under rcu_read_lock(). */
 struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 				struct request_queue *q)
@@ -663,12 +637,16 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
 static void blkg_destroy(struct blkio_group *blkg)
 {
 	struct request_queue *q = blkg->q;
+	struct blkio_cgroup *blkcg = blkg->blkcg;
 
 	lockdep_assert_held(q->queue_lock);
+	lockdep_assert_held(&blkcg->lock);
 
 	/* Something wrong if we are trying to remove same group twice */
 	WARN_ON_ONCE(list_empty(&blkg->q_node));
+	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
 	list_del_init(&blkg->q_node);
+	hlist_del_init_rcu(&blkg->blkcg_node);
 
 	WARN_ON_ONCE(q->nr_blkgs <= 0);
 	q->nr_blkgs--;
@@ -712,47 +690,35 @@ static void update_root_blkg(struct request_queue *q, enum blkio_policy_id plid)
 	pol->ops.blkio_init_group_fn(blkg);
 }
 
+/**
+ * blkg_destroy_all - destroy all blkgs associated with a request_queue
+ * @q: request_queue of interest
+ * @destroy_root: whether to destroy root blkg or not
+ *
+ * Destroy blkgs associated with @q.  If @destroy_root is %true, all are
+ * destroyed; otherwise, root blkg is left alone.
+ */
 void blkg_destroy_all(struct request_queue *q, bool destroy_root)
 {
 	struct blkio_group *blkg, *n;
 	int i;
 
-	while (true) {
-		bool done = true;
-
-		spin_lock_irq(q->queue_lock);
-
-		list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
-			/* skip root? */
-			if (!destroy_root && blkg->blkcg == &blkio_root_cgroup)
-				continue;
-
-			/*
-			 * If cgroup removal path got to blk_group first
-			 * and removed it from cgroup list, then it will
-			 * take care of destroying cfqg also.
-			 */
-			if (!blkiocg_del_blkio_group(blkg))
-				blkg_destroy(blkg);
-			else
-				done = false;
-		}
+	spin_lock_irq(q->queue_lock);
 
-		spin_unlock_irq(q->queue_lock);
+	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
+		struct blkio_cgroup *blkcg = blkg->blkcg;
 
-		/*
-		 * Group list may not be empty if we raced cgroup removal
-		 * and lost.  cgroup removal is guaranteed to make forward
-		 * progress and retrying after a while is enough.  This
-		 * ugliness is scheduled to be removed after locking
-		 * update.
-		 */
-		if (done)
-			break;
+		/* skip root? */
+		if (!destroy_root && blkg->blkcg == &blkio_root_cgroup)
+			continue;
 
-		msleep(10);	/* just some random duration I like */
+		spin_lock(&blkcg->lock);
+		blkg_destroy(blkg);
+		spin_unlock(&blkcg->lock);
 	}
 
+	spin_unlock_irq(q->queue_lock);
+
 	for (i = 0; i < BLKIO_NR_POLICIES; i++)
 		update_root_blkg(q, i);
 }
@@ -1590,45 +1556,45 @@ static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 				ARRAY_SIZE(blkio_files));
 }
 
+/**
+ * blkiocg_pre_destroy - cgroup pre_destroy callback
+ * @subsys: cgroup subsys
+ * @cgroup: cgroup of interest
+ *
+ * This function is called when @cgroup is about to go away and responsible
+ * for shooting down all blkgs associated with @cgroup.  blkgs should be
+ * removed while holding both q and blkcg locks.  As blkcg lock is nested
+ * inside q lock, this function performs reverse double lock dancing.
+ *
+ * This is the blkcg counterpart of ioc_release_fn().
+ */
 static int blkiocg_pre_destroy(struct cgroup_subsys *subsys,
 			       struct cgroup *cgroup)
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
-	unsigned long flags;
-	struct blkio_group *blkg;
-	struct request_queue *q;
 
 	rcu_read_lock();
+	spin_lock_irq(&blkcg->lock);
 
-	do {
-		spin_lock_irqsave(&blkcg->lock, flags);
+	while (!hlist_empty(&blkcg->blkg_list)) {
+		struct blkio_group *blkg = hlist_entry(blkcg->blkg_list.first,
+						struct blkio_group, blkcg_node);
+		struct request_queue *q = rcu_dereference(blkg->q);
 
-		if (hlist_empty(&blkcg->blkg_list)) {
-			spin_unlock_irqrestore(&blkcg->lock, flags);
-			break;
+		if (spin_trylock(q->queue_lock)) {
+			blkg_destroy(blkg);
+			spin_unlock(q->queue_lock);
+		} else {
+			spin_unlock_irq(&blkcg->lock);
+			rcu_read_unlock();
+			cpu_relax();
+			rcu_read_lock();
+			spin_lock(&blkcg->lock);
 		}
+	}
 
-		blkg = hlist_entry(blkcg->blkg_list.first, struct blkio_group,
-					blkcg_node);
-		q = rcu_dereference(blkg->q);
-		__blkiocg_del_blkio_group(blkg);
-
-		spin_unlock_irqrestore(&blkcg->lock, flags);
-
-		/*
-		 * This blkio_group is being unlinked as associated cgroup is
-		 * going away. Let all the IO controlling policies know about
-		 * this event.
-		 */
-		spin_lock(&blkio_list_lock);
-		spin_lock_irqsave(q->queue_lock, flags);
-		blkg_destroy(blkg);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-		spin_unlock(&blkio_list_lock);
-	} while (1);
-
+	spin_unlock_irq(&blkcg->lock);
 	rcu_read_unlock();
-
 	return 0;
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 88b2c3b..bebc442 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -376,7 +376,6 @@ static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg,
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
-extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 				       struct request_queue *q);
 struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
@@ -412,9 +411,6 @@ cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
 static inline struct blkio_cgroup *
 task_blkio_cgroup(struct task_struct *tsk) { return NULL; }
 
-static inline int
-blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
-
 static inline struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 					      void *key) { return NULL; }
 static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
diff --git a/block/cfq.h b/block/cfq.h
index 5584e1b..c8b15ef 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -79,11 +79,6 @@ static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
 					direction, sync);
 }
 
-static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
-{
-	return blkiocg_del_blkio_group(blkg);
-}
-
 #else /* CFQ_GROUP_IOSCHED */
 static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
 			struct blkio_policy_type *pol,
@@ -119,10 +114,5 @@ static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
 			struct blkio_policy_type *pol, uint64_t start_time,
 			uint64_t io_start_time, bool direction, bool sync) { }
 
-static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
-{
-	return 0;
-}
-
 #endif /* CFQ_GROUP_IOSCHED */
 #endif
-- 
1.7.7.3

