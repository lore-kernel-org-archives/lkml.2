Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1IGGYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:24:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48872 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab1IGGVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 22/55] rcu: Add grace-period, quiescent-state, and call_rcu trace events
Date: Tue,  6 Sep 2011 11:00:16 -0700
Message-Id: <1315332049-2604-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Add trace events to record grace-period start and end, quiescent states,
CPUs noticing grace-period start and end, grace-period initialization,
call_rcu() invocation, tasks blocking in RCU read-side critical sections,
tasks exiting those same critical sections, force_quiescent_state()
detection of dyntick-idle and offline CPUs, CPUs entering and leaving
dyntick-idle mode (except from NMIs), CPUs coming online and going
offline, and CPUs being kicked for staying in dyntick-idle mode for too
long (as in many weeks, even on 32-bit systems).

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

rcu: Add the rcu flavor to callback trace events

The earlier trace events for registering RCU callbacks and for invoking
them did not include the RCU flavor (rcu_bh, rcu_preempt, or rcu_sched).
This commit adds the RCU flavor to those trace events.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |  345 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/rcu.h               |    6 +-
 kernel/rcutiny.c           |    4 +-
 kernel/rcutree.c           |   45 ++++++-
 kernel/rcutree.h           |    1 +
 kernel/rcutree_plugin.h    |   22 +++-
 6 files changed, 399 insertions(+), 24 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index ac52aba..669fbd6 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -24,7 +24,7 @@ TRACE_EVENT(rcu_utilization,
 	TP_ARGS(s),
 
 	TP_STRUCT__entry(
-		__field(char *,	s)
+		__field(char *, s)
 	),
 
 	TP_fast_assign(
@@ -34,6 +34,297 @@ TRACE_EVENT(rcu_utilization,
 	TP_printk("%s", __entry->s)
 );
 
+#ifdef CONFIG_RCU_TRACE
+
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+
+/*
+ * Tracepoint for grace-period events: starting and ending a grace
+ * period ("start" and "end", respectively), a CPU noting the start
+ * of a new grace period or the end of an old grace period ("cpustart"
+ * and "cpuend", respectively), a CPU passing through a quiescent
+ * state ("cpuqs"), a CPU coming online or going offline ("cpuonl"
+ * and "cpuofl", respectively), and a CPU being kicked for being too
+ * long in dyntick-idle mode ("kick").
+ */
+TRACE_EVENT(rcu_grace_period,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, char *gpevent),
+
+	TP_ARGS(rcuname, gpnum, gpevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(char *, gpevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->gpevent = gpevent;
+	),
+
+	TP_printk("%s %lu %s",
+		  __entry->rcuname, __entry->gpnum, __entry->gpevent)
+);
+
+/*
+ * Tracepoint for grace-period-initialization events.  These are
+ * distinguished by the type of RCU, the new grace-period number, the
+ * rcu_node structure level, the starting and ending CPU covered by the
+ * rcu_node structure, and the mask of CPUs that will be waited for.
+ * All but the type of RCU are extracted from the rcu_node structure.
+ */
+TRACE_EVENT(rcu_grace_period_init,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, u8 level,
+		 int grplo, int grphi, unsigned long qsmask),
+
+	TP_ARGS(rcuname, gpnum, level, grplo, grphi, qsmask),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(unsigned long, qsmask)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->qsmask = qsmask;
+	),
+
+	TP_printk("%s %lu %u %d %d %lx",
+		  __entry->rcuname, __entry->gpnum, __entry->level,
+		  __entry->grplo, __entry->grphi, __entry->qsmask)
+);
+
+/*
+ * Tracepoint for tasks blocking within preemptible-RCU read-side
+ * critical sections.  Track the type of RCU (which one day might
+ * include SRCU), the grace-period number that the task is blocking
+ * (the current or the next), and the task's PID.
+ */
+TRACE_EVENT(rcu_preempt_task,
+
+	TP_PROTO(char *rcuname, int pid, unsigned long gpnum),
+
+	TP_ARGS(rcuname, pid, gpnum),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->pid = pid;
+	),
+
+	TP_printk("%s %lu %d",
+		  __entry->rcuname, __entry->gpnum, __entry->pid)
+);
+
+/*
+ * Tracepoint for tasks that blocked within a given preemptible-RCU
+ * read-side critical section exiting that critical section.  Track the
+ * type of RCU (which one day might include SRCU) and the task's PID.
+ */
+TRACE_EVENT(rcu_unlock_preempted_task,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, int pid),
+
+	TP_ARGS(rcuname, gpnum, pid),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->pid = pid;
+	),
+
+	TP_printk("%s %lu %d", __entry->rcuname, __entry->gpnum, __entry->pid)
+);
+
+/*
+ * Tracepoint for quiescent-state-reporting events.  These are
+ * distinguished by the type of RCU, the grace-period number, the
+ * mask of quiescent lower-level entities, the rcu_node structure level,
+ * the starting and ending CPU covered by the rcu_node structure, and
+ * whether there are any blocked tasks blocking the current grace period.
+ * All but the type of RCU are extracted from the rcu_node structure.
+ */
+TRACE_EVENT(rcu_quiescent_state_report,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum,
+		 unsigned long mask, unsigned long qsmask,
+		 u8 level, int grplo, int grphi, int gp_tasks),
+
+	TP_ARGS(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(unsigned long, mask)
+		__field(unsigned long, qsmask)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(u8, gp_tasks)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->mask = mask;
+		__entry->qsmask = qsmask;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->gp_tasks = gp_tasks;
+	),
+
+	TP_printk("%s %lu %lx>%lx %u %d %d %u",
+		  __entry->rcuname, __entry->gpnum,
+		  __entry->mask, __entry->qsmask, __entry->level,
+		  __entry->grplo, __entry->grphi, __entry->gp_tasks)
+);
+
+/*
+ * Tracepoint for quiescent states detected by force_quiescent_state().
+ * These trace events include the type of RCU, the grace-period number
+ * that was blocked by the CPU, the CPU itself, and the type of quiescent
+ * state, which can be "dti" for dyntick-idle mode, "ofl" for CPU offline,
+ * or "kick" when kicking a CPU that has been in dyntick-idle mode for
+ * too long.
+ */
+TRACE_EVENT(rcu_fqs,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, int cpu, char *qsevent),
+
+	TP_ARGS(rcuname, gpnum, cpu, qsevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(int, cpu)
+		__field(char *, qsevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->cpu = cpu;
+		__entry->qsevent = qsevent;
+	),
+
+	TP_printk("%s %lu %d %s",
+		  __entry->rcuname, __entry->gpnum,
+		  __entry->cpu, __entry->qsevent)
+);
+
+#endif /* #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) */
+
+/*
+ * Tracepoint for dyntick-idle entry/exit events.  These take a string
+ * as argument: "Start" for entering dyntick-idle mode and "End" for
+ * leaving it.
+ */
+TRACE_EVENT(rcu_dyntick,
+
+	TP_PROTO(char *polarity),
+
+	TP_ARGS(polarity),
+
+	TP_STRUCT__entry(
+		__field(char *, polarity)
+	),
+
+	TP_fast_assign(
+		__entry->polarity = polarity;
+	),
+
+	TP_printk("%s", __entry->polarity)
+);
+
+/*
+ * Tracepoint for the registration of a single RCU callback function.
+ * The first argument is the type of RCU, the second argument is
+ * a pointer to the RCU callback itself, and the third element is the
+ * new RCU callback queue length for the current CPU.
+ */
+TRACE_EVENT(rcu_callback,
+
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen),
+
+	TP_ARGS(rcuname, rhp, qlen),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(void *, func)
+		__field(long, qlen)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->rhp = rhp;
+		__entry->func = rhp->func;
+		__entry->qlen = qlen;
+	),
+
+	TP_printk("%s rhp=%p func=%pf %ld",
+		  __entry->rcuname, __entry->rhp, __entry->func, __entry->qlen)
+);
+
+/*
+ * Tracepoint for the registration of a single RCU callback of the special
+ * kfree() form.  The first argument is the RCU type, the second argument
+ * is a pointer to the RCU callback, the third argument is the offset
+ * of the callback within the enclosing RCU-protected data structure,
+ * and the fourth argument is the new RCU callback queue length for the
+ * current CPU.
+ */
+TRACE_EVENT(rcu_kfree_callback,
+
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset,
+		 long qlen),
+
+	TP_ARGS(rcuname, rhp, offset, qlen),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(unsigned long, offset)
+		__field(long, qlen)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->rhp = rhp;
+		__entry->offset = offset;
+		__entry->qlen = qlen;
+	),
+
+	TP_printk("%s rhp=%p func=%ld %ld",
+		  __entry->rcuname, __entry->rhp, __entry->offset,
+		  __entry->qlen)
+);
+
 /*
  * Tracepoint for marking the beginning rcu_do_batch, performed to start
  * RCU callback invocation.  The first argument is the RCU flavor,
@@ -65,50 +356,58 @@ TRACE_EVENT(rcu_batch_start,
 
 /*
  * Tracepoint for the invocation of a single RCU callback function.
- * The argument is a pointer to the RCU callback itself.
+ * The first argument is the type of RCU, and the second argument is
+ * a pointer to the RCU callback itself.
  */
 TRACE_EVENT(rcu_invoke_callback,
 
-	TP_PROTO(struct rcu_head *rhp),
+	TP_PROTO(char *rcuname, struct rcu_head *rhp),
 
-	TP_ARGS(rhp),
+	TP_ARGS(rcuname, rhp),
 
 	TP_STRUCT__entry(
-		__field(void *,	rhp)
-		__field(void *,	func)
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(void *, func)
 	),
 
 	TP_fast_assign(
+		__entry->rcuname = rcuname;
 		__entry->rhp = rhp;
 		__entry->func = rhp->func;
 	),
 
-	TP_printk("rhp=%p func=%pf", __entry->rhp, __entry->func)
+	TP_printk("%s rhp=%p func=%pf",
+		  __entry->rcuname, __entry->rhp, __entry->func)
 );
 
 /*
  * Tracepoint for the invocation of a single RCU callback of the special
- * kfree() form.  The first argument is a pointer to the RCU callback
- * and the second argument is the offset of the callback within the
- * enclosing RCU-protected data structure.
+ * kfree() form.  The first argument is the RCU flavor, the second
+ * argument is a pointer to the RCU callback, and the third argument
+ * is the offset of the callback within the enclosing RCU-protected
+ * data structure.
  */
 TRACE_EVENT(rcu_invoke_kfree_callback,
 
-	TP_PROTO(struct rcu_head *rhp, unsigned long offset),
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset),
 
