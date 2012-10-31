Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2JaBTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:19:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:53647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2JaBTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:19:16 -0400
Date: Wed, 31 Oct 2012 02:19:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.4-rt11
Message-ID: <alpine.LFD.2.02.1210310144210.2756@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.4-rt11 release.

Changes since 3.6.3-rt10:

   * Crypto wreckage fix (Milan Broz)

     Another proof why copy and paste should be forbidden, but if that
     would happen most of us would be serving time.

   * Another attempt to tame SLUB

     My previous approach turned out to be too naive though this one
     has at least held up against massive memory stress tests. It's a
     very simple and straight forward aproach now and while I'm quite
     sure that it will not fall over as it did before, there might be
     hidden latency issues with that new version.

      So please give it a proper testing!

   * Lazy preemption

     It has become an obsession to mitigate the determinism
     vs. throughput loss of RT. Looking at the mainline semantics of
     preemption points gives a hint why RT sucks throughput wise for
     ordinary SCHED_OTHER tasks. One major issue is the wakeup of
     tasks which are right away preempting the waking task while the
     waking task holds a lock on which the woken task will block right
     after having preempted the wakee. In mainline this is prevented
     due to the implicit preemption disable of spin/rw_lock held
     regions. On RT this is not possible due to the fully preemptible
     nature of sleeping spinlocks.

     Though for a SCHED_OTHER task preempting another SCHED_OTHER task
     this is really not a correctness issue. RT folks are concerned
     about SCHED_FIFO/RR tasks preemption and not about the purely
     fairness driven SCHED_OTHER preemption latencies.

     So I introduced a lazy preemption mechanism which only applies to
     SCHED_OTHER tasks preempting another SCHED_OTHER task. Aside of
     the existing preempt_count each tasks sports now a
     preempt_lazy_count which is manipulated on lock acquiry and
     release. This is slightly incorrect as for lazyness reasons I
     coupled this on migrate_disable/enable so some other mechanisms
     get the same treatment (e.g. get_cpu_light).

     Now on the scheduler side instead of setting NEED_RESCHED this
     sets NEED_RESCHED_LAZY in case of a SCHED_OTHER/SCHED_OTHER
     preemption and therefor allows to exit the waking task the lock
     held region before the woken task preempts. That also works
     better for cross CPU wakeups as the other side can stay in the
     adaptive spinning loop.

     For RT class preemption there is no change. This simply sets
     NEED_RESCHED and forgoes the lazy preemption counter.

     Initial test do not expose any observable latency increasement,
     but history shows that I've been proven wrong before :)

     The lazy preemption mode is per default on, but with
     CONFIG_SCHED_DEBUG enabled it can be disabled via:

     # echo NO_PREEMPT_LAZY >/sys/kernel/debug/sched_features

     and reenabled via

     # echo PREEMPT_LAZY >/sys/kernel/debug/sched_features

     The test results so far are very machine and workload dependent,
     but there is a clear trend that it enhances the non RT workload
     performance.

     Please give it a try and share your experience!

Known issues:

      There is still some "softirq pending xx" fallout which I have
      not been able to investigate yet, but that's on my top priority
      list. It's not a critical issue and only annoys people with
      CONFIG_NO_HZ=y configurations.
    

The delta patch against 3.6.4-rt10 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.4-rt10-rt11.patch.xz


The RT patch against 3.6.4 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.4-rt11.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.4-rt11.tar.xz

Enjoy,

	tglx

------------->

Index: linux-stable/arch/x86/Kconfig
===================================================================
--- linux-stable.orig/arch/x86/Kconfig
+++ linux-stable/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_PREEMPT_LAZY
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
Index: linux-stable/arch/x86/kernel/entry_64.S
===================================================================
--- linux-stable.orig/arch/x86/kernel/entry_64.S
+++ linux-stable/arch/x86/kernel/entry_64.S
@@ -1003,9 +1003,15 @@ retint_signal:
 ENTRY(retint_kernel)
 	cmpl $0,TI_preempt_count(%rcx)
 	jnz  retint_restore_args
-	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
+	bt   $TIF_NEED_RESCHED,TI_flags(%rcx)
+	jc   1f
+
+	cmpl $0,TI_preempt_lazy_count(%rcx)
+	jnz  retint_restore_args
+	bt   $TIF_NEED_RESCHED_LAZY,TI_flags(%rcx)
 	jnc  retint_restore_args
-	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
+
+1:	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
 	call preempt_schedule_irq
 	jmp exit_intr
Index: linux-stable/crypto/algapi.c
===================================================================
--- linux-stable.orig/crypto/algapi.c
+++ linux-stable/crypto/algapi.c
@@ -956,7 +956,6 @@ EXPORT_SYMBOL_GPL(crypto_xor);
 
 static int __init crypto_algapi_init(void)
 {
-	srcu_init_notifier_head(&crypto_chain);
 	crypto_init_proc();
 	return 0;
 }
