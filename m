Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2BVBsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:48:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2BVBsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:48:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.189.106 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/36] blkcg: let blkcg core manage per-queue blkg list and counter
Date: Tue, 21 Feb 2012 17:46:53 -0800
Message-Id: <1329875223-5102-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous patch to move blkg list heads and counters to
request_queue and blkg, logic to manage them in both policies are
almost identical and can be moved to blkcg core.

This patch moves blkg link logic into blkg_lookup_create(), implements
common blkg unlink code in blkg_destroy(), and updates
blkg_destory_all() so that it's policy specific and can skip root
group.  The updated blkg_destroy_all() is now used to both clear queue
for bypassing and elv switching, and release all blkgs on q exit.

This patch introduces a race window where policy [de]registration may
race against queue blkg clearing.  This can only be a problem on cfq
unload and shouldn't be a real problem in practice (and we have many
other places where this race already exists).  Future patches will
remove these unlikely races.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c     |   72 +++++++++++++++++++++++++++--------
 block/blk-cgroup.h     |   15 ++-----
 block/blk-throttle.c   |   99 +----------------------------------------------
 block/cfq-iosched.c    |  100 +++---------------------------------------------
 block/elevator.c       |    5 +-
 include/linux/blkdev.h |    4 +-
 6 files changed, 74 insertions(+), 221 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 634bfdf..d06178c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -596,8 +596,11 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 	/* insert */
 	spin_lock(&blkcg->lock);
 	swap(blkg, new_blkg);
+
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
-	pol->ops.blkio_link_group_fn(q, blkg);
+	list_add(&blkg->q_node[plid], &q->blkg_list[plid]);
+	q->nr_blkgs[plid]++;
+
 	spin_unlock(&blkcg->lock);
 out:
 	blkg_free(new_blkg);
@@ -646,36 +649,69 @@ struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 }
 EXPORT_SYMBOL_GPL(blkg_lookup);
 
-void blkg_destroy_all(struct request_queue *q)
+static void blkg_destroy(struct blkio_group *blkg, enum blkio_policy_id plid)
+{
+	struct request_queue *q = blkg->q;
+
+	lockdep_assert_held(q->queue_lock);
+
+	/* Something wrong if we are trying to remove same group twice */
+	WARN_ON_ONCE(list_empty(&blkg->q_node[plid]));
+	list_del_init(&blkg->q_node[plid]);
+
+	WARN_ON_ONCE(q->nr_blkgs[plid] <= 0);
+	q->nr_blkgs[plid]--;
+
+	/*
+	 * Put the reference taken at the time of creation so that when all
+	 * queues are gone, group can be destroyed.
+	 */
+	blkg_put(blkg);
+}
+
+void blkg_destroy_all(struct request_queue *q, enum blkio_policy_id plid,
+		      bool destroy_root)
 {
-	struct blkio_policy_type *pol;
+	struct blkio_group *blkg, *n;
 
 	while (true) {
 		bool done = true;
 
-		spin_lock(&blkio_list_lock);
 		spin_lock_irq(q->queue_lock);
 
-		/*
-		 * clear_queue_fn() might return with non-empty group list
-		 * if it raced cgroup removal and lost.  cgroup removal is
-		 * guaranteed to make forward progress and retrying after a
-		 * while is enough.  This ugliness is scheduled to be
-		 * removed after locking update.
-		 */
-		list_for_each_entry(pol, &blkio_list, list)
-			if (!pol->ops.blkio_clear_queue_fn(q))
+		list_for_each_entry_safe(blkg, n, &q->blkg_list[plid],
+					 q_node[plid]) {
+			/* skip root? */
+			if (!destroy_root && blkg->blkcg == &blkio_root_cgroup)
+				continue;
+
+			/*
+			 * If cgroup removal path got to blk_group first
+			 * and removed it from cgroup list, then it will
+			 * take care of destroying cfqg also.
+			 */
+			if (!blkiocg_del_blkio_group(blkg))
+				blkg_destroy(blkg, plid);
+			else
 				done = false;
+		}
 
 		spin_unlock_irq(q->queue_lock);
-		spin_unlock(&blkio_list_lock);
 
+		/*
+		 * Group list may not be empty if we raced cgroup removal
+		 * and lost.  cgroup removal is guaranteed to make forward
+		 * progress and retrying after a while is enough.  This
+		 * ugliness is scheduled to be removed after locking
+		 * update.
+		 */
 		if (done)
 			break;
 
 		msleep(10);	/* just some random duration I like */
 	}
 }
