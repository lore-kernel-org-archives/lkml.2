Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2AWXK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:10:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2AWXKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:10:25 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tejun@google.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/16] blkcg: factor out blkio_group creation
Date: Mon, 23 Jan 2012 15:09:50 -0800
Message-Id: <1327360193-24679-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327360193-24679-1-git-send-email-tj@kernel.org>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tejun@google.com>

Currently both blk-throttle and cfq-iosched implement their own
blkio_group creation code in throtl_get_tg() and cfq_get_cfqg().  This
patch factors out the common code.

* New plkio_policy_ops methods blkio_alloc_group_fn() and
  blkio_link_group_fn added.  Both are transitional and will be
  removed once the blkg management code is fully moved into
  blk-cgroup.c.

* blkio_alloc_group_fn() allocates policy-specific blkg which is
  usually a larger data structure with blkg as the first entry and
  intiailizes it.  Note that initialization of blkg proper, including
  percpu stats, is responsibility of blk-cgroup proper.

  Note that default config (weight, bps...) initialization is done
  from this method; otherwise, we end up violating locking order
  between blkcg and q locks via blkcg_get_CONF() functions.

* blkio_link_group_fn() is called under queue_lock and responsible for
  linking the blkg to the queue.  blkcg side is handled by blk-cgroup
  proper.

* The common blkg creation function is named blkg_lookup_create() and
  blkiocg_lookup_group() is renamed to blkg_lookup() for consistency.
  Also, throtl / cfq related functions are similarly [re]named for
  consistency.

* Code to fill cfqg->blkg.dev is open coded in cfq_find_alloc_queue().
  This is transitional and will be removed soon.

This simplifies blkcg policy implementations and enables further
cleanup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |  113 ++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h   |   29 +++++-----
 block/blk-throttle.c |  144 ++++++++++++++------------------------------------
 block/cfq-iosched.c  |  134 ++++++++++++----------------------------------
 block/cfq.h          |    8 ---
 5 files changed, 172 insertions(+), 256 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fab2800..2e6a043 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -465,38 +465,89 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
-/*
- * This function allocates the per cpu stats for blkio_group. Should be called
- * from sleepable context as alloc_per_cpu() requires that.
- */
-int blkio_alloc_blkg_stats(struct blkio_group *blkg)
+struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
+				       struct request_queue *q,
+				       enum blkio_policy_id plid)
+	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
-	/* Allocate memory for per cpu stats */
-	blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
-	if (!blkg->stats_cpu)
-		return -ENOMEM;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats);
+	struct blkio_policy_type *pol = blkio_policy[plid];
+	struct blkio_group *blkg = NULL;
+	struct blkio_group *new_blkg = NULL;
 
-void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-		struct blkio_group *blkg, struct request_queue *q, dev_t dev,
-		enum blkio_policy_id plid)
-{
-	unsigned long flags;
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	lockdep_assert_held(q->queue_lock);
 
-	spin_lock_irqsave(&blkcg->lock, flags);
-	spin_lock_init(&blkg->stats_lock);
-	rcu_assign_pointer(blkg->q, q);
-	blkg->blkcg_id = css_id(&blkcg->css);
+	/*
+	 * This could be the first entry point of blkcg implementation and
+	 * we shouldn't allow anything to go through for a dead queue.  The
+	 * following can be removed if blkg lookup is guaranteed to fail on
+	 * a dead queue.
+	 */
+	if (unlikely(blk_queue_dead(q)))
+		return NULL;
+
+	blkg = blkg_lookup(blkcg, q, plid);
+	if (blkg)
+		return blkg;
+
+	if (!css_tryget(&blkcg->css))
+		return NULL;
+
+	/*
+	 * Allocate and initialize.
+	 *
+	 * FIXME: The following is broken.  Percpu memory allocation
+	 * requires %GFP_KERNEL context and can't be performed from IO
+	 * path.  Allocation here should inherently be atomic and the
+	 * following lock dancing can be removed once the broken percpu
+	 * allocation is fixed.
+	 */
+	spin_unlock_irq(q->queue_lock);
+	rcu_read_unlock();
+
+	new_blkg = pol->ops.blkio_alloc_group_fn(q, blkcg);
+	if (new_blkg) {
+		new_blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+
+		spin_lock_init(&new_blkg->stats_lock);
+		rcu_assign_pointer(new_blkg->q, q);
+		new_blkg->blkcg_id = css_id(&blkcg->css);
+		new_blkg->plid = plid;
+		cgroup_path(blkcg->css.cgroup, new_blkg->path,
+			    sizeof(new_blkg->path));
+	}
+
+	rcu_read_lock();
+	spin_lock_irq(q->queue_lock);
+	css_put(&blkcg->css);
+
+	/* did the device die inbetween? */
+	if (unlikely(blk_queue_dead(q)))
+		goto out;
+
+	/* did someone beat us to it? */
+	blkg = blkg_lookup(blkcg, q, plid);
+	if (unlikely(blkg))
+		goto out;
+
+	/* did alloc fail? */
+	if (unlikely(!new_blkg || !new_blkg->stats_cpu))
+		goto out;
+
+	/* insert */
+	spin_lock(&blkcg->lock);
+	swap(blkg, new_blkg);
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
-	blkg->plid = plid;
-	spin_unlock_irqrestore(&blkcg->lock, flags);
-	/* Need to take css reference ? */
-	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
-	blkg->dev = dev;
+	pol->ops.blkio_link_group_fn(q, blkg);
+	spin_unlock(&blkcg->lock);
+out:
+	if (new_blkg) {
+		free_percpu(new_blkg->stats_cpu);
+		kfree(new_blkg);
+	}
+	return blkg;
 }
