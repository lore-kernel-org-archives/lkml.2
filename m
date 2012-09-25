Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab2IYKhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:37:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58422 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2IYKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:36:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] sched: Create sched_select_cpu() to give preferred CPU for power saving
Date: Tue, 25 Sep 2012 16:06:06 +0530
Message-Id: <cdec85a36f2da0d604aba8a330912ed3de2177b5.1348568074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
 <cover.1348568074.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Sep 2012 10:36:29.0288 (UTC) FILETIME=[9F476680:01CD9B09]
X-MC-Unique: 112092511363009501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8PAbMVE025582

In order to save power, it would be useful to schedule work onto non-IDLE cpus
instead of waking up an IDLE one.

To achieve this, we need scheduler to guide kernel frameworks (like: timers &
workqueues) on which is the most preferred CPU that must be used for these
tasks.

This routine returns the preferred cpu which is non-idle. It accepts max level
of sched domain, upto which we can choose a CPU from. It can accept following
options: SD_SIBLING, SD_MC, SD_BOOK, SD_CPU or SD_NUMA.

If user passed SD_MC, then we can return a CPU from SD_SIBLING or SD_MC.  If the
level requested by user is not available for the current kernel configuration,
then current CPU will be returned.

If user has passed NUMA level, then we may need to go through numa_levels too.
Second parameter to this routine will now come into play. Its minimum value is
zero, in which case there is only one NUMA level to go through. If you want to
go through all NUMA levels, pass -1 here. This should cover all NUMA levels.

This patch reuses the code from get_nohz_timer_target() routine, which had
similar implementation. get_nohz_timer_target() is also modified to use
sched_select_cpu() now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/sched.h | 11 +++++++
 kernel/sched/core.c   | 88 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0059212..4b660ee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -281,6 +281,10 @@ static inline void select_nohz_load_balancer(int stop_tick) { }
 static inline void set_cpu_sd_state_idle(void) { }
 #endif
 
+#ifdef CONFIG_SMP
+extern int sched_select_cpu(int sd_max_level, u32 numa_level);
+#endif
+
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
@@ -868,6 +872,13 @@ enum cpu_idle_type {
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
+/* sched-domain levels */
+#define SD_SIBLING		0x01	/* Only for CONFIG_SCHED_SMT */
+#define SD_MC			0x02	/* Only for CONFIG_SCHED_MC */
+#define SD_BOOK			0x04	/* Only for CONFIG_SCHED_BOOK */
+#define SD_CPU			0x08	/* Always enabled */
+#define SD_NUMA			0x10	/* Only for CONFIG_NUMA */
+
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
 struct sched_group_power {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index de97083..a14014c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -551,22 +551,7 @@ void resched_cpu(int cpu)
  */
 int get_nohz_timer_target(void)
 {
-	int cpu = smp_processor_id();
-	int i;
-	struct sched_domain *sd;
-
-	rcu_read_lock();
-	for_each_domain(cpu, sd) {
-		for_each_cpu(i, sched_domain_span(sd)) {
-			if (!idle_cpu(i)) {
-				cpu = i;
-				goto unlock;
-			}
-		}
-	}
-unlock:
-	rcu_read_unlock();
-	return cpu;
+	return sched_select_cpu(SD_NUMA, -1);
 }
 /*
  * When add_timer_on() enqueues a timer into the timer wheel of an
@@ -639,6 +624,66 @@ void sched_avg_update(struct rq *rq)
 	}
 }
 
+/* Mask of all the SD levels present in current configuration */
+static int sd_present_levels;
+
+/*
+ * This routine returns the preferred cpu which is non-idle. It accepts max
+ * level of sched domain, upto which we can choose a CPU from. It can accept
+ * following options: SD_SIBLING, SD_MC, SD_BOOK, SD_CPU or SD_NUMA.
+ *
+ * If user passed SD_MC, then we can return a CPU from SD_SIBLING or SD_MC.
+ * If the level requested by user is not available for the current kernel
+ * configuration, then current CPU will be returned.
+ *
+ * If user has passed NUMA level, then we may need to go through numa_levels
+ * too. Second parameter to this routine will now come into play. Its minimum
+ * value is zero, in which case there is only one NUMA level to go through. If
+ * you want to go through all NUMA levels, pass -1 here. This should cover all
+ * NUMA levels.
+ */
+int sched_select_cpu(int sd_max_level, u32 numa_level)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+	int i, sd_target_levels;
+
+	sd_target_levels = (sd_max_level | (sd_max_level - 1))
+			& sd_present_levels;
+
+	/* return current cpu if no sd_present_levels <= sd_max_level */
+	if (!sd_target_levels)
+		return cpu;
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (!idle_cpu(i)) {
+				cpu = i;
+				goto unlock;
+			}
+		}
+
+		/* Do we need to go through NUMA levels now */
+		if (sd_target_levels == SD_NUMA) {
+			/* Go through NUMA levels until numa_level is zero */
+			if (numa_level--)
+				continue;
+		}
+
+		/*
+		 * clear first bit set in sd_target_levels, and return if no
+		 * more sd levels must be checked
+		 */
+		sd_target_levels &= sd_target_levels - 1;
+		if (!sd_target_levels)
+			goto unlock;
+	}
+unlock:
+	rcu_read_unlock();
+	return cpu;
+}
+
 #else /* !CONFIG_SMP */
 void resched_task(struct task_struct *p)
 {
@@ -6188,6 +6233,7 @@ typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
+	int		    level_mask;
 	int		    flags;
 	int		    numa_level;
 	struct sd_data      data;
@@ -6434,6 +6480,7 @@ sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
 	*sd = SD_##type##_INIT;						\
 	SD_INIT_NAME(sd, type);						\
 	sd->private = &tl->data;					\
+	sd_present_levels |= tl->level_mask;				\
 	return sd;							\
 }
 
@@ -6547,15 +6594,15 @@ static const struct cpumask *cpu_smt_mask(int cpu)
  */
 static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_SCHED_SMT
-	{ sd_init_SIBLING, cpu_smt_mask, },
+	{ sd_init_SIBLING, cpu_smt_mask, SD_SIBLING, },
 #endif
 #ifdef CONFIG_SCHED_MC
-	{ sd_init_MC, cpu_coregroup_mask, },
+	{ sd_init_MC, cpu_coregroup_mask, SD_MC, },
 #endif
 #ifdef CONFIG_SCHED_BOOK
-	{ sd_init_BOOK, cpu_book_mask, },
+	{ sd_init_BOOK, cpu_book_mask, SD_BOOK, },
 #endif
-	{ sd_init_CPU, cpu_cpu_mask, },
+	{ sd_init_CPU, cpu_cpu_mask, SD_CPU, },
 	{ NULL, },
 };
 
@@ -6778,6 +6825,7 @@ static void sched_init_numa(void)
 		};
 	}
 
+	sd_present_levels |= SD_NUMA;
 	sched_domain_topology = tl;
 }
 #else
-- 
1.7.12.rc2.18.g61b472e


