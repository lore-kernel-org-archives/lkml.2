Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031288Ab2B2Rgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030904Ab2B2Rgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:36:50 -0500
Date: Wed, 29 Feb 2012 12:36:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120229173639.GB5930@redhat.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120224142033.GA5095@redhat.com>
 <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227031146.GA25187@redhat.com>
 <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227194321.GF27677@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227194321.GF27677@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 02:43:21PM -0500, Vivek Goyal wrote:
> On Mon, Feb 27, 2012 at 06:11:41PM +0900, Tejun Heo wrote:
> > On Sun, Feb 26, 2012 at 10:11:46PM -0500, Vivek Goyal wrote:
> > > Ok. This sounds better than embeding work_struct in blkg, I can embed it
> > > in request_queue and make the worker walk the list of blkg pending 
> > > alloc of stats. Will try that. Thanks for the idea.
> > 
> > We might not need to make it even per-queue.  Simple global list of
> > pending blkgs and single work item should work fine, I think.
> 
> Thanks for the suggestion Tejun. I have implemented it and below is the
> patch. I have done basic testing of boot and cgroup creation. Yet to test
> it over elevator switch path. Will do that once it is fixed. I will sign
> it after testing.
> 
> Do let me know if you want some changes in the patch.
> 
> Thanks
> Vivek
> 
> Allocate blkg per cpu stat from a worker thread.
> 
> Yet-to-be-signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Came up with second version of patch. Minor cleanups. There were couple
of redundant condition checks.

Thanks
Vivek


Allocate blkg per cpu stats asynchrnously from a worker thread.

---
 block/blk-cgroup.c |  134 +++++++++++++++++++++++++++++++++++++++--------------
 block/blk-cgroup.h |    2 
 2 files changed, 101 insertions(+), 35 deletions(-)

