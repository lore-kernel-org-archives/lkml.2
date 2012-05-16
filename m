Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966275Ab2EPClQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:41:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41217 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab2EPClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:41:14 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v4 6/7] ARM: imx: Add imx5 cpuidle
Date: Tue, 15 May 2012 21:33:35 -0500
Message-Id: <1337135616-8988-7-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpuidle driver for imx5 platform.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/pm-imx5.c |   44 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
index 6e62d79..966c71b 100644
--- a/arch/arm/mach-imx/pm-imx5.c
+++ b/arch/arm/mach-imx/pm-imx5.c
@@ -12,10 +12,12 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <asm/cacheflush.h>
 #include <asm/system_misc.h>
 #include <asm/tlbflush.h>
 #include <mach/common.h>
+#include <mach/cpuidle.h>
 #include <mach/hardware.h>
 #include "crm-regs-imx5.h"
 
@@ -134,12 +136,48 @@ static const struct platform_suspend_ops mx5_suspend_ops = {
 	.enter = mx5_suspend_enter,
 };
 
-static void imx5_pm_idle(void)
+static inline int imx5_cpu_do_idle(void)
 {
-	if (likely(!tzic_enable_wake()))
+	int ret = tzic_enable_wake();
+
+	if (likely(!ret))
 		cpu_do_idle();
+
+	return ret;
 }
 
+static void imx5_pm_idle(void)
+{
+	imx5_cpu_do_idle();
+}
+
+static int imx5_cpuidle_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int idx)
+{
+	int ret;
+
+	ret = imx5_cpu_do_idle();
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
+		.exit_latency		= 2,
+		.target_residency	= 1,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "IMX5 SRPG",
+		.desc			= "CPU state retained,powered off",
+	},
+	.state_count		= 1,
+};
+
 int __init imx5_pm_init(void)
 {
 	int ret;
@@ -160,5 +198,5 @@ int __init imx5_pm_init(void)
 	/* Set the registers to the default cpu idle state. */
 	mx5_cpu_lp_set(IMX5_DEFAULT_CPU_IDLE_STATE);
 
-	return 0;
+	return imx_cpuidle_init(&imx5_cpuidle_driver);
 }
-- 
1.7.10