Index: linux-stable/include/linux/ftrace_event.h
===================================================================
--- linux-stable.orig/include/linux/ftrace_event.h
+++ linux-stable/include/linux/ftrace_event.h
@@ -51,6 +51,7 @@ struct trace_entry {
 	int			pid;
 	unsigned short		migrate_disable;
 	unsigned short		padding;
+	unsigned char		preempt_lazy_count;
 };
 
 #define FTRACE_MAX_EVENT						\
Index: linux-stable/include/linux/preempt.h
===================================================================
--- linux-stable.orig/include/linux/preempt.h
+++ linux-stable/include/linux/preempt.h
@@ -23,15 +23,38 @@
 
 #define preempt_count()	(current_thread_info()->preempt_count)
 
+#ifdef CONFIG_HAVE_PREEMPT_LAZY
+#define add_preempt_lazy_count(val)	do { preempt_lazy_count() += (val); } while (0)
+#define sub_preempt_lazy_count(val)	do { preempt_lazy_count() -= (val); } while (0)
+#define inc_preempt_lazy_count()	add_preempt_lazy_count(1)
+#define dec_preempt_lazy_count()	sub_preempt_lazy_count(1)
+#define preempt_lazy_count()		(current_thread_info()->preempt_lazy_count)
+#else
+#define add_preempt_lazy_count(val)	do { } while (0)
+#define sub_preempt_lazy_count(val)	do { } while (0)
+#define inc_preempt_lazy_count()	do { } while (0)
+#define dec_preempt_lazy_count()	do { } while (0)
+#define preempt_lazy_count()		(0)
+#endif
+
 #ifdef CONFIG_PREEMPT
 
 asmlinkage void preempt_schedule(void);
 
+# ifdef CONFIG_HAVE_PREEMPT_LAZY
+#define preempt_check_resched() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED) || \
+		     test_thread_flag(TIF_NEED_RESCHED_LAZY)))  \
+		preempt_schedule(); \
+} while (0)
+# else
 #define preempt_check_resched() \
 do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))	\
 		preempt_schedule(); \
 } while (0)
+# endif
 
 #else /* !CONFIG_PREEMPT */
 
@@ -48,6 +71,12 @@ do { \
 	barrier(); \
 } while (0)
 
