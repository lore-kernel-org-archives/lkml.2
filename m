Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2DNQVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:21:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46061 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2DNQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 4/7] rcu: Move __rcu_read_lock() and __rcu_read_unlock() to per-CPU variables
Date: Sat, 14 Apr 2012 09:20:34 -0700
Message-Id: <1334420437-19264-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-1780-0000-0000-000004C2DA09
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000268; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00130845; UDB=6.00030853; UTC=2012-04-14
 16:20:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit is another step towards inlinable __rcu_read_lock() and
__rcu_read_unlock() functions for preemptible RCU.  This keeps these two
functions out of line, but switches them to use the per-CPU variables
that are required to export their definitions without requiring that
all RCU users include sched.h.  These per-CPU variables are saved and
restored at context-switch time.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/um/drivers/mconsole_kern.c |    3 +-
 include/linux/init_task.h       |    4 +-
 include/linux/rcupdate.h        |   20 +++++++-
 include/linux/sched.h           |   92 +++++++++++++++++++++++++++++++---
 kernel/rcu.h                    |    4 ++
 kernel/rcupdate.c               |   54 ++++++++++++++++++--
 kernel/rcutiny_plugin.h         |  106 ++++++++------------------------------
 kernel/rcutree_plugin.h         |   85 ++++++++-----------------------
 kernel/sched/core.c             |    3 +-
 9 files changed, 209 insertions(+), 162 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index f69ff2d..a98693f 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -704,8 +704,9 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch_from(from);
+	rcu_switch_from();
 	switch_to(from, to, from);
+	rcu_switch_to();
 }
 
 /*
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..cdd8436 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -105,8 +105,8 @@ extern struct group_info init_groups;
 #endif
 #ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
-	.rcu_read_lock_nesting = 0,					\
-	.rcu_read_unlock_special = 0,					\
+	.rcu_read_lock_nesting_save = 0,				\
+	.rcu_read_unlock_special_save = 0,				\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
 	INIT_TASK_RCU_TREE_PREEMPT()					\
 	INIT_TASK_RCU_BOOST()
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5a94dcf..89f7e97 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -146,6 +146,9 @@ extern void synchronize_sched(void);
 
 DECLARE_PER_CPU(int, rcu_read_lock_nesting);
 DECLARE_PER_CPU(int, rcu_read_unlock_special);
+#ifdef CONFIG_PROVE_RCU
+DECLARE_PER_CPU(struct task_struct *, rcu_current_task);
+#endif /* #ifdef CONFIG_PROVE_RCU */
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
@@ -157,7 +160,22 @@ void synchronize_rcu(void);
  * nesting depth, but makes sense only if CONFIG_PREEMPT_RCU -- in other
  * types of kernel builds, the rcu_read_lock() nesting depth is unknowable.
  */
