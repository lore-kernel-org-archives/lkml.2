Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2BPWiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:38:10 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35363 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BPWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:38:08 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Date: Thu, 16 Feb 2012 14:37:51 -0800
Message-Id: <1329431878-28300-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329431878-28300-1-git-send-email-tj@kernel.org>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that blkg additions / removals are always done under both q and
blkcg locks, the only place RCU locking is used is blkg_lookup() for
lockless lookup.  This patch drops unncessary RCU locking replacing it
with plain blkcg / q locking as necessary.

* blkg_lookup_create() and blkiocg_pre_destroy() already perform
  proper locking and don't need RCU.  Dropped.

* queue_lock coverage extended to cover @blkg usage in
  blkio_policy_parse_and_set() and RCU dropped.  This means all config
  update callbacks are now called under queue_lock.

* blkio_read_blkg_stats() now uses blkcg->lock instead of RCU read
  lock.  This isn't a hot path.

* RCU locking around blkg_lookup_create() in cfq_init_queue() and
  blk_throtl_init() removed.

* Now unnecessary synchronize_rcu() from queue exit paths removed.
  This makes q->nr_blkgs unnecessary.  Dropped.

* RCU annotation on blkg->q removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c     |   26 +++++++-------------------
 block/blk-cgroup.h     |    4 ++--
 block/blk-throttle.c   |   35 +----------------------------------
 block/cfq-iosched.c    |   26 --------------------------
 include/linux/blkdev.h |    1 -
 5 files changed, 10 insertions(+), 82 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index aee71ef..fb5f21b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -500,7 +500,7 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 		return NULL;
 
 	spin_lock_init(&blkg->stats_lock);
-	rcu_assign_pointer(blkg->q, q);
+	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
 	blkg->refcnt = 1;
@@ -551,7 +551,6 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 {
 	struct blkio_group *blkg, *new_blkg;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
 
 	/*
@@ -581,11 +580,9 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 	 * allocation is fixed.
 	 */
 	spin_unlock_irq(q->queue_lock);
-	rcu_read_unlock();
 
 	new_blkg = blkg_alloc(blkcg, q);
 
-	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
 
 	/* did bypass get turned on inbetween? */
@@ -611,7 +608,6 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	list_add(&blkg->q_node, &q->blkg_list);
-	q->nr_blkgs++;
 
 	spin_unlock(&blkcg->lock);
 out:
@@ -648,9 +644,6 @@ static void blkg_destroy(struct blkio_group *blkg)
 	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
-	WARN_ON_ONCE(q->nr_blkgs <= 0);
-	q->nr_blkgs--;
-
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
@@ -1041,11 +1034,8 @@ static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
 	if (!disk || part)
 		goto out;
 
-	rcu_read_lock();
-
 	spin_lock_irq(disk->queue->queue_lock);
 	blkg = blkg_lookup_create(blkcg, disk->queue, plid, false);
-	spin_unlock_irq(disk->queue->queue_lock);
 
 	if (IS_ERR(blkg)) {
 		ret = PTR_ERR(blkg);
@@ -1092,7 +1082,7 @@ static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
 	}
 	ret = 0;
 out_unlock:
-	rcu_read_unlock();
+	spin_unlock_irq(disk->queue->queue_lock);
 out:
 	put_disk(disk);
 
@@ -1224,7 +1214,8 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 	struct hlist_node *n;
 	uint64_t cgroup_total = 0;
 
-	rcu_read_lock();
+	spin_lock_irq(&blkcg->lock);
+
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 		int plid = BLKIOFILE_POLICY(cft->private);
@@ -1241,7 +1232,8 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 	}
 	if (show_total)
 		cb->fill(cb, "Total", cgroup_total);
-	rcu_read_unlock();
+
+	spin_unlock_irq(&blkcg->lock);
 	return 0;
 }
 
