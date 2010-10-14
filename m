Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0JNQSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:18:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:54083 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab0JNQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:18:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com, phorton@bitbox.co.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/5] Fix AT91SAM9G20 reset as per the errata in the data sheet
Date: Thu, 14 Oct 2010 19:25:02 +0200
Message-Id: <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <20100528153725.GA5102@axolotl.localnet>
References: <20100528153725.GA5102@axolotl.localnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Horton <phorton@bitbox.co.uk>

If the SDRAM is not cleanly shutdown before reset it can be left driving
the bus, which then stops the bootloader booting from NAND.

Signed-off-by: Peter Horton <phorton@bitbox.co.uk>
[nicolas.ferre@atmel.com: change file header line order]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile            |    2 +-
 arch/arm/mach-at91/at91sam9260.c       |    8 ++++-
 arch/arm/mach-at91/at91sam9g20_reset.S |   55 ++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-at91/at91sam9g20_reset.S

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 88e55e3..d4bb704 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_ARCH_AT91SAM9261)	+= at91sam9261.o at91sam926x_time.o at91sam9261_d
 obj-$(CONFIG_ARCH_AT91SAM9G10)	+= at91sam9261.o at91sam926x_time.o at91sam9261_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263.o at91sam926x_time.o at91sam9263_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl.o at91sam926x_time.o at91sam9rl_devices.o sam9_smc.o
-obj-$(CONFIG_ARCH_AT91SAM9G20)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o sam9_smc.o
+obj-$(CONFIG_ARCH_AT91SAM9G20)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o sam9_smc.o at91sam9g20_reset.o
 obj-$(CONFIG_ARCH_AT91SAM9G45)	+= at91sam9g45.o at91sam926x_time.o at91sam9g45_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT91CAP9)	+= at91cap9.o at91sam926x_time.o at91cap9_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT572D940HF)  += at572d940hf.o at91sam926x_time.o at572d940hf_devices.o sam9_smc.o
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 0894f10..f884450 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -25,6 +25,8 @@
 #include "generic.h"
 #include "clock.h"
 
+extern void at91sam9g20_reset(void);
+
 static struct map_desc at91sam9260_io_desc[] __initdata = {
 	{
 		.virtual	= AT91_VA_BASE_SYS,
@@ -327,7 +329,11 @@ void __init at91sam9260_initialize(unsigned long main_clock)
 	else
 		iotable_init(at91sam9260_sram_desc, ARRAY_SIZE(at91sam9260_sram_desc));
 
-	at91_arch_reset = at91sam9260_reset;
+	if (cpu_is_at91sam9g20())
+		at91_arch_reset = at91sam9g20_reset;
+	else
+		at91_arch_reset = at91sam9260_reset;
+
 	pm_power_off = at91sam9260_poweroff;
 	at91_extern_irq = (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IRQ1)
 			| (1 << AT91SAM9260_ID_IRQ2);
diff --git a/arch/arm/mach-at91/at91sam9g20_reset.S b/arch/arm/mach-at91/at91sam9g20_reset.S
new file mode 100644
index 0000000..f6e9b03
--- /dev/null
+++ b/arch/arm/mach-at91/at91sam9g20_reset.S
@@ -0,0 +1,55 @@
+/*
+ * reset AT91SAM9G20 as per errata
+ *
+ * (C) BitBox Ltd 2010
+ *
+ * unless the SDRAM is cleanly shutdown before we hit the
+ * reset register it can be left driving the data bus and
+ * killing the chance of a subsequent boot from NAND
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#define CP15_CR_I			(1 << 12)
+
+#define SYS_VIRT_OFS			(-0x01000000)
+
+#define SDRAMC_BASE			(SYS_VIRT_OFS + 0xffffea00)
+#define  SDRAMC_TR			0x0004
+#define  SDRAMC_LPR			0x0010
+#define   SDRAMC_LPCB_POWER_DOWN	2
+
+#define RSTC_BASE			(SYS_VIRT_OFS + 0xfffffd00)
+#define  RSTC_CR			0x0000
+#define   RSTC_PROCRST			(1 << 0)
+#define   RSTC_PERRST			(1 << 2)
+#define   RSTC_KEY			(0xa5 << 24)
+
+			.arm
+
+			.globl	at91sam9g20_reset
+
+at91sam9g20_reset:	mov	r0, #0
+			mcr	p15, 0, r0, c7, c5, 0	@ flush I-cache
+
+			mrc	p15, 0, r0, c1, c0, 0
+			orr	r0, r0, #CP15_CR_I
+			mcr	p15, 0, r0, c1, c0, 0	@ enable I-cache
+
+			ldr	r0, =SDRAMC_BASE	@ preload constants
+			ldr	r1, =RSTC_BASE
+
+			mov	r2, #1
+			mov	r3, #SDRAMC_LPCB_POWER_DOWN
+			ldr	r4, =RSTC_KEY | RSTC_PERRST | RSTC_PROCRST
+
+			.balign	32			@ align to cache line
+
+			str	r2, [r0, #SDRAMC_TR]	@ disable SDRAM access
+			str	r3, [r0, #SDRAMC_LPR]	@ power down SDRAM
+			str	r4, [r1, #RSTC_CR]	@ reset processor
+
+			b	.
-- 
1.7.3

