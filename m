Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2BVBsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:48:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2BVBsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:48:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.134.228 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/36] blkcg: move per-queue blkg list heads and counters to queue and blkg
Date: Tue, 21 Feb 2012 17:46:52 -0800
Message-Id: <1329875223-5102-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, specific policy implementations are responsible for
maintaining list and number of blkgs.  This duplicates code
unnecessarily, and hinders factoring common code and providing blkcg
API with better defined semantics.

After this patch, request_queue hosts list heads and counters and blkg
has list nodes for both policies.  This patch only relocates the
necessary fields and the next patch will actually move management code
into blkcg core.

Note that request_queue->blkg_list[] and ->nr_blkgs[] are hardcoded to
have 2 elements.  This is to avoid include dependency and will be
removed by the next patch.

This patch doesn't introduce any behavior change.

-v2: Now unnecessary conditional on CONFIG_BLK_CGROUP_MODULE removed
     as pointed out by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c     |    2 +
 block/blk-cgroup.h     |    1 +
 block/blk-core.c       |    4 +++
 block/blk-throttle.c   |   49 ++++++++++++++++++++++-------------------------
 block/cfq-iosched.c    |   47 ++++++++++++++++++---------------------------
 include/linux/blkdev.h |    5 ++++
 6 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 83cb1cd..634bfdf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -499,6 +499,8 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 
 	spin_lock_init(&blkg->stats_lock);
 	rcu_assign_pointer(blkg->q, q);
