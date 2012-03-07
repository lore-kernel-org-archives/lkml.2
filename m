Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab2CGDtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:49:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab2CGDtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:49:20 -0500
X-IronPort-AV: E=Sophos;i="4.73,543,1325433600"; 
   d="scan'208";a="4477084"
Message-ID: <4F56DBDA.1020608@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 11:54:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [RFC PATCH 5/5 single-thread-version] implement per-domain single-thread
 state machine call_srcu()
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com> <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com> <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 11:47:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 11:47:23,
	Serialize complete at 2012-03-07 11:47:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is on the top of the 4 previous patches(1/6, 2/6, 3/6, 4/6).

o	state machine is light way and single-threaded, it is preemptible when checking.

o	state machine is a work_struct. So, there is no thread occupied
	by SRCU when the srcu is not actived(no callback). And it does
	not sleep(avoid to occupy a thread when sleep).

o	state machine is the only thread can flip/check/write(*) the srcu_struct,
	so we don't need any mutex.
	(write(*): except ->per_cpu_ref, ->running, ->batch_queue)

o	synchronize_srcu() is always call call_srcu().
	synchronize_srcu_expedited() is also.
	It is OK for mb()-based srcu are extremely fast.

o	In current kernel, we can expect that there are only 1 callback per gp.
	so callback is probably called in the same CPU when it is queued.

The trip of a callback:
	1) ->batch_queue when call_srcu()

	2) ->batch_check0 when try to do check_zero

	3) ->batch_check1 after finish its first check_zero and the flip

	4) ->batch_done after finish its second check_zero

The current requirement of the callbacks:
	The callback will be called inside process context.
	The callback should be fast without any sleeping path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |    2 +-
 include/linux/srcu.h     |   28 +++++-
 kernel/rcupdate.c        |   24 ++++-
 kernel/rcutorture.c      |   44 ++++++++-
 kernel/srcu.c            |  238 ++++++++++++++++++++++++++++++++-------------
 5 files changed, 259 insertions(+), 77 deletions(-)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9372174..d98eab2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -222,7 +222,7 @@ extern void rcu_irq_exit(void);
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
  */
 
