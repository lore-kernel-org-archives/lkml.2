Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1CGHkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:40:52 -0500
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1139 "HELO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755220Ab1CGHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:40:48 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 20568
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] ARM: s3c24xx: Switch to common GPIO controlled UDC pullup implementation
Date: Mon,  7 Mar 2011 08:42:00 +0100
Message-Id: <1299483720-18175-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299483720-18175-1-git-send-email-lars@metafoo.de>
References: <1299483720-18175-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all boards using the s3c2410_udc driver use a GPIO to control the
state of the pullup, as a result the same code is reimplemented in each board
This patch changes these boards to use the common implementation for GPIO
controlled pullup in the UDC driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2410/mach-h1940.c    |   24 +-----------------------
 arch/arm/mach-s3c2410/mach-n30.c      |   21 +--------------------
 arch/arm/mach-s3c2412/mach-smdk2413.c |   24 +-----------------------
 arch/arm/mach-s3c2440/mach-gta02.c    |   22 ++--------------------
 arch/arm/mach-s3c2440/mach-mini2440.c |   24 +-----------------------
 arch/arm/mach-s3c2440/mach-rx1950.c   |   21 +--------------------
 6 files changed, 7 insertions(+), 129 deletions(-)

diff --git a/arch/arm/mach-s3c2410/mach-h1940.c b/arch/arm/mach-s3c2410/mach-h1940.c
index 5531c4c..882b32a 100644
--- a/arch/arm/mach-s3c2410/mach-h1940.c
+++ b/arch/arm/mach-s3c2410/mach-h1940.c
@@ -169,29 +169,10 @@ struct gpio_chip h1940_latch_gpiochip = {
 	.get			= h1940_gpiolib_latch_get,
 };
 
-static void h1940_udc_pullup(enum s3c2410_udc_cmd_e cmd)
-{
-	printk(KERN_DEBUG "udc: pullup(%d)\n",cmd);
-
-	switch (cmd)
-	{
-		case S3C2410_UDC_P_ENABLE :
-			gpio_set_value(H1940_LATCH_USB_DP, 1);
-			break;
-		case S3C2410_UDC_P_DISABLE :
-			gpio_set_value(H1940_LATCH_USB_DP, 0);
-			break;
-		case S3C2410_UDC_P_RESET :
-			break;
-		default:
-			break;
-	}
-}
-
 static struct s3c2410_udc_mach_info h1940_udc_cfg __initdata = {
-	.udc_command		= h1940_udc_pullup,
 	.vbus_pin		= S3C2410_GPG(5),
 	.vbus_pin_inverted	= 1,
+	.pullup_pin		= H1940_LATCH_USB_DP,
 };
 
 static struct s3c2410_ts_mach_info h1940_ts_cfg __initdata = {
@@ -742,9 +723,6 @@ static void __init h1940_init(void)
 	gpio_direction_output(H1940_LATCH_LCD_P4, 0);
 	gpio_direction_output(H1940_LATCH_MAX1698_nSHUTDOWN, 0);
 
-	gpio_request(H1940_LATCH_USB_DP, "USB pullup");
-	gpio_direction_output(H1940_LATCH_USB_DP, 0);
-
 	gpio_request(H1940_LATCH_SD_POWER, "SD power");
 	gpio_direction_output(H1940_LATCH_SD_POWER, 0);
 
diff --git a/arch/arm/mach-s3c2410/mach-n30.c b/arch/arm/mach-s3c2410/mach-n30.c
index 271b9aa..66f4444 100644
--- a/arch/arm/mach-s3c2410/mach-n30.c
+++ b/arch/arm/mach-s3c2410/mach-n30.c
@@ -84,26 +84,10 @@ static struct s3c2410_uartcfg n30_uartcfgs[] = {
 	},
 };
 
