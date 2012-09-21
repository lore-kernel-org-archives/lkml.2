Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab2IUSiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:38:14 -0400
Received: from service88.mimecast.com ([195.130.217.12]:50110 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab2IUSiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:38:12 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 14:38:11 EDT
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/10] sched: SCHED_HMP multi-domain task migration control
Date: Fri, 21 Sep 2012 19:32:25 +0100
Message-Id: <1348252345-5642-11-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:28.0147 (UTC) FILETIME=[74087430:01CD9827]
X-MC-Unique: 112092119322816101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIcJhW011404

From: Morten Rasmussen <morten.rasmussen@arm.com>

We need a way to prevent tasks that are migrating up and down the
hmp_domains from migrating straight on through before the load has
adapted to the new compute capacity of the CPU on the new hmp_domain.
This patch adds a next up/down migration delay that prevents the task
from doing another migration in the same direction until the delay
has expired.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/linux/sched.h |    4 ++++
 kernel/sched/core.c   |    4 ++++
 kernel/sched/fair.c   |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index df971a3..ca3890a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1158,6 +1158,10 @@ struct sched_avg {
 	s64 decay_count;
 	unsigned long load_avg_contrib;
 	unsigned long load_avg_ratio;
+#ifdef CONFIG_SCHED_HMP
+	u64 hmp_last_up_migration;
+	u64 hmp_last_down_migration;
+#endif
 	u32 usage_avg_sum;
 };
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 652b86b..a3b1ff6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1723,6 +1723,10 @@ static void __sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+#ifdef CONFIG_SCHED_HMP
+	p->se.avg.hmp_last_up_migration = 0;
+	p->se.avg.hmp_last_down_migration = 0;
+#endif
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 811b2b9..56cbda1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3138,10 +3138,14 @@ static int __init hmp_cpu_mask_setup(void)
  * tweaking suit particular needs.
  *
  * hmp_up_prio: Only up migrate task with high priority (<hmp_up_prio)
+ * hmp_next_up_threshold: Delay before next up migration (1024 ~= 1 ms)
+ * hmp_next_down_threshold: Delay before next down migration (1024 ~= 1 ms)
  */
 unsigned int hmp_up_threshold = 512;
 unsigned int hmp_down_threshold = 256;
 unsigned int hmp_up_prio = NICE_TO_PRIO(CONFIG_SCHED_HMP_PRIO_FILTER_VAL);
+unsigned int hmp_next_up_threshold = 4096;
+unsigned int hmp_next_down_threshold = 4096;
 
 static unsigned int hmp_up_migration(int cpu, struct sched_entity *se);
 static unsigned int hmp_down_migration(int cpu, struct sched_entity *se);
@@ -3204,6 +3208,21 @@ static inline unsigned int hmp_select_slower_cpu(struct task_struct *tsk,
 				tsk_cpus_allowed(tsk));
 }
 
+static inline void hmp_next_up_delay(struct sched_entity *se, int cpu)
+{
+	struct cfs_rq *cfs_rq = &cpu_rq(cpu)->cfs;
+
+	se->avg.hmp_last_up_migration = cfs_rq_clock_task(cfs_rq);
+	se->avg.hmp_last_down_migration = 0;
+}
+
+static inline void hmp_next_down_delay(struct sched_entity *se, int cpu)
+{
+	struct cfs_rq *cfs_rq = &cpu_rq(cpu)->cfs;
+
+	se->avg.hmp_last_down_migration = cfs_rq_clock_task(cfs_rq);
+	se->avg.hmp_last_up_migration = 0;
+}
 #endif /* CONFIG_SCHED_HMP */
 
 /*
@@ -3335,11 +3354,13 @@ unlock:
 #ifdef CONFIG_SCHED_HMP
 	if (hmp_up_migration(prev_cpu, &p->se)) {
 		new_cpu = hmp_select_faster_cpu(p, prev_cpu);
+		hmp_next_up_delay(&p->se, new_cpu);
 		trace_sched_hmp_migrate(p, new_cpu, 0);
 		return new_cpu;
 	}
 	if (hmp_down_migration(prev_cpu, &p->se)) {
 		new_cpu = hmp_select_slower_cpu(p, prev_cpu);
+		hmp_next_down_delay(&p->se, new_cpu);
 		trace_sched_hmp_migrate(p, new_cpu, 0);
 		return new_cpu;
 	}
@@ -5503,6 +5524,8 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
 static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
 {
 	struct task_struct *p = task_of(se);
+	struct cfs_rq *cfs_rq = &cpu_rq(cpu)->cfs;
+	u64 now;
 
 	if (hmp_cpu_is_fastest(cpu))
 		return 0;
@@ -5513,6 +5536,12 @@ static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
 		return 0;
 #endif
 
+	/* Let the task load settle before doing another up migration */
+	now = cfs_rq_clock_task(cfs_rq);
+	if (((now - se->avg.hmp_last_up_migration) >> 10)
+					< hmp_next_up_threshold)
+		return 0;
+
 	if (cpumask_intersects(&hmp_faster_domain(cpu)->cpus,
 					tsk_cpus_allowed(p))
 		&& se->avg.load_avg_ratio > hmp_up_threshold) {
@@ -5525,6 +5554,8 @@ static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
 static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
 {
 	struct task_struct *p = task_of(se);
+	struct cfs_rq *cfs_rq = &cpu_rq(cpu)->cfs;
+	u64 now;
 
 	if (hmp_cpu_is_slowest(cpu))
 		return 0;
@@ -5535,6 +5566,12 @@ static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
 		return 1;
 #endif
 
+	/* Let the task load settle before doing another down migration */
+	now = cfs_rq_clock_task(cfs_rq);
+	if (((now - se->avg.hmp_last_down_migration) >> 10)
+					< hmp_next_down_threshold)
+		return 0;
+
 	if (cpumask_intersects(&hmp_slower_domain(cpu)->cpus,
 					tsk_cpus_allowed(p))
 		&& se->avg.load_avg_ratio < hmp_down_threshold) {
@@ -5725,6 +5762,7 @@ static void hmp_force_up_migration(int this_cpu)
 				target->migrate_task = p;
 				force = 1;
 				trace_sched_hmp_migrate(p, target->push_cpu, 1);
+				hmp_next_up_delay(&p->se, target->push_cpu);
 			}
 		}
 		raw_spin_unlock_irqrestore(&target->lock, flags);
-- 
1.7.9.5


