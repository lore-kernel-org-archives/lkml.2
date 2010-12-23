Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0LWGOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:14:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:54294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab0LWGOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:14:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="690073765"
From: Youquan Song <youquan.song@intel.com>
To: davej@redhat.com, cpufreq@vger.kernle.org
Cc: venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 1/6] cpufreq: Add sampling window for ondemand governor
Date: Thu, 23 Dec 2010 14:17:01 +0800
Message-Id: <1293085026-18173-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1293085026-18173-1-git-send-email-youquan.song@intel.com>
References: <1293085026-18173-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a well-known power performance benchmark, current ondemand governor is
not power efficiency. Even when workload is at 10%~20% of full capability, the
CPU will also run much of time at highest frequency. In fact, in this situation,
the lowest frequency often can meet user requirement. When running this
this benchmark on turbo mode enable machine, I compare the result of different
governors, the results of ondemand and performance governors are the closest.
There is no much power saving between ondemand and performance governor. If we
can ignore the little power saving, the perfomance governor even better than 
ondemand governor, at leaset for better performance. 

One potential reason for ondemand governor is not power efficiency is that
ondemand governor decide the next target frequency by instant requirement during
sampling interval (10ms or possible a little longer for deferrable timer in idle
tickless). The instant requirement can response quickly to workload change, but
it does not usually reflect workload real CPU usage requirement in a small 
longer time and it possibly causes frequently change between highest and lowest
frequency.     

This patch add a sampling window for percpu ondemand thread. Each sampling
window with max 150 record items which slide every sampling interval and use to
track the workload requirement during latest sampling window timeframe. 
The average of workload during latest sample windows will be used to decide next
target frequency. The sampling window targets to be more truly reflects workload
requirement of CPU usage in the short recent. 

The sampling window size also can be dynamicly changed in according to current
system workload busy situation. The more idle, the smaller sampling window; the
more busy, the larger sampling window. It will increase the respnose speed by
decrease sampling window, while it will keep CPU working at high speed when busy
by increase sampling window and also avoid unefficiently dangle between highest
and lowest frequency in original ondemand.

It set up_threshold to 80 and down_differential to 20, so when workload reach
 80% of current frequency, it will increase to highest frequency. When workload
decrease to below (up_threshold - down_differential)60% of current frequency
capability, it will decrease the frequency, which ensure that CPU work above 60%
of its current capability, otherwise lowest frequency will be used. 
   
On my test platform with two sockets Westmere-EP server and run the well-known
power performance benchmark, when workload is low, the patched governor is 
power saving like powersave governor; while workload is high, the patched 
governor is as good as performance governor but the patched governor consume
less power than performance governor. Along with other patches in this patchset,
the patched governor power efficiey is improved about 10%, while the performance
has no apparently decrease.
Running other benchmarks in phoronix, kernel building save 5% power, while the
performance without decrease. compress-7zip save power 2%, while the performance
also does not apparently decrease. However, apache benchmark saves power but its
performance decrease a lot.


Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |  177 ++++++++++++++++++++++++++++++++++-
 1 files changed, 171 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c631f27..e49b2e1 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 /*
  * dbs is used in this file as a shortform for demandbased switching
@@ -37,6 +38,14 @@
 #define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
 #define MAX_FREQUENCY_UP_THRESHOLD		(100)
+/*Default sampling window : 1 second */
+#define DEF_SAMPLING_WINDOW			(1000000)
+
+/* Max number of history records */
+#define MAX_LOAD_RECORD_NUM			(150)
+
+#define SAMPLING_WINDOW_UP_THRESHOLD		(80)
+#define SAMPLING_WINDOW_DOWN_DIFFERENTIAL	(20)
 
 /*
  * The polling frequency of this governor depends on the capability of
@@ -73,6 +82,13 @@ struct cpufreq_governor cpufreq_gov_ondemand = {
 /* Sampling types */
 enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE};
 
+/* Sampling record */
+struct load_record {
+	unsigned long load_freq;
+	unsigned int wall_time;
+	unsigned int idle_time;
+};
+
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
 	cputime64_t prev_cpu_iowait;