-static void n30_udc_pullup(enum s3c2410_udc_cmd_e cmd)
-{
-	switch (cmd) {
-	case S3C2410_UDC_P_ENABLE :
-		gpio_set_value(S3C2410_GPB(3), 1);
-		break;
-	case S3C2410_UDC_P_DISABLE :
-		gpio_set_value(S3C2410_GPB(3), 0);
-		break;
-	case S3C2410_UDC_P_RESET :
-		break;
-	default:
-		break;
-	}
-}
-
 static struct s3c2410_udc_mach_info n30_udc_cfg __initdata = {
-	.udc_command		= n30_udc_pullup,
 	.vbus_pin		= S3C2410_GPG(1),
 	.vbus_pin_inverted	= 0,
+	.pullup_pin		= S3C2410_GPB(3),
 };
 
 static struct gpio_keys_button n30_buttons[] = {
@@ -596,9 +580,6 @@ static void __init n30_init(void)
 
 		platform_add_devices(n35_devices, ARRAY_SIZE(n35_devices));
 	}
-
-	WARN_ON(gpio_request(S3C2410_GPB(3), "udc pup"));
-	gpio_direction_output(S3C2410_GPB(3), 0);
 }
 
 MACHINE_START(N30, "Acer-N30")
diff --git a/arch/arm/mach-s3c2412/mach-smdk2413.c b/arch/arm/mach-s3c2412/mach-smdk2413.c
index 8e5758b..834cfb6 100644
--- a/arch/arm/mach-s3c2412/mach-smdk2413.c
+++ b/arch/arm/mach-s3c2412/mach-smdk2413.c
@@ -78,28 +78,9 @@ static struct s3c2410_uartcfg smdk2413_uartcfgs[] __initdata = {
 	}
 };
 
-static void smdk2413_udc_pullup(enum s3c2410_udc_cmd_e cmd)
-{
-	printk(KERN_DEBUG "udc: pullup(%d)\n",cmd);
-
-	switch (cmd)
-	{
-		case S3C2410_UDC_P_ENABLE :
-			gpio_set_value(S3C2410_GPF(2), 1);
-			break;
-		case S3C2410_UDC_P_DISABLE :
-			gpio_set_value(S3C2410_GPF(2), 0);
-			break;
-		case S3C2410_UDC_P_RESET :
-			break;
-		default:
-			break;
-	}
-}
-
 
 static struct s3c2410_udc_mach_info smdk2413_udc_cfg __initdata = {
-	.udc_command		= smdk2413_udc_pullup,
+	.pullup_pin = S3C2410_GPF(2),
 };
 
 
@@ -133,9 +114,6 @@ static void __init smdk2413_machine_init(void)
 {	/* Turn off suspend on both USB ports, and switch the
 	 * selectable USB port to USB device mode. */
 
-	WARN_ON(gpio_request(S3C2410_GPF(2), "udc pull"));
-	gpio_direction_output(S3C2410_GPF(2), 0);
-
 	s3c2410_modify_misccr(S3C2410_MISCCR_USBHOST |
 			      S3C2410_MISCCR_USBSUSPND0 |
 			      S3C2410_MISCCR_USBSUSPND1, 0x0);
diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index d217ef3..0db2411 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -448,28 +448,10 @@ static struct s3c2410_platform_nand __initdata gta02_nand_info = {
 };
 
 
-static void gta02_udc_command(enum s3c2410_udc_cmd_e cmd)
-{
-	switch (cmd) {
-	case S3C2410_UDC_P_ENABLE:
-		pr_debug("%s S3C2410_UDC_P_ENABLE\n", __func__);
-		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 1);
-		break;
-	case S3C2410_UDC_P_DISABLE:
-		pr_debug("%s S3C2410_UDC_P_DISABLE\n", __func__);
-		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 0);
-		break;
-	case S3C2410_UDC_P_RESET:
-		pr_debug("%s S3C2410_UDC_P_RESET\n", __func__);
-		/* FIXME: Do something here. */
-	}
-}
-
 /* Get PMU to set USB current limit accordingly. */
