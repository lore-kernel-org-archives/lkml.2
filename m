Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0DTVpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:45:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42736 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0DTVpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:45:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/23] rcu: improve RCU CPU stall-warning messages
Date: Tue, 20 Apr 2010 14:44:46 -0700
Message-Id: <1271799895-21028-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100420214431.GA20777@linux.vnet.ibm.com>
References: <20100420214431.GA20777@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing RCU CPU stall-warning messages can be confusing, especially
in the case where one CPU detects a single other stalled CPU.  In addition,
the console messages did not say which flavor of RCU detected the stall,
which can make it difficult to work out exactly what is causing the stall.
This commit improves these messages.

Requested-by: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   20 +++++++++++---------
 kernel/rcutree.h |    1 +
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ec6196f..f391886 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -54,8 +54,8 @@
 
 static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 
-#define RCU_STATE_INITIALIZER(name) { \
-	.level = { &name.node[0] }, \
+#define RCU_STATE_INITIALIZER(structname) { \
+	.level = { &structname.node[0] }, \
 	.levelcnt = { \
 		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
 		NUM_RCU_LVL_1, \
@@ -66,13 +66,14 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
 	.orphan_cbs_list = NULL, \
-	.orphan_cbs_tail = &name.orphan_cbs_list, \
+	.orphan_cbs_tail = &structname.orphan_cbs_list, \
 	.orphan_qlen = 0, \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
+	.name = #structname, \
 }
 
 struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched_state);
@@ -483,7 +484,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	/* OK, time to rat on our buddy... */
 
-	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
+	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks: {",
+	       rsp->name);
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_print_task_stall(rnp);
@@ -494,7 +496,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 			if (rnp->qsmask & (1UL << cpu))
 				printk(" %d", rnp->grplo + cpu);
 	}
-	printk(" (detected by %d, t=%ld jiffies)\n",
+	printk("} (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	trigger_all_cpu_backtrace();
 
@@ -510,8 +512,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu jiffies)\n",
-			smp_processor_id(), jiffies - rsp->gp_start);
+	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
+	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
 	trigger_all_cpu_backtrace();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4a525a3..11f1711 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -326,6 +326,7 @@ struct rcu_state {
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+	char *name;				/* Name of structure. */
 };
 
 /* Return values for rcu_preempt_offline_tasks(). */
-- 
1.7.0

