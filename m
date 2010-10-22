Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab0JVQVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:21:50 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:48815 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0JVQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:21:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] AT91: pm: use plain cpu_do_idle() for "wait for interrupt"
Date: Fri, 22 Oct 2010 19:28:58 +0200
Message-Id: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power management at91_pm_enter() routine, use the cpu_do_idle() for a
rock solid "wait for interrupt" implementation.
For AT91SAM9 ARM 926 based chips, we can exceed the cache line length as
we can access RAM even while in self-refresh mode.
We keep plain access to CP15 for at91rm9200 as this feature is not
available: instructions have to be in a single cache line.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/pm.c |    6 ++++--
 arch/arm/mach-at91/pm.h |    4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 6156689..87a31ba 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -258,16 +258,18 @@ static int at91_pm_enter(suspend_state_t state)
 			 * NOTE: the Wait-for-Interrupt instruction needs to be
 			 * in icache so no SDRAM accesses are needed until the
 			 * wakeup IRQ occurs and self-refresh is terminated.
+			 * For ARM 926 based chips, this requirement is weaker
+			 * as at91sam9 can access a RAM in self-refresh mode.
 			 */
 			asm("b 1f; .align 5; 1:");
 			asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
 			saved_lpr = sdram_selfrefresh_enable();
-			asm("mcr p15, 0, r0, c7, c0, 4");	/* wait for interrupt */
+			wait_for_interrupt_enable();
 			sdram_selfrefresh_disable(saved_lpr);
 			break;
 
 		case PM_SUSPEND_ON:
-			asm("mcr p15, 0, r0, c7, c0, 4");	/* wait for interrupt */
+			cpu_do_idle();
 			break;
 
 		default:
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 8c87d0c..2c4424b 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -21,6 +21,7 @@ static inline u32 sdram_selfrefresh_enable(void)
 }
 
 #define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
+#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4")
 
 #elif defined(CONFIG_ARCH_AT91CAP9)
 #include <mach/at91cap9_ddrsdr.h>
@@ -38,6 +39,7 @@ static inline u32 sdram_selfrefresh_enable(void)
 }
 
 #define sdram_selfrefresh_disable(saved_lpr)	at91_ramc_write(0, AT91_DDRSDRC_LPR, saved_lpr)
+#define wait_for_interrupt_enable()		cpu_do_idle()
 
 #elif defined(CONFIG_ARCH_AT91SAM9G45)
 #include <mach/at91sam9_ddrsdr.h>
@@ -74,6 +76,7 @@ static inline u32 sdram_selfrefresh_enable(void)
 		at91_ramc_write(0, AT91_DDRSDRC_LPR, saved_lpr0); \
 		at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1); \
 	} while (0)
+#define wait_for_interrupt_enable()		cpu_do_idle()
 
 #else
 #include <mach/at91sam9_sdramc.h>
@@ -98,5 +101,6 @@ static inline u32 sdram_selfrefresh_enable(void)
 }
 
 #define sdram_selfrefresh_disable(saved_lpr)	at91_ramc_write(0, AT91_SDRAMC_LPR, saved_lpr)
+#define wait_for_interrupt_enable()		cpu_do_idle()
 
 #endif
-- 
1.7.3

