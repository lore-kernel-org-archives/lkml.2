Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1KBUga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:36:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51235 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1KBUbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 11/28] rcu: Omit self-awaken when setting up expedited grace period
Date: Wed,  2 Nov 2011 13:30:32 -0700
Message-Id: <1320265849-5744-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-1976-0000-0000-000000ABACD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

When setting up an expedited grace period, if there were no readers, the
task will awaken itself.  This commit removes this useless self-awakening.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 +-
 kernel/rcutree.h        |    3 ++-
 kernel/rcutree_plugin.h |   17 +++++++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c097394..bbcafba 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1320,7 +1320,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	else
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
-		rcu_report_exp_rnp(rsp, rnp);
+		rcu_report_exp_rnp(rsp, rnp, true);
 	rcu_node_kthread_setaffinity(rnp, -1);
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 0963fa1..fd2f87d 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -444,7 +444,8 @@ static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
-static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
+			       bool wake);
 #endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 708dc57..7a7961f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -410,7 +410,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		 * then we need to report up the rcu_node hierarchy.
 		 */
 		if (!empty_exp && empty_exp_now)
-			rcu_report_exp_rnp(&rcu_preempt_state, rnp);
+			rcu_report_exp_rnp(&rcu_preempt_state, rnp, true);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -732,9 +732,13 @@ static int sync_rcu_preempt_exp_done(struct rcu_node *rnp)
  * recursively up the tree.  (Calm down, calm down, we do the recursion
  * iteratively!)
  *
+ * Most callers will set the "wake" flag, but the task initiating the
+ * expedited grace period need not wake itself.
+ *
  * Caller must hold sync_rcu_preempt_exp_mutex.
  */
-static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
+			       bool wake)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -747,7 +751,8 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		}
 		if (rnp->parent == NULL) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			wake_up(&sync_rcu_preempt_exp_wq);
+			if (wake)
+				wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
 		mask = rnp->grpmask;
@@ -780,7 +785,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 		must_wait = 1;
 	}
 	if (!must_wait)
-		rcu_report_exp_rnp(rsp, rnp);
+		rcu_report_exp_rnp(rsp, rnp, false); /* Don't wake self. */
 }
 
 /*
@@ -1072,9 +1077,9 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
  * report on tasks preempted in RCU read-side critical sections during
  * expedited RCU grace periods.
  */
-static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
+			       bool wake)
 {
-	return;
 }
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-- 
1.7.3.2

