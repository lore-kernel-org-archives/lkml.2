Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2CXBsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:48:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37426 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2CXBsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:48:06 -0400
Date: Fri, 23 Mar 2012 18:47:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.4
Message-ID: <20120324014755.GA4685@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120319152317.GA3932@gmail.com>
 <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com>
 <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
 <20120323192143.GY2450@linux.vnet.ibm.com>
 <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
 <20120323211638.GA2450@linux.vnet.ibm.com>
 <20120323212550.GA11791@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323212550.GA11791@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032401-3352-0000-0000-000003895BEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 02:25:50PM -0700, Paul E. McKenney wrote:
> On Fri, Mar 23, 2012 at 02:16:38PM -0700, Paul E. McKenney wrote:
> > On Fri, Mar 23, 2012 at 12:39:59PM -0700, Linus Torvalds wrote:
> > > On Fri, Mar 23, 2012 at 12:21 PM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > >>
> > > >> Please? Every time I look at some profiles, that silly rcu_read_lock
> > > >> is there in the profile. It's annoying. I'd rather see it in the
> > > >> function that invokes it.
> > > >
> > > > Let me see what I can do...
> > > 
> > > Thanks. To some degree, rcu_read_lock() is the more critical one,
> > > because it is often in the much more critical path in the caller. In
> > > particular, it's often at the beginning of a function, where a number
> > > of arguments are "live", and calling it out-of-line also forces the
> > > compiler to then save/restore those arguments (because they are
> > > clobbered by the function call).
> > > 
> > > rcu_read_unlock() is *usually* not as critical, and is obviously much
> > > harder to inline anyway due to the whole complexity with needing to
> > > check if an RCU sequence has ended. It often is at the end of the
> > > function call in the caller, when the only thing like is often just
> > > the single return value (if that). So it seldom looks nearly as bad in
> > > any profiles, because it doesn't tend to have the same kind of bad
> > > impact on the call site.
> > 
> > Very good to hear!  Especially since I am not seeing how to move
> > ->rcu_read_unlock_special to a per-CPU variable given that rcu_boost()
> > needs cross-task access to it.  There is probably some obvious trick,
> > but I will start with just __rcu_read_lock() for now.
> 
> And one obvious trick is a per-CPU pointer to the task-structure variable.
> But __rcu_read_lock() first.

And here is a preliminary patch with some known bugs (probably among
others), but useful for checking the __rcu_read_lock() code generation.

The known bugs include one where ->rcu_read_unlock_special can get paired
with the wrong call to rcu_read_unlock_special(), which can happen due to
the scheduler using RCU read-side primitives.  (I am currently leaning
towards an "ignore me" flag in ->rcu_read_unlock_special, but will see
how it goes.)  Another possible bug could occur if the scheduler enables
preemption on any code path reachable by __schedule().

Thoughts on code generation while I track down the other bugs?

This is what I get on a 32-bit build, according to objdump:

	24e3:       64 ff 05 00 00 00 00    incl   %fs:0x0

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make __rcu_read_lock() inlinable

The preemptible-RCU implementations of __rcu_read_lock() have not been
inlinable due to task_struct references that ran afoul of include-file
dependencies.  Fix this by moving the task_struct ->rcu_read_lock_nesting
field to a per-CPU variable that is saved and restored at context-switch
time.  With this change, __rcu_read_lock() references only that new
per-CPU variable, and so may be safely inlined.  This change also
allows some code that was duplicated in kernel/rcutree_plugin.h and
kernel/rcutiny_plugin.h to be merged into include/linux/rcupdate.h.

This same approach unfortunately cannot be used on __rcu_read_unlock()
because it also references the task_struct ->rcu_read_unlock_special
field, to which cross-task access is required by rcu_boost().  This
function will be handled in a separate commit, if need be.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Not-yet-signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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
index 9372174..9323ded 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -144,7 +144,19 @@ extern void synchronize_sched(void);
 
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
+	__raw_get_cpu_var(rcu_read_lock_nesting)++;
+	barrier(); /* Keep code within RCU read-side critical section. */
+}
+
 extern void __rcu_read_unlock(void);
 void synchronize_rcu(void);
 
@@ -154,7 +166,39 @@ void synchronize_rcu(void);
  * nesting depth, but makes sense only if CONFIG_PREEMPT_RCU -- in other
  * types of kernel builds, the rcu_read_lock() nesting depth is unknowable.
  */
-#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+#define rcu_preempt_depth() (__raw_get_cpu_var(rcu_read_lock_nesting))
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
+	return __raw_get_cpu_var(rcu_read_lock_nesting);
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
+	if (likely(__raw_get_cpu_var(rcu_read_lock_nesting) == 0))
+		return;
+	__raw_get_cpu_var(rcu_read_lock_nesting) = 1;
+	__rcu_read_unlock();
+}
 
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
@@ -178,9 +222,14 @@ static inline int rcu_preempt_depth(void)
 	return 0;
 }
 
