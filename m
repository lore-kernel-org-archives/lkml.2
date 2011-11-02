Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1KBUh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:37:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32834 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab1KBUbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:14 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/28] rcu: Track idleness independent of idle tasks
Date: Wed,  2 Nov 2011 13:30:27 -0700
Message-Id: <1320265849-5744-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-7182-0000-0000-0000001E33A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Earlier versions of RCU used the scheduling-clock tick to detect idleness
by checking for the idle task, but handled idleness differently for
CONFIG_NO_HZ=y.  But there are now a number of uses of RCU read-side
critical sections in the idle task, for example, for tracing.  A more
fine-grained detection of idleness is therefore required.

This commit presses the old dyntick-idle code into full-time service,
so that rcu_idle_enter(), previously known as rcu_enter_nohz(), is
always invoked at the beginning of an idle loop iteration.  Similarly,
rcu_idle_exit(), previously known as rcu_exit_nohz(), is always invoked
at the end of an idle-loop iteration.  This allows the idle task to
use RCU everywhere except between consecutive rcu_idle_enter() and
rcu_idle_exit() calls, in turn allowing architecture maintainers to
specify exactly where in the idle loop that RCU may be used.

Because some of the userspace upcall uses can result in what looks
to RCU like half of an interrupt, it is not possible to expect that
the irq_enter() and irq_exit() hooks will give exact counts.  This
patch therefore expands the ->dynticks_nesting counter to 64 bits
and uses two separate bitfields to count process/idle transitions
and interrupt entry/exit transitions.  It is presumed that userspace
upcalls do not happen in the idle loop or from usermode execution
(though usermode might do a system call that results in an upcall).
The counter is hard-reset on each process/idle transition, which
avoids the interrupt entry/exit error from accumulating.  Overflow
is avoided by the 64-bitness of the ->dyntick_nesting counter.

