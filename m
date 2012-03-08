Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab2CHSzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:55:33 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48276 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757747Ab2CHSyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:54:09 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, dpshah@google.com,
        ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] blkcg: alloc per cpu stats from worker thread in a delayed manner
Date: Thu,  8 Mar 2012 10:53:56 -0800
Message-Id: <1331232840-16044-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331232840-16044-1-git-send-email-tj@kernel.org>
References: <1331232840-16044-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Current per cpu stat allocation assumes GFP_KERNEL allocation flag. But in
IO path there are times when we want GFP_NOIO semantics. As there is no
way to pass the allocation flags to alloc_percpu(), this patch delays the
allocation of stats using a worker thread.

v2-> tejun suggested following changes. Changed the patch accordingly.
	- move alloc_node location in structure
	- reduce the size of names of some of the fields
	- Reduce the scope of locking of alloc_list_lock
	- Simplified stat_alloc_fn() by allocating stats for all
	  policies in one go and then assigning these to a group.

v3 -> Andrew suggested to put some comments in the code. Also raised
      concerns about trying to allocate infinitely in case of allocation
      failure. I have changed the logic to sleep for 10ms before retrying.
      That should take care of non-preemptible UP kernels.

v4 -> Tejun had more suggestions.
	- drop list_for_each_entry_all()
	- instead of msleep() use queue_delayed_work()
	- Some cleanups realted to more compact coding.

v5-> tejun suggested more cleanups leading to more compact code.

tj: - Relocated pcpu_stats into blkio_stat_alloc_fn().
    - Minor comment update.
    - This also fixes suspicious RCU usage warning caused by invoking
      cgroup_path() from blkg_alloc() without holding RCU read lock.
      Now that blkg_alloc() doesn't require sleepable context, RCU
      read lock from blkg_lookup_create() is maintained throughout
      blkg_alloc().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |  129 ++++++++++++++++++++++++++++++++++++----------------
 block/blk-cgroup.h |    2 +
 2 files changed, 91 insertions(+), 40 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ee962f3..622fb41 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -30,6 +30,13 @@ static LIST_HEAD(blkio_list);
 static DEFINE_MUTEX(all_q_mutex);
 static LIST_HEAD(all_q_list);
 
+/* List of groups pending per cpu stats allocation */
+static DEFINE_SPINLOCK(alloc_list_lock);
+static LIST_HEAD(alloc_list);
+
+static void blkio_stat_alloc_fn(struct work_struct *);
+static DECLARE_DELAYED_WORK(blkio_stat_alloc_work, blkio_stat_alloc_fn);
+
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
@@ -391,6 +398,10 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	/* If per cpu stats are not allocated yet, don't do any accounting. */
+	if (pd->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -443,6 +454,10 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	/* If per cpu stats are not allocated yet, don't do any accounting. */
+	if (pd->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -460,6 +475,60 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
+/*
+ * Worker for allocating per cpu stat for blk groups. This is scheduled on
+ * the system_nrt_wq once there are some groups on the alloc_list waiting
+ * for allocation.
+ */
+static void blkio_stat_alloc_fn(struct work_struct *work)
+{
+	static void *pcpu_stats[BLKIO_NR_POLICIES];
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct blkio_group *blkg;
+	int i;
+	bool empty = false;
+
+alloc_stats:
+	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+		if (pcpu_stats[i] != NULL)
+			continue;
+
+		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
+
+		/* Allocation failed. Try again after some time. */
+		if (pcpu_stats[i] == NULL) {
+			queue_delayed_work(system_nrt_wq, dwork,
+						msecs_to_jiffies(10));
+			return;
+		}
+	}
+
+	spin_lock_irq(&blkio_list_lock);
+	spin_lock(&alloc_list_lock);
+
+	/* cgroup got deleted or queue exited. */
+	if (!list_empty(&alloc_list)) {
+		blkg = list_first_entry(&alloc_list, struct blkio_group,
+						alloc_node);
+		for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+			struct blkg_policy_data *pd = blkg->pd[i];
+
+			if (blkio_policy[i] && pd && !pd->stats_cpu)
+				swap(pd->stats_cpu, pcpu_stats[i]);
+		}
+
+		list_del_init(&blkg->alloc_node);
+	}
+
+	empty = list_empty(&alloc_list);
+
+	spin_unlock(&alloc_list_lock);
+	spin_unlock_irq(&blkio_list_lock);
+
+	if (!empty)
+		goto alloc_stats;
+}
+
 /**
  * blkg_free - free a blkg
  * @blkg: blkg to free
@@ -491,9 +560,6 @@ static void blkg_free(struct blkio_group *blkg)
  * @q: request_queue the new blkg is associated with
  *
  * Allocate a new blkg assocating @blkcg and @q.
- *
- * FIXME: Should be called with queue locked but currently isn't due to
- *        percpu stat breakage.
  */
 static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 				      struct request_queue *q)
