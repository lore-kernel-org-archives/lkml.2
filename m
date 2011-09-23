Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1IWW0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:26:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13783 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1IWW0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:26:14 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [RFD 8/9] provide a version of cpuusage statistics inside cpu cgroup
Date: Fri, 23 Sep 2011 19:20:31 -0300
Message-Id: <1316816432-9237-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For users interested in using the information currently displayed
at cpuacct.usage and cpuaact.usage_per_cpu, we provide them inside
the cpu cgroup.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Balbir Singh <bsingharora@gmail.com>
---
 kernel/sched.c      |  220 +++++++++++++++++++++++++++++++++++----------------
 kernel/sched_fair.c |    2 +-
 kernel/sched_rt.c   |    2 +-
 3 files changed, 155 insertions(+), 69 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b687441..fc873c9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -280,6 +280,7 @@ struct task_group {
 #endif
 	unsigned long total_forks;
 	struct kernel_stat __percpu *cpustat;
+	u64 __percpu *cpuusage;
 	struct timespec start_time;
 };
 
@@ -2083,6 +2084,8 @@ static int irqtime_account_si_update(void)
 
 #endif
 
+static void cpuusage_charge(struct task_struct *tsk, u64 cputime);
+
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
@@ -8144,8 +8147,10 @@ void __init sched_init(void)
 
 	root_task_group.start_time = (struct timespec){0, 0};
 	root_task_group.cpustat = alloc_percpu(struct kernel_stat);
+	root_task_group.cpuusage = alloc_percpu(u64);
 	/* Failing that early an allocation means we're screwed anyway */
 	BUG_ON(!root_task_group.cpustat);
+	BUG_ON(!root_task_group.cpuusage);
 	for_each_possible_cpu(i) {
 		kstat = per_cpu_ptr(root_task_group.cpustat, i);
 		kstat->cpustat[IDLE] = 0;
@@ -8587,7 +8592,10 @@ static void free_sched_group(struct task_group *tg)
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
 	autogroup_free(tg);
-	free_percpu(tg->cpustat);
+	if (tg->cpustat)
+		free_percpu(tg->cpustat);
+	if (tg->cpuusage)
+		free_percpu(tg->cpuusage);
 	kfree(tg);
 }
 
@@ -8608,6 +8616,10 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	tg->cpuusage = alloc_percpu(u64);
+	if (!tg->cpuusage)
+		goto err;
+
 	tg->cpustat = alloc_percpu(struct kernel_stat);
 	if (!tg->cpustat)
 		goto err;
@@ -9296,6 +9308,87 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 
 
 
+static u64 cpuacct_cpuusage_read(u64 *cpuusage, int cpu)
+{
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpuacct_cpuusage_write(u64 *cpuusage, int cpu, u64 val)
+{
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
+static u64 cpu_cgroup_cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	u64 totalcpuusage = 0;
+	int i;
+
+	for_each_present_cpu(i) {
+		u64 *cpuusage = per_cpu_ptr(tg->cpuusage, i);
+		totalcpuusage += cpuacct_cpuusage_read(cpuusage, i);
+	}
+
+	return totalcpuusage;
+}
+
+static int cpu_cgroup_cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
+								u64 reset)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int err = 0;
+	int i;
+
+	if (reset) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_present_cpu(i) {
+		u64 *cpuusage = per_cpu_ptr(tg->cpuusage, i);
+		cpuacct_cpuusage_write(cpuusage, i, 0);
+	}
+
+out:
+	return err;
+}
+
+static int cpu_cgroup_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				      struct seq_file *m)
+{
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpu_cgroup_cpuusage_read(cgroup, cft);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
 static const char *cpuacct_stat_desc[] = {
 	[CPUACCT_STAT_USER] = "user",
 	[CPUACCT_STAT_SYSTEM] = "system",
@@ -9357,6 +9450,15 @@ static struct cftype cpu_files[] = {
 		.name = "stat",
 		.read_map = cpu_cgroup_stats_show,
 	},
+	{
+		.name = "usage",
+		.read_u64 = cpu_cgroup_cpuusage_read,
+		.write_u64 = cpu_cgroup_cpuusage_write,
+	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpu_cgroup_percpu_seq_read,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -9458,41 +9560,6 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	kfree(ca);
 }
 
-static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
-{
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-	u64 data;
-
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	data = *cpuusage;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	data = *cpuusage;
-#endif
-
-	return data;
-}
-
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
-{
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	*cpuusage = val;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	*cpuusage = val;
-#endif
-}
-
 /* return total cpu usage (in nanoseconds) of a group */
 static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 {
@@ -9500,8 +9567,10 @@ static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 	u64 totalcpuusage = 0;
 	int i;
 
-	for_each_present_cpu(i)
-		totalcpuusage += cpuacct_cpuusage_read(ca, i);
+	for_each_present_cpu(i) {
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+		totalcpuusage += cpuacct_cpuusage_read(cpuusage, i);
+	}
 
 	return totalcpuusage;
 }
@@ -9518,8 +9587,10 @@ static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
 		goto out;
 	}
 
-	for_each_present_cpu(i)
-		cpuacct_cpuusage_write(ca, i, 0);
+	for_each_present_cpu(i) {
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+		cpuacct_cpuusage_write(cpuusage, i, 0);
+	}
 
 out:
 	return err;
@@ -9576,33 +9647,6 @@ static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 }
 
 /*
- * charge this task's execution time to its accounting group.
- *
- * called with rq->lock held.
- */
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
-{
-	struct cpuacct *ca;
-	int cpu;
-
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	cpu = task_cpu(tsk);
-
-	rcu_read_lock();
-
-	ca = task_ca(tsk);
-
-	for (; ca; ca = ca->parent) {
-		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-		*cpuusage += cputime;
-	}
-
-	rcu_read_unlock();
-}
-
-/*
  * When CONFIG_VIRT_CPU_ACCOUNTING is enabled one jiffy can be very large
  * in cputime_t units. As a result, cpuacct_update_stats calls
  * percpu_counter_add with values large enough to always overflow the
@@ -9650,3 +9694,45 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
+/*
+ * charge this task's execution time to its accounting group.
+ *
+ * called with rq->lock held.
+ */
+static void cpuusage_charge(struct task_struct *tsk, u64 cputime)
+{
+	int cpu;
+
+#ifdef CONFIG_CGROUP_CPUACCT
+	struct cpuacct *ca;
+#endif
+#ifdef CONFIG_CGROUP_SCHED
+	struct task_group *tg;
+#endif
+	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
+
+#ifdef CONFIG_CGROUP_CPUACCT
+	ca = task_ca(tsk);
+
+	if (unlikely(!cpuacct_subsys.active))
+		goto no_cpuacct;
+
+	for (; ca; ca = ca->parent) {
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+		*cpuusage += cputime;
+	}
+no_cpuacct:
+#endif
+
+#ifdef CONFIG_CGROUP_SCHED
+	tg = task_group(tsk);
+	for (; tg; tg = tg->parent) {
+		u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+		*cpuusage += cputime;
+	}
+#endif
+	rcu_read_unlock();
+}
+
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..38b4549 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -580,7 +580,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
-		cpuacct_charge(curtask, delta_exec);
+		cpuusage_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..a21b58e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -676,7 +676,7 @@ static void update_curr_rt(struct rq *rq)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock_task;
-	cpuacct_charge(curr, delta_exec);
+	cpuusage_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
 
-- 
1.7.6

