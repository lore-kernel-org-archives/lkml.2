Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1KHSdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:33:09 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7795 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1KHSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:33:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133441769"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 1/2] ARM: msm: Consolidate and move DEBUG_LL to DEBUG_LL choice
Date: Tue,  8 Nov 2011 10:33:03 -0800
Message-Id: <1320777184-22446-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
References: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that DEBUG_LL is a choice we can move MSM's homegrown choice
menu to DEBUG_LL.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig.debug                          |   21 +++++++++++++++
 arch/arm/mach-msm/Kconfig                       |   32 -----------------------
 arch/arm/mach-msm/include/mach/debug-macro.S    |   19 ++-----------
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   12 --------
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   12 --------
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   12 --------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |   12 ++++++++
 arch/arm/mach-msm/io.c                          |    9 ++++--
 8 files changed, 42 insertions(+), 87 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index c5213e7..333b6a4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -247,6 +247,27 @@ choice
 		  their output to the standard serial port on the RealView
 		  PB1176 platform.
 
+	config DEBUG_MSM_UART1
+		bool "Kernel low-level debugging messages via MSM UART1"
+		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the first serial port on MSM devices.
+
+	config DEBUG_MSM_UART2
+		bool "Kernel low-level debugging messages via MSM UART2"
+		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the second serial port on MSM devices.
+
+	config DEBUG_MSM_UART3
+		bool "Kernel low-level debugging messages via MSM UART3"
+		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the third serial port on MSM devices.
+
 endchoice
 
 config EARLY_PRINTK
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index ebde97f..5b07b61 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -13,7 +13,6 @@ config ARCH_MSM7X00A
 	select CPU_V6
 	select GPIO_MSM_V1
 	select MSM_PROC_COMM
-	select HAS_MSM_DEBUG_UART_PHYS
 
 config ARCH_MSM7X30
 	bool "MSM7x30"
@@ -25,7 +24,6 @@ config ARCH_MSM7X30
 	select MSM_GPIOMUX
 	select GPIO_MSM_V1
 	select MSM_PROC_COMM
-	select HAS_MSM_DEBUG_UART_PHYS
 
 config ARCH_QSD8X50
 	bool "QSD8X50"
@@ -37,7 +35,6 @@ config ARCH_QSD8X50
 	select MSM_GPIOMUX
 	select GPIO_MSM_V1
 	select MSM_PROC_COMM
-	select HAS_MSM_DEBUG_UART_PHYS
 
 config ARCH_MSM8X60
 	bool "MSM8X60"
@@ -73,9 +70,6 @@ config  ARCH_MSM_ARM11
 config  ARCH_MSM_SCORPION
 	bool
 
-config HAS_MSM_DEBUG_UART_PHYS
-	bool
-
 config  MSM_VIC
 	bool
 
@@ -152,32 +146,6 @@ config MACH_MSM8960_RUMI3
 
 endmenu
 
-config MSM_DEBUG_UART
-	int
-	default 1 if MSM_DEBUG_UART1
-	default 2 if MSM_DEBUG_UART2
-	default 3 if MSM_DEBUG_UART3
-
-if HAS_MSM_DEBUG_UART_PHYS
-choice
-	prompt "Debug UART"
-
-	default MSM_DEBUG_UART_NONE
-
-	config MSM_DEBUG_UART_NONE
-		bool "None"
-
-	config MSM_DEBUG_UART1
-		bool "UART1"
-
-	config MSM_DEBUG_UART2
-		bool "UART2"
-
-	config MSM_DEBUG_UART3
-		bool "UART3"
-endchoice
-endif
-
 config MSM_SMD_PKG3
 	bool
 
diff --git a/arch/arm/mach-msm/include/mach/debug-macro.S b/arch/arm/mach-msm/include/mach/debug-macro.S
index 2dc73cc..db1f228 100644
--- a/arch/arm/mach-msm/include/mach/debug-macro.S
+++ b/arch/arm/mach-msm/include/mach/debug-macro.S
@@ -1,4 +1,4 @@
-/* arch/arm/mach-msm7200/include/mach/debug-macro.S
+/*
  *
  * Copyright (C) 2007 Google, Inc.
  * Author: Brian Swetland <swetland@google.com>
@@ -14,15 +14,14 @@
  *
  */
 
-
-
 #include <mach/hardware.h>
 #include <mach/msm_iomap.h>
 
-#if defined(CONFIG_HAS_MSM_DEBUG_UART_PHYS) && !defined(CONFIG_MSM_DEBUG_UART_NONE)
 	.macro	addruart, rp, rv, tmp
+#ifdef MSM_DEBUG_UART_PHYS
 	ldr	\rp, =MSM_DEBUG_UART_PHYS
 	ldr	\rv, =MSM_DEBUG_UART_BASE
+#endif
 	.endm
 
 	.macro	senduart,rd,rx
@@ -36,18 +35,6 @@
 	tst	\rd, #0x04
 	beq	1001b
 	.endm
