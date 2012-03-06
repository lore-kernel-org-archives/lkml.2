Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031338Ab2CFVKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:10:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031121Ab2CFVKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:10:05 -0500
Date: Tue, 6 Mar 2012 16:09:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120306210954.GF32148@redhat.com>
References: <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120224142033.GA5095@redhat.com>
 <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227031146.GA25187@redhat.com>
 <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305221321.GF1263@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:13:21PM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Wed, Feb 29, 2012 at 12:36:39PM -0500, Vivek Goyal wrote:
> > Index: tejun-misc/block/blk-cgroup.h
> > ===================================================================
> > --- tejun-misc.orig/block/blk-cgroup.h	2012-02-28 01:29:09.238256494 -0500
> > +++ tejun-misc/block/blk-cgroup.h	2012-02-28 01:29:12.000000000 -0500
> > @@ -180,6 +180,8 @@ struct blkio_group {
> >  	struct request_queue *q;
> >  	struct list_head q_node;
> >  	struct hlist_node blkcg_node;
> > +	/* List of blkg waiting for per cpu stats memory to be allocated */
> > +	struct list_head pending_alloc_node;
> 
> Can we move this right on top of rcu_head?  It's one of the coldest
> entries.  Also, long field names tend to be a bit painful.  How about
> just alloc_node?

Hi Tejun,

Here is the new version (lets call it v2) of the patch. Please let me
know if some more changes are required.

Thanks
Vivek

blk-cgroup: Alloc per cpu stats from worker thread in a delayed manner

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

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  128 ++++++++++++++++++++++++++++++++++++-----------------
 block/blk-cgroup.h |    2 
 2 files changed, 90 insertions(+), 40 deletions(-)

Index: tejun-misc/block/blk-cgroup.c
===================================================================
--- tejun-misc.orig/block/blk-cgroup.c	2012-03-07 02:33:14.761787970 -0500
+++ tejun-misc/block/blk-cgroup.c	2012-03-07 02:33:51.042788674 -0500
@@ -30,6 +30,15 @@ static LIST_HEAD(blkio_list);
 static DEFINE_MUTEX(all_q_mutex);
 static LIST_HEAD(all_q_list);
 
+/* List of groups pending per cpu stats allocation */
+static DEFINE_SPINLOCK(alloc_list_lock);
+static LIST_HEAD(alloc_list);
+
+/* Array of per cpu stat pointers allocated for blk groups */
+static void *pcpu_stats[BLKIO_NR_POLICIES];
+static void blkio_stat_alloc_fn(struct work_struct *);
+static DECLARE_WORK(blkio_stat_alloc_work, blkio_stat_alloc_fn);
+
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
@@ -391,6 +400,9 @@ void blkiocg_update_dispatch_stats(struc
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	if (pd->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -443,6 +455,9 @@ void blkiocg_update_io_merged_stats(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	if (pd->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -460,6 +475,59 @@ void blkiocg_update_io_merged_stats(stru
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
+static void blkio_stat_alloc_fn(struct work_struct *work)
+{
+
+	struct blkio_group *blkg, *n;
+	int i;
+
+alloc_stats:
+	spin_lock_irq(&alloc_list_lock);
+		if (list_empty(&alloc_list)) {
+			/* Nothing to do */
+			spin_unlock_irq(&alloc_list_lock);
+			return;
+		}
+	spin_unlock_irq(&alloc_list_lock);
+
+	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+		if (pcpu_stats[i] != NULL)
+			continue;
+
+		pcpu_stats[i] = alloc_percpu(struct blkio_group_stats_cpu);
+		if (pcpu_stats[i] == NULL)
+			goto alloc_stats;
+	}
+
+	spin_lock_irq(&blkio_list_lock);
+	spin_lock(&alloc_list_lock);
+
+	list_for_each_entry_safe(blkg, n, &alloc_list, alloc_node) {
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
+			pd->stats_cpu = pcpu_stats[i];
+			pcpu_stats[i] = NULL;
+		}
+		list_del_init(&blkg->alloc_node);
+		break;
+	}
+	spin_unlock(&alloc_list_lock);
+	spin_unlock_irq(&blkio_list_lock);
+	goto alloc_stats;
+}
+
 /**
  * blkg_free - free a blkg
  * @blkg: blkg to free
@@ -491,9 +559,6 @@ static void blkg_free(struct blkio_group
  * @q: request_queue the new blkg is associated with
  *
  * Allocate a new blkg assocating @blkcg and @q.
- *
- * FIXME: Should be called with queue locked but currently isn't due to
- *        percpu stat breakage.
  */
 static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 				      struct request_queue *q)
@@ -509,6 +574,7 @@ static struct blkio_group *blkg_alloc(st
 	spin_lock_init(&blkg->stats_lock);
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
+	INIT_LIST_HEAD(&blkg->alloc_node);
 	blkg->blkcg = blkcg;
 	blkg->refcnt = 1;
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
@@ -530,13 +596,6 @@ static struct blkio_group *blkg_alloc(st
 
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
@@ -556,7 +615,7 @@ struct blkio_group *blkg_lookup_create(s
 				       bool for_root)
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
-	struct blkio_group *blkg, *new_blkg;
+	struct blkio_group *blkg;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
@@ -580,48 +639,27 @@ struct blkio_group *blkg_lookup_create(s
 
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
+	queue_work(system_nrt_wq, &blkio_stat_alloc_work);
+	spin_unlock(&alloc_list_lock);
 out:
-	blkg_free(new_blkg);
 	return blkg;
 }
 EXPORT_SYMBOL_GPL(blkg_lookup_create);
@@ -654,6 +692,10 @@ static void blkg_destroy(struct blkio_gr
 	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
+	spin_lock(&alloc_list_lock);
+	list_del_init(&blkg->alloc_node);
+	spin_unlock(&alloc_list_lock);
+
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
@@ -752,6 +794,9 @@ static void blkio_reset_stats_cpu(struct
 	struct blkg_policy_data *pd = blkg->pd[plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
+
+	if (pd->stats_cpu == NULL)
+		return;
 	/*
 	 * Note: On 64 bit arch this should not be an issue. This has the
 	 * possibility of returning some inconsistent value on 32bit arch
@@ -883,6 +928,9 @@ static uint64_t blkio_read_stat_cpu(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
 
+	if (pd->stats_cpu == NULL)
+		return val;
+
 	for_each_possible_cpu(cpu) {
 		unsigned int start;
 		stats_cpu = per_cpu_ptr(pd->stats_cpu, cpu);
Index: tejun-misc/block/blk-cgroup.h
===================================================================
--- tejun-misc.orig/block/blk-cgroup.h	2012-03-07 02:33:14.761787970 -0500
+++ tejun-misc/block/blk-cgroup.h	2012-03-07 02:33:51.042788674 -0500
@@ -190,6 +190,8 @@ struct blkio_group {
 	spinlock_t stats_lock;
 	struct blkg_policy_data *pd[BLKIO_NR_POLICIES];
 
+	/* List of blkg waiting for per cpu stats memory to be allocated */
+	struct list_head alloc_node;
 	struct rcu_head rcu_head;
 };
 
