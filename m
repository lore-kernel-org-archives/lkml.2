Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2CHR5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:57:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab2CHR5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:57:18 -0500
Date: Thu, 8 Mar 2012 12:57:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120308175708.GB22922@redhat.com>
References: <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307150549.955d6f9c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 03:05:49PM -0800, Andrew Morton wrote:

[..]
> > > btw, speaking of uniprocessor: please do perform a uniprocessor build
> > > and see what impact the patch has upon the size(1) output for the .o
> > > files.  We should try to minimize the pointless bloat for the UP
> > > kernel.
> > 
> > But this logic is required both for UP and SMP kernels. So bloat on UP
> > is not unnecessary?
> 
> UP doesn't need a per-cpu variable, hence it doesn't need to run
> alloc_per_cpu() at all.  For UP all we need to do is to aggregate a
> `struct blkio_group_stats' within `struct blkg_policy_data'?
> 
> This could still be done with suitable abstraction and wrappers. 
> Whether that's desirable depends on how fat the API ends up, I guess.
> 

Ok, here is the patch which gets rid of allocating per cpu stats in case
of UP. Here are the size stats with and without patch.

Without patch (UP kernel)
-------------------------
# size block/blk-cgroup.o
   text    data     bss     dec     hex filename
  13377    5504      58   18939    49fb block/blk-cgroup.o

With patch (UP kernel)
----------------------
# size block/blk-cgroup.o
   text    data     bss     dec     hex filename
  12678    5312      49   18039    4677 block/blk-cgroup.o

Do you think it is worth introducing these ifdefs.

Anyway, I am assuming that optimization for UP issue is not blocking the
acceptance of other alloc per cpu patch. I have replaced msleep()
with queue_delayed_work(). Hopefully it is little less miserable now.

Tejun, I noticed that in UP case, once in a while cgroup removal is
hanging. Looks like it is hung in cgroup_rmdir() somewhere. I will debug
more to find out what is happening. May be blkcg->refcount issue.

Thanks
Vivek

---
 block/blk-cgroup.c |   65 +++++++++++++++++++++++++++++++++++++++++++++--------
 block/blk-cgroup.h |    6 ++++
 2 files changed, 61 insertions(+), 10 deletions(-)

Index: tejun-misc/block/blk-cgroup.h
===================================================================
--- tejun-misc.orig/block/blk-cgroup.h	2012-03-08 23:28:17.000000000 -0500
+++ tejun-misc/block/blk-cgroup.h	2012-03-08 23:37:25.310887020 -0500
@@ -168,9 +168,13 @@ struct blkg_policy_data {
 	struct blkio_group_conf conf;
 
 	struct blkio_group_stats stats;
+
+#ifdef CONFIG_SMP
 	/* Per cpu stats pointer */
 	struct blkio_group_stats_cpu __percpu *stats_cpu;
-
+#else
+	struct blkio_group_stats_cpu stats_cpu;
+#endif
 	/* pol->pdata_size bytes of private data used by policy impl */
 	char pdata[] __aligned(__alignof__(unsigned long long));
 };
Index: tejun-misc/block/blk-cgroup.c
===================================================================
--- tejun-misc.orig/block/blk-cgroup.c	2012-03-08 23:37:14.079886676 -0500
+++ tejun-misc/block/blk-cgroup.c	2012-03-08 23:37:55.104888008 -0500
@@ -35,9 +35,11 @@ static DEFINE_SPINLOCK(alloc_list_lock);
 static LIST_HEAD(alloc_list);
 
 /* Array of per cpu stat pointers allocated for blk groups */
+#ifdef CONFIG_SMP
 static void *pcpu_stats[BLKIO_NR_POLICIES];
 static void blkio_stat_alloc_fn(struct work_struct *);
 static DECLARE_DELAYED_WORK(blkio_stat_alloc_work, blkio_stat_alloc_fn);
+#endif
 
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
@@ -73,6 +75,42 @@ struct cgroup_subsys blkio_subsys = {
 };
 EXPORT_SYMBOL_GPL(blkio_subsys);
 
