Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0I1RLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:11:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab0I1RLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:11:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 4/4] blkio: Recalculate the throttled bio dispatch time upon throttle limit change
Date: Tue, 28 Sep 2010 13:10:59 -0400
Message-Id: <1285693859-13591-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
References: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently any cgroup throttle limit changes are processed asynchronousy and
  the change does not take affect till a new bio is dispatched from same group.

o It might happen that a user sets a redicuously low limit on throttling.
  Say 1 bytes per second on reads. In such cases simple operations like mount
  a disk can wait for a very long time.

o Once bio is throttled, there is no easy way to come out of that wait even if
  user increases the read limit later.

o This patch fixes it. Now if a user changes the cgroup limits, we recalculate
  the bio dispatch time according to new limits.

o Can't take queueu lock under blkcg_lock, hence after the change I wake
  up the dispatch thread again which recalculates the time. So there are some
  variables being synchronized across two threads without lock and I had to
  make use of barriers. Hoping I have used barriers correctly. Any review of
  memory barrier code especially will help.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   15 ++++--
 block/blk-cgroup.h   |   21 ++++----
 block/blk-throttle.c |  134 +++++++++++++++++++++++++++++++++++++++++++-------
 block/cfq-iosched.c  |    4 +-
 4 files changed, 139 insertions(+), 35 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 357f472..e863418 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -124,7 +124,8 @@ blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
 		if (blkiop->plid != blkg->plid)
 			continue;
 		if (blkiop->ops.blkio_update_group_weight_fn)
-			blkiop->ops.blkio_update_group_weight_fn(blkg, weight);
+			blkiop->ops.blkio_update_group_weight_fn(blkg->key,
+							blkg, weight);
 	}
 }
 
@@ -141,11 +142,13 @@ static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
 
 		if (fileid == BLKIO_THROTL_read_bps_device
 		    && blkiop->ops.blkio_update_group_read_bps_fn)
-			blkiop->ops.blkio_update_group_read_bps_fn(blkg, bps);
+			blkiop->ops.blkio_update_group_read_bps_fn(blkg->key,
+								blkg, bps);
 
 		if (fileid == BLKIO_THROTL_write_bps_device
 		    && blkiop->ops.blkio_update_group_write_bps_fn)
-			blkiop->ops.blkio_update_group_write_bps_fn(blkg, bps);
+			blkiop->ops.blkio_update_group_write_bps_fn(blkg->key,
+								blkg, bps);
 	}
 }
 
@@ -162,11 +165,13 @@ static inline void blkio_update_group_iops(struct blkio_group *blkg,
 
 		if (fileid == BLKIO_THROTL_read_iops_device
 		    && blkiop->ops.blkio_update_group_read_iops_fn)
-			blkiop->ops.blkio_update_group_read_iops_fn(blkg, iops);
+			blkiop->ops.blkio_update_group_read_iops_fn(blkg->key,
+								blkg, iops);
 
 		if (fileid == BLKIO_THROTL_write_iops_device
 		    && blkiop->ops.blkio_update_group_write_iops_fn)
-			blkiop->ops.blkio_update_group_write_iops_fn(blkg,iops);
+			blkiop->ops.blkio_update_group_write_iops_fn(blkg->key,
+								blkg,iops);
 	}
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2070053..034c355 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -186,16 +186,17 @@ extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
-typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
-						unsigned int weight);
-typedef void (blkio_update_group_read_bps_fn) (struct blkio_group *blkg,
-						u64 read_bps);
-typedef void (blkio_update_group_write_bps_fn) (struct blkio_group *blkg,
-						u64 write_bps);
-typedef void (blkio_update_group_read_iops_fn) (struct blkio_group *blkg,
-						unsigned int read_iops);
-typedef void (blkio_update_group_write_iops_fn) (struct blkio_group *blkg,
-						unsigned int write_iops);
+
+typedef void (blkio_update_group_weight_fn) (void *key,
+			struct blkio_group *blkg, unsigned int weight);
+typedef void (blkio_update_group_read_bps_fn) (void * key,
+			struct blkio_group *blkg, u64 read_bps);
+typedef void (blkio_update_group_write_bps_fn) (void *key,
+			struct blkio_group *blkg, u64 write_bps);
+typedef void (blkio_update_group_read_iops_fn) (void *key,
+			struct blkio_group *blkg, unsigned int read_iops);
+typedef void (blkio_update_group_write_iops_fn) (void *key,
+			struct blkio_group *blkg, unsigned int write_iops);
 
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index bc2936b..11713ed 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -70,6 +70,9 @@ struct throtl_grp {
 	/* When did we start a new slice */
 	unsigned long slice_start[2];
 	unsigned long slice_end[2];
+
+	/* Some throttle limits got updated for the group */
+	bool limits_changed;
 };
 
 struct throtl_data
