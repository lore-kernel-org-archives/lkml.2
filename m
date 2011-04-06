Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1DFNCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:02:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52038 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1DFNCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qqKetuEPJUpx2SRWNQQgmMC71xXkmYyKoX3HL8aDaMfOmgSSjEx8yGq46Z+GPmn0si
         ZB/bZfVBLeViER8jppJZrIN17zoFzJSxL2q+WfrfXP+ZU4DB8/DY3Wlz1j+Ox2MowfjI
         vW31U2iWGXANpBE9jBNhdznDNSLhx7Khqsx74=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, esta1ien@gmail.com, buserror@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 4/4] s3c2440: mini2440: Use leds-gpio driver for board leds handling.
Date: Wed,  6 Apr 2011 15:01:37 +0200
Message-Id: <1302094897-18446-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
References: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intention of this patch is convert existing usage of leds-s3c24xx driver
to use generic gpio-leds driver. Leds are separated to 2 devices.
First device handle 4 available leds. Second device is used to drive
LCD backlight. Backlight can be controlled via parameter b so we need
separate device which is registered or not depending on parameter.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-s3c2440/mach-mini2440.c |  122 +++++++++++++++------------------
 1 files changed, 54 insertions(+), 68 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index 163d318..2ebd70f 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -39,7 +39,6 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <mach/leds-gpio.h>
 #include <mach/regs-mem.h>
 #include <mach/regs-lcd.h>
 #include <mach/irqs.h>
@@ -419,81 +418,71 @@ static struct platform_device mini2440_button_device = {
 };
 
 /* LEDS */
-
-static struct s3c24xx_led_platdata mini2440_led1_pdata = {
-	.name		= "led1",
-	.gpio		= S3C2410_GPB(5),
-	.flags		= S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
-	.def_trigger	= "heartbeat",
-};
-
-static struct s3c24xx_led_platdata mini2440_led2_pdata = {
-	.name		= "led2",
-	.gpio		= S3C2410_GPB(6),
-	.flags		= S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
-	.def_trigger	= "nand-disk",
-};
-
-static struct s3c24xx_led_platdata mini2440_led3_pdata = {
-	.name		= "led3",
-	.gpio		= S3C2410_GPB(7),
-	.flags		= S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
-	.def_trigger	= "mmc0",
-};
-
-static struct s3c24xx_led_platdata mini2440_led4_pdata = {
-	.name		= "led4",
-	.gpio		= S3C2410_GPB(8),
-	.flags		= S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
-	.def_trigger	= "",
-};
-
-static struct s3c24xx_led_platdata mini2440_led_backlight_pdata = {
-	.name		= "backlight",
-	.gpio		= S3C2410_GPG(4),
-	.def_trigger	= "backlight",
+static struct gpio_led gpio_leds[] = {
+	{
+		.name			= "led1",
+		.gpio			= S3C2410_GPB(5),
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{
+		.name			= "led2",
+		.gpio			= S3C2410_GPB(6),
+		.active_low		= 1,
+		.default_trigger	= "nand-disk",
+		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name			= "led3",
+		.gpio			= S3C2410_GPB(7),
+		.active_low		= 1,
+		.default_trigger	= "mmc0",
+		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name			= "led4",
+		.gpio			= S3C2410_GPB(8),
+		.active_low		= 1,
+		.default_trigger	= "none",
+		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+	}
 };
 
-static struct platform_device mini2440_led1 = {
-	.name		= "s3c24xx_led",
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &mini2440_led1_pdata,
-	},
+static struct gpio_led backlight_led[] = {
+	{
+		.name			= "backlight",
+		.gpio			= S3C2410_GPG(4),
+		.active_low		= 0,
+		.default_trigger	= "backlight",
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
+	}
 };
 
-static struct platform_device mini2440_led2 = {
-	.name		= "s3c24xx_led",
-	.id		= 2,
-	.dev		= {
-		.platform_data	= &mini2440_led2_pdata,
-	},
+static struct gpio_led_platform_data gpio_led_info = {
+	.leds		= gpio_leds,
+	.num_leds	= ARRAY_SIZE(gpio_leds),
 };
 
-static struct platform_device mini2440_led3 = {
-	.name		= "s3c24xx_led",
-	.id		= 3,
-	.dev		= {
-		.platform_data	= &mini2440_led3_pdata,
-	},
+static struct gpio_led_platform_data backlight_info = {
+	.leds		= backlight_led,
+	.num_leds	= ARRAY_SIZE(backlight_led),
 };
 
-static struct platform_device mini2440_led4 = {
-	.name		= "s3c24xx_led",
-	.id		= 4,
-	.dev		= {
-		.platform_data	= &mini2440_led4_pdata,
-	},
+static struct platform_device mini2440_leds = {
+	.name	= "leds-gpio",
+	.id	= 0,
+	.dev	= {
+		.platform_data	= &gpio_led_info,
+	}
 };
 
 static struct platform_device mini2440_led_backlight = {
-	.name		= "s3c24xx_led",
-	.id		= 5,
-	.dev		= {
-		.platform_data	= &mini2440_led_backlight_pdata,
-	},
+	.name	= "leds-gpio",
+	.id	= 1,
+	.dev	= {
+		.platform_data	= &backlight_info,
+	}
 };
-
 /* AUDIO */
 
 static struct s3c24xx_uda134x_platform_data mini2440_audio_pins = {
@@ -543,10 +532,7 @@ static struct platform_device *mini2440_devices[] __initdata = {
 	&s3c_device_rtc,
 	&s3c_device_usbgadget,
 	&mini2440_device_eth,
-	&mini2440_led1,
-	&mini2440_led2,
-	&mini2440_led3,
-	&mini2440_led4,
+	&mini2440_leds,
 	&mini2440_button_device,
 	&s3c_device_nand,
 	&s3c_device_sdi,
-- 
1.7.1

