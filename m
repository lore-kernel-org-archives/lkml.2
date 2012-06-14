Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2FNEvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:51:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40029 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2FNEvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:51:31 -0400
Date: Wed, 13 Jun 2012 21:51:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614045125.GA30257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613204725.GA9858@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061404-6148-0000-0000-000006AF1289
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:47:25PM -0700, Paul E. McKenney wrote:
> On Wed, Jun 13, 2012 at 12:17:45PM -0700, Paul E. McKenney wrote:
> > On Wed, Jun 13, 2012 at 09:02:55PM +0200, Thomas Gleixner wrote:
> > > On Wed, 13 Jun 2012, Paul E. McKenney wrote:
> > > > On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> > > > >  	/* Now call notifier in preparation. */
> > > > >  	cpu_notify(CPU_ONLINE | mod, hcpu);
> > > > > +	smpboot_unpark_threads(cpu);
> > > > 
> > > > OK, RCU must use the lower-level interfaces, given that one of
> > > > then CPU_ONLINE notifiers might invoke synchronize_rcu().
> > > 
> > > We can start the threads before the notifiers. There is no
> > > restriction.
> > 
> > Sounds very good in both cases!
> 
> Just for reference, here is what I am using.

And here is a buggy first attempt to make RCU use the smpboot interfaces.
Probably still bugs in my adaptation, as it still hangs in the first
attempt to offline a CPU.  If I revert the softirq smpboot commit, the
offline still hangs somewhere near the __stop_machine() processing, but
the system continues running otherwise.  Will continue debugging tomorrow.

When doing this sort of conversion, renaming the per-CPU variable used
to hold the kthreads' task_struct pointers is highly recommended --
failing to do so cost me substantial confusion.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Use smp_hotplug_thread facility for RCU's per-CPU kthread

Bring RCU into the new-age CPU-hotplug fold by modifying RCU's per-CPU
kthread code to use the new smp_hotplug_thread facility.
    
Not-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

 rcutree.c        |    4 -
 rcutree.h        |    2 
 rcutree_plugin.h |  177 ++++++++-----------------------------------------------
 rcutree_trace.c  |    3 
 4 files changed, 27 insertions(+), 159 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0da7b88..7813d7d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -125,7 +125,6 @@ static int rcu_scheduler_fully_active __read_mostly;
  */
 static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
@@ -1458,7 +1457,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
 
 	/* Adjust any no-longer-needed kthreads. */
-	rcu_stop_cpu_kthread(cpu);
 	rcu_node_kthread_setaffinity(rnp, -1);
 
 	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
@@ -2514,11 +2512,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		rcu_node_kthread_setaffinity(rnp, -1);
-		rcu_cpu_kthread_setrt(cpu, 1);
 		break;
 	case CPU_DOWN_PREPARE:
 		rcu_node_kthread_setaffinity(rnp, cpu);
-		rcu_cpu_kthread_setrt(cpu, 0);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7f5d138..70883af 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -434,7 +434,6 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
-static void rcu_stop_cpu_kthread(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static int rcu_print_task_stall(struct rcu_node *rnp);
@@ -472,7 +471,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 static void invoke_rcu_node_kthread(struct rcu_node *rnp);
 static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
 #endif /* #ifdef CONFIG_RCU_BOOST */
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
 static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2411000..f789341 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,6 +25,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/smpboot.h>
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -1449,25 +1450,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-/*
- * Stop the RCU's per-CPU kthread when its CPU goes offline,.
- */
-static void rcu_stop_cpu_kthread(int cpu)
-{
-	struct task_struct *t;
-
-	/* Stop the CPU's kthread. */
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t != NULL) {
-		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
-		kthread_stop(t);
-	}
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 static void rcu_kthread_do_work(void)
 {
 	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
@@ -1490,30 +1472,6 @@ static void invoke_rcu_node_kthread(struct rcu_node *rnp)
 }
 
 /*
- * Set the specified CPU's kthread to run RT or not, as specified by
- * the to_rt argument.  The CPU-hotplug locks are held, so the task
- * is not going away.
- */
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
-{
-	int policy;
-	struct sched_param sp;
-	struct task_struct *t;
-
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t == NULL)
-		return;
-	if (to_rt) {
-		policy = SCHED_FIFO;
-		sp.sched_priority = RCU_KTHREAD_PRIO;
-	} else {
-		policy = SCHED_NORMAL;
-		sp.sched_priority = 0;
-	}
-	sched_setscheduler_nocheck(t, policy, &sp);
-}
-
-/*
  * Timer handler to initiate the waking up of per-CPU kthreads that
  * have yielded the CPU due to excess numbers of RCU callbacks.
  * We wake up the per-rcu_node kthread, which in turn will wake up
@@ -1553,63 +1511,35 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 }
 
 /*
- * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
- * This can happen while the corresponding CPU is either coming online
- * or going offline.  We cannot wait until the CPU is fully online
- * before starting the kthread, because the various notifier functions
- * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
- * the corresponding CPU is online.
- *
- * Return 1 if the kthread needs to stop, 0 otherwise.
- *
- * Caller must disable bh.  This function can momentarily enable it.
- */
-static int rcu_cpu_kthread_should_stop(int cpu)
-{
-	while (cpu_is_offline(cpu) ||
-	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
-	       smp_processor_id() != cpu) {
-		if (kthread_should_stop())
-			return 1;
-		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
-		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
-		local_bh_enable();
-		schedule_timeout_uninterruptible(1);
-		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
-			set_cpus_allowed_ptr(current, cpumask_of(cpu));
-		local_bh_disable();
-	}
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	return 0;
-}
-
-/*
  * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
  * RCU softirq used in flavors and configurations of RCU that do not
  * support RCU priority boosting.
  */
