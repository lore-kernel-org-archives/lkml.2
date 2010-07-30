Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0G3FTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:19:55 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23017 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0G3FTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ORxEF0ue+YzzL325iPE3r9O30OT9Kr2IiKJSh+B9XA8xiQR0yxzOjP30JUwv0L34e
	3+sBJ7u+nfjcwmRXDyAgQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 5/6] sched: add SCHED_IDLE load balancer
Date: Thu, 29 Jul 2010 22:19:05 -0700
Message-Id: <1280467146-32218-6-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a load balancer for SCHED_IDLE tasks (sched_idle_load_balance).
The metric used to balance SCHED_IDLE tasks is calculated as:

  load = (idle_nr_runnig * WEIGHT_IDLEPRIO / idle power)

The metric used is a ratio of the load contributed by SCHED_IDLE tasks to the
available power for running SCHED_IDLE tasks. We determine available power
similar to the RT power scaling calculations, i.e. we scale a CPU's available
idle power based on the average SCHED_NORMAL/SCHED_BATCH activity over a given
period.

The SCHED_IDLE load balancer is called at the end of rebalance domain. It runs
only when the SCHED_NORMAL/SCHED_BATCH balancer runs (i.e. it follows the same
rate limit).

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cb270e8..134ddbf 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1874,6 +1874,20 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	pinned = 1;
 
 	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
+		/*
+		 * We skip this task if the following conditions are satisfied:
+		 * 1. This sched domain has SD_IDLE_LOAD_BALANCE set
+		 * 2. If sched_idle_balance is not set (i.e. we are doing a
+		 * SCHED_NORMAL/SCHED_BATCH balance) and this is a SCHED_IDLE
+		 * task
+		 * 3. If sched_idle_balance is set (i.e. we are doing a
+		 * SCHED_IDLE balance) and this is not a SCHED_IDLE task
+		 */
+		if (sd->flags & SD_IDLE_LOAD_BALANCE &&
+		    ((sched_idle_balance && p->policy != SCHED_IDLE) ||
+		    (!sched_idle_balance && p->policy == SCHED_IDLE)))
+			continue;
+
 		if (loops++ > sysctl_sched_nr_migrate)
 			break;
 
@@ -3097,6 +3111,119 @@ out_unlock:
 	return 0;
 }
 
+/*
+ * SCHED_IDLE balancing functions
+ */
+unsigned long scale_norm_power(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 total, available;
+
+	sched_avg_update(rq);
+
+	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	available = total - (rq->rt_avg + rq->norm_avg);
+
+	if (unlikely((s64)total < SCHED_LOAD_SCALE))
+		total = SCHED_LOAD_SCALE;
+
+	total >>= SCHED_LOAD_SHIFT;
+
+	return div_u64(available, total);
+}
+
+unsigned long sched_idle_cpu_load(struct rq *rq)
+{
+	unsigned long sched_idle_load, power = SCHED_LOAD_SCALE;
+
+	power *= scale_norm_power(cpu_of(rq));
+	power >>= SCHED_LOAD_SHIFT;
+
+	if (!power)
+		power = 1;
+
+	sched_idle_load = rq->idle_nr_running * WEIGHT_IDLEPRIO;
+
+	return div_u64(sched_idle_load * SCHED_LOAD_SCALE, power);
+}
+
+static struct rq *busiest_idle_balance_queue(struct sched_domain *sd,
+		int this_cpu, unsigned long *sched_idle_imbalance)
+{
+	struct rq *busiest = NULL;
+	unsigned long this_load = 0, max_load = 0;
+	unsigned long this_nr_running = 0, max_nr_running = 0;
+	int local_cpu, i;
+
+	for_each_cpu(i, sched_domain_span(sd)) {
+		struct rq *rq = cpu_rq(i);
+		unsigned long load, idle_nr_running;
+
+		local_cpu = (i == this_cpu);
+
+		load = sched_idle_cpu_load(rq);
+		idle_nr_running = rq->idle_nr_running;
+
+		if (local_cpu) {
+			this_load = load;
+			this_nr_running = idle_nr_running;
+		} else if (load > max_load) {
+			busiest = rq;
+			max_load = load;
+			max_nr_running = idle_nr_running;
+		}
+	}
+
+	if (!busiest || max_nr_running < 1)
+		goto out_balanced;
+
+	if (this_load > max_load)
+		goto out_balanced;
+
+	*sched_idle_imbalance = (max_load - this_load) / 2;
+
+	if (100 * max_load <= sd->imbalance_pct * this_load)
+		goto out_balanced;
+
+	return busiest;
+
+out_balanced:
+	*sched_idle_imbalance = 0;
+	return NULL;
+}
+
+static int sched_idle_load_balance(int this_cpu, struct rq *this_rq,
+		struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	struct rq *busiest = NULL;
+	unsigned long sched_idle_imbalance;
+	int ld_moved;
+
+	busiest = busiest_idle_balance_queue(sd, this_cpu,
+			&sched_idle_imbalance);
+	if (!busiest)
+		return 0;
+
+	WARN_ON(busiest == this_rq);
+
+	if (busiest->idle_nr_running > 1) {
+		unsigned long flags;
+		int ld_moved, tmp = 0;
+
+		local_irq_save(flags);
+		double_rq_lock(this_rq, busiest);
+		ld_moved = move_tasks(this_rq, this_cpu, busiest,
+				sched_idle_imbalance, sd, idle, &tmp, 1);
+		double_rq_unlock(this_rq, busiest);
+		local_irq_restore(flags);
+
+		if (ld_moved && this_cpu != smp_processor_id())
+			resched_cpu(this_cpu);
+	}
+
+	return ld_moved;
+}
+
 #ifdef CONFIG_NO_HZ
 static struct {
 	atomic_t load_balancer;
@@ -3330,6 +3457,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
+	int do_sched_idle_balance = 0;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3363,6 +3491,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 				idle = CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
+			do_sched_idle_balance = 1;
 		}
 		if (need_serialize)
 			spin_unlock(&balancing);
@@ -3388,6 +3517,17 @@ out:
 	 */
 	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
+
+	if (do_sched_idle_balance)
+		for_each_domain(cpu, sd) {
+			/*
+			 * Skip SCHED_IDLE balance on domains where
+			 * SD_LOAD_BALANCE is not set
+			 */
+			if (!(sd->flags & SD_IDLE_LOAD_BALANCE))
+				continue;
+			sched_idle_load_balance(cpu, rq, sd, idle);
+		}
 }
 
 /*
-- 
1.7.1