-EXPORT_SYMBOL_GPL(blkiocg_add_blkio_group);
+EXPORT_SYMBOL_GPL(blkg_lookup_create);
 
 static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
@@ -533,9 +584,9 @@ int blkiocg_del_blkio_group(struct blkio_group *blkg)
 EXPORT_SYMBOL_GPL(blkiocg_del_blkio_group);
 
 /* called under rcu_read_lock(). */
-struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
-					 struct request_queue *q,
-					 enum blkio_policy_id plid)
+struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
+				struct request_queue *q,
+				enum blkio_policy_id plid)
 {
 	struct blkio_group *blkg;
 	struct hlist_node *n;
@@ -545,7 +596,7 @@ struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 			return blkg;
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(blkiocg_lookup_group);
+EXPORT_SYMBOL_GPL(blkg_lookup);
 
 static void blkio_reset_stats_cpu(struct blkio_group *blkg)
 {
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index aa66d49..f4057b7 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -204,6 +204,10 @@ extern unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg,
 extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 
+typedef struct blkio_group *(blkio_alloc_group_fn)(struct request_queue *q,
+						   struct blkio_cgroup *blkcg);
+typedef void (blkio_link_group_fn)(struct request_queue *q,
+			struct blkio_group *blkg);
 typedef void (blkio_unlink_group_fn)(struct request_queue *q,
 			struct blkio_group *blkg);
 typedef bool (blkio_clear_queue_fn)(struct request_queue *q);
@@ -219,6 +223,8 @@ typedef void (blkio_update_group_write_iops_fn)(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int write_iops);
 
 struct blkio_policy_ops {
+	blkio_alloc_group_fn *blkio_alloc_group_fn;
+	blkio_link_group_fn *blkio_link_group_fn;
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_clear_queue_fn *blkio_clear_queue_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
@@ -308,14 +314,13 @@ static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
-extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-	struct blkio_group *blkg, struct request_queue *q, dev_t dev,
-	enum blkio_policy_id plid);
-extern int blkio_alloc_blkg_stats(struct blkio_group *blkg);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
-extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
-						struct request_queue *q,
-						enum blkio_policy_id plid);
+extern struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
+				       struct request_queue *q,
+				       enum blkio_policy_id plid);
+struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
+				       struct request_queue *q,
+				       enum blkio_policy_id plid);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 					unsigned long time,
 					unsigned long unaccounted_time);
@@ -336,17 +341,11 @@ cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
 static inline struct blkio_cgroup *
 task_blkio_cgroup(struct task_struct *tsk) { return NULL; }
 
-static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-		struct blkio_group *blkg, void *key, dev_t dev,
-		enum blkio_policy_id plid) {}
-
-static inline int blkio_alloc_blkg_stats(struct blkio_group *blkg) { return 0; }
-
 static inline int
 blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
 
-static inline struct blkio_group *
-blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
+static inline struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
+					      void *key) { return NULL; }
 static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 						unsigned long time,
 						unsigned long unaccounted_time)
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index aeeb798..9da1ad4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -181,17 +181,25 @@ static void throtl_put_tg(struct throtl_grp *tg)
 	call_rcu(&tg->rcu_head, throtl_free_tg);
 }
 
