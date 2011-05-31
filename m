Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1EaMbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:31:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:41635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1EaMbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:31:35 -0400
Date: Tue, 31 May 2011 12:30:52 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-d72bce0e67e8afc6eb959f656013cbb577426f1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paul.mckenney@linaro.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        damien.wyart@free.fr, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paul.mckenney@linaro.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        damien.wyart@free.fr, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306755291.1200.2872.camel@twins>
References: <1306755291.1200.2872.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Cure load woes
Git-Commit-ID: d72bce0e67e8afc6eb959f656013cbb577426f1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 May 2011 12:30:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d72bce0e67e8afc6eb959f656013cbb577426f1e
Gitweb:     http://git.kernel.org/tip/d72bce0e67e8afc6eb959f656013cbb577426f1e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 30 May 2011 13:34:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 May 2011 10:01:48 +0200

rcu: Cure load woes

Commit cc3ce5176d83 (rcu: Start RCU kthreads in TASK_INTERRUPTIBLE
state) fudges a sleeping task' state, resulting in the scheduler seeing
a TASK_UNINTERRUPTIBLE task going to sleep, but a TASK_INTERRUPTIBLE
task waking up. The result is unbalanced load calculation.

The problem that patch tried to address is that the RCU threads could
stay in UNINTERRUPTIBLE state for quite a while and triggering the hung
task detector due to on-demand wake-ups.

Cure the problem differently by always giving the tasks at least one
wake-up once the CPU is fully up and running, this will kick them out of
the initial UNINTERRUPTIBLE state and into the regular INTERRUPTIBLE
wait state.

[ The alternative would be teaching kthread_create() to start threads as
  INTERRUPTIBLE but that needs a tad more thought. ]

Reported-by: Damien Wyart <damien.wyart@free.fr>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul E. McKenney <paul.mckenney@linaro.org>
Link: http://lkml.kernel.org/r/1306755291.1200.2872.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
