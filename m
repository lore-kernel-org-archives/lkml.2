Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1EUInQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:43:16 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:47226 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040Ab1EUInL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:43:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/13] mach-ux500: move CPUfreq driver to cpufreq subsystem
Date: Sat, 21 May 2011 10:42:59 +0200
Message-ID: <1305967379-16679-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As part of the ARM arch subsystem migration, move the DB8500
cpufreq driver to drivers/cpufreq as discussed with Dave Jones. The
Makefile is not updated in order to avoid cross-subsystem conflicts
for this file in merges.

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpufreq.c    |  210 --------------------------------------
 drivers/cpufreq/db8500-cpufreq.c |  210 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 210 insertions(+), 210 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/cpufreq.c
 create mode 100644 drivers/cpufreq/db8500-cpufreq.c

diff --git a/arch/arm/mach-ux500/cpufreq.c b/arch/arm/mach-ux500/cpufreq.c
deleted file mode 100644
index d196939..0000000
--- a/arch/arm/mach-ux500/cpufreq.c
+++ /dev/null
@@ -1,210 +0,0 @@
-/*
- * CPU frequency scaling for u8500
- * Inspired by linux/arch/arm/mach-davinci/cpufreq.c
- *
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License Terms: GNU General Public License v2
- *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Martin Persson <martin.persson@stericsson.com>
- * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
- *
- */
-
-#include <linux/platform_device.h>
-#include <linux/kernel.h>
-#include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/mfd/db8500-prcmu.h>
-
-#include <mach/hardware.h>
-
-#define DRIVER_NAME "cpufreq-u8500"
-#define CPUFREQ_NAME "u8500"
-
-static struct device *dev;
-
-static struct cpufreq_frequency_table freq_table[] = {
-	[0] = {
-		.index = 0,
-		.frequency = 200000,
-	},
-	[1] = {
-		.index = 1,
-		.frequency = 300000,
-	},
-	[2] = {
-		.index = 2,
-		.frequency = 600000,
-	},
-	[3] = {
-		/* Used for CPU_OPP_MAX, if available */
-		.index = 3,
-		.frequency = CPUFREQ_TABLE_END,
-	},
-	[4] = {
-		.index = 4,
-		.frequency = CPUFREQ_TABLE_END,
-	},
-};
-
-static enum prcmu_cpu_opp index2opp[] = {
-	CPU_OPP_EXT_CLK,
-	CPU_OPP_50,
-	CPU_OPP_100,
-	CPU_OPP_MAX
-};
-
-static int u8500_cpufreq_verify_speed(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, freq_table);
-}
-
-static int u8500_cpufreq_target(struct cpufreq_policy *policy,
-				unsigned int target_freq,
-				unsigned int relation)
-{
-	struct cpufreq_freqs freqs;
-	unsigned int index;
-	int ret = 0;
-
-	/*
-	 * Ensure desired rate is within allowed range.  Some govenors
-	 * (ondemand) will just pass target_freq=0 to get the minimum.
-	 */
-	if (target_freq < policy->cpuinfo.min_freq)
-		target_freq = policy->cpuinfo.min_freq;
-	if (target_freq > policy->cpuinfo.max_freq)
-		target_freq = policy->cpuinfo.max_freq;
-
-	ret = cpufreq_frequency_table_target(policy, freq_table,
-					     target_freq, relation, &index);
-	if (ret < 0) {
-		dev_err(dev, "Could not look up next frequency\n");
-		return ret;
-	}
-
-	freqs.old = policy->cur;
-	freqs.new = freq_table[index].frequency;
-	freqs.cpu = policy->cpu;
-
-	if (freqs.old == freqs.new) {
-		dev_dbg(dev, "Current and target frequencies are equal\n");
-		return 0;
-	}
-
-	dev_dbg(dev, "transition: %u --> %u\n", freqs.old, freqs.new);
-	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
-
-	ret = prcmu_set_cpu_opp(index2opp[index]);
-	if (ret < 0) {
-		dev_err(dev, "Failed to set OPP level\n");
-		return ret;
-	}
-
-	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
-}
-
-static unsigned int u8500_cpufreq_getspeed(unsigned int cpu)
-{
-	int i;
-
-	for (i = 0; prcmu_get_cpu_opp() != index2opp[i]; i++)
-		;
-	return freq_table[i].frequency;
-}
-
-static int __cpuinit u8500_cpu_init(struct cpufreq_policy *policy)
-{
-	int res;
-
-	BUILD_BUG_ON(ARRAY_SIZE(index2opp) + 1 != ARRAY_SIZE(freq_table));
-
-	if (cpu_is_u8500v2()) {
-		freq_table[1].frequency = 400000;
-		freq_table[2].frequency = 800000;
-		if (prcmu_has_arm_maxopp())
-			freq_table[3].frequency = 1000000;
-	}
-
-	/* get policy fields based on the table */
-	res = cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	if (!res)
-		cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
-	else {
-		dev_err(dev, "u8500-cpufreq : Failed to read policy table\n");
-		return res;
-	}
-
-	policy->min = policy->cpuinfo.min_freq;
-	policy->max = policy->cpuinfo.max_freq;
-	policy->cur = u8500_cpufreq_getspeed(policy->cpu);
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
-	/*
-	 * FIXME : Need to take time measurement across the target()
-	 *	   function with no/some/all drivers in the notification
-	 *	   list.
-	 */
-	policy->cpuinfo.transition_latency = 200 * 1000; /* in ns */
-
-	/* policy sharing between dual CPUs */
-	cpumask_copy(policy->cpus, &cpu_present_map);
-
-	policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-
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
-	return 0;
-}
-
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
-};
-
-static int __init u8500_cpufreq_probe(struct platform_device *pdev)
-{
-	dev = &pdev->dev;
-	return cpufreq_register_driver(&u8500_driver);
-}
-
-static int __exit u8500_cpufreq_remove(struct platform_device *pdev)
-{
-	return cpufreq_unregister_driver(&u8500_driver);
-}
-
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
-}
-
-device_initcall(u8500_cpufreq_init);
diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
new file mode 100644
index 0000000..d196939
--- /dev/null
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -0,0 +1,210 @@
+/*
+ * CPU frequency scaling for u8500
+ * Inspired by linux/arch/arm/mach-davinci/cpufreq.c
+ *
+ * Copyright (C) STMicroelectronics 2009
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/cpufreq.h>
+#include <linux/delay.h>
+#include <linux/mfd/db8500-prcmu.h>
+
+#include <mach/hardware.h>
+
+#define DRIVER_NAME "cpufreq-u8500"
+#define CPUFREQ_NAME "u8500"
+
+static struct device *dev;
+
+static struct cpufreq_frequency_table freq_table[] = {
+	[0] = {
+		.index = 0,
+		.frequency = 200000,
+	},
+	[1] = {
+		.index = 1,
+		.frequency = 300000,
+	},
+	[2] = {
+		.index = 2,
+		.frequency = 600000,
+	},
+	[3] = {
+		/* Used for CPU_OPP_MAX, if available */
+		.index = 3,
+		.frequency = CPUFREQ_TABLE_END,
+	},
+	[4] = {
+		.index = 4,
+		.frequency = CPUFREQ_TABLE_END,
+	},
+};
+
+static enum prcmu_cpu_opp index2opp[] = {
+	CPU_OPP_EXT_CLK,
+	CPU_OPP_50,
+	CPU_OPP_100,
+	CPU_OPP_MAX
+};
+
+static int u8500_cpufreq_verify_speed(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, freq_table);
+}
+
+static int u8500_cpufreq_target(struct cpufreq_policy *policy,
+				unsigned int target_freq,
+				unsigned int relation)
+{
+	struct cpufreq_freqs freqs;
+	unsigned int index;
+	int ret = 0;
+
+	/*
+	 * Ensure desired rate is within allowed range.  Some govenors
+	 * (ondemand) will just pass target_freq=0 to get the minimum.
+	 */
+	if (target_freq < policy->cpuinfo.min_freq)
+		target_freq = policy->cpuinfo.min_freq;
+	if (target_freq > policy->cpuinfo.max_freq)
+		target_freq = policy->cpuinfo.max_freq;
+
+	ret = cpufreq_frequency_table_target(policy, freq_table,
+					     target_freq, relation, &index);
+	if (ret < 0) {
+		dev_err(dev, "Could not look up next frequency\n");
+		return ret;
+	}
+
+	freqs.old = policy->cur;
+	freqs.new = freq_table[index].frequency;
+	freqs.cpu = policy->cpu;
+
+	if (freqs.old == freqs.new) {
+		dev_dbg(dev, "Current and target frequencies are equal\n");
+		return 0;
+	}
+
+	dev_dbg(dev, "transition: %u --> %u\n", freqs.old, freqs.new);
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	ret = prcmu_set_cpu_opp(index2opp[index]);
+	if (ret < 0) {
+		dev_err(dev, "Failed to set OPP level\n");
+		return ret;
+	}
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+
+	return ret;
+}
+
+static unsigned int u8500_cpufreq_getspeed(unsigned int cpu)
+{
+	int i;
+
+	for (i = 0; prcmu_get_cpu_opp() != index2opp[i]; i++)
+		;
+	return freq_table[i].frequency;
+}
+
+static int __cpuinit u8500_cpu_init(struct cpufreq_policy *policy)
+{
+	int res;
+
+	BUILD_BUG_ON(ARRAY_SIZE(index2opp) + 1 != ARRAY_SIZE(freq_table));
+
+	if (cpu_is_u8500v2()) {
+		freq_table[1].frequency = 400000;
+		freq_table[2].frequency = 800000;
+		if (prcmu_has_arm_maxopp())
+			freq_table[3].frequency = 1000000;
+	}
+
+	/* get policy fields based on the table */
+	res = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	if (!res)
+		cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+	else {
+		dev_err(dev, "u8500-cpufreq : Failed to read policy table\n");
+		return res;
+	}
+
+	policy->min = policy->cpuinfo.min_freq;
+	policy->max = policy->cpuinfo.max_freq;
+	policy->cur = u8500_cpufreq_getspeed(policy->cpu);
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+
+	/*
+	 * FIXME : Need to take time measurement across the target()
+	 *	   function with no/some/all drivers in the notification
+	 *	   list.
+	 */
+	policy->cpuinfo.transition_latency = 200 * 1000; /* in ns */
+
+	/* policy sharing between dual CPUs */
+	cpumask_copy(policy->cpus, &cpu_present_map);
+
+	policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
+
+	return res;
+}
+
+static struct freq_attr *u8500_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+static int u8500_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
+static struct cpufreq_driver u8500_driver = {
+	.owner = THIS_MODULE,
+	.flags = CPUFREQ_STICKY,
+	.verify = u8500_cpufreq_verify_speed,
+	.target = u8500_cpufreq_target,
+	.get = u8500_cpufreq_getspeed,
+	.init = u8500_cpu_init,
+	.exit = u8500_cpu_exit,
+	.name = CPUFREQ_NAME,
+	.attr = u8500_cpufreq_attr,
+};
+
+static int __init u8500_cpufreq_probe(struct platform_device *pdev)
+{
+	dev = &pdev->dev;
+	return cpufreq_register_driver(&u8500_driver);
+}
+
+static int __exit u8500_cpufreq_remove(struct platform_device *pdev)
+{
+	return cpufreq_unregister_driver(&u8500_driver);
+}
+
+static struct platform_driver u8500_cpufreq_driver = {
+	.driver = {
+		.name	 = DRIVER_NAME,
+		.owner	 = THIS_MODULE,
+	},
+	.remove = __exit_p(u8500_cpufreq_remove),
+};
+
+static int __init u8500_cpufreq_init(void)
+{
+	return platform_driver_probe(&u8500_cpufreq_driver,
+				     &u8500_cpufreq_probe);
+}
+
+device_initcall(u8500_cpufreq_init);
-- 
1.7.3.2

