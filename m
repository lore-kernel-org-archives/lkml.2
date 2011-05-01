Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1EANfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:35:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48486 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/86] rcu: Force per-rcu_node kthreads off of the outgoing CPU
Date: Sun,  1 May 2011 06:20:47 -0700
Message-Id: <1304256126-26015-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The scheduler has had some heartburn in the past when too many real-time
kthreads were affinitied to the outgoing CPU.  So, this commit lightens
the load by forcing the per-rcu_node and the boost kthreads off of the
outgoing CPU.  Note that RCU's per-CPU kthread remains on the outgoing
CPU until the bitter end, as it must in order to preserve correctness.

Also avoid disabling hardirqs across calls to set_cpus_allowed_ptr(),
given that this function can block.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   24 +++++++++++++++++++-----
 kernel/rcutree_plugin.h |    8 +++++---
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1ce51b8..85b06c5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -95,7 +95,7 @@ static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
 static DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp);
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_cpu_kthread(void);
 
 #define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
@@ -1099,7 +1099,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		kthread_stop(t);
 		rcu_stop_boost_kthread(rnp);
 	} else
-		rcu_node_kthread_setaffinity(rnp);
+		rcu_node_kthread_setaffinity(rnp, -1);
 }
 
 /*
@@ -1644,8 +1644,12 @@ static int rcu_node_kthread(void *arg)
  * Set the per-rcu_node kthread's affinity to cover all CPUs that are
  * served by the rcu_node in question.  The CPU hotplug lock is still
  * held, so the value of rnp->qsmaskinit will be stable.
+ *
+ * We don't include outgoingcpu in the affinity set, use -1 if there is
+ * no outgoing CPU.  If there are no CPUs left in the affinity set,
+ * this function allows the kthread to execute on any CPU.
  */
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
 	cpumask_var_t cm;
 	int cpu;
@@ -1657,8 +1661,14 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
 		return;
 	cpumask_clear(cm);
 	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
-		if (mask & 0x1)
+		if ((mask & 0x1) && cpu != outgoingcpu)
 			cpumask_set_cpu(cpu, cm);
+	if (cpumask_weight(cm) == 0) {
+		cpumask_setall(cm);
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
+			cpumask_clear_cpu(cpu, cm);
+		WARN_ON_ONCE(cpumask_weight(cm) == 0);
+	}
 	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
 	rcu_boost_kthread_setaffinity(rnp, cm);
 	free_cpumask_var(cm);
@@ -2154,7 +2164,11 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_online_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
-		rcu_node_kthread_setaffinity(rnp);
+	case CPU_DOWN_FAILED:
+		rcu_node_kthread_setaffinity(rnp, -1);
+		break;
+	case CPU_DOWN_PREPARE:
+		rcu_node_kthread_setaffinity(rnp, cpu);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5964f82..4e48625 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1212,17 +1212,19 @@ static void rcu_initiate_boost(struct rcu_node *rnp)
 	}
 }
 
+/*
+ * Set the affinity of the boost kthread.  The CPU-hotplug locks are
+ * held, so no one should be messing with the existence of the boost
+ * kthread.
+ */
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm)
 {
-	unsigned long flags;
 	struct task_struct *t;
 
-	raw_spin_lock_irqsave(&rnp->lock, flags);
 	t = rnp->boost_kthread_task;
 	if (t != NULL)
 		set_cpus_allowed_ptr(rnp->boost_kthread_task, cm);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
-- 
1.7.3.2

