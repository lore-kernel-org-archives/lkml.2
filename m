Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2BAUvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:51:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab2BAUvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:51:01 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] blkcg: use q and plid instead of opaque void * for blkio_group association
Date: Wed,  1 Feb 2012 12:50:23 -0800
Message-Id: <1328129429-11823-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328129429-11823-1-git-send-email-tj@kernel.org>
References: <1328129429-11823-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkgio_group is association between a block cgroup and a queue for a
given policy.  Using opaque void * for association makes things
confusing and hinders factoring of common code.  Use request_queue *
and, if necessary, policy id instead.

This will help block cgroup API cleanup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   32 +++++++++++++++-----------------
 block/blk-cgroup.h   |   22 ++++++++++++----------
 block/blk-throttle.c |   50 +++++++++++++++++++++++---------------------------
 block/cfq-iosched.c  |   30 ++++++++++++++++--------------
 block/cfq.h          |    7 ++++---
 5 files changed, 70 insertions(+), 71 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2d2986a..cd9fbae 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -129,7 +129,7 @@ blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
 		if (blkiop->plid != blkg->plid)
 			continue;
 		if (blkiop->ops.blkio_update_group_weight_fn)
-			blkiop->ops.blkio_update_group_weight_fn(blkg->key,
+			blkiop->ops.blkio_update_group_weight_fn(blkg->q,
 							blkg, weight);
 	}
 }
@@ -147,12 +147,12 @@ static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
 
 		if (fileid == BLKIO_THROTL_read_bps_device
 		    && blkiop->ops.blkio_update_group_read_bps_fn)
-			blkiop->ops.blkio_update_group_read_bps_fn(blkg->key,
+			blkiop->ops.blkio_update_group_read_bps_fn(blkg->q,
 								blkg, bps);
 
 		if (fileid == BLKIO_THROTL_write_bps_device
 		    && blkiop->ops.blkio_update_group_write_bps_fn)
-			blkiop->ops.blkio_update_group_write_bps_fn(blkg->key,
+			blkiop->ops.blkio_update_group_write_bps_fn(blkg->q,
 								blkg, bps);
 	}
 }
@@ -170,12 +170,12 @@ static inline void blkio_update_group_iops(struct blkio_group *blkg,
 
 		if (fileid == BLKIO_THROTL_read_iops_device
 		    && blkiop->ops.blkio_update_group_read_iops_fn)
-			blkiop->ops.blkio_update_group_read_iops_fn(blkg->key,
+			blkiop->ops.blkio_update_group_read_iops_fn(blkg->q,
 								blkg, iops);
 
 		if (fileid == BLKIO_THROTL_write_iops_device
 		    && blkiop->ops.blkio_update_group_write_iops_fn)
-			blkiop->ops.blkio_update_group_write_iops_fn(blkg->key,
+			blkiop->ops.blkio_update_group_write_iops_fn(blkg->q,
 								blkg,iops);
 	}
 }
@@ -478,14 +478,14 @@ int blkio_alloc_blkg_stats(struct blkio_group *blkg)
 EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats);
 
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-		struct blkio_group *blkg, void *key, dev_t dev,
+		struct blkio_group *blkg, struct request_queue *q, dev_t dev,
 		enum blkio_policy_id plid)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkcg->lock, flags);
 	spin_lock_init(&blkg->stats_lock);
-	rcu_assign_pointer(blkg->key, key);
+	rcu_assign_pointer(blkg->q, q);
 	blkg->blkcg_id = css_id(&blkcg->css);
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	blkg->plid = plid;
@@ -531,18 +531,16 @@ int blkiocg_del_blkio_group(struct blkio_group *blkg)
 EXPORT_SYMBOL_GPL(blkiocg_del_blkio_group);
 
 /* called under rcu_read_lock(). */
-struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
+struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
+					 struct request_queue *q,
+					 enum blkio_policy_id plid)
 {
 	struct blkio_group *blkg;
 	struct hlist_node *n;
-	void *__key;
 
-	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		__key = blkg->key;
-		if (__key == key)
+	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node)
+		if (blkg->q == q && blkg->plid == plid)
 			return blkg;
