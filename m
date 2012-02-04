Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2BDBsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:48:03 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54877 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2BDBr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:47:59 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 39/47] rcu: Rework detection of use of RCU by offline CPUs
Date: Fri,  3 Feb 2012 17:45:14 -0800
Message-Id: <1328319922-30828-39-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-9360-0000-0000-000003198D55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Because newly offlined CPUs continue executing after completing the
CPU_DYING notifiers, they legitimately enter the scheduler and use
RCU while appearing to be offline.  This calls for a more sophisticated
approach as follows:

1.	RCU marks the CPU online during the CPU_UP_PREPARE phase.

2.	RCU marks the CPU offline during the CPU_DEAD phase.

3.	Diagnostics regarding use of read-side RCU by offline CPUs use
	RCU's accounting rather than the cpu_online_map.  (Note that
	__call_rcu() still uses cpu_online_map to detect illegal
	invocations within CPU_DYING notifiers.)

4.	Offline CPUs are prevented from hanging the system by
	force_quiescent_state(), which pays attention to cpu_online_map.
	Some additional work (in a later commit) will be needed to
	guarantee that force_quiescent_state() waits a full jiffy before
	assuming that a CPU is offline, for example, when called from
	idle entry.  (This commit also makes the one-jiffy wait
	explicit, since the old-style implicit wait can now be defeated
	by RCU_FAST_NO_HZ and by rcutorture.)

This approach avoids the false positives encountered when attempting to
use more exact classification of CPU online/offline state.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   36 ++++++--------
 kernel/rcutree.c            |  113 +++++++++++++++++++++++++-----------------
 kernel/rcutree.h            |    1 -
 kernel/rcutree_plugin.h     |    2 +-
 kernel/rcutree_trace.c      |    6 +-
 5 files changed, 87 insertions(+), 71 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 49587ab..f6f15ce 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -33,23 +33,23 @@ rcu/rcuboost:
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
+  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
+  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -119,10 +119,6 @@ o	"of" is the number of times that some other CPU has forced a
 	CPU is offline when it is really alive and kicking) is a fatal
 	error, so it makes sense to err conservatively.
 
