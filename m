Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2KZQlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:41:00 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54401 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab2KZQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:40:57 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/5] cpufreq: ondemand: call dbs_check_cpu only when necessary
Date: Mon, 26 Nov 2012 17:39:54 +0100
Message-Id: <1353947996-26723-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify ondemand timer to not resample CPU utilization if recently
sampled from another SW coordinated core.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_governor.c |  3 ++
 drivers/cpufreq/cpufreq_governor.h |  1 +
 drivers/cpufreq/cpufreq_ondemand.c | 58 +++++++++++++++++++++++++++++++-------
 3 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index b7c1f89..7e322e5 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -341,6 +341,9 @@ second_time:
 		mutex_unlock(&dbs_data->mutex);
 
 		if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
+			/* Initiate timer time stamp */
+			cpu_cdbs->time_stamp = ktime_get();
+
 			for_each_cpu(j, policy->cpus) {
 				struct cpu_dbs_common_info *j_cdbs;
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 5bf6fb8..aaf073d 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -82,6 +82,7 @@ struct cpu_dbs_common_info {
 	 * the governor or limits.
 	 */
 	struct mutex timer_mutex;
+	ktime_t time_stamp;
 };
 
 struct od_cpu_dbs_info_s {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index fe6e47c..e07593e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -212,23 +212,23 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	}
 }
 
-static void od_dbs_timer(struct work_struct *work)
+static void od_timer_update(struct od_cpu_dbs_info_s *dbs_info, bool sample,
+			    struct delayed_work *dw)
 {
-	struct od_cpu_dbs_info_s *dbs_info =
-		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cpu;
 	int delay, sample_type = dbs_info->sample_type;
 
-	mutex_lock(&dbs_info->cdbs.timer_mutex);
-
 	/* Common NORMAL_SAMPLE setup */
 	dbs_info->sample_type = OD_NORMAL_SAMPLE;
 	if (sample_type == OD_SUB_SAMPLE) {
 		delay = dbs_info->freq_lo_jiffies;
-		__cpufreq_driver_target(dbs_info->cdbs.cur_policy,
-			dbs_info->freq_lo, CPUFREQ_RELATION_H);
+		if (sample)
+			__cpufreq_driver_target(dbs_info->cdbs.cur_policy,
+						dbs_info->freq_lo,
+						CPUFREQ_RELATION_H);
 	} else {
-		dbs_check_cpu(&od_dbs_data, cpu);
+		if (sample)
+			dbs_check_cpu(&od_dbs_data, cpu);
 		if (dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			dbs_info->sample_type = OD_SUB_SAMPLE;
@@ -239,11 +239,49 @@ static void od_dbs_timer(struct work_struct *work)
 		}
 	}
 
-	schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
-			delay);
+	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+}
+
+static void od_timer_coordinated(struct od_cpu_dbs_info_s *dbs_info_local,
+				 struct delayed_work *dw)
+{
+	struct od_cpu_dbs_info_s *dbs_info;
+	ktime_t time_now;
+	s64 delta_us;
+	bool sample = true;
+
+	/* use leader CPU's dbs_info */
+	dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info_local->cdbs.cpu);
+	mutex_lock(&dbs_info->cdbs.timer_mutex);
+
+	time_now = ktime_get();
+	delta_us = ktime_us_delta(time_now, dbs_info->cdbs.time_stamp);
+
+	/* Do nothing if we recently have sampled */
+	if (delta_us < (s64)(od_tuners.sampling_rate / 2))
+		sample = false;
+	else
+		dbs_info->cdbs.time_stamp = time_now;
+
+	od_timer_update(dbs_info, sample, dw);
 	mutex_unlock(&dbs_info->cdbs.timer_mutex);
 }
 
+static void od_dbs_timer(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct od_cpu_dbs_info_s *dbs_info =
+		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
+
+	if (dbs_sw_coordinated_cpus(&dbs_info->cdbs)) {
+		od_timer_coordinated(dbs_info, dw);
+	} else {
+		mutex_lock(&dbs_info->cdbs.timer_mutex);
+		od_timer_update(dbs_info, true, dw);
+		mutex_unlock(&dbs_info->cdbs.timer_mutex);
+	}
+}
+
 /************************** sysfs interface ************************/
 
 static ssize_t show_sampling_rate_min(struct kobject *kobj,
-- 
1.7.12.1

