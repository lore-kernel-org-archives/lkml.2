Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2KZQlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:41:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37020 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2KZQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:41:07 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 4/5] cpufreq: conservative: call dbs_check_cpu only when necessary
Date: Mon, 26 Nov 2012 17:39:55 +0100
Message-Id: <1353947996-26723-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify conservative timer to not resample CPU utilization if recently
sampled from another SW coordinated core.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 47 +++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index b9d7f14..5d8e894 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -111,22 +111,57 @@ static void cs_check_cpu(int cpu, unsigned int load)
 	}
 }
 
-static void cs_dbs_timer(struct work_struct *work)
+static void cs_timer_update(struct cs_cpu_dbs_info_s *dbs_info, bool sample,
+			    struct delayed_work *dw)
 {
-	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
-			struct cs_cpu_dbs_info_s, cdbs.work.work);
 	unsigned int cpu = dbs_info->cdbs.cpu;
 	int delay = delay_for_sampling_rate(cs_tuners.sampling_rate);
 
+	if (sample)
+		dbs_check_cpu(&cs_dbs_data, cpu);
+
+	schedule_delayed_work_on(smp_processor_id(), dw, delay);
+}
+
+static void cs_timer_coordinated(struct cs_cpu_dbs_info_s *dbs_info_local,
+				 struct delayed_work *dw)
+{
+	struct cs_cpu_dbs_info_s *dbs_info;
+	ktime_t time_now;
+	s64 delta_us;
+	bool sample = true;
+
+	/* use leader CPU's dbs_info */
+	dbs_info = &per_cpu(cs_cpu_dbs_info, dbs_info_local->cdbs.cpu);
 	mutex_lock(&dbs_info->cdbs.timer_mutex);
 
-	dbs_check_cpu(&cs_dbs_data, cpu);
+	time_now = ktime_get();
+	delta_us = ktime_us_delta(time_now, dbs_info->cdbs.time_stamp);
 
-	schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
-			delay);
+	/* Do nothing if we recently have sampled */
+	if (delta_us < (s64)(cs_tuners.sampling_rate / 2))
+		sample = false;
+	else
+		dbs_info->cdbs.time_stamp = time_now;
+
+	cs_timer_update(dbs_info, sample, dw);
 	mutex_unlock(&dbs_info->cdbs.timer_mutex);
 }
 
+static void cs_dbs_timer(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct cs_cpu_dbs_info_s *dbs_info = container_of(work,
+			struct cs_cpu_dbs_info_s, cdbs.work.work);
+
+	if (dbs_sw_coordinated_cpus(&dbs_info->cdbs)) {
+		cs_timer_coordinated(dbs_info, dw);
+	} else {
+		mutex_lock(&dbs_info->cdbs.timer_mutex);
+		cs_timer_update(dbs_info, true, dw);
+		mutex_unlock(&dbs_info->cdbs.timer_mutex);
+	}
+}
 static int dbs_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 		void *data)
 {
-- 
1.7.12.1

