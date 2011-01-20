Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1ATUd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:33:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20889 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1ATUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:33:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71062576"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org, Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 4/7] msm: mahimahi: add mahimahi board file
Date: Thu, 20 Jan 2011 12:32:42 -0800
Message-Id: <1295555565-21563-5-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds basic boot support for Nexus One (aka Mahimahi).

This code was taken from Google's tree, with slight modifications
and clean up.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig          |    8 ++-
 arch/arm/mach-msm/Makefile         |    1 +
 arch/arm/mach-msm/board-mahimahi.c |   20 ++---
 arch/arm/mach-msm/board-mahimahi.h |  147 ++++++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-mahimahi.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 5d3d9ad..0bb8173 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -27,7 +27,7 @@ config ARCH_MSM7X30
 
 config ARCH_QSD8X50
 	bool "QSD8X50"
-	select MACH_QSD8X50_SURF if !MACH_QSD8X50A_ST1_5
+	select MACH_QSD8X50_SURF if (!MACH_QSD8X50A_ST1_5 && !MACH_MAHIMAHI)
 	select ARCH_MSM_SCORPION
 	select MSM_SMD
 	select MSM_VIC
@@ -88,6 +88,12 @@ config MACH_MSM7X30_SURF
 	help
 	  Support for the Qualcomm MSM7x30 SURF eval board.
 
