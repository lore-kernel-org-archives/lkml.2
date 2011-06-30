Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab1F3Avo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 20:51:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17697 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab1F3Av3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 20:51:29 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-44-4e0bc88e087a
Date: Thu, 30 Jun 2011 09:51:25 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] ARM: EXYNOS4: Add more registers to be saved and restored
 for PM
In-reply-to: <1309395085-22084-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jaecheol Lee <jc.lee@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, myungjoo.ham@gmail.com
Message-id: <1309395085-22084-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1309395085-22084-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 30 Jun 2011 00:51:40.0883 (UTC)
 FILETIME=[DFD4F230:01CC36BF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need more registers to be saved and restored for PM of Exynos4210.
Otherwise, with additional drivers running, suspend-to-RAM fails to wake
up properly. This patch adds registers omitted in the initial PM
patches.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/pm.c |   77 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-exynos4/pm.c b/arch/arm/mach-exynos4/pm.c
index a103c13..24c9265 100644
--- a/arch/arm/mach-exynos4/pm.c
+++ b/arch/arm/mach-exynos4/pm.c
@@ -27,6 +27,8 @@
 #include <plat/cpu.h>
 #include <plat/pm.h>
 #include <plat/pll.h>
+#include <plat/regs-srom.h>
+#include <plat/regs-timer.h>
 
 #include <mach/regs-irq.h>
 #include <mach/regs-gpio.h>
@@ -60,14 +62,20 @@ static struct sleep_save exynos4_vpll_save[] = {
 
 static struct sleep_save exynos4_core_save[] = {
 	/* CMU side */
+	SAVE_ITEM(S5P_CLKSRC_LEFTBUS),
 	SAVE_ITEM(S5P_CLKDIV_LEFTBUS),
 	SAVE_ITEM(S5P_CLKGATE_IP_LEFTBUS),
+	SAVE_ITEM(S5P_CLKOUT_CMU_LEFTBUS),
+	SAVE_ITEM(S5P_CLKSRC_RIGHTBUS),
 	SAVE_ITEM(S5P_CLKDIV_RIGHTBUS),
 	SAVE_ITEM(S5P_CLKGATE_IP_RIGHTBUS),
+	SAVE_ITEM(S5P_CLKOUT_CMU_RIGHTBUS),
 	SAVE_ITEM(S5P_CLKSRC_TOP0),
 	SAVE_ITEM(S5P_CLKSRC_TOP1),
 	SAVE_ITEM(S5P_CLKSRC_CAM),
+	SAVE_ITEM(S5P_CLKSRC_TV),
 	SAVE_ITEM(S5P_CLKSRC_MFC),
+	SAVE_ITEM(S5P_CLKSRC_G3D),
 	SAVE_ITEM(S5P_CLKSRC_IMAGE),
 	SAVE_ITEM(S5P_CLKSRC_LCD0),
 	SAVE_ITEM(S5P_CLKSRC_LCD1),
@@ -94,6 +102,7 @@ static struct sleep_save exynos4_core_save[] = {
 	SAVE_ITEM(S5P_CLKDIV_PERIL4),
 	SAVE_ITEM(S5P_CLKDIV_PERIL5),
 	SAVE_ITEM(S5P_CLKDIV_TOP),
+	SAVE_ITEM(S5P_CLKSRC_MASK_TOP),
 	SAVE_ITEM(S5P_CLKSRC_MASK_CAM),
 	SAVE_ITEM(S5P_CLKSRC_MASK_TV),
 	SAVE_ITEM(S5P_CLKSRC_MASK_LCD0),
@@ -102,6 +111,7 @@ static struct sleep_save exynos4_core_save[] = {
 	SAVE_ITEM(S5P_CLKSRC_MASK_FSYS),
 	SAVE_ITEM(S5P_CLKSRC_MASK_PERIL0),
 	SAVE_ITEM(S5P_CLKSRC_MASK_PERIL1),
+	SAVE_ITEM(S5P_CLKDIV2_RATIO),
 	SAVE_ITEM(S5P_CLKGATE_SCLKCAM),
 	SAVE_ITEM(S5P_CLKGATE_IP_CAM),
 	SAVE_ITEM(S5P_CLKGATE_IP_TV),
@@ -115,15 +125,59 @@ static struct sleep_save exynos4_core_save[] = {
 	SAVE_ITEM(S5P_CLKGATE_IP_PERIL),
 	SAVE_ITEM(S5P_CLKGATE_IP_PERIR),
 	SAVE_ITEM(S5P_CLKGATE_BLOCK),
+	SAVE_ITEM(S5P_CLKOUT_CMU_TOP),
 	SAVE_ITEM(S5P_CLKSRC_MASK_DMC),
 	SAVE_ITEM(S5P_CLKSRC_DMC),
 	SAVE_ITEM(S5P_CLKDIV_DMC0),
 	SAVE_ITEM(S5P_CLKDIV_DMC1),
 	SAVE_ITEM(S5P_CLKGATE_IP_DMC),
+	SAVE_ITEM(S5P_CLKOUT_CMU_DMC),
+	SAVE_ITEM(S5P_APLL_LOCK),
+	SAVE_ITEM(S5P_MPLL_LOCK),
+	SAVE_ITEM(S5P_APLL_CON0),
+	SAVE_ITEM(S5P_APLL_CON1),
+	SAVE_ITEM(S5P_MPLL_CON0),
+	SAVE_ITEM(S5P_MPLL_CON1),
 	SAVE_ITEM(S5P_CLKSRC_CPU),
 	SAVE_ITEM(S5P_CLKDIV_CPU),
+	SAVE_ITEM(S5P_CLKDIV_CPU + 0x4),
 	SAVE_ITEM(S5P_CLKGATE_SCLKCPU),
 	SAVE_ITEM(S5P_CLKGATE_IP_CPU),
+	SAVE_ITEM(S5P_CLKOUT_CMU_CPU),
+
+	/* PMU */
+	SAVE_ITEM(S5P_HDMI_PHY_CONTROL),
+	SAVE_ITEM(S5P_USBOTG_PHY_CONTROL),
+	SAVE_ITEM(S5P_USBHOST_PHY_CONTROL),
+	SAVE_ITEM(S5P_DAC_CONTROL),
+	SAVE_ITEM(S5P_MIPI_CONTROL0),
+	SAVE_ITEM(S5P_MIPI_CONTROL1),
+	SAVE_ITEM(S5P_ADC_CONTROL),
+	SAVE_ITEM(S5P_PCIE_CONTROL),
+	SAVE_ITEM(S5P_SATA_CONTROL),
+	SAVE_ITEM(S5P_PMU_DEBUG),
+	SAVE_ITEM(S5P_ARM_CORE0_CONFIGURATION),
+	SAVE_ITEM(S5P_ARM_CORE1_CONFIGURATION),
+	SAVE_ITEM(S5P_ARM_CPU_L2_0_CONFIGURATION),
+	SAVE_ITEM(S5P_ARM_CPU_L2_1_CONFIGURATION),
+	SAVE_ITEM(S5P_XUSBXTI_CONFIGURATION),
+	SAVE_ITEM(S5P_XXTI_CONFIGURATION),
+	SAVE_ITEM(S5P_PMU_CAM_CONF),
+	SAVE_ITEM(S5P_PMU_TV_CONF),
+	SAVE_ITEM(S5P_PMU_MFC_CONF),
+	SAVE_ITEM(S5P_PMU_G3D_CONF),
+	SAVE_ITEM(S5P_PMU_LCD0_CONF),
+	SAVE_ITEM(S5P_PMU_LCD1_CONF),
+	SAVE_ITEM(S5P_MAUDIO_CONFIGURATION),
+	SAVE_ITEM(S5P_PMU_GPS_CONF),
+
+	/* System Controller side */
+	SAVE_ITEM(S3C_VA_SYS + 0x0210),
+	SAVE_ITEM(S3C_VA_SYS + 0x0214),
+	SAVE_ITEM(S3C_VA_SYS + 0x0218),
+	SAVE_ITEM(S3C_VA_SYS + 0x0220),
+	SAVE_ITEM(S3C_VA_SYS + 0x0230),
+
 	/* GIC side */
 	SAVE_ITEM(S5P_VA_GIC_CPU + 0x000),
 	SAVE_ITEM(S5P_VA_GIC_CPU + 0x004),
@@ -232,11 +286,32 @@ static struct sleep_save exynos4_core_save[] = {
 	SAVE_ITEM(S5P_VA_GIC_DIST + 0xC20),
 	SAVE_ITEM(S5P_VA_GIC_DIST + 0xC24),
 
-
 	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x000),
 	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x010),
 	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x020),
 	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x030),
+	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x040),
+	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x050),
+	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x060),
+	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x070),
+	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x080),
+	SAVE_ITEM(S5P_VA_COMBINER_BASE + 0x090),
+
+	/* SROM side */
+	SAVE_ITEM(S5P_SROM_BW),
+	SAVE_ITEM(S5P_SROM_BC0),
+	SAVE_ITEM(S5P_SROM_BC1),
+	SAVE_ITEM(S5P_SROM_BC2),
+	SAVE_ITEM(S5P_SROM_BC3),
+
+	/* PWM Register */
+	SAVE_ITEM(S3C2410_TCFG0),
+	SAVE_ITEM(S3C2410_TCFG1),
+	SAVE_ITEM(S3C64XX_TINT_CSTAT),
+	SAVE_ITEM(S3C2410_TCON),
+	SAVE_ITEM(S3C2410_TCNTB(0)),
+	SAVE_ITEM(S3C2410_TCMPB(0)),
+	SAVE_ITEM(S3C2410_TCNTO(0)),
 };
 
 static struct sleep_save exynos4_l2cc_save[] = {
-- 
1.7.4.1

