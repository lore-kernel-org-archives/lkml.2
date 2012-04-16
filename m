Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2DPXvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:51:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55433 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2DPXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:51:06 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH 2/3] ARM: imx: Add imx5 cpuidle driver
Date: Mon, 16 Apr 2012 18:50:13 -0500
Message-Id: <1334620214-25803-3-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add imx5 cpuidle driver.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/Makefile              |    2 +-
 arch/arm/mach-imx/cpuidle-imx5.c        |   55 +++++++++++++++++++++++++++++++
 arch/arm/mach-imx/mm-imx5.c             |   16 ++++++---
 arch/arm/plat-mxc/include/mach/common.h |    1 +
 4 files changed, 69 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-imx/cpuidle-imx5.c

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index ab939c5..84b8976 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_SOC_IMX27) += clock-imx27.o mm-imx27.o ehci-imx27.o
 obj-$(CONFIG_SOC_IMX31) += mm-imx3.o cpu-imx31.o clock-imx31.o iomux-imx31.o ehci-imx31.o pm-imx3.o
 obj-$(CONFIG_SOC_IMX35) += mm-imx3.o cpu-imx35.o clock-imx35.o ehci-imx35.o pm-imx3.o
 
-obj-$(CONFIG_SOC_IMX5) += cpu-imx5.o mm-imx5.o clock-mx51-mx53.o ehci-imx5.o pm-imx5.o cpu_op-mx51.o
+obj-$(CONFIG_SOC_IMX5) += cpu-imx5.o mm-imx5.o clock-mx51-mx53.o ehci-imx5.o pm-imx5.o cpu_op-mx51.o cpuidle-imx5.o
 
 # Support for CMOS sensor interface
 obj-$(CONFIG_MX1_VIDEO) += mx1-camera-fiq.o mx1-camera-fiq-ksym.o
diff --git a/arch/arm/mach-imx/cpuidle-imx5.c b/arch/arm/mach-imx/cpuidle-imx5.c
new file mode 100644
index 0000000..8f428fc
--- /dev/null
+++ b/arch/arm/mach-imx/cpuidle-imx5.c
@@ -0,0 +1,55 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2012 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/cpuidle.h>
+#include <linux/err.h>
+#include <mach/common.h>
+#include <mach/cpuidle.h>
+#include <mach/hardware.h>
+
+static int imx5_cpuidle_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int idx)
+{
+	int ret;
+
+	ret = imx5_idle();
+
+	if (ret < 0)
+		return ret;
+
+	return idx;
+}
+
+static struct cpuidle_driver imx5_cpuidle_driver = {
+	.name			= "imx5_cpuidle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]	= {
+		.enter			= imx5_cpuidle_enter,
+		.exit_latency		= 20, /* max latency at 160MHz */
+		.target_residency	= 1,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "IMX5 SRPG",
+		.desc			= "CPU state retained,powered off",
+	},
+	.state_count		= 1,
+};
+
+int __init imx5_cpuidle_init(void)
+{
+	imx_cpuidle_set_driver(&imx5_cpuidle_driver);
+
+	return 0;
+}
diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
index e10f391..594915b 100644
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@ -22,22 +22,29 @@
 #include <mach/common.h>
 #include <mach/devices-common.h>
 #include <mach/iomux-v3.h>
+#include <mach/cpuidle.h>
 
 static struct clk *gpc_dvfs_clk;
 
-static void imx5_idle(void)
+int imx5_idle(void)
 {
+	int ret = 0;
+
 	/* gpc clock is needed for SRPG */
 	if (gpc_dvfs_clk == NULL) {
 		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
 		if (IS_ERR(gpc_dvfs_clk))
-			return;
+			return -ENODEV;
 	}
 	clk_enable(gpc_dvfs_clk);
 	mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
 	if (!tzic_enable_wake())
 		cpu_do_idle();
+	else
+		ret = -EBUSY;
 	clk_disable(gpc_dvfs_clk);
+
+	return ret;
 }
 
 /*
@@ -103,7 +110,7 @@ void __init imx51_init_early(void)
 	mxc_set_cpu_type(MXC_CPU_MX51);
 	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
 	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG1_BASE_ADDR));
-	arm_pm_idle = imx5_idle;
+	arm_pm_idle = (void *)imx5_idle;
 }
 
 void __init imx53_init_early(void)
@@ -203,7 +210,8 @@ void __init imx51_soc_init(void)
 	/* i.mx51 has the i.mx35 type sdma */
 	imx_add_imx_sdma("imx35-sdma", MX51_SDMA_BASE_ADDR, MX51_INT_SDMA, &imx51_sdma_pdata);
 
-	/* Setup AIPS registers */
+	imx5_cpuidle_init();
+
 	imx_set_aips(MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR));
 	imx_set_aips(MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR));
 
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 0319c4a..128a572 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -95,6 +95,7 @@ enum mx3_cpu_pwr_mode {
 
 extern void mx3_cpu_lp_set(enum mx3_cpu_pwr_mode mode);
 extern void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode);
+extern int imx5_idle(void);
 extern void imx_print_silicon_rev(const char *cpu, int srev);
 
 void avic_handle_irq(struct pt_regs *);
-- 
1.7.10