+#define preempt_lazy_disable() \
+do { \
+	inc_preempt_lazy_count(); \
+	barrier(); \
+} while (0)
+
 #define sched_preempt_enable_no_resched() \
 do { \
 	barrier(); \
@@ -69,6 +98,13 @@ do { \
 	preempt_check_resched(); \
 } while (0)
 
+#define preempt_lazy_enable() \
+do { \
+	dec_preempt_lazy_count(); \
+	barrier(); \
+	preempt_check_resched(); \
+} while (0)
+
 /* For debugging and tracer internals only! */
 #define add_preempt_count_notrace(val)			\
 	do { preempt_count() += (val); } while (0)
Index: linux-stable/include/linux/sched.h
===================================================================
--- linux-stable.orig/include/linux/sched.h
+++ linux-stable/include/linux/sched.h
@@ -2660,6 +2660,52 @@ static inline int test_tsk_need_resched(
 	return unlikely(test_tsk_thread_flag(tsk,TIF_NEED_RESCHED));
 }
 
+#ifdef CONFIG_HAVE_PREEMPT_LAZY
+static inline void set_tsk_need_resched_lazy(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk,TIF_NEED_RESCHED_LAZY);
+}
+
+static inline void clear_tsk_need_resched_lazy(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk,TIF_NEED_RESCHED_LAZY);
+}
+
+static inline int test_tsk_need_resched_lazy(struct task_struct *tsk)
+{
+	return unlikely(test_tsk_thread_flag(tsk,TIF_NEED_RESCHED_LAZY));
+}
+
+static inline int need_resched_lazy(void)
+{
+	return test_thread_flag(TIF_NEED_RESCHED_LAZY);
+}
+
+static inline int need_resched_now(void)
+{
+	return test_thread_flag(TIF_NEED_RESCHED);
+}
+
+static inline int need_resched(void)
+{
+	return test_thread_flag(TIF_NEED_RESCHED) ||
+		test_thread_flag(TIF_NEED_RESCHED_LAZY);
+}
+#else
+static inline void clear_tsk_need_resched_lazy(struct task_struct *tsk) { }
+static inline int need_resched_lazy(void) { return 0; }
+
+static inline int need_resched_now(void)
+{
+	return test_thread_flag(TIF_NEED_RESCHED);
+}
+
+static inline int need_resched(void)
+{
+	return test_thread_flag(TIF_NEED_RESCHED);
+}
+#endif
+
 static inline int restart_syscall(void)
 {
 	set_tsk_thread_flag(current, TIF_SIGPENDING);
@@ -2691,11 +2737,6 @@ static inline int signal_pending_state(l
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 
-static inline int need_resched(void)
-{
-	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
-}
-
 /*
  * cond_resched() and cond_resched_lock(): latency reduction via
  * explicit rescheduling in places that are safe. The return
Index: linux-stable/kernel/Kconfig.preempt
===================================================================
--- linux-stable.orig/kernel/Kconfig.preempt
+++ linux-stable/kernel/Kconfig.preempt
@@ -6,6 +6,9 @@ config PREEMPT_RT_BASE
 	bool
 	select PREEMPT
 
+config HAVE_PREEMPT_LAZY
+	bool
+
 choice
 	prompt "Preemption Model"
 	default PREEMPT_NONE
Index: linux-stable/kernel/sched/core.c
===================================================================
--- linux-stable.orig/kernel/sched/core.c
+++ linux-stable/kernel/sched/core.c
@@ -534,6 +534,37 @@ void resched_task(struct task_struct *p)
 		smp_send_reschedule(cpu);
 }
 
+#ifdef CONFIG_HAVE_PREEMPT_LAZY
+void resched_task_lazy(struct task_struct *p)
+{
+	int cpu;
+
+	if (!sched_feat(PREEMPT_LAZY)) {
+		resched_task(p);
+		return;
+	}
+
+	assert_raw_spin_locked(&task_rq(p)->lock);
+
+	if (test_tsk_need_resched(p))
+		return;
+
+	if (test_tsk_need_resched_lazy(p))
+		return;
+
+	set_tsk_need_resched_lazy(p);
+
+	cpu = task_cpu(p);
+	if (cpu == smp_processor_id())
+		return;
+
+	/* NEED_RESCHED_LAZY must be visible before we test polling */
+	smp_mb();
+	if (!tsk_is_polling(p))
+		smp_send_reschedule(cpu);
+}
+#endif
+
 void resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -650,6 +681,17 @@ void resched_task(struct task_struct *p)
 	assert_raw_spin_locked(&task_rq(p)->lock);
 	set_tsk_need_resched(p);
 }
+#ifdef CONFIG_HAVE_PREEMPT_LAZY
+void resched_task_lazy(struct task_struct *p)
+{
+	if (!sched_feat(PREEMPT_LAZY)) {
+		resched_task(p);
+		return;
+	}
+	assert_raw_spin_locked(&task_rq(p)->lock);
+	set_tsk_need_resched_lazy(p);
+}
+#endif
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
@@ -3448,6 +3490,7 @@ void migrate_disable(void)
 		return;
 	}
 
+	preempt_lazy_disable();
 	pin_current_cpu();
 	p->migrate_disable = 1;
 	preempt_enable();
@@ -3503,6 +3546,7 @@ void migrate_enable(void)
 
 	unpin_current_cpu();
 	preempt_enable();
+	preempt_lazy_enable();
 }
 EXPORT_SYMBOL(migrate_enable);
 #else
@@ -3603,6 +3647,7 @@ need_resched:
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);
+	clear_tsk_need_resched_lazy(prev);
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
@@ -3724,6 +3769,14 @@ asmlinkage void __sched notrace preempt_
 	if (likely(ti->preempt_count || irqs_disabled()))
 		return;
 
+#ifdef CONFIG_HAVE_PREEMPT_LAZY
+	/*
+	 * Check for lazy preemption
+	 */
+	if (ti->preempt_lazy_count && !test_thread_flag(TIF_NEED_RESCHED))
+		return;
+#endif
+
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
 		/*
@@ -5331,6 +5384,7 @@ void __cpuinit init_idle(struct task_str
 
 	/* Set the preempt count _outside_ the spinlocks! */
 	task_thread_info(idle)->preempt_count = 0;
+	task_thread_info(idle)->preempt_lazy_count = 0;
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:
Index: linux-stable/kernel/sched/features.h
===================================================================
--- linux-stable.orig/kernel/sched/features.h
+++ linux-stable/kernel/sched/features.h
@@ -68,8 +68,10 @@ SCHED_FEAT(NONTASK_POWER, true)
 SCHED_FEAT(TTWU_QUEUE, true)
 #else
 SCHED_FEAT(TTWU_QUEUE, false)
