Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0IQB5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:57:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0IQB5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:57:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=r/Laggk63phc1JrDu0TYdLkZSW/p4plLXPKt7FNTE5R9H7qqB00U4o592EAepgjn1
	aksNkDu2c5ST9WNn4CxCw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 4/6] sched: Do not account irq time to current task
Date: Thu, 16 Sep 2010 18:56:34 -0700
Message-Id: <1284688596-6731-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284688596-6731-1-git-send-email-venki@google.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both softirq and interrupt processing times get accounted to the currently
running task by the scheduler. This means if the interrupt processing was
for some other task in the system, then the current task pays the penalty
as it gets shorter runtime than otherwise.

Change this to 'unaccount' irq processing times from currently running task.
We do this is class update_curr() function, modifying the delta_exec.

Note that this change only handler CONFIG_IRQ_TIME_ACCOUNTING case. We can
extend this to CONFIG_VIRT_CPU_ACCOUNTING with minimal effort. But, thats
for later.

This change will impact scheduling behavior in interrupt heavy conditions.

Tested on a 4-way system with eth0 handled by CPU 2 and a network heavy
task (nc) running on CPU 3 (and no RSS/RFS). With that I have CPU 2
spending 75%+ of its time in irq processing. CPU 3 spending around 35%
time running this task. Now, if I run another CPU intensive task on CPU 2,
without this change /proc/<pid>/schedstat for the CPU intensive task shows
100% of time accounted to this task. With this change, it shows less than 25%
accounted to this task.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c      |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_fair.c |    6 +++-
 kernel/sched_rt.c   |   16 +++++++--
 3 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 912d2de..f36697b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -370,6 +370,10 @@ struct cfs_rq {
 	unsigned long rq_weight;
 #endif
 #endif
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 saved_irq_time;
+#endif
+
 };
 
 /* Real-Time classes' related field in a runqueue: */
@@ -403,6 +407,10 @@ struct rt_rq {
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
 #endif
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 saved_irq_time;
+#endif
+
 };
 
 #ifdef CONFIG_SMP
@@ -532,6 +540,10 @@ struct rq {
 	struct hrtimer hrtick_timer;
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 total_irq_time;
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 	/* latency stats */
 	struct sched_info rq_sched_info;
@@ -643,10 +655,14 @@ static inline struct task_group *task_group(struct task_struct *p)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
+static void save_rq_irq_time(int cpu, struct rq *rq);
+
 inline void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update)
+	if (!rq->skip_clock_update) {
 		rq->clock = sched_clock_cpu(cpu_of(rq));
+		save_rq_irq_time(cpu_of(rq), rq);
+	}
 }
 
 /*
@@ -1919,6 +1935,17 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
+/*
+ * There are no locks covering percpu hardirq/softirq time.
+ * They are only modified in account_system_vtime, on corresponding CPU
+ * with interrupts disabled. So, writes are safe.
+ * They are read and saved off onto rq->total_irq_time in update_rq_clock().
+ * This may result in other CPU reading this CPU's irq time and can
+ * race with irq/account_system_vtime on this CPU. We would either get old
+ * or new value with a side effect of accounting a slice of irq time to wrong
+ * task when irq is in progress while we read rq->clock. That is a worthy
+ * compromise in place of having locks on each irq in account_system_time.
+ */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
 
@@ -1930,6 +1957,13 @@ void enable_sched_clock_irqtime(void)
        sched_clock_irqtime = 1;
 }
 
+static void save_rq_irq_time(int cpu, struct rq *rq)
+{
+	if (sched_clock_irqtime)
+		rq->total_irq_time = per_cpu(cpu_softirq_time, cpu) +
+					per_cpu(cpu_hardirq_time, cpu);
+}
+
 void account_system_vtime(struct task_struct *tsk)
 {
 	unsigned long flags;
@@ -1953,6 +1987,61 @@ void account_system_vtime(struct task_struct *tsk)
 	local_irq_restore(flags);
 }
 
