Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2EHHV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:21:29 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58442 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab2EHHV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:21:26 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 09/12] ARM: imx: eukrea_mbimxsd: add backlight and lcd support
Date: Tue,  8 May 2012 09:20:24 +0200
Message-Id: <1336461627-30315-9-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461627-30315-1-git-send-email-eric@eukrea.com>
References: <1336461627-30315-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Carikli <denis@eukrea.com>
Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/eukrea_mbimxsd-baseboard.c |   74 ++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/eukrea_mbimxsd-baseboard.c b/arch/arm/mach-imx/eukrea_mbimxsd-baseboard.c
index bc89bb6..920e42a 100644
--- a/arch/arm/mach-imx/eukrea_mbimxsd-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimxsd-baseboard.c
@@ -28,6 +28,8 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/i2c.h>
+#include <video/platform_lcd.h>
+#include <linux/backlight.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -71,10 +73,57 @@ static iomux_v3_cfg_t eukrea_mbimxsd_pads[] = {
 	MX51_PAD_AUD3_BB_RXD__AUD3_RXD,
 	MX51_PAD_AUD3_BB_CK__AUD3_TXC,
 	MX51_PAD_AUD3_BB_FS__AUD3_TXFS,
+	/* LCD Backlight */
+	MX51_PAD_DI1_D1_CS__GPIO3_4,
+	/* LCD RST */
+	MX51_PAD_CSI1_D9__GPIO3_13,
 };
 
 #define GPIO_LED1	IMX_GPIO_NR(3, 30)
 #define GPIO_SWITCH1	IMX_GPIO_NR(3, 31)
+#define GPIO_LCDRST	IMX_GPIO_NR(3, 13)
+#define GPIO_LCDBL	IMX_GPIO_NR(3, 4)
+
+static void eukrea_mbimxsd51_lcd_power_set(struct plat_lcd_data *pd,
+				   unsigned int power)
+{
+	if (power)
+		gpio_direction_output(GPIO_LCDRST, 1);
+	else
+		gpio_direction_output(GPIO_LCDRST, 0);
+}
+
+static struct plat_lcd_data eukrea_mbimxsd51_lcd_power_data = {
+	.set_power		= eukrea_mbimxsd51_lcd_power_set,
+};
+
+static struct platform_device eukrea_mbimxsd51_lcd_powerdev = {
+	.name			= "platform-lcd",
+	.dev.platform_data	= &eukrea_mbimxsd51_lcd_power_data,
+};
+
+static void eukrea_mbimxsd51_bl_set_intensity(int intensity)
+{
+	if (intensity)
+		gpio_direction_output(GPIO_LCDBL, 1);
+	else
+		gpio_direction_output(GPIO_LCDBL, 0);
+}
+
+static struct generic_bl_info eukrea_mbimxsd51_bl_info = {
+	.name			= "eukrea_mbimxsd51-bl",
+	.max_intensity		= 0xff,
+	.default_intensity	= 0xff,
+	.set_bl_intensity	= eukrea_mbimxsd51_bl_set_intensity,
+};
+
+static struct platform_device eukrea_mbimxsd51_bl_dev = {
+	.name			= "generic-bl",
+	.id			= 1,
+	.dev = {
+		.platform_data	= &eukrea_mbimxsd51_bl_info,
+	},
+};
 
 static const struct gpio_led eukrea_mbimxsd_leds[] __initconst = {
 	{
@@ -122,6 +171,19 @@ struct imx_ssi_platform_data eukrea_mbimxsd_ssi_pdata __initconst = {
 	.flags = IMX_SSI_SYN | IMX_SSI_NET | IMX_SSI_USE_I2S_SLAVE,
 };
 
+static int screen_type;
+
+static int __init eukrea_mbimxsd51_screen_type(char *options)
+{
+	if (!strcmp(options, "dvi"))
+		screen_type = 1;
+	else if (!strcmp(options, "tft"))
+		screen_type = 0;
+
+	return 0;
+}
+__setup("screen_type=", eukrea_mbimxsd51_screen_type);
+
 /*
  * system init for baseboard usage. Will be called by cpuimx51sd init.
  *
@@ -149,6 +211,18 @@ void __init eukrea_mbimxsd51_baseboard_init(void)
 	gpio_direction_input(GPIO_SWITCH1);
 	gpio_free(GPIO_SWITCH1);
 
+	gpio_request(GPIO_LCDRST, "LCDRST");
+	gpio_direction_output(GPIO_LCDRST, 0);
+	gpio_request(GPIO_LCDBL, "LCDBL");
+	gpio_direction_output(GPIO_LCDBL, 0);
+	if (!screen_type) {
+		platform_device_register(&eukrea_mbimxsd51_bl_dev);
+		platform_device_register(&eukrea_mbimxsd51_lcd_powerdev);
+	} else {
+		gpio_free(GPIO_LCDRST);
+		gpio_free(GPIO_LCDBL);
+	}
+
 	i2c_register_board_info(0, eukrea_mbimxsd_i2c_devices,
 				ARRAY_SIZE(eukrea_mbimxsd_i2c_devices));
 
-- 
1.7.7.6

