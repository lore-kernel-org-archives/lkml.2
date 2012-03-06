Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2CFJx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1744 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965161Ab2CFJxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:20 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4464395"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
Date: Tue, 6 Mar 2012 17:57:37 +0800
Message-Id: <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:24,
	Serialize complete at 2012-03-06 17:51:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Known issues:
	1) All call_srcu() compete at its own ->gp_lock.
	 = It is a fake problem, Update-site should be rare for a *specified*
	   SRCU domain.

	2) Since it is per-domain and update-site is rare, per-cpu is overkill,
	   and slow down the processing a little.
	 = The answer is unknow now. If <5callbacks/grace-perioad, I suggest
	   using single state-machine per-domain, otherwise per-cpu per-domain.

	3) The processing for per-cpu state machines are not full parallelism.
	 = It is not a problem when callbacks are rare.
	   It can be easy fixed, reduce the region of ->gp_lock in state machine,
	   I will add this code when need.

	4) If a reader is preempted/sleeping long, and there are several
	   cpu state machines active(have pending callbacks), These cpus may
	   do periodic check_zero, they all failed, it is waste.
	 = We can choose a leader of these cpus-state-machine to do the
	   periodic check_zero, instead of several cpus.
	   It does not need to be fixed now, will be fixed later.

Design:
o	The srcu callback is new thing, I hope it is completely preemptible,
	even sleepable. It does in this implemetation, I use work_struct
	to stand for every srcu callback.
	I notice some RCU callbacks also use work_struct for sleepable work.
	But this indirect way push complexity to the caller and these callbacks
	are not rcu_barrier()-awared.

o	state machine is light way, it is preemptible when checking.
	(if issue3 is fixed, it will be almost full-preemptible), but it does
	not sleep(avoid to occupy a thread when sleep).
	It is also a work_struct. So, there is no thread occupied
	by SRCU when the srcu is not actived(no callbacks).
	It processes 10 callbacks at most and return.(also return the thread)
	So the whole SRCU is efficient in resource usage.

o	callback is called in the same CPU when it is queued.
	state machine work_struct and the callback work_struct may be run
	without schedled in in a worker thread.

o	workqueue handle all hot-plug issues for us.
	So this implementation highly depends on workqueue. DRY.


Others:
	srcu_head is bigger, it is worth, it provides more ability and simplify
	the srcu code.

	srcu_barrier() is not tested.

	I think *_expedited can be removed, because mb()-based srcu are
	extremely faster than before.

The trip of a callback:
	1) call_srcu(), record(snap) the chck_seq of the srcu_domain.

	2) if callback->chck_seq < srcu_domain->zero_seq[0] &&
	      callback->chck_seq < srcu_domain->zero_seq[1]
	   diriver the callback.
	   if not, it stays, let the state machine do flip or do check_zero.

	3) the callback is called in the workqueue.

The process of check_zero:
	1) advance srcu_domain->chck_seq when needed
	   (optional, but I make it bigger than all callbacks)

	2) do check_zero

	3) commit the srcu_domain->chck_seq to ->zero_seq[idx] when success.

	=) so if a callback see callback->chck_seq < srcu_domain->zero_seq[idx],
	   it means it see the whole above step which means all readers start
	   before the callback queued(but increase on active counter of idx)
	   are all completed.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |   43 ++++++-
 kernel/srcu.c        |  400 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 379 insertions(+), 64 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index df8f5f7..c375985 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -29,6 +29,22 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+
