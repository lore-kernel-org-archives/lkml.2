Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2BVID6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:03:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30545 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2BVIDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:03:34 -0500
X-AuditID: cbfee61b-b7c62ae000000989-04-4f44a154d375
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: [RFC PATCH 2/2] CPUfreq ondemand: handle QoS request on DVFS response
 latency
Date: Wed, 22 Feb 2012 17:03:35 +0900
Message-id: <1329897815-15871-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
References: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com>
 <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With QoS class, DVFS_RESPONSE_LATENCY, users (device drivers and
userspace processes) may express the desired maximum response latency
from DVFS mechanisms such as CPUfreq's ondemand governors. Based on such
QoS requests, the ondemand governor may flexibly adjust sampling rate
accordingly unless it goes below the min_sampling_rate.

The benefit of having DVFS_RESPONSE_LATENCY is to have faster response
from user inputs (mouse clicks, keyboard inputs, touchscreen touches,
and others) without increasing frequency unconditionally. Because some
input events may not require any performance increases, increasing the
frequency unconditionally for inputs may simply consume too much energy.
Adjusting sampling rate based on user inputs enabled to increase
frequency with less latency if it requires and not to increase frequency
if it does not require.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
This patch depends on the patch
"PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency".
and the patch
"CPUfreq ondemand: update sampling rate without waiting for next
sampling"
---
 drivers/cpufreq/cpufreq_ondemand.c |  108 ++++++++++++++++++++++++++++++++----
 1 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 2d66649..b9188f1 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/pm_qos.h>
 
 /*
  * dbs is used in this file as a shortform for demandbased switching
@@ -93,6 +94,7 @@ struct cpu_dbs_info_s {
 	 * when user is changing the governor or limits.
 	 */
 	struct mutex timer_mutex;
+	bool activated; /* dbs_timer_init is in effect */
 };
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, od_cpu_dbs_info);
 
@@ -111,6 +113,8 @@ static struct dbs_tuners {
 	unsigned int sampling_down_factor;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
+	struct notifier_block dvfs_lat_qos_db;
+	unsigned int dvfs_lat_qos_wants;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
@@ -164,6 +168,23 @@ static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wal
 }
 
 /*
+ * Find right sampling rate based on sampling_rate and
+ * QoS requests on dvfs latency.
+ */
+static unsigned int effective_sampling_rate(void)
+{
+	unsigned int effective;
+
+	if (dbs_tuners_ins.dvfs_lat_qos_wants)
+		effective = min(dbs_tuners_ins.dvfs_lat_qos_wants,
+				dbs_tuners_ins.sampling_rate);
+	else
+		effective = dbs_tuners_ins.sampling_rate;
+
+	return max(effective, min_sampling_rate);
+}
+
+/*
  * Find right freq to be set now with powersave_bias on.
  * Returns the freq_hi to be used right now and will set freq_hi_jiffies,
  * freq_lo, and freq_lo_jiffies in percpu area for averaging freqs.
@@ -207,7 +228,7 @@ static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
 		dbs_info->freq_lo_jiffies = 0;
 		return freq_lo;
 	}
-	jiffies_total = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
+	jiffies_total = usecs_to_jiffies(effective_sampling_rate());
 	jiffies_hi = (freq_avg - freq_lo) * jiffies_total;
 	jiffies_hi += ((freq_hi - freq_lo) / 2);
 	jiffies_hi /= (freq_hi - freq_lo);
@@ -259,7 +280,8 @@ show_one(powersave_bias, powersave_bias);
 
 /**
  * update_sampling_rate - update sampling rate effective immediately if needed.
- * @new_rate: new sampling rate
+ * @new_rate: new sampling rate. if it is 0, regard sampling rate is not
+ *		changed and assume that qos request value is changed.
  *
  * If new rate is smaller than the old, simply updaing
  * dbs_tuners_int.sampling_rate might not be appropriate. For example,
@@ -273,9 +295,13 @@ show_one(powersave_bias, powersave_bias);
 static void update_sampling_rate(unsigned int new_rate)
 {
 	int cpu;
+	unsigned int effective;
+
+
+	if (new_rate)
+		dbs_tuners_ins.sampling_rate = max(new_rate, min_sampling_rate);
 
-	dbs_tuners_ins.sampling_rate = new_rate
-				     = max(new_rate, min_sampling_rate);
+	effective = effective_sampling_rate();
 
 	for_each_online_cpu(cpu) {
 		struct cpufreq_policy *policy;
@@ -283,21 +309,31 @@ static void update_sampling_rate(unsigned int new_rate)
 		struct timer_list *timer;
 		unsigned long appointed_at;
 
+		/*
+		 * mutex_destory(&dbs_info->timer_mutex) should not happen
+		 * in this context.
+		 */
+		mutex_lock(&dbs_mutex);
+
 		policy = cpufreq_cpu_get(cpu);
 		if (!policy)
