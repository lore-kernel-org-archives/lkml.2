Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1LSXNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:13:41 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36438 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1LSXNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:13:35 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH v2 3/7] ARM: OMAP1: ams-delta: supersede custom led device by leds-gpio
Date: Tue, 20 Dec 2011 00:08:53 +0100
Message-Id: <8d0cbce7431bf85d506ee7c100d71a8e0e71423f.1324331816.git.jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
In-Reply-To: <cover.1324331816.git.jkrzyszt@tis.icnet.pl>
References: <cover.1324331816.git.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the Amstrad Delta on-board latches have been converted to GPIO
devices, use the generic driver to control on-board LEDs which hang off
those latches.

Depends on patch 2/7 "ARM: OMAP1: ams-delta: convert latches to
basic_mmio_gpio"

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Changes against initial version:
* no functional changes,
* refreshed on top of v2 of patch 2/7,
* dropped leading underscores from local symbols, variable and function
  names (no namespace conflicts expected).


 arch/arm/mach-omap1/Kconfig                       |    1 +
 arch/arm/mach-omap1/board-ams-delta.c             |   87 +++++++++++---------
 arch/arm/plat-omap/include/plat/board-ams-delta.h |   19 -----
 3 files changed, 49 insertions(+), 58 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index d2606b1..ed7e864 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -156,6 +156,7 @@ config MACH_AMS_DELTA
 	depends on ARCH_OMAP1 && ARCH_OMAP15XX
 	select FIQ
 	select GPIO_GENERIC_PLATFORM
+	select LEDS_GPIO_REGISTER
 	help
 	  Support for the Amstrad E3 (codename Delta) videophone. Say Y here
 	  if you have such a device.
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index cff2711..034d009 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -164,18 +164,21 @@ static struct omap_board_config_kernel ams_delta_config[] __initdata = {
 	{ OMAP_TAG_LCD,		&ams_delta_lcd_config },
 };
 