+/*
+ * saved_irq_time in cfs_rq, rt_rq caches the accounted irqtime and
+ * it is updated from update_curr while doing entity accouting and
+ * in update_irq_time while the task is first scheduled in.
+ */
+static void __update_irq_time(int cpu, u64 *saved_irq_time)
+{
+	if (sched_clock_irqtime)
+		*saved_irq_time = cpu_rq(cpu)->total_irq_time;
+}
+
+#define update_irq_time(cpu, crq) __update_irq_time(cpu, &(crq)->saved_irq_time)
+
+static u64 unaccount_irq_delta(u64 delta, int cpu, u64 *saved_irq_time)
+{
+	u64 curr_irq_time;
+
+	if (!sched_clock_irqtime)
+		return delta;
+
+	curr_irq_time = cpu_rq(cpu)->total_irq_time - *saved_irq_time;
+	*saved_irq_time = cpu_rq(cpu)->total_irq_time;
+
+	if (likely(delta > curr_irq_time))
+		delta -= curr_irq_time;
+	else
+		delta = 0;
+
+	return delta;
+}
+
+#define unaccount_irq_delta_fair(delta, cpu, class_rq)		 \
+		(unsigned long)unaccount_irq_delta((u64)delta,	 \
+					cpu, &(class_rq)->saved_irq_time)
+
+#define unaccount_irq_delta_rt(delta, cpu, class_rq)		 \
+		unaccount_irq_delta(delta, cpu, &(class_rq)->saved_irq_time)
+
+#else
+
+#define update_irq_time(cpu, crq)		do { } while (0)
+
+static void save_rq_irq_time(int cpu, struct rq *rq) { }
+
+static unsigned long unaccount_irq_delta_fair(unsigned long delta_exec,
+		int cpu, struct cfs_rq *cfs_rq)
+{
+	return delta_exec;
+}
+
+static u64 unaccount_irq_delta_rt(u64 delta_exec, int cpu, struct rt_rq *rt_rq)
+{
+	return delta_exec;
+}
+
 #endif
 
 #include "sched_idletask.c"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a171138..a64fdaf 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -521,6 +521,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	struct sched_entity *curr = cfs_rq->curr;
 	u64 now = rq_of(cfs_rq)->clock;
 	unsigned long delta_exec;
+	int cpu = cpu_of(rq_of(cfs_rq));
 
 	if (unlikely(!curr))
 		return;
@@ -531,11 +532,13 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	 * overflow on 32 bits):
 	 */
 	delta_exec = (unsigned long)(now - curr->exec_start);
+	curr->exec_start = now;
+	delta_exec = unaccount_irq_delta_fair(delta_exec, cpu, cfs_rq);
+
 	if (!delta_exec)
 		return;
 
 	__update_curr(cfs_rq, curr, delta_exec);
-	curr->exec_start = now;
 
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
@@ -603,6 +606,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 * We are starting a new run period:
 	 */
 	se->exec_start = rq_of(cfs_rq)->clock;
+	update_irq_time(cpu_of(rq_of(cfs_rq)), cfs_rq);
 }
 
 /**************************************************
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d10c80e..000d402 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -605,6 +605,7 @@ static void update_curr_rt(struct rq *rq)
 	struct sched_rt_entity *rt_se = &curr->rt;
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
+	int cpu = cpu_of(rq);
 
 	if (!task_has_rt_policy(curr))
 		return;
@@ -613,6 +614,14 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
+	/*
+	 * rt_avg_update before removing irq_delta, to keep up with
+	 * current behavior.
+	 */
+	sched_rt_avg_update(rq, delta_exec);
+
+	delta_exec = unaccount_irq_delta_rt(delta_exec, cpu, rt_rq);
+
 	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
@@ -621,8 +630,6 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
-	sched_rt_avg_update(rq, delta_exec);
-
 	if (!rt_bandwidth_enabled())
 		return;
 
@@ -1057,9 +1064,10 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
-	struct rt_rq *rt_rq;
+	struct rt_rq *rt_rq, *tmp_rt_rq;
 
 	rt_rq = &rq->rt;
+	tmp_rt_rq = rt_rq;
 
 	if (unlikely(!rt_rq->rt_nr_running))
 		return NULL;
@@ -1075,6 +1083,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 
 	p = rt_task_of(rt_se);
 	p->se.exec_start = rq->clock;
+	update_irq_time(cpu_of(rq), tmp_rt_rq);
 
 	return p;
 }
@@ -1710,6 +1719,7 @@ static void set_curr_task_rt(struct rq *rq)
 	struct task_struct *p = rq->curr;
 
 	p->se.exec_start = rq->clock;
+	update_irq_time(cpu_of(rq), &rq->rt);
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
-- 
1.7.1

