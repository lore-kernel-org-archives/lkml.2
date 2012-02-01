Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2BATuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:50:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51210 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab2BATul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:50:41 -0500
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
Subject: [PATCH RFC tip/core/rcu 29/41] rcu: Print scheduling-clock information on RCU CPU stall-warning messages
Date: Wed,  1 Feb 2012 11:41:47 -0800
Message-Id: <1328125319-5205-29-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-6078-0000-0000-0000075A46CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

There have been situations where RCU CPU stall warnings were caused by
issues in scheduling-clock timer initialization.  To make it easier to
track these down, this commit causes the RCU CPU stall-warning messages
to print out the number of scheduling-clock interrupts taken in the
current grace period for each stalled CPU.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   33 +++++++----
 kernel/rcutree.h        |   11 ++++
 kernel/rcutree_plugin.h |  150 ++++++++++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug       |   14 +++++
 4 files changed, 194 insertions(+), 14 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e82e505..d2c770b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -692,12 +692,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		return;
 	}
 	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
-
-	/*
-	 * Now rat on any tasks that got kicked up to the root rcu_node
-	 * due to CPU offlining.
-	 */
-	ndetected = rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -705,8 +699,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks: {",
+	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks:",
 	       rsp->name);
+	print_cpu_stall_info_begin();
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		ndetected += rcu_print_task_stall(rnp);
@@ -715,11 +710,22 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
 			if (rnp->qsmask & (1UL << cpu)) {
-				printk(" %d", rnp->grplo + cpu);
+				print_cpu_stall_info(rsp, rnp->grplo + cpu);
 				ndetected++;
 			}
 	}
-	printk("} (detected by %d, t=%ld jiffies)\n",
+
+	/*
+	 * Now rat on any tasks that got kicked up to the root rcu_node
+	 * due to CPU offlining.
+	 */
+	rnp = rcu_get_root(rsp);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	ndetected = rcu_print_task_stall(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+
+	print_cpu_stall_info_end();
+	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
@@ -743,8 +749,11 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
-	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
+	printk(KERN_ERR "INFO: %s self-detected stall on CPU", rsp->name);
+	print_cpu_stall_info_begin();
+	print_cpu_stall_info(rsp, smp_processor_id());
+	print_cpu_stall_info_end();
+	printk(KERN_CONT " (t=%lu jiffies)\n", jiffies - rsp->gp_start);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
@@ -834,6 +843,7 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 			rdp->passed_quiesce = 0;
 		} else
 			rdp->qs_pending = 0;
+		zero_cpu_stall_ticks(rdp);
 	}
 }
 
