Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0JVQWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:22:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:65205 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0JVQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:21:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] AT91: pm: make sure that r0 is 0 when dealing with cache operations
Date: Fri, 22 Oct 2010 19:29:00 +0200
Message-Id: <86bb15f5a1aa3f21066ed13d7ee3f9f500d11087.1287767949.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
References: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
In-Reply-To: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
References: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using CP15 cache operations (c7), we make sure that Rd (r0)
is actually 0 as ARM 926 TRM is saying.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/pm.c           |    1 +
 arch/arm/mach-at91/pm.h           |    2 +-
 arch/arm/mach-at91/pm_slowclock.S |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 87a31ba..1d9f204 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -261,6 +261,7 @@ static int at91_pm_enter(suspend_state_t state)
 			 * For ARM 926 based chips, this requirement is weaker
 			 * as at91sam9 can access a RAM in self-refresh mode.
 			 */
+			asm("mov r0, #0");			/* clear r0 for CP15 accesses */
 			asm("b 1f; .align 5; 1:");
 			asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
 			saved_lpr = sdram_selfrefresh_enable();
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 2c4424b..be081c9 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -21,7 +21,7 @@ static inline u32 sdram_selfrefresh_enable(void)
 }
 
 #define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
-#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4")
+#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4") /* r0 is 0 here */
 
 #elif defined(CONFIG_ARCH_AT91CAP9)
 #include <mach/at91cap9_ddrsdr.h>
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index b6b00a1..f7922a4 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -124,6 +124,7 @@ ENTRY(at91_slow_clock)
 	ldr	r5, .at91_va_base_ramc1
 
 	/* Drain write buffer */
+	mov	r0, #0
 	mcr	p15, 0, r0, c7, c10, 4
 
 #ifdef CONFIG_ARCH_AT91RM9200
-- 
1.7.3