-#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+#define rcu_preempt_depth() (__this_cpu_read(rcu_read_lock_nesting))
+
+/*
+ * Check for a running RCU reader on the current CPU.  If used from
+ * TINY_PREEMPT_RCU, works globally, as there can be but one running
+ * RCU reader at a time in that case.  ;-)
+ *
+ * Returns zero if there are no running readers.  Returns a positive
+ * number if there is at least one reader within its RCU read-side
+ * critical section.  Returns a negative number if an outermost reader
+ * is in the midst of exiting from its RCU read-side critical section
+ *
+ * This differs from rcu_preempt_depth() in throwing a build error
+ * if used from under !CONFIG_PREEMPT_RCU.
+ */
+#define rcu_preempt_running_reader() (__this_cpu_read(rcu_read_lock_nesting))
 
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a749c9d..65e7023 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1275,8 +1275,8 @@ struct task_struct {
 	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
-	int rcu_read_lock_nesting;
-	char rcu_read_unlock_special;
+	int rcu_read_lock_nesting_save;
+	char rcu_read_unlock_special_save;
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -1868,8 +1868,8 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
-	p->rcu_read_lock_nesting = 0;
-	p->rcu_read_unlock_special = 0;
+	p->rcu_read_lock_nesting_save = 0;
+	p->rcu_read_unlock_special_save = 0;
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
@@ -1879,10 +1879,84 @@ static inline void rcu_copy_process(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
-static inline void rcu_switch_from(struct task_struct *prev)
+/*
+ * Let preemptible RCU know about a switch away from a task.
+ *
+ * First, if there is an ongoing RCU read-side critical section, invoke
+ * rcu_preempt_note_context_switch() to enqueue the task.
+ *
+ * We need to save both of the __rcu_read_lock() / __rcu_read_unlock()
+ * per-CPU variables in either case so that they can be correctly restored
+ * when this task resumes.
+ *
+ * Subsequent RCU read-side critical sections can occur either in the
+ * architecture switch_to() function or in interrupt handlers.  Both
+ * cases rely on the fact that if rcu_read_unlock_special is zero, then
+ * rcu_read_lock_nesting must also be zero.  Thus, the only way that such
+ * a critical section can enter rcu_read_unlock_special() is if:
+ *
+ * 1.	The per-CPU rcu_read_lock_nesting variable was zero, and:
+ * 2.	The critical section took a scheduling-clock interrupt,
+ *	setting the RCU_READ_UNLOCK_NEED_QS bit.
+ *
+ * This is harmless.  It will cause the CPU to register a quiescent state,
+ * which is OK because the CPU really is in a quiescent state and if the
+ * outgoing task was not in a quiescent state, it has already been queued.
+ * In particular, RCU_READ_UNLOCK_BLOCKED cannot be set because preemption
+ * is disabled.
+ *
+ * If rcu_read_lock_nesting is non-zero, then any subsequent RCU read-side
+ * critical section will act as if nested, thus refusing to enter the
+ * rcu_read_unlock_special() function in the first place.
+ *
+ * The caller must have disabled preemption.
+ */
+static inline void rcu_switch_from(void)
 {
-	if (prev->rcu_read_lock_nesting != 0)
+	struct task_struct *t = current;
+
+	if (__this_cpu_read(rcu_read_lock_nesting) != 0)
 		rcu_preempt_note_context_switch();
+	t->rcu_read_lock_nesting_save = __this_cpu_read(rcu_read_lock_nesting);
+	t->rcu_read_unlock_special_save =
+		__this_cpu_read(rcu_read_unlock_special);
+#ifdef CONFIG_PROVE_RCU
+	barrier();
+	/* Idle tasks can have NULL rcu_current_task at boot time. */
+	BUG_ON(__this_cpu_read(rcu_current_task) != t &&
+	       __this_cpu_read(rcu_current_task) != NULL);
+	__this_cpu_write(rcu_current_task, NULL);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+}
+
+/*
+ * Let preemptible RCU know about a switch to a task.
+ *
+ * This requires some care in order to preserve the invariant
+ * mentioned above.  First zero rcu_read_unlock_special, then
+ * restore the value of rcu_read_lock_nesting, and only then restore
+ * rcu_read_unlock_special_save.  (Yes, there is a check in
+ * rcu_read_unlock_special() that is supposed to prevent interrupt
+ * handlers from getting to far into that function, but this check
+ * are unavoidably heuristic in nature.)
+ *
+ * The caller must have disabled preemption.
+ */
+static inline void rcu_switch_to(void)
+{
+	struct task_struct *t = current;
+
+	__this_cpu_write(rcu_read_unlock_special, 0);
+	barrier(); /* Ensure ordering to maintain invariant. */
+	__this_cpu_write(rcu_read_lock_nesting, t->rcu_read_lock_nesting_save);
+	barrier(); /* Ensure ordering to maintain invariant. */
+	__this_cpu_write(rcu_read_unlock_special,
+		t->rcu_read_unlock_special_save);
+#ifdef CONFIG_PROVE_RCU
+	barrier();
+	BUG_ON(__this_cpu_read(rcu_current_task) != NULL);
+	__this_cpu_write(rcu_current_task, t);
+#endif /* #ifdef CONFIG_PROVE_RCU */
 }
 
 #else
@@ -1891,7 +1965,11 @@ static inline void rcu_copy_process(struct task_struct *p)
 {
 }
 
-static inline void rcu_switch_from(struct task_struct *prev)
+static inline void rcu_switch_from(void)
+{
+}
+
+static inline void rcu_switch_to(void)
 {
 }
 
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 8ba99cd..6243d8d 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -109,4 +109,8 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 	}
 }
 
