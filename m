Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab1EANXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:23:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48599 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab1EANW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/86] rcu: add tracing for RCU's kthread run states.
Date: Sun,  1 May 2011 06:20:55 -0700
Message-Id: <1304256126-26015-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Add tracing to help debugging situations when RCU's kthreads are not
running but are supposed to be.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   11 ++++++++++-
 kernel/rcutree.h        |   11 +++++++++++
 kernel/rcutree_plugin.h |    3 +++
 kernel/rcutree_trace.c  |   23 ++++++++++++++++++++---
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index eca6f05..a591694 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -91,8 +91,9 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  * handle all flavors of RCU.
  */
 static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
-static DEFINE_PER_CPU(char, rcu_cpu_has_work);
+DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
 static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
@@ -1563,11 +1564,13 @@ static int rcu_cpu_kthread(void *arg)
 	int cpu = (int)(long)arg;
 	unsigned long flags;
 	int spincnt = 0;
+	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
 	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
 	char work;
 	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
 
 	for (;;) {
+		*statusp = RCU_KTHREAD_WAITING;
 		wait_event_interruptible(*wqp,
 					 *workp != 0 || kthread_should_stop());
 		local_bh_disable();
@@ -1575,6 +1578,7 @@ static int rcu_cpu_kthread(void *arg)
 			local_bh_enable();
 			break;
 		}
+		*statusp = RCU_KTHREAD_RUNNING;
 		local_irq_save(flags);
 		work = *workp;
 		*workp = 0;
@@ -1587,10 +1591,12 @@ static int rcu_cpu_kthread(void *arg)
 		else
 			spincnt = 0;
 		if (spincnt > 10) {
+			*statusp = RCU_KTHREAD_YIELDING;
 			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
 			spincnt = 0;
 		}
 	}
+	*statusp = RCU_KTHREAD_STOPPED;
 	return 0;
 }
 
@@ -1637,10 +1643,12 @@ static int rcu_node_kthread(void *arg)
 	struct task_struct *t;
 
 	for (;;) {
+		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
 		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
 						       kthread_should_stop());
 		if (kthread_should_stop())
 			break;
+		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = rnp->wakemask;
 		rnp->wakemask = 0;
@@ -1661,6 +1669,7 @@ static int rcu_node_kthread(void *arg)
 			preempt_enable();
 		}
 	}
+	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
 	return 0;
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d49046c..67341db 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -89,6 +89,13 @@ struct rcu_dynticks {
 	atomic_t dynticks;	/* Even value for dynticks-idle, else odd. */
 };
 
+/* RCU's kthread states for tracing. */
+#define RCU_KTHREAD_STOPPED  0
+#define RCU_KTHREAD_RUNNING  1
+#define RCU_KTHREAD_WAITING  2
+#define RCU_KTHREAD_YIELDING 3
+#define RCU_KTHREAD_MAX      3
+
 /*
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
@@ -152,6 +159,8 @@ struct rcu_node {
 	wait_queue_head_t boost_wq;
 				/* Wait queue on which to park the boost */
 				/*  kthread. */
+	unsigned int boost_kthread_status;
+				/* State of boost_kthread_task for tracing. */
 	unsigned long n_tasks_boosted;
 				/* Total number of tasks boosted. */
 	unsigned long n_exp_boosts;
@@ -179,6 +188,8 @@ struct rcu_node {
 	wait_queue_head_t node_wq;
 				/* Wait queue on which to park the per-node */
 				/*  kthread. */
+	unsigned int node_kthread_status;
+				/* State of node_kthread_task for tracing. */
 } ____cacheline_internodealigned_in_smp;
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 07d3464..22a6a46 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1198,11 +1198,13 @@ static int rcu_boost_kthread(void *arg)
 	int more2boost;
 
 	for (;;) {
+		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
 		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
 							rnp->exp_tasks ||
 							kthread_should_stop());
 		if (kthread_should_stop())
 			break;
+		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
 			spincnt++;
@@ -1213,6 +1215,7 @@ static int rcu_boost_kthread(void *arg)
 			spincnt = 0;
 		}
 	}
+	rnp->boost_kthread_status = RCU_KTHREAD_STOPPED;
 	return 0;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index afd262f..fc40e89 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,16 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DECLARE_PER_CPU(char, rcu_cpu_has_work);
+
+static char convert_kthread_status(unsigned int kthread_status)
+{
+	if (kthread_status > RCU_KTHREAD_MAX)
+		return '?';
+	return "SRWY"[kthread_status];
+}
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -64,7 +74,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c b=%ld",
+	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c b=%ld",
 		   rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -73,6 +83,9 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
 			rdp->nxttail[RCU_WAIT_TAIL]],
 		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   per_cpu(rcu_cpu_has_work, rdp->cpu),
+		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
+					  rdp->cpu)),
 		   rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
@@ -130,7 +143,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,\"%c%c%c%c\",%ld", rdp->qlen,
+	seq_printf(m, ",%ld,\"%c%c%c%c\",%d,\"%c\",%ld", rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
@@ -138,6 +151,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
 			rdp->nxttail[RCU_WAIT_TAIL]],
 		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   per_cpu(rcu_cpu_has_work, rdp->cpu),
+		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
+					  rdp->cpu)),
 		   rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
@@ -178,13 +194,14 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
 {
-	seq_printf(m,  "%d:%d tasks=%c%c%c%c ntb=%lu neb=%lu nnb=%lu "
+	seq_printf(m,  "%d:%d tasks=%c%c%c%c kt=%c ntb=%lu neb=%lu nnb=%lu "
 		   "j=%04x bt=%04x\n",
 		   rnp->grplo, rnp->grphi,
 		   "T."[list_empty(&rnp->blkd_tasks)],
 		   "N."[!rnp->gp_tasks],
 		   "E."[!rnp->exp_tasks],
 		   "B."[!rnp->boost_tasks],
+		   convert_kthread_status(rnp->boost_kthread_status),
 		   rnp->n_tasks_boosted, rnp->n_exp_boosts,
 		   rnp->n_normal_boosts,
 		   (int)(jiffies & 0xffff),
-- 
1.7.3.2

