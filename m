Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2CYUxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:53:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44651 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab2CYUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:53:22 -0400
Date: Sun, 25 Mar 2012 13:52:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
Message-ID: <20120325205249.GA29528@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032520-7408-0000-0000-000003B53CD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preemptible-RCU implementations of __rcu_read_lock() have not been
inlinable due to task_struct references that ran afoul of include-file
dependencies.  Fix this (as suggested by Linus) by moving the task_struct
->rcu_read_lock_nesting field to a per-CPU variable that is saved and
restored at context-switch time.  With this change, __rcu_read_lock()
references only that new per-CPU variable, and so may be safely
inlined.  This change also allows some code that was duplicated in
kernel/rcutree_plugin.h and kernel/rcutiny_plugin.h to be merged into
include/linux/rcupdate.h.

This same approach unfortunately cannot be used on __rcu_read_unlock()
because it also references the task_struct ->rcu_read_unlock_special
field, to which cross-task access is required by rcu_boost().  This
function will be handled in a separate commit, if need be.

The TREE_RCU variant passes modest rcutorture runs, while TINY_RCU still
has a few bugs.  Peter Zijlstra might have some thoughts on hooking into
the scheduler.  Disallows use of RCU from within the architecture-specific
switch_to() function, which probably runs afoul of tracing for at least
some architectures.  There probably are still a few other bugs, as well.

TREE_RCU should be OK for experimental usage.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Not-yet-signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/um/drivers/mconsole_kern.c |    2 
 include/linux/init_task.h       |    2 
 include/linux/rcupdate.h        |   66 +++++++++++++++++++++++++++++++-
 include/linux/rcutiny.h         |    7 ---
 include/linux/rcutree.h         |   12 -----
 include/linux/sched.h           |    4 -
 kernel/rcupdate.c               |    4 +
 kernel/rcutiny_plugin.h         |   82 ++++++++++++++++------------------------
 kernel/rcutree_plugin.h         |   72 +++++++++++++++++------------------
 kernel/sched/core.c             |    2 
 10 files changed, 145 insertions(+), 108 deletions(-)

The preemptible-RCU implementations of __rcu_read_lock() have not been
inlinable due to task_struct references that ran afoul of include-file
dependencies.  Fix this (as suggested by Linus) by moving the task_struct
->rcu_read_lock_nesting field to a per-CPU variable that is saved and
restored at context-switch time.  With this change, __rcu_read_lock()
references only that new per-CPU variable, and so may be safely
inlined.  This change also allows some code that was duplicated in
kernel/rcutree_plugin.h and kernel/rcutiny_plugin.h to be merged into
include/linux/rcupdate.h.

This same approach unfortunately cannot be used on __rcu_read_unlock()
because it also references the task_struct ->rcu_read_unlock_special
field, to which cross-task access is required by rcu_boost().  This
function will be handled in a separate commit, if need be.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index c70e047..a98693f 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -704,7 +704,9 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
+	rcu_switch_from();
 	switch_to(from, to, from);
+	rcu_switch_to();
 }
 
 /*
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..6148cd6 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -105,7 +105,7 @@ extern struct group_info init_groups;
 #endif
 #ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
-	.rcu_read_lock_nesting = 0,					\
+	.rcu_read_lock_nesting_save = 0,				\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
 	INIT_TASK_RCU_TREE_PREEMPT()					\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9372174..2921217 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -43,6 +43,7 @@
 #include <linux/completion.h>
 #include <linux/debugobjects.h>
 #include <linux/compiler.h>
+#include <linux/percpu.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -144,7 +145,19 @@ extern void synchronize_sched(void);
 
 #ifdef CONFIG_PREEMPT_RCU
 
-extern void __rcu_read_lock(void);
+DECLARE_PER_CPU(int, rcu_read_lock_nesting);
+
+/*
+ * Preemptible-RCU implementation for rcu_read_lock().  Just increment
+ * the per-CPU rcu_read_lock_nesting: Shared state and per-task state will
+ * be updated if we block.
+ */
+static inline void __rcu_read_lock(void)
+{
+	__this_cpu_inc(rcu_read_lock_nesting);
+	barrier(); /* Keep code within RCU read-side critical section. */
+}
+
 extern void __rcu_read_unlock(void);
 void synchronize_rcu(void);
 
