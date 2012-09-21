Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab2IUSgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:36:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36680 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab2IUSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:26 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/10] sched: Task placement for heterogeneous systems based on task load-tracking
Date: Fri, 21 Sep 2012 19:32:17 +0100
Message-Id: <1348252345-5642-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:23.0976 (UTC) FILETIME=[718C0280:01CD9827]
X-MC-Unique: 112092119322500101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIaeLt011396

From: Morten Rasmussen <morten.rasmussen@arm.com>

This patch introduces the basic SCHED_HMP infrastructure. Each class of
cpus is represented by a hmp_domain and tasks will only be moved between
these domains when their load profiles suggest it is beneficial.

SCHED_HMP relies heavily on the task load-tracking introduced in Paul
Turners fair group scheduling patch set:

<https://lkml.org/lkml/2012/8/23/267>

SCHED_HMP requires that the platform implements arch_get_hmp_domains()
which should set up the platform specific list of hmp_domains. It is
also assumed that the platform disables SD_LOAD_BALANCE for the
appropriate sched_domains.
Tasks placement takes place every time a task is to be inserted into
a runqueue based on its load history. The task placement decision is
based on load thresholds.

There are no restrictions on the number of hmp_domains, however,
multiple (>2) has not been tested and the up/down migration policy is
rather simple.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/Kconfig      |   17 +++++
 include/linux/sched.h |    6 ++
 kernel/sched/fair.c   |  168 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h  |    6 ++
 4 files changed, 197 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f4a5d58..5b09684 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1554,6 +1554,23 @@ config SCHED_SMT
 	  MultiThreading at a cost of slightly increased overhead in some
 	  places. If unsure say N here.
 
+config DISABLE_CPU_SCHED_DOMAIN_BALANCE
+	bool "(EXPERIMENTAL) Disable CPU level scheduler load-balancing"
+	help
+	  Disables scheduler load-balancing at CPU sched domain level.
+
+config SCHED_HMP
+	bool "(EXPERIMENTAL) Heterogenous multiprocessor scheduling"
+	depends on DISABLE_CPU_SCHED_DOMAIN_BALANCE && SCHED_MC && FAIR_GROUP_SCHED && !SCHED_AUTOGROUP
+	help
+	  Experimental scheduler optimizations for heterogeneous platforms.
+	  Attempts to introspectively select task affinity to optimize power
+	  and performance. Basic support for multiple (>2) cpu types is in place,
+	  but it has only been tested with two types of cpus.
+	  There is currently no support for migration of task groups, hence
+	  !SCHED_AUTOGROUP. Furthermore, normal load-balancing must be disabled
+	  between cpus of different type (DISABLE_CPU_SCHED_DOMAIN_BALANCE).
+
 config HAVE_ARM_SCU
 	bool
 	help
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81e4e82..df971a3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1039,6 +1039,12 @@ unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
+#ifdef CONFIG_SCHED_HMP
+struct hmp_domain {
+	struct cpumask cpus;
+	struct list_head hmp_domains;
+};
+#endif /* CONFIG_SCHED_HMP */
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3e17dd5..d80de46 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3077,6 +3077,125 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	return target;
 }
 
