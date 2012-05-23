Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab2EWVo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:44:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51227 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933932Ab2EWVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:54 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [PATCH 09/15] sched: add schedstats for -deadline tasks.
Date: Wed, 23 May 2012 23:42:49 +0200
Message-Id: <1337809375-24295-10-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Add some typical sched-debug output to dl_rq(s) and some
schedstats to -deadline tasks.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h |   13 +++++++++++++
 kernel/sched/debug.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/dl.c     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h  |    9 ++++++++-
 4 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dc5b753..3599db7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1254,6 +1254,15 @@ struct sched_rt_entity {
 #endif
 };
 
+#ifdef CONFIG_SCHEDSTATS
+struct sched_stats_dl {
+	u64			last_dmiss;
+	u64			last_rorun;
+	u64			dmiss_max;
+	u64			rorun_max;
+};
+#endif
+
 struct sched_dl_entity {
 	struct rb_node	rb_node;
 	int nr_cpus_allowed;
@@ -1294,6 +1303,10 @@ struct sched_dl_entity {
 	 * own bandwidth to be enforced, thus we need one timer per task.
 	 */
 	struct hrtimer dl_timer;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_stats_dl stats;
+#endif
 };
 
 /*
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..df20c81 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -242,6 +242,45 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 #undef P
 }
 
+extern struct sched_dl_entity *__pick_dl_last_entity(struct dl_rq *dl_rq);
+extern void print_dl_stats(struct seq_file *m, int cpu);
+
+void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+	s64 min_deadline = -1, max_deadline = -1;
+	struct rq *rq = cpu_rq(cpu);
+	struct sched_dl_entity *last;
+	unsigned long flags;
+
+	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	if (dl_rq->rb_leftmost)
+		min_deadline = (rb_entry(dl_rq->rb_leftmost,
+					 struct sched_dl_entity,
+					 rb_node))->deadline;
+	last = __pick_dl_last_entity(dl_rq);
+	if (last)
+		max_deadline = last->deadline;
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(dl_rq->x))
+#define __PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+#define PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(dl_rq->x))
+
+	P(dl_nr_running);
+	PN(exec_clock);
+	__PN(min_deadline);
+	__PN(max_deadline);
+
+#undef PN
+#undef __PN
+#undef P
+}
+
 extern __read_mostly int sched_clock_running;
 
 static void print_cpu(struct seq_file *m, int cpu)
@@ -309,6 +348,7 @@ do {									\
 	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
+	print_dl_stats(m, cpu);
 
 	rcu_read_lock();
 	print_rq(m, rq, cpu);
@@ -460,6 +500,12 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.statistics.nr_wakeups_affine_attempts);
 	P(se.statistics.nr_wakeups_passive);
 	P(se.statistics.nr_wakeups_idle);
+	if (dl_task(p)) {
+		PN(dl.stats.last_dmiss);
+		PN(dl.stats.dmiss_max);
+		PN(dl.stats.last_rorun);
+		PN(dl.stats.rorun_max);
+	}
 
 	{
 		u64 avg_atom, avg_per_cpu;
diff --git a/kernel/sched/dl.c b/kernel/sched/dl.c
index 75de7cc..2110492 100644
--- a/kernel/sched/dl.c
+++ b/kernel/sched/dl.c
@@ -514,6 +514,25 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 		return 0;
 
 	/*
+	 * Record statistics about last and maximum deadline
+	 * misses and runtime overruns.
+	 */
+	if (dmiss) {
+		u64 damount = rq->clock - dl_se->deadline;
+
+		schedstat_set(dl_se->stats.last_dmiss, damount);
+		schedstat_set(dl_se->stats.dmiss_max,
+			      max(dl_se->stats.dmiss_max, damount));
+	}
+	if (rorun) {
+		u64 ramount = -dl_se->runtime;
+
+		schedstat_set(dl_se->stats.last_rorun, ramount);
+		schedstat_set(dl_se->stats.rorun_max,
+			      max(dl_se->stats.rorun_max, ramount));
+	}
+
+	/*
 	 * If we are beyond our current deadline and we are still
 	 * executing, then we have already used some of the runtime of
 	 * the next instance. Thus, if we do not account that, we are
@@ -553,6 +572,7 @@ static void update_curr_dl(struct rq *rq)
 		      max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
+	schedstat_add(&rq->dl, exec_clock, delta_exec);
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock_task;
@@ -900,6 +920,18 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 }
 #endif
 
+#ifdef CONFIG_SCHED_DEBUG
+struct sched_dl_entity *__pick_dl_last_entity(struct dl_rq *dl_rq)
+{
+	struct rb_node *last = rb_last(&dl_rq->rb_root);
+
+	if (!last)
+		return NULL;
+
+	return rb_entry(last, struct sched_dl_entity, rb_node);
+}
+#endif /* CONFIG_SCHED_DEBUG */
+
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 						   struct dl_rq *dl_rq)
 {
@@ -1572,3 +1604,16 @@ const struct sched_class dl_sched_class = {
 	.switched_from		= switched_from_dl,
 	.switched_to		= switched_to_dl,
 };
+
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
+
+void print_dl_stats(struct seq_file *m, int cpu)
+{
+	struct dl_rq *dl_rq = &cpu_rq(cpu)->dl;
+
+	rcu_read_lock();
+	print_dl_rq(m, cpu, dl_rq);
+	rcu_read_unlock();
+}
+#endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4b02092..996a992 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -329,6 +329,8 @@ struct dl_rq {
 
 	unsigned long dl_nr_running;
 
+	u64 exec_clock;
+
 #ifdef CONFIG_SMP
 	/*
 	 * Deadline values of the currently executing and the
@@ -355,6 +357,11 @@ struct dl_rq {
 #endif
 };
 
+#ifdef CONFIG_SCHED_DEBUG
+struct sched_dl_entity *__pick_dl_last_entity(struct dl_rq *dl_rq);
+void print_dl_stats(struct seq_file *m, int cpu);
+#endif
+
 #ifdef CONFIG_SMP
 
 /*
@@ -1201,7 +1208,7 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-extern void init_dl_rq(struct dl_rq *rt_rq, struct rq *rq);
+extern void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq);
 extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
-- 
1.7.9.5

