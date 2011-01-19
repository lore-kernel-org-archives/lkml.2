Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1ASU0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:26:02 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5077 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1ASUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:25:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70910650"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 02/11] msm: Generalize timer register mappings
Date: Wed, 19 Jan 2011 12:25:38 -0800
Message-Id: <1295468747-22796-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the timer register to be determined dynamically instead of at
compile time.  Use common virtual addresses for the registers across
all MSM chips, and select the register mappings based on the detected
CPU.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   10 ++----
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   14 ++------
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   14 ++------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   15 +++-----
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    7 +++-
 arch/arm/mach-msm/io.c                          |   22 ++++++------
 arch/arm/mach-msm/timer.c                       |   43 +++++++++++++---------
 7 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index cfff0e7..1e75ed7 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -1,6 +1,7 @@
 /* arch/arm/mach-msm/include/mach/msm_iomap.h
  *
  * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -47,13 +48,8 @@
 #define MSM_VIC_PHYS          0xC0000000
 #define MSM_VIC_SIZE          SZ_4K
 
-#define MSM_CSR_BASE          IOMEM(0xE0001000)
-#define MSM_CSR_PHYS          0xC0100000
-#define MSM_CSR_SIZE          SZ_4K
-
-#define MSM_GPT_PHYS          MSM_CSR_PHYS
-#define MSM_GPT_BASE          MSM_CSR_BASE
-#define MSM_GPT_SIZE          SZ_4K
+#define MSM7X00_CSR_PHYS      0xC0100000
+#define MSM7X00_CSR_SIZE      SZ_4K
 
 #define MSM_DMOV_BASE         IOMEM(0xE0002000)
 #define MSM_DMOV_PHYS         0xA9700000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 0fd7b68..4d84be1 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011 Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -39,16 +39,8 @@
 #define MSM_VIC_PHYS          0xC0080000
 #define MSM_VIC_SIZE          SZ_4K
 
-#define MSM_CSR_BASE          IOMEM(0xE0001000)
-#define MSM_CSR_PHYS          0xC0100000
-#define MSM_CSR_SIZE          SZ_4K
-
-#define MSM_TMR_PHYS          MSM_CSR_PHYS
-#define MSM_TMR_BASE          MSM_CSR_BASE
-#define MSM_TMR_SIZE          SZ_4K
-
-#define MSM_GPT_BASE 	      (MSM_TMR_BASE + 0x4)
-#define MSM_DGT_BASE 	      (MSM_TMR_BASE + 0x24)
+#define MSM7X30_CSR_PHYS      0xC0100000
+#define MSM7X30_CSR_SIZE      SZ_4K
 
 #define MSM_DMOV_BASE         IOMEM(0xE0002000)
 #define MSM_DMOV_PHYS         0xAC400000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index acc819e..cf1c2df 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011 Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -39,16 +39,8 @@
 #define MSM_VIC_PHYS          0xAC000000
 #define MSM_VIC_SIZE          SZ_4K
 
-#define MSM_CSR_BASE          IOMEM(0xE0001000)
-#define MSM_CSR_PHYS          0xAC100000
-#define MSM_CSR_SIZE          SZ_4K
-
-#define MSM_TMR_PHYS          MSM_CSR_PHYS
-#define MSM_TMR_BASE          MSM_CSR_BASE
-#define MSM_TMR_SIZE          SZ_4K
-
-#define MSM_GPT_BASE          MSM_TMR_BASE
-#define MSM_DGT_BASE          (MSM_TMR_BASE + 0x10)
+#define QSD8X50_CSR_PHYS      0xAC100000
+#define QSD8X50_CSR_SIZE      SZ_4K
 
 #define MSM_DMOV_BASE         IOMEM(0xE0002000)
 #define MSM_DMOV_PHYS         0xA9700000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index a54e33b..d5482d6 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -58,16 +58,11 @@
 #define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
 #define MSM_SHARED_RAM_SIZE	SZ_1M
 
-#define MSM_TMR_BASE		IOMEM(0xF0200000)
-#define MSM_TMR_PHYS		0x02000000
-#define MSM_TMR_SIZE		SZ_4K
+#define MSM8X60_TMR_PHYS	0x02000000
+#define MSM8X60_TMR_SIZE	SZ_4K
 
-#define MSM_TMR0_BASE		IOMEM(0xF0201000)
-#define MSM_TMR0_PHYS		0x02040000
-#define MSM_TMR0_SIZE		SZ_4K
-
-#define MSM_GPT_BASE		(MSM_TMR_BASE + 0x4)
-#define MSM_DGT_BASE		(MSM_TMR_BASE + 0x24)
+#define MSM8X60_TMR0_PHYS	0x02040000
+#define MSM8X60_TMR0_SIZE	SZ_4K
 
 #define MSM_IOMMU_JPEGD_PHYS	0x07300000
 #define MSM_IOMMU_JPEGD_SIZE	SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 8e24dd8..0243bd0 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -53,6 +53,9 @@
 #include "msm_iomap-7x00.h"
 #endif
 
-
+/* Virtual addressses shared across all MSM targets. */
+#define MSM_CSR_BASE		IOMEM(0xE0001000)
+#define MSM_TMR_BASE		IOMEM(0xF0200000)
+#define MSM_TMR0_BASE		IOMEM(0xF0201000)
 
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 800f327..47d699f 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -3,7 +3,7 @@
  * MSM7K, QSD io support
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -28,18 +28,20 @@
 
 #include <mach/board.h>
 
-#define MSM_DEVICE(name) { \
+#define MSM_CHIP_DEVICE(name, chip) {			      \
 		.virtual = (unsigned long) MSM_##name##_BASE, \
