Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1GZRWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:22:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:41539 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1GZRWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:22:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,270,1309762800"; 
   d="scan'208";a="32520135"
From: "Yung, Winson W" <winson.w.yung@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "venki@google.com" <venki@google.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Date: Tue, 26 Jul 2011 11:22:32 -0600
Subject: [PATCH] [RFC] ondemand governor: dynamic cpufreq scaling with
 different CPUs
Thread-Topic: [PATCH] [RFC] ondemand governor: dynamic cpufreq scaling with
 different CPUs
Thread-Index: AQHMS7iaCT3MiLpmIkOQgbMh9iOTcQ==
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F12470191AAD4C3@rrsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with using delayed work queue inside ondemand governor, I came to
realize that there are certain scenarios the governor may not
re-adjust cpu frequency swiftly for some duration. Here is a
brief description of the problem:

Currently when ondemand governor starts, it will create kthreads
for each CPU, something like kondemand/0, kondemand/1 and so on.
I found from ftrace that kondemand/0 is the only kthread that
handles all the CPU frequency dynamic cpu frequency scaling, other
kthread such as kondemand/1 is never used. I also confirmed this
by debugging through the kernel code.

So if there is no timer fired on CPU-0 (i.e. CPU-0 in C6), hence
no deferrable timers will ever fired by kondemand/0 to sample all
CPU workload. Since it is the only kthread doing the CPU freqency
scaling for all CPUs, it is possible to enter in the situation
where CPU frequency scaling will stop working for some duration
until CPU-0 becomes not idle again.

