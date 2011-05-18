Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1ERTP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637Ab1ERTN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:13:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 06/14] blk-cgroup: Allow sleeping while dynamically allocating a group
Date: Wed, 18 May 2011 15:13:18 -0400
Message-Id: <1305746006-5837-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all the cfq_group or throtl_group allocations happen while
we are holding ->queue_lock and sleeping is not allowed.

Soon, we will move to per cpu stats and also need to allocate the
per group stats. As one can not call alloc_percpu() from atomic
context as it can sleep, we need to drop ->queue_lock, allocate the
group, retake the lock and continue processing.

In throttling code, I check the queue DEAD flag again to make sure
that driver did not call blk_cleanup_queue() in the mean time.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |    3 +-
 block/blk-throttle.c |  141 ++++++++++++++++++++++++++++++++++++++------------
 block/cfq-iosched.c  |  128 +++++++++++++++++++++++++++++++++------------
 3 files changed, 205 insertions(+), 67 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a2e58ee..c95b3d2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1548,7 +1548,8 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 		}
 
-		blk_throtl_bio(q, &bio);
+		if (blk_throtl_bio(q, &bio))
+			goto end_io;
 
 		/*
 		 * If bio = NULL, bio has been throttled and will be submitted
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index fa9a900..c201967 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -188,8 +188,40 @@ throtl_add_group_to_td_list(struct throtl_data *td, struct throtl_grp *tg)
 	td->nr_undestroyed_grps++;
 }
 
-static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
-			struct blkio_cgroup *blkcg)
+static void throtl_init_add_tg_lists(struct throtl_data *td,
+			struct throtl_grp *tg, struct blkio_cgroup *blkcg)
+{
+	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
+	unsigned int major, minor;
+
+	/* Add group onto cgroup list */
+	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+	blkiocg_add_blkio_group(blkcg, &tg->blkg, (void *)td,
+				MKDEV(major, minor), BLKIO_POLICY_THROTL);
+
+	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
+	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
+	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
+	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
+
+	throtl_add_group_to_td_list(td, tg);
+}
+
+/* Should be called without queue lock and outside of rcu period */
+static struct throtl_grp *throtl_alloc_tg(struct throtl_data *td)
+{
+	struct throtl_grp *tg = NULL;
+
+	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, td->queue->node);
+	if (!tg)
+		return NULL;
+
+	throtl_init_group(tg);
+	return tg;
+}
+
+static struct
+throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 {
 	struct throtl_grp *tg = NULL;
 	void *key = td;
@@ -197,12 +229,6 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	unsigned int major, minor;
 
 	/*
-	 * TODO: Speed up blkiocg_lookup_group() by maintaining a radix
-	 * tree of blkg (instead of traversing through hash list all
-	 * the time.
-	 */
-
-	/*
 	 * This is the common case when there are no blkio cgroups.
  	 * Avoid lookup in this case
  	 */
@@ -215,43 +241,83 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	if (tg && !tg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
 		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 		tg->blkg.dev = MKDEV(major, minor);
-		goto done;
 	}
 
-	if (tg)
-		goto done;
-
-	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, td->queue->node);
-	if (!tg)
-		goto done;
-
-	throtl_init_group(tg);
-
-	/* Add group onto cgroup list */
-	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-	blkiocg_add_blkio_group(blkcg, &tg->blkg, (void *)td,
-				MKDEV(major, minor), BLKIO_POLICY_THROTL);
-
-	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
-	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
-	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
-	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
-
-	throtl_add_group_to_td_list(td, tg);
-done:
 	return tg;
 }
 
+/*
+ * This function returns with queue lock unlocked in case of error, like
+ * request queue is no more
+ */
 static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 {
-	struct throtl_grp *tg = NULL;
+	struct throtl_grp *tg = NULL, *__tg = NULL;
 	struct blkio_cgroup *blkcg;
+	struct request_queue *q = td->queue;
 
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
-	tg = throtl_find_alloc_tg(td, blkcg);
-	if (!tg)
+	tg = throtl_find_tg(td, blkcg);
+	if (tg) {
+		rcu_read_unlock();
+		return tg;
+	}
+
+	/*
+	 * Need to allocate a group. Allocation of group also needs allocation
+	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
+	 * we need to drop rcu lock and queue_lock before we call alloc
+	 *
+	 * Take the request queue reference to make sure queue does not
+	 * go away once we return from allocation.
+	 */
+	blk_get_queue(q);
+	rcu_read_unlock();
+	spin_unlock_irq(q->queue_lock);
+
+	tg = throtl_alloc_tg(td);
+	/*
+	 * We might have slept in group allocation. Make sure queue is not
+	 * dead
+	 */
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		blk_put_queue(q);
+		if (tg)
+			kfree(tg);
+
+		return ERR_PTR(-ENODEV);
+	}
+	blk_put_queue(q);
+
+	/* Group allocated and queue is still alive. take the lock */
+	spin_lock_irq(q->queue_lock);
+
+	/*
+	 * Initialize the new group. After sleeping, read the blkcg again.
+	 */
+	rcu_read_lock();
+	blkcg = task_blkio_cgroup(current);
+
+	/*
+	 * If some other thread already allocated the group while we were
+	 * not holding queue lock, free up the group
+	 */
+	__tg = throtl_find_tg(td, blkcg);
+
+	if (__tg) {
+		kfree(tg);
+		rcu_read_unlock();
+		return __tg;
+	}
+
+	/* Group allocation failed. Account the IO to root group */
+	if (!tg) {
 		tg = &td->root_tg;
+		return tg;
+	}
+
+	throtl_init_add_tg_lists(td, tg, blkcg);
 	rcu_read_unlock();
 	return tg;
 }