-	TP_ARGS(rhp, offset),
+	TP_ARGS(rcuname, rhp, offset),
 
 	TP_STRUCT__entry(
-		__field(void *,	rhp)
+		__field(char *, rcuname)
+		__field(void *, rhp)
 		__field(unsigned long, offset)
 	),
 
 	TP_fast_assign(
+		__entry->rcuname = rcuname;
 		__entry->rhp = rhp;
 		__entry->offset	= offset;
 	),
 
-	TP_printk("rhp=%p func=%ld", __entry->rhp, __entry->offset)
+	TP_printk("%s rhp=%p func=%ld",
+		  __entry->rcuname, __entry->rhp, __entry->offset)
 );
 
 /*
@@ -136,6 +435,24 @@ TRACE_EVENT(rcu_batch_end,
 		  __entry->rcuname, __entry->callbacks_invoked)
 );
 
+#else /* #ifdef CONFIG_RCU_TRACE */
+
+#define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
+#define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, qsmask) do { } while (0)
+#define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
+#define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
+#define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
+#define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
+#define trace_rcu_dyntick(polarity) do { } while (0)
+#define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
+#define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
+#define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
+#define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
+#define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
+#define trace_rcu_batch_end(rcuname, callbacks_invoked) do { } while (0)
+
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
 #endif /* _TRACE_RCU_H */
 
 /* This part must be outside protection */