@@ -81,6 +97,13 @@ struct cpu_dbs_info_s {
 	struct cpufreq_policy *cur_policy;
 	struct delayed_work work;
 	struct cpufreq_frequency_table *freq_table;
+	struct load_record *lr;		/* Load history record */
+	unsigned long total_load;	/* Sum of load in sampling window */
+	unsigned int total_wtime;	/* Sum of time in sampling window */
+	unsigned int total_itime;	/* Sum of idle time in sampling window*/
+	unsigned int start_p;		/* Start position of sampling window */
+	unsigned int cur_p;		/* Current position of sampling window*/
+	unsigned int cur_sw;		/* Current sampling window size */
 	unsigned int freq_lo;
 	unsigned int freq_lo_jiffies;
 	unsigned int freq_hi_jiffies;
@@ -97,6 +120,7 @@ struct cpu_dbs_info_s {
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, od_cpu_dbs_info);
 
 static unsigned int dbs_enable;	/* number of CPUs using this policy */
+static unsigned int sampling_window_enable; /* only use in HW_ALL */
 
 /*
  * dbs_mutex protects data in dbs_tuners_ins from concurrent changes on
@@ -114,12 +138,16 @@ static struct dbs_tuners {
 	unsigned int sampling_down_factor;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
+	unsigned int sampling_window;
+	unsigned int window_is_dynamic;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
 	.ignore_nice = 0,
 	.powersave_bias = 0,
+	.sampling_window = DEF_SAMPLING_WINDOW,
+	.window_is_dynamic = 1,
 };
 
 static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
@@ -501,9 +529,79 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
 }
 
+/* According to workload busy status to dynamic change sampling window,
+ * more idle, sampling window is smaller in proportion of current sampling
+ * window
+ */
+static unsigned int get_dynamic_sampling_window(struct cpu_dbs_info_s *dbs)
+{
+	unsigned int sampling_window = 0;
+	unsigned int busy_rate = 0;
+
+	if (dbs_tuners_ins.window_is_dynamic) {
+		busy_rate = (dbs->total_wtime - dbs->total_itime)
+			* 100 / dbs->total_wtime;
+
+		sampling_window = (dbs_tuners_ins.sampling_window * busy_rate)
+			/ 100;
+
+		if (sampling_window < dbs_tuners_ins.sampling_rate)
+			sampling_window = dbs_tuners_ins.sampling_rate;
+	} else
+		sampling_window = dbs_tuners_ins.sampling_window;
+
+	return sampling_window;
+}
+
+/* Get the average load during one sampling window */
+static unsigned long get_load_freq_during_sampling_window(
+		struct cpu_dbs_info_s *this_dbs_info, unsigned long load_freq,
+		unsigned int wall_time, unsigned int idle_time)
+{
+
+	unsigned int cur_p = 0, start_p = 0;
+
+	cur_p = this_dbs_info->cur_p;
+	start_p = this_dbs_info->start_p;
+	/* Record current sampling result */
+	this_dbs_info->lr[cur_p].load_freq = load_freq;
+	this_dbs_info->lr[cur_p].wall_time = wall_time;
+	this_dbs_info->lr[cur_p].idle_time = idle_time;
+	/* Cumulate records in sampling windows */
+	this_dbs_info->total_load += load_freq;
+	this_dbs_info->total_wtime += wall_time;
+	this_dbs_info->total_itime += idle_time;
+	this_dbs_info->cur_p = (cur_p + 1) % MAX_LOAD_RECORD_NUM;
+
+	/* Dynamicly get sampling window if sampling_is_dynamic set */
+	this_dbs_info->cur_sw = get_dynamic_sampling_window(this_dbs_info);
+
+	/* Find work load during the lastest sampling window */
+	while (this_dbs_info->total_wtime - this_dbs_info->lr[start_p].wall_time
+			 > this_dbs_info->cur_sw) {
+
+		this_dbs_info->total_wtime -=
+				this_dbs_info->lr[start_p].wall_time;
+		this_dbs_info->total_itime -=
+				this_dbs_info->lr[start_p].idle_time;
+		this_dbs_info->total_load -=
+				this_dbs_info->lr[start_p].load_freq;
+		start_p = (start_p + 1) % MAX_LOAD_RECORD_NUM;
+		this_dbs_info->start_p = start_p;
+	}
+
+	/* Get the average load in the lastest sampling window */
+	load_freq = this_dbs_info->total_load / this_dbs_info->total_wtime;
+
+	load_freq *= 100;
+	return load_freq;
+}
+
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
-	unsigned int max_load_freq;
+	unsigned long max_load_freq;
+	unsigned int max_wall_time;
+	unsigned int max_idle_time;
 
 	struct cpufreq_policy *policy;
 	unsigned int j;
@@ -525,12 +623,14 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 	/* Get Absolute Load - in terms of freq */
 	max_load_freq = 0;
+	max_wall_time = 0;
+	max_idle_time = 0;
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
 		cputime64_t cur_wall_time, cur_idle_time, cur_iowait_time;
+		unsigned long load_freq, load;
 		unsigned int idle_time, wall_time, iowait_time;
-		unsigned int load, load_freq;
 		int freq_avg;
 
 		j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
@@ -580,17 +680,28 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
-		load = 100 * (wall_time - idle_time) / wall_time;
+		load = wall_time - idle_time;
 
 		freq_avg = __cpufreq_driver_getavg(policy, j);
 		if (freq_avg <= 0)
 			freq_avg = policy->cur;
 
 		load_freq = load * freq_avg;
-		if (load_freq > max_load_freq)
+		if (load_freq > max_load_freq) {
 			max_load_freq = load_freq;
+			max_wall_time = wall_time;
+			max_idle_time = idle_time;
+		}
 	}
 
