Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1KHSdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:33:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7781 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab1KHSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:33:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135802026"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCHv3 2/2] msm: Support DEBUG_LL on MSM8660 and MSM8960
Date: Tue,  8 Nov 2011 10:33:04 -0800
Message-Id: <1320777184-22446-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
References: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DEBUG_LL on the 8660 and 8960 development boards.
While we're here cleanup the uncompress.h code a bit. Avoid
the use of readl/writel as those are Linux specific APIs that
aren't guaranteed to work in the decompressor.

Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v2:
 * Don't use readl/writel in uncompress.h
 * Fix 8660 help text

 arch/arm/Kconfig.debug                          |   16 +++++++++
 arch/arm/mach-msm/Kconfig                       |    3 ++
 arch/arm/mach-msm/include/mach/debug-macro.S    |   32 +++++++++++++++++--
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    5 +++
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 +++
 arch/arm/mach-msm/include/mach/uncompress.h     |   39 ++++++++++++++++++-----
 arch/arm/mach-msm/io.c                          |    6 +++
 7 files changed, 95 insertions(+), 11 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 333b6a4..4c1eb7d 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -268,6 +268,22 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the third serial port on MSM devices.
 
+	config DEBUG_MSM8660_UART
+		bool "Kernel low-level debugging messages via MSM 8660 UART"
+		depends on ARCH_MSM8X60
+		select MSM_HAS_DEBUG_UART_HS
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the serial port on MSM 8660 devices.
+
+	config DEBUG_MSM8960_UART
+		bool "Kernel low-level debugging messages via MSM 8960 UART"
+		depends on ARCH_MSM8960
+		select MSM_HAS_DEBUG_UART_HS
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the serial port on MSM 8960 devices.
+
 endchoice
 
 config EARLY_PRINTK
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 5b07b61..000ddf0 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -60,6 +60,9 @@ config ARCH_MSM8960
 
 endchoice
 
+config MSM_HAS_DEBUG_UART_HS
+	bool
+
 config MSM_SOC_REV_A
 	bool
 config  ARCH_MSM_SCORPIONMP
diff --git a/arch/arm/mach-msm/include/mach/debug-macro.S b/arch/arm/mach-msm/include/mach/debug-macro.S
index db1f228..3ffd866 100644
--- a/arch/arm/mach-msm/include/mach/debug-macro.S
+++ b/arch/arm/mach-msm/include/mach/debug-macro.S
@@ -1,6 +1,7 @@
 /*
  *
  * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
  *
  * This software is licensed under the terms of the GNU General Public
@@ -24,17 +25,42 @@
 #endif
 	.endm
 
-	.macro	senduart,rd,rx
+	.macro	senduart, rd, rx
+#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+	@ Write the 1 character to UARTDM_TF
+	str	\rd, [\rx, #0x70]
+#else
 	teq	\rx, #0
 	strne	\rd, [\rx, #0x0C]
+#endif
 	.endm
 
-	.macro	waituart,rd,rx
+	.macro	waituart, rd, rx
+#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+	@ check for TX_EMT in UARTDM_SR
+	ldr	\rd, [\rx, #0x08]
+	tst	\rd, #0x08
+	bne	1002f
+	@ wait for TXREADY in UARTDM_ISR
+1001:	ldr	\rd, [\rx, #0x14]
+	tst	\rd, #0x80
+	beq 	1001b
+1002:
+	@ Clear TX_READY by writing to the UARTDM_CR register
+	mov	\rd, #0x300
+	str	\rd, [\rx, #0x10]
+	@ Write 0x1 to NCF register
+	mov 	\rd, #0x1
+	str	\rd, [\rx, #0x40]
+	@ UARTDM reg. Read to induce delay
+	ldr	\rd, [\rx, #0x08]
+#else
 	@ wait for TX_READY
 1001:	ldr	\rd, [\rx, #0x08]
 	tst	\rd, #0x04
 	beq	1001b
+#endif
 	.endm
 
-	.macro	busyuart,rd,rx
+	.macro	busyuart, rd, rx
 	.endm
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 3c9d960..800b557 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -45,4 +45,9 @@
 #define MSM8960_TMR0_PHYS	0x0208A000
 #define MSM8960_TMR0_SIZE	SZ_4K
 
+#ifdef CONFIG_DEBUG_MSM8960_UART
+#define MSM_DEBUG_UART_BASE	0xE1040000
+#define MSM_DEBUG_UART_PHYS	0x16440000
+#endif
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 3b19b8f..54e12ca 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -62,4 +62,9 @@
 #define MSM8X60_TMR0_PHYS	0x02040000
 #define MSM8X60_TMR0_SIZE	SZ_4K
 
+#ifdef CONFIG_DEBUG_MSM8660_UART
+#define MSM_DEBUG_UART_BASE	0xE1040000
+#define MSM_DEBUG_UART_PHYS	0x19C40000
+#endif
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h
index d94292c..169a840 100644
--- a/arch/arm/mach-msm/include/mach/uncompress.h
+++ b/arch/arm/mach-msm/include/mach/uncompress.h
@@ -1,6 +1,6 @@
-/* arch/arm/mach-msm/include/mach/uncompress.h
- *
+/*
  * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -14,17 +14,40 @@
  */
 
 #ifndef __ASM_ARCH_MSM_UNCOMPRESS_H
+#define __ASM_ARCH_MSM_UNCOMPRESS_H
+
+#include <asm/processor.h>
+#include <mach/msm_iomap.h>
+
+#define UART_CSR      (*(volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x08))
+#define UART_TF       (*(volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x0c))
 
-#include "hardware.h"
-#include "linux/io.h"
-#include "mach/msm_iomap.h"
+#define UART_DM_SR    (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x08)))
+#define UART_DM_CR    (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x10)))
+#define UART_DM_ISR   (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x14)))
+#define UART_DM_NCHAR (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x40)))
+#define UART_DM_TF    (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x70)))
 
 static void putc(int c)
 {
 #if defined(MSM_DEBUG_UART_PHYS)
-	unsigned base = MSM_DEBUG_UART_PHYS;
-	while (!(readl(base + 0x08) & 0x04)) ;
-	writel(c, base + 0x0c);
+#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+	/*
+	 * Wait for TX_READY to be set; but skip it if we have a
+	 * TX underrun.
+	 */
+	if (UART_DM_SR & 0x08)
+		while (!(UART_DM_ISR & 0x80))
+			cpu_relax();
+
+	UART_DM_CR = 0x300;
+	UART_DM_NCHAR = 0x1;
+	UART_DM_TF = c;
+#else
+	while (!(UART_CSR & 0x04))
+		cpu_relax();
+	UART_TF = c;
+#endif
 #endif
 }
 
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 03036af..578b04e 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -111,6 +111,9 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
+#ifdef CONFIG_DEBUG_MSM8660_UART
+	MSM_DEVICE(DEBUG_UART),
+#endif
 };
 
 void __init msm_map_msm8x60_io(void)
@@ -125,6 +128,9 @@ static struct map_desc msm8960_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(QGIC_CPU, MSM8960),
 	MSM_CHIP_DEVICE(TMR, MSM8960),
 	MSM_CHIP_DEVICE(TMR0, MSM8960),
+#ifdef CONFIG_DEBUG_MSM8960_UART
+	MSM_DEVICE(DEBUG_UART),
+#endif
 };
 
 void __init msm_map_msm8960_io(void)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