-typedef void call_rcu_func_t(struct rcu_head *head,
+typedef void (*call_rcu_func_t)(struct rcu_head *head,
 			     void (*func)(struct rcu_head *head));
 void wait_rcu_gp(call_rcu_func_t crf);
 
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index df8f5f7..56cb774 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -29,6 +29,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/workqueue.h>
 
 struct srcu_struct_array {
 	unsigned long c[2];
@@ -39,10 +40,23 @@ struct srcu_struct_array {
 #define SRCU_REF_MASK		(ULONG_MAX >> SRCU_USAGE_BITS)
 #define SRCU_USAGE_COUNT	(SRCU_REF_MASK + 1)
 
+struct rcu_batch {
+	struct rcu_head *head, **tail;
+};
+
 struct srcu_struct {
 	unsigned completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
-	struct mutex mutex;
+	spinlock_t queue_lock; /* protect ->batch_queue, ->running */
+	bool running;
+	/* callbacks just queued */
+	struct rcu_batch batch_queue;
+	/* callbacks try to do the first check_zero */
+	struct rcu_batch batch_check0;
+	/* callbacks done with the first check_zero and the flip */
+	struct rcu_batch batch_check1;
+	struct rcu_batch batch_done;
+	struct delayed_work work;
 	unsigned long snap[NR_CPUS];
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
@@ -67,12 +81,24 @@ int init_srcu_struct(struct srcu_struct *sp);
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/* draft
+ * queue callbacks which will be invoked after grace period.
+ * The callback will be called inside process context.
+ * The callback should be fast without any sleeping path.
+ */
+void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
+		void (*func)(struct rcu_head *head));
+
+typedef void (*call_srcu_func_t)(struct srcu_struct *sp, struct rcu_head *head,
+		void (*func)(struct rcu_head *head));
+void __wait_srcu_gp(struct srcu_struct *sp, call_srcu_func_t crf);
 void cleanup_srcu_struct(struct srcu_struct *sp);
 int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
 void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
+void srcu_barrier(struct srcu_struct *sp);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a86f174..f9b551f 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/hardirq.h>
+#include <linux/srcu.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
@@ -123,20 +124,39 @@ static void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
-void wait_rcu_gp(call_rcu_func_t crf)
+static void __wait_rcu_gp(void *domain, void *func)
 {
 	struct rcu_synchronize rcu;
 
 	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
+
 	/* Will wake me after RCU finished. */
-	crf(&rcu.head, wakeme_after_rcu);
+	if (!domain) {
+		call_rcu_func_t crf = func;
+		crf(&rcu.head, wakeme_after_rcu);
+	} else {
+		call_srcu_func_t crf = func;
+		crf(domain, &rcu.head, wakeme_after_rcu);
+	}
+
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
 	destroy_rcu_head_on_stack(&rcu.head);
 }
+
+void wait_rcu_gp(call_rcu_func_t crf)
+{
+	__wait_rcu_gp(NULL, crf);
+}
 EXPORT_SYMBOL_GPL(wait_rcu_gp);
 
+/* srcu.c internel */
+void __wait_srcu_gp(struct srcu_struct *sp, call_srcu_func_t crf)
+{
+	__wait_rcu_gp(sp, crf);
+}
+
 #ifdef CONFIG_PROVE_RCU
 /*
  * wrapper function to avoid #include problems.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 54e5724..40d24d0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -623,6 +623,11 @@ static int srcu_torture_completed(void)
 	return srcu_batches_completed(&srcu_ctl);
 }
 
+static void srcu_torture_deferred_free(struct rcu_torture *rp)
+{
+	call_srcu(&srcu_ctl, &rp->rtort_rcu, rcu_torture_cb);
+}
+
 static void srcu_torture_synchronize(void)
 {
 	synchronize_srcu(&srcu_ctl);
@@ -652,7 +657,7 @@ static struct rcu_torture_ops srcu_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
 	.call		= NULL,
 	.cb_barrier	= NULL,
@@ -660,6 +665,21 @@ static struct rcu_torture_ops srcu_ops = {
 	.name		= "srcu"
 };
 
+static struct rcu_torture_ops srcu_sync_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_sync"
+};
+
 static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
 {
 	return srcu_read_lock_raw(&srcu_ctl);
@@ -677,7 +697,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
 	.call		= NULL,
 	.cb_barrier	= NULL,
@@ -685,6 +705,21 @@ static struct rcu_torture_ops srcu_raw_ops = {
 	.name		= "srcu_raw"
 };
 
+static struct rcu_torture_ops srcu_raw_sync_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock_raw,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock_raw,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_raw_sync"
+};
+
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -1673,7 +1708,7 @@ static int rcu_torture_barrier_init(void)
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
 		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
-						   (void *)i,
+						   (void *)(long)i,
 						   "rcu_torture_barrier_cbs");
 		if (IS_ERR(barrier_cbs_tasks[i])) {
 			ret = PTR_ERR(barrier_cbs_tasks[i]);
@@ -1857,7 +1892,8 @@ rcu_torture_init(void)
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_raw_ops, &srcu_expedited_ops,
+		  &srcu_ops, &srcu_sync_ops, &srcu_raw_ops,
+		  &srcu_raw_sync_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
diff --git a/kernel/srcu.c b/kernel/srcu.c
index d101ed5..532f890 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,10 +34,60 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
+static inline void rcu_batch_init(struct rcu_batch *b)
+{
+	b->head = NULL;
+	b->tail = &b->head;
+}
+
+static inline void rcu_batch_queue(struct rcu_batch *b, struct rcu_head *head)
+{
+	*b->tail = head;
+	b->tail = &head->next;
+}
+
+static inline bool rcu_batch_empty(struct rcu_batch *b)
+{
+	return b->tail == &b->head;
+}
+
+static inline struct rcu_head *rcu_batch_dequeue(struct rcu_batch *b)
+{
+	struct rcu_head *head;
+
+	if (rcu_batch_empty(b))
+		return NULL;
+
+	head = b->head;
+	b->head = head->next;
+	if (b->tail == &head->next)
+		rcu_batch_init(b);
+
+	return head;
+}
+
+static inline void rcu_batch_move(struct rcu_batch *to, struct rcu_batch *from)
+{
+	if (!rcu_batch_empty(from)) {
+		*to->tail = from->head;
+		to->tail = from->tail;
+		rcu_batch_init(from);
+	}
+}
+
+/* single-thread state-machine */
+static void process_srcu(struct work_struct *work);
+
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
-	mutex_init(&sp->mutex);
+	spin_lock_init(&sp->queue_lock);
+	sp->running = false;
+	rcu_batch_init(&sp->batch_queue);
+	rcu_batch_init(&sp->batch_check0);
+	rcu_batch_init(&sp->batch_check1);
+	rcu_batch_init(&sp->batch_done);
+	INIT_DELAYED_WORK(&sp->work, process_srcu);
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
 	return sp->per_cpu_ref ? 0 : -ENOMEM;
 }
@@ -254,11 +304,9 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  * we repeatedly block for 1-millisecond time periods.  This approach
  * has done well in testing, so there is no need for a config parameter.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY	5
-#define SYNCHRONIZE_SRCU_TRYCOUNT	2
-#define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
+#define SRCU_RETRY_CHECK_DELAY	5
 
-static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
+static bool try_check_zero(struct srcu_struct *sp, int idx, int trycount)
 {
 	/*
 	 * If a reader fetches the index before the ->completed increment,
@@ -271,19 +319,12 @@ static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
 	 */
 	smp_mb(); /* D */
 
-	/*
-	 * SRCU read-side critical sections are normally short, so wait
-	 * a small amount of time before possibly blocking.
-	 */
-	if (!srcu_readers_active_idx_check(sp, idx)) {
-		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
-		while (!srcu_readers_active_idx_check(sp, idx)) {
-			if (trycount > 0) {
-				trycount--;
-				udelay(SYNCHRONIZE_SRCU_READER_DELAY);
-			} else
-				schedule_timeout_interruptible(1);
-		}
+	for (;;) {
+		if (srcu_readers_active_idx_check(sp, idx))
+			break;
+		if (--trycount <= 0)
+			return false;
+		udelay(SRCU_RETRY_CHECK_DELAY);
 	}
 
 	/*
@@ -297,6 +338,8 @@ static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
 	 * the next flipping.
 	 */
 	smp_mb(); /* E */
+
+	return true;
 }
 
 /*
@@ -308,10 +351,27 @@ static void srcu_flip(struct srcu_struct *sp)
 	ACCESS_ONCE(sp->completed)++;
 }
 
+void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
+		void (*func)(struct rcu_head *head))
+{
+	unsigned long flags;
+
+	head->next = NULL;
+	head->func = func;
+	spin_lock_irqsave(&sp->queue_lock, flags);
+	rcu_batch_queue(&sp->batch_queue, head);
+	if (!sp->running) {
+		sp->running = true;
+		queue_delayed_work(system_nrt_wq, &sp->work, 0);
+	}
+	spin_unlock_irqrestore(&sp->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(call_srcu);
+
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
+static void __synchronize_srcu(struct srcu_struct *sp)
 {
 	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
 			   !lock_is_held(&rcu_bh_lock_map) &&
@@ -319,54 +379,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
-	mutex_lock(&sp->mutex);
-
-	/*
-	 * Suppose that during the previous grace period, a reader
-	 * picked up the old value of the index, but did not increment
-	 * its counter until after the previous instance of
-	 * __synchronize_srcu() did the counter summation and recheck.
-	 * That previous grace period was OK because the reader did
-	 * not start until after the grace period started, so the grace
-	 * period was not obligated to wait for that reader.
-	 *
-	 * However, the current SRCU grace period does have to wait for
-	 * that reader.  This is handled by invoking wait_idx() on the
-	 * non-active set of counters (hence sp->completed - 1).  Once
-	 * wait_idx() returns, we know that all readers that picked up
-	 * the old value of ->completed and that already incremented their
-	 * counter will have completed.
-	 *
-	 * But what about readers that picked up the old value of
-	 * ->completed, but -still- have not managed to increment their
-	 * counter?  We do not need to wait for those readers, because
-	 * they will have started their SRCU read-side critical section
-	 * after the current grace period starts.
-	 *
-	 * Because it is unlikely that readers will be preempted between
-	 * fetching ->completed and incrementing their counter, wait_idx()
-	 * will normally not need to wait.
-	 */
-	wait_idx(sp, (sp->completed - 1) & 0x1, trycount);
-
-	/*
-	 * Now that wait_idx() has waited for the really old readers,
-	 *
-	 * Flip the readers' index by incrementing ->completed, then wait
-	 * until there are no more readers using the counters referenced by
-	 * the old index value.  (Recall that the index is the bottom bit
-	 * of ->completed.)
-	 *
-	 * Of course, it is possible that a reader might be delayed for the
-	 * full duration of flip_idx_and_wait() between fetching the
-	 * index and incrementing its counter.  This possibility is handled
-	 * by the next __synchronize_srcu() invoking wait_idx() for such
-	 * readers before starting a new grace period.
-	 */
-	srcu_flip(sp);
-	wait_idx(sp, (sp->completed - 1) & 0x1, trycount);
-
-	mutex_unlock(&sp->mutex);
+	__wait_srcu_gp(sp, call_srcu);
 }
 
 /**
@@ -385,7 +398,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
+	__synchronize_srcu(sp);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
@@ -406,10 +419,16 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_EXP_TRYCOUNT);
+	__synchronize_srcu(sp);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
+void srcu_barrier(struct srcu_struct *sp)
+{
+	__synchronize_srcu(sp);
+}
+EXPORT_SYMBOL_GPL(srcu_barrier);
+
 /**
  * srcu_batches_completed - return batches completed.
  * @sp: srcu_struct on which to report batch completion.
@@ -423,3 +442,84 @@ long srcu_batches_completed(struct srcu_struct *sp)
 	return sp->completed;
 }
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
+
+#define SRCU_CALLBACK_BATCH	10
+#define SRCU_INTERVAL		1
+
+static void srcu_collect_new(struct srcu_struct *sp)
+{
+	if (!rcu_batch_empty(&sp->batch_queue)) {
+		spin_lock_irq(&sp->queue_lock);
+		rcu_batch_move(&sp->batch_check0, &sp->batch_queue);
+		spin_unlock_irq(&sp->queue_lock);
+	}
+}
+
+static void srcu_advance_batches(struct srcu_struct *sp)
+{
+	int idx = 1 - (sp->completed & 0x1UL);
+
+	/*
+	 * SRCU read-side critical sections are normally short, so check
+	 * twice after a flip.
+	 */
+	if (!rcu_batch_empty(&sp->batch_check1) ||
+	    !rcu_batch_empty(&sp->batch_check0)) {
+		if (try_check_zero(sp, idx, 1)) {
+			rcu_batch_move(&sp->batch_done, &sp->batch_check1);
+			rcu_batch_move(&sp->batch_check1, &sp->batch_check0);
+			if (!rcu_batch_empty(&sp->batch_check1)) {
+				srcu_flip(sp);
+				if (try_check_zero(sp, 1 - idx, 2)) {
+					rcu_batch_move(&sp->batch_done,
+						&sp->batch_check1);
+				}
+			}
+		}
+	}
+}
+
+static void srcu_invoke_callbacks(struct srcu_struct *sp)
+{
+	int i;
+	struct rcu_head *head;
+
+	for (i = 0; i < SRCU_CALLBACK_BATCH; i++) {
+		head = rcu_batch_dequeue(&sp->batch_done);
+		if (!head)
+			break;
+		head->func(head);
+	}
+}
+
+static void srcu_reschedule(struct srcu_struct *sp)
+{
+	bool running = true;
+
+	if (rcu_batch_empty(&sp->batch_done) &&
+	    rcu_batch_empty(&sp->batch_check1) &&
+	    rcu_batch_empty(&sp->batch_check0) &&
+	    rcu_batch_empty(&sp->batch_queue)) {
+		spin_lock_irq(&sp->queue_lock);
+		if (rcu_batch_empty(&sp->batch_queue)) {
+			sp->running = false;
+			running = false;
+		}
+		spin_unlock_irq(&sp->queue_lock);
+	}
+
+	if (running)
+		queue_delayed_work(system_nrt_wq, &sp->work, SRCU_INTERVAL);
+}
+
+static void process_srcu(struct work_struct *work)
+{
+	struct srcu_struct *sp;
+
+	sp = container_of(work, struct srcu_struct, work.work);
+
+	srcu_collect_new(sp);
+	srcu_advance_batches(sp);
+	srcu_invoke_callbacks(sp);
+	srcu_reschedule(sp);
+}



