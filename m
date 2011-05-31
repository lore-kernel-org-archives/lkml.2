Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1EaQ1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:27:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab1EaQ1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:27:36 -0400
Date: Tue, 31 May 2011 18:27:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fix
Message-ID: <20110531162726.GA15162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      rcu: Cure load woes


 kernel/rcutree.c        |   54 ++++++++++++++++++++++++++++++++++++++++-------
 kernel/rcutree_plugin.h |   11 ++++++++-
 2 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 77a7671..89419ff 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1648,7 +1648,6 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	kthread_bind(t, cpu);
-	set_task_state(t, TASK_INTERRUPTIBLE);
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
@@ -1756,7 +1755,6 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		if (IS_ERR(t))
 			return PTR_ERR(t);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		set_task_state(t, TASK_INTERRUPTIBLE);
 		rnp->node_kthread_task = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		sp.sched_priority = 99;
@@ -1765,6 +1763,8 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
 }
 
+static void rcu_wake_one_boost_kthread(struct rcu_node *rnp);
+
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
@@ -1772,18 +1772,30 @@ static int __init rcu_spawn_kthreads(void)
 {
 	int cpu;
 	struct rcu_node *rnp;
+	struct task_struct *t;
 
 	rcu_kthreads_spawnable = 1;
 	for_each_possible_cpu(cpu) {
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu))
+		if (cpu_online(cpu)) {
 			(void)rcu_spawn_one_cpu_kthread(cpu);
+			t = per_cpu(rcu_cpu_kthread_task, cpu);
+			if (t)
+				wake_up_process(t);
+		}
 	}
 	rnp = rcu_get_root(rcu_state);
 	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	if (rnp->node_kthread_task)
+		wake_up_process(rnp->node_kthread_task);
 	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state, rnp)
+		rcu_for_each_leaf_node(rcu_state, rnp) {
 			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+			t = rnp->node_kthread_task;
+			if (t)
+				wake_up_process(t);
+			rcu_wake_one_boost_kthread(rnp);
+		}
 	}
 	return 0;
 }
@@ -2188,14 +2200,14 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
-static void __cpuinit rcu_online_cpu(int cpu)
+static void __cpuinit rcu_prepare_cpu(int cpu)
 {
 	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
 	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
 	rcu_preempt_init_percpu_data(cpu);
 }
 
-static void __cpuinit rcu_online_kthreads(int cpu)
+static void __cpuinit rcu_prepare_kthreads(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
@@ -2209,6 +2221,31 @@ static void __cpuinit rcu_online_kthreads(int cpu)
 }
 
 /*
+ * kthread_create() creates threads in TASK_UNINTERRUPTIBLE state,
+ * but the RCU threads are woken on demand, and if demand is low this
+ * could be a while triggering the hung task watchdog.
+ *
+ * In order to avoid this, poke all tasks once the CPU is fully
+ * up and running.
+ */
+static void __cpuinit rcu_online_kthreads(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
+	struct task_struct *t;
+
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t)
+		wake_up_process(t);
+
+	t = rnp->node_kthread_task;
+	if (t)
+		wake_up_process(t);
+
+	rcu_wake_one_boost_kthread(rnp);
+}
+
+/*
  * Handle CPU online/offline notification events.
  */
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
@@ -2221,10 +2258,11 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		rcu_online_cpu(cpu);
-		rcu_online_kthreads(cpu);
+		rcu_prepare_cpu(cpu);
+		rcu_prepare_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
+		rcu_online_kthreads(cpu);
 	case CPU_DOWN_FAILED:
 		rcu_node_kthread_setaffinity(rnp, -1);
 		rcu_cpu_kthread_setrt(cpu, 1);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a767b7d..c8bff30 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1295,7 +1295,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	set_task_state(t, TASK_INTERRUPTIBLE);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
@@ -1303,6 +1302,12 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
+static void __cpuinit rcu_wake_one_boost_kthread(struct rcu_node *rnp)
+{
+	if (rnp->boost_kthread_task)
+		wake_up_process(rnp->boost_kthread_task);
+}
+
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
@@ -1326,6 +1331,10 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
+static void __cpuinit rcu_wake_one_boost_kthread(struct rcu_node *rnp)
+{
+}
+
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 #ifndef CONFIG_SMP