+#ifdef CONFIG_SCHED_HMP
+/*
+ * Heterogenous multiprocessor (HMP) optimizations
+ *
+ * The cpu types are distinguished using a list of hmp_domains
+ * which each represent one cpu type using a cpumask.
+ * The list is assumed ordered by compute capacity with the
+ * fastest domain first.
+ */
+DEFINE_PER_CPU(struct hmp_domain *, hmp_cpu_domain);
+
+extern void __init arch_get_hmp_domains(struct list_head *hmp_domains_list);
+
+/* Setup hmp_domains */
+static int __init hmp_cpu_mask_setup(void)
+{
+	char buf[64];
+	struct hmp_domain *domain;
+	struct list_head *pos;
+	int dc, cpu;
+
+	pr_debug("Initializing HMP scheduler:\n");
+
+	/* Initialize hmp_domains using platform code */
+	arch_get_hmp_domains(&hmp_domains);
+	if (list_empty(&hmp_domains)) {
+		pr_debug("HMP domain list is empty!\n");
+		return 0;
+	}
+
+	/* Print hmp_domains */
+	dc = 0;
+	list_for_each(pos, &hmp_domains) {
+		domain = list_entry(pos, struct hmp_domain, hmp_domains);
+		cpulist_scnprintf(buf, 64, &domain->cpus);
+		pr_debug("  HMP domain %d: %s\n", dc, buf);
+
+		for_each_cpu_mask(cpu, domain->cpus) {
+			per_cpu(hmp_cpu_domain, cpu) = domain;
+		}
+		dc++;
+	}
+
+	return 1;
+}
+
+/*
+ * Migration thresholds should be in the range [0..1023]
+ * hmp_up_threshold: min. load required for migrating tasks to a faster cpu
+ * hmp_down_threshold: max. load allowed for tasks migrating to a slower cpu
+ * The default values (512, 256) offer good responsiveness, but may need
+ * tweaking suit particular needs.
+ */
+unsigned int hmp_up_threshold = 512;
+unsigned int hmp_down_threshold = 256;
+
+static unsigned int hmp_up_migration(int cpu, struct sched_entity *se);
+static unsigned int hmp_down_migration(int cpu, struct sched_entity *se);
+
+/* Check if cpu is in fastest hmp_domain */
+static inline unsigned int hmp_cpu_is_fastest(int cpu)
+{
+	struct list_head *pos;
+
+	pos = &hmp_cpu_domain(cpu)->hmp_domains;
+	return pos == hmp_domains.next;
+}
+
+/* Check if cpu is in slowest hmp_domain */
+static inline unsigned int hmp_cpu_is_slowest(int cpu)
+{
+	struct list_head *pos;
+
+	pos = &hmp_cpu_domain(cpu)->hmp_domains;
+	return list_is_last(pos, &hmp_domains);
+}
+
+/* Next (slower) hmp_domain relative to cpu */
+static inline struct hmp_domain *hmp_slower_domain(int cpu)
+{
+	struct list_head *pos;
+
+	pos = &hmp_cpu_domain(cpu)->hmp_domains;
+	return list_entry(pos->next, struct hmp_domain, hmp_domains);
+}
+
+/* Previous (faster) hmp_domain relative to cpu */
+static inline struct hmp_domain *hmp_faster_domain(int cpu)
+{
+	struct list_head *pos;
+
+	pos = &hmp_cpu_domain(cpu)->hmp_domains;
+	return list_entry(pos->prev, struct hmp_domain, hmp_domains);
+}
+
+/*
+ * Selects a cpu in previous (faster) hmp_domain
+ * Note that cpumask_any_and() returns the first cpu in the cpumask
+ */
+static inline unsigned int hmp_select_faster_cpu(struct task_struct *tsk,
+							int cpu)
+{
+	return cpumask_any_and(&hmp_faster_domain(cpu)->cpus,
+				tsk_cpus_allowed(tsk));
+}
+
+/*
+ * Selects a cpu in next (slower) hmp_domain
+ * Note that cpumask_any_and() returns the first cpu in the cpumask
+ */
+static inline unsigned int hmp_select_slower_cpu(struct task_struct *tsk,
+							int cpu)
+{
+	return cpumask_any_and(&hmp_slower_domain(cpu)->cpus,
+				tsk_cpus_allowed(tsk));
+}
+
+#endif /* CONFIG_SCHED_HMP */
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -3203,6 +3322,16 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 unlock:
 	rcu_read_unlock();
 
+#ifdef CONFIG_SCHED_HMP
+	if (hmp_up_migration(prev_cpu, &p->se))
+		return hmp_select_faster_cpu(p, prev_cpu);
+	if (hmp_down_migration(prev_cpu, &p->se))
+		return hmp_select_slower_cpu(p, prev_cpu);
+	/* Make sure that the task stays in its previous hmp domain */
+	if (!cpumask_test_cpu(new_cpu, &hmp_cpu_domain(prev_cpu)->cpus))
+		return prev_cpu;
+#endif
+
 	return new_cpu;
 }
 
@@ -5354,6 +5483,41 @@ need_kick:
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
 #endif
 
+#ifdef CONFIG_SCHED_HMP
+/* Check if task should migrate to a faster cpu */
+static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
+{
+	struct task_struct *p = task_of(se);
+
+	if (hmp_cpu_is_fastest(cpu))
+		return 0;
+
+	if (cpumask_intersects(&hmp_faster_domain(cpu)->cpus,
+					tsk_cpus_allowed(p))
+		&& se->avg.load_avg_ratio > hmp_up_threshold) {
+		return 1;
+	}
+	return 0;
+}
+
+/* Check if task should migrate to a slower cpu */
+static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
+{
+	struct task_struct *p = task_of(se);
+
+	if (hmp_cpu_is_slowest(cpu))
+		return 0;
+
+	if (cpumask_intersects(&hmp_slower_domain(cpu)->cpus,
+					tsk_cpus_allowed(p))
+		&& se->avg.load_avg_ratio < hmp_down_threshold) {
+		return 1;
+	}
+	return 0;
+}
+
+#endif /* CONFIG_SCHED_HMP */
+
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
  * Also triggered for nohz idle balancing (with nohz_balancing_kick set).
@@ -5861,6 +6025,10 @@ __init void init_sched_fair_class(void)
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif
+
+#ifdef CONFIG_SCHED_HMP
+	hmp_cpu_mask_setup();
+#endif
 #endif /* SMP */
 
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 81135f9..4990d9e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -547,6 +547,12 @@ DECLARE_PER_CPU(int, sd_llc_id);
 
 extern int group_balance_cpu(struct sched_group *sg);
 
+#ifdef CONFIG_SCHED_HMP
+static LIST_HEAD(hmp_domains);
+DECLARE_PER_CPU(struct hmp_domain *, hmp_cpu_domain);
+#define hmp_cpu_domain(cpu)	(per_cpu(hmp_cpu_domain, (cpu)))
+#endif /* CONFIG_SCHED_HMP */
+
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
-- 
1.7.9.5