-		.pfn = __phys_to_pfn(MSM_##name##_PHYS), \
-		.length = MSM_##name##_SIZE, \
+		.pfn = __phys_to_pfn(chip##_##name##_PHYS), \
+		.length = chip##_##name##_SIZE, \
 		.type = MT_DEVICE_NONSHARED, \
 	 }
 
+#define MSM_DEVICE(name) MSM_CHIP_DEVICE(name, MSM)
+
 #if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
 	|| defined(CONFIG_ARCH_MSM7X25)
 static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
-	MSM_DEVICE(CSR),
+	MSM_CHIP_DEVICE(CSR, MSM7X00),
 	MSM_DEVICE(GPT),
 	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
@@ -73,8 +75,7 @@ void __init msm_map_common_io(void)
 #ifdef CONFIG_ARCH_QSD8X50
 static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
-	MSM_DEVICE(CSR),
-	MSM_DEVICE(TMR),
+	MSM_CHIP_DEVICE(CSR, QSD8X50),
 	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
@@ -104,8 +105,8 @@ void __init msm_map_qsd8x50_io(void)
 static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_DEVICE(QGIC_DIST),
 	MSM_DEVICE(QGIC_CPU),
-	MSM_DEVICE(TMR),
-	MSM_DEVICE(TMR0),
+	MSM_CHIP_DEVICE(TMR, MSM8X60),
+	MSM_CHIP_DEVICE(TMR0, MSM8X60),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
 };
@@ -119,8 +120,7 @@ void __init msm_map_msm8x60_io(void)
 #ifdef CONFIG_ARCH_MSM7X30
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
-	MSM_DEVICE(CSR),
-	MSM_DEVICE(TMR),
+	MSM_CHIP_DEVICE(CSR, MSM7X30),
 	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index c105d28..5548b15 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -24,10 +24,7 @@
 
 #include <asm/mach/time.h>
 #include <mach/msm_iomap.h>
-
-#ifndef MSM_DGT_BASE
-#define MSM_DGT_BASE (MSM_GPT_BASE + 0x10)
-#endif
+#include <mach/cpu.h>
 
 #define TIMER_MATCH_VAL         0x0000
 #define TIMER_COUNT_VAL         0x0004
@@ -52,14 +49,9 @@ enum timer_location {
 	GLOBAL_TIMER = 1,
 };
 
-#ifdef MSM_TMR0_BASE
-#define MSM_TMR_GLOBAL		(MSM_TMR0_BASE - MSM_TMR_BASE)
-#else
-#define MSM_TMR_GLOBAL		0
-#endif
-
 #define MSM_GLOBAL_TIMER MSM_CLOCK_DGT
 
+/* TODO: Remove these ifdefs */
 #if defined(CONFIG_ARCH_QSD8X50)
 #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
 #define MSM_DGT_SHIFT (0)
@@ -177,11 +169,7 @@ static struct msm_clock msm_clocks[] = {
 			.dev_id  = &msm_clocks[0].clockevent,
 			.irq     = INT_GP_TIMER_EXP
 		},
-		.regbase = MSM_GPT_BASE,
 		.freq = GPT_HZ,
-		.local_counter = MSM_GPT_BASE + TIMER_COUNT_VAL,
-		.global_counter = MSM_GPT_BASE + TIMER_COUNT_VAL +
-			MSM_TMR_GLOBAL,
 	},
 	[MSM_CLOCK_DGT] = {
 		.clockevent = {
@@ -206,12 +194,8 @@ static struct msm_clock msm_clocks[] = {
 			.dev_id  = &msm_clocks[1].clockevent,
 			.irq     = INT_DEBUG_TIMER_EXP
 		},
-		.regbase = MSM_DGT_BASE,
 		.freq = DGT_HZ >> MSM_DGT_SHIFT,
 		.shift = MSM_DGT_SHIFT,
-		.local_counter = MSM_DGT_BASE + TIMER_COUNT_VAL,
-		.global_counter = MSM_DGT_BASE + TIMER_COUNT_VAL +
-			MSM_TMR_GLOBAL,
 	}
 };
 
@@ -219,6 +203,25 @@ static void __init msm_timer_init(void)
 {
 	int i;
 	int res;
+	int global_offset = 0;
+
+	if (cpu_is_msm7x01()) {
+		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
+		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
+	} else if (cpu_is_msm7x30()) {
+		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE + 0x04;
+		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x24;
+	} else if (cpu_is_qsd8x50()) {
+		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
+		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
+	} else if (cpu_is_msm8x60()) {
+		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_TMR_BASE + 0x04;
+		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_TMR_BASE + 0x24;
+
+		/* Use CPU0's timer as the global timer. */
+		global_offset = MSM_TMR0_BASE - MSM_TMR_BASE;
+	} else
+		BUG();
 
 #ifdef CONFIG_ARCH_MSM_SCORPIONMP
 	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
@@ -228,6 +231,10 @@ static void __init msm_timer_init(void)
 		struct msm_clock *clock = &msm_clocks[i];
 		struct clock_event_device *ce = &clock->clockevent;
 		struct clocksource *cs = &clock->clocksource;
+
+		clock->local_counter = clock->regbase + TIMER_COUNT_VAL;
+		clock->global_counter = clock->local_counter + global_offset;
+
 		writel(0, clock->regbase + TIMER_ENABLE);
 		writel(0, clock->regbase + TIMER_CLEAR);
 		writel(~0, clock->regbase + TIMER_MATCH_VAL);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