+#ifdef CONFIG_PREEMPT_RCU
+extern void rcu_read_unlock_do_special(void);
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 1acf0da..f77a5fc 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -54,6 +54,54 @@
 #ifdef CONFIG_PREEMPT_RCU
 DEFINE_PER_CPU(int, rcu_read_lock_nesting);
 DEFINE_PER_CPU(int, rcu_read_unlock_special);
+#ifdef CONFIG_PROVE_RCU
+DEFINE_PER_CPU(struct task_struct *, rcu_current_task);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
+/*
+ * Preemptible-RCU implementation for rcu_read_lock().  Just increment
+ * the per-CPU rcu_read_lock_nesting: Shared state and per-task state will
+ * be updated if we block.
+ */
+void __rcu_read_lock(void)
+{
+	__this_cpu_inc(rcu_read_lock_nesting);
+	barrier(); /* Keep code within RCU read-side critical section. */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_lock);
+
+/*
+ * Tree-preemptible RCU implementation for rcu_read_unlock().
+ * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_do_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ * Set rcu_read_lock_nesting to a large negative value during cleanup
+ * in order to ensure that if rcu_read_unlock_special is non-zero, then
+ * rcu_read_lock_nesting is also non-zero.
+ */
+void __rcu_read_unlock(void)
+{
+	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
+		__this_cpu_dec(rcu_read_lock_nesting);
+	else {
+		barrier();  /* critical section before exit code. */
+		__this_cpu_write(rcu_read_lock_nesting, INT_MIN);
+		barrier();  /* assign before ->rcu_read_unlock_special load */
+		if (unlikely(__this_cpu_read(rcu_read_unlock_special)))
+			rcu_read_unlock_do_special();
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		__this_cpu_write(rcu_read_lock_nesting, 0);
+	}
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		int rln = __this_cpu_read(rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
+	}
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
 /*
  * Check for a task exiting while in a preemptible-RCU read-side
@@ -63,13 +111,11 @@ DEFINE_PER_CPU(int, rcu_read_unlock_special);
  */
 void exit_rcu(void)
 {
-	struct task_struct *t = current;
-
 	if (likely(list_empty(&current->rcu_node_entry)))
 		return;
-	t->rcu_read_lock_nesting = 1;
+	__this_cpu_write(rcu_read_lock_nesting, 1);
 	barrier();
-	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	__this_cpu_write(rcu_read_unlock_special, RCU_READ_UNLOCK_BLOCKED);
 	__rcu_read_unlock();
 }
 
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 66a542a..6b416af 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -132,7 +132,6 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
-static void rcu_read_unlock_do_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(void);
 static void rcu_report_exp_done(void);
 
@@ -145,25 +144,6 @@ static int rcu_cpu_blocking_cur_gp(void)
 }
 
 /*
- * Check for a running RCU reader.  Because there is only one CPU,
- * there can be but one running RCU reader at a time.  ;-)
- *
- * Returns zero if there are no running readers.  Returns a positive
- * number if there is at least one reader within its RCU read-side
- * critical section.  Returns a negative number if an outermost reader
- * is in the midst of exiting from its RCU read-side critical section
- *
- * Returns zero if there are no running readers.  Returns a positive
- * number if there is at least one reader within its RCU read-side
- * critical section.  Returns a negative number if an outermost reader
- * is in the midst of exiting from its RCU read-side critical section.
- */
-static int rcu_preempt_running_reader(void)
-{
-	return current->rcu_read_lock_nesting;
-}
-
-/*
  * Check for preempted RCU readers blocking any grace period.
  * If the caller needs a reliable answer, it must disable hard irqs.
  */
@@ -395,7 +375,7 @@ static void rcu_preempt_boost_start_gp(void)
  *
  * Unlike the other rcu_*_qs() functions, callers to this function
  * must disable irqs in order to protect the assignment to
- * ->rcu_read_unlock_special.
+ * rcu_read_unlock_special.
  *
  * Because this is a single-CPU implementation, the only way a grace
  * period can end is if the CPU is in a quiescent state.  The reason is
