Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0I2Tbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:31:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43295 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0I2Tba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=fS53wvG4Hh681UqSbU1mVsiWHh0WrcNQdscbf4wv4Y6l+IH7XqVyWnol0Ftlm1tVgj
         JG6BszgoqXIxFHnDcUDuvLAJDgFQpDmb0p4ac16l+PHKmV4xFLqVGGdC/ZlwzS4XfLC1
         +2a2+LLuARRI93BeVHJ5nnfI8RP2a4zeprnqI=
Subject: [PATCH 1/9] ARM: S3C64XX: add frame buffer support for mach-real6410
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:31:27 +0300
Message-ID: <20100929193047.25307.35558.stgit@darius-desktop>
In-Reply-To: <20100929192354.25307.40197.stgit@darius-desktop>
References: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for frame buffer device for mach-real6410.
Patch also adds support for feature string parsing
for real6410. The feature string is kernel command
line passed and currently lets select only LCD
configuration. At the moment there is support for
two LCD configurations - 4.3" and 7.0". Feature
parser is mach-mini2440 based.

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---
 arch/arm/mach-s3c64xx/Kconfig         |    2 
 arch/arm/mach-s3c64xx/mach-real6410.c |  146 ++++++++++++++++++++++++++++++++-
 2 files changed, 143 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index 1e4d78a..3bbd418 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -104,6 +104,8 @@ config MACH_REAL6410
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC1
 	select S3C64XX_SETUP_SDHCI
+	select S3C_DEV_FB
+	select S3C64XX_SETUP_FB_24BPP
 	help
 	  Machine support for the CoreWind REAL6410
 
diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-s3c64xx/mach-real6410.c
index e130379..bed75d2 100644
--- a/arch/arm/mach-s3c64xx/mach-real6410.c
+++ b/arch/arm/mach-s3c64xx/mach-real6410.c
@@ -12,24 +12,35 @@
  *
 */
 
-#include <linux/kernel.h>
-#include <linux/types.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/fb.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/init.h>
 #include <linux/dm9000.h>
-#include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/serial_core.h>
+#include <linux/types.h>
+
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+
 #include <mach/map.h>
-#include <mach/s3c6410.h>
+#include <mach/regs-fb.h>
+#include <mach/regs-gpio.h>
+#include <mach/regs-modem.h>
 #include <mach/regs-srom.h>
+#include <mach/s3c6410.h>
+
 #include <plat/cpu.h>
 #include <plat/devs.h>
+#include <plat/fb.h>
 #include <plat/regs-serial.h>
 
+#include <video/platform_lcd.h>
+
 #define UCON (S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
 #define ULCON (S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
 #define UFCON (S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE)
@@ -99,22 +110,145 @@ static struct platform_device real6410_device_eth = {
 	},
 };
 