+EXPORT_SYMBOL_GPL(blkg_destroy_all);
 
 static void blkg_rcu_free(struct rcu_head *rcu_head)
 {
@@ -1538,11 +1574,13 @@ static int blkiocg_pre_destroy(struct cgroup_subsys *subsys,
 		 * this event.
 		 */
 		spin_lock(&blkio_list_lock);
+		spin_lock_irqsave(q->queue_lock, flags);
 		list_for_each_entry(blkiop, &blkio_list, list) {
 			if (blkiop->plid != blkg->plid)
 				continue;
-			blkiop->ops.blkio_unlink_group_fn(q, blkg);
+			blkg_destroy(blkg, blkiop->plid);
 		}
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		spin_unlock(&blkio_list_lock);
 	} while (1);
 
@@ -1684,12 +1722,14 @@ static void blkcg_bypass_start(void)
 	__acquires(&all_q_mutex)
 {
 	struct request_queue *q;
+	int i;
 
 	mutex_lock(&all_q_mutex);
 
 	list_for_each_entry(q, &all_q_list, all_q_node) {
 		blk_queue_bypass_start(q);
-		blkg_destroy_all(q);
+		for (i = 0; i < BLKIO_NR_POLICIES; i++)
+			blkg_destroy_all(q, i, false);
 	}
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ae96f19..83ce5fa 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -196,11 +196,6 @@ struct blkio_group {
 };
 
 typedef void (blkio_init_group_fn)(struct blkio_group *blkg);
-typedef void (blkio_link_group_fn)(struct request_queue *q,
-			struct blkio_group *blkg);
-typedef void (blkio_unlink_group_fn)(struct request_queue *q,
-			struct blkio_group *blkg);
-typedef bool (blkio_clear_queue_fn)(struct request_queue *q);
 typedef void (blkio_update_group_weight_fn)(struct request_queue *q,
 			struct blkio_group *blkg, unsigned int weight);
 typedef void (blkio_update_group_read_bps_fn)(struct request_queue *q,
@@ -214,9 +209,6 @@ typedef void (blkio_update_group_write_iops_fn)(struct request_queue *q,
 
 struct blkio_policy_ops {
 	blkio_init_group_fn *blkio_init_group_fn;
-	blkio_link_group_fn *blkio_link_group_fn;
-	blkio_unlink_group_fn *blkio_unlink_group_fn;
-	blkio_clear_queue_fn *blkio_clear_queue_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
 	blkio_update_group_read_bps_fn *blkio_update_group_read_bps_fn;
 	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
@@ -238,7 +230,8 @@ extern void blkcg_exit_queue(struct request_queue *q);
 /* Blkio controller policy registration */
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
-extern void blkg_destroy_all(struct request_queue *q);
+extern void blkg_destroy_all(struct request_queue *q,
+			     enum blkio_policy_id plid, bool destroy_root);
 
 /**
  * blkg_to_pdata - get policy private data
@@ -319,7 +312,9 @@ static inline void blkcg_drain_queue(struct request_queue *q) { }
 static inline void blkcg_exit_queue(struct request_queue *q) { }
 static inline void blkio_policy_register(struct blkio_policy_type *blkiop) { }
 static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
-static inline void blkg_destroy_all(struct request_queue *q) { }
+static inline void blkg_destroy_all(struct request_queue *q,
+				    enum blkio_policy_id plid,
+				    bool destory_root) { }
 
 static inline void *blkg_to_pdata(struct blkio_group *blkg,
 				struct blkio_policy_type *pol) { return NULL; }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c15d383..1329412 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -157,14 +157,6 @@ static void throtl_init_blkio_group(struct blkio_group *blkg)
 	tg->iops[WRITE] = -1;
 }
 
-static void throtl_link_blkio_group(struct request_queue *q,
-				    struct blkio_group *blkg)
-{
-	list_add(&blkg->q_node[BLKIO_POLICY_THROTL],
-		 &q->blkg_list[BLKIO_POLICY_THROTL]);
-	q->nr_blkgs[BLKIO_POLICY_THROTL]++;
-}
-
 static struct
 throtl_grp *throtl_lookup_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 {
@@ -813,89 +805,6 @@ throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 	}
 }
 
-static void
-throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
-{
-	struct blkio_group *blkg = tg_to_blkg(tg);
-
-	/* Something wrong if we are trying to remove same group twice */
-	WARN_ON_ONCE(list_empty(&blkg->q_node[BLKIO_POLICY_THROTL]));
-
-	list_del_init(&blkg->q_node[BLKIO_POLICY_THROTL]);
-
-	/*
-	 * Put the reference taken at the time of creation so that when all
-	 * queues are gone, group can be destroyed.
-	 */
-	blkg_put(tg_to_blkg(tg));
-	td->queue->nr_blkgs[BLKIO_POLICY_THROTL]--;
-}
-
-static bool throtl_release_tgs(struct throtl_data *td, bool release_root)
-{
-	struct request_queue *q = td->queue;
-	struct blkio_group *blkg, *n;
-	bool empty = true;
-
-	list_for_each_entry_safe(blkg, n, &q->blkg_list[BLKIO_POLICY_THROTL],
-				 q_node[BLKIO_POLICY_THROTL]) {
-		struct throtl_grp *tg = blkg_to_tg(blkg);
-
-		/* skip root? */
-		if (!release_root && tg == td->root_tg)
-			continue;
-
-		/*
-		 * If cgroup removal path got to blk_group first and removed
-		 * it from cgroup list, then it will take care of destroying
-		 * cfqg also.
-		 */
-		if (!blkiocg_del_blkio_group(blkg))
-			throtl_destroy_tg(td, tg);
-		else
-			empty = false;
-	}
-	return empty;
-}
-
-/*
- * Blk cgroup controller notification saying that blkio_group object is being
- * delinked as associated cgroup object is going away. That also means that
- * no new IO will come in this group. So get rid of this group as soon as
- * any pending IO in the group is finished.
- *
- * This function is called under rcu_read_lock(). @q is the rcu protected
- * pointer. That means @q is a valid request_queue pointer as long as we
- * are rcu read lock.
- *
- * @q was fetched from blkio_group under blkio_cgroup->lock. That means
- * it should not be NULL as even if queue was going away, cgroup deltion
- * path got to it first.
- */
-void throtl_unlink_blkio_group(struct request_queue *q,
-			       struct blkio_group *blkg)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	throtl_destroy_tg(q->td, blkg_to_tg(blkg));
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-
-static bool throtl_clear_queue(struct request_queue *q)
-{
-	lockdep_assert_held(q->queue_lock);
-
-	/*
-	 * Clear tgs but leave the root one alone.  This is necessary
-	 * because root_tg is expected to be persistent and safe because
-	 * blk-throtl can never be disabled while @q is alive.  This is a
-	 * kludge to prepare for unified blkg.  This whole function will be
-	 * removed soon.
-	 */
-	return throtl_release_tgs(q->td, false);
-}
-
 static void throtl_update_blkio_group_common(struct throtl_data *td,
 				struct throtl_grp *tg)
 {
@@ -960,9 +869,6 @@ static void throtl_shutdown_wq(struct request_queue *q)
 static struct blkio_policy_type blkio_policy_throtl = {
 	.ops = {
 		.blkio_init_group_fn = throtl_init_blkio_group,
-		.blkio_link_group_fn = throtl_link_blkio_group,
-		.blkio_unlink_group_fn = throtl_unlink_blkio_group,
-		.blkio_clear_queue_fn = throtl_clear_queue,
 		.blkio_update_group_read_bps_fn =
 					throtl_update_blkio_group_read_bps,
 		.blkio_update_group_write_bps_fn =
@@ -1148,12 +1054,11 @@ void blk_throtl_exit(struct request_queue *q)
 
 	throtl_shutdown_wq(q);
 
-	spin_lock_irq(q->queue_lock);
-	throtl_release_tgs(td, true);
+	blkg_destroy_all(q, BLKIO_POLICY_THROTL, true);
 
 	/* If there are other groups */
+	spin_lock_irq(q->queue_lock);
 	wait = q->nr_blkgs[BLKIO_POLICY_THROTL];
-
 	spin_unlock_irq(q->queue_lock);
 
 	/*
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e846803..dc73690 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1045,14 +1045,6 @@ static void cfq_update_blkio_group_weight(struct request_queue *q,
 	cfqg->needs_update = true;
 }
 
-static void cfq_link_blkio_group(struct request_queue *q,
-				 struct blkio_group *blkg)
-{
-	list_add(&blkg->q_node[BLKIO_POLICY_PROP],
-		 &q->blkg_list[BLKIO_POLICY_PROP]);
-	q->nr_blkgs[BLKIO_POLICY_PROP]++;
-}
-
 static void cfq_init_blkio_group(struct blkio_group *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
@@ -1096,84 +1088,6 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 	blkg_get(cfqg_to_blkg(cfqg));
 }
 
-static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
-{
-	struct blkio_group *blkg = cfqg_to_blkg(cfqg);
-
-	/* Something wrong if we are trying to remove same group twice */
-	BUG_ON(list_empty(&blkg->q_node[BLKIO_POLICY_PROP]));
-
-	list_del_init(&blkg->q_node[BLKIO_POLICY_PROP]);
-
-	BUG_ON(cfqd->queue->nr_blkgs[BLKIO_POLICY_PROP] <= 0);
-	cfqd->queue->nr_blkgs[BLKIO_POLICY_PROP]--;
-
-	/*
-	 * Put the reference taken at the time of creation so that when all
-	 * queues are gone, group can be destroyed.
-	 */
-	blkg_put(cfqg_to_blkg(cfqg));
-}
-
-static bool cfq_release_cfq_groups(struct cfq_data *cfqd)
-{
-	struct request_queue *q = cfqd->queue;
-	struct blkio_group *blkg, *n;
-	bool empty = true;
-
-	list_for_each_entry_safe(blkg, n, &q->blkg_list[BLKIO_POLICY_PROP],
-				 q_node[BLKIO_POLICY_PROP]) {
-		/*
-		 * If cgroup removal path got to blk_group first and removed
-		 * it from cgroup list, then it will take care of destroying
-		 * cfqg also.
-		 */
-		if (!cfq_blkiocg_del_blkio_group(blkg))
-			cfq_destroy_cfqg(cfqd, blkg_to_cfqg(blkg));
-		else
-			empty = false;
-	}
-	return empty;
-}
-
-/*
- * Blk cgroup controller notification saying that blkio_group object is being
- * delinked as associated cgroup object is going away. That also means that
- * no new IO will come in this group. So get rid of this group as soon as
- * any pending IO in the group is finished.
- *
- * This function is called under rcu_read_lock(). key is the rcu protected
- * pointer. That means @q is a valid request_queue pointer as long as we
- * are rcu read lock.
- *
- * @q was fetched from blkio_group under blkio_cgroup->lock. That means
- * it should not be NULL as even if elevator was exiting, cgroup deltion
- * path got to it first.
- */
-static void cfq_unlink_blkio_group(struct request_queue *q,
-				   struct blkio_group *blkg)
-{
-	struct cfq_data *cfqd = q->elevator->elevator_data;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	cfq_destroy_cfqg(cfqd, blkg_to_cfqg(blkg));
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-
-static struct elevator_type iosched_cfq;
-
-static bool cfq_clear_queue(struct request_queue *q)
-{
-	lockdep_assert_held(q->queue_lock);
-
-	/* shoot down blkgs iff the current elevator is cfq */
-	if (!q->elevator || q->elevator->type != &iosched_cfq)
-		return true;
-
-	return cfq_release_cfq_groups(q->elevator->elevator_data);
-}
-
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
 						struct blkio_cgroup *blkcg)
@@ -1186,8 +1100,6 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 	cfqq->cfqg = cfqg;
 }
 
-static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
-
 #endif /* GROUP_IOSCHED */
 
 /*
@@ -3547,17 +3459,20 @@ static void cfq_exit_queue(struct elevator_queue *e)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
 	cfq_put_async_queues(cfqd);
-	cfq_release_cfq_groups(cfqd);
+
+	spin_unlock_irq(q->queue_lock);
+
+	blkg_destroy_all(q, BLKIO_POLICY_PROP, true);
 
 #ifdef CONFIG_BLK_CGROUP
 	/*
 	 * If there are groups which we could not unlink from blkcg list,
 	 * wait for a rcu period for them to be freed.
 	 */
+	spin_lock_irq(q->queue_lock);
 	wait = q->nr_blkgs[BLKIO_POLICY_PROP];
-#endif
 	spin_unlock_irq(q->queue_lock);
-
+#endif
 	cfq_shutdown_timer_wq(cfqd);
 
 	/*
@@ -3794,9 +3709,6 @@ static struct elevator_type iosched_cfq = {
 static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
 		.blkio_init_group_fn =		cfq_init_blkio_group,
-		.blkio_link_group_fn =		cfq_link_blkio_group,
-		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
-		.blkio_clear_queue_fn = cfq_clear_queue,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
 	},
 	.plid = BLKIO_POLICY_PROP,
diff --git a/block/elevator.c b/block/elevator.c
index 8c7561f..d4d39da 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -876,7 +876,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 {
 	struct elevator_queue *old = q->elevator;
 	bool registered = old->registered;
-	int err;
+	int i, err;
 
 	/*
 	 * Turn on BYPASS and drain all requests w/ elevator private data.
@@ -895,7 +895,8 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	ioc_clear_queue(q);
 	spin_unlock_irq(q->queue_lock);
 
-	blkg_destroy_all(q);
+	for (i = 0; i < BLKIO_NR_POLICIES; i++)
+		blkg_destroy_all(q, i, false);
 
 	/* allocate, init and register new elevator */
 	err = -ENOMEM;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f4e35ed..b4d1d4b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -364,8 +364,8 @@ struct request_queue {
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
 	/* XXX: array size hardcoded to avoid include dependency (temporary) */
-	struct list_head	blkg_list[2];
-	int			nr_blkgs[2];
+	struct list_head	blkg_list;
+	int			nr_blkgs;
 #endif
 
 	struct queue_limits	limits;
-- 
1.7.7.3

