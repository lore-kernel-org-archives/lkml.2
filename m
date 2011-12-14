Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1LNXGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:06:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340Ab1LNXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:06:20 -0500
Date: Wed, 14 Dec 2011 18:06:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nate Custer <nate@cpanel.net>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kvm deadlock
Message-ID: <20111214230611.GF25484@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111214170347.GA25484@redhat.com>
 <4EE8D863.5000701@kernel.dk>
 <20111214172234.GB25484@redhat.com>
 <20111214181623.GA20380@google.com>
 <20111214184134.GC25484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214184134.GC25484@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 01:41:34PM -0500, Vivek Goyal wrote:
> On Wed, Dec 14, 2011 at 10:16:23AM -0800, Tejun Heo wrote:
> 
> [..]
> > > > > Or may be there is a safer version of pcpu alloc which will return
> > > > > without allocation if pcpu_alloc_mutex is already locked.
> > 
> > pcpu alloc depends on vmalloc allocation, so it isn't trivial.  We can
> > try to make percpu keep cache of areas for this type of allocation but
> > I personally think doing percpu allocation from atomic context or IO
> > path is a bad idea.  Hmmm...
> 
> Looks like I am running out of options here.  I can't find a suitable path
> where I can allocate these stats out of IO path. Because devices can be
> plugged in dynamically (and these stats are per cgroup, per device), and
> cgroups can be created dynamically after device creation, I can't do any
> static allocation out of IO path. So that kind of makes use of per cpu
> memory areas for stats in this case impossible.
> 
> For a moment I thought of doing allocation from worker thread after taking
> a reference on the original group. Allow the IO submission to continue without
> blocking. Just that till per cpu areas are allocated, we will not
> collect any stats.
>

Ok, even though I am not convinced about it yet, I wrote a small patch
to allocate per cpu data area from worker thread context asynchronously
(except for root cgroup). We continue to submit the IO without blocking
for per cpu data and if per cpu data is not allocated yet, we lose the
stat for that duration for that group.

Here is half baked test patch which compiles and boots. CFQ changes are not
done yet. I have yet to find out if I need any additional locking or
barriers. Right now I am just relying on reference counting of group objects.

I am posting it here to figure if this kind of approach is acceptable or
completely frowned upon.

Thanks
Vivek

Not-signed-half-baked-test-patch
---
 block/blk-cgroup.c   |   29 +++++++++++++++++++++++++++
 block/blk-cgroup.h   |    2 +
 block/blk-throttle.c |   53 ++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 75 insertions(+), 9 deletions(-)

Index: block/blk-throttle.c
===================================================================
--- block/blk-throttle.c.orig	2011-12-14 23:25:00.000000000 -0500
+++ block/blk-throttle.c	2011-12-14 23:46:58.000000000 -0500
@@ -81,6 +81,7 @@ struct throtl_grp {
 	int limits_changed;
 
 	struct rcu_head rcu_head;
+	struct work_struct stat_alloc_work;
 };
 
 struct throtl_data
@@ -159,6 +160,7 @@ static void throtl_free_tg(struct rcu_he
 	struct throtl_grp *tg;
 
 	tg = container_of(head, struct throtl_grp, rcu_head);
+	/* Will delayed allocation be visible here for sure? */
 	free_percpu(tg->blkg.stats_cpu);
 	kfree(tg);
 }
@@ -181,6 +183,24 @@ static void throtl_put_tg(struct throtl_
 	call_rcu(&tg->rcu_head, throtl_free_tg);
 }
 