+	INIT_LIST_HEAD(&blkg->q_node[0]);
+	INIT_LIST_HEAD(&blkg->q_node[1]);
 	blkg->blkcg = blkcg;
 	blkg->plid = pol->plid;
 	blkg->refcnt = 1;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 60e96b4..ae96f19 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -178,6 +178,7 @@ struct blkg_policy_data {
 struct blkio_group {
 	/* Pointer to the associated request_queue, RCU protected */
 	struct request_queue __rcu *q;
+	struct list_head q_node[BLKIO_NR_POLICIES];
 	struct hlist_node blkcg_node;
 	struct blkio_cgroup *blkcg;
 	/* Store cgroup path */
diff --git a/block/blk-core.c b/block/blk-core.c
index ad862dc..8f570aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -546,6 +546,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->icq_list);
+#ifdef CONFIG_BLK_CGROUP
+	INIT_LIST_HEAD(&q->blkg_list[0]);
+	INIT_LIST_HEAD(&q->blkg_list[1]);
+#endif
 	INIT_LIST_HEAD(&q->flush_queue[0]);
 	INIT_LIST_HEAD(&q->flush_queue[1]);
 	INIT_LIST_HEAD(&q->flush_data_in_flight);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b2fddaf..c15d383 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -41,9 +41,6 @@ struct throtl_rb_root {
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
 
 struct throtl_grp {
-	/* List of throtl groups on the request queue*/
-	struct hlist_node tg_node;
-
 	/* active throtl group service_tree member */
 	struct rb_node rb_node;
 
@@ -83,9 +80,6 @@ struct throtl_grp {
 
 struct throtl_data
 {
-	/* List of throtl groups */
-	struct hlist_head tg_list;
-
 	/* service tree for active throtl groups */
 	struct throtl_rb_root tg_service_tree;
 
@@ -152,7 +146,6 @@ static void throtl_init_blkio_group(struct blkio_group *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 
-	INIT_HLIST_NODE(&tg->tg_node);
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
@@ -167,11 +160,9 @@ static void throtl_init_blkio_group(struct blkio_group *blkg)
 static void throtl_link_blkio_group(struct request_queue *q,
 				    struct blkio_group *blkg)
 {
-	struct throtl_data *td = q->td;
-	struct throtl_grp *tg = blkg_to_tg(blkg);
-
-	hlist_add_head(&tg->tg_node, &td->tg_list);
-	td->nr_undestroyed_grps++;
+	list_add(&blkg->q_node[BLKIO_POLICY_THROTL],
+		 &q->blkg_list[BLKIO_POLICY_THROTL]);
+	q->nr_blkgs[BLKIO_POLICY_THROTL]++;
 }
 
 static struct
@@ -711,8 +702,8 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 
 static void throtl_process_limit_change(struct throtl_data *td)
 {
-	struct throtl_grp *tg;
-	struct hlist_node *pos, *n;
+	struct request_queue *q = td->queue;
+	struct blkio_group *blkg, *n;
 
 	if (!td->limits_changed)
 		return;
@@ -721,7 +712,10 @@ static void throtl_process_limit_change(struct throtl_data *td)
 
 	throtl_log(td, "limits changed");
 
-	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
+	list_for_each_entry_safe(blkg, n, &q->blkg_list[BLKIO_POLICY_THROTL],
+				 q_node[BLKIO_POLICY_THROTL]) {
+		struct throtl_grp *tg = blkg_to_tg(blkg);
+
 		if (!tg->limits_changed)
 			continue;
 
@@ -822,26 +816,31 @@ throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 static void
 throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
 {
+	struct blkio_group *blkg = tg_to_blkg(tg);
+
 	/* Something wrong if we are trying to remove same group twice */
-	BUG_ON(hlist_unhashed(&tg->tg_node));
+	WARN_ON_ONCE(list_empty(&blkg->q_node[BLKIO_POLICY_THROTL]));
 
-	hlist_del_init(&tg->tg_node);
+	list_del_init(&blkg->q_node[BLKIO_POLICY_THROTL]);
 
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
 	blkg_put(tg_to_blkg(tg));
-	td->nr_undestroyed_grps--;
+	td->queue->nr_blkgs[BLKIO_POLICY_THROTL]--;
 }
 
 static bool throtl_release_tgs(struct throtl_data *td, bool release_root)
 {
-	struct hlist_node *pos, *n;
-	struct throtl_grp *tg;
+	struct request_queue *q = td->queue;
+	struct blkio_group *blkg, *n;
 	bool empty = true;
 
-	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
+	list_for_each_entry_safe(blkg, n, &q->blkg_list[BLKIO_POLICY_THROTL],
+				 q_node[BLKIO_POLICY_THROTL]) {
+		struct throtl_grp *tg = blkg_to_tg(blkg);
+
 		/* skip root? */
 		if (!release_root && tg == td->root_tg)
 			continue;
@@ -851,7 +850,7 @@ static bool throtl_release_tgs(struct throtl_data *td, bool release_root)
 		 * it from cgroup list, then it will take care of destroying
 		 * cfqg also.
 		 */
-		if (!blkiocg_del_blkio_group(tg_to_blkg(tg)))
+		if (!blkiocg_del_blkio_group(blkg))
 			throtl_destroy_tg(td, tg);
 		else
 			empty = false;
@@ -1114,7 +1113,6 @@ int blk_throtl_init(struct request_queue *q)
 	if (!td)
 		return -ENOMEM;
 
-	INIT_HLIST_HEAD(&td->tg_list);
 	td->tg_service_tree = THROTL_RB_ROOT;
 	td->limits_changed = false;
 	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
@@ -1144,7 +1142,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	struct throtl_data *td = q->td;
-	bool wait = false;
+	bool wait;
 
 	BUG_ON(!td);
 
@@ -1154,8 +1152,7 @@ void blk_throtl_exit(struct request_queue *q)
 	throtl_release_tgs(td, true);
 
 	/* If there are other groups */
-	if (td->nr_undestroyed_grps > 0)
-		wait = true;
+	wait = q->nr_blkgs[BLKIO_POLICY_THROTL];
 
 	spin_unlock_irq(q->queue_lock);
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 11dd9d7..e846803 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -208,9 +208,7 @@ struct cfq_group {
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
 	enum wl_prio_t saved_serving_prio;
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
-	struct hlist_node cfqd_node;
-#endif
+
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 	struct cfq_ttime ttime;
@@ -302,12 +300,6 @@ struct cfq_data {
 	struct cfq_queue oom_cfqq;
 
 	unsigned long last_delayed_sync;
-
-	/* List of cfq groups being managed on this device*/
-	struct hlist_head cfqg_list;
-
-	/* Number of groups which are on blkcg->blkg_list */
-	unsigned int nr_blkcg_linked_grps;
 };
 
 static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg)
@@ -1056,13 +1048,9 @@ static void cfq_update_blkio_group_weight(struct request_queue *q,
 static void cfq_link_blkio_group(struct request_queue *q,
 				 struct blkio_group *blkg)
 {
-	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
-
-	cfqd->nr_blkcg_linked_grps++;
-
-	/* Add group on cfqd list */
-	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+	list_add(&blkg->q_node[BLKIO_POLICY_PROP],
+		 &q->blkg_list[BLKIO_POLICY_PROP]);
+	q->nr_blkgs[BLKIO_POLICY_PROP]++;
 }
 
 static void cfq_init_blkio_group(struct blkio_group *blkg)
@@ -1110,13 +1098,15 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 
 static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
+	struct blkio_group *blkg = cfqg_to_blkg(cfqg);
+
 	/* Something wrong if we are trying to remove same group twice */
-	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
+	BUG_ON(list_empty(&blkg->q_node[BLKIO_POLICY_PROP]));
 
-	hlist_del_init(&cfqg->cfqd_node);
+	list_del_init(&blkg->q_node[BLKIO_POLICY_PROP]);
 
-	BUG_ON(cfqd->nr_blkcg_linked_grps <= 0);
-	cfqd->nr_blkcg_linked_grps--;
+	BUG_ON(cfqd->queue->nr_blkgs[BLKIO_POLICY_PROP] <= 0);
+	cfqd->queue->nr_blkgs[BLKIO_POLICY_PROP]--;
 
 	/*
 	 * Put the reference taken at the time of creation so that when all
@@ -1127,18 +1117,19 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 static bool cfq_release_cfq_groups(struct cfq_data *cfqd)
 {
-	struct hlist_node *pos, *n;
-	struct cfq_group *cfqg;
+	struct request_queue *q = cfqd->queue;
+	struct blkio_group *blkg, *n;
 	bool empty = true;
 
-	hlist_for_each_entry_safe(cfqg, pos, n, &cfqd->cfqg_list, cfqd_node) {
+	list_for_each_entry_safe(blkg, n, &q->blkg_list[BLKIO_POLICY_PROP],
+				 q_node[BLKIO_POLICY_PROP]) {
 		/*
 		 * If cgroup removal path got to blk_group first and removed
 		 * it from cgroup list, then it will take care of destroying
 		 * cfqg also.
 		 */
-		if (!cfq_blkiocg_del_blkio_group(cfqg_to_blkg(cfqg)))
-			cfq_destroy_cfqg(cfqd, cfqg);
+		if (!cfq_blkiocg_del_blkio_group(blkg))
+			cfq_destroy_cfqg(cfqd, blkg_to_cfqg(blkg));
 		else
 			empty = false;
 	}
@@ -3558,13 +3549,13 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
 
+#ifdef CONFIG_BLK_CGROUP
 	/*
 	 * If there are groups which we could not unlink from blkcg list,
 	 * wait for a rcu period for them to be freed.
 	 */
-	if (cfqd->nr_blkcg_linked_grps)
-		wait = true;
-
+	wait = q->nr_blkgs[BLKIO_POLICY_PROP];
+#endif
 	spin_unlock_irq(q->queue_lock);
 
 	cfq_shutdown_timer_wq(cfqd);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e8c0bbd..f4e35ed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -362,6 +362,11 @@ struct request_queue {
 	struct list_head	timeout_list;
 
 	struct list_head	icq_list;
+#ifdef CONFIG_BLK_CGROUP
+	/* XXX: array size hardcoded to avoid include dependency (temporary) */
+	struct list_head	blkg_list[2];
+	int			nr_blkgs[2];
+#endif
 
 	struct queue_limits	limits;
 
-- 
1.7.7.3