+static inline void exit_rcu(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
+extern void rcu_note_context_switch_end(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e93df77..148c6db 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -91,10 +91,6 @@ static inline void rcu_preempt_note_context_switch(void)
 {
 }
 
-static inline void exit_rcu(void)
-{
-}
-
 static inline int rcu_needs_cpu(int cpu)
 {
 	return 0;
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
index 22ecea0..3495946 100644
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
@@ -522,21 +503,23 @@ void rcu_preempt_note_context_switch(void)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that current grace period continues to be blocked.
 	 */
+	t->rcu_read_lock_nesting_save =
+		__raw_get_cpu_var(rcu_read_lock_nesting);
+	__raw_get_cpu_var(rcu_read_lock_nesting) = 0;
 	rcu_preempt_cpu_qs();
 	local_irq_restore(flags);
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
+ * Restore the incoming task's value for rcu_read_lock_nesting at the
+ * end of a context switch.
  */
-void __rcu_read_lock(void)
+void rcu_note_context_switch_end(void)
 {
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
+	WARN_ON_ONCE(__raw_get_cpu_var(rcu_read_lock_nesting) != 0);
+	__raw_get_cpu_var(rcu_read_lock_nesting) =
+		current->rcu_read_lock_nesting_save;
 }
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
 /*
  * Handle special cases during rcu_read_unlock(), such as needing to
@@ -628,7 +611,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 
 /*
  * Tiny-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
  * invoke rcu_read_unlock_special() to clean up after a context switch
  * in an RCU read-side critical section and other special cases.
@@ -638,21 +621,21 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
+	if (__raw_get_cpu_var(rcu_read_lock_nesting) != 1)
+		--__raw_get_cpu_var(rcu_read_lock_nesting);
 	else {
-		t->rcu_read_lock_nesting = INT_MIN;
+		__raw_get_cpu_var(rcu_read_lock_nesting) = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
+		__raw_get_cpu_var(rcu_read_lock_nesting) = 0;
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+		int rln = ACCESS_ONCE(__raw_get_cpu_var(rcu_read_lock_nesting));
 
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
 	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
@@ -851,22 +834,6 @@ int rcu_preempt_needs_cpu(void)
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
index c023464..f075058 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -160,7 +160,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
-	if (t->rcu_read_lock_nesting > 0 &&
+	if (__raw_get_cpu_var(rcu_read_lock_nesting) > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -208,7 +208,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 				       ? rnp->gpnum
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	} else if (t->rcu_read_lock_nesting < 0 &&
+	} else if (__raw_get_cpu_var(rcu_read_lock_nesting) < 0 &&
 		   t->rcu_read_unlock_special) {
 
 		/*
@@ -228,21 +228,23 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * means that we continue to block the current grace period.
 	 */
 	local_irq_save(flags);
+	t->rcu_read_lock_nesting_save =
+		__raw_get_cpu_var(rcu_read_lock_nesting);
+	__raw_get_cpu_var(rcu_read_lock_nesting) = 0;
 	rcu_preempt_qs(cpu);
 	local_irq_restore(flags);
 }
 
 /*
- * Tree-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
+ * Restore the incoming task's value for rcu_read_lock_nesting at the
+ * end of a context switch.
  */
-void __rcu_read_lock(void)
+void rcu_note_context_switch_end(void)
 {
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
+	WARN_ON_ONCE(__raw_get_cpu_var(rcu_read_lock_nesting) != 0);
+	__raw_get_cpu_var(rcu_read_lock_nesting) =
+		current->rcu_read_lock_nesting_save;
 }
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
 /*
  * Check for preempted RCU readers blocking the current grace period
@@ -420,7 +422,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 
 /*
  * Tree-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
  * invoke rcu_read_unlock_special() to clean up after a context switch
  * in an RCU read-side critical section and other special cases.
@@ -429,22 +431,22 @@ void __rcu_read_unlock(void)
 {
 	struct task_struct *t = current;
 
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
+	if (__raw_get_cpu_var(rcu_read_lock_nesting) != 1)
+		--__raw_get_cpu_var(rcu_read_lock_nesting);
 	else {
 		barrier();  /* critical section before exit code. */
-		t->rcu_read_lock_nesting = INT_MIN;
+		__raw_get_cpu_var(rcu_read_lock_nesting) = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
+		__raw_get_cpu_var(rcu_read_lock_nesting) = 0;
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+		int rln = ACCESS_ONCE(__raw_get_cpu_var(rcu_read_lock_nesting));
 
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
 	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
@@ -668,11 +670,11 @@ static void rcu_preempt_check_callbacks(int cpu)
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
@@ -969,22 +971,6 @@ static void __init __rcu_init_preempt(void)
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..d4b14c5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3221,6 +3221,8 @@ need_resched:
 
 	post_schedule(rq);
 
+	rcu_note_context_switch_end();
+
 	preempt_enable_no_resched();
 	if (need_resched())
 		goto need_resched;