-			continue;
+			goto next;
 		dbs_info = &per_cpu(od_cpu_dbs_info, policy->cpu);
 		cpufreq_cpu_put(policy);
 
+		/* timer_mutex destroyed or will be destoyed soon */
+		if (!dbs_info->activated)
+			goto next;
+
 		mutex_lock(&dbs_info->timer_mutex);
 
 		if (!delayed_work_pending(&dbs_info->work))
-			goto next;
+			goto next_timer_mutex;
 
 		timer = &dbs_info->work.timer;
 		appointed_at = timer->expires;
 
-		if (time_before(jiffies + usecs_to_jiffies(new_rate),
+		if (time_before(jiffies + usecs_to_jiffies(effective),
 				appointed_at)) {
 
 			mutex_unlock(&dbs_info->timer_mutex);
@@ -305,12 +341,15 @@ static void update_sampling_rate(unsigned int new_rate)
 			mutex_lock(&dbs_info->timer_mutex);
 
 			schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work,
-						 usecs_to_jiffies(new_rate));
+						 usecs_to_jiffies(effective));
 
 		}
-next:
+next_timer_mutex:
 		mutex_unlock(&dbs_info->timer_mutex);
+next:
+		mutex_unlock(&dbs_mutex);
 	}
+
 }
 
 static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
@@ -620,7 +659,7 @@ static void do_dbs_timer(struct work_struct *work)
 			/* We want all CPUs to do sampling nearly on
 			 * same jiffy
 			 */
-			delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate
+			delay = usecs_to_jiffies(effective_sampling_rate()
 				* dbs_info->rate_mult);
 
 			if (num_online_cpus() > 1)
@@ -638,7 +677,7 @@ static void do_dbs_timer(struct work_struct *work)
 static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 {
 	/* We want all CPUs to do sampling nearly on same jiffy */
-	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
+	int delay = usecs_to_jiffies(effective_sampling_rate());
 
 	if (num_online_cpus() > 1)
 		delay -= jiffies % delay;
@@ -646,10 +685,12 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
 	schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work, delay);
+	dbs_info->activated = true;
 }
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 {
+	dbs_info->activated = false;
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
@@ -767,10 +808,39 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
+/**
+ * qos_dvfs_lat_notify - PM QoS Notifier for DVFS_LATENCY QoS Request
+ * @nb		notifier block struct
+ * @value	QoS value
+ * @dummy
+ */
+static int qos_dvfs_lat_notify(struct notifier_block *nb, unsigned long value,
+			       void *dummy)
+{
+	/*
+	 * In the worst case, with a continuous up-treshold + e cpu load
+	 * from up-threshold - e load, the ondemand governor will react
+	 * sampling_rate * 2.
+	 *
+	 * Thus, based on the worst case scenario, we use value / 2;
+	 */
+	dbs_tuners_ins.dvfs_lat_qos_wants = value / 2;
+
+	/* Update sampling rate */
+	update_sampling_rate(0);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ondemand_qos_dvfs_lat_nb = {
+	.notifier_call = qos_dvfs_lat_notify,
+};
+
 static int __init cpufreq_gov_dbs_init(void)
 {
 	u64 idle_time;
 	int cpu = get_cpu();
+	int err = 0;
 
 	idle_time = get_cpu_idle_time_us(cpu, NULL);
 	put_cpu();
@@ -791,11 +861,25 @@ static int __init cpufreq_gov_dbs_init(void)
 			MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(10);
 	}
 
-	return cpufreq_register_governor(&cpufreq_gov_ondemand);
+	err = pm_qos_add_notifier(PM_QOS_DVFS_RESPONSE_LATENCY,
+			    &ondemand_qos_dvfs_lat_nb);
+	if (err)
+		return err;
+
+	err = cpufreq_register_governor(&cpufreq_gov_ondemand);
+	if (err) {
+		pm_qos_remove_notifier(PM_QOS_DVFS_RESPONSE_LATENCY,
+				       &ondemand_qos_dvfs_lat_nb);
+	}
+
+	return err;
 }
 
 static void __exit cpufreq_gov_dbs_exit(void)
 {
+	pm_qos_remove_notifier(PM_QOS_DVFS_RESPONSE_LATENCY,
+			       &ondemand_qos_dvfs_lat_nb);
+
 	cpufreq_unregister_governor(&cpufreq_gov_ondemand);
 }
 
-- 
1.7.4.1

