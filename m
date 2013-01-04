Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3ADQfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:35:33 -0500
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:37405 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3ADQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:35:26 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 4/4 v10] cpufreq, highbank: add support for highbank cpufreq
Date: Fri,  4 Jan 2013 10:35:46 -0600
Message-Id: <1357317346-1120-5-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highbank processors depend on the external ECME to perform voltage
management based on a requested frequency. Communication between the
A9 cores and the ECME happens over the pl320 IPC channel.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Mike Turquette <mturquette@linaro.org>
---
Changes from v9
	Added Mike Turquette's reviewed by.
	Used to be the 6th patch in the series.
Changes from v8
        Added Shawn Guo's reviewed by.
        Removed some magic numbers.
        Changed failure returns in clk_notify from NOTIFY_STOP to NOTIFY_BAD.
Changes from v7
        Removed old attribution to cpufreq-cpu0.
        Added some description in the documentation.
        Made cpu_dev, cpu_clk into local variables.
        Removed __devinit.
        Removed some unneeded includes.
        Added a brace to clarify some nested if logic.
Changes from v6
        Removed devicetree bindings documentation.
        Restructured driver to use clk notifications.
        Core driver logic is now cpufreq-clk0.
Changes from v5
        Changed ipc_transmit() to pl320_ipc_transmit().
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

 arch/arm/boot/dts/highbank.dts     |  10 ++++
 arch/arm/mach-highbank/Kconfig     |   2 +
 drivers/cpufreq/Kconfig.arm        |  15 +++++
 drivers/cpufreq/Makefile           |   1 +
 drivers/cpufreq/highbank-cpufreq.c | 109 +++++++++++++++++++++++++++++++++++++
 5 files changed, 137 insertions(+)
 create mode 100644 drivers/cpufreq/highbank-cpufreq.c

diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index a9ae5d3..202f12e 100644
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
+			clock-latency = <100000>;
 		};
 
 		cpu@1 {
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 2388085..44b12f9 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -1,5 +1,7 @@
 config ARCH_HIGHBANK
 	bool "Calxeda ECX-1000/2000 (Highbank/Midway)" if ARCH_MULTI_V7
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_AMBA
 	select ARM_GIC
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index a0b3661..7c71c1b 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -83,3 +83,18 @@ config ARM_SPEAR_CPUFREQ
 	default y
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
+
+config ARM_HIGHBANK_CPUFREQ
+	tristate "Calxeda Highbank-based"
+	depends on ARCH_HIGHBANK
+	select CPU_FREQ_TABLE
+	select GENERIC_CPUFREQ_CPU0
+	select PM_OPP
+	select REGULATOR
+
+	default m
+	help
+	   This adds the CPUFreq driver for Calxeda Highbank SoC
+	   based boards.
+
+	   If in doubt, say N.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 1f254ec0..2f7ab0b 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)     += omap-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
+obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
 
 ##################################################################################
 # PowerPC platform drivers
diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
new file mode 100644
index 0000000..8c85608
--- /dev/null
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -0,0 +1,109 @@
+/*
+ * Copyright (C) 2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver provides the clk notifier callbacks that are used when
+ * the cpufreq-cpu0 driver changes to frequency to alert the highbank
+ * EnergyCore Management Engine (ECME) about the need to change
+ * voltage. The ECME interfaces with the actual voltage regulators.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/mailbox.h>
+
+#define HB_CPUFREQ_CHANGE_NOTE	0x80000001
+#define HB_CPUFREQ_IPC_LEN	7
+#define HB_CPUFREQ_VOLT_RETRIES	15
+
+static int hb_voltage_change(unsigned int freq)
+{
+	int i;
+	u32 msg[HB_CPUFREQ_IPC_LEN];
+
+	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
+	msg[1] = freq / 1000000;
+	for (i = 2; i < HB_CPUFREQ_IPC_LEN; i++)
+		msg[i] = 0;
+
+	return pl320_ipc_transmit(msg);
+}
+
+static int hb_cpufreq_clk_notify(struct notifier_block *nb,
+				unsigned long action, void *hclk)
+{
+	struct clk_notifier_data *clk_data = hclk;
+	int i = 0;
+
+	if (action == PRE_RATE_CHANGE) {
+		if (clk_data->new_rate > clk_data->old_rate)
+			while (hb_voltage_change(clk_data->new_rate))
+				if (i++ > HB_CPUFREQ_VOLT_RETRIES)
+					return NOTIFY_BAD;
+	} else if (action == POST_RATE_CHANGE) {
+		if (clk_data->new_rate < clk_data->old_rate)
+			while (hb_voltage_change(clk_data->new_rate))
+				if (i++ > HB_CPUFREQ_VOLT_RETRIES)
+					return NOTIFY_BAD;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block hb_cpufreq_clk_nb = {
+	.notifier_call = hb_cpufreq_clk_notify,
+};
+
+static int hb_cpufreq_driver_init(void)
+{
+	struct device *cpu_dev;
+	struct clk *cpu_clk;
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
+	ret = clk_notifier_register(cpu_clk, &hb_cpufreq_clk_nb);
+	if (ret) {
+		pr_err("failed to register clk notifier: %d\n", ret);
+		goto out_put_node;
+	}
+
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
1.8.0.2

