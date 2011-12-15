Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1LOTrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1LOTrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:47:20 -0500
Date: Thu, 15 Dec 2011 14:47:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Nate Custer <nate@cpanel.net>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFT PATCH] blkio: alloc per cpu data from worker thread context(
 Re: kvm deadlock)
Message-ID: <20111215194712.GA11194@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE8C8EA.9070207@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:03:54PM +0100, Jens Axboe wrote:
> On 2011-12-14 14:43, Avi Kivity wrote:
> > On 12/14/2011 02:25 PM, Marcelo Tosatti wrote:
> >> On Mon, Dec 05, 2011 at 04:48:16PM -0600, Nate Custer wrote:
> >>> Hello,
> >>>
> >>> I am struggling with repeatable full hardware locks when running 8-12 KVM vms. At some point before the hard lock I get a inconsistent lock state warning. An example of this can be found here:
> >>>
> >>> http://pastebin.com/8wKhgE2C
> >>>
> >>> After that the server continues to run for a while and then starts its death spiral. When it reaches that point it fails to log anything further to the disk, but by attaching a console I have been able to get a stack trace documenting the final implosion:
> >>>
> >>> http://pastebin.com/PbcN76bd
> >>>
> >>> All of the cores end up hung and the server stops responding to all input, including SysRq commands. 
> >>>
> >>> I have seen this behavior on two machines (dual E5606 running Fedora 16) both passed cpuburnin testing and memtest86 scans without error. 
> >>>
> >>> I have reproduced the crash and stack traces from a Fedora debugging kernel - 3.1.2-1 and with a vanilla 3.1.4 kernel.
> >>
> >> Busted hardware, apparently. Can you reproduce these issues with the
> >> same workload on different hardware?
> > 
> > I don't think it's hardware related.  The second trace (in the first
> > paste) is called during swap, so GFP_FS is set.  The first one is not,
> > so GFP_FS is clear.  Lockdep is worried about the following scenario:
> > 
> >   acpi_early_init() is called
> >   calls pcpu_alloc(), which takes pcpu_alloc_mutex
> >   eventually, calls kmalloc(), or some other allocation function
> >   no memory, so swap
> >   call try_to_free_pages()
> >   submit_bio()
> >   blk_throtl_bio()
> >   blkio_alloc_blkg_stats()
> >   alloc_percpu()
> >   pcpu_alloc(), which takes pcpu_alloc_mutex
> >   deadlock
> > 
> > It's a little unlikely that acpi_early_init() will OOM, but lockdep
> > doesn't know that.  Other callers of pcpu_alloc() could trigger the same
> > thing.
> > 
> > When lockdep says
> > 
> > [ 5839.924953] other info that might help us debug this:
> > [ 5839.925396]  Possible unsafe locking scenario:
> > [ 5839.925397]
> > [ 5839.925840]        CPU0
> > [ 5839.926063]        ----
> > [ 5839.926287]   lock(pcpu_alloc_mutex);
> > [ 5839.926533]   <Interrupt>
> > [ 5839.926756]     lock(pcpu_alloc_mutex);
> > [ 5839.926986]
> > 
> > It really means
> > 
> >    <swap, set GFP_FS>
> > 
> > GFP_FS simply marks the beginning of a nested, unrelated context that
> > uses the same thread, just like an interrupt.  Kudos to lockdep for
> > catching that.
> > 
> > I think the allocation in blkio_alloc_blkg_stats() should be moved out
> > of the I/O path into some init function. Copying Jens.
> 
> That's completely buggy, basically you end up with a GFP_KERNEL
> allocation from the IO submit path. Vivek, per_cpu data needs to be set
> up at init time. You can't allocate it dynamically off the IO path.

Ok, I continued to develop on the patch which tries to allocate per cpu
stats from worker thread context. Here is the patch.

Can the reporter please try out the patch and see if it helps. I am not
sure if deadlock was because of mutex issue or not, but it should help
get rid of lockdep warning.

This patch is on top of for-3.3/core branch of jens's linux-block tree.
If it does not apply on your kernel version, do let me know the version 
you are testing with and I will generate another version of patch.

If testing results are good, I will break down the patch in small pieces
and post as a series separately.

Thanks
Vivek

