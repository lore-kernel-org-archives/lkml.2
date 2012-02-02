Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2BBAhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:37:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39685 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2BBAhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:37:35 -0500
Date: Wed, 1 Feb 2012 16:37:30 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120202003730.GC19837@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328131156-13290-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blkg is per cgroup-queue-policy combination.  This is
unnatural and leads to various convolutions in partially used
duplicate fields in blkg, config / stat access, and general management
of blkgs.

This patch make blkg's per cgroup-queue and let them serve all
policies.  blkgs are now created and destroyed by blkcg core proper.
This will allow further consolidation of common management logic into
blkcg core and API with better defined semantics and layering.

As a transitional step to untangle blkg management, elvswitch and
policy [de]registration, all blkgs except the root blkg are being shot
down during elvswitch and bypass.  This patch adds blkg_root_update()
to update root blkg in place on policy change.  This is hacky and racy
but should be good enough as interim step until we get locking
simplified and switch over to proper in-place update for all blkgs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
I was thinking root blkgs should be updated on policy changes and
commit message and comments were written that way too but for some
reason I wrote code which updates on elvswitch, which leads to oops on
root blkg access after policy changes (ie. insmod cfq-iosched.ko).
Fixed.  git branch updated accordingly.

Thanks.

 block/blk-cgroup.c     |  215 +++++++++++++++++++++++++++++--------------------
 block/blk-cgroup.h     |   10 --
 block/blk-core.c       |    3 
 block/blk-sysfs.c      |    4 
 block/blk-throttle.c   |    9 --
 block/cfq-iosched.c    |    4 
 block/elevator.c       |    5 -
 include/linux/blkdev.h |    5 -
 8 files changed, 143 insertions(+), 112 deletions(-)

Index: work/block/blk-cgroup.c
===================================================================
--- work.orig/block/blk-cgroup.c
+++ work/block/blk-cgroup.c
@@ -461,16 +461,20 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_merg
  */
 static void blkg_free(struct blkio_group *blkg)
 {
-	struct blkg_policy_data *pd;
+	int i;
 
 	if (!blkg)
 		return;
 
-	pd = blkg->pd[blkg->plid];
-	if (pd) {
-		free_percpu(pd->stats_cpu);
-		kfree(pd);
+	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+		struct blkg_policy_data *pd = blkg->pd[i];
+
+		if (pd) {
+			free_percpu(pd->stats_cpu);
+			kfree(pd);
+		}
 	}
+
 	kfree(blkg);
 }
 
@@ -486,11 +490,10 @@ static void blkg_free(struct blkio_group
  *        percpu stat breakage.
  */
 static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
-				      struct request_queue *q,
-				      struct blkio_policy_type *pol)
+				      struct request_queue *q)
 {
 	struct blkio_group *blkg;
-	struct blkg_policy_data *pd;
+	int i;
 
 	/* alloc and init base part */
 	blkg = kzalloc_node(sizeof(*blkg), GFP_ATOMIC, q->node);
@@ -499,34 +502,45 @@ static struct blkio_group *blkg_alloc(st
 
 	spin_lock_init(&blkg->stats_lock);
 	rcu_assign_pointer(blkg->q, q);
-	INIT_LIST_HEAD(&blkg->q_node[0]);
-	INIT_LIST_HEAD(&blkg->q_node[1]);
+	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
-	blkg->plid = pol->plid;
 	blkg->refcnt = 1;
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
 
-	/* alloc per-policy data and attach it to blkg */
-	pd = kzalloc_node(sizeof(*pd) + pol->pdata_size, GFP_ATOMIC,
-			  q->node);
-	if (!pd) {
-		blkg_free(blkg);
-		return NULL;
-	}
+	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+		struct blkio_policy_type *pol = blkio_policy[i];
+		struct blkg_policy_data *pd;
+
+		if (!pol)
+			continue;
 
-	blkg->pd[pol->plid] = pd;
-	pd->blkg = blkg;
+		/* alloc per-policy data and attach it to blkg */
+		pd = kzalloc_node(sizeof(*pd) + pol->pdata_size, GFP_ATOMIC,
+				  q->node);
+		if (!pd) {
+			blkg_free(blkg);
+			return NULL;
+		}
 
-	/* broken, read comment in the callsite */
+		blkg->pd[i] = pd;
+		pd->blkg = blkg;
 
-	pd->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
-	if (!pd->stats_cpu) {
-		blkg_free(blkg);
-		return NULL;
+		/* broken, read comment in the callsite */
+		pd->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+		if (!pd->stats_cpu) {
+			blkg_free(blkg);
+			return NULL;
+		}
 	}
 
 	/* invoke per-policy init */
-	pol->ops.blkio_init_group_fn(blkg);
+	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+		struct blkio_policy_type *pol = blkio_policy[i];
+
+		if (pol)
+			pol->ops.blkio_init_group_fn(blkg);
+	}
+
 	return blkg;
 }
 