-static void throtl_init_group(struct throtl_grp *tg)
+static struct blkio_group *throtl_alloc_blkio_group(struct request_queue *q,
+						    struct blkio_cgroup *blkcg)
 {
+	struct throtl_grp *tg;
+
+	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, q->node);
+	if (!tg)
+		return NULL;
+
 	INIT_HLIST_NODE(&tg->tg_node);
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
 	tg->limits_changed = false;
 
-	/* Practically unlimited BW */
-	tg->bps[0] = tg->bps[1] = -1;
-	tg->iops[0] = tg->iops[1] = -1;
+	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
+	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
+	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
+	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -200,14 +208,8 @@ static void throtl_init_group(struct throtl_grp *tg)
 	 * exit or cgroup deletion path depending on who is exiting first.
 	 */
 	atomic_set(&tg->ref, 1);
-}
 
-/* Should be called with rcu read lock held (needed for blkcg) */
-static void
-throtl_add_group_to_td_list(struct throtl_data *td, struct throtl_grp *tg)
-{
-	hlist_add_head(&tg->tg_node, &td->tg_list);
-	td->nr_undestroyed_grps++;
+	return &tg->blkg;
 }
 
 static void
@@ -246,46 +248,20 @@ throtl_tg_fill_dev_details(struct throtl_data *td, struct throtl_grp *tg)
 	spin_unlock_irq(td->queue->queue_lock);
 }
 
-static void throtl_init_add_tg_lists(struct throtl_data *td,
-			struct throtl_grp *tg, struct blkio_cgroup *blkcg)
+static void throtl_link_blkio_group(struct request_queue *q,
+				    struct blkio_group *blkg)
 {
-	__throtl_tg_fill_dev_details(td, tg);
-
-	/* Add group onto cgroup list */
-	blkiocg_add_blkio_group(blkcg, &tg->blkg, td->queue,
-				tg->blkg.dev, BLKIO_POLICY_THROTL);
-
-	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
-	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
-	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
-	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
-
-	throtl_add_group_to_td_list(td, tg);
-}
-
-/* Should be called without queue lock and outside of rcu period */
-static struct throtl_grp *throtl_alloc_tg(struct throtl_data *td)
-{
-	struct throtl_grp *tg = NULL;
-	int ret;
-
-	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, td->queue->node);
-	if (!tg)
-		return NULL;
-
-	ret = blkio_alloc_blkg_stats(&tg->blkg);
+	struct throtl_data *td = q->td;
+	struct throtl_grp *tg = tg_of_blkg(blkg);
 
-	if (ret) {
-		kfree(tg);
-		return NULL;
-	}
+	__throtl_tg_fill_dev_details(td, tg);
 
-	throtl_init_group(tg);
-	return tg;
+	hlist_add_head(&tg->tg_node, &td->tg_list);
+	td->nr_undestroyed_grps++;
 }
 
 static struct
-throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
+throtl_grp *throtl_lookup_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 {
 	struct throtl_grp *tg = NULL;
 
@@ -296,69 +272,29 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	if (blkcg == &blkio_root_cgroup)
 		tg = td->root_tg;
 	else
-		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, td->queue,
-						     BLKIO_POLICY_THROTL));
+		tg = tg_of_blkg(blkg_lookup(blkcg, td->queue,
+					    BLKIO_POLICY_THROTL));
 
 	__throtl_tg_fill_dev_details(td, tg);
 	return tg;
 }
 
-static struct throtl_grp *throtl_get_tg(struct throtl_data *td,
-					struct blkio_cgroup *blkcg)
+static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
+						  struct blkio_cgroup *blkcg)
 {
-	struct throtl_grp *tg = NULL, *__tg = NULL;
 	struct request_queue *q = td->queue;
+	struct throtl_grp *tg = NULL;
+	struct blkio_group *blkg;
 
-	/* no throttling for dead queue */
-	if (unlikely(blk_queue_bypass(q)))
-		return NULL;
-
-	tg = throtl_find_tg(td, blkcg);
-	if (tg)
-		return tg;
-
-	if (!css_tryget(&blkcg->css))
-		return NULL;
-
-	/*
-	 * Need to allocate a group. Allocation of group also needs allocation
-	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
-	 * we need to drop rcu lock and queue_lock before we call alloc.
-	 */
-	spin_unlock_irq(q->queue_lock);
-	rcu_read_unlock();
-
-	tg = throtl_alloc_tg(td);
-
-	/* Group allocated and queue is still alive. take the lock */
-	rcu_read_lock();
-	spin_lock_irq(q->queue_lock);
-	css_put(&blkcg->css);
-
-	/* Make sure @q is still alive */
-	if (unlikely(blk_queue_bypass(q))) {
-		kfree(tg);
-		return NULL;
-	}
-
-	/*
-	 * If some other thread already allocated the group while we were
-	 * not holding queue lock, free up the group
-	 */
-	__tg = throtl_find_tg(td, blkcg);
-
-	if (__tg) {
-		kfree(tg);
-		return __tg;
-	}
+	blkg = blkg_lookup_create(blkcg, q, BLKIO_POLICY_THROTL);
 
-	/* Group allocation failed. Account the IO to root group */
-	if (!tg) {
+	/* if %NULL and @q is alive, fall back to root_tg */
+	if (blkg)
+		tg = tg_of_blkg(blkg);
+	else if (!blk_queue_dead(q))
 		tg = td->root_tg;
-		return tg;
-	}
 
-	throtl_init_add_tg_lists(td, tg, blkcg);
+	__throtl_tg_fill_dev_details(td, tg);
 	return tg;
 }
 