-static int rcu_cpu_kthread(void *arg)
+static int rcu_cpu_kthread(void *cookie)
 {
-	int cpu = (int)(long)arg;
 	unsigned long flags;
+	struct sched_param sp;
 	int spincnt = 0;
-	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
+	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
 	char work;
-	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
+	char *workp = &__get_cpu_var(rcu_cpu_has_work);
 
-	trace_rcu_utilization("Start CPU kthread@init");
+	trace_rcu_utilization("Start CPU kthread@unpark");
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 	for (;;) {
 		*statusp = RCU_KTHREAD_WAITING;
 		trace_rcu_utilization("End CPU kthread@rcu_wait");
-		rcu_wait(*workp != 0 || kthread_should_stop());
+		rcu_wait(*workp != 0 ||
+			 smpboot_thread_check_parking(cookie));
 		trace_rcu_utilization("Start CPU kthread@rcu_wait");
 		local_bh_disable();
-		if (rcu_cpu_kthread_should_stop(cpu)) {
+		if (smpboot_thread_check_parking(cookie)) {
 			local_bh_enable();
 			break;
 		}
 		*statusp = RCU_KTHREAD_RUNNING;
-		per_cpu(rcu_cpu_kthread_loops, cpu)++;
+		this_cpu_inc(rcu_cpu_kthread_loops);
 		local_irq_save(flags);
 		work = *workp;
 		*workp = 0;
@@ -1624,59 +1554,14 @@ static int rcu_cpu_kthread(void *arg)
 		if (spincnt > 10) {
 			*statusp = RCU_KTHREAD_YIELDING;
 			trace_rcu_utilization("End CPU kthread@rcu_yield");
-			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
+			rcu_yield(rcu_cpu_kthread_timer,
+				  smp_processor_id());
 			trace_rcu_utilization("Start CPU kthread@rcu_yield");
 			spincnt = 0;
 		}
 	}
 	*statusp = RCU_KTHREAD_STOPPED;
-	trace_rcu_utilization("End CPU kthread@term");
-	return 0;
-}
-
-/*
- * Spawn a per-CPU kthread, setting up affinity and priority.
- * Because the CPU hotplug lock is held, no other CPU will be attempting
- * to manipulate rcu_cpu_kthread_task.  There might be another CPU
- * attempting to access it during boot, but the locking in kthread_bind()
- * will enforce sufficient ordering.
- *
- * Please note that we cannot simply refuse to wake up the per-CPU
- * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
- * which can result in softlockup complaints if the task ends up being
- * idle for more than a couple of minutes.
- *
- * However, please note also that we cannot bind the per-CPU kthread to its
- * CPU until that CPU is fully online.  We also cannot wait until the
- * CPU is fully online before we create its per-CPU kthread, as this would
- * deadlock the system when CPU notifiers tried waiting for grace
- * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
- * is online.  If its CPU is not yet fully online, then the code in
- * rcu_cpu_kthread() will wait until it is fully online, and then do
- * the binding.
- */
-static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
-{
-	struct sched_param sp;
-	struct task_struct *t;
-
-	if (!rcu_scheduler_fully_active ||
-	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
-		return 0;
-	t = kthread_create_on_node(rcu_cpu_kthread,
-				   (void *)(long)cpu,
-				   cpu_to_node(cpu),
-				   "rcuc/%d", cpu);
-	if (IS_ERR(t))
-		return PTR_ERR(t);
-	if (cpu_online(cpu))
-		kthread_bind(t, cpu);
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
+	trace_rcu_utilization("End CPU kthread@park");
 	return 0;
 }
 
@@ -1788,6 +1673,12 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
 }
 
+static struct smp_hotplug_thread rcu_cpu_thread_spec = {
+	.store = &rcu_cpu_kthread_task,
+	.thread_fn = rcu_cpu_kthread,
+	.thread_comm = "rcuc/%u",
+};
+
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
@@ -1797,11 +1688,9 @@ static int __init rcu_spawn_kthreads(void)
 	struct rcu_node *rnp;
 
 	rcu_scheduler_fully_active = 1;
-	for_each_possible_cpu(cpu) {
+	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
+	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu))
-			(void)rcu_spawn_one_cpu_kthread(cpu);
-	}
 	rnp = rcu_get_root(rcu_state);
 	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
 	if (NUM_RCU_NODES > 1) {
@@ -1818,11 +1707,9 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_scheduler_fully_active) {
-		(void)rcu_spawn_one_cpu_kthread(cpu);
-		if (rnp->node_kthread_task == NULL)
-			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	}
+	if (rcu_scheduler_fully_active &&
+	    rnp->node_kthread_task == NULL)
+		(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -1846,22 +1733,10 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void rcu_stop_cpu_kthread(int cpu)
-{
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
 }
 
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
-{
-}
-
 static int __init rcu_scheduler_really_started(void)
 {
 	rcu_scheduler_fully_active = 1;
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d4bc16d..6b4c76b 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -83,11 +83,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 			rdp->nxttail[RCU_WAIT_TAIL]],
 		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
 #ifdef CONFIG_RCU_BOOST
-	seq_printf(m, " kt=%d/%c/%d ktl=%x",
+	seq_printf(m, " kt=%d/%c ktl=%x",
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)),
-		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
 		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	seq_printf(m, " b=%ld", rdp->blimit);