@@ -1573,28 +1565,24 @@ static int blkiocg_pre_destroy(struct cgroup_subsys *subsys,
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 
-	rcu_read_lock();
 	spin_lock_irq(&blkcg->lock);
 
 	while (!hlist_empty(&blkcg->blkg_list)) {
 		struct blkio_group *blkg = hlist_entry(blkcg->blkg_list.first,
 						struct blkio_group, blkcg_node);
-		struct request_queue *q = rcu_dereference(blkg->q);
+		struct request_queue *q = blkg->q;
 
 		if (spin_trylock(q->queue_lock)) {
 			blkg_destroy(blkg);
 			spin_unlock(q->queue_lock);
 		} else {
 			spin_unlock_irq(&blkcg->lock);
-			rcu_read_unlock();
 			cpu_relax();
-			rcu_read_lock();
 			spin_lock(&blkcg->lock);
 		}
 	}
 
 	spin_unlock_irq(&blkcg->lock);
-	rcu_read_unlock();
 	return 0;
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index bebc442..1a80619 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -176,8 +176,8 @@ struct blkg_policy_data {
 };
 
 struct blkio_group {
-	/* Pointer to the associated request_queue, RCU protected */
-	struct request_queue __rcu *q;
+	/* Pointer to the associated request_queue */
+	struct request_queue *q;
 	struct list_head q_node;
 	struct hlist_node blkcg_node;
 	struct blkio_cgroup *blkcg;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e35ee7a..8cd13ec 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1026,7 +1026,6 @@ int blk_throtl_init(struct request_queue *q)
 	td->queue = q;
 
 	/* alloc and init root group. */
-	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
 
 	blkg = blkg_lookup_create(&blkio_root_cgroup, q, BLKIO_POLICY_THROTL,
@@ -1035,7 +1034,6 @@ int blk_throtl_init(struct request_queue *q)
 		td->root_tg = blkg_to_tg(blkg);
 
 	spin_unlock_irq(q->queue_lock);
-	rcu_read_unlock();
 
 	if (!td->root_tg) {
 		kfree(td);
@@ -1046,39 +1044,8 @@ int blk_throtl_init(struct request_queue *q)
 
 void blk_throtl_exit(struct request_queue *q)
 {
-	struct throtl_data *td = q->td;
-	bool wait;
-
-	BUG_ON(!td);
-
+	BUG_ON(!q->td);
 	throtl_shutdown_wq(q);
-
-	/* If there are other groups */
-	spin_lock_irq(q->queue_lock);
-	wait = q->nr_blkgs;
-	spin_unlock_irq(q->queue_lock);
-
-	/*
-	 * Wait for tg_to_blkg(tg)->q accessors to exit their grace periods.
-	 * Do this wait only if there are other undestroyed groups out
-	 * there (other than root group). This can happen if cgroup deletion
-	 * path claimed the responsibility of cleaning up a group before
-	 * queue cleanup code get to the group.
-	 *
-	 * Do not call synchronize_rcu() unconditionally as there are drivers
-	 * which create/delete request queue hundreds of times during scan/boot
-	 * and synchronize_rcu() can take significant time and slow down boot.
-	 */
-	if (wait)
-		synchronize_rcu();
-
-	/*
-	 * Just being safe to make sure after previous flush if some body did
-	 * update limits through cgroup and another work got queued, cancel
-	 * it.
-	 */
-	throtl_shutdown_wq(q);
-
 	kfree(q->td);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 637cd76..cc8e9ef 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3449,7 +3449,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 {
 	struct cfq_data *cfqd = e->elevator_data;
 	struct request_queue *q = cfqd->queue;
-	bool wait = false;
 
 	cfq_shutdown_timer_wq(cfqd);
 
@@ -3462,31 +3461,8 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	spin_unlock_irq(q->queue_lock);
 
-#ifdef CONFIG_BLK_CGROUP
-	/*
-	 * If there are groups which we could not unlink from blkcg list,
-	 * wait for a rcu period for them to be freed.
-	 */
-	spin_lock_irq(q->queue_lock);
-	wait = q->nr_blkgs;
-	spin_unlock_irq(q->queue_lock);
-#endif
 	cfq_shutdown_timer_wq(cfqd);
 
-	/*
-	 * Wait for cfqg->blkg->key accessors to exit their grace periods.
-	 * Do this wait only if there are other unlinked groups out
-	 * there. This can happen if cgroup deletion path claimed the
-	 * responsibility of cleaning up a group before queue cleanup code
-	 * get to the group.
-	 *
-	 * Do not call synchronize_rcu() unconditionally as there are drivers
-	 * which create/delete request queue hundreds of times during scan/boot
-	 * and synchronize_rcu() can take significant time and slow down boot.
-	 */
-	if (wait)
-		synchronize_rcu();
-
 #ifndef CONFIG_CFQ_GROUP_IOSCHED
 	kfree(cfqd->root_group);
 #endif
@@ -3511,7 +3487,6 @@ static int cfq_init_queue(struct request_queue *q)
 
 	/* Init root group and prefer root group over other groups by default */
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
 
 	blkg = blkg_lookup_create(&blkio_root_cgroup, q, BLKIO_POLICY_PROP,
@@ -3520,7 +3495,6 @@ static int cfq_init_queue(struct request_queue *q)
 		cfqd->root_group = blkg_to_cfqg(blkg);
 
 	spin_unlock_irq(q->queue_lock);
-	rcu_read_unlock();
 #else
 	cfqd->root_group = kzalloc_node(sizeof(*cfqd->root_group),
 					GFP_KERNEL, cfqd->queue->node);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b4d1d4b..33f1b29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -365,7 +365,6 @@ struct request_queue {
 #ifdef CONFIG_BLK_CGROUP
 	/* XXX: array size hardcoded to avoid include dependency (temporary) */
 	struct list_head	blkg_list;
-	int			nr_blkgs;
 #endif
 
 	struct queue_limits	limits;
-- 
1.7.7.3

