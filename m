Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HHTsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:48:35 -0400
Received: from smtpout.kotinet.com ([212.50.215.76]:51155 "EHLO
	smtpout.kotinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1HHTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:48:33 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Aug 2011 15:48:33 EDT
Date: Mon, 08 Aug 2011 22:41:08 +0300
From: joni@shade-fx.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: ondemand ignore_nice_level
Message-ID: <4e403bd4.5YAAoSWMDWtU5KOP%joni@shade-fx.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch has been sent earlier to kernel's cpufreq mailing list but
might be good to expose it for discussion also here, because it contains
changes to include/linux/kernel_stat.h, kernel/sched.c and fs/proc/stat.c
files.

This patch add functionality for cpufreq ondemand where user can decide
what nice level will be ignored when ondemand governors ignore_nice_load 
is used. The patch introduces new file ignore_nice_level where nice level can 
be tuned. In other words, user can select processes which can raise cpu
speed by setting processes to certain nice level and tuning ignore level
via ignore_nice_level at /sys/devices/system/cpu/cpufreq/ondemand .

To achieve this, the patch add a new nicevalue[40] array for cpu_usage_stat
struct where it keeps cpu usage statistic for each nice value.
This patch also makes this array visible for user via /proc/stat .
/proc/stat file gets a couple of new lines which corresponds used cpu time
for each nice level and for each cpu core.

Comments are very welcome but please be gentle, this is my very first kernel
patch. :)
Also, this patch lacks of documentation changes but I will add them if
people shows interest for this.

Kind regards

Joni Martikainen



 drivers/cpufreq/cpufreq_ondemand.c |  100 ++++++++++++++++++++++++++++++++++--
 fs/proc/stat.c                     |   33 ++++++++++++
 include/linux/kernel_stat.h        |    9 +++
 kernel/sched.c                     |    6 ++-
 4 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 891360e..3f901b0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -38,6 +38,19 @@
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
 #define MAX_FREQUENCY_UP_THRESHOLD		(100)
 
+/* 
+ * Default priority level where load is consided to be ignored 
+ * Value represents user-nice values [0..19]
+ */
+#define DEF_IGNORE_NICE_LEVEL			(1)
+
+/*
+ * Because only 'user-nice' values from 0 to 19 are available
+ * this value will be used when nice value is calculated on 0 to 39
+ * array ( kstat_cpu(cpu).cpustat.nicevalues[] )
+ */
+#define NICE_BASE_VALUE					(20)
+
 /*
  * The polling frequency of this governor depends on the capability of
  * the processor. Default polling frequency is 1000 times the transition
@@ -108,6 +121,7 @@ static struct dbs_tuners {
 	unsigned int up_threshold;
 	unsigned int down_differential;
 	unsigned int ignore_nice;
+	unsigned int ignore_nice_level;
 	unsigned int sampling_down_factor;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
@@ -116,9 +130,48 @@ static struct dbs_tuners {
 	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
 	.ignore_nice = 0,
+	.ignore_nice_level = DEF_IGNORE_NICE_LEVEL,
 	.powersave_bias = 0,
 };
 
+/* 
+ *  Nice load value which is calculated based on ignore_nice_value 
+ */
+static inline cputime64_t get_niced_cputime(unsigned int cpu)
+{
+	if (dbs_tuners_ins.ignore_nice) {
+		cputime64_t nice = cputime64_zero;
+		int i;
+		for (i=dbs_tuners_ins.ignore_nice_level; 
+				i<MAX_PRIO-MAX_RT_PRIO; i++) 
+		{
+			nice = cputime64_add(nice, 
+					kstat_cpu(cpu).cpustat.nicevalue[NICE_BASE_VALUE+i]);
+		}
+		return nice;
+	} else {
+		return kstat_cpu(cpu).cpustat.nice;
+	}
+}
+
+/* 
+ * Return User load value which is different if ignore_nice_value is
+ * not default 0. If ignore_nice_value is not 0 then load from 
+ * processes with priority > ignore_nice_value will be counted
+ * as User load.
+ */
+static inline cputime64_t get_user_cputime(unsigned int cpu)
+{
+	if (dbs_tuners_ins.ignore_nice) {
+		cputime64_t user = cputime64_zero;
+		user = cputime64_sub(kstat_cpu(cpu).cpustat.nice, get_niced_cputime(cpu));
+		user = cputime64_add(user, kstat_cpu(cpu).cpustat.user);
+		return user;
+	} else {
+		return kstat_cpu(cpu).cpustat.user;
+	}
+}
+
 static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 							cputime64_t *wall)
 {
@@ -254,6 +307,7 @@ show_one(io_is_busy, io_is_busy);
 show_one(up_threshold, up_threshold);
 show_one(sampling_down_factor, sampling_down_factor);
 show_one(ignore_nice_load, ignore_nice);
+show_one(ignore_nice_level, ignore_nice_level);
 show_one(powersave_bias, powersave_bias);
 
 static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
@@ -343,7 +397,43 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			dbs_info->prev_cpu_nice = get_niced_cputime(j);
+
+	}
+	return count;
+}
+
+static ssize_t store_ignore_nice_level(struct kobject *a, struct attribute *b,
+				      const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	unsigned int j;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	/*  Values refers to max and min user-space priorities */
+	if (input > 19)
+		input = 19;
+	if (input < 0)
+		input = 0;
+
+	if (input == dbs_tuners_ins.ignore_nice_level) { /* nothing to do */
+		return count;
+	}
+	dbs_tuners_ins.ignore_nice_level = input;
+
+	/* we need to re-evaluate prev_cpu_idle */
+	for_each_online_cpu(j) {
+		struct cpu_dbs_info_s *dbs_info;
+		dbs_info = &per_cpu(od_cpu_dbs_info, j);
+		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
+						&dbs_info->prev_cpu_wall);
+		if (dbs_tuners_ins.ignore_nice)
+			dbs_info->prev_cpu_nice = get_niced_cputime(j);
 
 	}
 	return count;
