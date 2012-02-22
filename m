Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2BVBub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:50:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2BVBsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:48:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.134.228 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/36] blkcg: drop unnecessary RCU locking
Date: Tue, 21 Feb 2012 17:46:56 -0800
Message-Id: <1329875223-5102-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that blkg additions / removals are always done under both q and
blkcg locks, the only places RCU locking is necessary are
blkg_lookup[_create]() for lookup w/o blkcg lock.  This patch drops
unncessary RCU locking replacing it with plain blkcg locking as
necessary.

* blkiocg_pre_destroy() already perform proper locking and don't need
  RCU.  Dropped.

* blkio_read_blkg_stats() now uses blkcg->lock instead of RCU read
  lock.  This isn't a hot path.

* Now unnecessary synchronize_rcu() from queue exit paths removed.
  This makes q->nr_blkgs unnecessary.  Dropped.

* RCU annotation on blkg->q removed.

-v2: Vivek pointed out that blkg_lookup_create() still needs to be
     called under rcu_read_lock().  Updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c     |   20 +++++++-------------
 block/blk-cgroup.h     |    4 ++--
 block/blk-throttle.c   |   33 +--------------------------------
 block/cfq-iosched.c    |   24 ------------------------
 include/linux/blkdev.h |    1 -
 5 files changed, 10 insertions(+), 72 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index aee71ef..5cabdb8 100644
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
@@ -611,7 +611,6 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	list_add(&blkg->q_node, &q->blkg_list);
-	q->nr_blkgs++;
 
 	spin_unlock(&blkcg->lock);
 out:
@@ -648,9 +647,6 @@ static void blkg_destroy(struct blkio_group *blkg)
 	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
-	WARN_ON_ONCE(q->nr_blkgs <= 0);
-	q->nr_blkgs--;
-
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
@@ -1224,8 +1220,9 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 	struct hlist_node *n;
 	uint64_t cgroup_total = 0;
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
+	spin_lock_irq(&blkcg->lock);
+
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 		int plid = BLKIOFILE_POLICY(cft->private);
 
@@ -1241,7 +1238,8 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 	}
 	if (show_total)
 		cb->fill(cb, "Total", cgroup_total);
-	rcu_read_unlock();
+
+	spin_unlock_irq(&blkcg->lock);
 	return 0;
 }
 
@@ -1573,28 +1571,24 @@ static int blkiocg_pre_destroy(struct cgroup_subsys *subsys,
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
index e35ee7a..bfa5168 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1046,39 +1046,8 @@ int blk_throtl_init(struct request_queue *q)
 
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
index 354a6eb..42fa071 100644
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

