Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1GKDvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:51:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38138 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab1GKDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:51:50 -0400
Date: Sun, 10 Jul 2011 20:51:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: RKK <kulkarni.ravi4@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0-rc5 doesnt boot and hangs at rcu_sched_state ()
Message-ID: <20110711035137.GA14739@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTikW6Xk8UMsOHLCnLn7STRzy8RaiJA@mail.gmail.com>
 <20110709160131.GA18172@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110709160131.GA18172@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 09:01:31AM -0700, Paul E. McKenney wrote:
> On Wed, Jun 29, 2011 at 06:56:35PM +0530, RKK wrote:
> > Hello,
> > I tried booting Linux3.0.rc5 on my machine today but everytime it
> > hangs after this message
> > 
> > a)starting configure read only root support
> > 
> > after this waiting for sometime then this message appears
> > 
> > b)INFO rcu_sched_state: RCU stalls CPU/disks
> > 
> > i tried to read the Documentation/RCU and enable CONFIG_RCU_TRACE but
> > dint know how to proceed further  .
> > 
> > i tried repeating this 4-5 times , one thing i observed that is
> > appearance of rcu_sched_state is intermittent but everytime the boot
> > stops/hangs at a) message .
> 
> Can you set up the SysRq key as described in Documentation/sysrq.txt?
> This might help you get some information about what the system is doing
> during the wait time.
> 
> My guess is that your kernel is spinning with interrupts disabled, and
> that RCU eventually tries to complain about this.  The possible causes
> of this are listed in Documentation/RCU/stallwarn.txt.

Could you please try out this patch and see if it helps?

							Thanx, Paul

------------------------------------------------------------------------

rcu: use softirq instead of kthreads except when RCU_BOOST=y

This patch #ifdefs RCU kthreads out of the kernel unless RCU_BOOST=y,
thus eliminating context-switch overhead if RCU priority boosting has
not been configured.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ae5c9ea..429d494 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -87,6 +87,8 @@ static struct rcu_state *rcu_state;
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+#ifdef CONFIG_RCU_BOOST
+
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
@@ -98,9 +100,11 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
-static void invoke_rcu_cpu_kthread(void);
-static void __invoke_rcu_cpu_kthread(void);
+static void invoke_rcu_core(void);
+static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
 #define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
 
@@ -1089,6 +1093,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
+#ifdef CONFIG_RCU_BOOST
 	struct task_struct *t;
 
 	/* Stop the CPU's kthread. */
@@ -1097,6 +1102,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
 		kthread_stop(t);
 	}
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -1232,7 +1238,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		invoke_rcu_cpu_kthread();
+		invoke_rcu_core();
 }
 
 /*
@@ -1278,7 +1284,7 @@ void rcu_check_callbacks(int cpu, int user)
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
-		invoke_rcu_cpu_kthread();
+		invoke_rcu_core();
 }
 
 #ifdef CONFIG_SMP
@@ -1444,9 +1450,11 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* If there are callbacks ready, invoke them. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		__invoke_rcu_cpu_kthread();
+		invoke_rcu_callbacks(rsp, rdp);
 }
 
+#ifdef CONFIG_RCU_BOOST
+
 static void rcu_kthread_do_work(void)
 {
 	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
@@ -1454,6 +1462,8 @@ static void rcu_kthread_do_work(void)
 	rcu_preempt_do_callbacks();
 }
 
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 /*
  * Do softirq processing for the current CPU.
  */
@@ -1474,25 +1484,22 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
  * cannot disappear out from under us.
  */
-static void __invoke_rcu_cpu_kthread(void)
+static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
-		local_irq_restore(flags);
+	if (likely(!rsp->boost)) {
+		rcu_do_batch(rsp, rdp);
 		return;
 	}
-	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
-	local_irq_restore(flags);
+	invoke_rcu_callbacks_kthread();
 }
 
-static void invoke_rcu_cpu_kthread(void)
+static void invoke_rcu_core(void)
 {
 	raise_softirq(RCU_SOFTIRQ);
 }
 