+/* No locks taken. A reference to throtl_grp taken before invocation */
+static void tg_stat_alloc_fn(struct work_struct *work)
+{
+	struct throtl_grp *tg = container_of(work, struct throtl_grp,
+						stat_alloc_work);
+	void *stat_ptr = NULL;
+
+	stat_ptr = blkio_alloc_blkg_stats_pcpu();
+
+	if (stat_ptr == NULL) {
+		throtl_put_tg(tg);
+		return;
+	}
+
+	blkio_set_blkg_stats_pcpu(&tg->blkg, stat_ptr);
+	throtl_put_tg(tg);
+}
+
 static void throtl_init_group(struct throtl_grp *tg)
 {
 	INIT_HLIST_NODE(&tg->tg_node);
@@ -188,6 +208,7 @@ static void throtl_init_group(struct thr
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
 	tg->limits_changed = false;
+	INIT_WORK(&tg->stat_alloc_work, tg_stat_alloc_fn);
 
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
@@ -264,7 +285,7 @@ static void throtl_init_add_tg_lists(str
 }
 
 /* Should be called without queue lock and outside of rcu period */
-static struct throtl_grp *throtl_alloc_tg(struct throtl_data *td)
+static struct throtl_grp *throtl_alloc_tg(struct throtl_data *td, bool async)
 {
 	struct throtl_grp *tg = NULL;
 	int ret;
@@ -273,14 +294,28 @@ static struct throtl_grp *throtl_alloc_t
 	if (!tg)
 		return NULL;
 
-	ret = blkio_alloc_blkg_stats(&tg->blkg);
+	if (!async) {
+		ret = blkio_alloc_blkg_stats(&tg->blkg);
 
-	if (ret) {
-		kfree(tg);
-		return NULL;
+		if (ret) {
+        		kfree(tg);
+        		return NULL;
+		}
 	}
 
 	throtl_init_group(tg);
+
+	if (async) {
+		/*
+		 * Schedule the group per cpu stat allocation through worker
+		 * thread
+		 */
+		throtl_ref_get_tg(tg);
+		if(!schedule_work(&tg->stat_alloc_work))
+			/* nobody should have scheduled this work before */
+			WARN_ON(1);
+	}
+
 	return tg;
 }
 
@@ -329,14 +364,14 @@ static struct throtl_grp * throtl_get_tg
 	rcu_read_unlock();
 	spin_unlock_irq(q->queue_lock);
 
-	tg = throtl_alloc_tg(td);
+	tg = throtl_alloc_tg(td, 1);
 
 	/* Group allocated and queue is still alive. take the lock */
 	spin_lock_irq(q->queue_lock);
 
 	/* Make sure @q is still alive */
 	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
-		kfree(tg);
+		throtl_put_tg(tg);
 		return NULL;
 	}
 
@@ -353,7 +388,7 @@ static struct throtl_grp * throtl_get_tg
 	__tg = throtl_find_tg(td, blkcg);
 
 	if (__tg) {
-		kfree(tg);
+		throtl_put_tg(tg);
 		rcu_read_unlock();
 		return __tg;
 	}
@@ -1254,7 +1289,7 @@ int blk_throtl_init(struct request_queue
 
 	/* alloc and Init root group. */
 	td->queue = q;
-	tg = throtl_alloc_tg(td);
+	tg = throtl_alloc_tg(td, 0);
 
 	if (!tg) {
 		kfree(td);
Index: block/blk-cgroup.c
===================================================================
--- block/blk-cgroup.c.orig	2011-12-14 23:25:00.000000000 -0500
+++ block/blk-cgroup.c	2011-12-14 23:25:24.000000000 -0500
@@ -400,6 +400,9 @@ void blkiocg_update_dispatch_stats(struc
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	if (blkg->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -446,6 +449,9 @@ void blkiocg_update_io_merged_stats(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
+	if (blkg->stats_cpu == NULL)
+		return;
+
 	/*
 	 * Disabling interrupts to provide mutual exclusion between two
 	 * writes on same cpu. It probably is not needed for 64bit. Not
@@ -477,6 +483,19 @@ int blkio_alloc_blkg_stats(struct blkio_
 }
 EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats);
 
+void* blkio_alloc_blkg_stats_pcpu(void)
+{
+	/* Allocate memory for per cpu stats */
+	return alloc_percpu(struct blkio_group_stats_cpu);
+}
+EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats_pcpu);
+
+void blkio_set_blkg_stats_pcpu(struct blkio_group *blkg, void *stats_cpu)
+{
+	blkg->stats_cpu = stats_cpu;
+}
+EXPORT_SYMBOL_GPL(blkio_set_blkg_stats_pcpu);
+
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid)
@@ -551,6 +570,12 @@ static void blkio_reset_stats_cpu(struct
 {
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
+
+	/* blkg->stats_cpu can have delayed allocation */
+
+	if (!blkg->stats_cpu)
+		return;
+
 	/*
 	 * Note: On 64 bit arch this should not be an issue. This has the
 	 * possibility of returning some inconsistent value on 32bit arch
@@ -673,6 +698,10 @@ static uint64_t blkio_read_stat_cpu(stru
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
 
+	/* blkg->stats_cpu might not have been allocated yet */
+	if (blkg->stats_cpu == NULL)
+		return 0;
+
 	for_each_possible_cpu(cpu) {
 		unsigned int start;
 		stats_cpu  = per_cpu_ptr(blkg->stats_cpu, cpu);
Index: block/blk-cgroup.h
===================================================================
--- block/blk-cgroup.h.orig	2011-12-14 23:25:00.000000000 -0500
+++ block/blk-cgroup.h	2011-12-14 23:25:24.000000000 -0500
@@ -311,6 +311,8 @@ extern void blkiocg_add_blkio_group(stru
 	struct blkio_group *blkg, void *key, dev_t dev,
 	enum blkio_policy_id plid);
 extern int blkio_alloc_blkg_stats(struct blkio_group *blkg);
+extern void* blkio_alloc_blkg_stats_pcpu(void);
+extern void blkio_set_blkg_stats_pcpu(struct blkio_group *blkg, void *stats_cpu);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