@@ -93,6 +96,8 @@ struct throtl_data
 
 	/* Work for dispatching throttled bios */
 	struct delayed_work throtl_work;
+
+	atomic_t limits_changed;
 };
 
 enum tg_state_flags {
@@ -592,15 +597,6 @@ static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
 	min_wait = min(read_wait, write_wait);
 	disptime = jiffies + min_wait;
 
-	/*
-	 * If group is already on active tree, then update dispatch time
-	 * only if it is lesser than existing dispatch time. Otherwise
-	 * always update the dispatch time
-	 */
-
-	if (throtl_tg_on_rr(tg) && time_before(disptime, tg->disptime))
-		return;
-
 	/* Update dispatch time */
 	throtl_dequeue_tg(td, tg);
 	tg->disptime = disptime;
@@ -691,6 +687,46 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 	return nr_disp;
 }
 
+static void throtl_process_limit_change(struct throtl_data *td)
+{
+	struct throtl_grp *tg;
+	struct hlist_node *pos, *n;
+
+	/*
+	 * Make sure atomic_inc() effects from
+	 * throtl_update_blkio_group_read_bps(), group of functions are
+	 * visible.
+	 * Is this required or smp_mb__after_atomic_inc() was suffcient
+	 * after the atomic_inc().
+	 */
+	smp_rmb();
+	if (!atomic_read(&td->limits_changed))
+		return;
+
+	throtl_log(td, "limit changed =%d", atomic_read(&td->limits_changed));
+
+	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
+		/*
+		 * Do I need an smp_rmb() here to make sure tg->limits_changed
+		 * update is visible. I am relying on smp_rmb() at the
+		 * beginning of function and not putting a new one here.
+		 */
+
+		if (throtl_tg_on_rr(tg) && tg->limits_changed) {
+			throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
+				" riops=%u wiops=%u", tg->bps[READ],
+				tg->bps[WRITE], tg->iops[READ],
+				tg->iops[WRITE]);
+			tg_update_disptime(td, tg);
+			tg->limits_changed = false;
+		}
+	}
+
+	smp_mb__before_atomic_dec();
+	atomic_dec(&td->limits_changed);
+	smp_mb__after_atomic_dec();
+}
+
 /* Dispatch throttled bios. Should be called without queue lock held. */
 static int throtl_dispatch(struct request_queue *q)
 {
@@ -701,6 +737,8 @@ static int throtl_dispatch(struct request_queue *q)
 
 	spin_lock_irq(q->queue_lock);
 
+	throtl_process_limit_change(td);
+
 	if (!total_nr_queued(td))
 		goto out;
 
@@ -821,28 +859,74 @@ void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(td->queue->queue_lock, flags);
 }
 
-static void throtl_update_blkio_group_read_bps (struct blkio_group *blkg,
-			u64 read_bps)
+/*
+ * For all update functions, key should be a valid pointer because these
+ * update functions are called under blkcg_lock, that means, blkg is
+ * valid and in turn key is valid. queue exit path can not race becuase
+ * of blkcg_lock
+ *
+ * Can not take queue lock in update functions as queue lock under blkcg_lock
+ * is not allowed. Under other paths we take blkcg_lock under queue_lock.
+ */
+static void throtl_update_blkio_group_read_bps(void *key,
+				struct blkio_group *blkg, u64 read_bps)
 {
+	struct throtl_data *td = key;
+
 	tg_of_blkg(blkg)->bps[READ] = read_bps;
+	/* Make sure read_bps is updated before setting limits_changed */
+	smp_wmb();
+	tg_of_blkg(blkg)->limits_changed = true;
+
+	/* Make sure tg->limits_changed is updated before td->limits_changed */
+	smp_mb__before_atomic_inc();
+	atomic_inc(&td->limits_changed);
+	smp_mb__after_atomic_inc();
+
+	/* Schedule a work now to process the limit change */
+	throtl_schedule_delayed_work(td->queue, 0);
 }
 