+	if (sampling_window_enable)
+		/* Get the average load in the lastest sampling window */
+		max_load_freq = get_load_freq_during_sampling_window(
+				this_dbs_info, max_load_freq,
+				max_wall_time, max_idle_time);
+	else
+		max_load_freq = (100 * max_load_freq) / max_wall_time;
+
 	/* Check for frequency increase */
 	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
 		/* If switching to max speed, apply sampling_down_factor */
@@ -713,6 +824,54 @@ static int should_io_be_busy(void)
 	return 0;
 }
 
+/* Initialize dbs_info struct */
+static int dbs_info_init(struct cpu_dbs_info_s *this_dbs_info,
+		struct cpufreq_policy *policy, unsigned int cpu)
+{
+	this_dbs_info->cpu = cpu;
+	this_dbs_info->rate_mult = 1;
+	/* Sampling windows only used in HW_ALL coordination */
+	if (cpumask_weight(policy->cpus) > 1)
+		return 0;
+
+	this_dbs_info->start_p = 0;
+	this_dbs_info->cur_p = 1;
+	this_dbs_info->total_wtime = 0;
+	this_dbs_info->total_itime = 0;
+	this_dbs_info->total_load = 0;
+	/* Initiate the load record */
+	this_dbs_info->lr = kmalloc(sizeof(struct load_record) *
+			(MAX_LOAD_RECORD_NUM), GFP_KERNEL);
+	if (!this_dbs_info->lr) {
+		printk(KERN_ERR "Malloc DBS load record failed\n");
+		return -EFAULT;
+	}
+
+	this_dbs_info->lr[0].load_freq = 0;
+	this_dbs_info->lr[0].wall_time = 0;
+	this_dbs_info->lr[0].idle_time = 0;
+	sampling_window_enable = 1;
+	dbs_tuners_ins.up_threshold = SAMPLING_WINDOW_UP_THRESHOLD;
+	dbs_tuners_ins.down_differential = SAMPLING_WINDOW_DOWN_DIFFERENTIAL;
+	return 0;
+
+}
+
+
+/* Free the load record buffer */
+static void destroy_dbs_info(void)
+{
+	struct cpu_dbs_info_s *dbs_info = NULL;
+	int i;
+	if (!sampling_window_enable)
+		return;
+
+	for_each_online_cpu(i) {
+		dbs_info = &per_cpu(od_cpu_dbs_info, i);
+		kfree(dbs_info->lr);
+	}
+}
+
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
@@ -749,8 +908,13 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 						kstat_cpu(j).cpustat.nice;
 			}
 		}
-		this_dbs_info->cpu = cpu;
-		this_dbs_info->rate_mult = 1;
+
+		rc = dbs_info_init(this_dbs_info, policy, cpu);
+		if (rc) {
+			mutex_unlock(&dbs_mutex);
+			return rc;
+		}
+
 		ondemand_powersave_bias_init_cpu(cpu);
 		/*
 		 * Start the timerschedule work, when this governor
@@ -854,6 +1018,7 @@ static void __exit cpufreq_gov_dbs_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_ondemand);
 	destroy_workqueue(kondemand_wq);
+	destroy_dbs_info();
 }
 
 
-- 
1.6.4.2

