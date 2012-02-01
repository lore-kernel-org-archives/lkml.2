Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2BAVY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:24:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60700 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2BAVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:35 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/11] blkcg: move refcnt to blkcg core
Date: Wed,  1 Feb 2012 13:19:11 -0800
Message-Id: <1328131156-13290-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328131156-13290-1-git-send-email-tj@kernel.org>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blkcg policy implementations manage blkg refcnt duplicating
mostly identical code in both policies.  This patch moves refcnt to
blkg and let blkcg core handle refcnt and freeing of blkgs.

* cfq blkgs now also get freed via RCU.

* cfq blkgs lose RB_EMPTY_ROOT() sanity check on blkg free.  If
  necessary, we can add blkio_exit_group_fn() to resurrect this.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   24 ++++++++++++++++++++
 block/blk-cgroup.h   |   35 ++++++++++++++++++++++++++++++
 block/blk-throttle.c |   58 +++----------------------------------------------
 block/cfq-iosched.c  |   58 ++++++++-----------------------------------------
 4 files changed, 73 insertions(+), 102 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e42da84..ba49af3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -463,6 +463,7 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 	rcu_assign_pointer(blkg->q, q);
 	blkg->blkcg = blkcg;
 	blkg->plid = pol->plid;
+	blkg->refcnt = 1;
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
 
 	/* alloc per-policy data */
@@ -633,6 +634,29 @@ void blkg_destroy_all(struct request_queue *q)
 	}
 }
 
