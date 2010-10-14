Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0JNQSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:18:47 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:39703 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0JNQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:18:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com, phorton@bitbox.co.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/5] AT91: reset: extend alternate reset procedure to several chips
Date: Thu, 14 Oct 2010 19:25:06 +0200
Message-Id: <2dff0263490be40a7b6e918940f31bdcb9ae99dd.1287076894.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <20100528153725.GA5102@axolotl.localnet>
References: <20100528153725.GA5102@axolotl.localnet>
In-Reply-To: <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
References: <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several at91sam9 chips need the alternate reset procedure to be sure to halt
SDRAM smoothly before resetting the chip.
This is an extension of previous patch "Fix AT91SAM9G20 reset" to all chips
affected.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile      |   10 +++++-----
 arch/arm/mach-at91/at91sam9260.c |   13 +------------
 arch/arm/mach-at91/at91sam9261.c |    7 +------
 arch/arm/mach-at91/at91sam9263.c |    7 +------
 arch/arm/mach-at91/at91sam9rl.c  |    7 +------
 arch/arm/mach-at91/generic.h     |    3 +++
 6 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 15fee8b..428266f 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -11,11 +11,11 @@ obj-$(CONFIG_AT91_PMC_UNIT)	+= clock.o
 
 # CPU-specific support
 obj-$(CONFIG_ARCH_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o at91rm9200_devices.o
-obj-$(CONFIG_ARCH_AT91SAM9260)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o sam9_smc.o
-obj-$(CONFIG_ARCH_AT91SAM9261)	+= at91sam9261.o at91sam926x_time.o at91sam9261_devices.o sam9_smc.o
-obj-$(CONFIG_ARCH_AT91SAM9G10)	+= at91sam9261.o at91sam926x_time.o at91sam9261_devices.o sam9_smc.o
-obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263.o at91sam926x_time.o at91sam9263_devices.o sam9_smc.o
-obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl.o at91sam926x_time.o at91sam9rl_devices.o sam9_smc.o
+obj-$(CONFIG_ARCH_AT91SAM9260)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o sam9_smc.o at91sam9_alt_reset.o
+obj-$(CONFIG_ARCH_AT91SAM9261)	+= at91sam9261.o at91sam926x_time.o at91sam9261_devices.o sam9_smc.o at91sam9_alt_reset.o
+obj-$(CONFIG_ARCH_AT91SAM9G10)	+= at91sam9261.o at91sam926x_time.o at91sam9261_devices.o sam9_smc.o at91sam9_alt_reset.o
+obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263.o at91sam926x_time.o at91sam9263_devices.o sam9_smc.o at91sam9_alt_reset.o
+obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl.o at91sam926x_time.o at91sam9rl_devices.o sam9_smc.o at91sam9_alt_reset.o
 obj-$(CONFIG_ARCH_AT91SAM9G20)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o sam9_smc.o at91sam9_alt_reset.o
 obj-$(CONFIG_ARCH_AT91SAM9G45)	+= at91sam9g45.o at91sam926x_time.o at91sam9g45_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT91CAP9)	+= at91cap9.o at91sam926x_time.o at91cap9_devices.o sam9_smc.o
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index dfd3529..195208b 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -25,8 +25,6 @@
 #include "generic.h"
 #include "clock.h"
 
