Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab2KWJkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:40:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49846 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106Ab2KWJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:40:10 -0500
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2012 04:40:10 EST
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v4 1/2] cpufreq: ondemand: handle SW coordinated CPUs
Date: Fri, 23 Nov 2012 10:31:56 +0100
Message-Id: <1353663117-10074-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

This patch fixes a bug that occured when we had load on a secondary CPU
and the primary CPU was sleeping. Only one sampling timer was spawned
and it was spawned as a deferred timer on the primary CPU, so when a
secondary CPU had a change in load this was not detected by the ondemand
governor.

This patch make sure that deferred timers are run on all CPUs in the
case of software controlled CPUs that run on the same frequency.

Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
Changes from v3:
- moved update_sampling rate code on 2/2
- simplified dbs_sw_coordinated_cpus
- reworked timer handling for code readability, now:
  * do_dbs_timer() [-> dbs_timer_coordinated()] -> dbs_timer_update()
- simplified cpu_callback cases

 drivers/cpufreq/cpufreq_ondemand.c | 152 ++++++++++++++++++++++++++++++++-----
 1 file changed, 132 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 396322f..849788b 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -93,6 +93,7 @@ struct cpu_dbs_info_s {
 	 * when user is changing the governor or limits.
 	 */
 	struct mutex timer_mutex;
+	ktime_t time_stamp;
 };
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, od_cpu_dbs_info);
 
@@ -449,6 +450,13 @@ static struct attribute_group dbs_attr_group = {
 
 /************************** sysfs end ************************/
 
+static bool dbs_sw_coordinated_cpus(struct cpu_dbs_info_s *dbs_info)
+{
+	struct cpufreq_policy *policy = dbs_info->cur_policy;
+
+	return cpumask_weight(policy->cpus) > 1;
+}
+
 static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 {
 	if (dbs_tuners_ins.powersave_bias)
@@ -596,22 +604,18 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 	}
 }
 
-static void do_dbs_timer(struct work_struct *work)
+static void dbs_timer_update(struct cpu_dbs_info_s *dbs_info, bool sample,
+			     struct delayed_work *dw)
 {
-	struct cpu_dbs_info_s *dbs_info =
-		container_of(work, struct cpu_dbs_info_s, work.work);
-	unsigned int cpu = dbs_info->cpu;
 	int sample_type = dbs_info->sample_type;
-
 	int delay;
 
-	mutex_lock(&dbs_info->timer_mutex);
-
 	/* Common NORMAL_SAMPLE setup */
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	if (!dbs_tuners_ins.powersave_bias ||
 	    sample_type == DBS_NORMAL_SAMPLE) {
-		dbs_check_cpu(dbs_info);
+		if (sample)
+			dbs_check_cpu(dbs_info);
 		if (dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			dbs_info->sample_type = DBS_SUB_SAMPLE;
@@ -627,32 +631,80 @@ static void do_dbs_timer(struct work_struct *work)
 				delay -= jiffies % delay;
 		}
 	} else {
-		__cpufreq_driver_target(dbs_info->cur_policy,
-			dbs_info->freq_lo, CPUFREQ_RELATION_H);
+		if (sample)
+			__cpufreq_driver_target(dbs_info->cur_policy,
+						dbs_info->freq_lo,
+						CPUFREQ_RELATION_H);
 		delay = dbs_info->freq_lo_jiffies;
 	}
-	schedule_delayed_work_on(cpu, &dbs_info->work, delay);
+	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+}
+
+static void dbs_timer_coordinated(struct cpu_dbs_info_s *dbs_info_local,
+				  struct delayed_work *dw)
+{
+	struct cpu_dbs_info_s *dbs_info;
+	ktime_t time_now;
+	s64 delta_us;
+	bool sample = true;
+
+	/* use leader CPU's dbs_info */
+	dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info_local->cpu);
+	mutex_lock(&dbs_info->timer_mutex);
+
+	time_now = ktime_get();
+	delta_us = ktime_us_delta(time_now, dbs_info->time_stamp);
+
+	/* Do nothing if we recently have sampled */
+	if (delta_us < (s64)(dbs_tuners_ins.sampling_rate / 2))
+		sample = false;
+	else
+		dbs_info->time_stamp = time_now;
+
+	dbs_timer_update(dbs_info, sample, dw);
 	mutex_unlock(&dbs_info->timer_mutex);
 }
 
