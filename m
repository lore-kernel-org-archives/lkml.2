Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2BWO0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:33 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:62005 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab2BWO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:29 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de
Subject: [PATCH v3 10/21] ARM: at91/pm_slowclock: add runtime detection of memory contoller
Date: Thu, 23 Feb 2012 15:25:54 +0100
Message-Id: <fb7e197bec45f15299315ed14292f09086d90a0b.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

This will allow to have all SoC in one kernel image.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/at91_ramc.h |    9 ++--
 arch/arm/mach-at91/pm.c                     |   15 +++++-
 arch/arm/mach-at91/pm_slowclock.S           |   66 +++++++++++++++++++++------
 3 files changed, 68 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_ramc.h b/arch/arm/mach-at91/include/mach/at91_ramc.h
index 3155499..d8aeb27 100644
--- a/arch/arm/mach-at91/include/mach/at91_ramc.h
+++ b/arch/arm/mach-at91/include/mach/at91_ramc.h
@@ -21,11 +21,12 @@ extern void __iomem *at91_ramc_base[];
 .extern at91_ramc_base
 #endif
 
-#ifdef CONFIG_ARCH_AT91RM9200
-#include <mach/at91rm9200_mc.h>
-#else
+#define AT91_MEMCTRL_MC		0
+#define AT91_MEMCTRL_SDRAMC	1
+#define AT91_MEMCTRL_DDRSDR	2
+
+#include <mach/at91rm9200_sdramc.h>
 #include <mach/at91sam9_ddrsdr.h>
 #include <mach/at91sam9_sdramc.h>
-#endif
 
 #endif /* __AT91_RAMC_H__ */
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 46dbb7e..2793591 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -188,10 +188,12 @@ int at91_suspend_entering_slow_clock(void)
 EXPORT_SYMBOL(at91_suspend_entering_slow_clock);
 
 
-static void (*slow_clock)(void __iomem *pmc, void __iomem *ramc0, void __iomem *ramc1);
+static void (*slow_clock)(void __iomem *pmc, void __iomem *ramc0,
+			  void __iomem *ramc1, int memctrl);
 
 #ifdef CONFIG_AT91_SLOW_CLOCK
-extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0, void __iomem *ramc1);
+extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
+			    void __iomem *ramc1, int memctrl);
 extern u32 at91_slow_clock_sz;
 #endif
 
@@ -241,11 +243,18 @@ static int at91_pm_enter(suspend_state_t state)
 			 * turning off the main oscillator; reverse on wakeup.
 			 */
 			if (slow_clock) {
+				int memctrl = AT91_MEMCTRL_SDRAMC;
+
+				if (cpu_is_at91rm9200())
+					memctrl = AT91_MEMCTRL_MC;
+				else if (cpu_is_at91sam9g45())
+					memctrl = AT91_MEMCTRL_DDRSDR;
 #ifdef CONFIG_AT91_SLOW_CLOCK
 				/* copy slow_clock handler to SRAM, and call it */
 				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
 #endif
-				slow_clock(at91_pmc_base, at91_ramc_base[0], at91_ramc_base[1]);
+				slow_clock(at91_pmc_base, at91_ramc_base[0],
+					   at91_ramc_base[1], memctrl);
 				break;
 			} else {
 				pr_info("AT91: PM - no slow clock mode enabled ...\n");
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index a2835a8..2c46010 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -42,8 +42,9 @@
 pmc	.req	r0
 sdramc	.req	r1
 ramc1	.req	r2
-tmp1	.req	r3
-tmp2	.req	r4
+memctrl	.req	r3
+tmp1	.req	r4
+tmp2	.req	r5
 
 /*
  * Wait until master clock is ready (after switching master clock source)
@@ -103,29 +104,44 @@ tmp2	.req	r4
 
 	.text
 
-/* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc, void __iomem *ramc1) */
+/* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc,
+ *			void __iomem *ramc1, int memctrl)
+ */
 ENTRY(at91_slow_clock)
 	/* Save registers on stack */
-	stmfd	sp!, {r3 - r12, lr}
+	stmfd	sp!, {r4 - r12, lr}
 
 	/*
 	 * Register usage:
 	 *  R0 = Base address of AT91_PMC
 	 *  R1 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
 	 *  R2 = Base address of second RAM Controller or 0 if not present
-	 *  R3 = temporary register
+	 *  R3 = Memory controller
 	 *  R4 = temporary register
+	 *  R5 = temporary register
 	 */
 
 	/* Drain write buffer */
 	mov	tmp1, #0
 	mcr	p15, 0, tmp1, c7, c10, 4
 
-#ifdef CONFIG_ARCH_AT91RM9200
+	cmp	memctrl, #AT91_MEMCTRL_MC
+	bne	ddr_sr_enable
+
+	/*
+	 * at91rm9200 Memory controller
+	 */
 	/* Put SDRAM in self-refresh mode */
 	mov	tmp1, #1
 	str	tmp1, [sdramc, #AT91RM9200_SDRAMC_SRR]
-#elif defined(CONFIG_ARCH_AT91SAM9G45)
+	b	sdr_sr_done
+
+	/*
+	 * DDRSDR Memory controller
+	 */
+ddr_sr_enable:
+	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
+	bne	sdr_sr_enable
 
 	/* prepare for DDRAM self-refresh mode */
 	ldr	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
@@ -143,7 +159,13 @@ ENTRY(at91_slow_clock)
 	/* Enable DDRAM self-refresh mode */
 	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
 	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
-#else
+
+	b	sdr_sr_done
+
+	/*
+	 * SDRAMC Memory controller
+	 */
+sdr_sr_enable:
 	/* Enable SDRAM self-refresh mode */
 	ldr	tmp1, [sdramc, #AT91_SDRAMC_LPR]
 	str	tmp1, .saved_sam9_lpr
@@ -151,8 +173,8 @@ ENTRY(at91_slow_clock)
 	bic	tmp1, #AT91_SDRAMC_LPCB
 	orr	tmp1, #AT91_SDRAMC_LPCB_SELF_REFRESH
 	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
-#endif
 
+sdr_sr_done:
 	/* Save Master clock setting */
 	ldr	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
 	str	tmp1, .saved_mckr
@@ -255,9 +277,18 @@ ENTRY(at91_slow_clock)
 
 	wait_mckrdy
 
-#ifdef CONFIG_ARCH_AT91RM9200
-	/* Do nothing - self-refresh is automatically disabled. */
-#elif defined(CONFIG_ARCH_AT91SAM9G45)
+	/*
+	 * at91rm9200 Memory controller
+	 * Do nothing - self-refresh is automatically disabled.
+	 */
+	cmp	memctrl, #AT91_MEMCTRL_MC
+	beq	ram_restored
+
+	/*
+	 * DDRSDR Memory controller
+	 */
+	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
+	bne	sdr_en_restore
 	/* Restore LPR on AT91 with DDRAM */
 	ldr	tmp1, .saved_sam9_lpr
 	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
@@ -267,14 +298,19 @@ ENTRY(at91_slow_clock)
 	ldrne	tmp2, .saved_sam9_lpr1
 	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
 
-#else
+	b	ram_restored
+
+	/*
+	 * SDRAMC Memory controller
+	 */
+sdr_en_restore:
 	/* Restore LPR on AT91 with SDRAM */
 	ldr	tmp1, .saved_sam9_lpr
 	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
-#endif
 
+ram_restored:
 	/* Restore registers, and return */
-	ldmfd	sp!, {r3 - r12, pc}
+	ldmfd	sp!, {r4 - r12, pc}
 
 
 .saved_mckr:
-- 
1.7.9

