Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3AERwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:52:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50193 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3AERtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/14] rcu: Remove restrictions on no-CBs CPUs
Date: Sat,  5 Jan 2013 09:48:53 -0800
Message-Id: <1357408144-15830-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7606-0000-0000-00000726CA2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, CPU 0 is constrained to not be a no-CBs CPU, and furthermore
at least one no-CBs CPU must remain online at any given time.  These
restrictions are problematic in some situations, such as cases where
all CPUs must run a real-time workload that needs to be insulated from
OS jitter and latencies due to RCU callback invocation.  This commit
therefore provides no-CBs CPUs a way to start and to wait for grace
periods independently of the normal RCU callback mechanisms.  This
approach allows any or all of the CPUs to be designated as no-CBs CPUs,
and allows any proper subset of the CPUs (whether no-CBs CPUs or not)
to be offlined.

This commit also provides event tracing, as well as a fix for a locking
bug spotted by Xie ChanglongX <changlongx.xie@intel.com>.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   55 +++++++++
 init/Kconfig               |    4 +-
 kernel/rcutree.c           |   15 ++-
 kernel/rcutree.h           |   18 ++--
 kernel/rcutree_plugin.h    |  271 +++++++++++++++++++++++++++-----------------
 5 files changed, 244 insertions(+), 119 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 5678114..ef0bf31 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -72,6 +72,58 @@ TRACE_EVENT(rcu_grace_period,
 );
 
 /*
+ * Tracepoint for no-callbacks grace-period events.  The caller should
+ * pull the data from the rcu_node structure, other than rcuname, which
+ * comes from the rcu_state structure, and event, which is one of the
+ * following:
+ *
+ * "Startleaf": Request a nocb grace period based on leaf-node data.
+ * "Startedleaf": Leaf-node start proved sufficient.
+ * "Startedleafroot": Leaf-node start proved sufficient after checking root.
+ * "Startedroot": Requested a nocb grace period based on root-node data.
+ * "StartWait": Start waiting for the requested grace period.
+ * "ResumeWait": Resume waiting after signal.
+ * "EndWait": Complete wait.
+ * "Cleanup": Clean up rcu_node structure after previous GP.
+ * "CleanupMore": Clean up, and another no-CB GP is needed.
+ */
+TRACE_EVENT(rcu_nocb_grace_period,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, unsigned long completed,
+		 unsigned long c, u8 level, int grplo, int grphi,
+		 char *gpevent),
+
+	TP_ARGS(rcuname, gpnum, completed, c, level, grplo, grphi, gpevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(unsigned long, completed)
+		__field(unsigned long, c)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(char *, gpevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->completed = completed;
+		__entry->c = c;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->gpevent = gpevent;
+	),
+
+	TP_printk("%s %lu %lu %lu %u %d %d %s",
+		  __entry->rcuname, __entry->gpnum, __entry->completed,
+		  __entry->c, __entry->level, __entry->grplo, __entry->grphi,
+		  __entry->gpevent)
+);
+
+/*
  * Tracepoint for grace-period-initialization events.  These are
  * distinguished by the type of RCU, the new grace-period number, the
  * rcu_node structure level, the starting and ending CPU covered by the
@@ -593,6 +645,9 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
 #define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
 				    qsmask) do { } while (0)
+#define trace_rcu_nocb_grace_period(rcuname, gpnum, completed, c, \
+				    level, grplo, grphi, event) \
+				    do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/init/Kconfig b/init/Kconfig
index 7d30240..fc6a3ca 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -655,7 +655,7 @@ config RCU_BOOST_DELAY
 	  Accept the default if unsure.
 
 config RCU_NOCB_CPU
-	bool "Offload RCU callback processing from boot-selected CPUs"
+	bool "Offload RCU callback processing from boot-selected CPUs (EXPERIMENTAL"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
@@ -673,7 +673,7 @@ config RCU_NOCB_CPU
 	  callback, and (2) affinity or cgroups can be used to force
 	  the kthreads to run on whatever set of CPUs is desired.
 
-	  Say Y here if you want reduced OS jitter on selected CPUs.
+	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
 
 endmenu # "RCU Subsystem"
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e9dce4f..8b110fa 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -316,6 +316,8 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_gp_in_progress(rsp))
 		return 0;  /* No, a grace period is already in progress. */
+	if (rcu_nocb_needs_gp(rsp))
+		return 1;  /* Yes, a no-CBs CPU needs one. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL])
 		return 0;  /* No, this is a no-CBs (or offline) CPU. */
 	if (*rdp->nxttail[RCU_NEXT_READY_TAIL])