@@ -1107,6 +1043,8 @@ static void throtl_shutdown_wq(struct request_queue *q)
 
 static struct blkio_policy_type blkio_policy_throtl = {
 	.ops = {
+		.blkio_alloc_group_fn = throtl_alloc_blkio_group,
+		.blkio_link_group_fn = throtl_link_blkio_group,
 		.blkio_unlink_group_fn = throtl_unlink_blkio_group,
 		.blkio_clear_queue_fn = throtl_clear_queue,
 		.blkio_update_group_read_bps_fn =
@@ -1141,7 +1079,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 */
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
-	tg = throtl_find_tg(td, blkcg);
+	tg = throtl_lookup_tg(td, blkcg);
 	if (tg) {
 		throtl_tg_fill_dev_details(td, tg);
 
@@ -1157,7 +1095,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 * IO group
 	 */
 	spin_lock_irq(q->queue_lock);
-	tg = throtl_get_tg(td, blkcg);
+	tg = throtl_lookup_create_tg(td, blkcg);
 	if (unlikely(!tg))
 		goto out_unlock;
 
@@ -1262,13 +1200,14 @@ int blk_throtl_init(struct request_queue *q)
 	td->limits_changed = false;
 	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
 
-	/* alloc and Init root group. */
+	q->td = td;
 	td->queue = q;
 
+	/* alloc and init root group. */
 	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
 
-	td->root_tg = throtl_get_tg(td, &blkio_root_cgroup);
+	td->root_tg = throtl_lookup_create_tg(td, &blkio_root_cgroup);
 
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
@@ -1277,9 +1216,6 @@ int blk_throtl_init(struct request_queue *q)
 		kfree(td);
 		return -ENOMEM;
 	}
-
-	/* Attach throtl data to request queue */
-	q->td = td;
 	return 0;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4ad2531..37a9660 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1048,10 +1048,12 @@ static void cfq_update_blkio_group_weight(struct request_queue *q,
 	cfqg->needs_update = true;
 }
 
-static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
-			struct cfq_group *cfqg, struct blkio_cgroup *blkcg)
+static void cfq_link_blkio_group(struct request_queue *q,
+				 struct blkio_group *blkg)
 {
-	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct backing_dev_info *bdi = &q->backing_dev_info;
+	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
 	unsigned int major, minor;
 
 	/*
@@ -1062,34 +1064,26 @@ static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
 	 */
 	if (bdi->dev) {
 		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg,
-					cfqd->queue, MKDEV(major, minor));
-	} else
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg,
-					cfqd->queue, 0);
+		blkg->dev = MKDEV(major, minor);
+	}
 
 	cfqd->nr_blkcg_linked_grps++;
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
 }
 
-/*
- * Should be called from sleepable context. No request queue lock as per
- * cpu stats are allocated dynamically and alloc_percpu needs to be called
- * from sleepable context.
- */
-static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
+static struct blkio_group *cfq_alloc_blkio_group(struct request_queue *q,
+						 struct blkio_cgroup *blkcg)
 {
 	struct cfq_group *cfqg;
-	int ret;
 
-	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
+	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, q->node);
 	if (!cfqg)
 		return NULL;
 
 	cfq_init_cfqg_base(cfqg);
+	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1099,91 +1093,20 @@ static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
 	 */
 	cfqg->ref = 1;
 