Alloc per cpu data from a worker thread context to avoid possibility of a
deadlock under memory pressure.

Only side affect of delayed allocation is that we will lose the blkio cgroup
stats for that group a small duration.

This patch is generated on top of "for-3.3/core" branch of linux-block tree.

---
 block/blk-cgroup.c   |   31 ++++++++++++-
 block/blk-cgroup.h   |    9 +++
 block/blk-throttle.c |  116 ++++++++++++++++++++++++++++++++-----------------
 block/cfq-iosched.c  |  119 ++++++++++++++++++++++++++++++---------------------
 4 files changed, 180 insertions(+), 95 deletions(-)

Index: block/blk-throttle.c
===================================================================
--- block/blk-throttle.c.orig	2011-12-15 20:31:05.000000000 -0500
+++ block/blk-throttle.c	2011-12-15 20:32:15.000000000 -0500
@@ -81,6 +81,7 @@ struct throtl_grp {
 	int limits_changed;
 
 	struct rcu_head rcu_head;
+	struct work_struct stat_alloc_work;
 };
 
 struct throtl_data
@@ -159,6 +160,13 @@ static void throtl_free_tg(struct rcu_he
 	struct throtl_grp *tg;
 
 	tg = container_of(head, struct throtl_grp, rcu_head);
+
+	/*
+	 * Will delayed allocation be visible here for sure? I am relying
+	 * on the fact that after blkg.stats_cpu assignment, we drop
+	 * reference to group using atomic_dec() which should imply
+	 * barrier
+	 */
 	free_percpu(tg->blkg.stats_cpu);
 	kfree(tg);
 }
@@ -181,6 +189,48 @@ static void throtl_put_tg(struct throtl_
 	call_rcu(&tg->rcu_head, throtl_free_tg);
 }
 
