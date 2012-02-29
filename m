Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2B2Iyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:54:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56844 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2B2Iyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:54:32 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-c3-4f4de7c7859a
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: [PATCH v2 1/2] CPUfreq ondemand: update sampling rate without waiting
 for next sampling
Date: Wed, 29 Feb 2012 17:54:41 +0900
Message-id: <1330505682-4794-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1330505682-4794-1-git-send-email-myungjoo.ham@samsung.com>
References: <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
 <1330505682-4794-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new sampling rate is shorter than the current one, (e.g., 1 sec
--> 10 ms) regardless how short the new one is, the current ondemand
mechanism wait for the previously set timer to be expired.

For example, if the user has just expressed that the sampling rate
should be 10 ms from now and the previous was 1000 ms, the new rate may
become effective 999 ms later, which could be not acceptable for the
user if the user has intended to speed up sampling because the system is
expected to react to CPU load fluctuation quickly from __now__.

In order to address this issue, we need to cancel the previously set
timer (schedule_delayed_work) and reset the timer if resetting timer is
expected to trigger the delayed_work ealier.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Changes from v1(RFC)
- Style updates
---
 drivers/cpufreq/cpufreq_ondemand.c |   58 +++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c3e0652..836e9b0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -257,6 +257,62 @@ show_one(sampling_down_factor, sampling_down_factor);
 show_one(ignore_nice_load, ignore_nice);
 show_one(powersave_bias, powersave_bias);
 
+/**
+ * update_sampling_rate - update sampling rate effective immediately if needed.
+ * @new_rate: new sampling rate
+ *
+ * If new rate is smaller than the old, simply updaing
+ * dbs_tuners_int.sampling_rate might not be appropriate. For example,
+ * if the original sampling_rate was 1 second and the requested new sampling
+ * rate is 10 ms because the user needs immediate reaction from ondemand
+ * governor, but not sure if higher frequency will be required or not,
+ * then, the governor may change the sampling rate too late; up to 1 second
+ * later. Thus, if we are reducing the sampling rate, we need to make the
+ * new value effective immediately.
+ */
+static void update_sampling_rate(unsigned int new_rate)
+{
+	int cpu;
+
+	dbs_tuners_ins.sampling_rate = new_rate
+				     = max(new_rate, min_sampling_rate);
+
+	for_each_online_cpu(cpu) {
+		struct cpufreq_policy *policy;
+		struct cpu_dbs_info_s *dbs_info;
+		unsigned long next_sampling, appointed_at;
+
+		policy = cpufreq_cpu_get(cpu);
+		if (!policy)
+			continue;
+		dbs_info = &per_cpu(od_cpu_dbs_info, policy->cpu);
+		cpufreq_cpu_put(policy);
+
+		mutex_lock(&dbs_info->timer_mutex);
+
+		if (!delayed_work_pending(&dbs_info->work)) {
+			mutex_unlock(&dbs_info->timer_mutex);
+			continue;
+		}
+
+		next_sampling  = jiffies + usecs_to_jiffies(new_rate);
+		appointed_at = dbs_info->work.timer.expires;
+
+
+		if (time_before(next_sampling, appointed_at)) {
+
+			mutex_unlock(&dbs_info->timer_mutex);
+			cancel_delayed_work_sync(&dbs_info->work);
+			mutex_lock(&dbs_info->timer_mutex);
+
+			schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work,
+						 usecs_to_jiffies(new_rate));
+
+		}
+		mutex_unlock(&dbs_info->timer_mutex);
+	}
+}
+
 static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
 				   const char *buf, size_t count)
 {
@@ -265,7 +321,7 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
 	ret = sscanf(buf, "%u", &input);
 	if (ret != 1)
 		return -EINVAL;
-	dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
+	update_sampling_rate(input);
 	return count;
 }
 
-- 
1.7.4.1

