Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2BVBvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:51:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2BVBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.72.70 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/36] blkcg: let blkcg core handle policy private data allocation
Date: Tue, 21 Feb 2012 17:46:48 -0800
Message-Id: <1329875223-5102-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blkg's are embedded in private data blkcg policy private
data structure and thus allocated and freed by policies.  This leads
to duplicate codes in policies, hinders implementing common part in
blkcg core with strong semantics, and forces duplicate blkg's for the
same cgroup-q association.

This patch introduces struct blkg_policy_data which is a separate data
structure chained from blkg.  Policies specifies the amount of private
data it needs in its blkio_policy_type->pdata_size and blkcg core
takes care of allocating them along with blkg which can be accessed
using blkg_to_pdata().  blkg can be determined from pdata using
pdata_to_blkg().  blkio_alloc_group_fn() method is accordingly updated
to blkio_init_group_fn().

For consistency, tg_of_blkg() and cfqg_of_blkg() are replaced with
blkg_to_tg() and blkg_to_cfqg() respectively, and functions to map in
the reverse direction are added.

Except that policy specific data now lives in a separate data
structure from blkg, this patch doesn't introduce any functional
difference.

This will be used to unify blkg's for different policies.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   86 +++++++++++++++++++++++++++++++++---------
 block/blk-cgroup.h   |   53 ++++++++++++++++++++++++-
 block/blk-throttle.c |   79 +++++++++++++++++++-------------------
 block/cfq-iosched.c  |  102 +++++++++++++++++++++++++------------------------
 4 files changed, 209 insertions(+), 111 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1695856..13fb955 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -422,6 +422,70 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
+/**
+ * blkg_free - free a blkg
+ * @blkg: blkg to free
+ *
+ * Free @blkg which may be partially allocated.
+ */
+static void blkg_free(struct blkio_group *blkg)
+{
+	if (blkg) {
+		free_percpu(blkg->stats_cpu);
+		kfree(blkg->pd);
+		kfree(blkg);
+	}
+}
+
+/**
+ * blkg_alloc - allocate a blkg
+ * @blkcg: block cgroup the new blkg is associated with
+ * @q: request_queue the new blkg is associated with
+ * @pol: policy the new blkg is associated with
+ *
+ * Allocate a new blkg assocating @blkcg and @q for @pol.
+ *
+ * FIXME: Should be called with queue locked but currently isn't due to
+ *        percpu stat breakage.
+ */
+static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
+				      struct request_queue *q,
+				      struct blkio_policy_type *pol)
+{
+	struct blkio_group *blkg;
+
+	/* alloc and init base part */
+	blkg = kzalloc_node(sizeof(*blkg), GFP_ATOMIC, q->node);
+	if (!blkg)
+		return NULL;
+
+	spin_lock_init(&blkg->stats_lock);
+	rcu_assign_pointer(blkg->q, q);
+	blkg->blkcg = blkcg;
+	blkg->plid = pol->plid;
+	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
+
+	/* alloc per-policy data */
+	blkg->pd = kzalloc_node(sizeof(*blkg->pd) + pol->pdata_size, GFP_ATOMIC,
+				q->node);
+	if (!blkg->pd) {
+		blkg_free(blkg);
+		return NULL;
+	}
+
+	/* broken, read comment in the callsite */
+	blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+	if (!blkg->stats_cpu) {
+		blkg_free(blkg);
+		return NULL;
+	}
+
+	/* attach pd to blkg and invoke per-policy init */
+	blkg->pd->blkg = blkg;
+	pol->ops.blkio_init_group_fn(blkg);
+	return blkg;
+}
+
 struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 				       struct request_queue *q,
 				       enum blkio_policy_id plid,
@@ -463,19 +527,7 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
 
-	new_blkg = pol->ops.blkio_alloc_group_fn(q, blkcg);
-	if (new_blkg) {
-		new_blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
-
-		spin_lock_init(&new_blkg->stats_lock);
-		rcu_assign_pointer(new_blkg->q, q);
-		new_blkg->blkcg = blkcg;
-		new_blkg->plid = plid;
-		cgroup_path(blkcg->css.cgroup, new_blkg->path,
-			    sizeof(new_blkg->path));
-	} else {
-		css_put(&blkcg->css);
-	}
+	new_blkg = blkg_alloc(blkcg, q, pol);
 
 	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
