Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab2BWO0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:49 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:24076 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab2BWO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:47 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de
Subject: [PATCH v3 07/21] ARM: at91/pm_slowclock: function slow_clock() accepts parameters
Date: Thu, 23 Feb 2012 15:25:51 +0100
Message-Id: <8ff12ad3df62ee343d5f5ec29572b9d2c5c2cedd.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
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
index c802d30..e31a5f2 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -46,11 +46,11 @@
 #define PLLALOCK_TIMEOUT	1000
 #define PLLBLOCK_TIMEOUT	1000
 
-pmc	.req	r1
-sdramc	.req	r2
+pmc	.req	r0
+sdramc	.req	r1
+ramc1	.req	r2
 tmp1	.req	r3
 tmp2	.req	r4
-ramc1	.req	r5
 
 /*
  * Wait until master clock is ready (after switching master clock source)
@@ -110,21 +110,19 @@ ramc1	.req	r5
 
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

