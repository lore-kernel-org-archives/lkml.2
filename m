Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2JGHoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:44:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56798 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2JGHok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:44:40 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com,
        pjt@google.com, linux@arm.linux.org.uk
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 3/6] sched: pack small tasks 
Date: Sun,  7 Oct 2012 09:43:55 +0200
Message-Id: <1349595838-31274-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During sched_domain creation, we define a pack buddy CPU if available.

On a system that share the powerline at all level, the buddy is set to -1

On a dual clusters / dual cores system which can powergate each core and
cluster independantly, the buddy configuration will be :
      | CPU0 | CPU1 | CPU2 | CPU3 |
-----------------------------------
buddy | CPU0 | CPU0 | CPU0 | CPU2 |

Small tasks tend to slip out of the periodic load balance.
The best place to choose to migrate them is at their wake up.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    1 +
 3 files changed, 111 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dab7908..70cadbe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6131,6 +6131,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
+	update_packing_domain(cpu);
 	update_top_cache_domain(cpu);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f4a4f6..8c9d3ed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -157,6 +157,63 @@ void sched_init_granularity(void)
 	update_sysctl();
 }
 
+
+/*
+ * Save the id of the optimal CPU that should be used to pack small tasks
+ * The value -1 is used when no buddy has been found
+ */
+DEFINE_PER_CPU(int, sd_pack_buddy);
+
+/* Look for the best buddy CPU that can be used to pack small tasks
+ * We make the assumption that it doesn't wort to pack on CPU that share the
+ * same powerline. We looks for the 1st sched_domain without the
+ * SD_SHARE_POWERLINE flag. Then We look for the sched_group witht the lowest
+ * power per core based on the assumption that their power efficiency is
+ * better */
+void update_packing_domain(int cpu)
+{
+	struct sched_domain *sd;
+	int id = -1;
+
+	sd = highest_flag_domain(cpu, SD_SHARE_POWERLINE);
+	if (!sd)
+		sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	else
+		sd = sd->parent;
+
+	while (sd) {
+		struct sched_group *sg = sd->groups;
+		struct sched_group *pack = sg;
+		struct sched_group *tmp = sg->next;
+
+		/* 1st CPU of the sched domain is a good candidate */
+		if (id == -1)
+			id = cpumask_first(sched_domain_span(sd));
+
+		/* loop the sched groups to find the best one */
+		while (tmp != sg) {
+			if (tmp->sgp->power * sg->group_weight <
+					sg->sgp->power * tmp->group_weight)
+				pack = tmp;
+			tmp = tmp->next;
+		}
+
+		/* we have found a better group */
+		if (pack != sg)
+			id = cpumask_first(sched_group_cpus(pack));
+
+		/* Look for another CPU than itself */
+		if ((id != cpu)
+		 || ((sd->parent) && !(sd->parent->flags && SD_LOAD_BALANCE)))
+			break;
+
+		sd = sd->parent;
+	}
+
+	pr_info(KERN_INFO "CPU%d packing on CPU%d\n", cpu, id);
+	per_cpu(sd_pack_buddy, cpu) = id;
+}
+
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
 #else
@@ -3073,6 +3130,55 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	return target;
 }
 
+static inline bool is_buddy_busy(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	/*
+	 * A busy buddy is a CPU with a high load or a small load with a lot of
+	 * running tasks.
+	 */
+	return ((rq->avg.usage_avg_sum << rq->nr_running) >
+			rq->avg.runnable_avg_period);
+}
+
+static inline bool is_light_task(struct task_struct *p)
+{
+	/* A light task runs less than 25% in average */
+	return ((p->se.avg.usage_avg_sum << 2) < p->se.avg.runnable_avg_period);
+}
+
+static int check_pack_buddy(int cpu, struct task_struct *p)
+{
+	int buddy = per_cpu(sd_pack_buddy, cpu);
+
+	/* No pack buddy for this CPU */
+	if (buddy == -1)
+		return false;
+
+	/*
+	 * If a task is waiting for running on the CPU which is its own buddy,
+	 * let the default behavior to look for a better CPU if available
+	 * The threshold has been set to 37.5%
+	 */
+	if ((buddy == cpu)
+	 && ((p->se.avg.usage_avg_sum << 3) < (p->se.avg.runnable_avg_sum * 5)))
+		return false;
+
+	/* buddy is not an allowed CPU */
+	if (!cpumask_test_cpu(buddy, tsk_cpus_allowed(p)))
+		return false;
+
+	/*
+	 * If the task is a small one and the buddy is not overloaded,
+	 * we use buddy cpu
+	 */
+	 if (!is_light_task(p) || is_buddy_busy(buddy))
+		return false;
+
+	return true;
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -3098,6 +3204,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
+	if (check_pack_buddy(cpu, p))
+		return per_cpu(sd_pack_buddy, cpu);
+
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 			want_affine = 1;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a95d5c1..086d8bf 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -875,6 +875,7 @@ static inline void idle_balance(int cpu, struct rq *rq)
 
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
+extern void update_packing_domain(int cpu);
 extern void update_max_interval(void);
 extern void update_group_power(struct sched_domain *sd, int cpu);
 extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
-- 
1.7.9.5