+#define LATCH1_GPIO_BASE	232
+#define LATCH1_NGPIO		8
+
 static struct resource latch1_resources[] __initconst = {
 	[0] = {
 		.name	= "dat",
 		.start	= LATCH1_PHYS,
-		.end	= LATCH1_PHYS + (AMS_DELTA_LATCH1_NGPIO - 1) / 8,
+		.end	= LATCH1_PHYS + (LATCH1_NGPIO - 1) / 8,
 		.flags	= IORESOURCE_MEM,
 	},
 };
 
 static struct bgpio_pdata latch1_pdata __initconst = {
-	.base	= AMS_DELTA_LATCH1_GPIO_BASE,
-	.ngpio	= AMS_DELTA_LATCH1_NGPIO,
+	.base	= LATCH1_GPIO_BASE,
+	.ngpio	= LATCH1_NGPIO,
 };
 
 static struct platform_device latch1_gpio_device = {
@@ -214,42 +217,12 @@ static struct platform_device latch2_gpio_device = {
 
 static struct gpio latch_gpios[] __initconst = {
 	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LED_CAMERA,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "led_camera",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LED_ADVERT,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "led_advert",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LED_EMAIL,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "led_email",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LED_HANDSFREE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "led_handsfree",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICEMAIL,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "led_voicemail",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "led_voice",
-	},
-	{
-		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 6,
+		.gpio	= LATCH1_GPIO_BASE + 6,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "dockit1",
 	},
 	{
-		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 7,
+		.gpio	= LATCH1_GPIO_BASE + 7,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "dockit2",
 	},
@@ -399,9 +372,45 @@ static struct platform_device ams_delta_lcd_device = {
 	.id	= -1,
 };
 
-static struct platform_device ams_delta_led_device = {
-	.name	= "ams-delta-led",
-	.id	= -1
+static struct gpio_led gpio_leds[] __initconst = {
+	{
+		.name		 = "camera",
+		.gpio		 = LATCH1_GPIO_BASE + 0,
+		.default_state	 = LEDS_GPIO_DEFSTATE_OFF,
+#ifdef CONFIG_LEDS_TRIGGERS
+		.default_trigger = "ams_delta_camera",
+#endif
+	},
+	{
+		.name		 = "advert",
+		.gpio		 = LATCH1_GPIO_BASE + 1,
+		.default_state	 = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name		 = "email",
+		.gpio		 = LATCH1_GPIO_BASE + 2,
+		.default_state	 = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name		 = "handsfree",
+		.gpio		 = LATCH1_GPIO_BASE + 3,
+		.default_state	 = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name		 = "voicemail",
+		.gpio		 = LATCH1_GPIO_BASE + 4,
+		.default_state	 = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name		 = "voice",
+		.gpio		 = LATCH1_GPIO_BASE + 5,
+		.default_state	 = LEDS_GPIO_DEFSTATE_OFF,
+	},
+};
+
+static struct gpio_led_platform_data leds_pdata __initconst = {
+	.leds		= gpio_leds,
+	.num_leds	= ARRAY_SIZE(gpio_leds),
 };
 
 static struct i2c_board_info ams_delta_camera_board_info[] = {
@@ -459,7 +468,6 @@ static struct platform_device *ams_delta_devices[] __initdata = {
 static struct platform_device *late_devices[] __initconst = {
 	&ams_delta_nand_device,
 	&ams_delta_lcd_device,
-	&ams_delta_led_device,
 };
 
 static void __init ams_delta_init(void)
@@ -493,6 +501,7 @@ static void __init ams_delta_init(void)
 	led_trigger_register_simple("ams_delta_camera",
 			&ams_delta_camera_led_trigger);
 #endif
+	gpio_led_register_device(-1, &leds_pdata);
 	platform_add_devices(ams_delta_devices, ARRAY_SIZE(ams_delta_devices));
 
 	ams_delta_init_fiq();
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index 68ffe32..a0f86ca 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -28,13 +28,6 @@
 
 #if defined (CONFIG_MACH_AMS_DELTA)
 
-#define AMS_DELTA_LATCH1_LED_CAMERA	0x01
-#define AMS_DELTA_LATCH1_LED_ADVERT	0x02
-#define AMS_DELTA_LATCH1_LED_EMAIL	0x04
-#define AMS_DELTA_LATCH1_LED_HANDSFREE	0x08
-#define AMS_DELTA_LATCH1_LED_VOICEMAIL	0x10
-#define AMS_DELTA_LATCH1_LED_VOICE	0x20
-
 #define AMS_DELTA_LATCH2_LCD_VBLEN	0x0001
 #define AMS_DELTA_LATCH2_LCD_NDISP	0x0002
 #define AMS_DELTA_LATCH2_NAND_NCE	0x0004
@@ -59,13 +52,6 @@
 #define AMS_DELTA_GPIO_PIN_CONFIG	11
 #define AMS_DELTA_GPIO_PIN_NAND_RB	12
 
-#define AMS_DELTA_GPIO_PIN_LED_CAMERA		232
-#define AMS_DELTA_GPIO_PIN_LED_ADVERT		233
-#define AMS_DELTA_GPIO_PIN_LED_EMAIL		234
-#define AMS_DELTA_GPIO_PIN_LED_HANDSFREE	235
-#define AMS_DELTA_GPIO_PIN_LED_VOICEMAIL	236
-#define AMS_DELTA_GPIO_PIN_LED_VOICE		237
-
 #define AMS_DELTA_GPIO_PIN_LCD_VBLEN		240
 #define AMS_DELTA_GPIO_PIN_LCD_NDISP		241
 #define AMS_DELTA_GPIO_PIN_NAND_NCE		242
@@ -81,16 +67,11 @@
 #define AMS_DELTA_GPIO_PIN_MODEM_NRESET		252
 #define AMS_DELTA_GPIO_PIN_MODEM_CODEC		253
 
-#define AMS_DELTA_LATCH1_GPIO_BASE	AMS_DELTA_GPIO_PIN_LED_CAMERA
-#define AMS_DELTA_LATCH1_NGPIO		8
 #define AMS_DELTA_LATCH2_GPIO_BASE	AMS_DELTA_GPIO_PIN_LCD_VBLEN
 #define AMS_DELTA_LATCH2_NGPIO		16
 
 #ifndef __ASSEMBLY__
 void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value);
-#define ams_delta_latch1_write(mask, value) \
-	ams_delta_latch_write(AMS_DELTA_LATCH1_GPIO_BASE, \
-			AMS_DELTA_LATCH1_NGPIO, (mask), (value))
 #define ams_delta_latch2_write(mask, value) \
 	ams_delta_latch_write(AMS_DELTA_LATCH2_GPIO_BASE, \
 			AMS_DELTA_LATCH2_NGPIO, (mask), (value))
-- 
1.7.3.4

