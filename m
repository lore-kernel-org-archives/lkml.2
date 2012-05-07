Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab2EGOOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:14:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37718 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab2EGOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:14:44 -0400
Date: Mon, 7 May 2012 16:14:37 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Subject: [PATCH] ARM: mx35: add cpufreq support
Message-ID: <20120507141437.GA9636@lovely.krouter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mx35 to the supported cpu-families of the
"CPUfreq driver for i.MX CPUs".

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Christian Hemp <c.hemp@phytec.de>
---
 arch/arm/mach-imx/Kconfig       |    1 +
 arch/arm/mach-imx/Makefile      |    2 +-
 arch/arm/mach-imx/clock-imx35.c |   67 +++++++++++++++++++++++++++++++++-----
 arch/arm/mach-imx/cpu_op-mx35.c |   27 +++++++++++++++
 arch/arm/mach-imx/cpu_op-mx35.h |    7 ++++
 5 files changed, 94 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/mach-imx/cpu_op-mx35.c
 create mode 100644 arch/arm/mach-imx/cpu_op-mx35.h

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7f43a1f..e88db4d 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -73,6 +73,7 @@ config SOC_IMX35
 	select HAVE_EPIT
 	select MXC_AVIC
 	select SMP_ON_UP if SMP
+	select ARCH_HAS_CPUFREQ
 
 config SOC_IMX5
 	select CPU_V7
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index ff1e438..dbdd757 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_SOC_IMX27) += cpu-imx27.o pm-imx27.o
 obj-$(CONFIG_SOC_IMX27) += clock-imx27.o mm-imx27.o ehci-imx27.o
 
 obj-$(CONFIG_SOC_IMX31) += mm-imx3.o cpu-imx31.o clock-imx31.o iomux-imx31.o ehci-imx31.o pm-imx3.o
-obj-$(CONFIG_SOC_IMX35) += mm-imx3.o cpu-imx35.o clock-imx35.o ehci-imx35.o pm-imx3.o
+obj-$(CONFIG_SOC_IMX35) += mm-imx3.o cpu-imx35.o clock-imx35.o ehci-imx35.o pm-imx3.o cpu_op-mx35.o
 
 obj-$(CONFIG_SOC_IMX5) += cpu-imx5.o mm-imx5.o clock-mx51-mx53.o ehci-imx5.o pm-imx5.o cpu_op-mx51.o
 
diff --git a/arch/arm/mach-imx/clock-imx35.c b/arch/arm/mach-imx/clock-imx35.c
index e56c1a8..704cf24 100644
--- a/arch/arm/mach-imx/clock-imx35.c
+++ b/arch/arm/mach-imx/clock-imx35.c
@@ -27,6 +27,7 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
 
+#include "cpu_op-mx35.h"
 #include "crmregs-imx3.h"
 
 #ifdef HAVE_SET_RATE_SUPPORT
@@ -112,24 +113,32 @@ struct arm_ahb_div {
 };
 
 static struct arm_ahb_div clk_consumer[] = {
-	{ .arm = 1, .ahb = 4, .sel = 0},
-	{ .arm = 1, .ahb = 3, .sel = 1},
-	{ .arm = 2, .ahb = 2, .sel = 0},
+	{ .arm = 1, .ahb = 4, .sel = 0}, /* ARM: 532 MHz, AHB: 133 Mhz */
+	{ .arm = 1, .ahb = 3, .sel = 1}, /* ARM: 399 MHz, AHB: 133 Mhz */
+	{ .arm = 2, .ahb = 2, .sel = 0}, /* ARM: 266 MHz, AHB: 133 Mhz */
 	{ .arm = 0, .ahb = 0, .sel = 0},
 	{ .arm = 0, .ahb = 0, .sel = 0},
 	{ .arm = 0, .ahb = 0, .sel = 0},
-	{ .arm = 4, .ahb = 1, .sel = 0},
-	{ .arm = 1, .ahb = 5, .sel = 0},
-	{ .arm = 1, .ahb = 8, .sel = 0},
-	{ .arm = 1, .ahb = 6, .sel = 1},
-	{ .arm = 2, .ahb = 4, .sel = 0},
+	{ .arm = 4, .ahb = 1, .sel = 0}, /* ARM: 133 MHz, AHB: 133 Mhz */
+	{ .arm = 1, .ahb = 5, .sel = 0}, /* ARM: 665 MHz, AHB: 133 Mhz */
+	{ .arm = 1, .ahb = 8, .sel = 0}, /* ARM: 532 MHz, AHB: 66.5 Mhz */
+	{ .arm = 1, .ahb = 6, .sel = 1}, /* ARM: 399 MHz, AHB: 66.5 Mhz */
+	{ .arm = 2, .ahb = 4, .sel = 0}, /* ARM: 266 MHz, AHB: 66.5 Mhz */
 	{ .arm = 0, .ahb = 0, .sel = 0},
 	{ .arm = 0, .ahb = 0, .sel = 0},
 	{ .arm = 0, .ahb = 0, .sel = 0},
-	{ .arm = 4, .ahb = 2, .sel = 0},
+	{ .arm = 4, .ahb = 2, .sel = 0}, /* ARM: 133 MHz, AHB: 66.5 Mhz */
 	{ .arm = 0, .ahb = 0, .sel = 0},
 };
 
