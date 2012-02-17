Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2BQRu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:50:29 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:57431 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2BQRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:50:27 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] ARM: at91/pm_slowclock: function slow_clock() accepts parameters
Date: Fri, 17 Feb 2012 18:49:58 +0100
Message-Id: <3100bd0c483a03ced617f3ce168e661d6968d21b.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Change slow_clock()/at91_slow_clock() prototype to accept the PMC
base address and one or two RAM controller addresses by parameters.
The r0, r1 and r2 registers are used differently and preserved during
function call.
Those values are defined in pm.c and slow_clock() function is called
from there with its new parameters.

This will allow to have a soc independent pm_slowclock.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Ached-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/pm.c           |   20 +++++++++++++++--
 arch/arm/mach-at91/pm_slowclock.S |   41 ++++++++----------------------------
 2 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index d554e67..aac00ce 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -188,13 +188,27 @@ int at91_suspend_entering_slow_clock(void)
 EXPORT_SYMBOL(at91_suspend_entering_slow_clock);
 
 
-static void (*slow_clock)(void);
+static void (*slow_clock)(void __iomem *pmc, void __iomem *ramc0, void __iomem *ramc1);
 
 #ifdef CONFIG_AT91_SLOW_CLOCK
-extern void at91_slow_clock(void);
+extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0, void __iomem *ramc1);
 extern u32 at91_slow_clock_sz;
 #endif
 
+static void __iomem *at91_pmc_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_PMC);
+#ifdef CONFIG_ARCH_AT91RM9200
+static void __iomem *at91_ramc0_base = (void __iomem*)AT91_VA_BASE_SYS;
+#elif defined(CONFIG_ARCH_AT91SAM9G45)
+static void __iomem *at91_ramc0_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_DDRSDRC0);
+#else
+static void __iomem *at91_ramc0_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_SDRAMC0);
+#endif
+
+#if defined(CONFIG_ARCH_AT91SAM9G45)
+static void __iomem *at91_ramc1_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_DDRSDRC1);
+#else
+static void __iomem *at91_ramc1_base = NULL;
+#endif
 
 static int at91_pm_enter(suspend_state_t state)
 {
@@ -232,7 +246,7 @@ static int at91_pm_enter(suspend_state_t state)
 				/* copy slow_clock handler to SRAM, and call it */
 				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
 #endif
-				slow_clock();
+				slow_clock(at91_pmc_base, at91_ramc0_base, at91_ramc1_base);
 				break;
 			} else {
 				pr_info("AT91: PM - no slow clock mode enabled ...\n");
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 97124f5..33fc4a7 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -46,11 +46,11 @@
 #define PLLALOCK_TIMEOUT	1000
 #define PLLBLOCK_TIMEOUT	1000
 
-#define pmc	r1
-#define sdramc	r2
+#define pmc	r0
+#define sdramc	r1
+#define ramc1	r2
 #define tmp1	r3
 #define tmp2	r4
-#define ramc1	r5
 
 /*
  * Wait until master clock is ready (after switching master clock source)
@@ -110,21 +110,19 @@
 
 	.text
 
+/* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc, void __iomem *ramc1) */
 ENTRY(at91_slow_clock)
 	/* Save registers on stack */
-	stmfd	sp!, {r0 - r12, lr}
+	stmfd	sp!, {r3 - r12, lr}
 
 	/*
 	 * Register usage:
-	 *  R1 = Base address of AT91_PMC
-	 *  R2 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
+	 *  R0 = Base address of AT91_PMC
+	 *  R1 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
+	 *  R2 = Base address of second RAM Controller or 0 if not present
 	 *  R3 = temporary register
 	 *  R4 = temporary register
-	 *  R5 = Base address of second RAM Controller or 0 if not present
 	 */
-	ldr	pmc, .at91_va_base_pmc
-	ldr	sdramc, .at91_va_base_sdramc
-	ldr	ramc1, .at91_va_base_ramc1
 
 	/* Drain write buffer */
 	mov	tmp1, #0
@@ -283,7 +281,7 @@ ENTRY(at91_slow_clock)
 #endif
 
 	/* Restore registers, and return */
-	ldmfd	sp!, {r0 - r12, pc}
+	ldmfd	sp!, {r3 - r12, pc}
 
 
 .saved_mckr:
@@ -301,26 +299,5 @@ ENTRY(at91_slow_clock)
 .saved_sam9_lpr1:
 	.word 0
 
-.at91_va_base_pmc:
-	.word AT91_VA_BASE_SYS + AT91_PMC
-
-#ifdef CONFIG_ARCH_AT91RM9200
-.at91_va_base_sdramc:
-	.word AT91_VA_BASE_SYS
-#elif defined(CONFIG_ARCH_AT91SAM9G45)
-.at91_va_base_sdramc:
-	.word AT91_VA_BASE_SYS + AT91_DDRSDRC0
-#else
-.at91_va_base_sdramc:
-	.word AT91_VA_BASE_SYS + AT91_SDRAMC0
-#endif
-
-.at91_va_base_ramc1:
-#if defined(CONFIG_ARCH_AT91SAM9G45)
-	.word AT91_VA_BASE_SYS + AT91_DDRSDRC1
-#else
-	.word 0
-#endif
-
 ENTRY(at91_slow_clock_sz)
 	.word .-at91_slow_clock
-- 
1.7.9

