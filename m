Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1KBUci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:32:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33731 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab1KBUcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 25/28] rcu: Deconfuse dynticks entry-exit tracing
Date: Wed,  2 Nov 2011 13:30:46 -0700
Message-Id: <1320265849-5744-25-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-9360-0000-0000-00000045A621
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The trace_rcu_dyntick() trace event did not print both the old and
the new value of the nesting level, and furthermore printed only
the low-order 32 bits of it.  This could result in some confusion
when interpreting trace-event dumps, so this commit prints both
the old and the new value, prints the full 64 bits, and also selects
the process-entry/exit increment to print nicely in hexadecimal.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   15 +++++++++------
 kernel/rcu.h               |    7 +++++++
 kernel/rcutiny.c           |   28 +++++++++++++++++-----------
 kernel/rcutree.c           |   35 ++++++++++++++++++++---------------
 4 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 172620a..c29fb2f 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -246,21 +246,24 @@ TRACE_EVENT(rcu_fqs,
  */
 TRACE_EVENT(rcu_dyntick,
 
-	TP_PROTO(char *polarity, int nesting),
+	TP_PROTO(char *polarity, long long oldnesting, long long newnesting),
 
-	TP_ARGS(polarity, nesting),
+	TP_ARGS(polarity, oldnesting, newnesting),
 
 	TP_STRUCT__entry(
 		__field(char *, polarity)
-		__field(int, nesting)
+		__field(long long, oldnesting)
+		__field(long long, newnesting)
 	),
 
 	TP_fast_assign(
 		__entry->polarity = polarity;
-		__entry->nesting = nesting;
+		__entry->oldnesting = oldnesting;
+		__entry->newnesting = newnesting;
 	),
 
-	TP_printk("%s %d", __entry->polarity, __entry->nesting)
+	TP_printk("%s %llx %llx", __entry->polarity,
+		  __entry->oldnesting, __entry->newnesting)
 );
 
 /*
@@ -470,7 +473,7 @@ TRACE_EVENT(rcu_torture_read,
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
 #define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
-#define trace_rcu_dyntick(polarity, nesting) do { } while (0)
+#define trace_rcu_dyntick(polarity, oldnesting, newnesting) do { } while (0)
 #define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
 #define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
 #define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
diff --git a/kernel/rcu.h b/kernel/rcu.h
index f600868..aa88baa 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -30,6 +30,13 @@
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 /*
+ * Process-level increment to ->dynticks_nesting field.  This allows for
+ * architectures that use half-interrupts and half-exceptions from
+ * process context.
+ */
+#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
+
+/*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
  * by call_rcu() and rcu callback execution, and are therefore not part of the
  * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 089820d..e0df33f 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -54,20 +54,21 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-static long long rcu_dynticks_nesting = LLONG_MAX / 2;
+static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
-static void rcu_idle_enter_common(void)
+static void rcu_idle_enter_common(long long oldval)
 {
 	if (rcu_dynticks_nesting) {
-		RCU_TRACE(trace_rcu_dyntick("--=", rcu_dynticks_nesting));
+		RCU_TRACE(trace_rcu_dyntick("--=",
+					    oldval, rcu_dynticks_nesting));
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
 	if (!idle_cpu(smp_processor_id())) {
 		WARN_ON_ONCE(1);	/* must be idle task! */
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
-					    rcu_dynticks_nesting));
+					    oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
 	}
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
@@ -80,10 +81,12 @@ static void rcu_idle_enter_common(void)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
+	long long oldval;
 
 	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
 	rcu_dynticks_nesting = 0;
-	rcu_idle_enter_common();
+	rcu_idle_enter_common(oldval);
 	local_irq_restore(flags);
 }
 
@@ -93,11 +96,13 @@ void rcu_idle_enter(void)
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
+	long long oldval;
 
 	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
 	rcu_dynticks_nesting--;
 	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
-	rcu_idle_enter_common();
+	rcu_idle_enter_common(oldval);
 	local_irq_restore(flags);
 }
 
@@ -105,14 +110,15 @@ void rcu_irq_exit(void)
 static void rcu_idle_exit_common(long long oldval)
 {
 	if (oldval) {
-		RCU_TRACE(trace_rcu_dyntick("++=", rcu_dynticks_nesting));
+		RCU_TRACE(trace_rcu_dyntick("++=",
+					    oldval, rcu_dynticks_nesting));
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("End", oldval));
+	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
 	if (!idle_cpu(smp_processor_id())) {
 		WARN_ON_ONCE(1);	/* must be idle task! */
 		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
-			  oldval));
+			  oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
 	}
 }
@@ -128,7 +134,7 @@ void rcu_idle_exit(void)
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
 	WARN_ON_ONCE(oldval != 0);
-	rcu_dynticks_nesting = LLONG_MAX / 2;
+	rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 28f8f92..cc04876 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -196,7 +196,7 @@ void rcu_note_context_switch(int cpu)
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = LLONG_MAX / 2,
+	.dynticks_nesting = DYNTICK_TASK_NESTING,
 	.dynticks = ATOMIC_INIT(1),
 };
 
@@ -348,17 +348,17 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  * we really have entered idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
+static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 {
 	if (rdtp->dynticks_nesting) {
-		trace_rcu_dyntick("--=", rdtp->dynticks_nesting);
+		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
 		return;
 	}
-	trace_rcu_dyntick("Start", rdtp->dynticks_nesting);
+	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
 		WARN_ON_ONCE(1);	/* must be idle task! */
 		trace_rcu_dyntick("Error on entry: not idle task",
-				   rdtp->dynticks_nesting);
+				   oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ALL);
 	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
@@ -383,12 +383,14 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
+	long long oldval;
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting = 0;
-	rcu_idle_enter_common(rdtp);
+	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
@@ -411,13 +413,15 @@ void rcu_idle_enter(void)
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
+	long long oldval;
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
-	rcu_idle_enter_common(rdtp);
+	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
@@ -431,7 +435,7 @@ void rcu_irq_exit(void)
 static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 {
 	if (oldval) {
-		trace_rcu_dyntick("++=", rdtp->dynticks_nesting);
+		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
 		return;
 	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
@@ -439,10 +443,11 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
-	trace_rcu_dyntick("End", oldval);
+	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
 		WARN_ON_ONCE(1);	/* must be idle task! */
-		trace_rcu_dyntick("Error on exit: not idle task", oldval);
+		trace_rcu_dyntick("Error on exit: not idle task",
+				  oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ALL);
 	}
 }
@@ -453,8 +458,8 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
  * Exit idle mode, in other words, -enter- the mode in which RCU
  * read-side critical sections can occur.
  *
- * We crowbar the ->dynticks_nesting field to LLONG_MAX/2 to allow for
- * the possibility of usermode upcalls messing up our count
+ * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NESTING to
+ * allow for the possibility of usermode upcalls messing up our count
  * of interrupt nesting level during the busy period that is just
  * now starting.
  */
@@ -468,7 +473,7 @@ void rcu_idle_exit(void)
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval != 0);
-	rdtp->dynticks_nesting = LLONG_MAX / 2;
+	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
 	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
@@ -2012,7 +2017,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rdp->qlen = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != LLONG_MAX / 2);
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
@@ -2040,7 +2045,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != LLONG_MAX / 2);
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
 	WARN_ON_ONCE((atomic_read(&rdp->dynticks->dynticks) & 0x1) != 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
-- 
1.7.3.2

