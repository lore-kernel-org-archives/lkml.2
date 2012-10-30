Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab2J3QrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:47:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58354 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2J3QrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:47:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] rcu: Print remote CPU's stacks in stall warnings
Date: Tue, 30 Oct 2012 09:46:46 -0700
Message-Id: <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030164622.GA25108@linux.vnet.ibm.com>
References: <20121030164622.GA25108@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-2398-0000-0000-00000D0E6139
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00186995; UDB=6.00042359; UTC=2012-10-30
 16:47:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The RCU CPU stall warnings rely on trigger_all_cpu_backtrace() to
do NMI-based dump of the stack traces of all CPUs.  Unfortunately, a
number of architectures do not implement trigger_all_cpu_backtrace(), in
which case RCU falls back to just dumping the stack of the running CPU.
This is unhelpful in the case where the running CPU has detected that
some other CPU has stalled.

This commit therefore makes the running CPU dump the stacks of the
tasks running on the stalled CPUs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/sched.h |    2 ++
 kernel/rcutree.c      |   25 ++++++++++++++++++++++++-
 kernel/sched/core.c   |    6 ++++++
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..ba69b5a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -109,6 +109,8 @@ extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
+extern void dump_cpu_task(int cpu);
+
 struct seq_file;
 struct cfs_rq;
 struct task_group;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..e785387 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -873,6 +873,29 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
+/*
+ * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
+ * for architectures that do not implement trigger_all_cpu_backtrace().
+ * The NMI-triggered stack traces are more accurate because they are
+ * printed by the target CPU.
+ */
+static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
+{
+	int cpu;
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	rcu_for_each_leaf_node(rsp, rnp) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		if (rnp->qsmask != 0) {
+			for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
+				if (rnp->qsmask & (1UL << cpu))
+					dump_cpu_task(rnp->grplo + cpu);
+		}
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
 static void print_other_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -929,7 +952,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
-		dump_stack();
+		rcu_dump_cpu_stacks(rsp);
 
 	/* Complain about tasks blocking the grace period. */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..59d08fb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8076,3 +8076,9 @@ struct cgroup_subsys cpuacct_subsys = {
 	.base_cftypes = files,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+void dump_cpu_task(int cpu)
+{
+	pr_info("Task dump for CPU %d:\n", cpu);
+	sched_show_task(cpu_curr(cpu));
+}
-- 
1.7.8