@@ -1499,6 +1509,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization("Start scheduler-tick");
+	increment_cpu_stall_ticks();
 	if (user || rcu_is_cpu_rrupt_from_idle()) {
 
 		/*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 0328a53..e2ac8ee 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -239,6 +239,12 @@ struct rcu_data {
 	bool		preemptible;	/* Preemptible RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+	unsigned long	ticks_this_gp;	/* The number of scheduling-clock */
+					/*  ticks this CPU has handled */
+					/*  during and after the last grace */
+					/* period it is aware of. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
 
 	/* 2) batch handling */
 	/*
@@ -466,5 +472,10 @@ static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
+static void print_cpu_stall_info_begin(void);
+static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
+static void print_cpu_stall_info_end(void);
+static void zero_cpu_stall_ticks(struct rcu_data *rdp);
+static void increment_cpu_stall_ticks(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 1b2a82b..a56fa20 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -63,7 +63,10 @@ static void __init rcu_bootup_announce_oddness(void)
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
-	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
+	printk(KERN_INFO "\tDump stacks of tasks blocking RCU-preempt GP.\n");
+#endif
+#if defined(CONFIG_RCU_CPU_STALL_INFO)
+	printk(KERN_INFO "\tAdditional per-CPU info printed with stalls.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
 	printk(KERN_INFO "\tExperimental four-level hierarchy is enabled.\n");
@@ -490,6 +493,31 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 
 #endif /* #else #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
 
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+
+static void rcu_print_task_stall_begin(struct rcu_node *rnp)
+{
+	printk(KERN_ERR "\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
+	       rnp->level, rnp->grplo, rnp->grphi);
+}
+
+static void rcu_print_task_stall_end(void)
+{
+	printk(KERN_CONT "\n");
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
+static void rcu_print_task_stall_begin(struct rcu_node *rnp)
+{
+}
+
+static void rcu_print_task_stall_end(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
 /*
  * Scan the current list of tasks blocked within RCU read-side critical
  * sections, printing out the tid of each.
@@ -501,12 +529,14 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return 0;
+	rcu_print_task_stall_begin(rnp);
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
-		printk(" P%d", t->pid);
+		printk(KERN_CONT " P%d", t->pid);
 		ndetected++;
 	}
+	rcu_print_task_stall_end();
 	return ndetected;
 }
 
@@ -2003,7 +2033,7 @@ static void rcu_cleanup_after_idle(int cpu)
 }
 
 /*
- * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=y,
+ * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=n,
  * is nothing.
  */
 static void rcu_prepare_for_idle(int cpu)
@@ -2272,3 +2302,117 @@ static void rcu_prepare_for_idle(int cpu)
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
+
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+
+#ifdef CONFIG_RCU_FAST_NO_HZ
+
+static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
+{
+	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+
+	sprintf(cp, "drain=%d %c timer=%lld",
+		per_cpu(rcu_dyntick_drain, cpu),
+		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
+		hrtimer_active(hrtp)
+			? ktime_to_us(hrtimer_get_remaining(hrtp))
+			: -1);
+}
+
+#else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
+
+static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_FAST_NO_HZ */
+
+/* Initiate the stall-info list. */
+static void print_cpu_stall_info_begin(void)
+{
+	printk(KERN_CONT "\n");
+}
+
+/*
+ * Print out diagnostic information for the specified stalled CPU.
+ *
+ * If the specified CPU is aware of the current RCU grace period
+ * (flavor specified by rsp), then print the number of scheduling
+ * clock interrupts the CPU has taken during the time that it has
+ * been aware.  Otherwise, print the number of RCU grace periods
+ * that this CPU is ignorant of, for example, "1" if the CPU was
+ * aware of the previous grace period.
+ *
+ * Also print out idle and (if CONFIG_RCU_FAST_NO_HZ) idle-entry info.
+ */
+static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
+{
+	char fast_no_hz[72];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+	struct rcu_dynticks *rdtp = rdp->dynticks;
+	char *ticks_title;
+	unsigned long ticks_value;
+
+	if (rsp->gpnum == rdp->gpnum) {
+		ticks_title = "ticks this GP";
+		ticks_value = rdp->ticks_this_gp;
+	} else {
+		ticks_title = "GPs behind";
+		ticks_value = rsp->gpnum - rdp->gpnum;
+	}
+	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
+	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d %s\n",
+	       cpu, ticks_value, ticks_title,
+	       atomic_read(&rdtp->dynticks) & 0xfff,
+	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
+	       fast_no_hz);
+}
+
+/* Terminate the stall-info list. */
+static void print_cpu_stall_info_end(void)
+{
+	printk(KERN_ERR "\t");
+}
+
+/* Zero ->ticks_this_gp for all flavors of RCU. */
+static void zero_cpu_stall_ticks(struct rcu_data *rdp)
+{
+	rdp->ticks_this_gp = 0;
+}
+
+/* Increment ->ticks_this_gp for all flavors of RCU. */
+static void increment_cpu_stall_ticks(void)
+{
+	__get_cpu_var(rcu_sched_data).ticks_this_gp++;
+	__get_cpu_var(rcu_bh_data).ticks_this_gp++;
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	__get_cpu_var(rcu_preempt_data).ticks_this_gp++;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
+static void print_cpu_stall_info_begin(void)
+{
+	printk(KERN_CONT " {");
+}
+
+static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
+{
+	printk(KERN_CONT " %d", cpu);
+}
+
+static void print_cpu_stall_info_end(void)
+{
+	printk(KERN_CONT "} ");
+}
+
+static void zero_cpu_stall_ticks(struct rcu_data *rdp)
+{
+}
+
+static void increment_cpu_stall_ticks(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_INFO */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bb67ce2..dabf524 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -927,6 +927,20 @@ config RCU_CPU_STALL_VERBOSE
 
 	  Say Y if you want to enable such checks.
 
+config RCU_CPU_STALL_INFO
+	bool "Print additional diagnostics on RCU CPU stall"
+	depends on (TREE_RCU || TREE_PREEMPT_RCU) && DEBUG_KERNEL
+	default n
+	help
+	  For each stalled CPU that is aware of the current RCU grace
+	  period, print out additional per-CPU diagnostic information
+	  regarding scheduling-clock ticks, idle state, and,
+	  for RCU_FAST_NO_HZ kernels, idle-entry state.
+
+	  Say N if you are unsure.
+
+	  Say Y if you want to enable such diagnostics.
+
 config RCU_TRACE
 	bool "Enable tracing for RCU"
 	help
-- 
1.7.8