+#ifdef CONFIG_RCU_BOOST
+
 /*
  * Wake up the specified per-rcu_node-structure kthread.
  * Because the per-rcu_node kthreads are immortal, we don't need
@@ -1818,6 +1825,18 @@ static int __init rcu_spawn_kthreads(void)
 }
 early_initcall(rcu_spawn_kthreads);
 
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
+{
+}
+
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	   struct rcu_state *rsp)
@@ -2224,6 +2243,8 @@ static void __cpuinit rcu_prepare_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
+#ifdef CONFIG_RCU_BOOST
+
 static void __cpuinit rcu_prepare_kthreads(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
@@ -2237,6 +2258,14 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 	}
 }
 
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static void __cpuinit rcu_prepare_kthreads(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 /*
  * Handle CPU online/offline notification events.
  */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 0fed6b9..434288c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -369,6 +369,7 @@ struct rcu_state {
 						/*  period because */
 						/*  force_quiescent_state() */
 						/*  was running. */
+	u8	boost;				/* Subject to priority boost. */
 	unsigned long gpnum;			/* Current gp number. */
 	unsigned long completed;		/* # of last completed gp. */
 
@@ -439,7 +440,6 @@ static void rcu_preempt_offline_cpu(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
-static void rcu_preempt_do_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
 static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
@@ -451,11 +451,15 @@ static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
+static void invoke_rcu_callbacks_kthread(void);
+#ifdef CONFIG_RCU_BOOST
+static void rcu_preempt_do_callbacks(void);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm);
-static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index);
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 38d09c5..2772386 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -602,11 +602,15 @@ static void rcu_preempt_process_callbacks(void)
 				&__get_cpu_var(rcu_preempt_data));
 }
 
+#ifdef CONFIG_RCU_BOOST
+
 static void rcu_preempt_do_callbacks(void)
 {
 	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
 }
 
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 /*
  * Queue a preemptible-RCU callback for invocation after a grace period.
  */
@@ -1002,10 +1006,6 @@ static void rcu_preempt_process_callbacks(void)
 {
 }
 
-static void rcu_preempt_do_callbacks(void)
-{
-}
-
 /*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptible RCU does not exist, map to rcu-sched.
@@ -1258,6 +1258,23 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
+ * Wake up the per-CPU kthread to invoke RCU callbacks.
+ */
+static void invoke_rcu_callbacks_kthread(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
+		local_irq_restore(flags);
+		return;
+	}
+	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	local_irq_restore(flags);
+}
+
+/*
  * Set the affinity of the boost kthread.  The CPU-hotplug locks are
  * held, so no one should be messing with the existence of the boost
  * kthread.
@@ -1297,6 +1314,7 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 
 	if (&rcu_preempt_state != rsp)
 		return 0;
+	rsp->boost = 1;
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
 	t = kthread_create(rcu_boost_kthread, (void *)rnp,
@@ -1319,22 +1337,15 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
-static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
-					  cpumask_var_t cm)
+static void invoke_rcu_callbacks_kthread(void)
 {
+	WARN_ON_ONCE(1);
 }
 
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
-static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
-						 struct rcu_node *rnp,
-						 int rnp_index)
-{
-	return 0;
-}
-
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 #ifndef CONFIG_SMP
@@ -1509,7 +1520,7 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
- * invoke_rcu_cpu_kthread() to cause rcu_process_callbacks() to be invoked
+ * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
  * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
@@ -1560,7 +1571,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
-		invoke_rcu_cpu_kthread();
+		invoke_rcu_core();
 	return c;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9678cc3..4e14487 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,8 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+#ifdef CONFIG_RCU_BOOST
+
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
@@ -58,6 +60,8 @@ static char convert_kthread_status(unsigned int kthread_status)
 	return "SRWOY"[kthread_status];
 }
 
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -76,7 +80,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c/%d ktl=%x b=%ld",
+	seq_printf(m, " ql=%ld qs=%c%c%c%c",
 		   rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -84,13 +88,16 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 			rdp->nxttail[RCU_NEXT_READY_TAIL]],
 		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
 			rdp->nxttail[RCU_WAIT_TAIL]],
-		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
+#ifdef CONFIG_RCU_BOOST
+	seq_printf(m, " kt=%d/%c/%d ktl=%x",
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)),
 		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
-		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff,
-		   rdp->blimit);
+		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	seq_printf(m, " b=%ld", rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -147,18 +154,21 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,\"%c%c%c%c\",%d,\"%c\",%ld", rdp->qlen,
+	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
 			rdp->nxttail[RCU_NEXT_READY_TAIL]],
 		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
 			rdp->nxttail[RCU_WAIT_TAIL]],
-		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
+#ifdef CONFIG_RCU_BOOST
+	seq_printf(m, ",%d,\"%c\"",
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
-					  rdp->cpu)),
-		   rdp->blimit);
+					  rdp->cpu)));
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	seq_printf(m, ",%ld", rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -169,7 +179,11 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
-	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
+	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
+#ifdef CONFIG_RCU_BOOST
+	seq_puts(m, "\"kt\",\"ktl\"");
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	seq_puts(m, "\"rcu_preempt:\"\n");
 	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