@@ -154,7 +167,42 @@ void synchronize_rcu(void);
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
+static inline int rcu_preempt_running_reader(void)
+{
+	return __this_cpu_read(rcu_read_lock_nesting);
+}
+
+/*
+ * Check for a task exiting while in a preemptible-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.  To be called from the task-exit path, and nowhere else.
+ */
+static inline void exit_rcu(void)
+{
+	if (likely(__this_cpu_read(rcu_read_lock_nesting) == 0))
+		return;
+	__this_cpu_write(rcu_read_lock_nesting, 1);
+	__rcu_read_unlock();
+}
+
+void rcu_switch_from(void);
+void rcu_switch_to(void);
 
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
@@ -178,9 +226,23 @@ static inline int rcu_preempt_depth(void)
 	return 0;
 }
 
+static inline void rcu_switch_from(void)
+{
+}
+
+static inline void rcu_switch_to(void)
+{
+}
+
+static inline void exit_rcu(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
+extern void rcu_switch_from(void);
+extern void rcu_switch_to(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e93df77..ef39878 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,11 +87,7 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
-static inline void rcu_preempt_note_context_switch(void)
-{
-}
-
-static inline void exit_rcu(void)
+static void rcu_preempt_note_context_switch(void)
 {
 }
 
@@ -103,7 +99,6 @@ static inline int rcu_needs_cpu(int cpu)
 #else /* #ifdef CONFIG_TINY_RCU */
 
 void rcu_preempt_note_context_switch(void);
-extern void exit_rcu(void);
 int rcu_preempt_needs_cpu(void);
 
 static inline int rcu_needs_cpu(int cpu)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e8ee5dd..782a8ab 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,18 +45,6 @@ static inline void rcu_virt_note_context_switch(int cpu)
 	rcu_note_context_switch(cpu);
 }
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-extern void exit_rcu(void);
-
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-static inline void exit_rcu(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
-
 extern void synchronize_rcu_bh(void);
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692aba..f24bf6a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1275,7 +1275,7 @@ struct task_struct {
 	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
-	int rcu_read_lock_nesting;
+	int rcu_read_lock_nesting_save;
 	char rcu_read_unlock_special;
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
@@ -1868,7 +1868,7 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
-	p->rcu_read_lock_nesting = 0;
+	p->rcu_read_lock_nesting_save = 0;
 	p->rcu_read_unlock_special = 0;
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a86f174..91b8623 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -51,6 +51,10 @@
 
 #include "rcu.h"
 
+#ifdef CONFIG_PREEMPT_RCU
+DEFINE_PER_CPU(int, rcu_read_lock_nesting);
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..b842e8d 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -145,25 +145,6 @@ static int rcu_cpu_blocking_cur_gp(void)
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
@@ -522,21 +503,40 @@ void rcu_preempt_note_context_switch(void)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that current grace period continues to be blocked.
 	 */
+	t->rcu_read_lock_nesting_save =
+		__this_cpu_read(rcu_read_lock_nesting);
+	__this_cpu_write(rcu_read_lock_nesting, 0);
 	rcu_preempt_cpu_qs();
 	local_irq_restore(flags);
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
+ * Save the incoming task's value for rcu_read_lock_nesting at the
+ * end of a context switch.  There can be no process-state RCU read-side
+ * critical sections between the call to rcu_switch_from() and to
+ * rcu_switch_to().  Interrupt-level RCU read-side critical sections are
+ * OK because rcu_read_unlock_special() takes early exits when called
+ * at interrupt level.
+ */
+void rcu_switch_from(void)
+{
+	current->rcu_read_lock_nesting_save =
+		__this_cpu_read(rcu_read_lock_nesting);
+	barrier();
+	__this_cpu_write(rcu_read_lock_nesting, 0);
+}
+
+/*
+ * Restore the incoming task's value for rcu_read_lock_nesting at the
+ * end of a context switch.
  */
-void __rcu_read_lock(void)
+void rcu_switch_to(void)
 {
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
+	__this_cpu_write(rcu_read_lock_nesting,
+			 current->rcu_read_lock_nesting_save);
+	barrier();
+	current->rcu_read_lock_nesting_save = 0;
 }
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
 /*
  * Handle special cases during rcu_read_unlock(), such as needing to
@@ -628,7 +628,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 
 /*
  * Tiny-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
  * invoke rcu_read_unlock_special() to clean up after a context switch
  * in an RCU read-side critical section and other special cases.
@@ -638,21 +638,21 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
+	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
+		__this_cpu_dec(rcu_read_lock_nesting);
 	else {
-		t->rcu_read_lock_nesting = INT_MIN;
+		__this_cpu_write(rcu_read_lock_nesting, INT_MIN);
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
+		__this_cpu_write(rcu_read_lock_nesting, 0);
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+		int rln = __this_cpu_read(rcu_read_lock_nesting);
 
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
 	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
@@ -851,22 +851,6 @@ int rcu_preempt_needs_cpu(void)
 	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
 }
 
-/*
- * Check for a task exiting while in a preemptible -RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0)
-		return;
-	t->rcu_read_lock_nesting = 1;
-	__rcu_read_unlock();
-}
-
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_TRACE
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..8a19210 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -160,7 +160,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
-	if (t->rcu_read_lock_nesting > 0 &&
+	if (__this_cpu_read(rcu_read_lock_nesting) > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -208,7 +208,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 				       ? rnp->gpnum
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	} else if (t->rcu_read_lock_nesting < 0 &&
+	} else if (__this_cpu_read(rcu_read_lock_nesting) < 0 &&
 		   t->rcu_read_unlock_special) {
 
 		/*
@@ -233,16 +233,32 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Tree-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
+ * Save the incoming task's value for rcu_read_lock_nesting at the
+ * end of a context switch.  There can be no process-state RCU read-side
+ * critical sections between the call to rcu_switch_from() and to
+ * rcu_switch_to().  Interrupt-level RCU read-side critical sections are
+ * OK because rcu_read_unlock_special() takes early exits when called
+ * at interrupt level.
  */
-void __rcu_read_lock(void)
+void rcu_switch_from(void)
 {
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
+	current->rcu_read_lock_nesting_save =
+		__this_cpu_read(rcu_read_lock_nesting);
+	barrier();
+	__this_cpu_write(rcu_read_lock_nesting, 0);
+}
+
+/*
+ * Restore the incoming task's value for rcu_read_lock_nesting at the
+ * end of a context switch.
+ */
+void rcu_switch_to(void)
+{
+	__this_cpu_write(rcu_read_lock_nesting,
+			 current->rcu_read_lock_nesting_save);
+	barrier();
+	current->rcu_read_lock_nesting_save = 0;
 }
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
 /*
  * Check for preempted RCU readers blocking the current grace period
@@ -420,7 +436,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 
 /*
  * Tree-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
  * invoke rcu_read_unlock_special() to clean up after a context switch
  * in an RCU read-side critical section and other special cases.
@@ -429,22 +445,22 @@ void __rcu_read_unlock(void)
 {
 	struct task_struct *t = current;
 
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
+	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
+		__this_cpu_dec(rcu_read_lock_nesting);
 	else {
 		barrier();  /* critical section before exit code. */
-		t->rcu_read_lock_nesting = INT_MIN;
+		__this_cpu_write(rcu_read_lock_nesting, INT_MIN);
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
+		__this_cpu_write(rcu_read_lock_nesting, 0);
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+		int rln = __this_cpu_read(rcu_read_lock_nesting);
 
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
 	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
@@ -668,11 +684,11 @@ static void rcu_preempt_check_callbacks(int cpu)
 {
 	struct task_struct *t = current;
 
-	if (t->rcu_read_lock_nesting == 0) {
+	if (!rcu_preempt_running_reader()) {
 		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (t->rcu_read_lock_nesting > 0 &&
+	if (rcu_preempt_running_reader() > 0 &&
 	    per_cpu(rcu_preempt_data, cpu).qs_pending)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
@@ -969,22 +985,6 @@ static void __init __rcu_init_preempt(void)
 	rcu_init_one(&rcu_preempt_state, &rcu_preempt_data);
 }
 
-/*
- * Check for a task exiting while in a preemptible-RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0)
-		return;
-	t->rcu_read_lock_nesting = 1;
-	__rcu_read_unlock();
-}
-
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state = &rcu_sched_state;
@@ -1018,8 +1018,8 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Because preemptible RCU does not exist, we never have to check for
- * CPUs being in quiescent states.
+ * Because preemptible RCU does not exist, we never have to save or restore
+ * its state upon context switch.
  */
 static void rcu_preempt_note_context_switch(int cpu)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..9f10b76 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2051,7 +2051,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
+	rcu_switch_from();
 	switch_to(prev, next, prev);
+	rcu_switch_to();
 
 	barrier();
 	/*

