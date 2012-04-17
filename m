Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2DQK4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:56:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44196 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2DQK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:56:18 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 02/18] ARM: at91: convert old leds drivers to gpio_led and led_trigger drivers
Date: Tue, 17 Apr 2012 18:53:29 +0800
Message-Id: <1334660025-20442-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build with at91 defconfigs successfully

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-csb337.c       |    3 -
 arch/arm/mach-at91/board-ecbat91.c      |   18 +++++-
 arch/arm/mach-at91/board-eco920.c       |   23 ++++++-
 arch/arm/mach-at91/board-kafa.c         |   17 ++++-
 arch/arm/mach-at91/board-kb9202.c       |   23 ++++++-
 arch/arm/mach-at91/board-rm9200dk.c     |    3 -
 arch/arm/mach-at91/board-rm9200ek.c     |    3 -
 arch/arm/mach-at91/board-sam9-l9260.c   |   23 ++++++-
 arch/arm/mach-at91/board-sam9261ek.c    |    3 -
 arch/arm/mach-at91/board-yl-9200.c      |    3 -
 arch/arm/mach-at91/include/mach/board.h |    1 -
 arch/arm/mach-at91/leds.c               |  105 -------------------------------
 12 files changed, 89 insertions(+), 136 deletions(-)

diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index 1a1547b..ce2eea3 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -48,9 +48,6 @@ static void __init csb337_init_early(void)
 	/* Initialize processor: 3.6864 MHz crystal */
 	at91_initialize(3686400);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB0, AT91_PIN_PB1);
-
 	/* DBGU on ttyS0 */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index 69966ce..da671f5 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -51,9 +51,6 @@ static void __init ecb_at91init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PC7, AT91_PIN_PC7);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
@@ -149,6 +146,18 @@ static struct spi_board_info __initdata ecb_at91spi_devices[] = {
 	},
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led ecb_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PC7,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	}
+};
+
 static void __init ecb_at91board_init(void)
 {
 	/* Serial */
@@ -168,6 +177,9 @@ static void __init ecb_at91board_init(void)
 
 	/* SPI */
 	at91_add_device_spi(ecb_at91spi_devices, ARRAY_SIZE(ecb_at91spi_devices));
+
+	/* LEDs */
+	at91_gpio_leds(ecb_leds, ARRAY_SIZE(ecb_leds));
 }
 
 MACHINE_START(ECBAT91, "emQbit's ECB_AT91")
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index f23aabe..3484eac 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -38,9 +38,6 @@ static void __init eco920_init_early(void)
 
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB0, AT91_PIN_PB1);
-
 	/* DBGU on ttyS0. (Rx & Tx only */
 	at91_register_uart(0, 0, 0);
 
@@ -101,6 +98,24 @@ static struct spi_board_info eco920_spi_devices[] = {
 	},
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led eco920_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PB0,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{	/* D2 */
+		.name			= "led2",
+		.gpio			= AT91_PIN_PB1,
+		.active_low		= 1,
+		.default_trigger	= "timer",
+	}
+};
+
 static void __init eco920_board_init(void)
 {
 	at91_add_device_serial();
@@ -131,6 +146,8 @@ static void __init eco920_board_init(void)
 	);
 
 	at91_add_device_spi(eco920_spi_devices, ARRAY_SIZE(eco920_spi_devices));
