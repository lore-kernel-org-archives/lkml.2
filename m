Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0JEAEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:04:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0JEAEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S+sCc6zWDCZxt6PQdlecqf3zmTDcUb5uaD9rjDfyJvEkEIpv88vsgBOyFm+dTJza1J
         gBAOksTdlCIdYBknapTw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 6/8] sched: Do not account irq time to current task -v4
Date: Mon,  4 Oct 2010 17:03:21 -0700
Message-Id: <1286237003-12406-7-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduler accounts both softirq and interrupt processing times to the
currently running task. This means, if the interrupt processing was
for some other task in the system, then the current task ends up being
penalized as it gets shorter runtime than otherwise.

Change sched task accounting to acoount only actual task time from
currently running task. Now update_curr(), modifies the delta_exec to
depend on rq->clock_task.

Note that this change only handles CONFIG_IRQ_TIME_ACCOUNTING case. We can
extend this to CONFIG_VIRT_CPU_ACCOUNTING with minimal effort. But, thats
for later.

This change will impact scheduling behavior in interrupt heavy conditions.

Tested on a 4-way system with eth0 handled by CPU 2 and a network heavy
task (nc) running on CPU 3 (and no RSS/RFS). With that I have CPU 2
spending 75%+ of its time in irq processing. CPU 3 spending around 35%
time running nc task.
Now, if I run another CPU intensive task on CPU 2, without this change
/proc/<pid>/schedstat shows 100% of time accounted to this task. With this
change, it rightly shows less than 25% accounted to this task as remaining
time is actually spent on irq processing.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c      |   43 ++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c |    6 +++---
 kernel/sched_rt.c   |    8 ++++----
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4d8bbed..12e9d70 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -493,6 +493,7 @@ struct rq {
 	struct mm_struct *prev_mm;
 
 	u64 clock;
+	u64 clock_task;
 
 	atomic_t nr_iowait;
 
@@ -643,10 +644,19 @@ static inline struct task_group *task_group(struct task_struct *p)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
+static u64 irq_time_cpu(int cpu);
+
 inline void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update)
-		rq->clock = sched_clock_cpu(cpu_of(rq));
+	if (!rq->skip_clock_update) {
+		int cpu = cpu_of(rq);
+		u64 irq_time;
+
+		rq->clock = sched_clock_cpu(cpu);
+		irq_time = irq_time_cpu(cpu);
+		if (rq->clock - irq_time > rq->clock_task)
+			rq->clock_task = rq->clock - irq_time;
+	}
 }
 
 /*
@@ -1919,6 +1929,18 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
+/*
+ * There are no locks covering percpu hardirq/softirq time.
+ * They are only modified in account_system_vtime, on corresponding CPU
+ * with interrupts disabled. So, writes are safe.
+ * They are read and saved off onto struct rq in update_rq_clock().
+ * This may result in other CPU reading this CPU's irq time and can
+ * race with irq/account_system_vtime on this CPU. We would either get old
+ * or new value (or semi updated value on 32 bit) with a side effect of
+ * accounting a slice of irq time to wrong task when irq is in progress
+ * while we read rq->clock. That is a worthy compromise in place of having
+ * locks on each irq in account_system_time.
+ */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
 
@@ -1935,6 +1957,14 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
+static u64 irq_time_cpu(int cpu)
+{
+	if (!sched_clock_irqtime)
+		return 0;
+
+	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
+}
+
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
@@ -1964,6 +1994,13 @@ void account_system_vtime(struct task_struct *curr)
 	local_irq_restore(flags);
 }
 
+#else
+
+static u64 irq_time_cpu(int cpu)
+{
+	return 0;
+}
+
 #endif
 
 #include "sched_idletask.c"
@@ -3297,7 +3334,7 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns = rq->clock - p->se.exec_start;
+		ns = rq->clock_task - p->se.exec_start;
 		if ((s64)ns < 0)
 			ns = 0;
 	}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index db3f674..0baa696 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -519,7 +519,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	u64 now = rq_of(cfs_rq)->clock_task;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -602,7 +602,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	/*
 	 * We are starting a new run period:
 	 */
-	se->exec_start = rq_of(cfs_rq)->clock;
+	se->exec_start = rq_of(cfs_rq)->clock_task;
 }
 
 /**************************************************
@@ -1798,7 +1798,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, rq->clock, sd);
+	tsk_cache_hot = task_hot(p, rq->clock_task, sd);
 	if (!tsk_cache_hot ||
 		sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d10c80e..bb4027a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -609,7 +609,7 @@ static void update_curr_rt(struct rq *rq)
 	if (!task_has_rt_policy(curr))
 		return;
 
-	delta_exec = rq->clock - curr->se.exec_start;
+	delta_exec = rq->clock_task - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
@@ -618,7 +618,7 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock;
+	curr->se.exec_start = rq->clock_task;
 	cpuacct_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
@@ -1074,7 +1074,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	} while (rt_rq);
 
 	p = rt_task_of(rt_se);
-	p->se.exec_start = rq->clock;
+	p->se.exec_start = rq->clock_task;
 
 	return p;
 }
@@ -1709,7 +1709,7 @@ static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p = rq->curr;
 
-	p->se.exec_start = rq->clock;
+	p->se.exec_start = rq->clock_task;
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
-- 
1.7.1

