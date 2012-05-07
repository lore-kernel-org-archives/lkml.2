Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2EGVRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:17:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62336 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2EGVRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:17:00 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v3 2/3] ARM: imx: Add imx5 cpuidle driver
Date: Mon,  7 May 2012 16:16:46 -0500
Message-Id: <1336425407-20308-3-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336425407-20308-1-git-send-email-rob.lee@linaro.org>
References: <1336425407-20308-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add imx5 cpuidle driver.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/mm-imx5.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
index d6b7e9f..0b3a4cc 100644
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@ -20,26 +20,61 @@
 
 #include <mach/hardware.h>
 #include <mach/common.h>
+#include <mach/cpuidle.h>
 #include <mach/devices-common.h>
 #include <mach/iomux-v3.h>
 
 static struct clk *gpc_dvfs_clk;
 
-static void imx5_idle(void)
+static int imx5_idle(void)
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
+}
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
 }
 
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
 /*
  * Define the MX50 memory map.
  */
@@ -103,7 +138,7 @@ void __init imx51_init_early(void)
 	mxc_set_cpu_type(MXC_CPU_MX51);
 	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
 	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG1_BASE_ADDR));
-	arm_pm_idle = imx5_idle;
+	arm_pm_idle = (void (*)(void))imx5_idle;
 }
 
 void __init imx53_init_early(void)
@@ -238,4 +273,5 @@ void __init imx53_soc_init(void)
 void __init imx51_init_late(void)
 {
 	mx51_neon_fixup();
+	imx_cpuidle_init(&imx5_cpuidle_driver);
 }
-- 
1.7.10