+	/* LEDs */
+	at91_gpio_leds(eco920_leds, ARRAY_SIZE(eco920_leds));
 }
 
 MACHINE_START(ECO920, "eco920")
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index efde1b2..bcd7f44 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -48,9 +48,6 @@ static void __init kafa_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Set up the LEDs */
-	at91_init_leds(AT91_PIN_PB4, AT91_PIN_PB4);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
@@ -77,6 +74,18 @@ static struct at91_udc_data __initdata kafa_udc_data = {
 	.pullup_pin	= AT91_PIN_PB7,
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led kafa_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PB4,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+};
+
 static void __init kafa_board_init(void)
 {
 	/* Serial */
@@ -91,6 +100,8 @@ static void __init kafa_board_init(void)
 	at91_add_device_i2c(NULL, 0);
 	/* SPI */
 	at91_add_device_spi(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(kafa_leds, ARRAY_SIZE(kafa_leds));
 }
 
 MACHINE_START(KAFA, "Sperry-Sun KAFA")
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 59b92aa..df74b72 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -51,9 +51,6 @@ static void __init kb9202_init_early(void)
 	/* Initialize processor: 10 MHz crystal */
 	at91_initialize(10000000);
 
-	/* Set up the LEDs */
-	at91_init_leds(AT91_PIN_PC19, AT91_PIN_PC18);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
@@ -113,6 +110,24 @@ static struct atmel_nand_data __initdata kb9202_nand_data = {
 	.num_parts	= ARRAY_SIZE(kb9202_nand_partition),
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led kb9202_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PC19,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{	/* D2 */
+		.name			= "led2",
+		.gpio			= AT91_PIN_PC18,
+		.active_low		= 1,
+		.default_trigger	= "timer",
+	}
+};
+
 static void __init kb9202_board_init(void)
 {
 	/* Serial */
@@ -131,6 +146,8 @@ static void __init kb9202_board_init(void)
 	at91_add_device_spi(NULL, 0);
 	/* NAND */
 	at91_add_device_nand(&kb9202_nand_data);
+	/* LEDs */
+	at91_gpio_leds(kb9202_leds, ARRAY_SIZE(kb9202_leds));
 }
 
 MACHINE_START(KB9200, "KB920x")
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index 01332aa..d89a2ff 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -51,9 +51,6 @@ static void __init dk_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB2, AT91_PIN_PB2);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 11cbaa8..a14727d 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -51,9 +51,6 @@ static void __init ek_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB1, AT91_PIN_PB2);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index e8b116b..7e4405e1 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -49,9 +49,6 @@ static void __init ek_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PA9, AT91_PIN_PA6);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
@@ -182,6 +179,24 @@ static struct at91_mmc_data __initdata ek_mmc_data = {
 	.vcc_pin	= -EINVAL,
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led ek_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PA9,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{	/* D2 */
+		.name			= "led2",
+		.gpio			= AT91_PIN_PA6,
+		.active_low		= 1,
+		.default_trigger	= "timer",
+	}
+};
+
 static void __init ek_board_init(void)
 {
 	/* Serial */
@@ -200,6 +215,8 @@ static void __init ek_board_init(void)
 	at91_add_device_mmc(0, &ek_mmc_data);
 	/* I2C */
 	at91_add_device_i2c(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
 }
 
 MACHINE_START(SAM9_L9260, "Olimex SAM9-L9260")
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index c3f9944..0eaadc7 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -59,9 +59,6 @@ static void __init ek_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PA13, AT91_PIN_PA14);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index 38dd279..23e547b 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -59,9 +59,6 @@ static void __init yl9200_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs D2=PB17 (timer), D3=PB16 (cpu) */
-	at91_init_leds(AT91_PIN_PB16, AT91_PIN_PB17);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 49a8211..e116445 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -188,7 +188,6 @@ struct at91_can_data {
 extern void __init at91_add_device_can(struct at91_can_data *data);
 
  /* LEDs */
-extern void __init at91_init_leds(u8 cpu_led, u8 timer_led);
 extern void __init at91_gpio_leds(struct gpio_led *leds, int nr);
 extern void __init at91_pwm_leds(struct gpio_led *leds, int nr);
 
diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
index 8dfafe7..1b1e62b 100644
--- a/arch/arm/mach-at91/leds.c
+++ b/arch/arm/mach-at91/leds.c
@@ -90,108 +90,3 @@ void __init at91_pwm_leds(struct gpio_led *leds, int nr)
 #else
 void __init at91_pwm_leds(struct gpio_led *leds, int nr){}
 #endif
-
-
-/* ------------------------------------------------------------------------- */
-
-#if defined(CONFIG_LEDS)
-
-#include <asm/leds.h>
-
-/*
- * Old ARM-specific LED framework; not fully functional when generic time is
- * in use.
- */
-
-static u8 at91_leds_cpu;
-static u8 at91_leds_timer;
-
-static inline void at91_led_on(unsigned int led)
-{
-	at91_set_gpio_value(led, 0);
-}
-
-static inline void at91_led_off(unsigned int led)
-{
-	at91_set_gpio_value(led, 1);
-}
-
-static inline void at91_led_toggle(unsigned int led)
-{
-	unsigned long is_off = at91_get_gpio_value(led);
-	if (is_off)
-		at91_led_on(led);
-	else
-		at91_led_off(led);
-}
-
-
-/*
- * Handle LED events.
- */
-static void at91_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch(evt) {
-	case led_start:		/* System startup */
-		at91_led_on(at91_leds_cpu);
-		break;
-
-	case led_stop:		/* System stop / suspend */
-		at91_led_off(at91_leds_cpu);
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:		/* Every 50 timer ticks */
-		at91_led_toggle(at91_leds_timer);
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:	/* Entering idle state */
-		at91_led_off(at91_leds_cpu);
-		break;
-
-	case led_idle_end:	/* Exit idle state */
-		at91_led_on(at91_leds_cpu);
-		break;
-#endif
-
-	default:
-		break;
-	}
-
-	local_irq_restore(flags);
-}
-
-
-static int __init leds_init(void)
-{
-	if (!at91_leds_timer || !at91_leds_cpu)
-		return -ENODEV;
-
-	leds_event = at91_leds_event;
-
-	leds_event(led_start);
-	return 0;
-}
-
-__initcall(leds_init);
-
-
-void __init at91_init_leds(u8 cpu_led, u8 timer_led)
-{
-	/* Enable GPIO to access the LEDs */
-	at91_set_gpio_output(cpu_led, 1);
-	at91_set_gpio_output(timer_led, 1);
-
-	at91_leds_cpu	= cpu_led;
-	at91_leds_timer	= timer_led;
-}
-
-#else
-void __init at91_init_leds(u8 cpu_led, u8 timer_led) {}
-#endif
-- 
1.7.9.5