@@ -536,7 +550,6 @@ struct blkio_group *blkg_lookup_create(s
 				       bool for_root)
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
-	struct blkio_policy_type *pol = blkio_policy[plid];
 	struct blkio_group *blkg, *new_blkg;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -551,7 +564,7 @@ struct blkio_group *blkg_lookup_create(s
 	if (unlikely(blk_queue_bypass(q)) && !for_root)
 		return ERR_PTR(blk_queue_dead(q) ? -EINVAL : -EBUSY);
 
-	blkg = blkg_lookup(blkcg, q, plid);
+	blkg = blkg_lookup(blkcg, q);
 	if (blkg)
 		return blkg;
 
@@ -571,7 +584,7 @@ struct blkio_group *blkg_lookup_create(s
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
 
-	new_blkg = blkg_alloc(blkcg, q, pol);
+	new_blkg = blkg_alloc(blkcg, q);
 
 	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
@@ -583,7 +596,7 @@ struct blkio_group *blkg_lookup_create(s
 	}
 
 	/* did someone beat us to it? */
-	blkg = blkg_lookup(blkcg, q, plid);
+	blkg = blkg_lookup(blkcg, q);
 	if (unlikely(blkg))
 		goto out;
 
@@ -598,8 +611,8 @@ struct blkio_group *blkg_lookup_create(s
 	swap(blkg, new_blkg);
 
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
-	list_add(&blkg->q_node[plid], &q->blkg_list[plid]);
-	q->nr_blkgs[plid]++;
+	list_add(&blkg->q_node, &q->blkg_list);
+	q->nr_blkgs++;
 
 	spin_unlock(&blkcg->lock);
 out:
@@ -636,31 +649,30 @@ EXPORT_SYMBOL_GPL(blkiocg_del_blkio_grou
 
 /* called under rcu_read_lock(). */
 struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
-				struct request_queue *q,
-				enum blkio_policy_id plid)
+				struct request_queue *q)
 {
 	struct blkio_group *blkg;
 	struct hlist_node *n;
 
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node)
-		if (blkg->q == q && blkg->plid == plid)
+		if (blkg->q == q)
 			return blkg;
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(blkg_lookup);
 
-static void blkg_destroy(struct blkio_group *blkg, enum blkio_policy_id plid)
+static void blkg_destroy(struct blkio_group *blkg)
 {
 	struct request_queue *q = blkg->q;
 
 	lockdep_assert_held(q->queue_lock);
 
 	/* Something wrong if we are trying to remove same group twice */
-	WARN_ON_ONCE(list_empty(&blkg->q_node[plid]));
-	list_del_init(&blkg->q_node[plid]);
+	WARN_ON_ONCE(list_empty(&blkg->q_node));
+	list_del_init(&blkg->q_node);
 
-	WARN_ON_ONCE(q->nr_blkgs[plid] <= 0);
-	q->nr_blkgs[plid]--;
+	WARN_ON_ONCE(q->nr_blkgs <= 0);
+	q->nr_blkgs--;
 
 	/*
 	 * Put the reference taken at the time of creation so that when all
@@ -669,8 +681,7 @@ static void blkg_destroy(struct blkio_gr
 	blkg_put(blkg);
 }
 
-void blkg_destroy_all(struct request_queue *q, enum blkio_policy_id plid,
-		      bool destroy_root)
+void blkg_destroy_all(struct request_queue *q, bool destroy_root)
 {
 	struct blkio_group *blkg, *n;
 
@@ -679,8 +690,7 @@ void blkg_destroy_all(struct request_que
 
 		spin_lock_irq(q->queue_lock);
 
-		list_for_each_entry_safe(blkg, n, &q->blkg_list[plid],
-					 q_node[plid]) {
+		list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
 			/* skip root? */
 			if (!destroy_root && blkg->blkcg == &blkio_root_cgroup)
 				continue;
@@ -691,7 +701,7 @@ void blkg_destroy_all(struct request_que
 			 * take care of destroying cfqg also.
 			 */
 			if (!blkiocg_del_blkio_group(blkg))
-				blkg_destroy(blkg, plid);
+				blkg_destroy(blkg);
 			else
 				done = false;
 		}
@@ -776,43 +786,49 @@ blkiocg_reset_stats(struct cgroup *cgrou
 #endif
 
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	spin_lock(&blkio_list_lock);
 	spin_lock_irq(&blkcg->lock);
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+		struct blkio_policy_type *pol;
 
-		spin_lock(&blkg->stats_lock);
-		stats = &pd->stats;
+		list_for_each_entry(pol, &blkio_list, list) {
+			struct blkg_policy_data *pd = blkg->pd[pol->plid];
+
+			spin_lock(&blkg->stats_lock);
+			stats = &pd->stats;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-		idling = blkio_blkg_idling(stats);
-		waiting = blkio_blkg_waiting(stats);
-		empty = blkio_blkg_empty(stats);
+			idling = blkio_blkg_idling(stats);
+			waiting = blkio_blkg_waiting(stats);
+			empty = blkio_blkg_empty(stats);
 #endif
-		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
-			queued[i] = stats->stat_arr[BLKIO_STAT_QUEUED][i];
-		memset(stats, 0, sizeof(struct blkio_group_stats));
-		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
-			stats->stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
+			for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+				queued[i] = stats->stat_arr[BLKIO_STAT_QUEUED][i];
+			memset(stats, 0, sizeof(struct blkio_group_stats));
+			for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+				stats->stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-		if (idling) {
-			blkio_mark_blkg_idling(stats);
-			stats->start_idle_time = now;
-		}
-		if (waiting) {
-			blkio_mark_blkg_waiting(stats);
-			stats->start_group_wait_time = now;
-		}
-		if (empty) {
-			blkio_mark_blkg_empty(stats);
-			stats->start_empty_time = now;
-		}
+			if (idling) {
+				blkio_mark_blkg_idling(stats);
+				stats->start_idle_time = now;
+			}
+			if (waiting) {
+				blkio_mark_blkg_waiting(stats);
+				stats->start_group_wait_time = now;
+			}
+			if (empty) {
+				blkio_mark_blkg_empty(stats);
+				stats->start_empty_time = now;
+			}
 #endif
-		spin_unlock(&blkg->stats_lock);
+			spin_unlock(&blkg->stats_lock);
 
-		/* Reset Per cpu stats which don't take blkg->stats_lock */
-		blkio_reset_stats_cpu(blkg, blkg->plid);
+			/* Reset Per cpu stats which don't take blkg->stats_lock */
+			blkio_reset_stats_cpu(blkg, pol->plid);
+		}
 	}
 
 	spin_unlock_irq(&blkcg->lock);
+	spin_unlock(&blkio_list_lock);
 	return 0;
 }
 
@@ -1157,8 +1173,7 @@ static void blkio_read_conf(struct cftyp
 
 	spin_lock_irq(&blkcg->lock);
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
-		if (BLKIOFILE_POLICY(cft->private) == blkg->plid)
-			blkio_print_group_conf(cft, blkg, m);
+		blkio_print_group_conf(cft, blkg, m);
 	spin_unlock_irq(&blkcg->lock);
 }
 
@@ -1213,8 +1228,6 @@ static int blkio_read_blkg_stats(struct 
 		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 		int plid = BLKIOFILE_POLICY(cft->private);
 
-		if (plid != blkg->plid)
-			continue;
 		if (pcpu) {
 			cgroup_total += blkio_get_stat_cpu(blkg, plid,
 							   cb, dname, type);
@@ -1324,9 +1337,9 @@ static int blkio_weight_write(struct blk
 	blkcg->weight = (unsigned int)val;
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+		struct blkg_policy_data *pd = blkg->pd[plid];
 
-		if (blkg->plid == plid && !pd->conf.weight)
+		if (!pd->conf.weight)
 			blkio_update_group_weight(blkg, plid, blkcg->weight);
 	}
 
@@ -1549,7 +1562,6 @@ static int blkiocg_pre_destroy(struct cg
 	unsigned long flags;
 	struct blkio_group *blkg;
 	struct request_queue *q;
-	struct blkio_policy_type *blkiop;
 
 	rcu_read_lock();
 
@@ -1575,11 +1587,7 @@ static int blkiocg_pre_destroy(struct cg
 		 */
 		spin_lock(&blkio_list_lock);
 		spin_lock_irqsave(q->queue_lock, flags);
-		list_for_each_entry(blkiop, &blkio_list, list) {
-			if (blkiop->plid != blkg->plid)
-				continue;
-			blkg_destroy(blkg, blkiop->plid);
-		}
+		blkg_destroy(blkg);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 		spin_unlock(&blkio_list_lock);
 	} while (1);
@@ -1673,6 +1681,8 @@ void blkcg_exit_queue(struct request_que
 	list_del_init(&q->all_q_node);
 	mutex_unlock(&all_q_mutex);
 
+	blkg_destroy_all(q, true);
+
 	blk_throtl_exit(q);
 }
 
@@ -1722,14 +1732,12 @@ static void blkcg_bypass_start(void)
 	__acquires(&all_q_mutex)
 {
 	struct request_queue *q;
-	int i;
 
 	mutex_lock(&all_q_mutex);
 
 	list_for_each_entry(q, &all_q_list, all_q_node) {
 		blk_queue_bypass_start(q);
-		for (i = 0; i < BLKIO_NR_POLICIES; i++)
-			blkg_destroy_all(q, i, false);
+		blkg_destroy_all(q, false);
 	}
 }
 
@@ -1744,6 +1752,39 @@ static void blkcg_bypass_end(void)
 	mutex_unlock(&all_q_mutex);
 }
 
+/*
+ * XXX: This updates blkg policy data in-place for root blkg, which is
+ * necessary across policy registration as root blkgs aren't shot down.
+ * This broken and racy implementation is interim.  Eventually, blkg shoot
+ * down will be replaced by proper in-place update.
+ */
+static void update_root_blkgs(enum blkio_policy_id plid)
+{
+	struct blkio_policy_type *pol = blkio_policy[plid];
+	struct request_queue *q;
+
+	list_for_each_entry(q, &all_q_list, all_q_node) {
+		struct blkio_group *blkg = blkg_lookup(&blkio_root_cgroup, q);
+		struct blkg_policy_data *pd;
+
+		kfree(blkg->pd[plid]);
+		blkg->pd[plid] = NULL;
+
+		if (!pol)
+			continue;
+
+		pd = kzalloc(sizeof(*pd) + pol->pdata_size, GFP_KERNEL);
+		WARN_ON_ONCE(!pd);
+
+		pd->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+		WARN_ON_ONCE(!pd->stats_cpu);
+
+		blkg->pd[plid] = pd;
+		pd->blkg = blkg;
+		pol->ops.blkio_init_group_fn(blkg);
+	}
+}
+
 void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
 	blkcg_bypass_start();
@@ -1754,6 +1795,7 @@ void blkio_policy_register(struct blkio_
 	list_add_tail(&blkiop->list, &blkio_list);
 
 	spin_unlock(&blkio_list_lock);
+	update_root_blkgs(blkiop->plid);
 	blkcg_bypass_end();
 }
 EXPORT_SYMBOL_GPL(blkio_policy_register);
@@ -1768,6 +1810,7 @@ void blkio_policy_unregister(struct blki
 	list_del_init(&blkiop->list);
 
 	spin_unlock(&blkio_list_lock);
+	update_root_blkgs(blkiop->plid);
 	blkcg_bypass_end();
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
Index: work/block/blk-cgroup.h
===================================================================
--- work.orig/block/blk-cgroup.h
+++ work/block/blk-cgroup.h
@@ -178,13 +178,11 @@ struct blkg_policy_data {
 struct blkio_group {
 	/* Pointer to the associated request_queue, RCU protected */
 	struct request_queue __rcu *q;
-	struct list_head q_node[BLKIO_NR_POLICIES];
+	struct list_head q_node;
 	struct hlist_node blkcg_node;
 	struct blkio_cgroup *blkcg;
 	/* Store cgroup path */
 	char path[128];
-	/* policy which owns this blk group */
-	enum blkio_policy_id plid;
 	/* reference count */
 	int refcnt;
 
@@ -230,8 +228,7 @@ extern void blkcg_exit_queue(struct requ
 /* Blkio controller policy registration */
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
-extern void blkg_destroy_all(struct request_queue *q,
-			     enum blkio_policy_id plid, bool destroy_root);
+extern void blkg_destroy_all(struct request_queue *q, bool destroy_root);
 
 /**
  * blkg_to_pdata - get policy private data
@@ -382,8 +379,7 @@ extern struct blkio_cgroup *cgroup_to_bl
 extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
-				       struct request_queue *q,
-				       enum blkio_policy_id plid);
+				       struct request_queue *q);
 struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 				       struct request_queue *q,
 				       enum blkio_policy_id plid,
Index: work/block/blk-throttle.c
===================================================================
--- work.orig/block/blk-throttle.c
+++ work/block/blk-throttle.c
@@ -167,7 +167,7 @@ throtl_grp *throtl_lookup_tg(struct thro
 	if (blkcg == &blkio_root_cgroup)
 		return td->root_tg;
 
-	return blkg_to_tg(blkg_lookup(blkcg, td->queue, BLKIO_POLICY_THROTL));
+	return blkg_to_tg(blkg_lookup(blkcg, td->queue));
 }
 
 static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
@@ -704,8 +704,7 @@ static void throtl_process_limit_change(
 
 	throtl_log(td, "limits changed");
 
-	list_for_each_entry_safe(blkg, n, &q->blkg_list[BLKIO_POLICY_THROTL],
-				 q_node[BLKIO_POLICY_THROTL]) {
+	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
 		struct throtl_grp *tg = blkg_to_tg(blkg);
 
 		if (!tg->limits_changed)
@@ -1054,11 +1053,9 @@ void blk_throtl_exit(struct request_queu
 
 	throtl_shutdown_wq(q);
 
-	blkg_destroy_all(q, BLKIO_POLICY_THROTL, true);
-
 	/* If there are other groups */
 	spin_lock_irq(q->queue_lock);
-	wait = q->nr_blkgs[BLKIO_POLICY_THROTL];
+	wait = q->nr_blkgs;
 	spin_unlock_irq(q->queue_lock);
 
 	/*
Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -3468,14 +3468,12 @@ static void cfq_exit_queue(struct elevat
 
 	spin_unlock_irq(q->queue_lock);
 
-	blkg_destroy_all(q, BLKIO_POLICY_PROP, true);
-
 	/*
 	 * If there are groups which we could not unlink from blkcg list,
 	 * wait for a rcu period for them to be freed.
 	 */
 	spin_lock_irq(q->queue_lock);
-	wait = q->nr_blkgs[BLKIO_POLICY_PROP];
+	wait = q->nr_blkgs;
 	spin_unlock_irq(q->queue_lock);
 
 	cfq_shutdown_timer_wq(cfqd);
Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -547,8 +547,7 @@ struct request_queue *blk_alloc_queue_no
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->icq_list);
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
-	INIT_LIST_HEAD(&q->blkg_list[0]);
-	INIT_LIST_HEAD(&q->blkg_list[1]);
+	INIT_LIST_HEAD(&q->blkg_list);
 #endif
 	INIT_LIST_HEAD(&q->flush_queue[0]);
 	INIT_LIST_HEAD(&q->flush_queue[1]);
Index: work/block/elevator.c
===================================================================
--- work.orig/block/elevator.c
+++ work/block/elevator.c
@@ -923,7 +923,7 @@ static int elevator_switch(struct reques
 {
 	struct elevator_queue *old = q->elevator;
 	bool registered = old->registered;
-	int i, err;
+	int err;
 
 	/*
 	 * Turn on BYPASS and drain all requests w/ elevator private data.
@@ -942,8 +942,7 @@ static int elevator_switch(struct reques
 	ioc_clear_queue(q);
 	spin_unlock_irq(q->queue_lock);
 
-	for (i = 0; i < BLKIO_NR_POLICIES; i++)
-		blkg_destroy_all(q, i, false);
+	blkg_destroy_all(q, false);
 
 	/* allocate, init and register new elevator */
 	err = -ENOMEM;
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -363,9 +363,8 @@ struct request_queue {
 
 	struct list_head	icq_list;
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
-	/* XXX: array size hardcoded to avoid include dependency (temporary) */
-	struct list_head	blkg_list[2];
-	int			nr_blkgs[2];
+	struct list_head	blkg_list;
+	int			nr_blkgs;
 #endif
 
 	struct queue_limits	limits;
Index: work/block/blk-sysfs.c
===================================================================
--- work.orig/block/blk-sysfs.c
+++ work/block/blk-sysfs.c
@@ -480,6 +480,8 @@ static void blk_release_queue(struct kob
 
 	blk_sync_queue(q);
 
+	blkcg_exit_queue(q);
+
 	if (q->elevator) {
 		spin_lock_irq(q->queue_lock);
 		ioc_clear_queue(q);
@@ -487,8 +489,6 @@ static void blk_release_queue(struct kob
 		elevator_exit(q->elevator);
 	}
 
-	blkcg_exit_queue(q);
-
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