-	ret = blkio_alloc_blkg_stats(&cfqg->blkg);
-	if (ret) {
-		kfree(cfqg);
-		return NULL;
-	}
-
-	return cfqg;
-}
-
-static struct cfq_group *
-cfq_find_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg)
-{
-	struct cfq_group *cfqg = NULL;
-	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
-	unsigned int major, minor;
-
-	/*
-	 * This is the common case when there are no blkio cgroups.
-	 * Avoid lookup in this case
-	 */
-	if (blkcg == &blkio_root_cgroup)
-		cfqg = cfqd->root_group;
-	else
-		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, cfqd->queue,
-							 BLKIO_POLICY_PROP));
-
-	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfqg->blkg.dev = MKDEV(major, minor);
-	}
-
-	return cfqg;
+	return &cfqg->blkg;
 }
 
 /*
  * Search for the cfq group current task belongs to. request_queue lock must
  * be held.
  */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
-				      struct blkio_cgroup *blkcg)
+static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
+						struct blkio_cgroup *blkcg)
 {
-	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
-	struct request_queue *q = cfqd->queue;
+	struct blkio_group *blkg;
 
-	cfqg = cfq_find_cfqg(cfqd, blkcg);
-	if (cfqg)
-		return cfqg;
-
-	if (!css_tryget(&blkcg->css))
-		return NULL;
-
-	/*
-	 * Need to allocate a group. Allocation of group also needs allocation
-	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
-	 * we need to drop rcu lock and queue_lock before we call alloc.
-	 *
-	 * Not taking any queue reference here and assuming that queue is
-	 * around by the time we return. CFQ queue allocation code does
-	 * the same. It might be racy though.
-	 */
-	rcu_read_unlock();
-	spin_unlock_irq(q->queue_lock);
-
-	cfqg = cfq_alloc_cfqg(cfqd);
-
-	spin_lock_irq(q->queue_lock);
-	rcu_read_lock();
-	css_put(&blkcg->css);
-
-	/*
-	 * If some other thread already allocated the group while we were
-	 * not holding queue lock, free up the group
-	 */
-	__cfqg = cfq_find_cfqg(cfqd, blkcg);
-
-	if (__cfqg) {
-		kfree(cfqg);
-		return __cfqg;
-	}
-
-	if (!cfqg)
-		cfqg = cfqd->root_group;
-
-	cfq_init_add_cfqg_lists(cfqd, cfqg, blkcg);
-	return cfqg;
+	blkg = blkg_lookup_create(blkcg, cfqd->queue, BLKIO_POLICY_PROP);
+	return cfqg_of_blkg(blkg);
 }
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
@@ -1295,8 +1218,8 @@ static bool cfq_clear_queue(struct request_queue *q)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
-				      struct blkio_cgroup *blkcg)
+static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
+						struct blkio_cgroup *blkcg)
 {
 	return cfqd->root_group;
 }
@@ -2885,6 +2808,7 @@ static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	struct blkio_cgroup *blkcg;
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_cq *cic;
@@ -2895,7 +2819,19 @@ retry:
 
 	blkcg = task_blkio_cgroup(current);
 
-	cfqg = cfq_get_cfqg(cfqd, blkcg);
+	/* avoid lookup for the common case where there's no blkio cgroup */
+	if (blkcg == &blkio_root_cgroup)
+		cfqg = cfqd->root_group;
+	else
+		cfqg = cfq_lookup_create_cfqg(cfqd, blkcg);
+
+	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+		unsigned int major, minor;
+
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfqg->blkg.dev = MKDEV(major, minor);
+	}
+
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
@@ -3718,7 +3654,7 @@ static int cfq_init_queue(struct request_queue *q)
 	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
 
-	cfqd->root_group = cfq_get_cfqg(cfqd, &blkio_root_cgroup);
+	cfqd->root_group = cfq_lookup_create_cfqg(cfqd, &blkio_root_cgroup);
 
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
@@ -3904,6 +3840,8 @@ static struct elevator_type iosched_cfq = {
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
+		.blkio_alloc_group_fn =		cfq_alloc_blkio_group,
+		.blkio_link_group_fn =		cfq_link_blkio_group,
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
 		.blkio_clear_queue_fn = cfq_clear_queue,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
diff --git a/block/cfq.h b/block/cfq.h
index 343b78a..3987601 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -67,12 +67,6 @@ static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
 				direction, sync);
 }
 
-static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-		struct blkio_group *blkg, struct request_queue *q, dev_t dev)
-{
-	blkiocg_add_blkio_group(blkcg, blkg, q, dev, BLKIO_POLICY_PROP);
-}
-
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
 	return blkiocg_del_blkio_group(blkg);
@@ -105,8 +99,6 @@ static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync) {}
 static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync) {}
 
-static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-		struct blkio_group *blkg, struct request_queue *q, dev_t dev) {}
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
 	return 0;
-- 
1.7.7.3

