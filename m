Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1CBEUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:20:52 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25401 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab1CBEUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:20:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6272"; a="77471331"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, dwalker@fifo99.com
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tsoni@codeaurora.org, dima@android.com, swetland@google.com,
        Kenneth Heitke <kheitke@codeaurora.org>, <linux@arm.linux.org.uk>,
        <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] msm: Add SSBI support for MSM8960
Date: Tue,  1 Mar 2011 21:20:47 -0700
Message-Id: <1299039647-12766-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device definitions and platform data to support
SSBI on MSM8960 simulator and RUMI3 targets.

SSBI is the Qualcomm single-wire serial bus interface used
to connect the MSM devices to other devices.

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
This patch depends on the "[PATCH v3 x/2] msm: add single-wire serial
bus interface (SSBI) driver" patch series which is under review

 arch/arm/mach-msm/board-msm8960.c               |   15 +++++++++++++++
 arch/arm/mach-msm/devices-msm8960.c             |   16 ++++++++++++++++
 arch/arm/mach-msm/devices.h                     |    1 +
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    4 ++++
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 052cb35..bf1a24b 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/clkdev.h>
+#include <linux/msm_ssbi.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -59,21 +60,35 @@ static void __init msm8960_init_irq(void)
 
 static struct platform_device *sim_devices[] __initdata = {
 	&msm8960_device_uart_gsbi2,
+	&msm8960_device_ssbi_pm8921,
 };
 
 static struct platform_device *rumi3_devices[] __initdata = {
 	&msm8960_device_uart_gsbi5,
 };
 
+static struct msm_ssbi_platform_data msm8960_ssbi_pm8921_pdata = {
+	.controller_type = MSM_SBI_CTRL_PMIC_ARBITER,
+	.slave	= {
+		.name		= "pm8921-core",
+	},
+};
+
 static void __init msm8960_sim_init(void)
 {
 	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	msm8960_device_ssbi_pm8921.dev.platform_data =
+					&msm8960_ssbi_pm8921_pdata;
+
 	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
 }
 
 static void __init msm8960_rumi3_init(void)
 {
 	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	msm8960_device_ssbi_pm8921.dev.platform_data =
+					&msm8960_ssbi_pm8921_pdata;
+
 	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
 }
 
diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
index 894ff98..40ceb78 100644
--- a/arch/arm/mach-msm/devices-msm8960.c
+++ b/arch/arm/mach-msm/devices-msm8960.c
@@ -24,6 +24,7 @@
 
 #include <mach/irqs-8960.h>
 #include <mach/board.h>
+#include <mach/msm_iomap.h>
 
 #include "devices.h"
 #include "clock.h"
@@ -89,6 +90,21 @@ struct platform_device msm8960_device_uart_gsbi5 = {
 	.resource	= resources_uart_gsbi5,
 };
 
+static struct resource resources_ssbi_pm8921[] = {
+	{
+		.start  = MSM_PMIC1_SSBI_CMD_PHYS,
+		.end    = MSM_PMIC1_SSBI_CMD_PHYS + MSM_PMIC_SSBI_SIZE - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device msm8960_device_ssbi_pm8921 = {
+	.name           = "msm_ssbi",
+	.id             = 0,
+	.resource       = resources_ssbi_pm8921,
+	.num_resources  = ARRAY_SIZE(resources_ssbi_pm8921),
+};
+
 struct clk_lookup msm_clocks_8960[] = {
 	CLK_DUMMY("ce_clk",		CE2_CLK,		NULL, OFF),
 	CLK_DUMMY("gsbi_uart_clk",	GSBI1_UART_CLK,		NULL, OFF),
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index e7a0cb0..e7c7fe0 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -26,6 +26,7 @@ extern struct platform_device msm_device_uart3;
 
 extern struct platform_device msm8960_device_uart_gsbi2;
 extern struct platform_device msm8960_device_uart_gsbi5;
+extern struct platform_device msm8960_device_ssbi_pm8921;
 
 extern struct platform_device msm_device_sdc1;
 extern struct platform_device msm_device_sdc2;
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 3c9d960..2d2210f 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -45,4 +45,8 @@
 #define MSM8960_TMR0_PHYS	0x0208A000
 #define MSM8960_TMR0_SIZE	SZ_4K
 
+#define MSM_PMIC1_SSBI_CMD_PHYS	0x00500000
+#define MSM_PMIC2_SSBI_CMD_PHYS	0x00C00000
+#define MSM_PMIC_SSBI_SIZE	SZ_4K
+
 #endif
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