Signed-off-by: Hari K Kanigeri <hari.kkanigeri@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   93 +++++++++++++++++++++++++++++++----
 include/linux/cpufreq.h            |    3 +
 2 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 891360e..b4f4f9d 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -541,6 +541,9 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 static void do_dbs_timer(struct work_struct *work)
 {
+	u64 old_time, new_do_dbs_time;
+	u64 saved_last_time;
+	
 	struct cpu_dbs_info_s *dbs_info =
 		container_of(work, struct cpu_dbs_info_s, work.work);
 	unsigned int cpu = dbs_info->cpu;
@@ -548,6 +551,41 @@ static void do_dbs_timer(struct work_struct *work)
 
 	int delay;
 
+	new_do_dbs_time = get_jiffies_64();
+
+	/* Save a copy of last_do_dbs_time do_dbs_timer */
+
+	saved_last_time = atomic64_read(
+		&dbs_info->cur_policy->last_do_dbs_time);
+
+	/* If the last time do_dbs_timer ran is less than */
+	/* 'delay' delta from current time, one of other  */
+	/* CPUs is still handling cpufreq governoring for */
+	/* for all CPUs. */
+
+	if ((new_do_dbs_time - saved_last_time) <
+		dbs_info->cur_policy->last_delay) {
+
+		/* If do_dbs_time ran not long ago */
+		/* (delta is less than last_delay) */
+		/* then bail out because there is  */
+		/* no need to run so frequently.   */
+		goto do_exit;
+	}
+
+	old_time = atomic64_cmpxchg(&dbs_info->cur_policy->last_do_dbs_time,
+					saved_last_time, new_do_dbs_time);
+
+	/* If old_time is not equal to saved_last_time, */ 
+	/* it means another CPU is calling do_dbs_time. */
+
+	if (old_time != saved_last_time)
+		goto do_exit;
+
+	/* Switch cpu saved in the policy */
+	if (dbs_info->cur_policy->cpu != cpu)
+		dbs_info->cur_policy->cpu = cpu;
+
 	mutex_lock(&dbs_info->timer_mutex);
 
 	/* Common NORMAL_SAMPLE setup */
@@ -559,6 +597,7 @@ static void do_dbs_timer(struct work_struct *work)
 			/* Setup timer for SUB_SAMPLE */
 			dbs_info->sample_type = DBS_SUB_SAMPLE;
 			delay = dbs_info->freq_hi_jiffies;
+			dbs_info->cur_policy->last_delay = delay;
 		} else {
 			/* We want all CPUs to do sampling nearly on
 			 * same jiffy
@@ -566,14 +605,18 @@ static void do_dbs_timer(struct work_struct *work)
 			delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate
 				* dbs_info->rate_mult);
 
-			if (num_online_cpus() > 1)
+			if (num_online_cpus() > 1) {
 				delay -= jiffies % delay;
+				dbs_info->cur_policy->last_delay = delay;
+			}
 		}
 	} else {
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
 		delay = dbs_info->freq_lo_jiffies;
+		dbs_info->cur_policy->last_delay = delay;
 	}
+do_exit:
 	schedule_delayed_work_on(cpu, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
 }
@@ -648,10 +691,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				j_dbs_info->prev_cpu_nice =
 						kstat_cpu(j).cpustat.nice;
 			}
+
+			j_dbs_info->cpu = j;
+			j_dbs_info->rate_mult = 1;
+			ondemand_powersave_bias_init_cpu(j);
 		}
-		this_dbs_info->cpu = cpu;
-		this_dbs_info->rate_mult = 1;
-		ondemand_powersave_bias_init_cpu(cpu);
+
 		/*
 		 * Start the timerschedule work, when this governor
 		 * is used for first time
@@ -680,32 +725,58 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		}
 		mutex_unlock(&dbs_mutex);
 
-		mutex_init(&this_dbs_info->timer_mutex);
-		dbs_timer_init(this_dbs_info);
+		for_each_cpu(j, policy->cpus) {
+			struct cpu_dbs_info_s *j_dbs_info;
+			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
+			mutex_init(&j_dbs_info->timer_mutex);
+			dbs_timer_init(j_dbs_info);
+		}
 		break;
 
 	case CPUFREQ_GOV_STOP:
-		dbs_timer_exit(this_dbs_info);
+		for_each_cpu(j, policy->cpus) {
+			struct cpu_dbs_info_s *j_dbs_info;
+			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
+			dbs_timer_exit(j_dbs_info);
+		}
 
 		mutex_lock(&dbs_mutex);
-		mutex_destroy(&this_dbs_info->timer_mutex);
+
+		for_each_cpu(j, policy->cpus) {
+			struct cpu_dbs_info_s *j_dbs_info;
+			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
+			mutex_destroy(&j_dbs_info->timer_mutex);
+		}
+
 		dbs_enable--;
 		mutex_unlock(&dbs_mutex);
 		if (!dbs_enable)
 			sysfs_remove_group(cpufreq_global_kobject,
 					   &dbs_attr_group);
-
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
-		mutex_lock(&this_dbs_info->timer_mutex);
+		/* Since ondemand governor is no longer running on the */
+		/* same CPU anymore,need to mutex_lock all timer_mutex */
+		/* before calling __cpufreq_driver_target. */
+		for_each_cpu(j, policy->cpus) {
+			struct cpu_dbs_info_s *j_dbs_info;
+			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
+			mutex_lock(&j_dbs_info->timer_mutex);
+		}
+
 		if (policy->max < this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(this_dbs_info->cur_policy,
 				policy->max, CPUFREQ_RELATION_H);
 		else if (policy->min > this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(this_dbs_info->cur_policy,
 				policy->min, CPUFREQ_RELATION_L);
-		mutex_unlock(&this_dbs_info->timer_mutex);
+
+		for_each_cpu(j, policy->cpus) {
+			struct cpu_dbs_info_s *j_dbs_info;
+			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
+			mutex_unlock(&j_dbs_info->timer_mutex);
+		}
 		break;
 	}
 	return 0;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 11be48e..2295a35 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -106,6 +106,9 @@ struct cpufreq_policy {
 
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+
+	atomic64_t		last_do_dbs_tim;
+	int			last_delay;
 };
 
 #define CPUFREQ_ADJUST		(0)
-- 
1.7.1

