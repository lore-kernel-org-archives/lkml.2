Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1IGG3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:29:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38148 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1IGGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 39/55] rcu: Suppress NMI backtraces when stall ends before dump
Date: Tue,  6 Sep 2011 11:00:33 -0700
Message-Id: <1315332049-2604-39-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for an RCU CPU stall to end just as it is detected, in
which case the current code will uselessly dump all CPU's stacks.
This commit therefore checks for this condition and refrains from
sending needless NMIs.

And yes, the stall might also end just after we checked all CPUs and
tasks, but in that case we would at least have given some clue as
to which CPU/task was at fault.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   13 +++++++++----
 kernel/rcutree.h        |    2 +-
 kernel/rcutree_plugin.h |   13 +++++++++----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9970116..ade7883 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -545,6 +545,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	int cpu;
 	long delta;
 	unsigned long flags;
+	int ndetected;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Only let one CPU complain about others per time interval. */
@@ -561,7 +562,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * Now rat on any tasks that got kicked up to the root rcu_node
 	 * due to CPU offlining.
 	 */
-	rcu_print_task_stall(rnp);
+	ndetected = rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -573,17 +574,21 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       rsp->name);
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rcu_print_task_stall(rnp);
+		ndetected += rcu_print_task_stall(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		if (rnp->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
-			if (rnp->qsmask & (1UL << cpu))
+			if (rnp->qsmask & (1UL << cpu)) {
 				printk(" %d", rnp->grplo + cpu);
+				ndetected++;
+			}
 	}
 	printk("} (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
-	if (!trigger_all_cpu_backtrace())
+	if (ndetected == 0)
+		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
+	else if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
 	/* If so configured, complain about tasks blocking the grace period. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 51638b6..f509f72 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -438,7 +438,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 static void rcu_stop_cpu_kthread(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
-static void rcu_print_task_stall(struct rcu_node *rnp);
+static int rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_stall_reset(void);
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index eeb38ee..d3127e8 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -483,16 +483,20 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  * Scan the current list of tasks blocked within RCU read-side critical
  * sections, printing out the tid of each.
  */
-static void rcu_print_task_stall(struct rcu_node *rnp)
+static int rcu_print_task_stall(struct rcu_node *rnp)
 {
 	struct task_struct *t;
+	int ndetected = 0;
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
-		return;
+		return 0;
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
-	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
 		printk(" P%d", t->pid);
+		ndetected++;
+	}
+	return ndetected;
 }
 
 /*
@@ -976,8 +980,9 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
-static void rcu_print_task_stall(struct rcu_node *rnp)
+static int rcu_print_task_stall(struct rcu_node *rnp)
 {
+	return 0;
 }
 
 /*
-- 
1.7.3.2

