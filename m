Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2KZQkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:40:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54311 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab2KZQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:40:48 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/5] cpufreq: star/stop cpufreq timers on cpu hotplug
Date: Mon, 26 Nov 2012 17:39:53 +0100
Message-Id: <1353947996-26723-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a CPU notifier to start and stop individual core timers on CPU
hotplug events when running on CPUs with SW coordinated frequency.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_governor.c | 51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index a00f02d..b7c1f89 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -25,9 +25,12 @@
 #include <linux/tick.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include <linux/cpu.h>
 
 #include "cpufreq_governor.h"
 
+static DEFINE_PER_CPU(struct dbs_data *, cpu_cur_dbs);
+
 static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 {
 	u64 idle_time;
@@ -193,6 +196,46 @@ static inline void dbs_timer_exit(struct cpu_dbs_common_info *cdbs)
 	cancel_delayed_work_sync(&cdbs->work);
 }
 
+static int __cpuinit cpu_callback(struct notifier_block *nfb,
+		unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct device *cpu_dev = get_cpu_device(cpu);
+	struct dbs_data *dbs_data = per_cpu(cpu_cur_dbs, cpu);
+	struct cpu_dbs_common_info *cpu_cdbs = dbs_data->get_cpu_cdbs(cpu);
+	unsigned int sampling_rate;
+
+	if (dbs_data->governor == GOV_CONSERVATIVE) {
+		struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+		sampling_rate = cs_tuners->sampling_rate;
+	} else {
+		struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+		sampling_rate = od_tuners->sampling_rate;
+	}
+
+	if (cpu_dev) {
+		switch (action) {
+		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
+		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
+			dbs_timer_init(dbs_data, cpu_cdbs,
+					sampling_rate, cpu);
+			break;
+		case CPU_DOWN_PREPARE:
+		case CPU_DOWN_PREPARE_FROZEN:
+			dbs_timer_exit(cpu_cdbs);
+			break;
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __refdata ondemand_cpu_notifier = {
+	.notifier_call = cpu_callback,
+};
+
 int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		struct cpufreq_policy *policy, unsigned int event)
 {
@@ -304,7 +347,11 @@ second_time:
 				j_cdbs = dbs_data->get_cpu_cdbs(j);
 				dbs_timer_init(dbs_data, j_cdbs,
 					       *sampling_rate, j);
+
+				per_cpu(cpu_cur_dbs, j) = dbs_data;
 			}
+
+			register_hotcpu_notifier(&ondemand_cpu_notifier);
 		} else {
 			dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate, cpu);
 		}
@@ -315,11 +362,15 @@ second_time:
 			cs_dbs_info->enable = 0;
 
 		if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
+			unregister_hotcpu_notifier(&ondemand_cpu_notifier);
+
 			for_each_cpu(j, policy->cpus) {
 				struct cpu_dbs_common_info *j_cdbs;
 
 				j_cdbs = dbs_data->get_cpu_cdbs(j);
 				dbs_timer_exit(j_cdbs);
+
+				per_cpu(cpu_cur_dbs, j) = NULL;
 			}
 		} else {
 			dbs_timer_exit(cpu_cdbs);
-- 
1.7.12.1

