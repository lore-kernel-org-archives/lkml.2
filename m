Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1ATPmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:42:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1ATPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:42:19 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
        Tony Lindgren <tony@atomide.com> (maintainer:OMAP SUPPORT),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com, manjugk@ti.com
Subject: [PATCHv5] OMAP3: Devkit8000: Change lcd power pin
Date: Thu, 20 Jan 2011 16:41:48 +0100
Message-Id: <1295538108-26451-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
X-Provags-ID: V02:K0:g+xTwATRCviBMGNwciFGgXxMxcK5/4LI3ZaiF15O3ri
 GfEpGKGNQSWGpHhLgcxStdVZP7EwPrSxqZdY12Ia4Z6c93QDXL
 xuII/Cz3Sur4soEfjI5IuhF/vfRAtTSyPfguJFr1/yWQ1xGWgB
 iCtK5mP9KZ3qDqhgHjJpc4fPO9TMdByuxoAj2Zb2k38M/Hm/Zd
 SyuVhejWWtJPcBSDkJiWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a wrongly used lcd enable pin.

The Devkit8000 uses twl4030_ledA configured as output gpio only for
the lcd enable line. twl4030_gpio.1 is used through the generic
gpio functions while ledA is used via low level twl4030 calls.

This patch removes the low level calls and use the generic gpio functions
for initialization and use of ledA. This patch also fixes a bug where the
lcd would not power down when blanking.

Further this patch fixes an indentation issue. The comment line uses
eight whitespace and is replaced with a hard tab.

gpio_request + gpio_direction_output are replaced with gpio_request_one.
The return value of gpio_request_one is used to set the value of the
gpio to -EINVAL when unsuccessful, so that gpio_is_valid can detect the
unsuccessful request. But already successful requested gpios are not freed.

Reported-by: Daniel Morsing <daniel.morsing@gmail.com>
Signed-off-by: Thomas Weber <weber@corscience.de>
---
Changes from v4:
	Merge of two patches
	Use of gpio_request_one instead of gpio_request + gpio_direction_output
Changes from v3:
	Use return value of gpio_request
Changes from v2:
	Fix indention => indentation
	Better comment for removing low level functions used for twl4030 gpio
Changes from v1:
	Pull the indentation fix into this patch
	Change the pin for lcd pwren	
	
 arch/arm/mach-omap2/board-devkit8000.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index a5eb955..e4c12fe 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -115,9 +115,6 @@ static struct omap2_hsmmc_info mmc[] = {
 
 static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
 {
-	twl_i2c_write_u8(TWL4030_MODULE_GPIO, 0x80, REG_GPIODATADIR1);
-	twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
-
 	if (gpio_is_valid(dssdev->reset_gpio))
 		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
 	return 0;
@@ -247,6 +244,8 @@ static struct gpio_led gpio_leds[];
 static int devkit8000_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
+	int ret;
+
 	omap_mux_init_gpio(29, OMAP_PIN_INPUT);
 	/* gpio + 0 is "mmc0_cd" (input/IRQ) */
 	mmc[0].gpio_cd = gpio + 0;
@@ -255,17 +254,23 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
 
-        /* gpio + 1 is "LCD_PWREN" (out, active high) */
-	devkit8000_lcd_device.reset_gpio = gpio + 1;
-	gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
-	/* Disable until needed */
-	gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
+	/* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
+	devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
+	ret = gpio_request_one(devkit8000_lcd_device.reset_gpio,
+			GPIOF_DIR_OUT | GPIOF_INIT_LOW, "LCD_PWREN");
+	if (ret < 0) {
+		devkit8000_lcd_device.reset_gpio = -EINVAL;
+		printk(KERN_ERR "Failed to request GPIO for LCD_PWRN\n");
+	}
 
 	/* gpio + 7 is "DVI_PD" (out, active low) */
 	devkit8000_dvi_device.reset_gpio = gpio + 7;
-	gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
-	/* Disable until needed */
-	gpio_direction_output(devkit8000_dvi_device.reset_gpio, 0);
+	ret = gpio_request_one(devkit8000_dvi_device.reset_gpio,
+			GPIOF_DIR_OUT | GPIOF_INIT_LOW, "DVI PowerDown");
+	if (ret < 0) {
+		devkit8000_dvi_device.reset_gpio = -EINVAL;
+		printk(KERN_ERR "Failed to request GPIO for DVI PowerDown\n");
+	}
 
 	return 0;
 }
-- 
1.7.4.rc2