Index: tejun-misc/block/blk-cgroup.h
===================================================================
--- tejun-misc.orig/block/blk-cgroup.h	2012-02-28 01:29:09.238256494 -0500
+++ tejun-misc/block/blk-cgroup.h	2012-02-28 01:29:12.000000000 -0500
@@ -180,6 +180,8 @@ struct blkio_group {
 	struct request_queue *q;
 	struct list_head q_node;
 	struct hlist_node blkcg_node;
+	/* List of blkg waiting for per cpu stats memory to be allocated */
+	struct list_head pending_alloc_node;
 	struct blkio_cgroup *blkcg;
 	/* Store cgroup path */
 	char path[128];
Index: tejun-misc/block/blk-cgroup.c
===================================================================
--- tejun-misc.orig/block/blk-cgroup.c	2012-02-28 01:29:09.239256494 -0500
+++ tejun-misc/block/blk-cgroup.c	2012-02-29 23:02:00.279293289 -0500
@@ -30,6 +30,12 @@ static LIST_HEAD(blkio_list);
 static DEFINE_MUTEX(all_q_mutex);
 static LIST_HEAD(all_q_list);
 
+static DEFINE_SPINLOCK(pending_alloc_list_lock);
+static LIST_HEAD(pending_alloc_list);
+
+static void blkio_stat_alloc_fn(struct work_struct *);
+static DECLARE_WORK(blkio_stat_alloc_work, blkio_stat_alloc_fn);
+
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
@@ -391,6 +397,9 @@ void blkiocg_update_dispatch_stats(struc
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	if (pd->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -443,6 +452,9 @@ void blkiocg_update_io_merged_stats(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	if (pd->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -460,6 +472,72 @@ void blkiocg_update_io_merged_stats(stru
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
+static void blkio_stat_alloc_fn(struct work_struct *work)
+{
+
+	void *stat_ptr = NULL;
+	struct blkio_group *blkg, *n;
+	int i;
+
+alloc_stats:
+	spin_lock_irq(&pending_alloc_list_lock);
+		if (list_empty(&pending_alloc_list)) {
+			/* Nothing to do */
+			spin_unlock_irq(&pending_alloc_list_lock);
+			return;
+		}
+	spin_unlock_irq(&pending_alloc_list_lock);
+
+	WARN_ON(stat_ptr != NULL);
+	stat_ptr = alloc_percpu(struct blkio_group_stats_cpu);
+
+	/* Retry. Should there be an upper limit on number of retries */
+	if (stat_ptr == NULL)
+		goto alloc_stats;
+
+	spin_lock_irq(&blkio_list_lock);
+	spin_lock(&pending_alloc_list_lock);
+
+	list_for_each_entry_safe(blkg, n, &pending_alloc_list,
+		pending_alloc_node) {
+		for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+			struct blkio_policy_type *pol = blkio_policy[i];
+			struct blkg_policy_data *pd;
+
+			if (!pol)
+				continue;
+
+			if (!blkg->pd[i])
+				continue;
+
+			pd = blkg->pd[i];
+			if (pd->stats_cpu)
+				continue;
+
+			pd->stats_cpu = stat_ptr;
+			stat_ptr = NULL;
+			break;
+		}
+
+		if (i == BLKIO_NR_POLICIES - 1) {
+			/* We are done with this group */
+			list_del_init(&blkg->pending_alloc_node);
+			continue;
+		} else
+			/* Go allocate more memory */
+			break;
+	}
+	spin_unlock(&pending_alloc_list_lock);
+	spin_unlock_irq(&blkio_list_lock);
+
+	if (stat_ptr != NULL) {
+		/* Nobody needs memory anymore */
+		free_percpu(stat_ptr);
+		return;
+	} else
+		goto alloc_stats;
+}
+
 /**
  * blkg_free - free a blkg
  * @blkg: blkg to free
@@ -509,6 +587,7 @@ static struct blkio_group *blkg_alloc(st
 	spin_lock_init(&blkg->stats_lock);
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
+	INIT_LIST_HEAD(&blkg->pending_alloc_node);
 	blkg->blkcg = blkcg;
 	blkg->refcnt = 1;
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
@@ -530,13 +609,6 @@ static struct blkio_group *blkg_alloc(st
 
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
@@ -556,7 +628,7 @@ struct blkio_group *blkg_lookup_create(s
 				       bool for_root)
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
-	struct blkio_group *blkg, *new_blkg;
+	struct blkio_group *blkg;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
@@ -580,48 +652,29 @@ struct blkio_group *blkg_lookup_create(s
 
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
+	spin_lock(&pending_alloc_list_lock);
 
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	list_add(&blkg->q_node, &q->blkg_list);
+	list_add(&blkg->pending_alloc_node, &pending_alloc_list);
 
+	/* Queue per cpu stat allocation from worker thread. */
+	queue_work(system_nrt_wq, &blkio_stat_alloc_work);
+
+	spin_unlock(&pending_alloc_list_lock);
 	spin_unlock(&blkcg->lock);
 out:
-	blkg_free(new_blkg);
 	return blkg;
 }
 EXPORT_SYMBOL_GPL(blkg_lookup_create);
@@ -648,11 +701,16 @@ static void blkg_destroy(struct blkio_gr
 	lockdep_assert_held(q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
+	spin_lock(&pending_alloc_list_lock);
+
 	/* Something wrong if we are trying to remove same group twice */
 	WARN_ON_ONCE(list_empty(&blkg->q_node));
 	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
 	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
+	list_del_init(&blkg->pending_alloc_node);
+
+	spin_unlock(&pending_alloc_list_lock);
 
 	/*
 	 * Put the reference taken at the time of creation so that when all
@@ -755,6 +813,9 @@ static void blkio_reset_stats_cpu(struct
 	struct blkg_policy_data *pd = blkg->pd[plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
+
+	if (pd->stats_cpu == NULL)
+		return;
 	/*
 	 * Note: On 64 bit arch this should not be an issue. This has the
 	 * possibility of returning some inconsistent value on 32bit arch
@@ -886,6 +947,9 @@ static uint64_t blkio_read_stat_cpu(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
 
+	if (pd->stats_cpu == NULL)
+		return val;
+
 	for_each_possible_cpu(cpu) {
 		unsigned int start;
 		stats_cpu = per_cpu_ptr(pd->stats_cpu, cpu);