-#else
-	.macro  addruart, rp, rv, tmp
-	mov	\rv, #0xff000000
-	orr	\rv, \rv, #0x00f00000
-	.endm
-
-	.macro	senduart,rd,rx
-	.endm
-
-	.macro	waituart,rd,rx
-	.endm
-#endif
 
 	.macro	busyuart,rd,rx
 	.endm
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 94fe9fe..8af4612 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -78,18 +78,6 @@
 #define MSM_UART3_PHYS        0xA9C00000
 #define MSM_UART3_SIZE        SZ_4K
 
-#ifdef CONFIG_MSM_DEBUG_UART
-#define MSM_DEBUG_UART_BASE   0xE1000000
-#if CONFIG_MSM_DEBUG_UART == 1
-#define MSM_DEBUG_UART_PHYS   MSM_UART1_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 2
-#define MSM_DEBUG_UART_PHYS   MSM_UART2_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 3
-#define MSM_DEBUG_UART_PHYS   MSM_UART3_PHYS
-#endif
-#define MSM_DEBUG_UART_SIZE   SZ_4K
-#endif
-
 #define MSM_SDC1_PHYS         0xA0400000
 #define MSM_SDC1_SIZE         SZ_4K
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 3769444..198202c 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -89,18 +89,6 @@
 #define MSM_UART3_PHYS        0xACC00000
 #define MSM_UART3_SIZE        SZ_4K
 
-#ifdef CONFIG_MSM_DEBUG_UART
-#define MSM_DEBUG_UART_BASE   0xE1000000
-#if CONFIG_MSM_DEBUG_UART == 1
-#define MSM_DEBUG_UART_PHYS   MSM_UART1_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 2
-#define MSM_DEBUG_UART_PHYS   MSM_UART2_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 3
-#define MSM_DEBUG_UART_PHYS   MSM_UART3_PHYS
-#endif
-#define MSM_DEBUG_UART_SIZE   SZ_4K
-#endif
-
 #define MSM_MDC_BASE	      IOMEM(0xE0200000)
 #define MSM_MDC_PHYS	      0xAA500000
 #define MSM_MDC_SIZE	      SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index d67cd73..0faa894 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -83,18 +83,6 @@
 #define MSM_UART3_PHYS        0xA9C00000
 #define MSM_UART3_SIZE        SZ_4K
 
-#ifdef CONFIG_MSM_DEBUG_UART
-#define MSM_DEBUG_UART_BASE   0xE1000000
-#if CONFIG_MSM_DEBUG_UART == 1
-#define MSM_DEBUG_UART_PHYS   MSM_UART1_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 2
-#define MSM_DEBUG_UART_PHYS   MSM_UART2_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 3
-#define MSM_DEBUG_UART_PHYS   MSM_UART3_PHYS
-#endif
-#define MSM_DEBUG_UART_SIZE   SZ_4K
-#endif
-
 #define MSM_MDC_BASE	      IOMEM(0xE0200000)
 #define MSM_MDC_PHYS	      0xAA500000
 #define MSM_MDC_SIZE	      SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 4ded152..90682f4 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -55,6 +55,18 @@
 
 #include "msm_iomap-8960.h"
 
+#define MSM_DEBUG_UART_SIZE	SZ_4K
+#if defined(CONFIG_DEBUG_MSM_UART1)
+#define MSM_DEBUG_UART_BASE	0xE1000000
+#define MSM_DEBUG_UART_PHYS	MSM_UART1_PHYS
+#elif defined(CONFIG_DEBUG_MSM_UART2)
+#define MSM_DEBUG_UART_BASE	0xE1000000
+#define MSM_DEBUG_UART_PHYS	MSM_UART2_PHYS
+#elif defined(CONFIG_DEBUG_MSM_UART3)
+#define MSM_DEBUG_UART_BASE	0xE1000000
+#define MSM_DEBUG_UART_PHYS	MSM_UART3_PHYS
+#endif
+
 /* Virtual addresses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
 #define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 8759ecf..03036af 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -47,7 +47,8 @@ static struct map_desc msm_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
 	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
 	MSM_DEVICE(CLK_CTL),
-#ifdef CONFIG_MSM_DEBUG_UART
+#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
+	defined(CONFIG_DEBUG_MSM_UART3)
 	MSM_DEVICE(DEBUG_UART),
 #endif
 #ifdef CONFIG_ARCH_MSM7X30
@@ -84,7 +85,8 @@ static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(SCPLL),
 	MSM_DEVICE(AD5),
 	MSM_DEVICE(MDC),
-#ifdef CONFIG_MSM_DEBUG_UART
+#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
+	defined(CONFIG_DEBUG_MSM_UART3)
 	MSM_DEVICE(DEBUG_UART),
 #endif
 	{
@@ -146,7 +148,8 @@ static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(SAW),
 	MSM_DEVICE(GCC),
 	MSM_DEVICE(TCSR),
-#ifdef CONFIG_MSM_DEBUG_UART
+#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
+	defined(CONFIG_DEBUG_MSM_UART3)
 	MSM_DEVICE(DEBUG_UART),
 #endif
 	{
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