@@ -1014,6 +1080,15 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	spin_lock_irq(q->queue_lock);
 	tg = throtl_get_tg(td);
 
+	if (IS_ERR(tg)) {
+		if (PTR_ERR(tg)	== -ENODEV) {
+			/*
+			 * Queue is gone. No queue lock held here.
+			 */
+			return -ENODEV;
+		}
+	}
+
 	if (tg->nr_queued[rw]) {
 		/*
 		 * There is already another bio queued in same dir. No
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e2e6719..606020f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1016,28 +1016,47 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg->needs_update = true;
 }
 
-static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
-		struct blkio_cgroup *blkcg)
+static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
+			struct cfq_group *cfqg, struct blkio_cgroup *blkcg)
 {
-	struct cfq_group *cfqg = NULL;
-	void *key = cfqd;
-	int i, j;
-	struct cfq_rb_root *st;
 	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	unsigned int major, minor;
 
-	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
-	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+	/*
+	 * Add group onto cgroup list. It might happen that bdi->dev is
+	 * not initialized yet. Initialize this new group without major
+	 * and minor info and this info will be filled in once a new thread
+	 * comes for IO.
+	 */
+	if (bdi->dev) {
 		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfqg->blkg.dev = MKDEV(major, minor);
-		goto done;
-	}
-	if (cfqg)
-		goto done;
+		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg,
+					(void *)cfqd, MKDEV(major, minor));
+	} else
+		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg,
+					(void *)cfqd, 0);
+
+	cfqd->nr_blkcg_linked_grps++;
+	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+
+	/* Add group on cfqd list */
+	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+}
+
+/*
+ * Should be called from sleepable context. No request queue lock as per
+ * cpu stats are allocated dynamically and alloc_percpu needs to be called
+ * from sleepable context.
+ */
+static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
+{
+	struct cfq_group *cfqg = NULL;
+	int i, j;
+	struct cfq_rb_root *st;
 
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
 	if (!cfqg)
-		goto done;
+		return NULL;
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
@@ -1050,28 +1069,31 @@ static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
 	 * or cgroup deletion path depending on who is exiting first.
 	 */
 	cfqg->ref = 1;
+	return cfqg;
+}
+
+static struct cfq_group *
+cfq_find_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg)
+{
+	struct cfq_group *cfqg = NULL;
+	void *key = cfqd;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	unsigned int major, minor;
 
 	/*
-	 * Add group onto cgroup list. It might happen that bdi->dev is
-	 * not initialized yet. Initialize this new group without major
-	 * and minor info and this info will be filled in once a new thread
-	 * comes for IO. See code above.
+	 * This is the common case when there are no blkio cgroups.
+	 * Avoid lookup in this case
 	 */
-	if (bdi->dev) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
-					MKDEV(major, minor));
-	} else
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
-					0);
-
-	cfqd->nr_blkcg_linked_grps++;
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	if (blkcg == &blkio_root_cgroup)
+		cfqg = &cfqd->root_group;
+	else
+		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
 
-	/* Add group on cfqd list */
-	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfqg->blkg.dev = MKDEV(major, minor);
+	}
 
-done:
 	return cfqg;
 }
 
@@ -1082,13 +1104,53 @@ done:
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
 	struct blkio_cgroup *blkcg;
-	struct cfq_group *cfqg = NULL;
+	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
+	struct request_queue *q = cfqd->queue;
+
+	rcu_read_lock();
+	blkcg = task_blkio_cgroup(current);
+	cfqg = cfq_find_cfqg(cfqd, blkcg);
+	if (cfqg) {
+		rcu_read_unlock();
+		return cfqg;
+	}
+
+	/*
+	 * Need to allocate a group. Allocation of group also needs allocation
+	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
+	 * we need to drop rcu lock and queue_lock before we call alloc.
+	 *
+	 * Not taking any queue reference here and assuming that queue is
+	 * around by the time we return. CFQ queue allocation code does
+	 * the same. It might be racy though.
+	 */
+
+	rcu_read_unlock();
+	spin_unlock_irq(q->queue_lock);
+
+	cfqg = cfq_alloc_cfqg(cfqd);
+
+	spin_lock_irq(q->queue_lock);
 
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
-	cfqg = cfq_find_alloc_cfqg(cfqd, blkcg);
+
+	/*
+	 * If some other thread already allocated the group while we were
+	 * not holding queue lock, free up the group
+	 */
+	__cfqg = cfq_find_cfqg(cfqd, blkcg);
+
+	if (__cfqg) {
+		kfree(cfqg);
+		rcu_read_unlock();
+		return __cfqg;
+	}
+
 	if (!cfqg)
 		cfqg = &cfqd->root_group;
+
+	cfq_init_add_cfqg_lists(cfqd, cfqg, blkcg);
 	rcu_read_unlock();
 	return cfqg;
 }
-- 
1.7.1