+static void blkg_rcu_free(struct rcu_head *rcu_head)
+{
+	blkg_free(container_of(rcu_head, struct blkio_group, rcu_head));
+}
+
+void __blkg_release(struct blkio_group *blkg)
+{
+	/* release the extra blkcg reference this blkg has been holding */
+	css_put(&blkg->blkcg->css);
+
+	/*
+	 * A group is freed in rcu manner. But having an rcu lock does not
+	 * mean that one can access all the fields of blkg and assume these
+	 * are valid. For example, don't try to follow throtl_data and
+	 * request queue links.
+	 *
+	 * Having a reference to blkg under an rcu allows acess to only
+	 * values local to groups like group stats and group rate limits
+	 */
+	call_rcu(&blkg->rcu_head, blkg_rcu_free);
+}
+EXPORT_SYMBOL_GPL(__blkg_release);
+
 static void blkio_reset_stats_cpu(struct blkio_group *blkg)
 {
 	struct blkio_group_stats_cpu *stats_cpu;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 9537819..7da1068 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -177,6 +177,8 @@ struct blkio_group {
 	char path[128];
 	/* policy which owns this blk group */
 	enum blkio_policy_id plid;
+	/* reference count */
+	int refcnt;
 
 	/* Configuration */
 	struct blkio_group_conf conf;
@@ -188,6 +190,8 @@ struct blkio_group {
 	struct blkio_group_stats_cpu __percpu *stats_cpu;
 
 	struct blkg_policy_data *pd;
+
+	struct rcu_head rcu_head;
 };
 
 typedef void (blkio_init_group_fn)(struct blkio_group *blkg);
@@ -272,6 +276,35 @@ static inline char *blkg_path(struct blkio_group *blkg)
 	return blkg->path;
 }
 
+/**
+ * blkg_get - get a blkg reference
+ * @blkg: blkg to get
+ *
+ * The caller should be holding queue_lock and an existing reference.
+ */
+static inline void blkg_get(struct blkio_group *blkg)
+{
+	lockdep_assert_held(blkg->q->queue_lock);
+	WARN_ON_ONCE(!blkg->refcnt);
+	blkg->refcnt++;
+}
+
+void __blkg_release(struct blkio_group *blkg);
+
+/**
+ * blkg_put - put a blkg reference
+ * @blkg: blkg to put
+ *
+ * The caller should be holding queue_lock.
+ */
+static inline void blkg_put(struct blkio_group *blkg)
+{
+	lockdep_assert_held(blkg->q->queue_lock);
+	WARN_ON_ONCE(blkg->refcnt <= 0);
+	if (!--blkg->refcnt)
+		__blkg_release(blkg);
+}
+
 #else
 
 struct blkio_group {
@@ -292,6 +325,8 @@ static inline void *blkg_to_pdata(struct blkio_group *blkg,
 static inline struct blkio_group *pdata_to_blkg(void *pdata,
 				struct blkio_policy_type *pol) { return NULL; }
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
+static inline void blkg_get(struct blkio_group *blkg) { }
+static inline void blkg_put(struct blkio_group *blkg) { }
 
 #endif
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9c8a124..153ba50 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -54,7 +54,6 @@ struct throtl_grp {
 	 */
 	unsigned long disptime;
 
-	atomic_t ref;
 	unsigned int flags;
 
 	/* Two lists for READ and WRITE */
@@ -80,8 +79,6 @@ struct throtl_grp {
 
 	/* Some throttle limits got updated for the group */
 	int limits_changed;
-
-	struct rcu_head rcu_head;
 };
 
 struct throtl_data
@@ -151,45 +148,6 @@ static inline unsigned int total_nr_queued(struct throtl_data *td)
 	return td->nr_queued[0] + td->nr_queued[1];
 }
 
-static inline struct throtl_grp *throtl_ref_get_tg(struct throtl_grp *tg)
-{
-	atomic_inc(&tg->ref);
-	return tg;
-}
-
-static void throtl_free_tg(struct rcu_head *head)
-{
-	struct throtl_grp *tg = container_of(head, struct throtl_grp, rcu_head);
-	struct blkio_group *blkg = tg_to_blkg(tg);
-
-	free_percpu(blkg->stats_cpu);
-	kfree(blkg->pd);
-	kfree(blkg);
-}
-
-static void throtl_put_tg(struct throtl_grp *tg)
-{
-	struct blkio_group *blkg = tg_to_blkg(tg);
-
-	BUG_ON(atomic_read(&tg->ref) <= 0);
-	if (!atomic_dec_and_test(&tg->ref))
-		return;
-
-	/* release the extra blkcg reference this blkg has been holding */
-	css_put(&blkg->blkcg->css);
-
-	/*
-	 * A group is freed in rcu manner. But having an rcu lock does not
-	 * mean that one can access all the fields of blkg and assume these
-	 * are valid. For example, don't try to follow throtl_data and
-	 * request queue links.
-	 *
-	 * Having a reference to blkg under an rcu allows acess to only
-	 * values local to groups like group stats and group rate limits
-	 */
-	call_rcu(&tg->rcu_head, throtl_free_tg);
-}
-
 static void throtl_init_blkio_group(struct blkio_group *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
@@ -204,14 +162,6 @@ static void throtl_init_blkio_group(struct blkio_group *blkg)
 	tg->bps[WRITE] = -1;
 	tg->iops[READ] = -1;
 	tg->iops[WRITE] = -1;
-
-	/*
-	 * Take the initial reference that will be released on destroy
-	 * This can be thought of a joint reference by cgroup and
-	 * request queue which will be dropped by either request queue
-	 * exit or cgroup deletion path depending on who is exiting first.
-	 */
-	atomic_set(&tg->ref, 1);
 }
 
 static void throtl_link_blkio_group(struct request_queue *q,
@@ -648,7 +598,7 @@ static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
 
 	bio_list_add(&tg->bio_lists[rw], bio);
 	/* Take a bio reference on tg */
-	throtl_ref_get_tg(tg);
+	blkg_get(tg_to_blkg(tg));
 	tg->nr_queued[rw]++;
 	td->nr_queued[rw]++;
 	throtl_enqueue_tg(td, tg);
@@ -681,8 +631,8 @@ static void tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg,
 
 	bio = bio_list_pop(&tg->bio_lists[rw]);
 	tg->nr_queued[rw]--;
-	/* Drop bio reference on tg */
-	throtl_put_tg(tg);
+	/* Drop bio reference on blkg */
+	blkg_put(tg_to_blkg(tg));
 
 	BUG_ON(td->nr_queued[rw] <= 0);
 	td->nr_queued[rw]--;
@@ -880,7 +830,7 @@ throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
-	throtl_put_tg(tg);
+	blkg_put(tg_to_blkg(tg));
 	td->nr_undestroyed_grps--;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0875c7f..5ce81a8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -210,7 +210,6 @@ struct cfq_group {
 	enum wl_prio_t saved_serving_prio;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
-	int ref;
 #endif
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
@@ -1071,14 +1070,6 @@ static void cfq_init_blkio_group(struct blkio_group *blkg)
 
 	cfq_init_cfqg_base(cfqg);
 	cfqg->weight = blkg->blkcg->weight;
-
-	/*
-	 * Take the initial reference that will be released on destroy
-	 * This can be thought of a joint reference by cgroup and
-	 * elevator which will be dropped by either elevator exit
-	 * or cgroup deletion path depending on who is exiting first.
-	 */
-	cfqg->ref = 1;
 }
 
 /*
@@ -1105,12 +1096,6 @@ static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
 	return cfqg;
 }
 
-static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
-{
-	cfqg->ref++;
-	return cfqg;
-}
-
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
 	/* Currently, all async queues are mapped to root group */
@@ -1119,28 +1104,7 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
-	cfqq->cfqg->ref++;
-}
-
-static void cfq_put_cfqg(struct cfq_group *cfqg)
-{
-	struct blkio_group *blkg = cfqg_to_blkg(cfqg);
-	struct cfq_rb_root *st;
-	int i, j;
-
-	BUG_ON(cfqg->ref <= 0);
-	cfqg->ref--;
-	if (cfqg->ref)
-		return;
-
-	/* release the extra blkcg reference this blkg has been holding */
-	css_put(&blkg->blkcg->css);
-
-	for_each_cfqg_st(cfqg, i, j, st)
-		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
-	free_percpu(blkg->stats_cpu);
-	kfree(blkg->pd);
-	kfree(blkg);
+	blkg_get(cfqg_to_blkg(cfqg));
 }
 
 static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
@@ -1157,7 +1121,7 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
-	cfq_put_cfqg(cfqg);
+	blkg_put(cfqg_to_blkg(cfqg));
 }
 
 static bool cfq_release_cfq_groups(struct cfq_data *cfqd)
@@ -1225,18 +1189,12 @@ static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
 	return cfqd->root_group;
 }
 
-static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
-{
-	return cfqg;
-}
-
 static inline void
 cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 	cfqq->cfqg = cfqg;
 }
 
 static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
