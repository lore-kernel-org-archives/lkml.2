Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1LSId1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:33:27 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54509 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1LSId0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:33:26 -0500
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/4] sched: Adding gang scheduling infrastrucure
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 14:04:38 +0530
Message-ID: <20111219083424.32311.23559.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11121908-3864-0000-0000-00000091AA55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introduces the concept of gang_leader and gang_cpumasks.  For the
first time when the gang_leader is not set, the gang leader is elected. The
election is dependent on the number of cpus that we have to gang, aka gang
granularity. ATM, gang granularity is set to 8cpus, which can be made to set
using a sysctl if required.

TODO: This still does not take care of cpu-offlining and re-electing the
gang-leader

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---

 kernel/sched/core.c  |    9 +++++
 kernel/sched/fair.c  |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    4 ++
 3 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e96f861..f3ae29c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1968,6 +1968,12 @@ static inline void post_schedule(struct rq *rq)
 
 		rq->post_schedule = 0;
 	}
+	if (rq->gang_schedule == 1) {
+		struct task_group *tg = task_group(rq->curr);
+
+		gang_sched(tg, rq);
+	}
+
 }
 
 #else
@@ -6903,6 +6909,9 @@ void __init sched_init(void)
 		rq->rd = NULL;
 		rq->cpu_power = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
+		rq->gang_schedule = 0;
+		rq->gang_leader = -1;
+		rq->gang_cpumask = NULL;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b95575f..c03efd2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3020,6 +3020,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
+	struct task_group *tg;
 
 	if (!cfs_rq->nr_running)
 		return NULL;
@@ -3030,6 +3031,13 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
+	tg = se->cfs_rq->tg;
+
+	if (tg->gang) {
+		if (!rq->gang_schedule && rq->gang_leader)
+			rq->gang_schedule = tg->gang;
+	}
+
 	p = task_of(se);
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
@@ -3533,6 +3541,15 @@ struct sg_lb_stats {
 };
 
 /**
+ * domain_first_cpu - Returns the first cpu in the cpumask of a sched_domain.
+ * @domain: The domain whose first cpu is to be returned.
+ */
+static inline unsigned int domain_first_cpu(struct sched_domain *sd)
+{
+	return cpumask_first(sched_domain_span(sd));
+}
+
+/**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
  * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
@@ -5485,6 +5502,80 @@ done:
 	return 0;
 }
 
+static void gang_sched_member(void *info)
+{
+	struct task_group *tg = (struct task_group *) info;
+	struct cfs_rq *cfs_rq;
+	struct rq *rq;
+	int cpu;
+	unsigned long flags;
+
+	cpu  = smp_processor_id();
+	cfs_rq = tg->cfs_rq[cpu];
+	rq = cfs_rq->rq;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+
+	/* Check if the runqueue has runnable tasks */
+	if (cfs_rq->nr_running) {
+		/* Favour this task group and set need_resched flag,
+		 * added by following patches */
+	}
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+#define GANG_SCHED_GRANULARITY 8
+
+void gang_sched(struct task_group *tg, struct rq *rq)
+{
+	/* We do not gang sched here */
+	if (rq->gang_leader == 0 || !tg || tg->gang == 0)
+		return;
+
+	/* Yes thats the leader */
+	if (rq->gang_leader == 1) {
+
+		if (!in_interrupt() && !irqs_disabled()) {
+			smp_call_function_many(rq->gang_cpumask,
+					gang_sched_member, tg, 0);
+
+			rq->gang_schedule = 0;
+		}
+
+	} else {
+		/*
+		 * find the gang leader according to the span,
+		 * currently we have it as 8cpu, this can be made
+		 * dynamic
+		 */
+		struct sched_domain *sd;
+		unsigned int count;
+		int i;
+
+		for_each_domain(cpu_of(rq), sd) {
+			count = 0;
+			for_each_cpu(i, sched_domain_span(sd))
+				count++;
+
+			if (count >= GANG_SCHED_GRANULARITY)
+				break;
+		}
+
+		if (sd && cpu_of(rq) == domain_first_cpu(sd)) {
+			printk(KERN_INFO "Selected CPU %d as gang leader\n",
+				cpu_of(rq));
+			rq->gang_leader = 1;
+			rq->gang_cpumask = sched_domain_span(sd);
+		} else if (sd) {
+			/*
+			 * A fellow cpu, it will receive gang
+			 * initiations from the gang leader now
+			 */
+			rq->gang_leader = 0;
+		}
+	}
+}
+
 static DEFINE_MUTEX(gang_mutex);
 
 int sched_group_set_gang(struct task_group *tg, unsigned long gang)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f1a85e3..db8369f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -187,6 +187,7 @@ extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern int sched_group_set_gang(struct task_group *tg, unsigned long gang);
+extern void gang_sched(struct task_group *tg, struct rq *rq);
 
 extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
@@ -419,6 +420,9 @@ struct rq {
 	unsigned char idle_balance;
 	/* For active balancing */
 	int post_schedule;
+	int gang_schedule;
+	int gang_leader;
+	struct cpumask *gang_cpumask;
 	int active_balance;
 	int push_cpu;
 	struct cpu_stop_work active_balance_work;

