Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2JOLh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:37:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55304 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2JOLhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:37:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Robin.Randhawa@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2] cpufreq: Move common part from governors to separate file
Date: Mon, 15 Oct 2012 17:07:36 +0530
Message-Id: <55ee99ecd367db51513d6dbff504a9b6f14ffba3.1350301011.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 15 Oct 2012 11:37:51.0101 (UTC) FILETIME=[82127AD0:01CDAAC9]
X-MC-Unique: 112101512375103001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9FBbwiL024686

Multiple cpufreq governers have defined similar get_cpu_idle_time_***()
routines. These routines must be moved to some common place, so that all
governors can use them.

So moving them to cpufreq_governor.c, which seems to be a better place for
keeping these routines.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
-----
- Instead of moving get_cpu_idle_time_*() routines to tick-sched, move them to
  common governor specific file.

 drivers/cpufreq/Makefile               |  4 +--
 drivers/cpufreq/cpufreq_conservative.c | 34 ----------------------
 drivers/cpufreq/cpufreq_governor.c     | 52 ++++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq_ondemand.c     | 34 ----------------------
 include/linux/cpufreq.h                |  5 ++++
 5 files changed, 59 insertions(+), 70 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_governor.c

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 7c620a8..fe4cd26 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -7,8 +7,8 @@ obj-$(CONFIG_CPU_FREQ_STAT)             += cpufreq_stats.o
 obj-$(CONFIG_CPU_FREQ_GOV_PERFORMANCE)	+= cpufreq_performance.o
 obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
 obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
-obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
-obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
+obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o cpufreq_governor.o
+obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o cpufreq_governor.o
 
 # CPUfreq cross-arch helpers
 obj-$(CONFIG_CPU_FREQ_TABLE)		+= freq_table.o
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 55f0354..93b02f4 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -95,40 +95,6 @@ static struct dbs_tuners {
 	.freq_step = 5,
 };
 
-static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
-{
-	u64 idle_time;
-	u64 cur_wall_time;
-	u64 busy_time;
-
-	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-
-	busy_time  = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
-
-	idle_time = cur_wall_time - busy_time;
-	if (wall)
-		*wall = jiffies_to_usecs(cur_wall_time);
-
-	return jiffies_to_usecs(idle_time);
-}
-
-static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
-{
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
-
-	if (idle_time == -1ULL)
-		return get_cpu_idle_time_jiffy(cpu, wall);
-	else
-		idle_time += get_cpu_iowait_time_us(cpu, wall);
-
-	return idle_time;
-}
-
 /* keep track of frequency transitions */
 static int
 dbs_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
new file mode 100644
index 0000000..0001071
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -0,0 +1,52 @@
+/*
+ * drivers/cpufreq/cpufreq_governor.c
+ *
+ * CPUFREQ governors common code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/cputime.h>
+#include <linux/export.h>
+#include <linux/kernel_stat.h>
+#include <linux/tick.h>
+#include <linux/types.h>
+/*
+ * Code picked from earlier governer implementations
+ */
+static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
+{
+	u64 idle_time;
+	u64 cur_wall_time;
+	u64 busy_time;
+
+	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
+
+	busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+
+	idle_time = cur_wall_time - busy_time;
+	if (wall)
+		*wall = jiffies_to_usecs(cur_wall_time);
+
+	return jiffies_to_usecs(idle_time);
+}
+
+cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
+{
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
+
+	if (idle_time == -1ULL)
+		return get_cpu_idle_time_jiffy(cpu, wall);
+	else
+		idle_time += get_cpu_iowait_time_us(cpu, wall);
+
+	return idle_time;
+}
+EXPORT_SYMBOL_GPL(get_cpu_idle_time);
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 14c1af5..964918b 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -119,40 +119,6 @@ static struct dbs_tuners {
 	.powersave_bias = 0,
 };
 
-static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
-{
-	u64 idle_time;
-	u64 cur_wall_time;
-	u64 busy_time;
-
-	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-
-	busy_time  = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
-
-	idle_time = cur_wall_time - busy_time;
-	if (wall)
-		*wall = jiffies_to_usecs(cur_wall_time);
-
-	return jiffies_to_usecs(idle_time);
-}
-
-static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
-{
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
-
-	if (idle_time == -1ULL)
-		return get_cpu_idle_time_jiffy(cpu, wall);
-	else
-		idle_time += get_cpu_iowait_time_us(cpu, wall);
-
-	return idle_time;
-}
-
 static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wall)
 {
 	u64 iowait_time = get_cpu_iowait_time_us(cpu, wall);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index fc4b785..d03c219 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_CPUFREQ_H
 #define _LINUX_CPUFREQ_H
 
+#include <asm/cputime.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/threads.h>
@@ -407,5 +408,9 @@ void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
 
+/*********************************************************************
+ *                     Governor Helpers				     *
+ *********************************************************************/
+cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall);
 
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.7.12.rc2.18.g61b472e