+static struct s3c_fb_pd_win real6410_fb_win[] = {
+	{
+		.win_mode	= {	/* 4.3" 480x272 */
+			.left_margin	= 3,
+			.right_margin	= 2,
+			.upper_margin	= 1,
+			.lower_margin	= 1,
+			.hsync_len	= 40,
+			.vsync_len	= 1,
+			.xres		= 480,
+			.yres		= 272,
+		},
+		.max_bpp	= 32,
+		.default_bpp	= 16,
+	}, {
+		.win_mode	= {	/* 7.0" 800x480 */
+			.left_margin	= 8,
+			.right_margin	= 13,
+			.upper_margin	= 7,
+			.lower_margin	= 5,
+			.hsync_len	= 3,
+			.vsync_len	= 1,
+			.xres		= 800,
+			.yres		= 480,
+		},
+		.max_bpp	= 32,
+		.default_bpp	= 16,
+	},
+};
+
+static struct s3c_fb_platdata real6410_lcd_pdata __initdata = {
+	.setup_gpio	= s3c64xx_fb_gpio_setup_24bpp,
+	.win[0]		= &real6410_fb_win[0],
+	.vidcon0	= VIDCON0_VIDOUT_RGB | VIDCON0_PNRMODE_RGB,
+	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC,
+};
+
 static struct platform_device *real6410_devices[] __initdata = {
 	&real6410_device_eth,
 	&s3c_device_hsmmc0,
 	&s3c_device_hsmmc1,
+	&s3c_device_fb,
 };
 
 static void __init real6410_map_io(void)
 {
+	u32 tmp;
+
 	s3c64xx_init_io(NULL, 0);
 	s3c24xx_init_clocks(12000000);
 	s3c24xx_init_uarts(real6410_uartcfgs, ARRAY_SIZE(real6410_uartcfgs));
+
+	/* set the LCD type */
+	tmp = __raw_readl(S3C64XX_SPCON);
+	tmp &= ~S3C64XX_SPCON_LCD_SEL_MASK;
+	tmp |= S3C64XX_SPCON_LCD_SEL_RGB;
+	__raw_writel(tmp, S3C64XX_SPCON);
+
+	/* remove the LCD bypass */
+	tmp = __raw_readl(S3C64XX_MODEM_MIFPCON);
+	tmp &= ~MIFPCON_LCD_BYPASS;
+	__raw_writel(tmp, S3C64XX_MODEM_MIFPCON);
+}
+
+/*
+ * real6410_features string
+ *
+ * 0-9 LCD configuration
+ *
+ */
+static char real6410_features_str[12] __initdata = "0";
+
+static int __init real6410_features_setup(char *str)
+{
+	if (str)
+		strlcpy(real6410_features_str, str,
+			sizeof(real6410_features_str));
+	return 1;
+}
+
+__setup("real6410=", real6410_features_setup);
+
+#define FEATURE_SCREEN (1 << 0)
+
+struct real6410_features_t {
+	int done;
+	int lcd_index;
+};
+
+static void real6410_parse_features(
+		struct real6410_features_t *features,
+		const char *features_str)
+{
+	const char *fp = features_str;
+
+	features->done = 0;
+	features->lcd_index = 0;
+
+	while (*fp) {
+		char f = *fp++;
+
+		switch (f) {
+		case '0'...'9':	/* tft screen */
+			if (features->done & FEATURE_SCREEN) {
+				printk(KERN_INFO "REAL6410: '%c' ignored, "
+					"screen type already set\n", f);
+			} else {
+				int li = f - '0';
+				if (li >= ARRAY_SIZE(real6410_fb_win))
+					printk(KERN_INFO "REAL6410: '%c' out "
+						"of range LCD mode\n", f);
+				else {
+					features->lcd_index = li;
+				}
+			}
+			features->done |= FEATURE_SCREEN;
+			break;
+		}
+	}
 }
 
 static void __init real6410_machine_init(void)
 {
 	u32 cs1;
+	struct real6410_features_t features = { 0 };
+
+	printk(KERN_INFO "REAL6410: Option string real6410=%s\n",
+			real6410_features_str);
+
+	/* Parse the feature string */
+	real6410_parse_features(&features, real6410_features_str);
+
+	real6410_lcd_pdata.win[0] = &real6410_fb_win[features.lcd_index];
+
+	printk(KERN_INFO "REAL6410: selected LCD display is %dx%d\n",
+		real6410_lcd_pdata.win[0]->win_mode.xres,
+		real6410_lcd_pdata.win[0]->win_mode.yres);
+
+	s3c_fb_set_platdata(&real6410_lcd_pdata);
 
 	/* configure nCS1 width to 16 bits */
 
@@ -136,6 +270,8 @@ static void __init real6410_machine_init(void)
 		(4 << S3C64XX_SROM_BCX__TCOS__SHIFT) |
 		(0 << S3C64XX_SROM_BCX__TACS__SHIFT), S3C64XX_SROM_BC1);
 
+	gpio_request(S3C64XX_GPF(15), "LCD power");
+
 	platform_add_devices(real6410_devices, ARRAY_SIZE(real6410_devices));
 }
 