@@ -1400,6 +1402,7 @@ int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 static void rcu_gp_cleanup(struct rcu_state *rsp)
 {
 	unsigned long gp_duration;
+	int nocb = 0;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
@@ -1430,11 +1433,13 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
 		rnp->completed = rsp->gpnum;
+		nocb += rcu_nocb_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
+	rcu_nocb_gp_set(rnp, nocb);
 
 	rsp->completed = rsp->gpnum; /* Declare grace period done. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
@@ -2951,7 +2956,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
-	int ret = NOTIFY_OK;
 
 	trace_rcu_utilization("Start CPU hotplug");
 	switch (action) {
@@ -2965,10 +2969,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_boost_kthread_setaffinity(rnp, -1);
 		break;
 	case CPU_DOWN_PREPARE:
-		if (nocb_cpu_expendable(cpu))
-			rcu_boost_kthread_setaffinity(rnp, cpu);
-		else
-			ret = NOTIFY_BAD;
+		rcu_boost_kthread_setaffinity(rnp, cpu);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -2992,7 +2993,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	}
 	trace_rcu_utilization("End CPU hotplug");
-	return ret;
+	return NOTIFY_OK;
 }
 
 /*
@@ -3123,6 +3124,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			}
 			rnp->level = i;
 			INIT_LIST_HEAD(&rnp->blkd_tasks);
+			rcu_init_one_nocb(rnp);
 		}
 	}
 
@@ -3208,7 +3210,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	rcu_init_nocb();
 	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c9f362e..ef26eab 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -200,6 +200,12 @@ struct rcu_node {
 				/* Refused to boost: not sure why, though. */
 				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
+#ifdef CONFIG_RCU_NOCB_CPU
+	wait_queue_head_t nocb_gp_wq[2];
+				/* Place for rcu_nocb_kthread() to wait GP. */
+	int n_nocb_gp_requests[2];
+				/* Counts of upcoming no-CB GP requests. */
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
 } ____cacheline_internodealigned_in_smp;
 
@@ -384,12 +390,6 @@ struct rcu_state {
 	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
 		     void (*func)(struct rcu_head *head));
-#ifdef CONFIG_RCU_NOCB_CPU
-	void (*call_remote)(struct rcu_head *head,
-		     void (*func)(struct rcu_head *head));
-						/* call_rcu() flavor, but for */
-						/*  placing on remote CPU. */
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
@@ -538,16 +538,18 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
+static int rcu_nocb_needs_gp(struct rcu_state *rsp);
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
+static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
+static void rcu_init_one_nocb(struct rcu_node *rnp);
 static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp);
-static bool nocb_cpu_expendable(int cpu);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void init_nocb_callback_list(struct rcu_data *rdp);
-static void __init rcu_init_nocb(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f6e5ec2..37750bc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -87,10 +87,6 @@ static void __init rcu_bootup_announce_oddness(void)
 		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
 	if (have_rcu_nocb_mask) {
-		if (cpumask_test_cpu(0, rcu_nocb_mask)) {
-			cpumask_clear_cpu(0, rcu_nocb_mask);
-			pr_info("\tCPU 0: illegal no-CBs CPU (cleared).\n");
-		}
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
@@ -2159,6 +2155,57 @@ static int __init rcu_nocb_setup(char *str)
 }
 __setup("rcu_nocbs=", rcu_nocb_setup);
 
+/*
+ * Do any no-CBs CPUs need another grace period?
+ *
+ * Interrupts must be disabled.  If the caller does not hold the root
+ * rnp_node structure's ->lock, the results are advisory only.
+ */
+static int rcu_nocb_needs_gp(struct rcu_state *rsp)
+{
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	return rnp->n_nocb_gp_requests[(ACCESS_ONCE(rnp->completed) + 1) & 0x1];
+}
+
+/*
+ * Clean up this rcu_node structure's no-CBs state at the end of
+ * a grace period, and also return whether any no-CBs CPU associated
+ * with this rcu_node structure needs another grace period.
+ */
+static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	int c = rnp->completed;
+	int needmore;
+
+	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
+	rnp->n_nocb_gp_requests[c & 0x1] = 0;
+	needmore = rnp->n_nocb_gp_requests[(c + 1) & 0x1];
+	trace_rcu_nocb_grace_period(rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    needmore ? "CleanupMore" : "Cleanup");
+	return needmore;
+}
+
+/*
+ * Set the root rcu_node structure's ->n_nocb_gp_requests field
+ * based on the sum of those of all rcu_node structures.  This does
+ * double-count the root rcu_node structure's requests, but this
+ * is necessary to handle the possibility of a rcu_nocb_kthread()
+ * having awakened during the time that the rcu_node structures
+ * were being updated for the end of the previous grace period.
+ */
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
+{
+	rnp->n_nocb_gp_requests[(rnp->completed + 1) & 0x1] += nrq;
+}
+
+static void rcu_init_one_nocb(struct rcu_node *rnp)
+{
+	init_waitqueue_head(&rnp->nocb_gp_wq[0]);
+	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
+}
+
 /* Is the specified CPU a no-CPUs CPU? */
 static bool is_nocb_cpu(int cpu)
 {
@@ -2221,6 +2268,13 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 	if (!is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
+	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
+		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
+					 (unsigned long)rhp->func,
+					 rdp->qlen_lazy, rdp->qlen);
+	else
+		trace_rcu_callback(rdp->rsp->name, rhp,
+				   rdp->qlen_lazy, rdp->qlen);
 	return 1;
 }
 