-o	"ri" is the number of times that RCU has seen fit to send a
-	reschedule IPI to this CPU in order to get it to report a
-	quiescent state.
-
 o	"ql" is the number of RCU callbacks currently residing on
 	this CPU.  This is the total number of callbacks, regardless
 	of what state they are in (new, waiting for grace period to
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 05470d4..708469a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -320,25 +320,18 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 {
 	/*
-	 * If the CPU is offline, it is in a quiescent state.  We can
-	 * trust its state not to change because interrupts are disabled.
+	 * If the CPU is offline for more than a jiffy, it is in a quiescent
+	 * state.  We can trust its state not to change because interrupts
+	 * are disabled.  The reason for the jiffy's worth of slack is to
+	 * handle CPUs initializing on the way up and finding their way
+	 * to the idle loop on the way down.
 	 */
-	if (cpu_is_offline(rdp->cpu)) {
+	if (cpu_is_offline(rdp->cpu) &&
+	    ULONG_CMP_LT(rdp->rsp->gp_start + 2, jiffies)) {
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
 		rdp->offline_fqs++;
 		return 1;
 	}
-
-	/*
-	 * The CPU is online, so send it a reschedule IPI.  This forces
-	 * it through the scheduler, and (inefficiently) also handles cases
-	 * where idle loops fail to inform RCU about the CPU being idle.
-	 */
-	if (rdp->cpu != smp_processor_id())
-		smp_send_reschedule(rdp->cpu);
-	else
-		set_need_resched();
-	rdp->resched_ipi++;
 	return 0;
 }
 
@@ -601,19 +594,33 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  * this task being preempted, its old CPU being taken offline, resuming
  * on some other CPU, then determining that its old CPU is now offline.
  * It is OK to use RCU on an offline processor during initial boot, hence
- * the check for rcu_scheduler_fully_active.
+ * the check for rcu_scheduler_fully_active.  Note also that it is OK
+ * for a CPU coming online to use RCU for one jiffy prior to marking itself
+ * online in the cpu_online_mask.  Similarly, it is OK for a CPU going
+ * offline to continue to use RCU for one jiffy after marking itself
+ * offline in the cpu_online_mask.  This leniency is necessary given the
+ * non-atomic nature of the online and offline processing, for example,
+ * the fact that a CPU enters the scheduler after completing the CPU_DYING
+ * notifiers.
+ *
+ * This is also why RCU internally marks CPUs online during the
+ * CPU_UP_PREPARE phase and offline during the CPU_DEAD phase.
  *
  * Disable checking if in an NMI handler because we cannot safely report
  * errors from NMI handlers anyway.
  */
 bool rcu_lockdep_current_cpu_online(void)
 {
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
 	bool ret;
 
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	ret = cpu_online(smp_processor_id()) ||
+	rdp = &__get_cpu_var(rcu_sched_data);
+	rnp = rdp->mynode;
+	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
 	preempt_enable();
 	return ret;
@@ -1308,14 +1315,12 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
-	unsigned long flags;
 	int i;
 	unsigned long mask;
-	int need_report;
 	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
-	struct rcu_node *rnp = rdp->mynode; /* For dying CPU. */
+	RCU_TRACE(struct rcu_node *rnp = rdp->mynode); /* For dying CPU. */
 
 	/* First, adjust the counts. */
 	if (rdp->nxtlist != NULL) {
@@ -1381,32 +1386,6 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 			       "cpuofl");
 	rcu_report_qs_rdp(smp_processor_id(), rsp, rdp, rsp->gpnum);
 	/* Note that rcu_report_qs_rdp() might call trace_rcu_grace_period(). */
-
-	/*
-	 * Remove the dying CPU from the bitmasks in the rcu_node
-	 * hierarchy.  Because we are in stop_machine() context, we
-	 * automatically exclude ->onofflock critical sections.
-	 */
-	do {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rnp->qsmaskinit &= ~mask;
-		if (rnp->qsmaskinit != 0) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			break;
-		}
-		if (rnp == rdp->mynode) {
-			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
-			if (need_report & RCU_OFL_TASKS_NORM_GP)
-				rcu_report_unblock_qs_rnp(rnp, flags);
-			else
-				raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			if (need_report & RCU_OFL_TASKS_EXP_GP)
-				rcu_report_exp_rnp(rsp, rnp, true);
-		} else
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		mask = rnp->grpmask;
-		rnp = rnp->parent;
-	} while (rnp != NULL);
 }
 
 /*
@@ -1417,11 +1396,53 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
  */
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
+	unsigned long flags;
+	unsigned long mask;
+	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
-	struct rcu_node *rnp = rdp->mynode;
+	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rnp. */
 
+	/* Adjust any no-longer-needed kthreads. */
 	rcu_stop_cpu_kthread(cpu);
 	rcu_node_kthread_setaffinity(rnp, -1);
+
+	/* Remove the dying CPU from the bitmasks in the rcu_node hierarchy. */
+
+	/* Exclude any attempts to start a new grace period. */
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
+	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	do {
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+		rnp->qsmaskinit &= ~mask;
+		if (rnp->qsmaskinit != 0) {
+			if (rnp != rdp->mynode)
+				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			break;
+		}
+		if (rnp == rdp->mynode)
+			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+		else
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		mask = rnp->grpmask;
+		rnp = rnp->parent;
+	} while (rnp != NULL);
+
+	/*
+	 * We still hold the leaf rcu_node structure lock here, and
+	 * irqs are still disabled.  The reason for this subterfuge is
+	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
+	 * held leads to deadlock.
+	 */
+	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	rnp = rdp->mynode;
+	if (need_report & RCU_OFL_TASKS_NORM_GP)
+		rcu_report_unblock_qs_rnp(rnp, flags);
+	else
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (need_report & RCU_OFL_TASKS_EXP_GP)
+		rcu_report_exp_rnp(rsp, rnp, true);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e2ac8ee..cdd1be0 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -289,7 +289,6 @@ struct rcu_data {
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
-	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5a1c0fb..2daa7b9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -610,7 +610,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * absolutely necessary, but this is a good performance/complexity
 	 * tradeoff.
 	 */
-	if (rcu_preempt_blocked_readers_cgp(rnp))
+	if (rcu_preempt_blocked_readers_cgp(rnp) && rnp->qsmask == 0)
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index db0987c..ed459ed 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -72,7 +72,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
+	seq_printf(m, " of=%lu", rdp->offline_fqs);
 	seq_printf(m, " ql=%ld/%ld qs=%c%c%c%c",
 		   rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
@@ -144,7 +144,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
+	seq_printf(m, ",%lu", rdp->offline_fqs);
 	seq_printf(m, ",%ld,%ld,\"%c%c%c%c\"", rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -168,7 +168,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-	seq_puts(m, "\"of\",\"ri\",\"qll\",\"ql\",\"qs\"");
+	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
 #endif /* #ifdef CONFIG_RCU_BOOST */
-- 
1.7.8