+struct srcu_head;
+typedef void (*srcu_callback_func_t)(struct srcu_head *head);
+
+struct srcu_head {
+	union {
+		struct {
+			struct srcu_head *next;
+			/* the snap of sp->chck_seq when queued */
+			unsigned long chck_seq;
+			srcu_callback_func_t func;
+		};
+		struct work_struct work;
+	};
+};
 
 struct srcu_struct_array {
 	unsigned long c[2];
@@ -39,10 +55,32 @@ struct srcu_struct_array {
 #define SRCU_REF_MASK		(ULONG_MAX >> SRCU_USAGE_BITS)
 #define SRCU_USAGE_COUNT	(SRCU_REF_MASK + 1)
 
+struct srcu_cpu_struct;
+
 struct srcu_struct {
 	unsigned completed;
+
+	/* the sequence of check zero */
+	unsigned long chck_seq;
+	/* the snap of chck_seq when the last callback is queued */
+	unsigned long callback_chck_seq;
+
+	/* the sequence value of succeed check(chck_seq) */
+	unsigned long zero_seq[2];
+
+	/* protects the above completed and sequence values */
+	spinlock_t gp_lock;
+
+	/* protects all the fields here except callback_chck_seq */
+	struct mutex flip_check_mutex;
+	/*
+	 * Fileds of the intersection of gp_lock-protected fields and
+	 * flip_check_mutex-protected fields can only be modified with
+	 * the two lock are both held, can be read with one of lock held.
+	 */
+
 	struct srcu_struct_array __percpu *per_cpu_ref;
-	struct mutex mutex;
+	struct srcu_cpu_struct __percpu *srcu_per_cpu;
 	unsigned long snap[NR_CPUS];
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
@@ -236,4 +274,7 @@ static inline void srcu_read_unlock_raw(struct srcu_struct *sp, int idx)
 	local_irq_restore(flags);
 }
 
+void call_srcu(struct srcu_struct *sp, struct srcu_head *head,
+		srcu_callback_func_t func);
+void srcu_barrier(struct srcu_struct *sp);
 #endif
diff --git a/kernel/srcu.c b/kernel/srcu.c
index d101ed5..8c71ae8 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -33,13 +33,63 @@
 #include <linux/smp.h>
 #include <linux/delay.h>
 #include <linux/srcu.h>
+#include <linux/completion.h>
+
+#define SRCU_CALLBACK_BATCH	10
+#define SRCU_INTERVAL		1
+
+/* protected by sp->gp_lock */
+struct srcu_cpu_struct {
+	/* callback queue for handling */
+	struct srcu_head *head, **tail;
+
+	/* the struct srcu_struct of this struct srcu_cpu_struct */
+	struct srcu_struct *sp;
+	struct delayed_work work;
+};
+
+/*
+ * State machine process for every CPU, it may run on wrong CPU
+ * during hotplugging or synchronize_srcu() scheldule it after
+ * migrated.
+ */
+static void process_srcu_cpu_struct(struct work_struct *work);
+
+static struct workqueue_struct *srcu_callback_wq;
 
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
+	int cpu;
+	struct srcu_cpu_struct *scp;
+
+	mutex_init(&sp->flip_check_mutex);
+	spin_lock_init(&sp->gp_lock);
 	sp->completed = 0;
-	mutex_init(&sp->mutex);
+	sp->chck_seq = 0;
+	sp->callback_chck_seq = 0;
+	sp->zero_seq[0] = 0;
+	sp->zero_seq[1] = 0;
+
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
-	return sp->per_cpu_ref ? 0 : -ENOMEM;
+	if (!sp->per_cpu_ref)
+		return -ENOMEM;
+
+	sp->srcu_per_cpu = alloc_percpu(struct srcu_cpu_struct);
+	if (!sp->srcu_per_cpu) {
+		free_percpu(sp->per_cpu_ref);
+		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu) {
+		scp = per_cpu_ptr(sp->srcu_per_cpu, cpu);
+
+		scp->sp = sp;
+		scp->head = NULL;
+		scp->tail = &scp->head;
+		INIT_DELAYED_WORK(&scp->work, process_srcu_cpu_struct);
+	}
+
+	return 0;
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -208,6 +258,8 @@ void cleanup_srcu_struct(struct srcu_struct *sp)
 		return;
 	free_percpu(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
+	free_percpu(sp->srcu_per_cpu);
+	sp->srcu_per_cpu = NULL;
 }
 EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
 
@@ -247,6 +299,19 @@ void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
 /*
+ * 'return left < right;' but handle the overflow issues.
+ * The same as 'return (long)(right - left) > 0;' but it cares more.
+ */
+static inline
+bool safe_less_than(unsigned long left, unsigned long right, unsigned long max)
+{
+	unsigned long a = right - left;
+	unsigned long b = max - left;
+
+	return !!a && (a <= b);
+}
+
+/*
  * We use an adaptive strategy for synchronize_srcu() and especially for
  * synchronize_srcu_expedited().  We spin for a fixed time period
  * (defined below) to allow SRCU readers to exit their read-side critical
@@ -254,11 +319,11 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  * we repeatedly block for 1-millisecond time periods.  This approach
  * has done well in testing, so there is no need for a config parameter.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY	5
+#define SRCU_RETRY_CHECK_DELAY		5
 #define SYNCHRONIZE_SRCU_TRYCOUNT	2
 #define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
 
-static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
+static bool do_check_zero_idx(struct srcu_struct *sp, int idx, int trycount)
 {
 	/*
 	 * If a reader fetches the index before the ->completed increment,
@@ -271,19 +336,12 @@ static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
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
@@ -297,6 +355,8 @@ static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
 	 * the next flipping.
 	 */
 	smp_mb(); /* E */
+
+	return true;
 }
 
 /*
@@ -308,65 +368,234 @@ static void srcu_flip(struct srcu_struct *sp)
 	ACCESS_ONCE(sp->completed)++;
 }
 
+/* Must called with sp->flip_check_mutex and sp->gp_lock held; */
+static bool check_zero_idx(struct srcu_struct *sp, int idx,
+		struct srcu_head *head, int trycount)
+{
+	unsigned long chck_seq;
+	bool checked_zero;
+
+	/* find out the check sequence number for this check */
+	if (sp->chck_seq == sp->callback_chck_seq ||
+	    sp->chck_seq == head->chck_seq)
+		sp->chck_seq++;
+	chck_seq = sp->chck_seq;
+
+	spin_unlock_irq(&sp->gp_lock);
+	checked_zero = do_check_zero_idx(sp, idx, trycount);
+	spin_lock_irq(&sp->gp_lock);
+
+	if (!checked_zero)
+		return false;
+
+	/* commit the succeed check */
+	sp->zero_seq[idx] = chck_seq;
+
+	return true;
+}
+
+/*
+ * Are the @head completed? will try do check zero when it is not.
+ *
+ * Must be called with sp->flip_check_mutex and sp->gp_lock held;
+ * Must be called from process contex, because the check may be long
+ * The sp->gp_lock may be released and regained.
+ */
+static bool complete_head_flip_check(struct srcu_struct *sp,
+		struct srcu_head *head, int trycount)
+{
+	int idxb = sp->completed & 0X1UL;
+	int idxa = 1 - idxb;
+	unsigned long h  = head->chck_seq;
+	unsigned long za = sp->zero_seq[idxa];
+	unsigned long zb = sp->zero_seq[idxb];
+	unsigned long s  = sp->chck_seq;
+
+	if (!safe_less_than(h, za, s)) {
+		if (!check_zero_idx(sp, idxa, head, trycount))
+			return false;
+	}
+
+	if (!safe_less_than(h, zb, s)) {
+		srcu_flip(sp);
+		trycount = trycount < 2 ? 2 : trycount;
+		return check_zero_idx(sp, idxb, head, trycount);
+	}
+
+	return true;
+}
+
+/*
+ * Are the @head completed?
+ *
+ * Must called with sp->gp_lock held;
+ * srcu_queue_callback() and check_zero_idx() ensure (s - z0) and (s - z1)
+ * less than (ULONG_MAX / sizof(struct srcu_head)). There is at least one
+ * callback queued for each seq in (z0, s) and (z1, s). The same for
+ * za, zb, s in complete_head_flip_check().
+ */
+static bool complete_head(struct srcu_struct *sp, struct srcu_head *head)
+{
+	unsigned long h  = head->chck_seq;
+	unsigned long z0 = sp->zero_seq[0];
+	unsigned long z1 = sp->zero_seq[1];
+	unsigned long s  = sp->chck_seq;
+
+	return safe_less_than(h, z0, s) && safe_less_than(h, z1, s);
+}
+
+static void process_srcu_cpu_struct(struct work_struct *work)
+{
+	int i;
+	int can_flip_check;
+	struct srcu_head *head;
+	struct srcu_cpu_struct *scp;
+	struct srcu_struct *sp;
+	work_func_t wfunc;
+
+	scp = container_of(work, struct srcu_cpu_struct, work.work);
+	sp = scp->sp;
+
+	can_flip_check = mutex_trylock(&sp->flip_check_mutex);
+	spin_lock_irq(&sp->gp_lock);
+
+	for (i = 0; i < SRCU_CALLBACK_BATCH; i++) {
+		head = scp->head;
+		if (!head)
+			break;
+
+		/* Test whether the head is completed or not. */
+		if (can_flip_check) {
+			if (!complete_head_flip_check(sp, head, 1))
+				break;
+		} else {
+			if (!complete_head(sp, head))
+				break;
+		}
+
+		/* dequeue the completed callback */
+		scp->head = head->next;
+		if (!scp->head)
+			scp->tail = &scp->head;
+
+		/* deliver the callback, will be invoked in workqueue */
+		BUILD_BUG_ON(offsetof(struct srcu_head, work) != 0);
+		wfunc = (work_func_t)head->func;
+		INIT_WORK(&head->work, wfunc);
+		queue_work(srcu_callback_wq, &head->work);
+	}
+	if (scp->head)
+		schedule_delayed_work(&scp->work, SRCU_INTERVAL);
+	spin_unlock_irq(&sp->gp_lock);
+	if (can_flip_check)
+		mutex_unlock(&sp->flip_check_mutex);
+}
+
+static
+void srcu_queue_callback(struct srcu_struct *sp, struct srcu_cpu_struct *scp,
+                struct srcu_head *head, srcu_callback_func_t func)
+{
+	head->next = NULL;
+	head->func = func;
+	head->chck_seq = sp->chck_seq;
+	sp->callback_chck_seq = sp->chck_seq;
+	*scp->tail = head;
+	scp->tail = &head->next;
+}
+
+void call_srcu(struct srcu_struct *sp, struct srcu_head *head,
+		srcu_callback_func_t func)
+{
+	unsigned long flags;
+	int cpu = get_cpu();
+	struct srcu_cpu_struct *scp = per_cpu_ptr(sp->srcu_per_cpu, cpu);
+
+	spin_lock_irqsave(&sp->gp_lock, flags);
+	srcu_queue_callback(sp, scp, head, func);
+	/* start state machine when this is the head */
+	if (scp->head == head)
+		schedule_delayed_work(&scp->work, 0);
+	spin_unlock_irqrestore(&sp->gp_lock, flags);
+	put_cpu();
+}
+EXPORT_SYMBOL_GPL(call_srcu);
+
+struct srcu_sync {
+	struct srcu_head head;
+	struct completion completion;
+};
+
+static void __synchronize_srcu_callback(struct srcu_head *head)
+{
+	struct srcu_sync *sync = container_of(head, struct srcu_sync, head);
+
+	complete(&sync->completion);
+}
+
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
+static void __synchronize_srcu(struct srcu_struct *sp, int try_count)
 {
+	struct srcu_sync sync;
+	struct srcu_head *head = &sync.head;
+	struct srcu_head **orig_tail;
+	int cpu = raw_smp_processor_id();
+	struct srcu_cpu_struct *scp = per_cpu_ptr(sp->srcu_per_cpu, cpu);
+	bool started;
+
 	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
 			   !lock_is_held(&rcu_bh_lock_map) &&
 			   !lock_is_held(&rcu_lock_map) &&
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
-	mutex_lock(&sp->mutex);
+	init_completion(&sync.completion);
+	if (!mutex_trylock(&sp->flip_check_mutex)) {
+		call_srcu(sp, &sync.head, __synchronize_srcu_callback);
+		goto wait;
+	}
+
+	spin_lock_irq(&sp->gp_lock);
+	started = !!scp->head;
+	orig_tail = scp->tail;
+	srcu_queue_callback(sp, scp, head, __synchronize_srcu_callback);
+
+	/* fast path */
+	if (complete_head_flip_check(sp, head, try_count)) {
+		/*
+		 * dequeue @head, we hold flip_check_mutex, the previous
+		 * node stays or all prevous node are all dequeued.
+		 */
+		if (scp->head == head)
+			orig_tail = &scp->head;
+		*orig_tail = head->next;
+		if (*orig_tail == NULL)
+			scp->tail = orig_tail;
+
+		/*
+		 * start state machine if this is the head and some callback(s)
+		 * are queued when we do check_zero(they have not started it).
+		 */
+		if (!started && scp->head)
+			schedule_delayed_work(&scp->work, 0);
+
+		/* we done! */
+		spin_unlock_irq(&sp->gp_lock);
+		mutex_unlock(&sp->flip_check_mutex);
+		return;
+	}
 
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
+	/* slow path */
 
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
+	/* start state machine when this is the head */
+	if (!started)
+		schedule_delayed_work(&scp->work, 0);
+	spin_unlock_irq(&sp->gp_lock);
+	mutex_unlock(&sp->flip_check_mutex);
 
-	mutex_unlock(&sp->mutex);
+wait:
+	wait_for_completion(&sync.completion);
 }
 
 /**
@@ -410,6 +639,44 @@ void synchronize_srcu_expedited(struct srcu_struct *sp)
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
+void srcu_barrier(struct srcu_struct *sp)
+{
+	struct srcu_sync sync;
+	struct srcu_head *head = &sync.head;
+	unsigned long chck_seq; /* snap */
+
+	int idle_loop = 0;
+	int cpu;
+	struct srcu_cpu_struct *scp;
+
+	spin_lock_irq(&sp->gp_lock);
+	chck_seq = sp->chck_seq;
+	for_each_possible_cpu(cpu) {
+		scp = per_cpu_ptr(sp->srcu_per_cpu, cpu);
+		if (scp->head && !safe_less_than(chck_seq, scp->head->chck_seq,
+				sp->chck_seq)) {
+			/* this path is likely enterred only once */
+			init_completion(&sync.completion);
+			srcu_queue_callback(sp, scp, head,
+					__synchronize_srcu_callback);
+			/* don't need to wakeup the woken state machine */
+			spin_unlock_irq(&sp->gp_lock);
+			wait_for_completion(&sync.completion);
+			spin_lock_irq(&sp->gp_lock);
+		} else {
+			if ((++idle_loop & 0xF) == 0) {
+				spin_unlock_irq(&sp->gp_lock);
+				udelay(1);
+				spin_lock_irq(&sp->gp_lock);
+			}
+		}
+	}
+	spin_unlock_irq(&sp->gp_lock);
+
+	flush_workqueue(srcu_callback_wq);
+}
+EXPORT_SYMBOL_GPL(srcu_barrier);
+
 /**
  * srcu_batches_completed - return batches completed.
  * @sp: srcu_struct on which to report batch completion.
@@ -423,3 +690,10 @@ long srcu_batches_completed(struct srcu_struct *sp)
 	return sp->completed;
 }
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
+
+__init int srcu_init(void)
+{
+	srcu_callback_wq = alloc_workqueue("srcu", 0, 0);
+	return srcu_callback_wq ? 0 : -1;
+}
+subsys_initcall(srcu_init);
-- 
1.7.4.4

