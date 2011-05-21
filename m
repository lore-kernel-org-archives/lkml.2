Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1EUIn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:43:57 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:50911 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679Ab1EUInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:43:15 -0400
X-Greylist: delayed 38243 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 May 2011 04:43:15 EDT
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/13] cpufreq: update DB8500 cpufreq driver
Date: Sat, 21 May 2011 10:43:06 +0200
Message-ID: <1305967386-16714-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This updates the ux500 cpufreq driver to the new interface from the
updated DB8500 PRCMU

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/cpufreq/db8500-cpufreq.c |  167 ++++++++++++++-----------------------
 1 files changed, 63 insertions(+), 104 deletions(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index d196939..d90456a 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -1,134 +1,118 @@
 /*
- * CPU frequency scaling for u8500
- * Inspired by linux/arch/arm/mach-davinci/cpufreq.c
- *
  * Copyright (C) STMicroelectronics 2009
  * Copyright (C) ST-Ericsson SA 2010
  *
  * License Terms: GNU General Public License v2
- *
  * Author: Sundar Iyer <sundar.iyer@stericsson.com>
  * Author: Martin Persson <martin.persson@stericsson.com>
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
  *
  */
-
-#include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/mfd/db8500-prcmu.h>
-
-#include <mach/hardware.h>
-
-#define DRIVER_NAME "cpufreq-u8500"
-#define CPUFREQ_NAME "u8500"
-
-static struct device *dev;
+#include <mach/id.h>
 
 static struct cpufreq_frequency_table freq_table[] = {
 	[0] = {
 		.index = 0,
-		.frequency = 200000,
+		.frequency = 300000,
 	},
 	[1] = {
 		.index = 1,
-		.frequency = 300000,
+		.frequency = 600000,
 	},
 	[2] = {
+		/* Used for MAX_OPP, if available */
 		.index = 2,
-		.frequency = 600000,
+		.frequency = CPUFREQ_TABLE_END,
 	},
 	[3] = {
-		/* Used for CPU_OPP_MAX, if available */
 		.index = 3,
 		.frequency = CPUFREQ_TABLE_END,
 	},
-	[4] = {
-		.index = 4,
-		.frequency = CPUFREQ_TABLE_END,
-	},
 };
 
-static enum prcmu_cpu_opp index2opp[] = {
-	CPU_OPP_EXT_CLK,
-	CPU_OPP_50,
-	CPU_OPP_100,
-	CPU_OPP_MAX
+static enum arm_opp idx2opp[] = {
+	ARM_50_OPP,
+	ARM_100_OPP,
+	ARM_MAX_OPP
+};
+
+static struct freq_attr *db8500_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
 };
 
-static int u8500_cpufreq_verify_speed(struct cpufreq_policy *policy)
+static int db8500_cpufreq_verify_speed(struct cpufreq_policy *policy)
 {
 	return cpufreq_frequency_table_verify(policy, freq_table);
 }
 
-static int u8500_cpufreq_target(struct cpufreq_policy *policy,
+static int db8500_cpufreq_target(struct cpufreq_policy *policy,
 				unsigned int target_freq,
 				unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int index;
-	int ret = 0;
+	unsigned int idx;
 
-	/*
-	 * Ensure desired rate is within allowed range.  Some govenors
-	 * (ondemand) will just pass target_freq=0 to get the minimum.
-	 */
+	/* scale the target frequency to one of the extremes supported */
 	if (target_freq < policy->cpuinfo.min_freq)
 		target_freq = policy->cpuinfo.min_freq;
 	if (target_freq > policy->cpuinfo.max_freq)
 		target_freq = policy->cpuinfo.max_freq;
 
-	ret = cpufreq_frequency_table_target(policy, freq_table,
-					     target_freq, relation, &index);
-	if (ret < 0) {
-		dev_err(dev, "Could not look up next frequency\n");
-		return ret;
+	/* Lookup the next frequency */
+	if (cpufreq_frequency_table_target
+	    (policy, freq_table, target_freq, relation, &idx)) {
+		return -EINVAL;
 	}
 
 	freqs.old = policy->cur;
-	freqs.new = freq_table[index].frequency;
+	freqs.new = freq_table[idx].frequency;
 	freqs.cpu = policy->cpu;
 
-	if (freqs.old == freqs.new) {
-		dev_dbg(dev, "Current and target frequencies are equal\n");
+	if (freqs.old == freqs.new)
 		return 0;
-	}
 
-	dev_dbg(dev, "transition: %u --> %u\n", freqs.old, freqs.new);
+	/* pre-change notification */
 	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
-	ret = prcmu_set_cpu_opp(index2opp[index]);
-	if (ret < 0) {
-		dev_err(dev, "Failed to set OPP level\n");
-		return ret;
+	/* request the PRCM unit for opp change */
+	if (prcmu_set_arm_opp(idx2opp[idx])) {
+		pr_err("db8500-cpufreq:  Failed to set OPP level\n");
+		return -EINVAL;
 	}
 
+	/* post change notification */
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
-	return ret;
+	return 0;
 }
 
-static unsigned int u8500_cpufreq_getspeed(unsigned int cpu)
+static unsigned int db8500_cpufreq_getspeed(unsigned int cpu)
 {
 	int i;
-
-	for (i = 0; prcmu_get_cpu_opp() != index2opp[i]; i++)
+	/* request the prcm to get the current ARM opp */
+	for (i = 0; prcmu_get_arm_opp() != idx2opp[i]; i++)
 		;
 	return freq_table[i].frequency;
 }
 
-static int __cpuinit u8500_cpu_init(struct cpufreq_policy *policy)
+static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int res;
+	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(index2opp) + 1 != ARRAY_SIZE(freq_table));
+	BUILD_BUG_ON(ARRAY_SIZE(idx2opp) + 1 != ARRAY_SIZE(freq_table));
 
-	if (cpu_is_u8500v2()) {
-		freq_table[1].frequency = 400000;
-		freq_table[2].frequency = 800000;
+	if (cpu_is_u8500v2() && !prcmu_is_u8400()) {
+		freq_table[0].frequency = 400000;
+		freq_table[1].frequency = 800000;
 		if (prcmu_has_arm_maxopp())
-			freq_table[3].frequency = 1000000;
+			freq_table[2].frequency = 1000000;
 	}
 
 	/* get policy fields based on the table */
@@ -136,13 +120,17 @@ static int __cpuinit u8500_cpu_init(struct cpufreq_policy *policy)
 	if (!res)
 		cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 	else {
-		dev_err(dev, "u8500-cpufreq : Failed to read policy table\n");
+		pr_err("db8500-cpufreq : Failed to read policy table\n");
 		return res;
 	}
 
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
-	policy->cur = u8500_cpufreq_getspeed(policy->cpu);
+	policy->cur = db8500_cpufreq_getspeed(policy->cpu);
+
+	for (i = 0; freq_table[i].frequency != policy->cur; i++)
+		;
+
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 
 	/*
@@ -150,61 +138,32 @@ static int __cpuinit u8500_cpu_init(struct cpufreq_policy *policy)
 	 *	   function with no/some/all drivers in the notification
 	 *	   list.
 	 */
-	policy->cpuinfo.transition_latency = 200 * 1000; /* in ns */
+	policy->cpuinfo.transition_latency = 20 * 1000; /* in ns */
 
 	/* policy sharing between dual CPUs */
 	cpumask_copy(policy->cpus, &cpu_present_map);
 
 	policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 
-	return res;
-}
-
-static struct freq_attr *u8500_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-static int u8500_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
 }
 
-static struct cpufreq_driver u8500_driver = {
-	.owner = THIS_MODULE,
-	.flags = CPUFREQ_STICKY,
-	.verify = u8500_cpufreq_verify_speed,
-	.target = u8500_cpufreq_target,
-	.get = u8500_cpufreq_getspeed,
-	.init = u8500_cpu_init,
-	.exit = u8500_cpu_exit,
-	.name = CPUFREQ_NAME,
-	.attr = u8500_cpufreq_attr,
+static struct cpufreq_driver db8500_cpufreq_driver = {
+	.flags  = CPUFREQ_STICKY,
+	.verify = db8500_cpufreq_verify_speed,
+	.target = db8500_cpufreq_target,
+	.get    = db8500_cpufreq_getspeed,
+	.init   = db8500_cpufreq_init,
+	.name   = "DB8500",
+	.attr   = db8500_cpufreq_attr,
 };
 
-static int __init u8500_cpufreq_probe(struct platform_device *pdev)
+static int __init db8500_cpufreq_register(void)
 {
-	dev = &pdev->dev;
-	return cpufreq_register_driver(&u8500_driver);
-}
-
-static int __exit u8500_cpufreq_remove(struct platform_device *pdev)
-{
-	return cpufreq_unregister_driver(&u8500_driver);
-}
+	if (!cpu_is_u8500v20_or_later())
+		return -ENODEV;
 
-static struct platform_driver u8500_cpufreq_driver = {
-	.driver = {
-		.name	 = DRIVER_NAME,
-		.owner	 = THIS_MODULE,
-	},
-	.remove = __exit_p(u8500_cpufreq_remove),
-};
-
-static int __init u8500_cpufreq_init(void)
-{
-	return platform_driver_probe(&u8500_cpufreq_driver,
-				     &u8500_cpufreq_probe);
+	pr_info("cpufreq for DB8500 started\n");
+	return cpufreq_register_driver(&db8500_cpufreq_driver);
 }
-
-device_initcall(u8500_cpufreq_init);
+device_initcall(db8500_cpufreq_register);
-- 
1.7.3.2

