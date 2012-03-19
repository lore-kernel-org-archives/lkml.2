Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2CSIH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:07:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab2CSIHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:07:19 -0400
X-IronPort-AV: E=Sophos;i="4.73,611,1325433600"; 
   d="scan'208";a="4567345"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 3/4 V2] implement per-domain single-thread state machine call_srcu()
Date: Mon, 19 Mar 2012 16:12:13 +0800
Message-Id: <1332144734-9375-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:09,
	Serialize complete at 2012-03-19 16:05:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o	state machine is light way and single-threaded, it is preemptible when checking.

o	state machine is a work_struct. So, there is no thread occupied
	by SRCU when the srcu is not actived(no callback). And it does
	not sleep(avoid to occupy a thread when sleep).

o	state machine is the only thread can flip/check/write(*) the srcu_struct,
	so we don't need any mutex.
	(write(*): except ->per_cpu_ref, ->running, ->batch_queue)

o	synchronize_srcu() will take the processing ownership when no other
	state-machine is running.(the task of synchronize_srcu() becomes
	the state-machine-thread). This fast patch can avoid scheduling.
	When the fast path fails, it falls back to "call_srcu() + wait".

o	callback is probably called in the same CPU when it is queued.

The trip of a callback:
	1) ->batch_queue when call_srcu()

	2) ->batch_check0 when try to do check_zero

	3) ->batch_check1 after finish its first check_zero and the flip

	4) ->batch_done after finish its second check_zero

The current requirement of the callbacks:
	The callback will be called inside process context.
	The callback should be fast without any sleeping path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/srcu.h |   25 ++++-
 kernel/srcu.c        |  310 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 268 insertions(+), 67 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index e5ce804..075fb8c 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -29,16 +29,30 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/workqueue.h>
 
 struct srcu_struct_array {
 	unsigned long c[2];
 	unsigned long seq[2];
 };
 
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
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -62,12 +76,21 @@ int init_srcu_struct(struct srcu_struct *sp);
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/*
+ * queue callbacks which will be invoked after grace period.
+ * The callback will be called inside process context.
+ * The callback should be fast without any sleeping path.
+ */
+void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
+		void (*func)(struct rcu_head *head));
+
 void cleanup_srcu_struct(struct srcu_struct *sp);
 int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
 void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
+void srcu_barrier(struct srcu_struct *sp);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2923541..c193d59 100644
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
@@ -251,29 +301,22 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  * we repeatedly block for 1-millisecond time periods.  This approach
  * has done well in testing, so there is no need for a config parameter.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY	5
+#define SRCU_RETRY_CHECK_DELAY		5
 #define SYNCHRONIZE_SRCU_TRYCOUNT	2
 #define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
 
 /*
- * Wait until all the readers(which starts before this wait_idx()
- * with the specified idx) complete.
+ * the caller should ensures the ->completed is not changed while checking
+ * and idx = (->completed & 1) ^ 1
  */
-static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
+static bool try_check_zero(struct srcu_struct *sp, int idx, int trycount)
 {
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
+			return true;
+		if (--trycount <= 0)
+			return false;
+		udelay(SRCU_RETRY_CHECK_DELAY);
 	}
 }
 