@@ -492,7 +544,7 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 		goto out;
 
 	/* did alloc fail? */
-	if (unlikely(!new_blkg || !new_blkg->stats_cpu)) {
+	if (unlikely(!new_blkg)) {
 		blkg = ERR_PTR(-ENOMEM);
 		goto out;
 	}
@@ -504,11 +556,7 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 	pol->ops.blkio_link_group_fn(q, blkg);
 	spin_unlock(&blkcg->lock);
 out:
-	if (new_blkg) {
-		free_percpu(new_blkg->stats_cpu);
-		kfree(new_blkg);
-		css_put(&blkcg->css);
-	}
+	blkg_free(new_blkg);
 	return blkg;
 }
 EXPORT_SYMBOL_GPL(blkg_lookup_create);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3bc1710..9537819 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -159,6 +159,15 @@ struct blkio_group_conf {
 	u64 bps[2];
 };
 
+/* per-blkg per-policy data */
+struct blkg_policy_data {
+	/* the blkg this per-policy data belongs to */
+	struct blkio_group *blkg;
+
+	/* pol->pdata_size bytes of private data used by policy impl */
+	char pdata[] __aligned(__alignof__(unsigned long long));
+};
+
 struct blkio_group {
 	/* Pointer to the associated request_queue, RCU protected */
 	struct request_queue __rcu *q;
@@ -177,10 +186,11 @@ struct blkio_group {
 	struct blkio_group_stats stats;
 	/* Per cpu stats pointer */
 	struct blkio_group_stats_cpu __percpu *stats_cpu;
+
+	struct blkg_policy_data *pd;
 };
 
-typedef struct blkio_group *(blkio_alloc_group_fn)(struct request_queue *q,
-						   struct blkio_cgroup *blkcg);
+typedef void (blkio_init_group_fn)(struct blkio_group *blkg);
 typedef void (blkio_link_group_fn)(struct request_queue *q,
 			struct blkio_group *blkg);
 typedef void (blkio_unlink_group_fn)(struct request_queue *q,
@@ -198,7 +208,7 @@ typedef void (blkio_update_group_write_iops_fn)(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int write_iops);
 
 struct blkio_policy_ops {
-	blkio_alloc_group_fn *blkio_alloc_group_fn;
+	blkio_init_group_fn *blkio_init_group_fn;
 	blkio_link_group_fn *blkio_link_group_fn;
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_clear_queue_fn *blkio_clear_queue_fn;
@@ -213,6 +223,7 @@ struct blkio_policy_type {
 	struct list_head list;
 	struct blkio_policy_ops ops;
 	enum blkio_policy_id plid;
+	size_t pdata_size;		/* policy specific private data size */
 };
 
 extern int blkcg_init_queue(struct request_queue *q);
@@ -224,6 +235,38 @@ extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
 extern void blkg_destroy_all(struct request_queue *q);
 
+/**
+ * blkg_to_pdata - get policy private data
+ * @blkg: blkg of interest
+ * @pol: policy of interest
+ *
+ * Return pointer to private data associated with the @blkg-@pol pair.
+ */
+static inline void *blkg_to_pdata(struct blkio_group *blkg,
+			      struct blkio_policy_type *pol)
+{
+	return blkg ? blkg->pd->pdata : NULL;
+}
+
+/**
+ * pdata_to_blkg - get blkg associated with policy private data
+ * @pdata: policy private data of interest
+ * @pol: policy @pdata is for
+ *
+ * @pdata is policy private data for @pol.  Determine the blkg it's
+ * associated with.
+ */
+static inline struct blkio_group *pdata_to_blkg(void *pdata,
+						struct blkio_policy_type *pol)
+{
+	if (pdata) {
+		struct blkg_policy_data *pd =
+			container_of(pdata, struct blkg_policy_data, pdata);
+		return pd->blkg;
+	}
+	return NULL;
+}
+
 static inline char *blkg_path(struct blkio_group *blkg)
 {
 	return blkg->path;
@@ -244,6 +287,10 @@ static inline void blkio_policy_register(struct blkio_policy_type *blkiop) { }
 static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
 static inline void blkg_destroy_all(struct request_queue *q) { }
 
+static inline void *blkg_to_pdata(struct blkio_group *blkg,
+				struct blkio_policy_type *pol) { return NULL; }
+static inline struct blkio_group *pdata_to_blkg(void *pdata,
+				struct blkio_policy_type *pol) { return NULL; }
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
 
 #endif
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ac6d0fe..9c8a124 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -21,6 +21,8 @@ static int throtl_quantum = 32;
 /* Throttling is performed over 100ms slice and after that slice is renewed */
 static unsigned long throtl_slice = HZ/10;	/* 100 ms */
 
+static struct blkio_policy_type blkio_policy_throtl;
+
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
 static void throtl_schedule_delayed_work(struct throtl_data *td,
@@ -52,7 +54,6 @@ struct throtl_grp {
 	 */
 	unsigned long disptime;
 
-	struct blkio_group blkg;
 	atomic_t ref;
 	unsigned int flags;
 
@@ -108,6 +109,16 @@ struct throtl_data
 	int limits_changed;
 };
 
+static inline struct throtl_grp *blkg_to_tg(struct blkio_group *blkg)
+{
+	return blkg_to_pdata(blkg, &blkio_policy_throtl);
+}
+
+static inline struct blkio_group *tg_to_blkg(struct throtl_grp *tg)
+{
+	return pdata_to_blkg(tg, &blkio_policy_throtl);
+}
+
 enum tg_state_flags {
 	THROTL_TG_FLAG_on_rr = 0,	/* on round-robin busy list */
 };
@@ -130,19 +141,11 @@ THROTL_TG_FNS(on_rr);
 
 #define throtl_log_tg(td, tg, fmt, args...)				\
 	blk_add_trace_msg((td)->queue, "throtl %s " fmt,		\
-				blkg_path(&(tg)->blkg), ##args);      	\
+			  blkg_path(tg_to_blkg(tg)), ##args);		\
 
 #define throtl_log(td, fmt, args...)	\
 	blk_add_trace_msg((td)->queue, "throtl " fmt, ##args)
 
-static inline struct throtl_grp *tg_of_blkg(struct blkio_group *blkg)
-{
-	if (blkg)
-		return container_of(blkg, struct throtl_grp, blkg);
-
-	return NULL;
-}
-
 static inline unsigned int total_nr_queued(struct throtl_data *td)
 {
 	return td->nr_queued[0] + td->nr_queued[1];
@@ -156,21 +159,24 @@ static inline struct throtl_grp *throtl_ref_get_tg(struct throtl_grp *tg)
 
 static void throtl_free_tg(struct rcu_head *head)
 {
-	struct throtl_grp *tg;
+	struct throtl_grp *tg = container_of(head, struct throtl_grp, rcu_head);
+	struct blkio_group *blkg = tg_to_blkg(tg);
 
-	tg = container_of(head, struct throtl_grp, rcu_head);
-	free_percpu(tg->blkg.stats_cpu);
-	kfree(tg);
+	free_percpu(blkg->stats_cpu);
+	kfree(blkg->pd);
+	kfree(blkg);
 }
 
 static void throtl_put_tg(struct throtl_grp *tg)
 {
+	struct blkio_group *blkg = tg_to_blkg(tg);
+
 	BUG_ON(atomic_read(&tg->ref) <= 0);
 	if (!atomic_dec_and_test(&tg->ref))
 		return;
 
 	/* release the extra blkcg reference this blkg has been holding */
-	css_put(&tg->blkg.blkcg->css);
+	css_put(&blkg->blkcg->css);
 
 	/*
 	 * A group is freed in rcu manner. But having an rcu lock does not
@@ -184,14 +190,9 @@ static void throtl_put_tg(struct throtl_grp *tg)
 	call_rcu(&tg->rcu_head, throtl_free_tg);
 }
 
-static struct blkio_group *throtl_alloc_blkio_group(struct request_queue *q,
-						    struct blkio_cgroup *blkcg)
+static void throtl_init_blkio_group(struct blkio_group *blkg)
 {
-	struct throtl_grp *tg;
-
-	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, q->node);
-	if (!tg)
-		return NULL;
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 
 	INIT_HLIST_NODE(&tg->tg_node);
 	RB_CLEAR_NODE(&tg->rb_node);
@@ -211,15 +212,13 @@ static struct blkio_group *throtl_alloc_blkio_group(struct request_queue *q,
 	 * exit or cgroup deletion path depending on who is exiting first.
 	 */
 	atomic_set(&tg->ref, 1);
-
-	return &tg->blkg;
 }
 
 static void throtl_link_blkio_group(struct request_queue *q,
 				    struct blkio_group *blkg)
 {
 	struct throtl_data *td = q->td;
-	struct throtl_grp *tg = tg_of_blkg(blkg);
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 
 	hlist_add_head(&tg->tg_node, &td->tg_list);
 	td->nr_undestroyed_grps++;
@@ -235,7 +234,7 @@ throtl_grp *throtl_lookup_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	if (blkcg == &blkio_root_cgroup)
 		return td->root_tg;
 
-	return tg_of_blkg(blkg_lookup(blkcg, td->queue, BLKIO_POLICY_THROTL));
+	return blkg_to_tg(blkg_lookup(blkcg, td->queue, BLKIO_POLICY_THROTL));
 }
 
 static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
@@ -257,7 +256,7 @@ static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
 
 		/* if %NULL and @q is alive, fall back to root_tg */
 		if (!IS_ERR(blkg))
-			tg = tg_of_blkg(blkg);
+			tg = blkg_to_tg(blkg);
 		else if (!blk_queue_dead(q))
 			tg = td->root_tg;
 	}
@@ -639,7 +638,7 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	tg->bytes_disp[rw] += bio->bi_size;
 	tg->io_disp[rw]++;
 
-	blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size, rw, sync);
+	blkiocg_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, rw, sync);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -901,7 +900,7 @@ static bool throtl_release_tgs(struct throtl_data *td, bool release_root)
 		 * it from cgroup list, then it will take care of destroying
 		 * cfqg also.
 		 */
-		if (!blkiocg_del_blkio_group(&tg->blkg))
+		if (!blkiocg_del_blkio_group(tg_to_blkg(tg)))
 			throtl_destroy_tg(td, tg);
 		else
 			empty = false;
@@ -929,7 +928,7 @@ void throtl_unlink_blkio_group(struct request_queue *q,
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	throtl_destroy_tg(q->td, tg_of_blkg(blkg));
+	throtl_destroy_tg(q->td, blkg_to_tg(blkg));
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -968,7 +967,7 @@ static void throtl_update_blkio_group_common(struct throtl_data *td,
 static void throtl_update_blkio_group_read_bps(struct request_queue *q,
 				struct blkio_group *blkg, u64 read_bps)
 {
-	struct throtl_grp *tg = tg_of_blkg(blkg);
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 
 	tg->bps[READ] = read_bps;
 	throtl_update_blkio_group_common(q->td, tg);
@@ -977,7 +976,7 @@ static void throtl_update_blkio_group_read_bps(struct request_queue *q,
 static void throtl_update_blkio_group_write_bps(struct request_queue *q,
 				struct blkio_group *blkg, u64 write_bps)
 {
-	struct throtl_grp *tg = tg_of_blkg(blkg);
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 
 	tg->bps[WRITE] = write_bps;
 	throtl_update_blkio_group_common(q->td, tg);
@@ -986,7 +985,7 @@ static void throtl_update_blkio_group_write_bps(struct request_queue *q,
 static void throtl_update_blkio_group_read_iops(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int read_iops)
 {
-	struct throtl_grp *tg = tg_of_blkg(blkg);
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 
 	tg->iops[READ] = read_iops;
 	throtl_update_blkio_group_common(q->td, tg);
@@ -995,7 +994,7 @@ static void throtl_update_blkio_group_read_iops(struct request_queue *q,
 static void throtl_update_blkio_group_write_iops(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int write_iops)
 {
-	struct throtl_grp *tg = tg_of_blkg(blkg);
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 
 	tg->iops[WRITE] = write_iops;
 	throtl_update_blkio_group_common(q->td, tg);
@@ -1010,7 +1009,7 @@ static void throtl_shutdown_wq(struct request_queue *q)
 
 static struct blkio_policy_type blkio_policy_throtl = {
 	.ops = {
-		.blkio_alloc_group_fn = throtl_alloc_blkio_group,
+		.blkio_init_group_fn = throtl_init_blkio_group,
 		.blkio_link_group_fn = throtl_link_blkio_group,
 		.blkio_unlink_group_fn = throtl_unlink_blkio_group,
 		.blkio_clear_queue_fn = throtl_clear_queue,
@@ -1024,6 +1023,7 @@ static struct blkio_policy_type blkio_policy_throtl = {
 					throtl_update_blkio_group_write_iops,
 	},
 	.plid = BLKIO_POLICY_THROTL,
+	.pdata_size = sizeof(struct throtl_grp),
 };
 
 bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
@@ -1049,8 +1049,9 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	tg = throtl_lookup_tg(td, blkcg);
 	if (tg) {
 		if (tg_no_rule_group(tg, rw)) {
-			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
-					rw, rw_is_sync(bio->bi_rw));
+			blkiocg_update_dispatch_stats(tg_to_blkg(tg),
+						      bio->bi_size, rw,
+						      rw_is_sync(bio->bi_rw));
 			goto out_unlock_rcu;
 		}
 	}
@@ -1176,7 +1177,7 @@ int blk_throtl_init(struct request_queue *q)
 	blkg = blkg_lookup_create(&blkio_root_cgroup, q, BLKIO_POLICY_THROTL,
 				  true);
 	if (!IS_ERR(blkg))
-		td->root_tg = tg_of_blkg(blkg);
+		td->root_tg = blkg_to_tg(blkg);
 
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
@@ -1207,7 +1208,7 @@ void blk_throtl_exit(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 
 	/*
-	 * Wait for tg->blkg->q accessors to exit their grace periods.
+	 * Wait for tg_to_blkg(tg)->q accessors to exit their grace periods.
 	 * Do this wait only if there are other undestroyed groups out
 	 * there (other than root group). This can happen if cgroup deletion
 	 * path claimed the responsibility of cleaning up a group before
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9ef86fb..c7449db 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -17,6 +17,8 @@
 #include "blk.h"
 #include "cfq.h"
 
+static struct blkio_policy_type blkio_policy_cfq;
+
 /*
  * tunables
  */
@@ -206,7 +208,6 @@ struct cfq_group {
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
 	enum wl_prio_t saved_serving_prio;
-	struct blkio_group blkg;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
 	int ref;
@@ -310,6 +311,16 @@ struct cfq_data {
 	unsigned int nr_blkcg_linked_grps;
 };
 
+static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg)
+{
+	return blkg_to_pdata(blkg, &blkio_policy_cfq);
+}
+
+static inline struct blkio_group *cfqg_to_blkg(struct cfq_group *cfqg)
+{
+	return pdata_to_blkg(cfqg, &blkio_policy_cfq);
+}
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -374,11 +385,11 @@ CFQ_CFQQ_FNS(wait_busy);
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
 			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
-			blkg_path(&(cfqq)->cfqg->blkg), ##args)
+			blkg_path(cfqg_to_blkg((cfqq)->cfqg)), ##args)
 
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)				\
 	blk_add_trace_msg((cfqd)->queue, "%s " fmt,			\
-				blkg_path(&(cfqg)->blkg), ##args)       \
+			blkg_path(cfqg_to_blkg((cfqg))), ##args)	\
 
 #else
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
@@ -935,7 +946,7 @@ cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfq_group_service_tree_del(st, cfqg);
 	cfqg->saved_workload_slice = 0;
-	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+	cfq_blkiocg_update_dequeue_stats(cfqg_to_blkg(cfqg), 1);
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq,
@@ -1007,9 +1018,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		     "sl_used=%u disp=%u charge=%u iops=%u sect=%lu",
 		     used_sl, cfqq->slice_dispatch, charge,
 		     iops_mode(cfqd), cfqq->nr_sectors);
-	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl,
+	cfq_blkiocg_update_timeslice_used(cfqg_to_blkg(cfqg), used_sl,
 					  unaccounted_sl);
-	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
+	cfq_blkiocg_set_start_empty_time(cfqg_to_blkg(cfqg));
 }
 
 /**
@@ -1032,18 +1043,12 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
-{
-	if (blkg)
-		return container_of(blkg, struct cfq_group, blkg);
-	return NULL;
-}
-
 static void cfq_update_blkio_group_weight(struct request_queue *q,
 					  struct blkio_group *blkg,
 					  unsigned int weight)
 {
-	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
+	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+
 	cfqg->new_weight = weight;
 	cfqg->needs_update = true;
 }
@@ -1052,7 +1057,7 @@ static void cfq_link_blkio_group(struct request_queue *q,
 				 struct blkio_group *blkg)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
+	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
 
 	cfqd->nr_blkcg_linked_grps++;
 
@@ -1060,17 +1065,12 @@ static void cfq_link_blkio_group(struct request_queue *q,
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
 }
 
-static struct blkio_group *cfq_alloc_blkio_group(struct request_queue *q,
-						 struct blkio_cgroup *blkcg)
+static void cfq_init_blkio_group(struct blkio_group *blkg)
 {
-	struct cfq_group *cfqg;
-
-	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, q->node);
-	if (!cfqg)
-		return NULL;
+	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
 
 	cfq_init_cfqg_base(cfqg);
-	cfqg->weight = blkcg->weight;
+	cfqg->weight = blkg->blkcg->weight;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1079,8 +1079,6 @@ static struct blkio_group *cfq_alloc_blkio_group(struct request_queue *q,
 	 * or cgroup deletion path depending on who is exiting first.
 	 */
 	cfqg->ref = 1;
-
-	return &cfqg->blkg;
 }
 
 /*
@@ -1101,7 +1099,7 @@ static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
 
 		blkg = blkg_lookup_create(blkcg, q, BLKIO_POLICY_PROP, false);
 		if (!IS_ERR(blkg))
-			cfqg = cfqg_of_blkg(blkg);
+			cfqg = blkg_to_cfqg(blkg);
 	}
 
 	return cfqg;
@@ -1126,6 +1124,7 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 
 static void cfq_put_cfqg(struct cfq_group *cfqg)
 {
+	struct blkio_group *blkg = cfqg_to_blkg(cfqg);
 	struct cfq_rb_root *st;
 	int i, j;
 
@@ -1135,12 +1134,13 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 		return;
 
 	/* release the extra blkcg reference this blkg has been holding */
-	css_put(&cfqg->blkg.blkcg->css);
+	css_put(&blkg->blkcg->css);
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
-	free_percpu(cfqg->blkg.stats_cpu);
-	kfree(cfqg);
+	free_percpu(blkg->stats_cpu);
+	kfree(blkg->pd);
+	kfree(blkg);
 }
 
 static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
@@ -1172,7 +1172,7 @@ static bool cfq_release_cfq_groups(struct cfq_data *cfqd)
 		 * it from cgroup list, then it will take care of destroying
 		 * cfqg also.
 		 */
-		if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
+		if (!cfq_blkiocg_del_blkio_group(cfqg_to_blkg(cfqg)))
 			cfq_destroy_cfqg(cfqd, cfqg);
 		else
 			empty = false;
@@ -1201,7 +1201,7 @@ static void cfq_unlink_blkio_group(struct request_queue *q,
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
+	cfq_destroy_cfqg(cfqd, blkg_to_cfqg(blkg));
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -1504,12 +1504,12 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
-	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
+	cfq_blkiocg_update_io_remove_stats(cfqg_to_blkg(RQ_CFQG(rq)),
 					rq_data_dir(rq), rq_is_sync(rq));
 	cfq_add_rq_rb(rq);
-	cfq_blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
-			&cfqq->cfqd->serving_group->blkg, rq_data_dir(rq),
-			rq_is_sync(rq));
+	cfq_blkiocg_update_io_add_stats(cfqg_to_blkg(RQ_CFQG(rq)),
+					cfqg_to_blkg(cfqq->cfqd->serving_group),
+					rq_data_dir(rq), rq_is_sync(rq));
 }
 
 static struct request *
@@ -1565,7 +1565,7 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
-	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
+	cfq_blkiocg_update_io_remove_stats(cfqg_to_blkg(RQ_CFQG(rq)),
 					rq_data_dir(rq), rq_is_sync(rq));
 	if (rq->cmd_flags & REQ_PRIO) {
 		WARN_ON(!cfqq->prio_pending);
@@ -1601,7 +1601,7 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
-	cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg,
+	cfq_blkiocg_update_io_merged_stats(cfqg_to_blkg(RQ_CFQG(req)),
 					bio_data_dir(bio), cfq_bio_sync(bio));
 }
 
@@ -1624,7 +1624,7 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
-	cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg,
+	cfq_blkiocg_update_io_merged_stats(cfqg_to_blkg(RQ_CFQG(rq)),
 					rq_data_dir(next), rq_is_sync(next));
 
 	cfqq = RQ_CFQQ(next);
@@ -1666,7 +1666,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	del_timer(&cfqd->idle_slice_timer);
-	cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
+	cfq_blkiocg_update_idle_time_stats(cfqg_to_blkg(cfqq->cfqg));
 }
 
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
@@ -1675,7 +1675,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
-		cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
+		cfq_blkiocg_update_avg_queue_size_stats(cfqg_to_blkg(cfqq->cfqg));
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
 		cfqq->allocated_slice = 0;
@@ -2023,7 +2023,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 		sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	cfq_blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
+	cfq_blkiocg_update_set_idle_time_stats(cfqg_to_blkg(cfqq->cfqg));
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu group_idle: %d", sl,
 			group_idle ? 1 : 0);
 }
@@ -2046,8 +2046,9 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
-	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
-					rq_data_dir(rq), rq_is_sync(rq));
+	cfq_blkiocg_update_dispatch_stats(cfqg_to_blkg(cfqq->cfqg),
+					  blk_rq_bytes(rq), rq_data_dir(rq),
+					  rq_is_sync(rq));
 }
 
 /*
@@ -3135,7 +3136,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				__blk_run_queue(cfqd->queue);
 			} else {
 				cfq_blkiocg_update_idle_time_stats(
-						&cfqq->cfqg->blkg);
+						cfqg_to_blkg(cfqq->cfqg));
 				cfq_mark_cfqq_must_dispatch(cfqq);
 			}
 		}
@@ -3162,9 +3163,9 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
-	cfq_blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
-			&cfqd->serving_group->blkg, rq_data_dir(rq),
-			rq_is_sync(rq));
+	cfq_blkiocg_update_io_add_stats(cfqg_to_blkg(RQ_CFQG(rq)),
+					cfqg_to_blkg(cfqd->serving_group),
+					rq_data_dir(rq), rq_is_sync(rq));
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 
@@ -3260,7 +3261,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
 	(RQ_CFQG(rq))->dispatched--;
-	cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
+	cfq_blkiocg_update_completion_stats(cfqg_to_blkg(cfqq->cfqg),
 			rq_start_time_ns(rq), rq_io_start_time_ns(rq),
 			rq_data_dir(rq), rq_is_sync(rq));
 
@@ -3641,7 +3642,7 @@ static int cfq_init_queue(struct request_queue *q)
 	blkg = blkg_lookup_create(&blkio_root_cgroup, q, BLKIO_POLICY_PROP,
 				  true);
 	if (!IS_ERR(blkg))
-		cfqd->root_group = cfqg_of_blkg(blkg);
+		cfqd->root_group = blkg_to_cfqg(blkg);
 
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
@@ -3827,13 +3828,14 @@ static struct elevator_type iosched_cfq = {
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
-		.blkio_alloc_group_fn =		cfq_alloc_blkio_group,
+		.blkio_init_group_fn =		cfq_init_blkio_group,
 		.blkio_link_group_fn =		cfq_link_blkio_group,
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
 		.blkio_clear_queue_fn = cfq_clear_queue,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
 	},
 	.plid = BLKIO_POLICY_PROP,
+	.pdata_size = sizeof(struct cfq_group),
 };
 #endif
 
-- 
1.7.7.3