@@ -2259,95 +2313,108 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 }
 
 /*
- * There must be at least one non-no-CBs CPU in operation at any given
- * time, because no-CBs CPUs are not capable of initiating grace periods
- * independently.  This function therefore complains if the specified
- * CPU is the last non-no-CBs CPU, allowing the CPU-hotplug system to
- * avoid offlining the last such CPU.  (Recursion is a wonderful thing,
- * but you have to have a base case!)
+ * If necessary, kick off a new grace period, and either way wait
+ * for a subsequent grace period to complete.
  */
-static bool nocb_cpu_expendable(int cpu)
+static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 {
-	cpumask_var_t non_nocb_cpus;
-	int ret;
+	unsigned long c;
+	bool d;
+	unsigned long flags;
+	unsigned long flags1;
+	struct rcu_node *rnp = rdp->mynode;
+	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
 
-	/*
-	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
-	 * then offlining this CPU is harmless.  Let it happen.
-	 */
-	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
-		return 1;
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	c = rnp->completed + 2;
 
-	/* If no memory, play it safe and keep the CPU around. */
-	if (!alloc_cpumask_var(&non_nocb_cpus, GFP_NOIO))
-		return 0;
-	cpumask_andnot(non_nocb_cpus, cpu_online_mask, rcu_nocb_mask);
-	cpumask_clear_cpu(cpu, non_nocb_cpus);
-	ret = !cpumask_empty(non_nocb_cpus);
-	free_cpumask_var(non_nocb_cpus);
-	return ret;
-}
+	/* Count our request for a grace period. */
+	rnp->n_nocb_gp_requests[c & 0x1]++;
+	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    "Startleaf");
 
