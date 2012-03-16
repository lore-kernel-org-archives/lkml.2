Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032907Ab2CPQLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:11:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40066 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239Ab2CPQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:11:45 -0400
Date: Fri, 16 Mar 2012 09:03:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, efault@gmx.de, sivanich@sgi.com
Subject: [PATCH RFC] rcu: Permit limiting of force_quiescent_state() latency
Message-ID: <20120316160328.GA7207@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031616-7408-0000-0000-0000037FC22A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dimitri and Mike,

This one is a first step in limiting RCU-induced latencies for systems
that have not just NR_CPUS=4096, but also a lot of CPUs.  I have tested
this using my big-system-simulation setup, but of course testing on
systems that really are big would be quite valuable.

Remaining issues include the latency of setting up grace periods and
the latency of finalizing them in the case where another grace period
is not immediately rquired.

							Thanx, Paul

------------------------------------------------------------------------

Systems whose cache-miss penalties are large compared to the permitted
per-CPU force_quiescent_state() latency can limit these latencies by
defining CONFIG_ARCH_RCU_FQS_LIMIT to be the maximum number of CPUs
that force_quiescent_state() is permitted to visit per invocation.
If this limit is exceeded, the next CPU to scan is stored into a new
->fqs_next_cpu field in the rcu_state structure, and the existing
->jiffies_force_qs field is set so that the next CPU will re-invoke
force_quiescent_state() rather than waiting a few jiffies.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7247fa8..e99b405 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1685,47 +1685,66 @@ void rcu_check_callbacks(int cpu, int user)
  * have not yet encountered a quiescent state, using the function specified.
  * Also initiate boosting for any threads blocked on the root rcu_node.
  *
+ * Returns 0 if the scan could not be completed, 1 otherwise.
  * The caller must have suppressed start of new grace periods.
  */
-static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
+static int force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
+	int cpusvisited = 0;
 	unsigned long flags;
 	unsigned long mask;
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
+		if (rnp->grphi < rsp->fqs_next_cpu)
+			continue;
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		if (!rcu_gp_in_progress(rsp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			return;
+			return 1;
 		}
 		if (rnp->qsmask == 0) {
 			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
 			continue;
 		}
 		cpu = rnp->grplo;
+		if (cpu < rsp->fqs_next_cpu)
+			cpu = rsp->fqs_next_cpu;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
-			if ((rnp->qsmask & bit) != 0 &&
-			    f(per_cpu_ptr(rsp->rda, cpu)))
+			if ((rnp->qsmask & bit) == 0)
+				continue;
+			if (cpu > rcu_get_max_cpu())
+				goto done;
+			if (f(per_cpu_ptr(rsp->rda, cpu)))
 				mask |= bit;
+			if (++cpusvisited >= FQS_MAX_CPU_VISIT) {
+				rsp->fqs_next_cpu = cpu + 1;
+				break;
+			}
 		}
 		if (mask != 0) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
-			continue;
+			if (cpusvisited < FQS_MAX_CPU_VISIT)
+				continue;
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		if (cpusvisited >= FQS_MAX_CPU_VISIT)
+			break;
 	}
 	rnp = rcu_get_root(rsp);
 	if (rnp->qsmask == 0) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 	}
+done:
+	rsp->fqs_next_cpu = 0;
+	return 1;
 }
 
 /*
@@ -1735,6 +1754,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
+	int retval;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	trace_rcu_utilization("Start fqs");
@@ -1771,21 +1791,25 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 
 		/* Record dyntick-idle state. */
-		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		retval = force_qs_rnp(rsp, dyntick_save_progress_counter);
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (rcu_gp_in_progress(rsp))
+		if (rcu_gp_in_progress(rsp) && retval) {
 			rsp->fqs_state = RCU_FORCE_QS;
+			rsp->fqs_next_cpu = 0;
+		} else if (rcu_gp_in_progress(rsp))
+			rsp->jiffies_force_qs = jiffies - 1;
 		break;
 
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
+		retval = force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
-
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
+		if (rcu_gp_in_progress(rsp) && !retval)
+			rsp->jiffies_force_qs = jiffies - 1;
 		break;
 	}
 	rsp->fqs_active = 0;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 772df1c..444a39b 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -348,6 +348,21 @@ do {									\
 } while (0)
 
 /*
+ * Large latency-sensitive configurations can limit force_quiescent_state()
+ * latencies by defining an CONFIG_ARCH_RCU_FQS_LIMIT.  This should be
+ * sized based on that architecture's cache-miss latency and the maximum
+ * desired force_quiescent_state latency.  For example, if the cache-miss
+ * latency was 100 nanoseconds, and the maximum force_quiescent_state()
+ * latency contribution was 5 microseconds, then that architecture should
+ * define CONFIG_ARCH_RCU_FQS_LIMIT to be 50.
+ */
+#ifdef CONFIG_ARCH_RCU_FQS_LIMIT
+#define FQS_MAX_CPU_VISIT CONFIG_ARCH_RCU_FQS_LIMIT
+#else /* #ifdef CONFIG_ARCH_RCU_FQS_LIMIT */
+#define FQS_MAX_CPU_VISIT NR_CPUS
+#endif /* #else #ifdef CONFIG_ARCH_RCU_FQS_LIMIT */
+
+/*
  * RCU global state, including node hierarchy.  This hierarchy is
  * represented in "heap" form in a dense array.  The root (first level)
  * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
@@ -396,6 +411,7 @@ struct rcu_state {
 						/*  or NULL if no barrier. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
+	int fqs_next_cpu;			/* Next CPU for fqs to scan. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */

