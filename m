Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0JNQSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:18:13 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:21170 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0JNQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:18:11 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com, phorton@bitbox.co.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/5] AT91: reset routine cleanup
Date: Thu, 14 Oct 2010 19:25:04 +0200
Message-Id: <a7729a9f07e50d8c9f8d72d345a158a54b0c70e7.1287076894.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <20100528153725.GA5102@axolotl.localnet>
References: <20100528153725.GA5102@axolotl.localnet>
In-Reply-To: <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
References: <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize assembler reset routine to allow use on several at91sam9 chips.
This patch replace double definitions of SDRAM controller registers and RSTC
registers with use of classical header files.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9260.c       |    4 +-
 arch/arm/mach-at91/at91sam9g20_reset.S |   44 ++++++++++++++-----------------
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index f884450..dfd3529 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -25,7 +25,7 @@
 #include "generic.h"
 #include "clock.h"
 
-extern void at91sam9g20_reset(void);
+extern void at91sam9_alt_reset(void);
 
 static struct map_desc at91sam9260_io_desc[] __initdata = {
 	{
@@ -330,7 +330,7 @@ void __init at91sam9260_initialize(unsigned long main_clock)
 		iotable_init(at91sam9260_sram_desc, ARRAY_SIZE(at91sam9260_sram_desc));
 
 	if (cpu_is_at91sam9g20())
-		at91_arch_reset = at91sam9g20_reset;
+		at91_arch_reset = at91sam9_alt_reset;
 	else
 		at91_arch_reset = at91sam9260_reset;
 
diff --git a/arch/arm/mach-at91/at91sam9g20_reset.S b/arch/arm/mach-at91/at91sam9g20_reset.S
index 1631c38..2e5c70d 100644
--- a/arch/arm/mach-at91/at91sam9g20_reset.S
+++ b/arch/arm/mach-at91/at91sam9g20_reset.S
@@ -13,43 +13,39 @@
  * (at your option) any later version.
  */
 
-#define CP15_CR_I			(1 << 12)
-
-#define SYS_VIRT_OFS			(-0x01000000)
-
-#define SDRAMC_BASE			(SYS_VIRT_OFS + 0xffffea00)
-#define  SDRAMC_TR			0x0004
-#define  SDRAMC_LPR			0x0010
-#define   SDRAMC_LPCB_POWER_DOWN	2
-
-#define RSTC_BASE			(SYS_VIRT_OFS + 0xfffffd00)
-#define  RSTC_CR			0x0000
-#define   RSTC_PROCRST			(1 << 0)
-#define   RSTC_PERRST			(1 << 2)
-#define   RSTC_KEY			(0xa5 << 24)
+#include <linux/linkage.h>
+#include <asm/system.h>
+#include <mach/hardware.h>
+#include <mach/at91sam9_sdramc.h>
+#include <mach/at91_rstc.h>
 
 			.arm
 
-			.globl	at91sam9g20_reset
+			.globl	at91sam9_alt_reset
 
-at91sam9g20_reset:	mov	r0, #0
+at91sam9_alt_reset:	mov	r0, #0
 			mcr	p15, 0, r0, c7, c5, 0		@ flush I-cache
 
 			mrc	p15, 0, r0, c1, c0, 0
-			orr	r0, r0, #CP15_CR_I
+			orr	r0, r0, #CR_I
 			mcr	p15, 0, r0, c1, c0, 0		@ enable I-cache
 
-			ldr	r0, =SDRAMC_BASE		@ preload constants
-			ldr	r1, =RSTC_BASE
+			ldr	r0, .at91_va_base_sdramc	@ preload constants
+			ldr	r1, .at91_va_base_rstc_cr
 
 			mov	r2, #1
-			mov	r3, #SDRAMC_LPCB_POWER_DOWN
-			ldr	r4, =RSTC_KEY | RSTC_PERRST | RSTC_PROCRST
+			mov	r3, #AT91_SDRAMC_LPCB_POWER_DOWN
+			ldr	r4, =AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST
 
 			.balign	32				@ align to cache line
 
-			str	r2, [r0, #SDRAMC_TR]		@ disable SDRAM access
-			str	r3, [r0, #SDRAMC_LPR]		@ power down SDRAM
-			str	r4, [r1, #RSTC_CR]		@ reset processor
+			str	r2, [r0, #AT91_SDRAMC_TR]	@ disable SDRAM access
+			str	r3, [r0, #AT91_SDRAMC_LPR]	@ power down SDRAM
+			str	r4, [r1]			@ reset processor
 
 			b	.
+
+.at91_va_base_sdramc:
+	.word AT91_VA_BASE_SYS + AT91_SDRAMC0
+.at91_va_base_rstc_cr:
+	.word AT91_VA_BASE_SYS + AT91_RSTC_CR
-- 
1.7.3