-/*
- * Helper structure for remote registry of RCU callbacks.
- * This is needed for when a no-CBs CPU needs to start a grace period.
- * If it just invokes call_rcu(), the resulting callback will be queued,
- * which can result in deadlock.
- */
-struct rcu_head_remote {
-	struct rcu_head *rhp;
-	call_rcu_func_t *crf;
-	void (*func)(struct rcu_head *rhp);
-};
+	if (rnp->gpnum != rnp->completed) {
 
-/*
- * Register a callback as specified by the rcu_head_remote struct.
- * This function is intended to be invoked via smp_call_function_single().
- */
-static void call_rcu_local(void *arg)
-{
-	struct rcu_head_remote *rhrp =
-		container_of(arg, struct rcu_head_remote, rhp);
+		/*
+		 * This rcu_node structure believes that a grace period
+		 * is in progress, so we are done.  When this grace
+		 * period ends, our request will be acted upon.
+		 */
+		trace_rcu_nocb_grace_period(rdp->rsp->name,
+					    rnp->gpnum, rnp->completed, c,
+					    rnp->level, rnp->grplo, rnp->grphi,
+					    "Startedleaf");
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
-	rhrp->crf(rhrp->rhp, rhrp->func);
-}
+	} else {
 
-/*
- * Set up an rcu_head_remote structure and the invoke call_rcu_local()
- * on CPU 0 (which is guaranteed to be a non-no-CBs CPU) via
- * smp_call_function_single().
- */
-static void invoke_crf_remote(struct rcu_head *rhp,
-			      void (*func)(struct rcu_head *rhp),
-			      call_rcu_func_t crf)
-{
-	struct rcu_head_remote rhr;
+		/*
+		 * Might not be a grace period, check root rcu_node
+		 * structure to see if we must start one.
+		 */
+		if (rnp != rnp_root)
+			raw_spin_lock(&rnp_root->lock); /* irqs disabled. */
+		if (rnp_root->gpnum != rnp_root->completed) {
+			trace_rcu_nocb_grace_period(rdp->rsp->name,
+						    rnp->gpnum, rnp->completed,
+						    c, rnp->level,
+						    rnp->grplo, rnp->grphi,
+						    "Startedleafroot");
+			raw_spin_unlock(&rnp_root->lock); /* irqs disabled. */
+		} else {
 
-	rhr.rhp = rhp;
-	rhr.crf = crf;
-	rhr.func = func;
-	smp_call_function_single(0, call_rcu_local, &rhr, 1);
-}
+			/*
+			 * No grace period, so we need to start one.
+			 * The good news is that we can wait for exactly
+			 * one grace period instead of part of the current
+			 * grace period and all of the next grace period.
+			 * Adjust counters accordingly and start the
+			 * needed grace period.
+			 */
+			rnp->n_nocb_gp_requests[c & 0x1]--;
+			c = rnp_root->completed + 1;
+			rnp->n_nocb_gp_requests[c & 0x1]++;
+			rnp_root->n_nocb_gp_requests[c & 0x1]++;
+			trace_rcu_nocb_grace_period(rdp->rsp->name,
+						    rnp->gpnum, rnp->completed,
+						    c, rnp->level,
+						    rnp->grplo, rnp->grphi,
+						    "Startedroot");
+			local_save_flags(flags1);
+			rcu_start_gp(rdp->rsp, flags1); /* Rlses ->lock. */
+		}
 
-/*
- * Helper functions to be passed to wait_rcu_gp(), each of which
- * invokes invoke_crf_remote() to register a callback appropriately.
- */
-static void __maybe_unused
-call_rcu_preempt_remote(struct rcu_head *rhp,
-			void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu);
-}
-static void call_rcu_bh_remote(struct rcu_head *rhp,
-			       void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu_bh);
-}
-static void call_rcu_sched_remote(struct rcu_head *rhp,
-				  void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu_sched);
+		/* Clean up locking and irq state. */
+		if (rnp != rnp_root)
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		else
+			local_irq_restore(flags);
+	}
+
+	/*
+	 * Wait for the grace period.  Do so interruptibly to avoid messing
+	 * up the load average.
+	 */
+	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    "StartWait");
+	for (;;) {
+		wait_event_interruptible(
+			rnp->nocb_gp_wq[c & 0x1],
+			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
+		if (likely(d))
+			break;
+		flush_signals(current);
+		trace_rcu_nocb_grace_period(rdp->rsp->name,
+					    rnp->gpnum, rnp->completed, c,
+					    rnp->level, rnp->grplo, rnp->grphi,
+					    "ResumeWait");
+	}
+	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    "EndWait");
+	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
 /*
@@ -2366,10 +2433,11 @@ static int rcu_nocb_kthread(void *arg)
 	for (;;) {
 		/* If not polling, wait for next batch of callbacks. */
 		if (!rcu_nocb_poll)
-			wait_event(rdp->nocb_wq, rdp->nocb_head);
+			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
 		list = ACCESS_ONCE(rdp->nocb_head);
 		if (!list) {
 			schedule_timeout_interruptible(1);
+			flush_signals(current);
 			continue;
 		}
 
@@ -2383,7 +2451,7 @@ static int rcu_nocb_kthread(void *arg)
 		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
 		ACCESS_ONCE(rdp->nocb_p_count) += c;
 		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
-		wait_rcu_gp(rdp->rsp->call_remote);
+		rcu_nocb_wait_gp(rdp);
 
 		/* Each pass through the following loop invokes a callback. */
 		trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
@@ -2444,17 +2512,25 @@ static void init_nocb_callback_list(struct rcu_data *rdp)
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 }
 
-/* Initialize the ->call_remote fields in the rcu_state structures. */
-static void __init rcu_init_nocb(void)
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+
+static int rcu_nocb_needs_gp(struct rcu_state *rsp)
 {
-#ifdef CONFIG_PREEMPT_RCU
-	rcu_preempt_state.call_remote = call_rcu_preempt_remote;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-	rcu_bh_state.call_remote = call_rcu_bh_remote;
-	rcu_sched_state.call_remote = call_rcu_sched_remote;
+	return 0;
 }
 
-#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	return 0;
+}
+
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
+{
+}
+
+static void rcu_init_one_nocb(struct rcu_node *rnp)
+{
+}
 
 static bool is_nocb_cpu(int cpu)
 {
@@ -2473,11 +2549,6 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	return 0;
 }
 
-static bool nocb_cpu_expendable(int cpu)
-{
-	return 1;
-}
-
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 }
@@ -2490,8 +2561,4 @@ static void init_nocb_callback_list(struct rcu_data *rdp)
 {
 }
 
-static void __init rcu_init_nocb(void)
-{
-}
-
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
-- 
1.7.8

