Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2K0PFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:05:53 -0500
Received: from smtp201.dfw.emailsrvr.com ([67.192.241.201]:49752 "EHLO
	smtp201.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2K0PEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:04:39 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 6/6 v5] cpufreq, highbank: add support for highbank cpufreq
Date: Tue, 27 Nov 2012 09:04:34 -0600
Message-Id: <1354028674-23685-7-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highbank processors depend on the external ECME to perform voltage
management based on a requested frequency. Communication between the
A9 cores and the ECME happens over the pl320 IPC channel.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
Changes from v4
	Removed erroneous changes to arch/arm/Kconfig.
	Removed unnecessary changes to drivers/cpufreq/Kconfig.arm
	Alphabetized additions to arch/arm/mach-highbank/Kconfig
	Changed ipc call and header to match new ipc location in 
	drivers/mailbox.
Changes from v3
        None.
Changes from v2
        Changed transition latency binding in code to match documentation.
Changes from v1
        Added highbank specific Kconfig changes.

 .../bindings/cpufreq/highbank-cpufreq.txt          |  53 +++++
 arch/arm/boot/dts/highbank.dts                     |  10 +
 arch/arm/mach-highbank/Kconfig                     |   2 +
 drivers/cpufreq/Kconfig.arm                        |  13 ++
 drivers/cpufreq/Makefile                           |   1 +
 drivers/cpufreq/highbank-cpufreq.c                 | 229 +++++++++++++++++++++
 6 files changed, 308 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/highbank-cpufreq.txt
 create mode 100644 drivers/cpufreq/highbank-cpufreq.c

diff --git a/Documentation/devicetree/bindings/cpufreq/highbank-cpufreq.txt b/Documentation/devicetree/bindings/cpufreq/highbank-cpufreq.txt
new file mode 100644
index 0000000..1d5a836
--- /dev/null
+++ b/Documentation/devicetree/bindings/cpufreq/highbank-cpufreq.txt
@@ -0,0 +1,53 @@
+Highbank cpufreq driver
+
+This is cpufreq driver for Calxeda ECX-1000 (highbank) processor. It is based
+on the generic cpu0 driver and uses a similar format for bindings. Since
+the EnergyCore Management Engine maintains the voltage based on the
+frequency, the voltage component of the operating points can be set to any
+arbitrary values.
+
+Both required properties listed below must be defined under node /cpus/cpu@0.
+
+Required properties:
+- operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
+  for details
+- transition-latency: Specify the possible maximum transition latency for clock,
+  in unit of nanoseconds.
+
+Examples:
+
+cpus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	cpu@0 {
+		compatible = "arm,cortex-a9";
+		reg = <0>;
+		next-level-cache = <&L2>;
+		operating-points = <
+			/* kHz  ignored */
+			790000  1000000
+			396000  1000000
+			198000  1000000
+		>;
+		transition-latency = <200000>;
+	};
+
+	cpu@1 {
+		compatible = "arm,cortex-a9";
+		reg = <1>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@2 {
+		compatible = "arm,cortex-a9";
+		reg = <2>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@3 {
+		compatible = "arm,cortex-a9";
+		reg = <3>;
+		next-level-cache = <&L2>;
+	};
+};
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index 0c6fc34..8624c94 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -36,6 +36,16 @@
 			next-level-cache = <&L2>;
 			clocks = <&a9pll>;
 			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 1300000  1000000
+				 1200000  1000000
+				 1100000  1000000
+				  800000  1000000
+				  400000  1000000
+				  200000  1000000
+			>;
+			transition-latency = <100000>;
 		};
 
 		cpu@1 {
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 2896881..b7862da 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -1,5 +1,7 @@
 config ARCH_HIGHBANK
 	bool "Calxeda ECX-1000 (Highbank)" if ARCH_MULTI_V7
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_AMBA
 	select ARM_GIC
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 5961e64..7a8bcdc 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -76,3 +76,16 @@ config ARM_EXYNOS5250_CPUFREQ
 	help
 	  This adds the CPUFreq driver for Samsung EXYNOS5250
 	  SoC.
+
+config ARM_HIGHBANK_CPUFREQ
+       tristate "Calxeda Highbank-based"
+       depends on ARCH_HIGHBANK
+       select CPU_FREQ_TABLE
+       select PM_OPP
+       default m
+       help
+         This adds the CPUFreq driver for Calxeda Highbank SoC
+         based boards.
+
+         If in doubt, say N.
+
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 1bc90e1..9e8f12a 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)     += omap-cpufreq.o
+obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
 
 ##################################################################################
 # PowerPC platform drivers
diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
new file mode 100644
index 0000000..f2ac342
--- /dev/null
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -0,0 +1,229 @@
+/*
+ * Copyright (C) 2012 Calxeda, Inc.
+ *
+ * derived from cpufreq-cpu0 by Freescale Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/opp.h>
+#include <linux/slab.h>
+#include <linux/mailbox.h>
+
+#define HB_CPUFREQ_CHANGE_NOTE 0x80000001
+
+static unsigned int transition_latency;
+
+static struct device *cpu_dev;
+static struct clk *cpu_clk;
+static struct cpufreq_frequency_table *freq_table;
+
+static int hb_verify_speed(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, freq_table);
+}
+
+static unsigned int hb_get_speed(unsigned int cpu)
+{
+	return clk_get_rate(cpu_clk) / 1000;
+}
+
+static int hb_voltage_change(unsigned int freq)
+{
+	int i;
+	u32 msg[7];
+
+	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
+	msg[1] = freq / 1000;
+	for (i = 2; i < 7; i++)
+		msg[i] = 0;
+
+	return ipc_transmit(msg);
+}
+
+static int hb_set_target(struct cpufreq_policy *policy,
+			   unsigned int target_freq, unsigned int relation)
+{
+	struct cpufreq_freqs freqs;
+	unsigned long freq_Hz;
+	unsigned int index, cpu;
+	int ret;
+
+	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
+					     relation, &index);
+	if (ret) {
+		pr_err("failed to match target freqency %d: %d\n",
+		       target_freq, ret);
+		return ret;
+	}
+
+	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
+	if (freq_Hz < 0)
+		freq_Hz = freq_table[index].frequency * 1000;
+	freqs.new = freq_Hz / 1000;
+	freqs.old = clk_get_rate(cpu_clk) / 1000;
+
+	if (freqs.old == freqs.new)
+		return 0;
+
+	for_each_online_cpu(cpu) {
+		freqs.cpu = cpu;
+		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+	}
+
+	pr_debug("%u MHz --> %u MHz\n", freqs.old / 1000, freqs.new / 1000);
+
+	/* scaling up?  scale voltage before frequency */
+	if (freqs.new > freqs.old) {
+		ret = hb_voltage_change(freqs.new);
+		if (ret) {
+			freqs.new = freqs.old;
+			return -EAGAIN;
+		}
+	}
+
+	ret = clk_set_rate(cpu_clk, freqs.new * 1000);
+	if (ret) {
+		pr_err("failed to set clock rate: %d\n", ret);
+		hb_voltage_change(freqs.old);
+		return ret;
+	}
+
+	/* scaling down?  scale voltage after frequency */
+	if (freqs.new < freqs.old) {
+		ret = hb_voltage_change(freqs.new);
+		if (ret) {
+			if (clk_set_rate(cpu_clk, freqs.old * 1000))
+				pr_err("also failed to reset freq\n");
+			freqs.new = freqs.old;
+			return -EAGAIN;
+		}
+	}
+
+	for_each_online_cpu(cpu) {
+		freqs.cpu = cpu;
+		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+	}
+
+	return 0;
+}
+
+static int hb_cpufreq_init(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	if (policy->cpu != 0)
+		return -EINVAL;
+
+	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	if (ret) {
+		pr_err("invalid frequency table: %d\n", ret);
+		return ret;
+	}
+
+	policy->cpuinfo.transition_latency = transition_latency;
+	policy->cur = clk_get_rate(cpu_clk) / 1000;
+
+	policy->shared_type = CPUFREQ_SHARED_TYPE_ANY;
+	cpumask_setall(policy->cpus);
+
+	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+
+	return 0;
+}
+
+static int hb_cpufreq_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+
+	return 0;
+}
+
+static struct freq_attr *hb_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver hb_cpufreq_driver = {
+	.flags = CPUFREQ_STICKY,
+	.verify = hb_verify_speed,
+	.target = hb_set_target,
+	.get = hb_get_speed,
+	.init = hb_cpufreq_init,
+	.exit = hb_cpufreq_exit,
+	.name = "highbank-cpufreq",
+	.attr = hb_cpufreq_attr,
+};
+
+static int __devinit hb_cpufreq_driver_init(void)
+{
+	struct device_node *np;
+	int ret;
+
+	np = of_find_node_by_path("/cpus/cpu@0");
+	if (!np) {
+		pr_err("failed to find highbank cpufreq node\n");
+		return -ENOENT;
+	}
+
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev) {
+		pr_err("failed to get highbank cpufreq device\n");
+		ret = -ENODEV;
+		goto out_put_node;
+	}
+
+	cpu_dev->of_node = np;
+
+	cpu_clk = clk_get(cpu_dev, NULL);
+	if (IS_ERR(cpu_clk)) {
+		ret = PTR_ERR(cpu_clk);
+		pr_err("failed to get cpu0 clock: %d\n", ret);
+		goto out_put_node;
+	}
+
+	ret = of_init_opp_table(cpu_dev);
+	if (ret) {
+		pr_err("failed to init OPP table: %d\n", ret);
+		goto out_put_node;
+	}
+
+	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
+	if (ret) {
+		pr_err("failed to init cpufreq table: %d\n", ret);
+		goto out_put_node;
+	}
+
+	if (of_property_read_u32(np, "transition-latency", &transition_latency))
+		transition_latency = CPUFREQ_ETERNAL;
+
+	ret = cpufreq_register_driver(&hb_cpufreq_driver);
+	if (ret) {
+		pr_err("failed register driver: %d\n", ret);
+		goto out_free_table;
+	}
+
+	of_node_put(np);
+	return 0;
+
+out_free_table:
+	opp_free_cpufreq_table(cpu_dev, &freq_table);
+out_put_node:
+	of_node_put(np);
+	return ret;
+}
+late_initcall(hb_cpufreq_driver_init);
+
+MODULE_AUTHOR("Mark Langsdorf <mark.langsdorf@calxeda.com>");
+MODULE_DESCRIPTION("Calxeda Highbank cpufreq driver");
+MODULE_LICENSE("GPL");
-- 
1.7.11.7