+#ifdef CONFIG_SMP
+static inline struct blkio_group_stats_cpu *
+pd_this_cpu_stat_ptr(struct blkg_policy_data *pd)
+{
+	return this_cpu_ptr(pd->stats_cpu);
+}
+
+static inline struct blkio_group_stats_cpu *
+pd_cpu_stat_ptr(struct blkg_policy_data *pd, int cpu)
+{
+	return per_cpu_ptr(pd->stats_cpu, cpu);
+}
+
+static inline bool pd_stat_cpu_valid(struct blkg_policy_data *pd)
+{
+	return pd->stats_cpu ? true : false;
+}
+#else /* UP */
+static inline struct blkio_group_stats_cpu *
+pd_this_cpu_stat_ptr(struct blkg_policy_data *pd)
+{
+	return &pd->stats_cpu;
+}
+
+static inline struct blkio_group_stats_cpu *
+pd_cpu_stat_ptr(struct blkg_policy_data *pd, int cpu)
+{
+	return &pd->stats_cpu;
+}
+
+static inline bool pd_stat_cpu_valid(struct blkg_policy_data *pd)
+{
+	return true;
+}
+#endif /* CONFIG_SMP */
+
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 {
 	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
@@ -401,7 +439,7 @@ void blkiocg_update_dispatch_stats(struc
 	unsigned long flags;
 
 	/* If per cpu stats are not allocated yet, don't do any accounting. */
-	if (pd->stats_cpu == NULL)
+	if (!pd_stat_cpu_valid(pd))
 		return;
 
 	/*
@@ -411,7 +449,7 @@ void blkiocg_update_dispatch_stats(struc
 	 */
 	local_irq_save(flags);
 
-	stats_cpu = this_cpu_ptr(pd->stats_cpu);
+	stats_cpu = pd_this_cpu_stat_ptr(pd);
 
 	u64_stats_update_begin(&stats_cpu->syncp);
 	stats_cpu->sectors += bytes >> 9;
@@ -457,7 +495,7 @@ void blkiocg_update_io_merged_stats(stru
 	unsigned long flags;
 
 	/* If per cpu stats are not allocated yet, don't do any accounting. */
-	if (pd->stats_cpu == NULL)
+	if (!pd_stat_cpu_valid(pd))
 		return;
 
 	/*
@@ -467,7 +505,7 @@ void blkiocg_update_io_merged_stats(stru
 	 */
 	local_irq_save(flags);
 
-	stats_cpu = this_cpu_ptr(pd->stats_cpu);
+	stats_cpu = pd_this_cpu_stat_ptr(pd);
 
 	u64_stats_update_begin(&stats_cpu->syncp);
 	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_MERGED], 1,
@@ -481,6 +519,7 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_merg
  * Worker for allocating per cpu stat for blk groups. This is scheduled
  * once there are some groups on the alloc_list waiting for allocation
  */
+#ifdef CONFIG_SMP
 static void blkio_stat_alloc_fn(struct work_struct *work)
 {
 
@@ -530,6 +569,7 @@ alloc_stats:
 	if (!empty)
 		goto alloc_stats;
 }
+#endif
 
 /**
  * blkg_free - free a blkg
@@ -548,7 +588,9 @@ static void blkg_free(struct blkio_group
 		struct blkg_policy_data *pd = blkg->pd[i];
 
 		if (pd) {
+#ifdef CONFIG_SMP
 			free_percpu(pd->stats_cpu);
+#endif
 			kfree(pd);
 		}
 	}
@@ -657,11 +699,15 @@ struct blkio_group *blkg_lookup_create(s
 	list_add(&blkg->q_node, &q->blkg_list);
 	spin_unlock(&blkcg->lock);
 
+	/* In case of UP, stats are not per cpu */
+#ifdef CONFIG_SMP
 	spin_lock(&alloc_list_lock);
 	list_add(&blkg->alloc_node, &alloc_list);
 	/* Queue per cpu stat allocation from worker thread. */
 	queue_delayed_work(system_nrt_wq, &blkio_stat_alloc_work, 0);
 	spin_unlock(&alloc_list_lock);
+#endif
+
 out:
 	return blkg;
 }
@@ -730,9 +776,10 @@ void update_root_blkg_pd(struct request_
 	pd = kzalloc(sizeof(*pd) + pol->pdata_size, GFP_KERNEL);
 	WARN_ON_ONCE(!pd);
 
+#ifdef CONFIG_SMP
 	pd->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
 	WARN_ON_ONCE(!pd->stats_cpu);
-
+#endif
 	blkg->pd[plid] = pd;
 	pd->blkg = blkg;
 	pol->ops.blkio_init_group_fn(blkg);
@@ -798,7 +845,7 @@ static void blkio_reset_stats_cpu(struct
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
 
-	if (pd->stats_cpu == NULL)
+	if (!pd_stat_cpu_valid(pd))
 		return;
 	/*
 	 * Note: On 64 bit arch this should not be an issue. This has the
@@ -812,7 +859,7 @@ static void blkio_reset_stats_cpu(struct
 	 * unless this becomes a real issue.
 	 */
 	for_each_possible_cpu(i) {
-		stats_cpu = per_cpu_ptr(pd->stats_cpu, i);
+		stats_cpu = pd_cpu_stat_ptr(pd, i);
 		stats_cpu->sectors = 0;
 		for(j = 0; j < BLKIO_STAT_CPU_NR; j++)
 			for (k = 0; k < BLKIO_STAT_TOTAL; k++)
@@ -931,12 +978,12 @@ static uint64_t blkio_read_stat_cpu(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
 
-	if (pd->stats_cpu == NULL)
+	if (!pd_stat_cpu_valid(pd))
 		return val;
 
 	for_each_possible_cpu(cpu) {
 		unsigned int start;
-		stats_cpu = per_cpu_ptr(pd->stats_cpu, cpu);
+		stats_cpu = pd_cpu_stat_ptr(pd, cpu);
 
 		do {
 			start = u64_stats_fetch_begin(&stats_cpu->syncp);


