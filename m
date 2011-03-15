Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1COFBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63697 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1COFB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79964170"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 11/11] msm: dma: support msm8960 dma
Date: Mon, 14 Mar 2011 22:01:14 -0700
Message-Id: <1300165274-8544-12-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                      |    2 +-
 arch/arm/mach-msm/board-msm8960.c               |    5 +++++
 arch/arm/mach-msm/devices-msm8960.c             |   21 +++++++++++++++++++++
 arch/arm/mach-msm/devices.h                     |    1 +
 arch/arm/mach-msm/dma.c                         |    3 +++
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    3 +++
 6 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9998f75..35fd3e8 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
 obj-$(CONFIG_ARCH_MSM8X60) += dma.o
-obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o
+obj-$(CONFIG_ARCH_MSM8960) += dma.o clock-dummy.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 9511ea6..72ac090 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -65,9 +65,14 @@ static struct platform_device *rumi3_devices[] __initdata = {
 	&msm8960_device_uart_gsbi5,
 };
 
+static struct platform_device *devices[] __initdata = {
+	&msm8960_device_dmov,
+};
+
 static void __init msm8960_init(void)
 {
 	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 static void __init msm8960_sim_init(void)
diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
index 894ff98..75dc162 100644
--- a/arch/arm/mach-msm/devices-msm8960.c
+++ b/arch/arm/mach-msm/devices-msm8960.c
@@ -24,6 +24,8 @@
 
 #include <mach/irqs-8960.h>
 #include <mach/board.h>
+#include <mach/msm_iomap.h>
+#include <mach/irqs.h>
 
 #include "devices.h"
 #include "clock.h"
@@ -89,6 +91,25 @@ struct platform_device msm8960_device_uart_gsbi5 = {
 	.resource	= resources_uart_gsbi5,
 };
 
+static struct resource resources_dmov[] = {
+	{
+		.start = MSM8960_DMOV_PHYS,
+		.end = MSM8960_DMOV_PHYS + MSM8960_DMOV_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_ADM0_SCSS_0_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device msm8960_device_dmov = {
+	.name	= "msm_dmov",
+	.id	= -1,
+	.num_resources = ARRAY_SIZE(resources_dmov),
+	.resource = resources_dmov,
+};
+
 struct clk_lookup msm_clocks_8960[] = {
 	CLK_DUMMY("ce_clk",		CE2_CLK,		NULL, OFF),
 	CLK_DUMMY("gsbi_uart_clk",	GSBI1_UART_CLK,		NULL, OFF),
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 0abf25f..e38fc86 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -41,6 +41,7 @@ extern struct platform_device msm_device_i2c;
 extern struct platform_device msm_device_smd;
 
 extern struct platform_device msm_device_dmov;
+extern struct platform_device msm8960_device_dmov;
 extern struct platform_device msm_device_dmov_adm0;
 extern struct platform_device msm_device_dmov_adm1;
 
diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 44d9621..16b4034 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -57,6 +57,9 @@ static int nr_adms;
 #elif defined(CONFIG_ARCH_MSM8X60)
 #define DMOV_SD_AARM DMOV_SD1
 #define DMOV_SD_SIZE 0x800
+#elif defined(CONFIG_ARCH_MSM8960)
+#define DMOV_SD_AARM DMOV_SD0
+#define DMOV_SD_SIZE 0x800
 #else
 #define DMOV_SD_AARM DMOV_SD3
 #define DMOV_SD_SIZE 0x400
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 3c9d960..b251ba6 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -45,4 +45,7 @@
 #define MSM8960_TMR0_PHYS	0x0208A000
 #define MSM8960_TMR0_SIZE	SZ_4K
 
+#define MSM8960_DMOV_PHYS	0x18300000
+#define MSM8960_DMOV_SIZE	SZ_1M
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

