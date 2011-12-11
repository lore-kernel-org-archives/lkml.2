Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1LKURR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:17:17 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48670 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1LKURO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:17:14 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 08/10] omapfb: lcd_ams_delta: Drive control lines over GPIO
Date: Sun, 11 Dec 2011 21:12:06 +0100
Message-Id: <1323634328-856-9-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use Amstrad Delta custom I/O functions any longer, use GPIO API
instead.

Depends on patch 5/10 "MTD: NAND: ams-delta: Use GPIO instead of custom
I/O".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/board-ams-delta.c             |   10 -------
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    2 -
 drivers/video/omap/lcd_ams_delta.c                |   27 +++++++++++++++-----
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 5705481..b7422e3 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -232,16 +232,6 @@ static struct gpio _latch_gpios[] __initconst = {
 		.label	= "dockit2",
 	},
 	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LCD_VBLEN,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "lcd_vblen",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_LCD_NDISP,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "lcd_ndisp",
-	},
-	{
 		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "keybrd_pwr",
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index 73fdab9..1d0706e 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -28,8 +28,6 @@
 
 #if defined (CONFIG_MACH_AMS_DELTA)
 
-#define AMS_DELTA_LATCH2_LCD_VBLEN	0x0001
-#define AMS_DELTA_LATCH2_LCD_NDISP	0x0002
 #define AMD_DELTA_LATCH2_KEYBRD_PWR	0x0100
 #define AMD_DELTA_LATCH2_KEYBRD_DATA	0x0200
 #define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
diff --git a/drivers/video/omap/lcd_ams_delta.c b/drivers/video/omap/lcd_ams_delta.c
index 6978ae4..73b211b 100644
--- a/drivers/video/omap/lcd_ams_delta.c
+++ b/drivers/video/omap/lcd_ams_delta.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/lcd.h>
+#include <linux/gpio.h>
 
 #include <plat/board-ams-delta.h>
 #include <mach/hardware.h>
@@ -98,29 +99,41 @@ static struct lcd_ops ams_delta_lcd_ops = {
 
 /* omapfb panel section */
 
+static struct gpio _gpios[] __initconst_or_module = {
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LCD_VBLEN,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "lcd_vblen",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LCD_NDISP,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "lcd_ndisp",
+	},
+};
+
 static int ams_delta_panel_init(struct lcd_panel *panel,
 		struct omapfb_device *fbdev)
 {
-	return 0;
+	return gpio_request_array(_gpios, ARRAY_SIZE(_gpios));
 }
 
 static void ams_delta_panel_cleanup(struct lcd_panel *panel)
 {
+	gpio_free_array(_gpios, ARRAY_SIZE(_gpios));
 }
 
 static int ams_delta_panel_enable(struct lcd_panel *panel)
 {
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_NDISP,
-			AMS_DELTA_LATCH2_LCD_NDISP);
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_VBLEN,
-			AMS_DELTA_LATCH2_LCD_VBLEN);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_LCD_NDISP, 1);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_LCD_VBLEN, 1);
 	return 0;
 }
 
 static void ams_delta_panel_disable(struct lcd_panel *panel)
 {
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_VBLEN, 0);
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_NDISP, 0);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_LCD_VBLEN, 0);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_LCD_NDISP, 0);
 }
 
 static unsigned long ams_delta_panel_get_caps(struct lcd_panel *panel)
-- 
1.7.3.4