+static inline void throtl_check_schedule_pcpu_stat_alloc(struct throtl_grp *tg) {
+	if (tg->blkg.stats_cpu != NULL)
+		return;
+	/*
+	 * Schedule the group per cpu stat allocation through worker
+	 * thread
+	 */
+	throtl_ref_get_tg(tg);
+	if (!schedule_work(&tg->stat_alloc_work)) {
+		/* Work is already scheduled by somebody */
+		throtl_put_tg(tg);
+	}
+}
+
+/* No locks taken. A reference to throtl_grp taken before invocation */
+static void tg_stat_alloc_fn(struct work_struct *work)
+{
+	struct throtl_grp *tg = container_of(work, struct throtl_grp,
+						stat_alloc_work);
+	void *stat_ptr = NULL;
+	unsigned long ret;
+
+	stat_ptr = blkio_alloc_blkg_stats_pcpu();
+
+	if (stat_ptr == NULL) {
+		/* If memory allocation failed, try again */
+		throtl_check_schedule_pcpu_stat_alloc(tg);
+		throtl_put_tg(tg);
+		return;
+	}
+
+	ret = blkio_cmpxchg_blkg_stats(&tg->blkg, 0,
+					(unsigned long)stat_ptr);
+
+	if (ret != (unsigned long)stat_ptr) {
+		/* Somebody else got to it first */
+		free_percpu(tg->blkg.stats_cpu);
+	}
+
+	throtl_put_tg(tg);
+}
+
 static void throtl_init_group(struct throtl_grp *tg)
 {
 	INIT_HLIST_NODE(&tg->tg_node);
@@ -188,6 +238,7 @@ static void throtl_init_group(struct thr
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
 	tg->limits_changed = false;
+	INIT_WORK(&tg->stat_alloc_work, tg_stat_alloc_fn);
 
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
@@ -263,8 +314,25 @@ static void throtl_init_add_tg_lists(str
 	throtl_add_group_to_td_list(td, tg);
 }
 
-/* Should be called without queue lock and outside of rcu period */
-static struct throtl_grp *throtl_alloc_tg(struct throtl_data *td)
+/* Allocates per cpu stats asynchronously with the help of worker thread */
+static struct throtl_grp *throtl_alloc_tg_async(struct throtl_data *td)
+{
+	struct throtl_grp *tg = NULL;
+
+	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, td->queue->node);
+	if (!tg)
+		return NULL;
+
+	throtl_init_group(tg);
+	throtl_check_schedule_pcpu_stat_alloc(tg);
+	return tg;
+}
+
+/*
+ * Should be called without queue lock and outside of rcu period as per
+ * cpu alloc will block
+ */
+static struct throtl_grp *throtl_alloc_tg_sync(struct throtl_data *td)
 {
 	struct throtl_grp *tg = NULL;
 	int ret;
@@ -273,7 +341,7 @@ static struct throtl_grp *throtl_alloc_t
 	if (!tg)
 		return NULL;
 
-	ret = blkio_alloc_blkg_stats(&tg->blkg);
+	ret = blkio_alloc_set_blkg_stats(&tg->blkg);
 
 	if (ret) {
 		kfree(tg);
@@ -305,7 +373,7 @@ throtl_grp *throtl_find_tg(struct throtl
 
 static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 {
-	struct throtl_grp *tg = NULL, *__tg = NULL;
+	struct throtl_grp *tg = NULL;
 	struct blkio_cgroup *blkcg;
 	struct request_queue *q = td->queue;
 
@@ -321,46 +389,12 @@ static struct throtl_grp * throtl_get_tg
 		return tg;
 	}
 
-	/*
-	 * Need to allocate a group. Allocation of group also needs allocation
-	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
-	 * we need to drop rcu lock and queue_lock before we call alloc.
-	 */
-	rcu_read_unlock();
-	spin_unlock_irq(q->queue_lock);
-
-	tg = throtl_alloc_tg(td);
-
-	/* Group allocated and queue is still alive. take the lock */
-	spin_lock_irq(q->queue_lock);
-
-	/* Make sure @q is still alive */
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
-		kfree(tg);
-		return NULL;
-	}
-
-	/*
-	 * Initialize the new group. After sleeping, read the blkcg again.
-	 */
-	rcu_read_lock();
-	blkcg = task_blkio_cgroup(current);
-
-	/*
-	 * If some other thread already allocated the group while we were
-	 * not holding queue lock, free up the group
-	 */
-	__tg = throtl_find_tg(td, blkcg);
-
-	if (__tg) {
-		kfree(tg);
-		rcu_read_unlock();
-		return __tg;
-	}
+	tg = throtl_alloc_tg_async(td);
 
 	/* Group allocation failed. Account the IO to root group */
 	if (!tg) {
 		tg = td->root_tg;
+		rcu_read_unlock();
 		return tg;
 	}
 
@@ -1254,7 +1288,7 @@ int blk_throtl_init(struct request_queue
 
 	/* alloc and Init root group. */
 	td->queue = q;
-	tg = throtl_alloc_tg(td);
+	tg = throtl_alloc_tg_sync(td);
 
 	if (!tg) {
 		kfree(td);
Index: block/blk-cgroup.c
===================================================================
--- block/blk-cgroup.c.orig	2011-12-15 20:31:05.000000000 -0500
+++ block/blk-cgroup.c	2011-12-15 20:32:15.000000000 -0500
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
@@ -465,9 +471,11 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_merg
 
 /*
  * This function allocates the per cpu stats for blkio_group. Should be called
- * from sleepable context as alloc_per_cpu() requires that.
+ * from sleepable context as alloc_per_cpu() requires that. percpu alloc does
+ * not take any flags and does GFP_KERNEL allocations. Don't use it from
+ * IO submission path which usually might require GFP_NOIO.
  */
-int blkio_alloc_blkg_stats(struct blkio_group *blkg)
+int blkio_alloc_set_blkg_stats(struct blkio_group *blkg)
 {
 	/* Allocate memory for per cpu stats */
 	blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
@@ -475,7 +483,14 @@ int blkio_alloc_blkg_stats(struct blkio_
 		return -ENOMEM;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats);
+EXPORT_SYMBOL_GPL(blkio_alloc_set_blkg_stats);
+
+void* blkio_alloc_blkg_stats_pcpu(void)
+{
+	/* Allocate memory for per cpu stats */
+	return alloc_percpu(struct blkio_group_stats_cpu);
+}
+EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats_pcpu);
 
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
@@ -551,6 +566,12 @@ static void blkio_reset_stats_cpu(struct
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
@@ -673,6 +694,10 @@ static uint64_t blkio_read_stat_cpu(stru
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
--- block/blk-cgroup.h.orig	2011-12-15 20:31:05.000000000 -0500
+++ block/blk-cgroup.h	2011-12-15 20:32:15.000000000 -0500
@@ -310,7 +310,12 @@ extern struct blkio_cgroup *task_blkio_c
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	struct blkio_group *blkg, void *key, dev_t dev,
 	enum blkio_policy_id plid);
-extern int blkio_alloc_blkg_stats(struct blkio_group *blkg);
+extern int blkio_alloc_set_blkg_stats(struct blkio_group *blkg);
+extern void* blkio_alloc_blkg_stats_pcpu(void);
+
+#define blkio_cmpxchg_blkg_stats(blkg, oldval, newval) \
+	cmpxchg((unsigned long *)&(blkg)->stats_cpu, oldval, newval);
+
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
@@ -338,7 +343,7 @@ static inline void blkiocg_add_blkio_gro
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid) {}
 
-static inline int blkio_alloc_blkg_stats(struct blkio_group *blkg) { return 0; }
+static inline int blkio_alloc_set_blkg_stats(struct blkio_group *blkg) { return 0; }
 
 static inline int
 blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
Index: block/cfq-iosched.c
===================================================================
--- block/cfq-iosched.c.orig	2011-12-15 20:31:05.000000000 -0500
+++ block/cfq-iosched.c	2011-12-15 20:32:15.000000000 -0500
@@ -209,7 +209,12 @@ struct cfq_group {
 	struct blkio_group blkg;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
-	int ref;
+	/*
+	 * blkg per cpu stat allocation code will need to put reference
+	 * without having queue lock. Hence keep it atomic.
+	 */
+	atomic_t ref;
+	struct work_struct stat_alloc_work;
 #endif
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
@@ -1012,6 +1017,9 @@ static void cfq_group_served(struct cfq_
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+static void cfq_put_cfqg(struct cfq_group *cfqg);
+static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg);
+
 static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 {
 	if (blkg)
@@ -1054,6 +1062,52 @@ static void cfq_init_add_cfqg_lists(stru
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
 }
 
+static inline void cfq_check_schedule_pcpu_stat_alloc(struct cfq_group *cfqg) {
+	if (cfqg->blkg.stats_cpu != NULL)
+		return;
+
+	/*
+	 * Schedule the group per cpu stat allocation through worker
+	 * thread
+	 */
+	cfq_ref_get_cfqg(cfqg);
+	if (!schedule_work(&cfqg->stat_alloc_work)) {
+		/* Work is already scheduled by somebody */
+		cfq_put_cfqg(cfqg);
+	}
+}
+
+/* No locks taken. A reference to cfq_group taken before invocation */
+static void cfqg_stat_alloc_fn(struct work_struct *work)
+{
+	struct cfq_group *cfqg = container_of(work, struct cfq_group,
+						stat_alloc_work);
+	void *stat_ptr = NULL;
+	unsigned long ret;
+
+	stat_ptr = blkio_alloc_blkg_stats_pcpu();
+
+	if (stat_ptr == NULL) {
+		/*
+		 * Memory allocation failed. Try again. Should an upper limit
+		 * be put on number of retries?
+		 */
+		cfq_check_schedule_pcpu_stat_alloc(cfqg);
+		cfq_put_cfqg(cfqg);
+		return;
+	}
+
+	ret = blkio_cmpxchg_blkg_stats(&cfqg->blkg, 0,
+					(unsigned long)stat_ptr);
+
+	if (ret != (unsigned long)stat_ptr) {
+		/* Somebody else got to it first */
+		free_percpu(cfqg->blkg.stats_cpu);
+	}
+
+	cfq_put_cfqg(cfqg);
+}
+
 /*
  * Should be called from sleepable context. No request queue lock as per
  * cpu stats are allocated dynamically and alloc_percpu needs to be called
@@ -1062,7 +1116,7 @@ static void cfq_init_add_cfqg_lists(stru
 static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_group *cfqg = NULL;
-	int i, j, ret;
+	int i, j;
 	struct cfq_rb_root *st;
 
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
@@ -1072,6 +1126,7 @@ static struct cfq_group * cfq_alloc_cfqg
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
+	INIT_WORK(&cfqg->stat_alloc_work, cfqg_stat_alloc_fn);
 
 	cfqg->ttime.last_end_request = jiffies;
 
@@ -1081,14 +1136,9 @@ static struct cfq_group * cfq_alloc_cfqg
 	 * elevator which will be dropped by either elevator exit
 	 * or cgroup deletion path depending on who is exiting first.
 	 */
-	cfqg->ref = 1;
-
-	ret = blkio_alloc_blkg_stats(&cfqg->blkg);
-	if (ret) {
-		kfree(cfqg);
-		return NULL;
-	}
+	atomic_set(&cfqg->ref, 1);
 
+	cfq_check_schedule_pcpu_stat_alloc(cfqg);
 	return cfqg;
 }
 
@@ -1124,8 +1174,7 @@ cfq_find_cfqg(struct cfq_data *cfqd, str
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
 	struct blkio_cgroup *blkcg;
-	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
-	struct request_queue *q = cfqd->queue;
+	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
@@ -1135,41 +1184,13 @@ static struct cfq_group *cfq_get_cfqg(st
 		return cfqg;
 	}
 
-	/*
-	 * Need to allocate a group. Allocation of group also needs allocation
-	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
-	 * we need to drop rcu lock and queue_lock before we call alloc.
-	 *
-	 * Not taking any queue reference here and assuming that queue is
-	 * around by the time we return. CFQ queue allocation code does
-	 * the same. It might be racy though.
-	 */
-
-	rcu_read_unlock();
-	spin_unlock_irq(q->queue_lock);
-
 	cfqg = cfq_alloc_cfqg(cfqd);
-
-	spin_lock_irq(q->queue_lock);
-
-	rcu_read_lock();
-	blkcg = task_blkio_cgroup(current);
-
-	/*
-	 * If some other thread already allocated the group while we were
-	 * not holding queue lock, free up the group
-	 */
-	__cfqg = cfq_find_cfqg(cfqd, blkcg);
-
-	if (__cfqg) {
-		kfree(cfqg);
+	if (!cfqg) {
+		cfqg = &cfqd->root_group;
 		rcu_read_unlock();
-		return __cfqg;
+		return cfqg;
 	}
 
-	if (!cfqg)
-		cfqg = &cfqd->root_group;
-
 	cfq_init_add_cfqg_lists(cfqd, cfqg, blkcg);
 	rcu_read_unlock();
 	return cfqg;
@@ -1177,7 +1198,7 @@ static struct cfq_group *cfq_get_cfqg(st
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 {
-	cfqg->ref++;
+	atomic_inc(&cfqg->ref);
 	return cfqg;
 }
 
@@ -1189,7 +1210,7 @@ static void cfq_link_cfqq_cfqg(struct cf
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
-	cfqq->cfqg->ref++;
+	atomic_inc(&cfqq->cfqg->ref);
 }
 
 static void cfq_put_cfqg(struct cfq_group *cfqg)
@@ -1197,9 +1218,8 @@ static void cfq_put_cfqg(struct cfq_grou
 	struct cfq_rb_root *st;
 	int i, j;
 
-	BUG_ON(cfqg->ref <= 0);
-	cfqg->ref--;
-	if (cfqg->ref)
+	BUG_ON(atomic_read(&cfqg->ref) <= 0);
+	if (!atomic_dec_and_test(&cfqg->ref))
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
@@ -4025,6 +4045,7 @@ static void *cfq_init_queue(struct reque
 	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+	INIT_WORK(&cfqg->stat_alloc_work, cfqg_stat_alloc_fn);
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
 	 * all groups on cfqd->cfqg_list are being deleted during queue exit.
@@ -4032,9 +4053,9 @@ static void *cfq_init_queue(struct reque
 	 * group as it is statically allocated and gets destroyed when
 	 * throtl_data goes away.
 	 */
-	cfqg->ref = 2;
+	atomic_set(&cfqg->ref, 2);
 
-	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
+	if (blkio_alloc_set_blkg_stats(&cfqg->blkg)) {
 		kfree(cfqg);
 		kfree(cfqd);
 		return NULL;