+SCHED_FEAT(PREEMPT_LAZY, true)
 #endif
 
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
+
Index: linux-stable/kernel/trace/trace.c
===================================================================
--- linux-stable.orig/kernel/trace/trace.c
+++ linux-stable/kernel/trace/trace.c
@@ -1152,6 +1152,7 @@ tracing_generic_entry_update(struct trac
 	struct task_struct *tsk = current;
 
 	entry->preempt_count		= pc & 0xff;
+	entry->preempt_lazy_count	= preempt_lazy_count();
 	entry->pid			= (tsk) ? tsk->pid : 0;
 	entry->padding			= 0;
 	entry->flags =
@@ -1162,7 +1163,8 @@ tracing_generic_entry_update(struct trac
 #endif
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
-		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
+		(need_resched_now() ? TRACE_FLAG_NEED_RESCHED : 0) |
+		(need_resched_lazy() ? TRACE_FLAG_NEED_RESCHED_LAZY : 0);
 
 	entry->migrate_disable	= (tsk) ? __migrate_disabled(tsk) & 0xFF : 0;
 }
@@ -1985,15 +1987,17 @@ get_total_entries(struct trace_array *tr
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                  _------=> CPU#            \n");
-	seq_puts(m, "#                 / _-----=> irqs-off        \n");
-	seq_puts(m, "#                | / _----=> need-resched    \n");
-	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
-	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#                |||| / _--=> migrate-disable\n");
-	seq_puts(m, "#                ||||| /     delay           \n");
-	seq_puts(m, "#  cmd     pid   |||||| time  |   caller     \n");
-	seq_puts(m, "#     \\   /      |||||  \\   |   /          \n");
+	seq_puts(m, "#                   _--------=> CPU#              \n");
+	seq_puts(m, "#                  / _-------=> irqs-off          \n");
+	seq_puts(m, "#                 | / _------=> need-resched      \n");
+	seq_puts(m, "#                 || / _-----=> need-resched_lazy \n");
+	seq_puts(m, "#                 ||| / _----=> hardirq/softirq   \n");
+	seq_puts(m, "#                 |||| / _---=> preempt-depth     \n");
+	seq_puts(m, "#                 ||||| / _--=> preempt-lazy-depth\n");
+	seq_puts(m, "#                 |||||| / _-=> migrate-disable   \n");
+	seq_puts(m, "#                 ||||||| /     delay             \n");
+	seq_puts(m, "#  cmd     pid    |||||||| time  |   caller       \n");
+	seq_puts(m, "#     \\   /      ||||||||  \\   |   /            \n");
 }
 
 static void print_event_info(struct trace_array *tr, struct seq_file *m)
@@ -2017,13 +2021,16 @@ static void print_func_help_header(struc
 static void print_func_help_header_irq(struct trace_array *tr, struct seq_file *m)
 {
 	print_event_info(tr, m);
-	seq_puts(m, "#                              _-----=> irqs-off\n");
-	seq_puts(m, "#                             / _----=> need-resched\n");
-	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
-	seq_puts(m, "#                            || / _--=> preempt-depth\n");
-	seq_puts(m, "#                            ||| /     delay\n");
-	seq_puts(m, "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |   ||||       |         |\n");
+	seq_puts(m, "#                              _-------=> irqs-off          \n");
+	seq_puts(m, "#                            /  _------=> need-resched      \n");
+	seq_puts(m, "#                            |/  _-----=> need-resched_lazy \n");
+	seq_puts(m, "#                            ||/  _----=> hardirq/softirq   \n");
+	seq_puts(m, "#                            |||/  _---=> preempt-depth     \n");
+	seq_puts(m, "#                            ||||/  _--=> preempt-lazy-depth\n");
+	seq_puts(m, "#                            ||||| / _-=> migrate-disable   \n");
+	seq_puts(m, "#                            |||||| /     delay\n");
+	seq_puts(m, "#           TASK-PID   CPU#  |||||||    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#              | |       |   |||||||       |         |\n");
 }
 
 void
Index: linux-stable/kernel/trace/trace.h
===================================================================
--- linux-stable.orig/kernel/trace/trace.h
+++ linux-stable/kernel/trace/trace.h
@@ -116,6 +116,7 @@ struct uprobe_trace_entry_head {
  *  NEED_RESCHED	- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
+ *  NEED_RESCHED_LAZY	- lazy reschedule is requested
  */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
@@ -123,6 +124,7 @@ enum trace_flag_type {
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
+	TRACE_FLAG_NEED_RESCHED_LAZY	= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
Index: linux-stable/kernel/trace/trace_output.c
===================================================================
--- linux-stable.orig/kernel/trace/trace_output.c
+++ linux-stable/kernel/trace/trace_output.c
@@ -564,6 +564,7 @@ int trace_print_lat_fmt(struct trace_seq
 {
 	char hardsoft_irq;
 	char need_resched;
+	char need_resched_lazy;
 	char irqs_off;
 	int hardirq;
 	int softirq;
@@ -578,14 +579,17 @@ int trace_print_lat_fmt(struct trace_seq
 		'.';
 	need_resched =
 		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
+	need_resched_lazy =
+		(entry->flags & TRACE_FLAG_NEED_RESCHED_LAZY) ? 'L' : '.';
 	hardsoft_irq =
 		(hardirq && softirq) ? 'H' :
 		hardirq ? 'h' :
 		softirq ? 's' :
 		'.';
 
-	if (!trace_seq_printf(s, "%c%c%c",
-			      irqs_off, need_resched, hardsoft_irq))
+	if (!trace_seq_printf(s, "%c%c%c%c",
+			      irqs_off, need_resched, need_resched_lazy,
+			      hardsoft_irq))
 		return 0;
 
 	if (entry->preempt_count)
@@ -593,6 +597,11 @@ int trace_print_lat_fmt(struct trace_seq
 	else
 		ret = trace_seq_putc(s, '.');
 
+	if (entry->preempt_lazy_count)
+		ret = trace_seq_printf(s, "%x", entry->preempt_lazy_count);
+	else
+		ret = trace_seq_putc(s, '.');
+
 	if (entry->migrate_disable)
 		ret = trace_seq_printf(s, "%x", entry->migrate_disable);
 	else
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt10
+-rt11
Index: linux-stable/mm/slub.c
===================================================================
--- linux-stable.orig/mm/slub.c
+++ linux-stable/mm/slub.c
@@ -31,7 +31,6 @@
 #include <linux/fault-inject.h>
 #include <linux/stacktrace.h>
 #include <linux/prefetch.h>
-#include <linux/locallock.h>
 
 #include <trace/events/kmem.h>
 
@@ -226,8 +225,6 @@ static inline void stat(const struct kme
 #endif
 }
 
-static DEFINE_LOCAL_IRQ_LOCK(slub_lock);
-
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -1256,6 +1253,12 @@ static inline void slab_free_hook(struct
 
 #endif /* CONFIG_SLUB_DEBUG */
 
+struct slub_free_list {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+static DEFINE_PER_CPU(struct slub_free_list, slub_free_list);
+
 /*
  * Slab allocation and freeing
  */
@@ -1280,8 +1283,12 @@ static struct page *allocate_slab(struct
 
 	flags &= gfp_allowed_mask;
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (system_state == SYSTEM_RUNNING)
+#else
 	if (flags & __GFP_WAIT)
-		local_unlock_irq(slub_lock);
+#endif
+		local_irq_enable();
 
 	flags |= s->allocflags;
 
@@ -1320,8 +1327,12 @@ static struct page *allocate_slab(struct
 			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (system_state == SYSTEM_RUNNING)
+#else
 	if (flags & __GFP_WAIT)
-		local_lock_irq(slub_lock);
+#endif
+		local_irq_disable();
 	if (!page)
 		return NULL;
 
@@ -1412,6 +1423,16 @@ static void __free_slab(struct kmem_cach
 	__free_pages(page, order);
 }
 
+static void free_delayed(struct kmem_cache *s, struct list_head *h)
+{
+	while(!list_empty(h)) {
+		struct page *page = list_first_entry(h, struct page, lru);
+
+		list_del(&page->lru);
+		__free_slab(s, page);
+	}
+}
+
 #define need_reserve_slab_rcu						\
 	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
 
@@ -1446,6 +1467,12 @@ static void free_slab(struct kmem_cache 
 		}
 
 		call_rcu(head, rcu_free_slab);
+	} else if (irqs_disabled()) {
+		struct slub_free_list *f = &__get_cpu_var(slub_free_list);
+
+		raw_spin_lock(&f->lock);
+		list_add(&page->lru, &f->list);
+		raw_spin_unlock(&f->lock);
 	} else
 		__free_slab(s, page);
 }
@@ -1547,7 +1574,7 @@ static void *get_partial_node(struct kme
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	spin_lock(&n->list_lock);
+	raw_spin_lock(&n->list_lock);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
 		void *t;
 		int available;
@@ -1572,7 +1599,7 @@ static void *get_partial_node(struct kme
 			break;
 
 	}
-	spin_unlock(&n->list_lock);
+	raw_spin_unlock(&n->list_lock);
 	return object;
 }
 
@@ -1814,7 +1841,7 @@ redo:
 			 * that acquire_slab() will see a slab page that
 			 * is frozen
 			 */
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 	} else {
 		m = M_FULL;
@@ -1825,7 +1852,7 @@ redo:
 			 * slabs from diagnostic functions will not see
 			 * any frozen slabs.
 			 */
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 	}
 
@@ -1860,7 +1887,7 @@ redo:
 		goto redo;
 
 	if (lock)
-		spin_unlock(&n->list_lock);
+		raw_spin_unlock(&n->list_lock);
 
 	if (m == M_FREE) {
 		stat(s, DEACTIVATE_EMPTY);
@@ -1874,10 +1901,10 @@ redo:
  *
  * This function must be called with interrupt disabled.
  */
-static void unfreeze_partials(struct kmem_cache *s, unsigned int cpu)
+static void unfreeze_partials(struct kmem_cache *s,
+		struct kmem_cache_cpu *c)
 {
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
-	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 	struct page *page, *discard_page = NULL;
 
 	while ((page = c->partial)) {
@@ -1889,10 +1916,10 @@ static void unfreeze_partials(struct kme
 		n2 = get_node(s, page_to_nid(page));
 		if (n != n2) {
 			if (n)
-				spin_unlock(&n->list_lock);
+				raw_spin_unlock(&n->list_lock);
 
 			n = n2;
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 
 		do {
@@ -1921,7 +1948,7 @@ static void unfreeze_partials(struct kme
 	}
 
 	if (n)
-		spin_unlock(&n->list_lock);
+		raw_spin_unlock(&n->list_lock);
 
 	while (discard_page) {
 		page = discard_page;
@@ -1942,7 +1969,7 @@ static void unfreeze_partials(struct kme
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
  */
-int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 {
 	struct page *oldpage;
 	int pages;
@@ -1957,14 +1984,21 @@ int put_cpu_partial(struct kmem_cache *s
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
 			if (drain && pobjects > s->cpu_partial) {
+				struct slub_free_list *f;
 				unsigned long flags;
+				LIST_HEAD(tofree);
 				/*
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
-				local_lock_irqsave(slub_lock, flags);
-				unfreeze_partials(s, smp_processor_id());
-				local_unlock_irqrestore(slub_lock, flags);
+				local_irq_save(flags);
+				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+				f = &__get_cpu_var(slub_free_list);
+				raw_spin_lock(&f->lock);
+				list_splice_init(&f->list, &tofree);
+				raw_spin_unlock(&f->lock);
+				local_irq_restore(flags);
+				free_delayed(s, &tofree);
 				pobjects = 0;
 				pages = 0;
 				stat(s, CPU_PARTIAL_DRAIN);
@@ -2005,19 +2039,10 @@ static inline void __flush_cpu_slab(stru
 		if (c->page)
 			flush_slab(s, c);
 
-		unfreeze_partials(s, cpu);
+		unfreeze_partials(s, c);
 	}
 }
 
-static bool has_cpu_slab(int cpu, void *info)
-{
-	struct kmem_cache *s = info;
-	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
-
-	return c->page || c->partial;
-}
-
-#ifndef CONFIG_PREEMPT_RT_FULL
 static void flush_cpu_slab(void *d)
 {
 	struct kmem_cache *s = d;
@@ -2025,21 +2050,33 @@ static void flush_cpu_slab(void *d)
 	__flush_cpu_slab(s, smp_processor_id());
 }
 
-static void flush_all(struct kmem_cache *s)
+static bool has_cpu_slab(int cpu, void *info)
 {
-	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
+	struct kmem_cache *s = info;
+	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+
+	return c->page || c->partial;
 }
-#else
+
 static void flush_all(struct kmem_cache *s)
 {
+	LIST_HEAD(tofree);
 	int cpu;
 
+	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
 	for_each_online_cpu(cpu) {
-		if (has_cpu_slab(cpu, s))
-			__flush_cpu_slab(s, cpu);
+		struct slub_free_list *f;
+
+		if (!has_cpu_slab(cpu, s))
+			continue;
+
+		f = &per_cpu(slub_free_list, cpu);
+		raw_spin_lock_irq(&f->lock);
+		list_splice_init(&f->list, &tofree);
+		raw_spin_unlock_irq(&f->lock);
+		free_delayed(s, &tofree);
 	}
 }
-#endif
 
 /*
  * Check if the objects in a per cpu structure fit numa
@@ -2066,10 +2103,10 @@ static unsigned long count_partial(struc
 	unsigned long x = 0;
 	struct page *page;
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	raw_spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry(page, &n->partial, lru)
 		x += get_count(page);
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
 
@@ -2212,11 +2249,13 @@ static inline void *get_freelist(struct 
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
+	struct slub_free_list *f;
 	void *freelist;
 	struct page *page;
 	unsigned long flags;
+	LIST_HEAD(tofree);
 
-	local_lock_irqsave(slub_lock, flags);
+	local_irq_save(flags);
 #ifdef CONFIG_PREEMPT
 	/*
 	 * We may have been preempted and rescheduled on a different
@@ -2277,7 +2316,13 @@ load_freelist:
 	VM_BUG_ON(!c->page->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
-	local_unlock_irqrestore(slub_lock, flags);
+out:
+	f = &__get_cpu_var(slub_free_list);
+	raw_spin_lock(&f->lock);
+	list_splice_init(&f->list, &tofree);
+	raw_spin_unlock(&f->lock);
+	local_irq_restore(flags);
+	free_delayed(s, &tofree);
 	return freelist;
 
 new_slab:
@@ -2295,9 +2340,7 @@ new_slab:
 	if (unlikely(!freelist)) {
 		if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 			slab_out_of_memory(s, gfpflags, node);
-
-		local_unlock_irqrestore(slub_lock, flags);
-		return NULL;
+		goto out;
 	}
 
 	page = c->page;
@@ -2311,8 +2354,7 @@ new_slab:
 	deactivate_slab(s, page, get_freepointer(s, freelist));
 	c->page = NULL;
 	c->freelist = NULL;
-	local_unlock_irqrestore(slub_lock, flags);
-	return freelist;
+	goto out;
 }
 
 /*
@@ -2503,8 +2545,7 @@ static void __slab_free(struct kmem_cach
 				 * Otherwise the list_lock will synchronize with
 				 * other processors updating the list of slabs.
 				 */
-				local_spin_lock_irqsave(slub_lock,
-							&n->list_lock, flags);
+				raw_spin_lock_irqsave(&n->list_lock, flags);
 
 			}
 		}
@@ -2554,7 +2595,7 @@ static void __slab_free(struct kmem_cach
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
-	local_spin_unlock_irqrestore(slub_lock, &n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return;
 
 slab_empty:
@@ -2568,7 +2609,7 @@ slab_empty:
 		/* Slab must be on the full list */
 		remove_full(s, page);
 
-	local_spin_unlock_irqrestore(slub_lock, &n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 }
@@ -2797,7 +2838,7 @@ static void
 init_kmem_cache_node(struct kmem_cache_node *n)
 {
 	n->nr_partial = 0;
-	spin_lock_init(&n->list_lock);
+	raw_spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
@@ -3540,7 +3581,7 @@ int kmem_cache_shrink(struct kmem_cache 
 		for (i = 0; i < objects; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
 
-		spin_lock_irqsave(&n->list_lock, flags);
+		raw_spin_lock_irqsave(&n->list_lock, flags);
 
 		/*
 		 * Build lists indexed by the items in use in each slab.
@@ -3561,7 +3602,7 @@ int kmem_cache_shrink(struct kmem_cache 
 		for (i = objects - 1; i > 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		raw_spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
 		list_for_each_entry_safe(page, t, slabs_by_inuse, lru)
@@ -3727,10 +3768,15 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 	struct kmem_cache *temp_kmem_cache;
-	int order;
+	int order, cpu;
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
 
+	for_each_possible_cpu(cpu) {
+		raw_spin_lock_init(&per_cpu(slub_free_list, cpu).lock);
+		INIT_LIST_HEAD(&per_cpu(slub_free_list, cpu).list);
+	}
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
@@ -4018,9 +4064,9 @@ static int __cpuinit slab_cpuup_callback
 	case CPU_DEAD_FROZEN:
 		mutex_lock(&slab_mutex);
 		list_for_each_entry(s, &slab_caches, list) {
-			local_lock_irqsave(slub_lock, flags);
+			local_irq_save(flags);
 			__flush_cpu_slab(s, cpu);
-			local_unlock_irqrestore(slub_lock, flags);
+			local_irq_restore(flags);
 		}
 		mutex_unlock(&slab_mutex);
 		break;
@@ -4143,7 +4189,7 @@ static int validate_slab_node(struct kme
 	struct page *page;
 	unsigned long flags;
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	raw_spin_lock_irqsave(&n->list_lock, flags);
 
 	list_for_each_entry(page, &n->partial, lru) {
 		validate_slab_slab(s, page, map);
@@ -4166,7 +4212,7 @@ static int validate_slab_node(struct kme
 			atomic_long_read(&n->nr_slabs));
 
 out:
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return count;
 }
 
@@ -4356,12 +4402,12 @@ static int list_locations(struct kmem_ca
 		if (!atomic_long_read(&n->nr_slabs))
 			continue;
 
-		spin_lock_irqsave(&n->list_lock, flags);
+		raw_spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->partial, lru)
 			process_slab(&t, s, page, alloc, map);
 		list_for_each_entry(page, &n->full, lru)
 			process_slab(&t, s, page, alloc, map);
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
 	for (i = 0; i < t.count; i++) {
Index: linux-stable/include/linux/slub_def.h
===================================================================
--- linux-stable.orig/include/linux/slub_def.h
+++ linux-stable/include/linux/slub_def.h
@@ -54,7 +54,7 @@ struct kmem_cache_cpu {
 };
 
 struct kmem_cache_node {
-	spinlock_t list_lock;	/* Protect partial list and nr_partial */
+	raw_spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
Index: linux-stable/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-stable.orig/arch/x86/include/asm/thread_info.h
+++ linux-stable/arch/x86/include/asm/thread_info.h
@@ -31,6 +31,8 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			preempt_lazy_count;	/* 0 => lazy preemptable,
+							   <0 => BUG */
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
@@ -83,6 +85,7 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
+#define TIF_NEED_RESCHED_LAZY	9	/* lazy rescheduling necessary */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
@@ -108,6 +111,7 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_NEED_RESCHED_LAZY	(1 << TIF_NEED_RESCHED_LAZY)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
Index: linux-stable/arch/x86/kernel/asm-offsets.c
===================================================================
--- linux-stable.orig/arch/x86/kernel/asm-offsets.c
+++ linux-stable/arch/x86/kernel/asm-offsets.c
@@ -33,6 +33,7 @@ void common(void) {
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
 	OFFSET(TI_preempt_count, thread_info, preempt_count);
+	OFFSET(TI_preempt_lazy_count, thread_info, preempt_lazy_count);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
Index: linux-stable/arch/x86/kernel/entry_32.S
===================================================================
--- linux-stable.orig/arch/x86/kernel/entry_32.S
+++ linux-stable/arch/x86/kernel/entry_32.S
@@ -352,8 +352,14 @@ ENTRY(resume_kernel)
 need_resched:
 	movl TI_flags(%ebp), %ecx	# need_resched set ?
 	testb $_TIF_NEED_RESCHED, %cl
+	jnz 1f
+
+	cmpl $0,TI_preempt_lazy_count(%ebp)	# non-zero preempt_lazy_count ?
+	jnz  restore_all
+	testb $_TIF_NEED_RESCHED_LAZY, %cl
 	jz restore_all
-	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
+
+1:	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
 	jz restore_all
 	call preempt_schedule_irq
 	jmp need_resched
Index: linux-stable/kernel/sched/fair.c
===================================================================
--- linux-stable.orig/kernel/sched/fair.c
+++ linux-stable/kernel/sched/fair.c
@@ -1222,7 +1222,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_task_lazy(rq_of(cfs_rq)->curr);
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -1246,7 +1246,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 		return;
 
 	if (delta > ideal_runtime)
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_task_lazy(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -1363,7 +1363,7 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 	 * validating it and just reschedule.
 	 */
 	if (queued) {
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_task_lazy(rq_of(cfs_rq)->curr);
 		return;
 	}
 	/*
@@ -1543,7 +1543,7 @@ static void __account_cfs_rq_runtime(str
 	 * hierarchy can be throttled
 	 */
 	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_task_lazy(rq_of(cfs_rq)->curr);
 }
 
 static __always_inline
@@ -2129,7 +2129,7 @@ static void hrtick_start_fair(struct rq 
 
 		if (delta < 0) {
 			if (rq->curr == p)
-				resched_task(p);
+				resched_task_lazy(p);
 			return;
 		}
 
@@ -2954,7 +2954,7 @@ static void check_preempt_wakeup(struct 
 	return;
 
 preempt:
-	resched_task(curr);
+	resched_task_lazy(curr);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
@@ -5027,7 +5027,7 @@ static void task_fork_fair(struct task_s
 		 * 'current' within the tree based on its new key value.
 		 */
 		swap(curr->vruntime, se->vruntime);
-		resched_task(rq->curr);
+		resched_task_lazy(rq->curr);
 	}
 
 	se->vruntime -= cfs_rq->min_vruntime;
@@ -5052,7 +5052,7 @@ prio_changed_fair(struct rq *rq, struct 
 	 */
 	if (rq->curr == p) {
 		if (p->prio > oldprio)
-			resched_task(rq->curr);
+			resched_task_lazy(rq->curr);
 	} else
 		check_preempt_curr(rq, p, 0);
 }
Index: linux-stable/kernel/sched/sched.h
===================================================================
--- linux-stable.orig/kernel/sched/sched.h
+++ linux-stable/kernel/sched/sched.h
@@ -876,6 +876,15 @@ extern void init_sched_fair_class(void);
 extern void resched_task(struct task_struct *p);
 extern void resched_cpu(int cpu);
 
+#ifdef CONFIG_HAVE_PREEMPT_LAZY
+extern void resched_task_lazy(struct task_struct *tsk);
+#else
+static inline void resched_task_lazy(struct task_struct *tsk)
+{
+	resched_task(tsk);
+}
+#endif
+
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