+enum mx35_cpu_freqs {
+	mx35_cpu_freq_532_mhz,
+	mx35_cpu_freq_399_mhz,
+	mx35_cpu_freq_266_mhz,
+	mx35_cpu_freq_133_mhz = 6,
+	mx35_cpu_freq_665_mhz,
+};
+
 static unsigned long get_rate_arm(void)
 {
 	unsigned long pdr0 = __raw_readl(MXC_CCM_PDR0);
@@ -143,6 +152,40 @@ static unsigned long get_rate_arm(void)
 	return fref / aad->arm;
 }
 
+#if defined(CONFIG_CPU_FREQ_IMX)
+static unsigned long clk_cpu_get_rate(struct clk *clk)
+{
+	return get_rate_arm();
+}
+
+static int clk_cpu_set_rate(struct clk *clk, unsigned long rate)
+{
+	int i;
+	struct cpu_op *cpu_op_tbl;
+	int cpu_op_nr;
+	unsigned long pdr0;
+	const int mx35_cpu_freq[] = {
+		mx35_cpu_freq_133_mhz, mx35_cpu_freq_266_mhz,
+		mx35_cpu_freq_399_mhz, mx35_cpu_freq_532_mhz };
+
+	if (!get_cpu_op)
+		return -EINVAL;
+
+	cpu_op_tbl = get_cpu_op(&cpu_op_nr);
+
+	for (i = 0; i < cpu_op_nr; i++) {
+		if (cpu_op_tbl[i].cpu_rate == rate)
+			break;
+	}
+	pdr0 = __raw_readl(MXC_CCM_PDR0);
+	pdr0 &= ~(0xF << 16);
+	pdr0 |= mx35_cpu_freq[i] << 16;
+	__raw_writel(pdr0, MXC_CCM_PDR0);
+
+	return 0;
+}
+#endif
+
 static unsigned long get_rate_ahb(struct clk *clk)
 {
 	unsigned long pdr0 = __raw_readl(MXC_CCM_PDR0);
@@ -392,6 +435,9 @@ DEFINE_CLOCK(iim_clk,    0, MX35_CCM_CGR3,  2, NULL, NULL);
 DEFINE_CLOCK(gpu2d_clk,  0, MX35_CCM_CGR3,  4, NULL, NULL);
 
 DEFINE_CLOCK(usbahb_clk, 0, 0,         0, get_rate_ahb, NULL);
+#if defined(CONFIG_CPU_FREQ_IMX)
+DEFINE_CLOCK(cpu_clk, 0, 0,         0, clk_cpu_get_rate, clk_cpu_set_rate);
+#endif
 
 static int clk_dummy_enable(struct clk *clk)
 {
@@ -487,6 +533,9 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK(NULL, "iim", iim_clk)
 	_REGISTER_CLOCK(NULL, "gpu2d", gpu2d_clk)
 	_REGISTER_CLOCK("mxc_nand.0", NULL, nfc_clk)
+#if defined(CONFIG_CPU_FREQ_IMX)
+	_REGISTER_CLOCK(NULL, "cpu_clk", cpu_clk)
+#endif
 };
 
 int __init mx35_clocks_init()
diff --git a/arch/arm/mach-imx/cpu_op-mx35.c b/arch/arm/mach-imx/cpu_op-mx35.c
new file mode 100644
index 0000000..7618f86
--- /dev/null
+++ b/arch/arm/mach-imx/cpu_op-mx35.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2012 PHYTEC Messtechnik GmbH
+ *
+ * Licensed under the GPLv2 or (at your option) any later version.
+ */
+
+#include <linux/bug.h>
+#include <linux/types.h>
+#include <mach/hardware.h>
+#include <linux/kernel.h>
+
+static struct cpu_op mx35_cpu_op[] = {
+	{
+	.cpu_rate = 133000000,},
+	{
+	.cpu_rate = 266000000,},
+	{
+	.cpu_rate = 399000000,},
+	{
+	.cpu_rate = 532000000,},
+};
+
+struct cpu_op *mx35_get_cpu_op(int *op)
+{
+	*op = ARRAY_SIZE(mx35_cpu_op);
+	return mx35_cpu_op;
+}
diff --git a/arch/arm/mach-imx/cpu_op-mx35.h b/arch/arm/mach-imx/cpu_op-mx35.h
new file mode 100644
index 0000000..6ea9385
--- /dev/null
+++ b/arch/arm/mach-imx/cpu_op-mx35.h
@@ -0,0 +1,7 @@
+/*
+ * Copyright (C) 2012 PHYTEC Messtechnik GmbH
+ *
+ * Licensed under the GPLv2 or (at your option) any later version.
+ */
+
+extern struct cpu_op *mx35_get_cpu_op(int *op);
-- 
1.7.2.5