diff --git a/kernel/rcu.h b/kernel/rcu.h
index d7f00ec..f600868 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -69,15 +69,15 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 
 extern void kfree(const void *);
 
-static inline void __rcu_reclaim(struct rcu_head *head)
+static inline void __rcu_reclaim(char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
 	if (__is_kfree_rcu_offset(offset)) {
-		RCU_TRACE(trace_rcu_invoke_kfree_callback(head, offset));
+		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
 	} else {
-		RCU_TRACE(trace_rcu_invoke_callback(head));
+		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
 	}
 }
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index c9321d8..da775c8 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -147,6 +147,7 @@ void rcu_check_callbacks(int cpu, int user)
  */
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
+	char *rn = NULL;
 	struct rcu_head *next, *list;
 	unsigned long flags;
 	RCU_TRACE(int cb_count = 0);
@@ -171,12 +172,13 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	local_irq_restore(flags);
 
 	/* Invoke the callbacks on the local list. */
+	RCU_TRACE(rn = rcp->name);
 	while (list) {
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
 		local_bh_disable();
-		__rcu_reclaim(list);
+		__rcu_reclaim(rn, list);
 		local_bh_enable();
 		list = next;
 		RCU_TRACE(cb_count++);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4e24399..7e02829 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -166,6 +166,8 @@ void rcu_sched_qs(int cpu)
 
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
+	if (rdp->passed_quiesc == 0)
+		trace_rcu_grace_period("rcu_sched", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesc = 1;
 }
 
@@ -175,6 +177,8 @@ void rcu_bh_qs(int cpu)
 
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
+	if (rdp->passed_quiesc == 0)
+		trace_rcu_grace_period("rcu_bh", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesc = 1;
 }
 
@@ -319,6 +323,7 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 	 * trust its state not to change because interrupts are disabled.
 	 */
 	if (cpu_is_offline(rdp->cpu)) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
 		rdp->offline_fqs++;
 		return 1;
 	}
@@ -359,6 +364,7 @@ void rcu_enter_nohz(void)
 		local_irq_restore(flags);
 		return;
 	}