-static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 
 #endif /* GROUP_IOSCHED */
 
@@ -2637,7 +2595,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	kmem_cache_free(cfq_pool, cfqq);
-	cfq_put_cfqg(cfqg);
+	blkg_put(cfqg_to_blkg(cfqg));
 }
 
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
@@ -3388,7 +3346,7 @@ static void cfq_put_request(struct request *rq)
 		cfqq->allocated[rw]--;
 
 		/* Put down rq reference on cfqg */
-		cfq_put_cfqg(RQ_CFQG(rq));
+		blkg_put(cfqg_to_blkg(RQ_CFQG(rq)));
 		rq->elv.priv[0] = NULL;
 		rq->elv.priv[1] = NULL;
 
@@ -3483,8 +3441,9 @@ new_queue:
 	cfqq->allocated[rw]++;
 
 	cfqq->ref++;
+	blkg_get(cfqg_to_blkg(cfqq->cfqg));
 	rq->elv.priv[0] = cfqq;
-	rq->elv.priv[1] = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->elv.priv[1] = cfqq->cfqg;
 	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
@@ -3682,8 +3641,11 @@ static int cfq_init_queue(struct request_queue *q)
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
 	cfqd->oom_cfqq.ref++;
+
+	spin_lock_irq(q->queue_lock);
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, cfqd->root_group);
-	cfq_put_cfqg(cfqd->root_group);
+	blkg_put(cfqg_to_blkg(cfqd->root_group));
+	spin_unlock_irq(q->queue_lock);
 
 	init_timer(&cfqd->idle_slice_timer);
 	cfqd->idle_slice_timer.function = cfq_idle_slice_timer;
-- 
1.7.7.3

