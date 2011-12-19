Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1LSR13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:27:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1LSR10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:27:26 -0500
Date: Mon, 19 Dec 2011 12:27:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Nate Custer <nate@cpanel.net>
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111219172717.GB7175@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 03:25:48PM -0600, Nate Custer wrote:
> 
> On Dec 16, 2011, at 2:29 PM, Vivek Goyal wrote:
> > Thanks for testing it Nate. I did some debugging and found out that patch
> > is doing double free on per cpu pointer hence the crash you are running
> > into. I could reproduce this problem on my box. It is just a matter of
> > doing rmdir on the blkio cgroup.
> > 
> > I understood the cmpxchg() semantics wrong. I have fixed it now and
> > no crashes on directory removal. Can you please give this version a
> > try.
> > 
> > Thanks
> > Vivek
> 
> After 24 hours of stress testing the machine remains up and working without issue. I will continue to test it, but am reasonably confident that this patch resolves my issue.
> 

Hi Nate,

I have come up with final version of the patch. This time I have used non
rentrant work queue to queue the stat alloc work. This also gets rid of
cmpxchg code as there is only one writer at a time. There are couple of
other small cleanups.

Can you please give patch also a try to make sure I have not broken
something while doing changes.

This version is based on 3.2-rc6. Once you confirm the results, I will
rebase it on top of "linux-block for-3.3/core" and post it to Jens for
inclusion.

Thanks
Vivek

Block cgroup currently allocates percpu data for some stats. This allocation
is happening in IO submission path which can recurse in IO stack.

Percpu allocation API does not take any allocation flags as input, hence
to avoid the deadlock problem under memory pressure, alloc per cpu data
from a worker thread context.

Only side affect of delayed allocation is that we will lose the blkio cgroup
stats for that group a small duration.

In case per cpu memory allocation fails, worker thread re-arms the work
with a delay of 1 second.

This patch is generated on top of 3.2-rc6

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reported-by: Nate Custer <nate@cpanel.net>
Tested-by: Nate Custer <nate@cpanel.net>
---
 block/blk-cgroup.c   |   31 ++++++++++++-
 block/blk-cgroup.h   |   11 +++-
 block/blk-throttle.c |  115 ++++++++++++++++++++++++++++++++-------------------
 block/cfq-iosched.c  |  111 +++++++++++++++++++++++++++----------------------
 4 files changed, 173 insertions(+), 95 deletions(-)

Index: block/blk-throttle.c
===================================================================
--- block/blk-throttle.c.orig	2011-12-19 23:10:53.000000000 -0500
+++ block/blk-throttle.c	2011-12-19 23:11:14.000000000 -0500
@@ -81,6 +81,7 @@ struct throtl_grp {
 	int limits_changed;
 
 	struct rcu_head rcu_head;
+	struct delayed_work stat_alloc_work;
 };
 
 struct throtl_data
@@ -159,6 +160,12 @@ static void throtl_free_tg(struct rcu_he
 	struct throtl_grp *tg;
 
 	tg = container_of(head, struct throtl_grp, rcu_head);
+
+	/*
+	 * delayed per cpu allocation should be visible here due to
+	 * barrier guarantees offered by atomic_dec_and_test() called
+	 * during dropping reference.
+	 */
 	free_percpu(tg->blkg.stats_cpu);
 	kfree(tg);
 }
@@ -181,6 +188,48 @@ static void throtl_put_tg(struct throtl_
 	call_rcu(&tg->rcu_head, throtl_free_tg);
 }
 