-extern void at91sam9_alt_reset(void);
-
 static struct map_desc at91sam9260_io_desc[] __initdata = {
 	{
 		.virtual	= AT91_VA_BASE_SYS,
@@ -281,11 +279,6 @@ static struct at91_gpio_bank at91sam9260_gpio[] = {
 	}
 };
 
-static void at91sam9260_reset(void)
-{
-	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
-}
-
 static void at91sam9260_poweroff(void)
 {
 	at91_sys_write(AT91_SHDW_CR, AT91_SHDW_KEY | AT91_SHDW_SHDW);
@@ -329,11 +322,7 @@ void __init at91sam9260_initialize(unsigned long main_clock)
 	else
 		iotable_init(at91sam9260_sram_desc, ARRAY_SIZE(at91sam9260_sram_desc));
 
-	if (cpu_is_at91sam9g20())
-		at91_arch_reset = at91sam9_alt_reset;
-	else
-		at91_arch_reset = at91sam9260_reset;
-
+	at91_arch_reset = at91sam9_alt_reset;
 	pm_power_off = at91sam9260_poweroff;
 	at91_extern_irq = (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IRQ1)
 			| (1 << AT91SAM9260_ID_IRQ2);
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 4ecf379..fcad886 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -257,11 +257,6 @@ static struct at91_gpio_bank at91sam9261_gpio[] = {
 	}
 };
 
-static void at91sam9261_reset(void)
-{
-	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
-}
-
 static void at91sam9261_poweroff(void)
 {
 	at91_sys_write(AT91_SHDW_CR, AT91_SHDW_KEY | AT91_SHDW_SHDW);
@@ -283,7 +278,7 @@ void __init at91sam9261_initialize(unsigned long main_clock)
 		iotable_init(at91sam9261_sram_desc, ARRAY_SIZE(at91sam9261_sram_desc));
 
 
-	at91_arch_reset = at91sam9261_reset;
+	at91_arch_reset = at91sam9_alt_reset;
 	pm_power_off = at91sam9261_poweroff;
 	at91_extern_irq = (1 << AT91SAM9261_ID_IRQ0) | (1 << AT91SAM9261_ID_IRQ1)
 			| (1 << AT91SAM9261_ID_IRQ2);
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 942792d..249f900 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -269,11 +269,6 @@ static struct at91_gpio_bank at91sam9263_gpio[] = {
 	}
 };
 
-static void at91sam9263_reset(void)
-{
-	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
-}
-
 static void at91sam9263_poweroff(void)
 {
 	at91_sys_write(AT91_SHDW_CR, AT91_SHDW_KEY | AT91_SHDW_SHDW);
@@ -289,7 +284,7 @@ void __init at91sam9263_initialize(unsigned long main_clock)
 	/* Map peripherals */
 	iotable_init(at91sam9263_io_desc, ARRAY_SIZE(at91sam9263_io_desc));
 
-	at91_arch_reset = at91sam9263_reset;
+	at91_arch_reset = at91sam9_alt_reset;
 	pm_power_off = at91sam9263_poweroff;
 	at91_extern_irq = (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IRQ1);
 
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 211c5c1..6a9d24e 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -242,11 +242,6 @@ static struct at91_gpio_bank at91sam9rl_gpio[] = {
 	}
 };
 
-static void at91sam9rl_reset(void)
-{
-	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
-}
-
 static void at91sam9rl_poweroff(void)
 {
 	at91_sys_write(AT91_SHDW_CR, AT91_SHDW_KEY | AT91_SHDW_SHDW);
@@ -281,7 +276,7 @@ void __init at91sam9rl_initialize(unsigned long main_clock)
 	/* Map SRAM */
 	iotable_init(at91sam9rl_sram_desc, ARRAY_SIZE(at91sam9rl_sram_desc));
 
-	at91_arch_reset = at91sam9rl_reset;
+	at91_arch_reset = at91sam9_alt_reset;
 	pm_power_off = at91sam9rl_poweroff;
 	at91_extern_irq = (1 << AT91SAM9RL_ID_IRQ0);
 
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 65c3dc5..0c66deb 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -46,6 +46,9 @@ extern void __init at91_clock_associate(const char *id, struct device *dev, cons
 extern void at91_irq_suspend(void);
 extern void at91_irq_resume(void);
 
+/* reset */
+extern void at91sam9_alt_reset(void);
+
  /* GPIO */
 #define AT91RM9200_PQFP		3	/* AT91RM9200 PQFP package has 3 banks */
 #define AT91RM9200_BGA		4	/* AT91RM9200 BGA package has 4 banks */
-- 
1.7.3

