Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2LPFuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 00:50:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2LPFu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 00:50:29 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, rafael.j.wysocki@intel.com
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] cpufreq: Notify governors when cpus are hot-[un]plugged
Date: Sun, 16 Dec 2012 11:20:09 +0530
Message-Id: <0464826f8b1fff4555fb0f38032220d1cc591396.1355636864.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
In-Reply-To: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because cpufreq core and governors worry only about the online cpus, if a cpu is
hot [un]plugged, we must notify governors about it, otherwise be ready to expect
something unexpected.

We already have notifiers in the form of CPUFREQ_GOV_START/CPUFREQ_GOV_STOP, we
just need to call them now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index de99517..a0a33bd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -751,11 +751,16 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 				return -EBUSY;
 			}
 
+			__cpufreq_governor(managed_policy, CPUFREQ_GOV_STOP);
+
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+			__cpufreq_governor(managed_policy, CPUFREQ_GOV_START);
+			__cpufreq_governor(managed_policy, CPUFREQ_GOV_LIMITS);
+
 			pr_debug("CPU already managed, adding link\n");
 			ret = sysfs_create_link(&dev->kobj,
 						&managed_policy->kobj,
@@ -1066,8 +1071,13 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	 */
 	if (unlikely(cpu != data->cpu)) {
 		pr_debug("removing link\n");
+		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		__cpufreq_governor(data, CPUFREQ_GOV_START);
+		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+
 		kobj = &dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
-- 
1.7.12.rc2.18.g61b472e