@@ -372,6 +462,7 @@ define_one_global_rw(io_is_busy);
 define_one_global_rw(up_threshold);
 define_one_global_rw(sampling_down_factor);
 define_one_global_rw(ignore_nice_load);
+define_one_global_rw(ignore_nice_level);
 define_one_global_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
@@ -380,6 +471,7 @@ static struct attribute *dbs_attributes[] = {
 	&up_threshold.attr,
 	&sampling_down_factor.attr,
 	&ignore_nice_load.attr,
+	&ignore_nice_level.attr,
 	&powersave_bias.attr,
 	&io_is_busy.attr,
 	NULL
@@ -456,7 +548,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+			cur_nice = cputime64_sub(get_niced_cputime(j),
 					 j_dbs_info->prev_cpu_nice);
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -465,7 +557,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			j_dbs_info->prev_cpu_nice = get_niced_cputime(j);
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -646,7 +738,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 						&j_dbs_info->prev_cpu_wall);
 			if (dbs_tuners_ins.ignore_nice) {
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat.nice;
+						get_niced_cputime(j);
 			}
 		}
 		this_dbs_info->cpu = cpu;
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9758b65..e31eed2 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -27,6 +27,12 @@ static int show_stat(struct seq_file *p, void *v)
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest, guest_nice;
+	cputime64_t nice_stats[MAX_PRIO-MAX_RT_PRIO];
+	int k;
+	for(k = 0; k < MAX_PRIO-MAX_RT_PRIO; k++) {
+		nice_stats[k] = cputime64_zero;
+	}
+
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
@@ -75,6 +81,7 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(steal),
 		(unsigned long long)cputime64_to_clock_t(guest),
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
+
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -89,6 +96,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kstat_cpu(i).cpustat.steal;
 		guest = kstat_cpu(i).cpustat.guest;
 		guest_nice = kstat_cpu(i).cpustat.guest_nice;
+
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
@@ -127,6 +135,31 @@ static int show_stat(struct seq_file *p, void *v)
 	for (i = 0; i < NR_SOFTIRQS; i++)
 		seq_printf(p, " %u", per_softirq_sums[i]);
 	seq_putc(p, '\n');
+	/* sum values of all cpus */
+	for_each_possible_cpu(i) {
+		for (k = 0; k < MAX_PRIO-MAX_RT_PRIO; k++) {
+			nice_stats[k] = cputime64_add(nice_stats[k], 
+				kstat_cpu(i).cpustat.nicevalue[k]);
+		}
+	}
+	seq_printf(p, "nice_stats_cpu");
+	for (k = 0; k < MAX_PRIO-MAX_RT_PRIO; k++) {
+		seq_printf(p, " %llu", 
+				(unsigned long long)cputime64_to_clock_t(
+					nice_stats[k]));
+		}
+	seq_putc(p, '\n');
+
+	/* per cpu values */
+	for_each_online_cpu(i) {
+		seq_printf(p, "nice_stats_cpu%d", i);
+		for (k = 0; k < MAX_PRIO-MAX_RT_PRIO; k++) {
+			seq_printf(p, " %llu", 
+					(unsigned long long)cputime64_to_clock_t(
+						kstat_cpu(i).cpustat.nicevalue[k]));
+		}
+		seq_putc(p, '\n');
+	}
 
 	return 0;
 }
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 0cce2db..7397b67 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -9,6 +9,10 @@
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
+#include <linux/sched.h>
+
+
+
 /*
  * 'kernel_stat.h' contains the definitions needed for doing
  * some kernel statistics (CPU usage, context switches ...),
@@ -26,6 +30,11 @@ struct cpu_usage_stat {
 	cputime64_t steal;
 	cputime64_t guest;
 	cputime64_t guest_nice;
+
+	/* Priority value represents user-space priorities
+	 * from 0..39 */
+	cputime64_t nicevalue[MAX_PRIO-MAX_RT_PRIO];
+
 };
 
 struct kernel_stat {
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..687b4a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3755,7 +3755,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
  * @cputime_scaled: cputime scaled by cpu frequency
  */
 void account_user_time(struct task_struct *p, cputime_t cputime,
-		       cputime_t cputime_scaled)
+		cputime_t cputime_scaled)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
@@ -3769,9 +3769,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	tmp = cputime_to_cputime64(cputime);
 	if (TASK_NICE(p) > 0)
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-	else
+	else 
 		cpustat->user = cputime64_add(cpustat->user, tmp);
 
+	cpustat->nicevalue[TASK_USER_PRIO(p)] = cputime64_add(cpustat->nicevalue[TASK_USER_PRIO(p)], tmp);
+
 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
 	acct_update_integrals(p);