@@ -509,6 +575,7 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 	spin_lock_init(&blkg->stats_lock);
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
+	INIT_LIST_HEAD(&blkg->alloc_node);
 	blkg->blkcg = blkcg;
 	blkg->refcnt = 1;
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
@@ -530,13 +597,6 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
-
-		/* broken, read comment in the callsite */
-		pd->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
-		if (!pd->stats_cpu) {
-			blkg_free(blkg);
-			return NULL;
-		}
 	}
 
 	/* invoke per-policy init */
@@ -556,7 +616,7 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 				       bool for_root)
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
-	struct blkio_group *blkg, *new_blkg;
+	struct blkio_group *blkg;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
@@ -580,48 +640,27 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 
 	/*
 	 * Allocate and initialize.
-	 *
-	 * FIXME: The following is broken.  Percpu memory allocation
-	 * requires %GFP_KERNEL context and can't be performed from IO
-	 * path.  Allocation here should inherently be atomic and the
-	 * following lock dancing can be removed once the broken percpu
-	 * allocation is fixed.
 	 */
-	spin_unlock_irq(q->queue_lock);
-	rcu_read_unlock();
-
-	new_blkg = blkg_alloc(blkcg, q);
-
-	rcu_read_lock();
-	spin_lock_irq(q->queue_lock);
-
-	/* did bypass get turned on inbetween? */
-	if (unlikely(blk_queue_bypass(q)) && !for_root) {
-		blkg = ERR_PTR(blk_queue_dead(q) ? -EINVAL : -EBUSY);
-		goto out;
-	}
-
-	/* did someone beat us to it? */
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(blkg))
-		goto out;
+	blkg = blkg_alloc(blkcg, q);
 
 	/* did alloc fail? */
-	if (unlikely(!new_blkg)) {
+	if (unlikely(!blkg)) {
 		blkg = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
 	/* insert */
 	spin_lock(&blkcg->lock);
-	swap(blkg, new_blkg);
-
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	list_add(&blkg->q_node, &q->blkg_list);
-
 	spin_unlock(&blkcg->lock);
+
+	spin_lock(&alloc_list_lock);
+	list_add(&blkg->alloc_node, &alloc_list);
+	/* Queue per cpu stat allocation from worker thread. */
+	queue_delayed_work(system_nrt_wq, &blkio_stat_alloc_work, 0);
+	spin_unlock(&alloc_list_lock);
 out:
-	blkg_free(new_blkg);
 	return blkg;
 }
 EXPORT_SYMBOL_GPL(blkg_lookup_create);
@@ -654,6 +693,10 @@ static void blkg_destroy(struct blkio_group *blkg)
 	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
+	spin_lock(&alloc_list_lock);
+	list_del_init(&blkg->alloc_node);
+	spin_unlock(&alloc_list_lock);
+
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
@@ -752,6 +795,9 @@ static void blkio_reset_stats_cpu(struct blkio_group *blkg, int plid)
 	struct blkg_policy_data *pd = blkg->pd[plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
+
+	if (pd->stats_cpu == NULL)
+		return;
 	/*
 	 * Note: On 64 bit arch this should not be an issue. This has the
 	 * possibility of returning some inconsistent value on 32bit arch
@@ -883,6 +929,9 @@ static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg, int plid,
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
 
+	if (pd->stats_cpu == NULL)
+		return val;
+
 	for_each_possible_cpu(cpu) {
 		unsigned int start;
 		stats_cpu = per_cpu_ptr(pd->stats_cpu, cpu);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 98cd853..1de32fe 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -190,6 +190,8 @@ struct blkio_group {
 	spinlock_t stats_lock;
 	struct blkg_policy_data *pd[BLKIO_NR_POLICIES];
 
+	/* List of blkg waiting for per cpu stats memory to be allocated */
+	struct list_head alloc_node;
 	struct rcu_head rcu_head;
 };
 
-- 
1.7.7.3

