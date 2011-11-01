Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1KAVVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:21:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19961 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab1KAVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:21:07 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 10/14] Keep number of context switches per-cgroup
Date: Tue,  1 Nov 2011 19:19:16 -0200
Message-Id: <1320182360-20043-11-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ties the number of context_switches to a cgroup.
No impact is expected when per-cgroup stats collecting is disabled
in the root cgroup.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 include/linux/kernel_stat.h |    2 ++
 kernel/sched.c              |   24 ++++++++++++++++++------
 kernel/sched_debug.c        |    3 ++-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 77e91f6..2c32b24 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -30,6 +30,7 @@ enum cpu_usage_stat {
 	STEAL_BASE,
 	IDLE_BASE,
 	TOTAL_FORKS,
+	NR_SWITCHES,
 	NR_STATS,
 };
 
@@ -68,6 +69,7 @@ DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 
 extern unsigned long long nr_context_switches(void);
+extern unsigned long long nr_context_switches_cpu(int cpu);
 
 #ifndef CONFIG_GENERIC_HARDIRQS
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 800728e..4f91781 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -611,7 +611,6 @@ struct rq {
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
 	unsigned long nr_load_updates;
-	u64 nr_switches;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -3475,11 +3474,23 @@ unsigned long long nr_context_switches(void)
 	int i;
 	unsigned long long sum = 0;
 
-	for_each_possible_cpu(i)
-		sum += cpu_rq(i)->nr_switches;
+	for_each_possible_cpu(i) {
+		kstat_lock();
+		sum += per_cpu(kernel_cpustat, i).cpustat[NR_SWITCHES];
+		kstat_unlock();
+	}
 
 	return sum;
 }
+unsigned long long nr_context_switches_cpu(int cpu)
+{
+	unsigned long long ret;
+
+	kstat_lock();
+	ret = per_cpu(kernel_cpustat, cpu).cpustat[NR_SWITCHES];
+	kstat_unlock();
+	return ret;
+}
 
 unsigned long nr_iowait(void)
 {
@@ -4554,9 +4565,9 @@ need_resched:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
+		task_group_account_field(prev, 1, NR_SWITCHES);
 
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
@@ -9713,6 +9724,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 	unsigned long tg_iowait = 0;
+	u64 tg_nr_switches = 0;
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group *tg;
 	struct task_group *sib;
@@ -9754,8 +9766,8 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		guest += kcpustat->cpustat[GUEST];
 		guest_nice += kcpustat->cpustat[GUEST_NICE];
 		total_forks += kcpustat->cpustat[TOTAL_FORKS];
+		tg_nr_switches += kcpustat->cpustat[NR_SWITCHES];
 		tg_iowait += atomic_read(&kcpustat->nr_iowait);
-
 #ifdef CONFIG_CGROUP_SCHED
 		if (static_branch(&sched_cgroup_enabled)) {
 			list_for_each_entry(sib, &tg->siblings, siblings) {
@@ -9858,7 +9870,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		"processes %llu\n"
 		"procs_running %lu\n"
 		"procs_blocked %lu\n",
-		nr_context_switches(),
+		tg_nr_switches,
 		(unsigned long)jif,
 		total_forks,
 		nr_running(),
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index a6710a1..c7464601 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -246,6 +246,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
+	unsigned long long nr_switches = nr_context_switches_cpu(cpu);
 
 #ifdef CONFIG_X86
 	{
@@ -266,8 +267,8 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(nr_running);
 	SEQ_printf(m, "  .%-30s: %lu\n", "load",
 		   rq->load.weight);
-	P(nr_switches);
 	P(nr_load_updates);
+	SEQ_printf(m, "  .%-30s: %Ld\n","nr_switches", nr_switches);
 	P(nr_uninterruptible);
 	PN(next_balance);
 	P(curr->pid);
-- 
1.7.6.4