+config MACH_MAHIMAHI
+        depends on ARCH_QSD8X50
+        bool "HTC Passion/Nexus One"
+        help
+          Select this to support an HTC Passion/Nexus One phone.
+
 config MACH_QSD8X50_SURF
 	depends on ARCH_QSD8X50
 	bool "QSD8x50 SURF"
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9fd3a35..a0ebce4 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
+obj-$(CONFIG_MACH_MAHIMAHI) += board-mahimahi.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
index aedb136..c1745c7 100644
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ b/arch/arm/mach-msm/board-mahimahi.c
@@ -41,11 +41,7 @@ static uint debug_uart;
 module_param_named(debug_uart, debug_uart, uint, 0);
 
 static struct platform_device *devices[] __initdata = {
-#if !defined(CONFIG_MSM_SERIAL_DEBUGGER)
 	&msm_device_uart1,
-#endif
-	&msm_device_uart_dm1,
-	&msm_device_nand,
 };
 
 static struct msm_acpu_clock_platform_data mahimahi_clock_data = {
@@ -82,28 +78,30 @@ static void __init mahimahi_fixup(struct machine_desc *desc, struct tag *tags,
 {
 	mi->nr_banks = 2;
 	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].node = PHYS_TO_NID(PHYS_OFFSET);
 	mi->bank[0].size = (219*1024*1024);
 	mi->bank[1].start = MSM_HIGHMEM_BASE;
-	mi->bank[1].node = PHYS_TO_NID(MSM_HIGHMEM_BASE);
 	mi->bank[1].size = MSM_HIGHMEM_SIZE;
 }
 
 static void __init mahimahi_map_io(void)
 {
-	msm_map_common_io();
-	msm_clock_init();
+	msm_map_qsd8x50_io();
+	msm_clock_init(msm_clocks_8x50, msm_num_clocks_8x50);
+}
+
+static void __init mahimahi_init_irq(void)
+{
+	msm_init_irq();
+	msm_init_sirc();
 }
 
 extern struct sys_timer msm_timer;
 
 MACHINE_START(MAHIMAHI, "mahimahi")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= 0x20000100,
 	.fixup		= mahimahi_fixup,
 	.map_io		= mahimahi_map_io,
-	.init_irq	= msm_init_irq,
+	.init_irq	= mahimahi_init_irq,
 	.init_machine	= mahimahi_init,
 	.timer		= &msm_timer,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-mahimahi.h b/arch/arm/mach-msm/board-mahimahi.h
new file mode 100644
index 0000000..e2a8b14
--- /dev/null
+++ b/arch/arm/mach-msm/board-mahimahi.h
@@ -0,0 +1,147 @@
+/* arch/arm/mach-msm/board-mahimahi.h
+ *
+ * Copyright (C) 2009 HTC Corporation.
+ * Author: Haley Teng <Haley_Teng@htc.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+*/
+
+#ifndef __ARCH_ARM_MACH_MSM_BOARD_MAHIMAHI_H
+#define __ARCH_ARM_MACH_MSM_BOARD_MAHIMAHI_H
+
+#include <mach/board.h>
+
+#define MSM_RAM_CONSOLE_BASE	0x03A00000
+#define MSM_RAM_CONSOLE_SIZE	0x00040000
+
+#define MSM_FB_BASE		0x03B00000
+#define MSM_FB_SIZE		0x00465000
+
+#define MSM_EBI1_BANK0_BASE	0x20000000
+#define MSM_EBI1_BANK0_SIZE	0x0E000000
+
+#define MSM_GPU_MEM_BASE	0x2DB00000
+#define MSM_GPU_MEM_SIZE	0x00500000
+
+#define MSM_EBI1_BANK1_BASE	0x30000000
+#define MSM_EBI1_BANK1_SIZE	0x10000000
+
+#define MSM_PMEM_MDP_BASE	0x30000000
+#define MSM_PMEM_MDP_SIZE	0x02000000
+
+#define MSM_PMEM_ADSP_BASE	0x32000000
+#define MSM_PMEM_ADSP_SIZE	0x02900000
+
+#define MSM_PMEM_CAMERA_BASE	0x34900000
+#define MSM_PMEM_CAMERA_SIZE	0x00800000
+
+#define MSM_HIGHMEM_BASE	0x35100000
+#define MSM_HIGHMEM_SIZE	0x0AF00000
+
+#define MAHIMAHI_GPIO_PS_HOLD		25
+
+#define MAHIMAHI_GPIO_UP_INT_N		35
+#define MAHIMAHI_GPIO_UP_RESET_N	82
+#define MAHIMAHI_GPIO_LS_EN_N		119
+
+#define MAHIMAHI_GPIO_TP_INT_N		92
+#define MAHIMAHI_GPIO_TP_LS_EN		93
+#define MAHIMAHI_GPIO_TP_EN		160
+
+#define MAHIMAHI_GPIO_POWER_KEY		94
+#define MAHIMAHI_GPIO_SDMC_CD_REV0_N	153
+
+#define MAHIMAHI_GPIO_WIFI_SHUTDOWN_N	127
+#define MAHIMAHI_GPIO_WIFI_IRQ		152
+
+#define MAHIMAHI_GPIO_BALL_UP		38
+#define MAHIMAHI_GPIO_BALL_DOWN		37
+#define MAHIMAHI_GPIO_BALL_LEFT		145
+#define MAHIMAHI_GPIO_BALL_RIGHT	21
+
+#define MAHIMAHI_GPIO_BT_UART1_RTS	43
+#define MAHIMAHI_GPIO_BT_UART1_CTS	44
+#define MAHIMAHI_GPIO_BT_UART1_RX	45
+#define MAHIMAHI_GPIO_BT_UART1_TX	46
+#define MAHIMAHI_GPIO_BT_RESET_N	146
+#define MAHIMAHI_GPIO_BT_SHUTDOWN_N	128
+
+#define MAHIMAHI_GPIO_BT_WAKE		57
+#define MAHIMAHI_GPIO_BT_HOST_WAKE	86
+
+#define MAHIMAHI_GPIO_PROXIMITY_INT_N	90
+#define MAHIMAHI_GPIO_PROXIMITY_EN	120
+
+#define MAHIMAHI_GPIO_DS2482_SLP_N	87
+#define MAHIMAHI_GPIO_VIBRATOR_ON	89
+/* Compass */
+#define MAHIMAHI_REV0_GPIO_COMPASS_INT_N	36
+
+#define MAHIMAHI_GPIO_COMPASS_INT_N	153
+#define MAHIMAHI_GPIO_COMPASS_RST_N	107
+#define MAHIMAHI_PROJECT_NAME          "mahimahi"
+#define MAHIMAHI_LAYOUTS {			   \
+	{ {-1,  0, 0}, { 0, -1,  0}, {0, 0,  1} }, \
+	{ { 0, -1, 0}, { 1,  0,  0}, {0, 0, -1} }, \
+	{ { 0, -1, 0}, { 1,  0,  0}, {0, 0,  1} }, \
+	{ {-1,  0, 0}, { 0,  0, -1}, {0, 1,  0} }  \
+}
+
+/* Audio */
+#define MAHIMAHI_AUD_JACKHP_EN		157
+#define MAHIMAHI_AUD_2V5_EN		158
+#define MAHIMAHI_AUD_MICPATH_SEL	111
+#define MAHIMAHI_AUD_A1026_INT		112
+#define MAHIMAHI_AUD_A1026_WAKEUP	113
+#define MAHIMAHI_AUD_A1026_RESET	129
+#define MAHIMAHI_AUD_A1026_CLK		 -1
+#define MAHIMAHI_CDMA_XA_AUD_A1026_CLK	105
+/* NOTE: MAHIMAHI_CDMA_XB_AUD_A1026_WAKEUP on CDMA is the same GPIO as
+ * MAHIMAHI_GPIO_BATTERY_CHARGER_CURRENT on UMTS.  Also,
+ * MAHIMAHI_CDMA_XB_AUD_A1026_RESET is the same as
+ * GPIO MAHIMAHI_GPIO_35MM_KEY_INT_SHUTDOWN on UMTS.
+ */
+#define MAHIMAHI_CDMA_XB_AUD_A1026_WAKEUP	16
+#define MAHIMAHI_CDMA_XB_AUD_A1026_RESET	19
+#define MAHIMAHI_CDMA_XB_AUD_A1026_CLK	-1
+
+/* Bluetooth PCM */
+#define MAHIMAHI_BT_PCM_OUT		68
+#define MAHIMAHI_BT_PCM_IN		69
+#define MAHIMAHI_BT_PCM_SYNC		70
+#define MAHIMAHI_BT_PCM_CLK		71
+/* flash light */
+#define MAHIMAHI_GPIO_FLASHLIGHT_TORCH	58
+#define MAHIMAHI_GPIO_FLASHLIGHT_FLASH	84
+
+#define MAHIMAHI_GPIO_LED_3V3_EN	85
+#define MAHIMAHI_GPIO_LCD_RST_N		29
+
+/* 3.5mm remote control key interrupt shutdown signal */
+#define MAHIMAHI_GPIO_35MM_KEY_INT_SHUTDOWN	19
+
+#define MAHIMAHI_GPIO_DOCK		106
+
+/* speaker amplifier enable pin for mahimahi CDMA version */
+#define MAHIMAHI_CDMA_GPIO_AUD_SPK_AMP_EN	104
+
+#define MAHIMAHI_GPIO_BATTERY_DETECTION		39
+#define MAHIMAHI_GPIO_BATTERY_CHARGER_EN	22
+#define MAHIMAHI_GPIO_BATTERY_CHARGER_CURRENT	16
+
+#define MAHIMAHI_CDMA_GPIO_BT_WAKE		28
+#define MAHIMAHI_CDMA_GPIO_FLASHLIGHT_TORCH	26
+
+#define MAHIMAHI_CDMA_SD_2V85_EN		100
+#define MAHIMAHI_CDMA_JOG_2V6_EN		150
+
+#define is_cdma_version(rev) (((rev) & 0xF0) == 0xC0)
+
+#endif /* __ARCH_ARM_MACH_MSM_BOARD_MAHIMAHI_H */
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