-static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
+static void do_dbs_timer(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct cpu_dbs_info_s *dbs_info =
+		container_of(work, struct cpu_dbs_info_s, work.work);
+
+	if (dbs_sw_coordinated_cpus(dbs_info)) {
+		dbs_timer_coordinated(dbs_info, dw);
+	} else {
+		mutex_lock(&dbs_info->timer_mutex);
+		dbs_timer_update(dbs_info, true, dw);
+		mutex_unlock(&dbs_info->timer_mutex);
+	}
+}
+
+static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info, int cpu)
 {
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
+	struct cpu_dbs_info_s *dbs_info_local = &per_cpu(od_cpu_dbs_info, cpu);
 
 	if (num_online_cpus() > 1)
 		delay -= jiffies % delay;
 
+	cancel_delayed_work_sync(&dbs_info_local->work);
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
-	INIT_DEFERRABLE_WORK(&dbs_info->work, do_dbs_timer);
-	schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work, delay);
+	schedule_delayed_work_on(cpu, &dbs_info_local->work, delay);
 }
 
-static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
+static inline void dbs_timer_exit(int cpu)
 {
+	struct cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
+static void dbs_timer_exit_per_cpu(struct work_struct *dummy)
+{
+	dbs_timer_exit(smp_processor_id());
+}
+
 /*
  * Not all CPUs want IO time to be accounted as busy; this dependson how
  * efficient idling at a higher frequency/voltage is.
@@ -676,6 +728,41 @@ static int should_io_be_busy(void)
 	return 0;
 }
 
+static int __cpuinit cpu_callback(struct notifier_block *nfb,
+				  unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct device *cpu_dev;
+	struct cpu_dbs_info_s *dbs_info;
+
+	dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
+
+	/* use leader CPU's dbs_info */
+	if (dbs_sw_coordinated_cpus(dbs_info))
+		dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info->cpu);
+
+	cpu_dev = get_cpu_device(cpu);
+	if (cpu_dev) {
+		switch (action) {
+		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
+		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
+			dbs_timer_init(dbs_info, cpu);
+			break;
+		case CPU_DOWN_PREPARE:
+		case CPU_DOWN_PREPARE_FROZEN:
+			dbs_timer_exit(cpu);
+			break;
+		}
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __refdata ondemand_cpu_notifier = {
+	.notifier_call = cpu_callback,
+};
+
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
@@ -704,9 +791,13 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
 						kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+
+			mutex_init(&j_dbs_info->timer_mutex);
+			INIT_DEFERRABLE_WORK(&j_dbs_info->work, do_dbs_timer);
+
+			j_dbs_info->rate_mult = 1;
 		}
 		this_dbs_info->cpu = cpu;
-		this_dbs_info->rate_mult = 1;
 		ondemand_powersave_bias_init_cpu(cpu);
 		/*
 		 * Start the timerschedule work, when this governor
@@ -736,21 +827,42 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		}
 		mutex_unlock(&dbs_mutex);
 
-		mutex_init(&this_dbs_info->timer_mutex);
-		dbs_timer_init(this_dbs_info);
+		/* If SW coordinated CPUs then register notifier */
+		if (dbs_sw_coordinated_cpus(this_dbs_info)) {
+			register_hotcpu_notifier(&ondemand_cpu_notifier);
+
+			/* Initiate timer time stamp */
+			this_dbs_info->time_stamp = ktime_get();
+
+			for_each_cpu(j, policy->cpus) {
+				struct cpu_dbs_info_s *j_dbs_info;
+
+				j_dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
+				dbs_timer_init(j_dbs_info, j);
+			}
+		} else {
+			dbs_timer_init(this_dbs_info, cpu);
+		}
 		break;
 
 	case CPUFREQ_GOV_STOP:
-		dbs_timer_exit(this_dbs_info);
+		dbs_timer_exit(cpu);
 
 		mutex_lock(&dbs_mutex);
 		mutex_destroy(&this_dbs_info->timer_mutex);
 		dbs_enable--;
 		mutex_unlock(&dbs_mutex);
-		if (!dbs_enable)
+		if (!dbs_enable) {
 			sysfs_remove_group(cpufreq_global_kobject,
 					   &dbs_attr_group);
 
+			if (dbs_sw_coordinated_cpus(this_dbs_info)) {
+				/* Make sure all pending timers/works are
+				 * stopped. */
+				schedule_on_each_cpu(dbs_timer_exit_per_cpu);
+				unregister_hotcpu_notifier(&ondemand_cpu_notifier);
+			}
+		}
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
-- 
1.7.12.1