This commit also adds warnings if a non-idle task asks RCU to enter
idle state (and these checks will need some adjustment before applying
Frederic's OS-jitter patches (http://lkml.org/lkml/2011/10/7/246).
In addition, validation of ->dynticks and ->dynticks_nesting is added.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |    4 -
 include/linux/hardirq.h     |   21 ----
 include/linux/rcupdate.h    |   21 +---
 include/linux/tick.h        |   11 ++-
 include/trace/events/rcu.h  |   10 +-
 kernel/rcutiny.c            |  124 ++++++++++++++++++++---
 kernel/rcutree.c            |  229 ++++++++++++++++++++++++++++++-------------
 kernel/rcutree.h            |   15 +--
 kernel/rcutree_trace.c      |   10 +--
 kernel/time/tick-sched.c    |    6 +-
 10 files changed, 297 insertions(+), 154 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index aaf65f6..49587ab 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -105,14 +105,10 @@ o	"dt" is the current value of the dyntick counter that is incremented
 	or one greater than the interrupt-nesting depth otherwise.
 	The number after the second "/" is the NMI nesting depth.
 
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
 o	"df" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being in
 	dynticks-idle state.
 
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
 	offline.  In a perfect world, this might never happen, but it
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index f743883..bb7f309 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -139,20 +139,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
-#if defined(CONFIG_NO_HZ)
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-static inline void rcu_irq_enter(void)
-{
-	rcu_exit_nohz();
-}
-
-static inline void rcu_irq_exit(void)
-{
-	rcu_enter_nohz();
-}
 
 static inline void rcu_nmi_enter(void)
 {
@@ -163,17 +150,9 @@ static inline void rcu_nmi_exit(void)
 }
 
 #else
-extern void rcu_irq_enter(void);
-extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
 extern void rcu_nmi_exit(void);
 #endif
-#else
-# define rcu_irq_enter() do { } while (0)
-# define rcu_irq_exit() do { } while (0)
-# define rcu_nmi_enter() do { } while (0)
-# define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2cf4226..cd1ad4b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -177,23 +177,10 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
-
-#ifdef CONFIG_NO_HZ
-
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-#else /* #ifdef CONFIG_NO_HZ */
-
-static inline void rcu_enter_nohz(void)
-{
-}
-
-static inline void rcu_exit_nohz(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
+extern void rcu_idle_enter(void);
+extern void rcu_idle_exit(void);
+extern void rcu_irq_enter(void);
+extern void rcu_irq_exit(void);
 
 /*
  * Infrastructure to implement the synchronize_() primitives in
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..ca40838 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -127,8 +127,15 @@ extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(int inidle) { }
-static inline void tick_nohz_restart_sched_tick(void) { }
+static inline void tick_nohz_stop_sched_tick(int inidle)
+{
+	if (inidle)
+		rcu_idle_enter();
+}
+static inline void tick_nohz_restart_sched_tick(void)
+{
+	rcu_idle_exit();
+}
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 669fbd6..e577180 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -246,19 +246,21 @@ TRACE_EVENT(rcu_fqs,
  */
 TRACE_EVENT(rcu_dyntick,
 
-	TP_PROTO(char *polarity),
+	TP_PROTO(char *polarity, int nesting),
 
-	TP_ARGS(polarity),
+	TP_ARGS(polarity, nesting),
 
 	TP_STRUCT__entry(
 		__field(char *, polarity)
+		__field(int, nesting)
 	),
 
 	TP_fast_assign(
 		__entry->polarity = polarity;
+		__entry->nesting = nesting;
 	),
 
-	TP_printk("%s", __entry->polarity)
+	TP_printk("%s %d", __entry->polarity, __entry->nesting)
 );
 
 /*
@@ -443,7 +445,7 @@ TRACE_EVENT(rcu_batch_end,
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
 #define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
-#define trace_rcu_dyntick(polarity) do { } while (0)
+#define trace_rcu_dyntick(polarity, nesting) do { } while (0)
 #define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
 #define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
 #define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index da775c8..6b0ace4 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -54,31 +54,122 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-#ifdef CONFIG_NO_HZ
+static long long rcu_dynticks_nesting = LLONG_MAX / 2;
 
-static long rcu_dynticks_nesting = 1;
+/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
+static void rcu_idle_enter_common(void)
+{
+	if (rcu_dynticks_nesting) {
+		RCU_TRACE(trace_rcu_dyntick("--=", rcu_dynticks_nesting));
+		return;
+	}
+	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting));
+	if (!idle_cpu(smp_processor_id())) {
+		WARN_ON_ONCE(1);	/* must be idle task! */
+		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
+					    rcu_dynticks_nesting));
+		ftrace_dump(DUMP_ALL);
+	}
+	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+}
 
 /*
- * Enter dynticks-idle mode, which is an extended quiescent state
- * if we have fully entered that mode (i.e., if the new value of
- * dynticks_nesting is zero).
+ * Enter idle, which is an extended quiescent state if we have fully
+ * entered that mode (i.e., if the new value of dynticks_nesting is zero).
  */
-void rcu_enter_nohz(void)
+void rcu_idle_enter(void)
 {
-	if (--rcu_dynticks_nesting == 0)
-		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+	unsigned long flags;
+
+	local_irq_save(flags);
+	rcu_dynticks_nesting = 0;
+	rcu_idle_enter_common();
+	local_irq_restore(flags);
 }
 
 /*
- * Exit dynticks-idle mode, so that we are no longer in an extended
- * quiescent state.
+ * Exit an interrupt handler towards idle.
+ */
+void rcu_irq_exit(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	rcu_dynticks_nesting--;
+	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
+	rcu_idle_enter_common();
+	local_irq_restore(flags);
+}
+
+/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
+static void rcu_idle_exit_common(long long oldval)
+{
+	if (oldval) {
+		RCU_TRACE(trace_rcu_dyntick("++=", rcu_dynticks_nesting));
+		return;
+	}
+	RCU_TRACE(trace_rcu_dyntick("End", oldval));
+	if (!idle_cpu(smp_processor_id())) {
+		WARN_ON_ONCE(1);	/* must be idle task! */
+		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
+			  oldval));
+		ftrace_dump(DUMP_ALL);
+	}
+}
+
+/*
+ * Exit idle, so that we are no longer in an extended quiescent state.
  */