@@ -282,12 +325,51 @@ static void srcu_flip(struct srcu_struct *sp)
 	sp->completed++;
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
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
+/*
+ * Awaken the corresponding synchronize_srcu() instance now that a
+ * grace period has elapsed.
+ */
+static void wakeme_after_rcu(struct rcu_head *head)
+{
+	struct rcu_synchronize *rcu;
+
+	rcu = container_of(head, struct rcu_synchronize, head);
+	complete(&rcu->completion);
+}
+
+static void srcu_advance_batches(struct srcu_struct *sp, int trycount);
+static void srcu_reschedule(struct srcu_struct *sp);
+
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
 static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 {
-	int busy_idx;
+	struct rcu_synchronize rcu;
+	struct rcu_head *head = &rcu.head;
+	bool done = false;
 
 	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
 			   !lock_is_held(&rcu_bh_lock_map) &&
@@ -295,54 +377,32 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
-	mutex_lock(&sp->mutex);
-	busy_idx = sp->completed & 0X1UL;
-
-	/*
-	 * There are some readers start with idx=0, and some others start
-	 * with idx=1. So two wait_idx()s are enough for synchronize:
-	 * __synchronize_srcu() {
-	 * 	wait_idx(sp, 0, trycount);
-	 * 	wait_idx(sp, 1, trycount);
-	 * }
-	 * When it returns, all started readers have complete.
-	 *
-	 * But synchronizer may be starved by the readers, example,
-	 * if sp->complete & 0x1L == 1, wait_idx(sp, 1, expedited)
-	 * may not returns if there are continuous readers start
-	 * with idx=1.
-	 *
-	 * So we need to flip the busy index to keep synchronizer
-	 * from starvation.
-	 */
-
-	/*
-	 * The above comments assume we have readers with all the
-	 * 2 idx. It does have this probability, some readers may
-	 * hold the reader lock with idx=1-busy_idx:
-	 *
-	 * Suppose that during the previous grace period, a reader
-	 * picked up the old value of the index, but did not increment
-	 * its counter until after the previous instance of
-	 * __synchronize_srcu() did the counter summation and recheck.
-	 * That previous grace period was OK because the reader did
-	 * not start until after the grace period started, so the grace
-	 * period was not obligated to wait for that reader.
-	 *
-	 * Because this probability is not high, wait_idx()
-	 * will normally not need to wait.
-	 */
-	wait_idx(sp, 1 - busy_idx, trycount);
-
-	/* flip the index to ensure the return of the next wait_idx() */
-	srcu_flip(sp);
-
-	/*
-	 * Now that wait_idx() has waited for the really old readers.
-	 */
-	wait_idx(sp, busy_idx, trycount);
+	init_completion(&rcu.completion);
+
+	head->next = NULL;
+	head->func = wakeme_after_rcu;
+	spin_lock_irq(&sp->queue_lock);
+	if (!sp->running) {
+		/* steal the processing owner */
+		sp->running = true;
+		rcu_batch_queue(&sp->batch_check0, head);
+		spin_unlock_irq(&sp->queue_lock);
+
+		srcu_advance_batches(sp, trycount);
+		if (!rcu_batch_empty(&sp->batch_done)) {
+			BUG_ON(sp->batch_done.head != head);
+			rcu_batch_dequeue(&sp->batch_done);
+			done = true;
+		}
+		/* give the processing owner to work_struct */
+		srcu_reschedule(sp);
+	} else {
+		rcu_batch_queue(&sp->batch_queue, head);
+		spin_unlock_irq(&sp->queue_lock);
+	}
 
-	mutex_unlock(&sp->mutex);
+	if (!done)
+		wait_for_completion(&rcu.completion);
 }
 
 /**
@@ -386,6 +446,12 @@ void synchronize_srcu_expedited(struct srcu_struct *sp)
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
+void srcu_barrier(struct srcu_struct *sp)
+{
+	synchronize_srcu(sp);
+}
+EXPORT_SYMBOL_GPL(srcu_barrier);
+
 /**
  * srcu_batches_completed - return batches completed.
  * @sp: srcu_struct on which to report batch completion.
@@ -399,3 +465,115 @@ long srcu_batches_completed(struct srcu_struct *sp)
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
+static void srcu_advance_batches(struct srcu_struct *sp, int trycount)
+{
+	int idx = 1 ^ (sp->completed & 1);
+
+	/*
+	 * There are some readers start with idx=0, and some others start
+	 * with idx=1. So two success try_check_zero()s (with idx=0,and idx=1)
+	 * are enough for a callback to complete.
+	 */
+
+	if (rcu_batch_empty(&sp->batch_check0) &&
+	    rcu_batch_empty(&sp->batch_check1))
+		return; /* no callbacks need to be advanced */
+
+	if (!try_check_zero(sp, idx, trycount))
+		return; /* failed to advance, will try after SRCU_INTERVAL */
+
+	/*
+	 * The callbacks in ->batch_check1 have already done with their
+	 * first check zero and a flip after check. Their first
+	 * check zero is "try_check_zero(sp, idx^1, ...)",
+	 * and they finish try_check_zero(sp, idx, ...) just now.
+	 * So they all completed, move them to ->batch_done.
+	 */
+	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
+
+	if (rcu_batch_empty(&sp->batch_check0))
+		return; /* no callbacks need to be advanced */
+	srcu_flip(sp);
+
+	/*
+	 * The callbacks in ->batch_check0 just finish their
+	 * first check zero and a flip after check, move them to
+	 * ->batch_check1 for future checking with a different idx.
+	 */
+	rcu_batch_move(&sp->batch_check1, &sp->batch_check0);
+
+	/*
+	 * SRCU read-side critical sections are normally short, so check
+	 * twice after a flip.
+	 */
+	trycount = trycount < 2 ? 2 : trycount;
+	if (!try_check_zero(sp, idx^1, trycount))
+		return; /* failed to advance, will try after SRCU_INTERVAL */
+
+	/*
+	 * The callbacks in ->batch_check1 have already done with their
+	 * first check zero and a flip after check. Their first
+	 * check zero is "try_check_zero(sp, idx, ...)",
+	 * and they finish try_check_zero(sp, idx^1, ...) just now.
+	 * So they all completed, move them to ->batch_done.
+	 */
+	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
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
+	bool pending = true;
+
+	if (rcu_batch_empty(&sp->batch_done) &&
+	    rcu_batch_empty(&sp->batch_check1) &&
+	    rcu_batch_empty(&sp->batch_check0) &&
+	    rcu_batch_empty(&sp->batch_queue)) {
+		spin_lock_irq(&sp->queue_lock);
+		if (rcu_batch_empty(&sp->batch_queue)) {
+			sp->running = false;
+			pending = false;
+		}
+		spin_unlock_irq(&sp->queue_lock);
+	}
+
+	if (pending)
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
+	srcu_advance_batches(sp, 1);
+	srcu_invoke_callbacks(sp);
+	srcu_reschedule(sp);
+}
-- 
1.7.4.4

