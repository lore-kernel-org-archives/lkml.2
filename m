Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1EANWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53834 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab1EANWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:24 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/86] rcu: add grace-period age to tracing
Date: Sun,  1 May 2011 06:20:58 -0700
Message-Id: <1304256126-26015-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This commit adds the age in jiffies of the current grace period along
with the duration in jiffies of the longest grace period since boot
to the rcu/rcugp debugfs file.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   12 ++++++++++--
 kernel/rcutree.c            |   10 ++++++++++
 kernel/rcutree.h            |    7 +++++--
 kernel/rcutree_trace.c      |   37 +++++++++++++++++++++++++++++--------
 4 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 0346d3c..77f5bda 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -150,8 +150,8 @@ o	"qs" gives an indication of the state of the callback queue
 	the corresponding character is replaced by ".".
 
 o	"kt" is the per-CPU kernel-thread state.  The digit preceding
-	the slash is zero if there is no work pending and 1 otherwise.
-	The character after the slash is as follows:
+	the first slash is zero if there is no work pending and 1
+	otherwise.  The character between the slashes is as follows:
 
 	"S"	The kernel thread is stopped, in other words, all
 		CPUs corresponding to this rcu_node structure are
@@ -162,10 +162,18 @@ o	"kt" is the per-CPU kernel-thread state.  The digit preceding
 	"W"	The kernel thread is waiting because there is no work
 		for it to do.
 
+	"O"	The kernel thread is waiting because it has been
+		forced off of its designated CPU or because its
+		->cpus_allowed mask permits it to run on other than
+		its designated CPU.
+
 	"Y"	The kernel thread is yielding to avoid hogging CPU.
 
 	"?"	Unknown value, indicates a bug.
 
+	The number after the final slash is the CPU that the kthread
+	is actually running on.
+
 o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c1f5434..8cf0307 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -92,6 +92,7 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
 static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
@@ -888,6 +889,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
+	unsigned long gp_duration;
+
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 
 	/*
@@ -895,6 +898,9 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	 * is seen before the assignment to rsp->completed.
 	 */
 	smp_mb(); /* See above block comment. */
+	gp_duration = jiffies - rsp->gp_start;
+	if (gp_duration > rsp->gp_max)
+		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -1583,12 +1589,15 @@ static int rcu_cpu_kthread_should_stop(int cpu)
 	       smp_processor_id() != cpu) {
 		if (kthread_should_stop())
 			return 1;
+		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
+		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
 		local_bh_enable();
 		schedule_timeout_uninterruptible(1);
 		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
 			set_cpus_allowed_ptr(current, cpumask_of(cpu));
 		local_bh_disable();
 	}
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	return 0;
 }
 
@@ -1656,6 +1665,7 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	kthread_bind(t, cpu);
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
 	wake_up_process(t);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 67341db..37502a2 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -93,8 +93,9 @@ struct rcu_dynticks {
 #define RCU_KTHREAD_STOPPED  0
 #define RCU_KTHREAD_RUNNING  1
 #define RCU_KTHREAD_WAITING  2
-#define RCU_KTHREAD_YIELDING 3
-#define RCU_KTHREAD_MAX      3
+#define RCU_KTHREAD_OFFCPU   3
+#define RCU_KTHREAD_YIELDING 4
+#define RCU_KTHREAD_MAX      4
 
 /*
  * Definition for node within the RCU grace-period-detection hierarchy.
@@ -383,6 +384,8 @@ struct rcu_state {
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
+	unsigned long gp_max;			/* Maximum GP duration in */
+						/*  jiffies. */
 	char *name;				/* Name of structure. */
 };
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 3baa235..564b8fe 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -47,13 +47,14 @@
 #include "rcutree.h"
 
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
 DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
 static char convert_kthread_status(unsigned int kthread_status)
 {
 	if (kthread_status > RCU_KTHREAD_MAX)
 		return '?';
-	return "SRWY"[kthread_status];
+	return "SRWOY"[kthread_status];
 }
 
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
@@ -74,7 +75,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c b=%ld",
+	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c/%d b=%ld",
 		   rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -86,6 +87,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)),
+		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
 		   rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
@@ -312,16 +314,35 @@ static const struct file_operations rcuhier_fops = {
 	.release = single_release,
 };
 
+static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	unsigned long completed;
+	unsigned long gpnum;
+	unsigned long gpage;
+	unsigned long gpmax;
+	struct rcu_node *rnp = &rsp->node[0];
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	completed = rsp->completed;
+	gpnum = rsp->gpnum;
+	if (rsp->completed == rsp->gpnum)
+		gpage = 0;
+	else
+		gpage = jiffies - rsp->gp_start;
+	gpmax = rsp->gp_max;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	seq_printf(m, "%s: completed=%ld  gpnum=%lu  age=%ld  max=%ld\n",
+		   rsp->name, completed, gpnum, gpage, gpmax);
+}
+
 static int show_rcugp(struct seq_file *m, void *unused)
 {
 #ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%lu\n",
-		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
+	show_one_rcugp(m, &rcu_preempt_state);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%lu\n",
-		   rcu_sched_state.completed, rcu_sched_state.gpnum);
-	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%lu\n",
-		   rcu_bh_state.completed, rcu_bh_state.gpnum);
+	show_one_rcugp(m, &rcu_sched_state);
+	show_one_rcugp(m, &rcu_bh_state);
 	return 0;
 }
 
-- 
1.7.3.2