+	trace_rcu_dyntick("Start");
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
@@ -396,6 +402,7 @@ void rcu_exit_nohz(void)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	trace_rcu_dyntick("End");
 	local_irq_restore(flags);
 }
 
@@ -501,6 +508,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * of the current RCU grace period.
 	 */
 	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "dti");
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -683,6 +691,7 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 		 * go looking for one.
 		 */
 		rdp->gpnum = rnp->gpnum;
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
 		if (rnp->qsmask & rdp->grpmask) {
 			rdp->qs_pending = 1;
 			rdp->passed_quiesc = 0;
@@ -746,6 +755,7 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuend");
 
 		/*
 		 * If we were in an extended quiescent state, we may have
@@ -856,6 +866,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
+	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
 	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
@@ -870,6 +881,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
+		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
+					    rnp->level, rnp->grplo,
+					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -906,6 +920,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
+		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
+					    rnp->level, rnp->grplo,
+					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -939,6 +956,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
+	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
@@ -967,6 +985,10 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
+		trace_rcu_quiescent_state_report(rsp->name, rnp->gpnum,
+						 mask, rnp->qsmask, rnp->level,
+						 rnp->grplo, rnp->grphi,
+						 !!rnp->gp_tasks);
 		if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 
 			/* Other bits still set at this level, so done. */
@@ -1135,11 +1157,20 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
 				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			else
+				trace_rcu_grace_period(rsp->name,
+						       rnp->gpnum + 1 -
+						       !!(rnp->qsmask & mask),
+						       "cpuofl");
 			break;
 		}
-		if (rnp == rdp->mynode)
+		if (rnp == rdp->mynode) {
+			trace_rcu_grace_period(rsp->name,
+					       rnp->gpnum + 1 -
+					       !!(rnp->qsmask & mask),
+					       "cpuofl");
 			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
-		else
+		} else
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
 		rnp = rnp->parent;
@@ -1226,7 +1257,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		__rcu_reclaim(list);
+		__rcu_reclaim(rsp->name, list);
 		list = next;
 		if (++count >= bl)
 			break;
@@ -1552,6 +1583,12 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 	rdp->qlen++;
 
+	if (__is_kfree_rcu_offset((unsigned long)func))
+		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
+					 rdp->qlen);
+	else
+		trace_rcu_callback(rsp->name, head, rdp->qlen);
+
 	/* If interrupts were disabled, don't dive into RCU core. */
 	if (irqs_disabled_flags(flags)) {
 		local_irq_restore(flags);
@@ -1850,6 +1887,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 #endif /* #ifdef CONFIG_NO_HZ */
 	rdp->cpu = cpu;
+	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
@@ -1898,6 +1936,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 			rdp->gpnum = rnp->completed; /* if GP in progress... */
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesc_completed = rnp->completed - 1;
+			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
 		}
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index eee6c94..d11a006 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -299,6 +299,7 @@ struct rcu_data {
 	unsigned long n_rp_need_nothing;
 
 	int cpu;
+	struct rcu_state *rsp;
 };
 
 /* Values for signaled field in struct rcu_state. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 94d9ca1..bdb2e82 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -124,6 +124,8 @@ static void rcu_preempt_qs(int cpu)
 
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
+	if (rdp->passed_quiesc == 0)
+		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesc = 1;
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
@@ -190,6 +192,11 @@ static void rcu_preempt_note_context_switch(int cpu)
 			if (rnp->qsmask & rdp->grpmask)
 				rnp->gp_tasks = &t->rcu_node_entry;
 		}
+		trace_rcu_preempt_task(rdp->rsp->name,
+				       t->pid,
+				       (rnp->qsmask & rdp->grpmask)
+				       ? rnp->gpnum
+				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else if (t->rcu_read_lock_nesting < 0 &&
 		   t->rcu_read_unlock_special) {
@@ -344,6 +351,8 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		trace_rcu_unlock_preempted_task("rcu_preempt",
+						rnp->gpnum, t->pid);
 		if (&t->rcu_node_entry == rnp->gp_tasks)
 			rnp->gp_tasks = np;
 		if (&t->rcu_node_entry == rnp->exp_tasks)
@@ -364,10 +373,17 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		 * we aren't waiting on any CPUs, report the quiescent state.
 		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
 		 */
-		if (empty)
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		else
+		if (!empty && !rcu_preempt_blocked_readers_cgp(rnp)) {
+			trace_rcu_quiescent_state_report("preempt_rcu",
+							 rnp->gpnum,
+							 0, rnp->qsmask,
+							 rnp->level,
+							 rnp->grplo,
+							 rnp->grphi,
+							 !!rnp->gp_tasks);
 			rcu_report_unblock_qs_rnp(rnp, flags);
+		} else
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-- 
1.7.3.2

