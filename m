Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0C3KLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:11:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0C3KLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:11:50 -0400
Message-ID: <4BB1CE6B.6030207@cn.fujitsu.com>
Date: Tue, 30 Mar 2010 18:11:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: only raise softirq when need
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found something RCU_SOFTIRQ are called without do any thing.
(use function_graph to find it:
 1)               |  rcu_process_callbacks() {
 1)               |    __rcu_process_callbacks() {
 1)   0.634 us    |      rcu_process_gp_end();
 1)   0.487 us    |      check_for_new_grace_period();
 1)   2.672 us    |    }
 1)               |    __rcu_process_callbacks() {
 1)   0.633 us    |      rcu_process_gp_end();
 1)   0.491 us    |      check_for_new_grace_period();
 1)   2.672 us    |    }
)

This patch make RCU_SOFTIRQ raised when need.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1947c4e..06a1780 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -133,6 +133,7 @@ module_param(qlowmark, int, 0);
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
+static int rcu_qs_pending(int cpu);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -1125,8 +1126,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (!rcu_pending(cpu))
-		return; /* if nothing for RCU to do. */
+	if (!rcu_qs_pending(cpu))
+		goto check_rcu_softirq_work;
+
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1158,7 +1160,10 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_bh_qs(cpu);
 	}
 	rcu_preempt_check_callbacks(cpu);
-	raise_softirq(RCU_SOFTIRQ);
+
+check_rcu_softirq_work:
+	if (rcu_pending(cpu))
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 #ifdef CONFIG_SMP
@@ -1497,9 +1502,9 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
-	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending) {
-		rdp->n_rp_qs_pending++;
+	/* Does this RCU need to report quiescent state? */
+	if (rdp->qs_pending && rdp->passed_quiesc) {
+		rdp->n_rp_report_qs++;
 		return 1;
 	}
 
@@ -1551,6 +1556,24 @@ static int rcu_pending(int cpu)
 	       rcu_preempt_pending(cpu);
 }
 
+/* Is the RCU core waiting for a quiescent state from this CPU? */
+static int __rcu_qs_pending(struct rcu_data *rdp)
+{
+	if (rdp->qs_pending) {
+		rdp->n_rp_qs_pending++;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int rcu_qs_pending(int cpu)
+{
+	return __rcu_qs_pending(&per_cpu(rcu_sched_data, cpu)) ||
+	       __rcu_qs_pending(&per_cpu(rcu_bh_data, cpu)) ||
+	       rcu_preempt_qs_pending(cpu);
+}
+
 /*
  * Check to see if any future RCU-related work will need to be done
  * by the current CPU, even if none need be done immediately, returning
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4a525a3..c0f312e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -223,6 +223,7 @@ struct rcu_data {
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
 	unsigned long n_rp_qs_pending;
+	unsigned long n_rp_report_qs;
 	unsigned long n_rp_cb_ready;
 	unsigned long n_rp_cpu_needs_gp;
 	unsigned long n_rp_gp_completed;
@@ -378,6 +379,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
 #endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
+static int rcu_preempt_qs_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_orphanage(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 79b53bd..4befb64 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -689,6 +689,11 @@ static int rcu_preempt_pending(int cpu)
 			     &per_cpu(rcu_preempt_data, cpu));
 }
 
+static int rcu_preempt_qs_pending(int cpu)
+{
+	return __rcu_qs_pending(&per_cpu(rcu_preempt_data, cpu));
+}
+
 /*
  * Does preemptable RCU need the CPU to stay out of dynticks mode?
  */
@@ -914,6 +919,11 @@ static int rcu_preempt_pending(int cpu)
 	return 0;
 }
 
+static int rcu_preempt_qs_pending(int cpu)
+{
+	return 0;
+}
+
 /*
  * Because preemptable RCU does not exist, it never needs any CPU.
  */



