Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1FHTa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48317 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab1FHTaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/28] rcu: Simplify curing of load woes
Date: Wed,  8 Jun 2011 12:29:40 -0700
Message-Id: <1307561407-13809-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the functions creating the kthreads wake them up.  Leverage the
fact that the per-node and boost kthreads can run anywhere, thus
dispensing with the need to wake them up once the incoming CPU has
gone fully online.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   65 +++++++++++++++-------------------------------
 kernel/rcutree_plugin.h |   11 +-------
 2 files changed, 22 insertions(+), 54 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4cc6a94..36e79d2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1634,6 +1634,20 @@ static int rcu_cpu_kthread(void *arg)
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
@@ -1646,12 +1660,14 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
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
 
@@ -1758,12 +1774,11 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
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
@@ -1771,30 +1786,18 @@ static int __init rcu_spawn_kthreads(void)
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
@@ -2220,31 +2223,6 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
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
@@ -2261,7 +2239,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
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
-- 
1.7.3.2