-static struct s3c2410_udc_mach_info gta02_udc_cfg = {
+static struct s3c2410_udc_mach_info gta02_udc_cfg __initdata = {
 	.vbus_draw	= gta02_udc_vbus_draw,
-	.udc_command	= gta02_udc_command,
-
+	.pullup_pin = GTA02_GPIO_USB_PULLUP,
 };
 
 /* USB */
diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index f62bb4c..d80f129 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -97,26 +97,8 @@ static struct s3c2410_uartcfg mini2440_uartcfgs[] __initdata = {
 
 /* USB device UDC support */
 
-static void mini2440_udc_pullup(enum s3c2410_udc_cmd_e cmd)
-{
-	pr_debug("udc: pullup(%d)\n", cmd);
-
-	switch (cmd) {
-		case S3C2410_UDC_P_ENABLE :
-			gpio_set_value(S3C2410_GPC(5), 1);
-			break;
-		case S3C2410_UDC_P_DISABLE :
-			gpio_set_value(S3C2410_GPC(5), 0);
-			break;
-		case S3C2410_UDC_P_RESET :
-			break;
-		default:
-			break;
-	}
-}
-
 static struct s3c2410_udc_mach_info mini2440_udc_cfg __initdata = {
-	.udc_command		= mini2440_udc_pullup,
+	.pullup_pin = S3C2410_GPC(5),
 };
 
 
@@ -644,10 +626,6 @@ static void __init mini2440_init(void)
 	s3c2410_gpio_setpin(S3C2410_GPB(1), 0);
 	s3c_gpio_cfgpin(S3C2410_GPB(1), S3C2410_GPIO_INPUT);
 
-	/* Make sure the D+ pullup pin is output */
-	WARN_ON(gpio_request(S3C2410_GPC(5), "udc pup"));
-	gpio_direction_output(S3C2410_GPC(5), 0);
-
 	/* mark the key as input, without pullups (there is one on the board) */
 	for (i = 0; i < ARRAY_SIZE(mini2440_buttons); i++) {
 		s3c_gpio_setpull(mini2440_buttons[i].gpio, S3C_GPIO_PULL_UP);
diff --git a/arch/arm/mach-s3c2440/mach-rx1950.c b/arch/arm/mach-s3c2440/mach-rx1950.c
index 2d2f4e4..22f18d9 100644
--- a/arch/arm/mach-s3c2440/mach-rx1950.c
+++ b/arch/arm/mach-s3c2440/mach-rx1950.c
@@ -616,26 +616,10 @@ static struct s3c2410_platform_nand rx1950_nand_info = {
 	.sets = rx1950_nand_sets,
 };
 
-static void rx1950_udc_pullup(enum s3c2410_udc_cmd_e cmd)
-{
-	switch (cmd) {
-	case S3C2410_UDC_P_ENABLE:
-		gpio_direction_output(S3C2410_GPJ(5), 1);
-		break;
-	case S3C2410_UDC_P_DISABLE:
-		gpio_direction_output(S3C2410_GPJ(5), 0);
-		break;
-	case S3C2410_UDC_P_RESET:
-		break;
-	default:
-		break;
-	}
-}
-
 static struct s3c2410_udc_mach_info rx1950_udc_cfg __initdata = {
-	.udc_command = rx1950_udc_pullup,
 	.vbus_pin = S3C2410_GPG(5),
 	.vbus_pin_inverted = 1,
+	.pullup_pin = S3C2410_GPJ(5),
 };
 
 static struct s3c2410_ts_mach_info rx1950_ts_cfg __initdata = {
@@ -800,9 +784,6 @@ static void __init rx1950_init_machine(void)
 						S3C2410_MISCCR_USBSUSPND0 |
 						S3C2410_MISCCR_USBSUSPND1, 0x0);
 
-	WARN_ON(gpio_request(S3C2410_GPJ(5), "UDC pullup"));
-	gpio_direction_output(S3C2410_GPJ(5), 0);
-
 	/* mmc power is disabled by default */
 	WARN_ON(gpio_request(S3C2410_GPJ(1), "MMC power"));
 	gpio_direction_output(S3C2410_GPJ(1), 0);
-- 
1.7.2.3

