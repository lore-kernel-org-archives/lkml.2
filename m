Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1IGGWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:22:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38331 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1IGGVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 23/55] rcu: Simplify quiescent-state accounting
Date: Tue,  6 Sep 2011 11:00:17 -0700
Message-Id: <1315332049-2604-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

There is often a delay between the time that a CPU passes through a
quiescent state and the time that this quiescent state is reported to the
RCU core.  It is quite possible that the grace period ended before the
quiescent state could be reported, for example, some other CPU might have
deduced that this CPU passed through dyntick-idle mode.  It is critically
important that quiescent state be counted only against the grace period
that was in effect at the time that the quiescent state was detected.

Previously, this was handled by recording the number of the last grace
period to complete when passing through a quiescent state.  The RCU
core then checks this number against the current value, and rejects
the quiescent state if there is a mismatch.  However, one additional
possibility must be accounted for, namely that the quiescent state was
recorded after the prior grace period completed but before the current
grace period started.  In this case, the RCU core must reject the
quiescent state, but the recorded number will match.  This is handled
when the CPU becomes aware of a new grace period -- at that point,
it invalidates any prior quiescent state.

This works, but is a bit indirect.  The new approach records the current
grace period, and the RCU core checks to see (1) that this is still the
current grace period and (2) that this grace period has not yet ended.
This approach simplifies reasoning about correctness, and this commit
changes over to this new approach.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   34 ++++++++++++++++----------------
 kernel/rcutree.c            |   44 +++++++++++++++++++++---------------------
 kernel/rcutree.h            |    6 ++--
 kernel/rcutree_plugin.h     |    6 ++--
 kernel/rcutree_trace.c      |    8 +++---
 5 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index a67af0a..aaf65f6 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -33,23 +33,23 @@ rcu/rcuboost:
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pqc=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pqc=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
+  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pqc=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
+  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -84,7 +84,7 @@ o	"pq" indicates that this CPU has passed through a quiescent state
 	CPU has not yet reported that fact, (2) some other CPU has not
 	yet reported for this grace period, or (3) both.
 
-o	"pqc" indicates which grace period the last-observed quiescent
+o	"pgp" indicates which grace period the last-observed quiescent
 	state for this CPU corresponds to.  This is important for handling
 	the race between CPU 0 reporting an extended dynticks-idle
 	quiescent state for CPU 1 and CPU 1 suddenly waking up and
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7e02829..7e2f297 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -159,32 +159,34 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  * Note a quiescent state.  Because we do not need to know
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period, this just sets a flag.
+ * The caller must have disabled preemption.
  */
 void rcu_sched_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 
-	rdp->passed_quiesc_completed = rdp->gpnum - 1;
+	rdp->passed_quiesce_gpnum = rdp->gpnum;
 	barrier();
-	if (rdp->passed_quiesc == 0)
+	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_sched", rdp->gpnum, "cpuqs");
-	rdp->passed_quiesc = 1;
+	rdp->passed_quiesce = 1;
 }
 
 void rcu_bh_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 
-	rdp->passed_quiesc_completed = rdp->gpnum - 1;
+	rdp->passed_quiesce_gpnum = rdp->gpnum;
 	barrier();
-	if (rdp->passed_quiesc == 0)
+	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_bh", rdp->gpnum, "cpuqs");
-	rdp->passed_quiesc = 1;
+	rdp->passed_quiesce = 1;
 }
 
 /*
  * Note a context switch.  This is a quiescent state for RCU-sched,
  * and requires special handling for preemptible RCU.
+ * The caller must have disabled preemption.
  */
 void rcu_note_context_switch(int cpu)
 {
@@ -694,7 +696,7 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
 		if (rnp->qsmask & rdp->grpmask) {
 			rdp->qs_pending = 1;
-			rdp->passed_quiesc = 0;
+			rdp->passed_quiesce = 0;
 		} else
 			rdp->qs_pending = 0;
 	}
@@ -1027,7 +1029,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
  * based on quiescent states detected in an earlier grace period!
  */
 static void
-rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
+rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastgp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -1035,17 +1037,15 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
 
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	if (lastcomp != rnp->completed) {
+	if (lastgp != rnp->gpnum || rnp->completed == rnp->gpnum) {
 
 		/*
-		 * Someone beat us to it for this grace period, so leave.
-		 * The race with GP start is resolved by the fact that we
-		 * hold the leaf rcu_node lock, so that the per-CPU bits
-		 * cannot yet be initialized -- so we would simply find our
-		 * CPU's bit already cleared in rcu_report_qs_rnp() if this
-		 * race occurred.
+		 * The grace period in which this quiescent state was
+		 * recorded has ended, so don't report it upwards.
+		 * We will instead need a new quiescent state that lies
+		 * within the current grace period.
 		 */
-		rdp->passed_quiesc = 0;	/* try again later! */
+		rdp->passed_quiesce = 0;	/* need qs for new gp. */
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -1089,14 +1089,14 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * Was there a quiescent state since the beginning of the grace
 	 * period? If no, then exit and wait for the next call.
 	 */
-	if (!rdp->passed_quiesc)
+	if (!rdp->passed_quiesce)
 		return;
 
 	/*
 	 * Tell RCU we are done (but rcu_report_qs_rdp() will be the
 	 * judge of that).
 	 */
-	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
+	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesce_gpnum);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1712,7 +1712,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending && !rdp->passed_quiesc) {
+	if (rdp->qs_pending && !rdp->passed_quiesce) {
 
 		/*
 		 * If force_quiescent_state() coming soon and this CPU
@@ -1724,7 +1724,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
 				 jiffies))
 			set_need_resched();
-	} else if (rdp->qs_pending && rdp->passed_quiesc) {
+	} else if (rdp->qs_pending && rdp->passed_quiesce) {
 		rdp->n_rp_report_qs++;
 		return 1;
 	}
@@ -1907,7 +1907,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
+	rdp->passed_quiesce = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptible = preemptible;
@@ -1935,7 +1935,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 		if (rnp == rdp->mynode) {
 			rdp->gpnum = rnp->completed; /* if GP in progress... */
 			rdp->completed = rnp->completed;
-			rdp->passed_quiesc_completed = rnp->completed - 1;
+			rdp->passed_quiesce_gpnum = rnp->gpnum - 1;
 			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
 		}
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d11a006..51638b6 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -230,9 +230,9 @@ struct rcu_data {
 					/*  in order to detect GP end. */
 	unsigned long	gpnum;		/* Highest gp number that this CPU */
 					/*  is aware of having started. */
-	unsigned long	passed_quiesc_completed;
-					/* Value of completed at time of qs. */
-	bool		passed_quiesc;	/* User-mode/idle loop etc. */
+	unsigned long	passed_quiesce_gpnum;
+					/* gpnum at time of quiescent state. */
+	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
 	bool		preemptible;	/* Preemptible RCU? */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index bdb2e82..4bac5a2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -122,11 +122,11 @@ static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
 
-	rdp->passed_quiesc_completed = rdp->gpnum - 1;
+	rdp->passed_quiesce_gpnum = rdp->gpnum;
 	barrier();
-	if (rdp->passed_quiesc == 0)
+	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
-	rdp->passed_quiesc = 1;
+	rdp->passed_quiesce = 1;
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index e623564..3f739cf3 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -61,11 +61,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pqc=%lu qp=%d",
+	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pgp=%lu qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, " dt=%d/%d/%d df=%lu",
@@ -139,7 +139,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
@@ -170,7 +170,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
+	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
-- 
1.7.3.2