-void rcu_exit_nohz(void)
+void rcu_idle_exit(void)
 {
+	unsigned long flags;
+	long long oldval;
+
+	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
+	WARN_ON_ONCE(oldval != 0);
+	rcu_dynticks_nesting = LLONG_MAX / 2;
+	rcu_idle_exit_common(oldval);
+	local_irq_restore(flags);
+}
+
+/*
+ * Enter an interrupt handler, moving away from idle.
+ */
+void rcu_irq_enter(void)
+{
+	unsigned long flags;
+	long long oldval;
+
+	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
 	rcu_dynticks_nesting++;
+	WARN_ON_ONCE(rcu_dynticks_nesting == 0);
+	rcu_idle_exit_common(oldval);
+	local_irq_restore(flags);
+}
+
+#ifdef CONFIG_PROVE_RCU
+
+/*
+ * Test whether RCU thinks that the current CPU is idle.
+ */
+int rcu_is_cpu_idle(void)
+{
+	return !rcu_dynticks_nesting;
 }
 
-#endif /* #ifdef CONFIG_NO_HZ */
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
+/*
+ * Test whether the current CPU was interrupted from idle.  Nested
+ * interrupts don't count, we must be running at the first interrupt
+ * level.
+ */
+int rcu_is_cpu_rrupt_from_idle(void)
+{
+	return rcu_dynticks_nesting <= 0;
+}
 
 /*
  * Helper function for rcu_sched_qs() and rcu_bh_qs().
@@ -127,14 +218,13 @@ void rcu_bh_qs(int cpu)
 
 /*
  * Check to see if the scheduling-clock interrupt came from an extended
- * quiescent state, and, if so, tell RCU about it.
+ * quiescent state, and, if so, tell RCU about it.  This function must
+ * be called from hardirq context.  It is normally called from the
+ * scheduling-clock interrupt.
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (user ||
-	    (idle_cpu(cpu) &&
-	     !in_softirq() &&
-	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
+	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cb7c46e..abb5167 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -195,12 +195,10 @@ void rcu_note_context_switch(int cpu)
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
-#ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = 1,
+	.dynticks_nesting = LLONG_MAX / 2,
 	.dynticks = ATOMIC_INIT(1),
 };
-#endif /* #ifdef CONFIG_NO_HZ */
 
 static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
@@ -328,11 +326,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* If preemptible RCU, no point in sending reschedule IPI. */
-	if (rdp->preemptible)
-		return 0;
-
-	/* The CPU is online, so send it a reschedule IPI. */
+	/*
+	 * The CPU is online, so send it a reschedule IPI.  This forces
+	 * it through the scheduler, and (inefficiently) also handles cases
+	 * where idle loops fail to inform RCU about the CPU being idle.
+	 */
 	if (rdp->cpu != smp_processor_id())
 		smp_send_reschedule(rdp->cpu);
 	else
@@ -343,51 +341,97 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-#ifdef CONFIG_NO_HZ
+/*
+ * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
+ *
+ * If the new value of the ->dynticks_nesting counter now is zero,
+ * we really have entered idle, and must do the appropriate accounting.
+ * The caller must have disabled interrupts.
+ */
+static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
+{
+	if (rdtp->dynticks_nesting) {
+		trace_rcu_dyntick("--=", rdtp->dynticks_nesting);
+		return;
+	}
+	trace_rcu_dyntick("Start", rdtp->dynticks_nesting);
+	if (!idle_cpu(smp_processor_id())) {
+		WARN_ON_ONCE(1);	/* must be idle task! */
+		trace_rcu_dyntick("Error on entry: not idle task",
+				   rdtp->dynticks_nesting);
+		ftrace_dump(DUMP_ALL);
+	}
+	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
+	smp_mb__before_atomic_inc();  /* See above. */
+	atomic_inc(&rdtp->dynticks);
+	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+}
 
 /**
- * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+ * rcu_idle_enter - inform RCU that current CPU is entering idle
  *
- * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * Enter idle mode, in other words, -leave- the mode in which RCU
  * read-side critical sections can occur.  (Though RCU read-side
- * critical sections can occur in irq handlers in nohz mode, a possibility
- * handled by rcu_irq_enter() and rcu_irq_exit()).
+ * critical sections can occur in irq handlers in idle, a possibility
+ * handled by irq_enter() and irq_exit().)
+ *
+ * We crowbar the ->dynticks_nesting field to zero to allow for
+ * the possibility of usermode upcalls having messed up our count
+ * of interrupt nesting level during the prior busy period.
  */