-	}
-
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(blkiocg_lookup_group);
@@ -1582,7 +1580,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	unsigned long flags;
 	struct blkio_group *blkg;
-	void *key;
+	struct request_queue *q;
 	struct blkio_policy_type *blkiop;
 	struct blkio_policy_node *pn, *pntmp;
 
@@ -1597,7 +1595,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 
 		blkg = hlist_entry(blkcg->blkg_list.first, struct blkio_group,
 					blkcg_node);
-		key = rcu_dereference(blkg->key);
+		q = rcu_dereference(blkg->q);
 		__blkiocg_del_blkio_group(blkg);
 
 		spin_unlock_irqrestore(&blkcg->lock, flags);
@@ -1611,7 +1609,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		list_for_each_entry(blkiop, &blkio_list, list) {
 			if (blkiop->plid != blkg->plid)
 				continue;
-			blkiop->ops.blkio_unlink_group_fn(key, blkg);
+			blkiop->ops.blkio_unlink_group_fn(q, blkg);
 		}
 		spin_unlock(&blkio_list_lock);
 	} while (1);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e5cfcbd..41c960b 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -153,8 +153,8 @@ struct blkio_group_stats_cpu {
 };
 
 struct blkio_group {
-	/* An rcu protected unique identifier for the group */
-	void *key;
+	/* Pointer to the associated request_queue, RCU protected */
+	struct request_queue __rcu *q;
 	struct hlist_node blkcg_node;
 	unsigned short blkcg_id;
 	/* Store cgroup path */
@@ -202,17 +202,18 @@ extern unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg,
 extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 
-typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
+typedef void (blkio_unlink_group_fn)(struct request_queue *q,
+			struct blkio_group *blkg);
 typedef bool (blkio_clear_queue_fn)(struct request_queue *q);
-typedef void (blkio_update_group_weight_fn) (void *key,
+typedef void (blkio_update_group_weight_fn)(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int weight);
-typedef void (blkio_update_group_read_bps_fn) (void * key,
+typedef void (blkio_update_group_read_bps_fn)(struct request_queue *q,
 			struct blkio_group *blkg, u64 read_bps);
-typedef void (blkio_update_group_write_bps_fn) (void *key,
+typedef void (blkio_update_group_write_bps_fn)(struct request_queue *q,
 			struct blkio_group *blkg, u64 write_bps);
-typedef void (blkio_update_group_read_iops_fn) (void *key,
+typedef void (blkio_update_group_read_iops_fn)(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int read_iops);
-typedef void (blkio_update_group_write_iops_fn) (void *key,
+typedef void (blkio_update_group_write_iops_fn)(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int write_iops);
 
 struct blkio_policy_ops {
@@ -305,12 +306,13 @@ extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-	struct blkio_group *blkg, void *key, dev_t dev,
+	struct blkio_group *blkg, struct request_queue *q, dev_t dev,
 	enum blkio_policy_id plid);
 extern int blkio_alloc_blkg_stats(struct blkio_group *blkg);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
-						void *key);
+						struct request_queue *q,
+						enum blkio_policy_id plid);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 					unsigned long time,
 					unsigned long unaccounted_time);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c252df9..6613de7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -252,7 +252,7 @@ static void throtl_init_add_tg_lists(struct throtl_data *td,
 	__throtl_tg_fill_dev_details(td, tg);
 
 	/* Add group onto cgroup list */
-	blkiocg_add_blkio_group(blkcg, &tg->blkg, (void *)td,
+	blkiocg_add_blkio_group(blkcg, &tg->blkg, td->queue,
 				tg->blkg.dev, BLKIO_POLICY_THROTL);
 
 	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
@@ -288,7 +288,6 @@ static struct
 throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 {
 	struct throtl_grp *tg = NULL;
-	void *key = td;
 
 	/*
 	 * This is the common case when there are no blkio cgroups.
@@ -297,7 +296,8 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	if (blkcg == &blkio_root_cgroup)
 		tg = td->root_tg;
 	else
-		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
+		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, td->queue,
+						     BLKIO_POLICY_THROTL));
 
 	__throtl_tg_fill_dev_details(td, tg);
 	return tg;
@@ -1012,22 +1012,22 @@ static bool throtl_release_tgs(struct throtl_data *td, bool release_root)
  * no new IO will come in this group. So get rid of this group as soon as
  * any pending IO in the group is finished.
  *
- * This function is called under rcu_read_lock(). key is the rcu protected
- * pointer. That means "key" is a valid throtl_data pointer as long as we are
- * rcu read lock.
+ * This function is called under rcu_read_lock(). @q is the rcu protected
+ * pointer. That means @q is a valid request_queue pointer as long as we
+ * are rcu read lock.
  *
- * "key" was fetched from blkio_group under blkio_cgroup->lock. That means
+ * @q was fetched from blkio_group under blkio_cgroup->lock. That means
  * it should not be NULL as even if queue was going away, cgroup deltion
  * path got to it first.
  */
-void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
+void throtl_unlink_blkio_group(struct request_queue *q,
+			       struct blkio_group *blkg)
 {
 	unsigned long flags;
-	struct throtl_data *td = key;
 
-	spin_lock_irqsave(td->queue->queue_lock, flags);
-	throtl_destroy_tg(td, tg_of_blkg(blkg));
-	spin_unlock_irqrestore(td->queue->queue_lock, flags);
+	spin_lock_irqsave(q->queue_lock, flags);
+	throtl_destroy_tg(q->td, tg_of_blkg(blkg));
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 static bool throtl_clear_queue(struct request_queue *q)
@@ -1054,52 +1054,48 @@ static void throtl_update_blkio_group_common(struct throtl_data *td,
 }
 
 /*
- * For all update functions, key should be a valid pointer because these
+ * For all update functions, @q should be a valid pointer because these
  * update functions are called under blkcg_lock, that means, blkg is
- * valid and in turn key is valid. queue exit path can not race because
+ * valid and in turn @q is valid. queue exit path can not race because
  * of blkcg_lock
  *
  * Can not take queue lock in update functions as queue lock under blkcg_lock
  * is not allowed. Under other paths we take blkcg_lock under queue_lock.
  */
-static void throtl_update_blkio_group_read_bps(void *key,
+static void throtl_update_blkio_group_read_bps(struct request_queue *q,
 				struct blkio_group *blkg, u64 read_bps)
 {
-	struct throtl_data *td = key;
 	struct throtl_grp *tg = tg_of_blkg(blkg);
 
 	tg->bps[READ] = read_bps;
-	throtl_update_blkio_group_common(td, tg);
+	throtl_update_blkio_group_common(q->td, tg);
 }
 
-static void throtl_update_blkio_group_write_bps(void *key,
+static void throtl_update_blkio_group_write_bps(struct request_queue *q,
 				struct blkio_group *blkg, u64 write_bps)
 {
-	struct throtl_data *td = key;
 	struct throtl_grp *tg = tg_of_blkg(blkg);
 
 	tg->bps[WRITE] = write_bps;
-	throtl_update_blkio_group_common(td, tg);
+	throtl_update_blkio_group_common(q->td, tg);
 }
 
-static void throtl_update_blkio_group_read_iops(void *key,
+static void throtl_update_blkio_group_read_iops(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int read_iops)
 {
-	struct throtl_data *td = key;
 	struct throtl_grp *tg = tg_of_blkg(blkg);
 
 	tg->iops[READ] = read_iops;
-	throtl_update_blkio_group_common(td, tg);
+	throtl_update_blkio_group_common(q->td, tg);
 }
 
-static void throtl_update_blkio_group_write_iops(void *key,
+static void throtl_update_blkio_group_write_iops(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int write_iops)
 {
-	struct throtl_data *td = key;
 	struct throtl_grp *tg = tg_of_blkg(blkg);
 
 	tg->iops[WRITE] = write_iops;
-	throtl_update_blkio_group_common(td, tg);
+	throtl_update_blkio_group_common(q->td, tg);
 }
 
 static void throtl_shutdown_wq(struct request_queue *q)
@@ -1306,7 +1302,7 @@ void blk_throtl_exit(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 
 	/*
-	 * Wait for tg->blkg->key accessors to exit their grace periods.
+	 * Wait for tg->blkg->q accessors to exit their grace periods.
 	 * Do this wait only if there are other undestroyed groups out
 	 * there (other than root group). This can happen if cgroup deletion
 	 * path claimed the responsibility of cleaning up a group before
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cc6eb7f..8d5f371 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1020,7 +1020,8 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
-static void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
+static void cfq_update_blkio_group_weight(struct request_queue *q,
+					  struct blkio_group *blkg,
 					  unsigned int weight)
 {
 	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
@@ -1043,10 +1044,10 @@ static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
 	if (bdi->dev) {
 		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg,
-					(void *)cfqd, MKDEV(major, minor));
+					cfqd->queue, MKDEV(major, minor));
 	} else
 		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg,
-					(void *)cfqd, 0);
+					cfqd->queue, 0);
 
 	cfqd->nr_blkcg_linked_grps++;
 	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
@@ -1097,7 +1098,6 @@ static struct cfq_group *
 cfq_find_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg)
 {
 	struct cfq_group *cfqg = NULL;
-	void *key = cfqd;
 	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	unsigned int major, minor;
 
@@ -1108,7 +1108,8 @@ cfq_find_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg)
 	if (blkcg == &blkio_root_cgroup)
 		cfqg = &cfqd->root_group;
 	else
-		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, cfqd->queue,
+							 BLKIO_POLICY_PROP));
 
 	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
 		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
@@ -1247,21 +1248,22 @@ static bool cfq_release_cfq_groups(struct cfq_data *cfqd)
  * any pending IO in the group is finished.
  *
  * This function is called under rcu_read_lock(). key is the rcu protected
- * pointer. That means "key" is a valid cfq_data pointer as long as we are rcu
- * read lock.
+ * pointer. That means @q is a valid request_queue pointer as long as we
+ * are rcu read lock.
  *
- * "key" was fetched from blkio_group under blkio_cgroup->lock. That means
+ * @q was fetched from blkio_group under blkio_cgroup->lock. That means
  * it should not be NULL as even if elevator was exiting, cgroup deltion
  * path got to it first.
  */
-static void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
+static void cfq_unlink_blkio_group(struct request_queue *q,
+				   struct blkio_group *blkg)
 {
-	unsigned long  flags;
-	struct cfq_data *cfqd = key;
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	unsigned long flags;
 
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	spin_lock_irqsave(q->queue_lock, flags);
 	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 static struct elevator_type iosched_cfq;
@@ -3724,7 +3726,7 @@ static int cfq_init_queue(struct request_queue *q)
 	rcu_read_lock();
 
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
-					(void *)cfqd, 0);
+				    cfqd->queue, 0);
 	rcu_read_unlock();
 	cfqd->nr_blkcg_linked_grps++;
 
diff --git a/block/cfq.h b/block/cfq.h
index 2a15592..343b78a 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -68,8 +68,9 @@ static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
 }
 
 static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, void *key, dev_t dev) {
-	blkiocg_add_blkio_group(blkcg, blkg, key, dev, BLKIO_POLICY_PROP);
+		struct blkio_group *blkg, struct request_queue *q, dev_t dev)
+{
+	blkiocg_add_blkio_group(blkcg, blkg, q, dev, BLKIO_POLICY_PROP);
 }
 
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
@@ -105,7 +106,7 @@ static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync) {}
 
 static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, void *key, dev_t dev) {}
+		struct blkio_group *blkg, struct request_queue *q, dev_t dev) {}
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
 	return 0;
-- 
1.7.7.3

