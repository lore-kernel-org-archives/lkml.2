Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0JYKCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:02:05 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:57905 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0JYKCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:02:03 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2 v2] AT91: pm: make sure that r0 is 0 when dealing with cache operations
Date: Mon, 25 Oct 2010 13:09:06 +0200
Message-Id: <1288004946-9324-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <20101022164247.GB29119@n2100.arm.linux.org.uk>
References: <20101022164247.GB29119@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using CP15 cache operations (c7), we make sure that Rd (r0)
is actually 0 as ARM 926 TRM is saying.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2: modify asm according to Russell's comments: be sure to insert asm lines in
the proper order and inform gcc about register used.

 arch/arm/mach-at91/pm.c           |    9 +++++++--
 arch/arm/mach-at91/pm.h           |    3 ++-
 arch/arm/mach-at91/pm_slowclock.S |    1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 87a31ba..dafbacc 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -261,8 +261,13 @@ static int at91_pm_enter(suspend_state_t state)
 			 * For ARM 926 based chips, this requirement is weaker
 			 * as at91sam9 can access a RAM in self-refresh mode.
 			 */
-			asm("b 1f; .align 5; 1:");
-			asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
+			asm volatile (	"mov r0, #0\n\t"
+					"b 1f\n\t"
+					".align 5\n\t"
+					"1: mcr p15, 0, r0, c7, c10, 4\n\t"
+					: /* no output */
+					: /* no input */
+					: "r0");
 			saved_lpr = sdram_selfrefresh_enable();
 			wait_for_interrupt_enable();
 			sdram_selfrefresh_disable(saved_lpr);
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 2c4424b..ce9a206 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -21,7 +21,8 @@ static inline u32 sdram_selfrefresh_enable(void)
 }
 
 #define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
-#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4")
+#define wait_for_interrupt_enable()		asm volatile ("mcr p15, 0, %0, c7, c0, 4" \
+								: : "r" (0))
 
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

