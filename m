Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1HZJFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:05:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1HZJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:05:21 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] arm: at91: convert old leds drivers to gpio_led and led_trigger drivers
Date: Fri, 26 Aug 2011 17:03:20 +0800
Message-Id: <1314349415-889-4-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build with at91 defconfigs successfully

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/board-cap9adk.c      |   21 ++++++-
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
 13 files changed, 108 insertions(+), 138 deletions(-)

diff --git a/arch/arm/mach-at91/board-cap9adk.c b/arch/arm/mach-at91/board-cap9adk.c
index 679b0b7..0f95be9 100644
--- a/arch/arm/mach-at91/board-cap9adk.c
+++ b/arch/arm/mach-at91/board-cap9adk.c
@@ -55,8 +55,6 @@ static void __init cap9adk_init_early(void)
 	/* Initialize processor: 12 MHz crystal */
 	at91_initialize(12000000);
 
-	/* Setup the LEDs: USER1 and USER2 LED for cpu/timer... */
-	at91_init_leds(AT91_PIN_PA10, AT91_PIN_PA11);
 	/* ... POWER LED always on */
 	at91_set_gpio_output(AT91_PIN_PC29, 1);
 
@@ -359,6 +357,23 @@ static struct ac97c_platform_data cap9adk_ac97_data = {
 //	.reset_pin	= ... not connected
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led cap9adk_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PA10,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{	/* D2 */
+		.name			= "led2",
+		.gpio			= AT91_PIN_PA11,
+		.active_low		= 1,
+		.default_trigger	= "timer",
+	}
+};
 
 static void __init cap9adk_board_init(void)
 {
@@ -386,6 +401,8 @@ static void __init cap9adk_board_init(void)
 	at91_add_device_lcdc(&cap9adk_lcdc_data);
 	/* AC97 */
 	at91_add_device_ac97(&cap9adk_ac97_data);
+	/* LEDs */
+	at91_gpio_leds(cap9adk_leds, ARRAY_SIZE(cap9adk_leds));
 }
 
 MACHINE_START(AT91CAP9ADK, "Atmel AT91CAP9A-DK")
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index 17654d5..0b2cdee 100644
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
index 7c0313c..15cbbe4 100644
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
 
@@ -144,6 +141,18 @@ static struct spi_board_info __initdata ecb_at91spi_devices[] = {
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
@@ -163,6 +172,9 @@ static void __init ecb_at91board_init(void)
 
 	/* SPI */
 	at91_add_device_spi(ecb_at91spi_devices, ARRAY_SIZE(ecb_at91spi_devices));
+
+	/* LEDs */
+	at91_gpio_leds(ecb_leds, ARRAY_SIZE(ecb_leds));
 }
 
 MACHINE_START(ECBAT91, "emQbit's ECB_AT91")
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 8252c72..efa8e55 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -37,9 +37,6 @@ static void __init eco920_init_early(void)
 
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB0, AT91_PIN_PB1);
-
 	/* DBGU on ttyS0. (Rx & Tx only */
 	at91_register_uart(0, 0, 0);
 
@@ -95,6 +92,24 @@ static struct spi_board_info eco920_spi_devices[] = {
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
@@ -125,6 +140,8 @@ static void __init eco920_board_init(void)
 	);
 
 	at91_add_device_spi(eco920_spi_devices, ARRAY_SIZE(eco920_spi_devices));
+	/* LEDs */
+	at91_gpio_leds(eco920_leds, ARRAY_SIZE(eco920_leds));
 }
 
 MACHINE_START(ECO920, "eco920")
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 4a17089..17a470b 100644
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
 
@@ -75,6 +72,18 @@ static struct at91_udc_data __initdata kafa_udc_data = {
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
@@ -89,6 +98,8 @@ static void __init kafa_board_init(void)
 	at91_add_device_i2c(NULL, 0);
 	/* SPI */
 	at91_add_device_spi(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(kafa_leds, ARRAY_SIZE(kafa_leds));
 }
 
 MACHINE_START(KAFA, "Sperry-Sun KAFA")
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 9dc8d49..bee2a4e 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -50,9 +50,6 @@ static void __init kb9202_init_early(void)
 	/* Initialize processor: 10 MHz crystal */
 	at91_initialize(10000000);
 
-	/* Set up the LEDs */
-	at91_init_leds(AT91_PIN_PC19, AT91_PIN_PC18);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
@@ -112,6 +109,24 @@ static struct atmel_nand_data __initdata kb9202_nand_data = {
 	.partition_info	= nand_partitions,
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
@@ -130,6 +145,8 @@ static void __init kb9202_board_init(void)
 	at91_add_device_spi(NULL, 0);
 	/* NAND */
 	at91_add_device_nand(&kb9202_nand_data);
+	/* LEDs */
+	at91_gpio_leds(kb9202_leds, ARRAY_SIZE(kb9202_leds));
 }
 
 MACHINE_START(KB9200, "KB920x")
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index 6f08faa..8694b74 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -50,9 +50,6 @@ static void __init dk_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB2, AT91_PIN_PB2);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 85bcccd..3a96ed3 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -50,9 +50,6 @@ static void __init ek_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB1, AT91_PIN_PB2);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 4d3a02f..8c3a15a 100644
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
 
@@ -184,6 +181,24 @@ static struct at91_mmc_data __initdata ek_mmc_data = {
 //	.vcc_pin	= ... not connected
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
@@ -202,6 +217,8 @@ static void __init ek_board_init(void)
 	at91_add_device_mmc(0, &ek_mmc_data);
 	/* I2C */
 	at91_add_device_i2c(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
 }
 
 MACHINE_START(SAM9_L9260, "Olimex SAM9-L9260")
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 5096a0e..4d7b6fa 100644
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
index 95edcbd..9ac5c47 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -58,9 +58,6 @@ static void __init yl9200_init_early(void)
 	/* Initialize processor: 18.432 MHz crystal */
 	at91_initialize(18432000);
 
-	/* Setup the LEDs D2=PB17 (timer), D3=PB16 (cpu) */
-	at91_init_leds(AT91_PIN_PB16, AT91_PIN_PB17);
-
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index ed544a0..c2a7746 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -200,7 +200,6 @@ struct at91_can_data {
 extern void __init at91_add_device_can(struct at91_can_data *data);
 
  /* LEDs */
-extern void __init at91_init_leds(u8 cpu_led, u8 timer_led);
 extern void __init at91_gpio_leds(struct gpio_led *leds, int nr);
 extern void __init at91_pwm_leds(struct gpio_led *leds, int nr);
 
diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
index 0415a839..844aef8 100644
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
1.7.5