@@ -412,7 +392,7 @@ static void rcu_preempt_cpu_qs(void)
 {
 	/* Record both CPU and task as having responded to current GP. */
 	rcu_preempt_ctrlblk.gpcpu = rcu_preempt_ctrlblk.gpnum;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	__get_cpu_var(rcu_read_unlock_special) &= ~RCU_READ_UNLOCK_NEED_QS;
 
 	/* If there is no GP then there is nothing more to do.  */
 	if (!rcu_preempt_gp_in_progress())
@@ -486,10 +466,12 @@ void rcu_preempt_note_context_switch(void)
 
 	local_irq_save(flags); /* must exclude scheduler_tick(). */
 	if (rcu_preempt_running_reader() > 0 &&
-	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+	    (__this_cpu_read(rcu_read_unlock_special) &
+	     RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+		__get_cpu_var(rcu_read_unlock_special) |=
+			RCU_READ_UNLOCK_BLOCKED;
 
 		/*
 		 * If this CPU has already checked in, then this task
@@ -505,12 +487,12 @@ void rcu_preempt_note_context_switch(void)
 		if (rcu_cpu_blocking_cur_gp())
 			rcu_preempt_ctrlblk.gp_tasks = &t->rcu_node_entry;
 	} else if (rcu_preempt_running_reader() < 0 &&
-		   t->rcu_read_unlock_special) {
+		   __this_cpu_read(rcu_read_unlock_special)) {
 		/*
 		 * Complete exit from RCU read-side critical section on
 		 * behalf of preempted instance of __rcu_read_unlock().
 		 */
-		rcu_read_unlock_do_special(t);
+		rcu_read_unlock_do_special();
 	}
 
 	/*
@@ -527,23 +509,11 @@ void rcu_preempt_note_context_switch(void)
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static noinline void rcu_read_unlock_do_special(struct task_struct *t)
+void rcu_read_unlock_do_special(void)
 {
 	int empty;
 	int empty_exp;
@@ -567,7 +537,7 @@ static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 	 * If RCU core is waiting for this CPU to exit critical section,
 	 * let it know that we have done so.
 	 */
-	special = t->rcu_read_unlock_special;
+	special = __this_cpu_read(rcu_read_unlock_special);
 	if (special & RCU_READ_UNLOCK_NEED_QS)
 		rcu_preempt_cpu_qs();
 
@@ -579,7 +549,10 @@ static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+		struct task_struct *t = current;
+
+		__get_cpu_var(rcu_read_unlock_special) &=
+			~RCU_READ_UNLOCK_BLOCKED;
 
 		/*
 		 * Remove this task from the ->blkd_tasks list and adjust
@@ -614,49 +587,17 @@ static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 		 */
 		if (!empty_exp && rcu_preempt_ctrlblk.exp_tasks == NULL)
 			rcu_report_exp_done();
-	}
 #ifdef CONFIG_RCU_BOOST
-	/* Unboost self if was boosted. */
-	if (t->rcu_boost_mutex != NULL) {
-		rbmp = t->rcu_boost_mutex;
-		t->rcu_boost_mutex = NULL;
-		rt_mutex_unlock(rbmp);
-	}
+		/* Unboost self if was boosted. */
+		if (t->rcu_boost_mutex != NULL) {
+			rbmp = t->rcu_boost_mutex;
+			t->rcu_boost_mutex = NULL;
+			rt_mutex_unlock(rbmp);
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
-	local_irq_restore(flags);
-}
-
-/*
- * Tiny-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_do_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_struct *t = current;
-
-	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
-	else {
-		t->rcu_read_lock_nesting = INT_MIN;
-		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_do_special(t);
-		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
-	}
-#ifdef CONFIG_PROVE_LOCKING
-	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
-
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
 	}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
+	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
 /*
  * Check for a quiescent state from the current CPU.  When a task blocks,
@@ -667,8 +608,6 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
  */
 static void rcu_preempt_check_callbacks(void)
 {
-	struct task_struct *t = current;
-
 	if (rcu_preempt_gp_in_progress() &&
 	    (!rcu_preempt_running_reader() ||
 	     !rcu_cpu_blocking_cur_gp()))
@@ -679,7 +618,8 @@ static void rcu_preempt_check_callbacks(void)
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
 	    rcu_preempt_running_reader() > 0)
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+		__get_cpu_var(rcu_read_unlock_special) |=
+			RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 76a1ba9..20be289 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -78,7 +78,6 @@ struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
-static void rcu_read_unlock_do_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
 /*
@@ -126,7 +125,7 @@ EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
  *
  * Unlike the other rcu_*_qs() functions, callers to this function
  * must disable irqs in order to protect the assignment to
- * ->rcu_read_unlock_special.
+ * rcu_read_unlock_special.
  */
 static void rcu_preempt_qs(int cpu)
 {
@@ -137,7 +136,7 @@ static void rcu_preempt_qs(int cpu)
 	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesce = 1;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	__get_cpu_var(rcu_read_unlock_special) &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
@@ -160,14 +159,16 @@ void rcu_preempt_note_context_switch(void)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
-	if (t->rcu_read_lock_nesting > 0 &&
-	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+	if (__this_cpu_read(rcu_read_lock_nesting) > 0 &&
+	    (__this_cpu_read(rcu_read_unlock_special) &
+	     RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = __this_cpu_ptr(rcu_preempt_state.rda);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+		__get_cpu_var(rcu_read_unlock_special) |=
+			RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
 		/*
@@ -208,14 +209,14 @@ void rcu_preempt_note_context_switch(void)
 				       ? rnp->gpnum
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	} else if (t->rcu_read_lock_nesting < 0 &&
-		   t->rcu_read_unlock_special) {
+	} else if (__this_cpu_read(rcu_read_lock_nesting) < 0 &&
+		   __this_cpu_read(rcu_read_unlock_special)) {
 
 		/*
-		 * Complete exit from RCU read-side critical section on
+		 * Finish the exit from RCU read-side critical section on
 		 * behalf of preempted instance of __rcu_read_unlock().
 		 */
-		rcu_read_unlock_do_special(t);
+		rcu_read_unlock_do_special();
 	}
 
 	/*
@@ -233,18 +234,6 @@ void rcu_preempt_note_context_switch(void)
 }
 
 /*
- * Tree-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Check for preempted RCU readers blocking the current grace period
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
@@ -310,7 +299,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static noinline void rcu_read_unlock_do_special(struct task_struct *t)
+void rcu_read_unlock_do_special(void)
 {
 	int empty;
 	int empty_exp;
@@ -333,7 +322,7 @@ static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 	 * If RCU core is waiting for this CPU to exit critical section,
 	 * let it know that we have done so.
 	 */
-	special = t->rcu_read_unlock_special;
+	special = __this_cpu_read(rcu_read_unlock_special);
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
 		rcu_preempt_qs(smp_processor_id());
 	}
@@ -346,7 +335,10 @@ static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+		struct task_struct *t = current;
+
+		__get_cpu_var(rcu_read_unlock_special) &=
+			~RCU_READ_UNLOCK_BLOCKED;
 
 		/*
 		 * Remove this task from the list it blocked on.  The
@@ -418,38 +410,6 @@ static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 	}
 }
 
-/*
- * Tree-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_do_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
-	else {
-		barrier();  /* critical section before exit code. */
-		t->rcu_read_lock_nesting = INT_MIN;
-		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_do_special(t);
-		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
-	}
-#ifdef CONFIG_PROVE_LOCKING
-	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
-
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
-	}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
-
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
 /*
@@ -666,15 +626,14 @@ static void rcu_preempt_cleanup_dead_cpu(int cpu)
  */
 static void rcu_preempt_check_callbacks(int cpu)
 {
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0) {
+	if (__this_cpu_read(rcu_read_lock_nesting) == 0) {
 		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (t->rcu_read_lock_nesting > 0 &&
-	    per_cpu(rcu_preempt_data, cpu).qs_pending)
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+	if (__this_cpu_read(rcu_read_lock_nesting) > 0 &&
+	    __get_cpu_var(rcu_preempt_data).qs_pending)
+		__get_cpu_var(rcu_read_unlock_special) |=
+			RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 10689da..9f10b76 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2051,8 +2051,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch_from(prev);
+	rcu_switch_from();
 	switch_to(prev, next, prev);
+	rcu_switch_to();
 
 	barrier();
 	/*
-- 
1.7.8

