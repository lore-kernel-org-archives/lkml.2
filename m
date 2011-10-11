Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1JKLEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:04:50 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56636 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab1JKLEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:04:12 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 3/3] at91: add Atmel ISI and ov2640 support on sam9m10/sam9g45 board
Date: Tue, 11 Oct 2011 19:03:40 +0800
Message-Id: <1318331020-22031-4-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
References: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
X-OriginalArrivalTime: 11 Oct 2011 11:03:47.0070 (UTC) FILETIME=[72E499E0:01CC8805]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add:
- ov2640 sensor in sam9m10/sam9g45 board.
- support to use PCK as ISI_MCK. PCK's parent is managed in SoC level, e.g. at91sam9g45_devices.c

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |   98 +++++++++++++++++++++++++++++-
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   85 +++++++++++++++++++++++++-
 2 files changed, 180 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 600bffb..00e6a7f 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -16,7 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
 #include <linux/atmel-mci.h>
-
+#include <linux/clk.h>
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
 
@@ -28,7 +28,10 @@
 #include <mach/at_hdmac.h>
 #include <mach/atmel-mci.h>
 
+#include <media/atmel-isi.h>
+
 #include "generic.h"
+#include "clock.h"
 
 
 /* --------------------------------------------------------------------
@@ -863,6 +866,99 @@ void __init at91_add_device_ac97(struct ac97c_platform_data *data)
 void __init at91_add_device_ac97(struct ac97c_platform_data *data) {}
 #endif
 
+/* --------------------------------------------------------------------
+ *  Image Sensor Interface
+ * -------------------------------------------------------------------- */
+#if defined(CONFIG_VIDEO_ATMEL_ISI) || defined(CONFIG_VIDEO_ATMEL_ISI_MODULE)
+static u64 isi_dmamask = DMA_BIT_MASK(32);
+static struct isi_platform_data isi_data;
+
+struct resource isi_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_ISI,
+		.end	= AT91SAM9G45_BASE_ISI + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_ISI,
+		.end	= AT91SAM9G45_ID_ISI,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_isi_device = {
+	.name		= "atmel_isi",
+	.id		= 0,
+	.dev		= {
+			.dma_mask		= &isi_dmamask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+			.platform_data		= &isi_data,
+	},
+	.resource	= isi_resources,
+	.num_resources	= ARRAY_SIZE(isi_resources),
+};
+
+static struct clk_lookup isi_mck_lookups[] = {
+	CLKDEV_CON_DEV_ID("isi_mck", "atmel_isi.0", NULL),
+};
+
+void __init at91_add_device_isi(struct isi_platform_data * data,
+		bool use_pck_as_mck)
+{
+	struct clk *pck;
+	struct clk *parent;
+
+	if (!data)
+		return;
+	isi_data = *data;
+
+	at91_set_A_periph(AT91_PIN_PB20, 0);	/* ISI_D0 */
+	at91_set_A_periph(AT91_PIN_PB21, 0);	/* ISI_D1 */
+	at91_set_A_periph(AT91_PIN_PB22, 0);	/* ISI_D2 */
+	at91_set_A_periph(AT91_PIN_PB23, 0);	/* ISI_D3 */
+	at91_set_A_periph(AT91_PIN_PB24, 0);	/* ISI_D4 */
+	at91_set_A_periph(AT91_PIN_PB25, 0);	/* ISI_D5 */
+	at91_set_A_periph(AT91_PIN_PB26, 0);	/* ISI_D6 */
+	at91_set_A_periph(AT91_PIN_PB27, 0);	/* ISI_D7 */
+	at91_set_A_periph(AT91_PIN_PB28, 0);	/* ISI_PCK */
+	at91_set_A_periph(AT91_PIN_PB30, 0);	/* ISI_HSYNC */
+	at91_set_A_periph(AT91_PIN_PB29, 0);	/* ISI_VSYNC */
+	at91_set_B_periph(AT91_PIN_PB8, 0);	/* ISI_PD8 */
+	at91_set_B_periph(AT91_PIN_PB9, 0);	/* ISI_PD9 */
+	at91_set_B_periph(AT91_PIN_PB10, 0);	/* ISI_PD10 */
+	at91_set_B_periph(AT91_PIN_PB11, 0);	/* ISI_PD11 */
+
+	platform_device_register(&at91sam9g45_isi_device);
+
+	if (use_pck_as_mck) {
+		at91_set_B_periph(AT91_PIN_PB31, 0);	/* ISI_MCK (PCK1) */
+
+		pck = clk_get(NULL, "pck1");
+		parent = clk_get(NULL, "plla");
+
+		if (IS_ERR(pck) || IS_ERR(parent))
+			BUG();
+
+		if (clk_set_parent(pck, parent))
+			printk(KERN_ERR "Failed to set PCK's parent\n");
+		else {
+			/* Register PCK as ISI_MCK */
+			isi_mck_lookups->clk = pck;
+			clkdev_add_table(isi_mck_lookups,
+					ARRAY_SIZE(isi_mck_lookups));
+		}
+
+		clk_put(pck);
+		clk_put(parent);
+	}
+
+	return;
+}
+#else
+void __init at91_add_device_isi(struct isi_platform_data * data,
+		int use_pck_as_mck) {}
+#endif
+
 
 /* --------------------------------------------------------------------
  *  LCD Controller
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index ad234cc..068464c 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -23,11 +23,13 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/leds.h>
-#include <linux/clk.h>
 #include <linux/atmel-mci.h>
+#include <linux/delay.h>
 
 #include <mach/hardware.h>
 #include <video/atmel_lcdc.h>
+#include <media/soc_camera.h>
+#include <media/atmel-isi.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -187,6 +189,76 @@ static void __init ek_add_device_nand(void)
 
 
 /*
+ *  ISI
+ */
+static struct isi_platform_data __initdata isi_data = {
+	.frate			= ISI_CFG1_FRATE_CAPTURE_ALL,
+	.has_emb_sync		= 0,
+	.emb_crc_sync		= 0,
+	.hsync_act_low		= 0,
+	.vsync_act_low		= 0,
+	.pclk_act_falling	= 0,
+	/* to use codec and preview path simultaneously */
+	.full_mode		= 1,
+	.data_width_flags	= ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10,
+	/* ISI_MCK is provided by programmable clock or external clock  */
+	.mck_hz			= 25000000,
+};
+
+
+/*
+ * soc-camera OV2640
+ */
+#if defined(CONFIG_SOC_CAMERA_OV2640) || \
+	defined(CONFIG_SOC_CAMERA_OV2640_MODULE)
+static unsigned long isi_camera_query_bus_param(struct soc_camera_link *link)
+{
+	/* ISI board for ek using default 8-bits connection */
+	return SOCAM_DATAWIDTH_8;
+}
+
+static int i2c_camera_power(struct device *dev, int on)
+{
+	/* enable or disable the camera */
+	pr_debug("%s: %s the camera\n", __func__, on ? "ENABLE" : "DISABLE");
+	at91_set_gpio_output(AT91_PIN_PD13, !on);
+
+	if (!on)
+		goto out;
+
+	/* If enabled, give a reset impulse */
+	at91_set_gpio_output(AT91_PIN_PD12, 0);
+	msleep(20);
+	at91_set_gpio_output(AT91_PIN_PD12, 1);
+	msleep(100);
+
+out:
+	return 0;
+}
+
+static struct i2c_board_info i2c_camera = {
+	I2C_BOARD_INFO("ov2640", 0x30),
+};
+
+static struct soc_camera_link iclink_ov2640 = {
+	.bus_id			= 0,
+	.board_info		= &i2c_camera,
+	.i2c_adapter_id		= 0,
+	.power			= i2c_camera_power,
+	.query_bus_param	= isi_camera_query_bus_param,
+};
+
+static struct platform_device isi_ov2640 = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &iclink_ov2640,
+	},
+};
+#endif
+
+
+/*
  * LCD Controller
  */
 #if defined(CONFIG_FB_ATMEL) || defined(CONFIG_FB_ATMEL_MODULE)
@@ -378,7 +450,12 @@ static struct gpio_led ek_pwm_led[] = {
 #endif
 };
 
-
+static struct platform_device *devices[] __initdata = {
+#if defined(CONFIG_SOC_CAMERA_OV2640) || \
+	defined(CONFIG_SOC_CAMERA_OV2640_MODULE)
+	&isi_ov2640,
+#endif
+};
 
 static void __init ek_board_init(void)
 {
@@ -400,6 +477,8 @@ static void __init ek_board_init(void)
 	ek_add_device_nand();
 	/* I2C */
 	at91_add_device_i2c(0, NULL, 0);
+	/* ISI, using programmable clock as ISI_MCK */
+	at91_add_device_isi(&isi_data, 1);
 	/* LCD Controller */
 	at91_add_device_lcdc(&ek_lcdc_data);
 	/* Touch Screen */
@@ -411,6 +490,8 @@ static void __init ek_board_init(void)
 	/* LEDs */
 	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
 	at91_pwm_leds(ek_pwm_led, ARRAY_SIZE(ek_pwm_led));
+	/* Other platform devices */
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 MACHINE_START(AT91SAM9M10G45EK, "Atmel AT91SAM9M10G45-EK")
-- 
1.6.3.3