-void rcu_enter_nohz(void)
+void rcu_idle_enter(void)
 {
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (--rdtp->dynticks_nesting) {
-		local_irq_restore(flags);
-		return;
-	}
-	trace_rcu_dyntick("Start");
-	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
-	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	rdtp->dynticks_nesting = 0;
+	rcu_idle_enter_common(rdtp);
 	local_irq_restore(flags);
 }
 
-/*
- * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+/**
+ * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
+ *
+ * Exit from an interrupt handler, which might possibly result in entering
+ * idle mode, in other words, leaving the mode in which read-side critical
+ * sections can occur.
  *
- * Exit nohz mode, in other words, -enter- the mode in which RCU
- * read-side critical sections normally occur.
+ * This code assumes that the idle loop never does anything that might
+ * result in unbalanced calls to irq_enter() and irq_exit().  If your
+ * architecture violates this assumption, RCU will give you what you
+ * deserve, good and hard.  But very infrequently and irreproducibly.
+ *
+ * Use things like work queues to work around this limitation.
+ *
+ * You have been warned.
  */
-void rcu_exit_nohz(void)
+void rcu_irq_exit(void)
 {
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (rdtp->dynticks_nesting++) {
-		local_irq_restore(flags);
+	rdtp->dynticks_nesting--;
+	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
+	rcu_idle_enter_common(rdtp);
+	local_irq_restore(flags);
+}
+
+/*
+ * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
+ *
+ * If the new value of the ->dynticks_nesting counter was previously zero,
+ * we really have exited idle, and must do the appropriate accounting.
+ * The caller must have disabled interrupts.
+ */
+static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
+{
+	if (oldval) {
+		trace_rcu_dyntick("++=", rdtp->dynticks_nesting);
 		return;
 	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
@@ -395,7 +439,71 @@ void rcu_exit_nohz(void)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
-	trace_rcu_dyntick("End");
+	trace_rcu_dyntick("End", oldval);
+	if (!idle_cpu(smp_processor_id())) {
+		WARN_ON_ONCE(1);	/* must be idle task! */
+		trace_rcu_dyntick("Error on exit: not idle task", oldval);
+		ftrace_dump(DUMP_ALL);
+	}
+}
+
+/**
+ * rcu_idle_exit - inform RCU that current CPU is leaving idle
+ *
+ * Exit idle mode, in other words, -enter- the mode in which RCU
+ * read-side critical sections can occur.
+ *
+ * We crowbar the ->dynticks_nesting field to LLONG_MAX/2 to allow for
+ * the possibility of usermode upcalls messing up our count
+ * of interrupt nesting level during the busy period that is just
+ * now starting.
+ */
+void rcu_idle_exit(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+	long long oldval;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	WARN_ON_ONCE(oldval != 0);
+	rdtp->dynticks_nesting = LLONG_MAX / 2;
+	rcu_idle_exit_common(rdtp, oldval);
+	local_irq_restore(flags);
+}
+
+/**
+ * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
+ *
+ * Enter an interrupt handler, which might possibly result in exiting
+ * idle mode, in other words, entering the mode in which read-side critical
+ * sections can occur.
+ *
+ * Note that the Linux kernel is fully capable of entering an interrupt
+ * handler that it never exits, for example when doing upcalls to
+ * user mode!  This code assumes that the idle loop never does upcalls to
+ * user mode.  If your architecture does do upcalls from the idle loop (or
+ * does anything else that results in unbalanced calls to the irq_enter()
+ * and irq_exit() functions), RCU will give you what you deserve, good
+ * and hard.  But very infrequently and irreproducibly.
+ *
+ * Use things like work queues to work around this limitation.
+ *
+ * You have been warned.
+ */
+void rcu_irq_enter(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+	long long oldval;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	rdtp->dynticks_nesting++;
+	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
+	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
@@ -442,27 +550,32 @@ void rcu_nmi_exit(void)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
+#ifdef CONFIG_PROVE_RCU
+
 /**
- * rcu_irq_enter - inform RCU of entry to hard irq context
+ * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
  *
- * If the CPU was idle with dynamic ticks active, this updates the
- * rdtp->dynticks to let the RCU handling know that the CPU is active.
+ * If the current CPU is in its idle loop and is neither in an interrupt
+ * or NMI handler, return true.  The caller must have at least disabled
+ * preemption.
  */
-void rcu_irq_enter(void)
+int rcu_is_cpu_idle(void)
 {
-	rcu_exit_nohz();
+	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
 }
 
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
 /**
- * rcu_irq_exit - inform RCU of exit from hard irq context
+ * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
  *
- * If the CPU was idle with dynamic ticks active, update the rdp->dynticks
- * to put let the RCU handling be aware that the CPU is going back to idle
- * with no ticks.
+ * If the current CPU is idle or running at a first-level (not nested)
+ * interrupt from idle, return true.  The caller must have at least
+ * disabled preemption.
  */
-void rcu_irq_exit(void)
+int rcu_is_cpu_rrupt_from_idle(void)
 {
-	rcu_enter_nohz();
+	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
 
 #ifdef CONFIG_SMP
@@ -512,24 +625,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-#else /* #ifdef CONFIG_NO_HZ */
-
-#ifdef CONFIG_SMP
-
-static int dyntick_save_progress_counter(struct rcu_data *rdp)
-{
-	return 0;
-}
-
-static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
-{
-	return rcu_implicit_offline_qs(rdp);
-}
-
-#endif /* #ifdef CONFIG_SMP */
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
 int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -1334,16 +1429,14 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
  * Also schedule RCU core processing.
  *
- * This function must be called with hardirqs disabled.  It is normally
+ * This function must be called from hardirq context.  It is normally
  * invoked from the scheduling-clock interrupt.  If rcu_pending returns
  * false, there is no point in invoking rcu_check_callbacks().
  */
 void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization("Start scheduler-tick");
-	if (user ||
-	    (idle_cpu(cpu) && rcu_scheduler_active &&
-	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	if (user || rcu_is_cpu_rrupt_from_idle()) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
@@ -1913,9 +2006,9 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rdp->qlen = 0;
-#ifdef CONFIG_NO_HZ
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-#endif /* #ifdef CONFIG_NO_HZ */
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != LLONG_MAX / 2);
+	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1942,6 +2035,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != LLONG_MAX / 2);
+	WARN_ON_ONCE((atomic_read(&rdp->dynticks->dynticks) & 0x1) != 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 517f2f8..0963fa1 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,9 +84,10 @@
  * Dynticks per-CPU state.
  */
 struct rcu_dynticks {
-	int dynticks_nesting;	/* Track irq/process nesting level. */
-	int dynticks_nmi_nesting; /* Track NMI nesting level. */
-	atomic_t dynticks;	/* Even value for dynticks-idle, else odd. */
+	long long dynticks_nesting; /* Track irq/process nesting level. */
+				    /* Process level is worth LLONG_MAX/2. */
+	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
+	atomic_t dynticks;	    /* Even value for idle, else odd. */
 };
 
 /* RCU's kthread states for tracing. */
@@ -274,16 +275,12 @@ struct rcu_data {
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
 
-#ifdef CONFIG_NO_HZ
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-#endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
-#ifdef CONFIG_NO_HZ
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
-#endif /* #ifdef CONFIG_NO_HZ */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
@@ -307,11 +304,7 @@ struct rcu_data {
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
-#ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
-#else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
-#endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 59c7bee..654cfe6 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -67,13 +67,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
-#ifdef CONFIG_NO_HZ
-	seq_printf(m, " dt=%d/%d/%d df=%lu",
+	seq_printf(m, " dt=%d/%llx/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, " ql=%ld qs=%c%c%c%c",
 		   rdp->qlen,
@@ -141,13 +139,11 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
-#ifdef CONFIG_NO_HZ
-	seq_printf(m, ",%d,%d,%d,%lu",
+	seq_printf(m, ",%d,%llx,%d,%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
@@ -171,9 +167,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
-#ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index eb98e55..4692907 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -405,7 +405,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
 		}
 
 		ts->idle_sleeps++;
@@ -444,6 +443,8 @@ out:
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 end:
+	if (inidle)
+		rcu_idle_enter();
 	local_irq_restore(flags);
 }
 
@@ -500,6 +501,7 @@ void tick_nohz_restart_sched_tick(void)
 	ktime_t now;
 
 	local_irq_disable();
+	rcu_idle_exit();
 	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
 		now = ktime_get();
 
@@ -514,8 +516,6 @@ void tick_nohz_restart_sched_tick(void)
 
 	ts->inidle = 0;
 
-	rcu_exit_nohz();
-
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
-- 
1.7.3.2

