Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1FNEwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 00:52:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45853 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab1FNEwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 00:52:05 -0400
Date: Mon, 13 Jun 2011 21:51:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.0-rc3] tree RCU boost vs hang notifier...
Message-ID: <20110614045150.GA2264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTin2osfkSiu8maGmJAnzv4O5ODK0dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin2osfkSiu8maGmJAnzv4O5ODK0dw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 12:02:24PM +0800, Daniel J Blueman wrote:
> With 3.0-rc3 configured with CONFIG_TREE_PREEMPT_RCU, CONFIG_RCU_BOOST
> and CONFIG_DETECT_HUNG_TASK, we see frequent task hung reports [1],
> possibly as the tree RCU boost kthreads sleep uninterruptably.
> 
> It looks like tinyRCU sleeps interruptably, so won't trigger the hangcheck.
> 
> Thanks,
>   Daniel
> 
> --- [1]
> 
> INFO: task rcub0:9 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> rcub0           D ffffffff81c29c80  6768     9      2 0x00000000
>  ffff880221713ea0 0000000000000046 ffff880221713db0 ffffffff8171b825
>  ffff880221712000 0000000000004000 ffff8802214d0000 ffff88022170c060
>  ffff88022ec00000 0000000000010ac0 0000000000000001 ffff88022ec10ac0
> Call Trace:
>  [<ffffffff8171b825>] ? _raw_spin_unlock_irqrestore+0x75/0x80
>  [<ffffffff8171822a>] ? preempt_schedule+0x3a/0x50
>  [<ffffffff8171b825>] ? _raw_spin_unlock_irqrestore+0x75/0x80
>  [<ffffffff810cec90>] ? rcu_boost+0x120/0x120
>  [<ffffffff8107e1a3>] kthread+0x93/0xc0
>  [<ffffffff81098bad>] ? trace_hardirqs_on_caller+0x13d/0x180
>  [<ffffffff8171d4d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81048ad7>] ? finish_task_switch+0x77/0x100
>  [<ffffffff8171bc04>] ? retint_restore_args+0xe/0xe
>  [<ffffffff8107e110>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff8171d4d0>] ? gs_change+0xb/0xb
> no locks held by rcub0/9.

Hello, Daniel,

Does the following patch help?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Simplify curing of load woes

Make the functions creating the kthreads wake them up.  Leverage the
fact that the per-node and boost kthreads can run anywhere, thus
dispensing with the need to wake them up once the incoming CPU has
gone fully online.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 89419ff..0a8ec5b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1635,6 +1635,20 @@ static int rcu_cpu_kthread(void *arg)
  * to manipulate rcu_cpu_kthread_task.  There might be another CPU
  * attempting to access it during boot, but the locking in kthread_bind()
  * will enforce sufficient ordering.
+ *
+ * Please note that we cannot simply refuse to wake up the per-CPU
+ * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
+ * which can result in softlockup complaints if the task ends up being
+ * idle for more than a couple of minutes.
+ *
+ * However, please note also that we cannot bind the per-CPU kthread to its
+ * CPU until that CPU is fully online.  We also cannot wait until the
+ * CPU is fully online before we create its per-CPU kthread, as this would
+ * deadlock the system when CPU notifiers tried waiting for grace
+ * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
+ * is online.  If its CPU is not yet fully online, then the code in
+ * rcu_cpu_kthread() will wait until it is fully online, and then do
+ * the binding.
  */
 static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 {
@@ -1647,12 +1661,14 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
-	kthread_bind(t, cpu);
+	if (cpu_online(cpu))
+		kthread_bind(t, cpu);
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
-	per_cpu(rcu_cpu_kthread_task, cpu) = t;
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	per_cpu(rcu_cpu_kthread_task, cpu) = t;
+	wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
 }
 
@@ -1759,12 +1775,11 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		sp.sched_priority = 99;
 		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+		wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	}
 	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
 }
 
-static void rcu_wake_one_boost_kthread(struct rcu_node *rnp);
-
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
@@ -1772,30 +1787,18 @@ static int __init rcu_spawn_kthreads(void)
 {
 	int cpu;
 	struct rcu_node *rnp;
-	struct task_struct *t;
 
 	rcu_kthreads_spawnable = 1;
 	for_each_possible_cpu(cpu) {
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu)) {
+		if (cpu_online(cpu))
 			(void)rcu_spawn_one_cpu_kthread(cpu);
-			t = per_cpu(rcu_cpu_kthread_task, cpu);
-			if (t)
-				wake_up_process(t);
-		}
 	}
 	rnp = rcu_get_root(rcu_state);
 	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	if (rnp->node_kthread_task)
-		wake_up_process(rnp->node_kthread_task);
 	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state, rnp) {
+		rcu_for_each_leaf_node(rcu_state, rnp)
 			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-			t = rnp->node_kthread_task;
-			if (t)
-				wake_up_process(t);
-			rcu_wake_one_boost_kthread(rnp);
-		}
 	}
 	return 0;
 }
@@ -2221,31 +2224,6 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 }
 
 /*
- * kthread_create() creates threads in TASK_UNINTERRUPTIBLE state,
- * but the RCU threads are woken on demand, and if demand is low this
- * could be a while triggering the hung task watchdog.
- *
- * In order to avoid this, poke all tasks once the CPU is fully
- * up and running.
- */
-static void __cpuinit rcu_online_kthreads(int cpu)
-{
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
-	struct rcu_node *rnp = rdp->mynode;
-	struct task_struct *t;
-
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t)
-		wake_up_process(t);
-
-	t = rnp->node_kthread_task;
-	if (t)
-		wake_up_process(t);
-
-	rcu_wake_one_boost_kthread(rnp);
-}
-
-/*
  * Handle CPU online/offline notification events.
  */
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
@@ -2262,7 +2240,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_prepare_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
-		rcu_online_kthreads(cpu);
 	case CPU_DOWN_FAILED:
 		rcu_node_kthread_setaffinity(rnp, -1);
 		rcu_cpu_kthread_setrt(cpu, 1);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c8bff30..ea2e2fb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1299,15 +1299,10 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
 }
 
-static void __cpuinit rcu_wake_one_boost_kthread(struct rcu_node *rnp)
-{
-	if (rnp->boost_kthread_task)
-		wake_up_process(rnp->boost_kthread_task);
-}
-
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
@@ -1331,10 +1326,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-static void __cpuinit rcu_wake_one_boost_kthread(struct rcu_node *rnp)
-{
-}
-
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 #ifndef CONFIG_SMP
