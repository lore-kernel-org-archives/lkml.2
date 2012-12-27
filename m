Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2L0O4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:56:30 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53051 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab2L0O4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:56:24 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Date: Thu, 27 Dec 2012 15:55:38 +0100
Message-Id: <1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

This patch fixes a bug that occurred when we had load on a secondary CPU
and the primary CPU was sleeping. Only one sampling timer was spawned
and it was spawned as a deferred timer on the primary CPU, so when a
secondary CPU had a change in load this was not detected by the cpufreq
governor (both ondemand and conservative).

This patch make sure that deferred timers are run on all CPUs in the
case of software controlled CPUs that run on the same frequency.

Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c |  3 ++-
 drivers/cpufreq/cpufreq_governor.c     | 44 +++++++++++++++++++++++++++++-----
 drivers/cpufreq/cpufreq_governor.h     |  1 +
 drivers/cpufreq/cpufreq_ondemand.c     |  3 ++-
 4 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 64ef737..b9d7f14 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -122,7 +122,8 @@ static void cs_dbs_timer(struct work_struct *work)
 
 	dbs_check_cpu(&cs_dbs_data, cpu);
 
-	schedule_delayed_work_on(cpu, &dbs_info->cdbs.work, delay);
+	schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
+			delay);
 	mutex_unlock(&dbs_info->cdbs.timer_mutex);
 }
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 6c5f1d3..b0e4506 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -161,13 +161,23 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
 
+bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs)
+{
+	struct cpufreq_policy *policy = cdbs->cur_policy;
+
+	return cpumask_weight(policy->cpus) > 1;
+}
+EXPORT_SYMBOL_GPL(dbs_sw_coordinated_cpus);
+
 static inline void dbs_timer_init(struct dbs_data *dbs_data,
-		struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
+				  struct cpu_dbs_common_info *cdbs,
+				  unsigned int sampling_rate,
+				  int cpu)
 {
 	int delay = delay_for_sampling_rate(sampling_rate);
+	struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
 
-	INIT_DEFERRABLE_WORK(&cdbs->work, dbs_data->gov_dbs_timer);
-	schedule_delayed_work_on(cdbs->cpu, &cdbs->work, delay);
+	schedule_delayed_work_on(cpu, &cdbs_local->work, delay);
 }
 
 static inline void dbs_timer_exit(struct cpu_dbs_common_info *cdbs)
@@ -217,6 +227,10 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
 					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+
+			mutex_init(&j_cdbs->timer_mutex);
+			INIT_DEFERRABLE_WORK(&j_cdbs->work,
+					     dbs_data->gov_dbs_timer);
 		}
 
 		/*
@@ -275,15 +289,33 @@ second_time:
 		}
 		mutex_unlock(&dbs_data->mutex);
 
-		mutex_init(&cpu_cdbs->timer_mutex);
-		dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate);
+		if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
+			for_each_cpu(j, policy->cpus) {
+				struct cpu_dbs_common_info *j_cdbs;
+
+				j_cdbs = dbs_data->get_cpu_cdbs(j);
+				dbs_timer_init(dbs_data, j_cdbs,
+					       *sampling_rate, j);
+			}
+		} else {
+			dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate, cpu);
+		}
 		break;
 
 	case CPUFREQ_GOV_STOP:
 		if (dbs_data->governor == GOV_CONSERVATIVE)
 			cs_dbs_info->enable = 0;
 
-		dbs_timer_exit(cpu_cdbs);
+		if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
+			for_each_cpu(j, policy->cpus) {
+				struct cpu_dbs_common_info *j_cdbs;
+
+				j_cdbs = dbs_data->get_cpu_cdbs(j);
+				dbs_timer_exit(j_cdbs);
+			}
+		} else {
+			dbs_timer_exit(cpu_cdbs);
+		}
 
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index f661654..5bf6fb8 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -171,6 +171,7 @@ static inline int delay_for_sampling_rate(unsigned int sampling_rate)
 
 u64 get_cpu_idle_time(unsigned int cpu, u64 *wall);
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
+bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs);
 int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 		struct cpufreq_policy *policy, unsigned int event);
 #endif /* _CPUFREQ_GOVERNER_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 7731f7c..93bb56d 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -243,7 +243,8 @@ static void od_dbs_timer(struct work_struct *work)
 		}
 	}
 
-	schedule_delayed_work_on(cpu, &dbs_info->cdbs.work, delay);
+	schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
+			delay);
 	mutex_unlock(&dbs_info->cdbs.timer_mutex);
 }
 
-- 
1.7.12.1