-static void throtl_update_blkio_group_write_bps (struct blkio_group *blkg,
-			u64 write_bps)
+static void throtl_update_blkio_group_write_bps(void *key,
+				struct blkio_group *blkg, u64 write_bps)
 {
+	struct throtl_data *td = key;
+
 	tg_of_blkg(blkg)->bps[WRITE] = write_bps;
+	smp_wmb();
+	tg_of_blkg(blkg)->limits_changed = true;
+	smp_mb__before_atomic_inc();
+	atomic_inc(&td->limits_changed);
+	smp_mb__after_atomic_inc();
+	throtl_schedule_delayed_work(td->queue, 0);
 }
 
-static void throtl_update_blkio_group_read_iops (struct blkio_group *blkg,
-			unsigned int read_iops)
+static void throtl_update_blkio_group_read_iops(void *key,
+			struct blkio_group *blkg, unsigned int read_iops)
 {
+	struct throtl_data *td = key;
+
 	tg_of_blkg(blkg)->iops[READ] = read_iops;
+	smp_wmb();
+	tg_of_blkg(blkg)->limits_changed = true;
+	smp_mb__before_atomic_inc();
+	atomic_inc(&td->limits_changed);
+	smp_mb__after_atomic_inc();
+	throtl_schedule_delayed_work(td->queue, 0);
 }
 
-static void throtl_update_blkio_group_write_iops (struct blkio_group *blkg,
-			unsigned int write_iops)
+static void throtl_update_blkio_group_write_iops(void *key,
+			struct blkio_group *blkg, unsigned int write_iops)
 {
+	struct throtl_data *td = key;
+
 	tg_of_blkg(blkg)->iops[WRITE] = write_iops;
+	smp_wmb();
+	tg_of_blkg(blkg)->limits_changed = true;
+	smp_mb__before_atomic_inc();
+	atomic_inc(&td->limits_changed);
+	smp_mb__after_atomic_inc();
+	throtl_schedule_delayed_work(td->queue, 0);
 }
 
 void throtl_shutdown_timer_wq(struct request_queue *q)
@@ -886,8 +970,14 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 		/*
 		 * There is already another bio queued in same dir. No
 		 * need to update dispatch time.
+		 * Still update the disptime if rate limits on this group
+		 * were changed.
 		 */
-		update_disptime = false;
+		if (!tg->limits_changed)
+			update_disptime = false;
+		else
+			tg->limits_changed = false;
+
 		goto queue_bio;
 	}
 
@@ -929,6 +1019,7 @@ int blk_throtl_init(struct request_queue *q)
 
 	INIT_HLIST_HEAD(&td->tg_list);
 	td->tg_service_tree = THROTL_RB_ROOT;
+	atomic_set(&td->limits_changed, 0);
 
 	/* Init root group */
 	tg = &td->root_tg;
@@ -996,6 +1087,13 @@ void blk_throtl_exit(struct request_queue *q)
 	 */
 	if (wait)
 		synchronize_rcu();
+
+	/*
+	 * Just being safe to make sure after previous flush if some body did
+	 * update limits through cgroup and another work got queued, cancel
+	 * it.
+	 */
+	throtl_shutdown_timer_wq(q);
 	throtl_td_free(td);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6db8884..ee9cd3a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -976,8 +976,8 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
-void
-cfq_update_blkio_group_weight(struct blkio_group *blkg, unsigned int weight)
+void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
+					unsigned int weight)
 {
 	cfqg_of_blkg(blkg)->weight = weight;
 }
-- 
1.7.2.3