+static inline void throtl_schedule_pcpu_stat_alloc(struct throtl_grp *tg,
+				unsigned long delay) {
+	WARN_ON(tg->blkg.stats_cpu != NULL);
+
+	/*
+	 * Schedule the group per cpu stat allocation through worker
+	 * thread
+	 */
+	throtl_ref_get_tg(tg);
+
+	/* queue work on non-rentrant work queue */
+	queue_delayed_work(system_nrt_wq, &tg->stat_alloc_work, delay);
+}
+
+/* No locks taken. A reference to throtl_grp taken before invocation */
+static void tg_stat_alloc_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct throtl_grp *tg = container_of(dwork, struct throtl_grp,
+						stat_alloc_work);
+	void *stat_ptr = NULL;
+
+	stat_ptr = blkio_alloc_blkg_stats_pcpu();
+
+	if (stat_ptr == NULL) {
+		/*
+		 * If memory allocation failed, try again with delay of 1s
+		 * FIXME: Put an upper limit on number of retries?
+		 */
+		throtl_schedule_pcpu_stat_alloc(tg, HZ);
+		throtl_put_tg(tg);
+		return;
+	}
+
+	/*
+	 * There is only one writer at a time and that is worker thread. Hence
+	 * no synchronization should be required.
+	 */
+	blkio_set_blkg_pcpu_stats(&tg->blkg, stat_ptr);
+	throtl_put_tg(tg);
+}
+
 static void throtl_init_group(struct throtl_grp *tg)
 {
 	INIT_HLIST_NODE(&tg->tg_node);
@@ -188,6 +237,7 @@ static void throtl_init_group(struct thr
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
 	tg->limits_changed = false;
+	INIT_DELAYED_WORK(&tg->stat_alloc_work, tg_stat_alloc_fn);
 
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
@@ -263,8 +313,25 @@ static void throtl_init_add_tg_lists(str
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
+	throtl_schedule_pcpu_stat_alloc(tg, 0);
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
@@ -273,7 +340,7 @@ static struct throtl_grp *throtl_alloc_t
 	if (!tg)
 		return NULL;
 
-	ret = blkio_alloc_blkg_stats(&tg->blkg);
+	ret = blkio_alloc_set_blkg_stats(&tg->blkg);
 
 	if (ret) {
 		kfree(tg);
@@ -305,7 +372,7 @@ throtl_grp *throtl_find_tg(struct throtl
 
 static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 {
-	struct throtl_grp *tg = NULL, *__tg = NULL;
+	struct throtl_grp *tg = NULL;
 	struct blkio_cgroup *blkcg;
 	struct request_queue *q = td->queue;
 
@@ -321,46 +388,12 @@ static struct throtl_grp * throtl_get_tg
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
 
@@ -1254,7 +1287,7 @@ int blk_throtl_init(struct request_queue
 
 	/* alloc and Init root group. */
 	td->queue = q;
-	tg = throtl_alloc_tg(td);
+	tg = throtl_alloc_tg_sync(td);
 
 	if (!tg) {
 		kfree(td);
Index: block/blk-cgroup.c
===================================================================
--- block/blk-cgroup.c.orig	2011-12-19 23:10:53.000000000 -0500
+++ block/blk-cgroup.c	2011-12-19 23:11:14.000000000 -0500
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
--- block/blk-cgroup.h.orig	2011-12-19 23:06:11.000000000 -0500
+++ block/blk-cgroup.h	2011-12-19 23:11:14.000000000 -0500
@@ -310,7 +310,14 @@ extern struct blkio_cgroup *task_blkio_c
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	struct blkio_group *blkg, void *key, dev_t dev,
 	enum blkio_policy_id plid);
-extern int blkio_alloc_blkg_stats(struct blkio_group *blkg);
+extern int blkio_alloc_set_blkg_stats(struct blkio_group *blkg);
+extern void* blkio_alloc_blkg_stats_pcpu(void);
+
+static inline void blkio_set_blkg_pcpu_stats(struct blkio_group *blkg, void *ptr)
+{
+	blkg->stats_cpu = ptr;
+}
+
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
@@ -338,7 +345,7 @@ static inline void blkiocg_add_blkio_gro
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid) {}
 
-static inline int blkio_alloc_blkg_stats(struct blkio_group *blkg) { return 0; }
+static inline int blkio_alloc_set_blkg_stats(struct blkio_group *blkg) { return 0; }
 
 static inline int
 blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
Index: block/cfq-iosched.c
===================================================================
--- block/cfq-iosched.c.orig	2011-12-19 23:10:53.000000000 -0500
+++ block/cfq-iosched.c	2011-12-19 23:11:14.000000000 -0500
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
+	struct delayed_work stat_alloc_work;
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
@@ -1054,6 +1062,44 @@ static void cfq_init_add_cfqg_lists(stru
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
 }
 
+static inline void cfq_schedule_pcpu_stat_alloc(struct cfq_group *cfqg,
+				unsigned long delay) {
+	WARN_ON(cfqg->blkg.stats_cpu != NULL);
+
+	/*
+	 * Schedule the group per cpu stat allocation through worker
+	 * thread
+	 */
+	cfq_ref_get_cfqg(cfqg);
+
+	/* queue work on non-rentrant work queue */
+	queue_delayed_work(system_nrt_wq, &cfqg->stat_alloc_work, delay);
+}
+
+/* No locks taken. A reference to cfq_group taken before invocation */
+static void cfqg_stat_alloc_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct cfq_group *cfqg = container_of(dwork, struct cfq_group,
+						stat_alloc_work);
+	void *stat_ptr = NULL;
+
+	stat_ptr = blkio_alloc_blkg_stats_pcpu();
+
+	if (stat_ptr == NULL) {
+		/*
+		 * Memory allocation failed. Try again. Should an upper limit
+		 * be put on number of retries?
+		 */
+		cfq_schedule_pcpu_stat_alloc(cfqg, HZ);
+		cfq_put_cfqg(cfqg);
+		return;
+	}
+
+	blkio_set_blkg_pcpu_stats(&cfqg->blkg, stat_ptr);
+	cfq_put_cfqg(cfqg);
+}
+
 /*
  * Should be called from sleepable context. No request queue lock as per
  * cpu stats are allocated dynamically and alloc_percpu needs to be called
@@ -1062,7 +1108,7 @@ static void cfq_init_add_cfqg_lists(stru
 static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_group *cfqg = NULL;
-	int i, j, ret;
+	int i, j;
 	struct cfq_rb_root *st;
 
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
@@ -1072,6 +1118,7 @@ static struct cfq_group * cfq_alloc_cfqg
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
+	INIT_DELAYED_WORK(&cfqg->stat_alloc_work, cfqg_stat_alloc_fn);
 
 	cfqg->ttime.last_end_request = jiffies;
 
@@ -1081,14 +1128,9 @@ static struct cfq_group * cfq_alloc_cfqg
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
 
+	cfq_schedule_pcpu_stat_alloc(cfqg, 0);
 	return cfqg;
 }
 
@@ -1124,8 +1166,7 @@ cfq_find_cfqg(struct cfq_data *cfqd, str
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
 	struct blkio_cgroup *blkcg;
-	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
-	struct request_queue *q = cfqd->queue;
+	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
@@ -1135,41 +1176,13 @@ static struct cfq_group *cfq_get_cfqg(st
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
@@ -1177,7 +1190,7 @@ static struct cfq_group *cfq_get_cfqg(st
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 {
-	cfqg->ref++;
+	atomic_inc(&cfqg->ref);
 	return cfqg;
 }
 
@@ -1189,7 +1202,7 @@ static void cfq_link_cfqq_cfqg(struct cf
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
-	cfqq->cfqg->ref++;
+	atomic_inc(&cfqq->cfqg->ref);
 }
 
 static void cfq_put_cfqg(struct cfq_group *cfqg)
@@ -1197,9 +1210,8 @@ static void cfq_put_cfqg(struct cfq_grou
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
@@ -4032,6 +4044,7 @@ static void *cfq_init_queue(struct reque
 	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+	INIT_DELAYED_WORK(&cfqg->stat_alloc_work, cfqg_stat_alloc_fn);
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
 	 * all groups on cfqd->cfqg_list are being deleted during queue exit.
@@ -4039,9 +4052,9 @@ static void *cfq_init_queue(struct reque
 	 * group as it is statically allocated and gets destroyed when
 	 * throtl_data goes away.
 	 */
-	cfqg->ref = 2;
+	atomic_set(&cfqg->ref, 2);
 
-	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
+	if (blkio_alloc_set_blkg_stats(&cfqg->blkg)) {
 		kfree(cfqg);
 
 		spin_lock(&cic_index_lock);
