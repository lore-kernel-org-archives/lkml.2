Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab0EEROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:14:30 -0400
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:47510 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0EERO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:14:29 -0400
X-MXL-Hash: 4be1a7740df4eb5f-091df979268b01e27eaa010a546e63a6f1bc5cb5
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
       Richard Purdie <rpurdie@rpsys.net>
Date: Wed, 5 May 2010 12:13:23 -0500
Subject: [PATCH] backlight: Add Cirrus EP93xx backlight driver
Thread-Topic: [PATCH] backlight: Add Cirrus EP93xx backlight driver
Thread-Index: AcrsdkSiyVuG95OmS5SBj9sxcHoxVg==
Message-ID: <0D753D10438DA54287A00B0270842697636EC1EA58@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2943493793; CM=0.500; S=0.294(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=3aWvbf9_hegA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=i00gxMtYAAAA:8 a=rgg]
X-AnalysisOut: [nVFrEAAAA:8 a=-sM3sDvmAAAA:8 a=xDo7VF2rI-fousFZ7SYA:9 a=w6]
X-AnalysisOut: [RGS7Hnxm7C-EPFNMAA:7 a=bweHMZrkwZUDv6VYT_I24wxTj8QA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=ct-hs6iedJYA:10 a=130E6O]
X-AnalysisOut: [D_8ZAA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o45HEhmE004355

The EP9307, EP9312, and EP9315 processors include a framebuffer
peripheral.  This peripheral has a dedicated pwm output called
BRIGHT that can be used to control the backlight on an LCD.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

---

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 4dfb5f4..625a464 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -142,6 +142,16 @@ config BACKLIGHT_ATMEL_PWM
 	  To compile this driver as a module, choose M here: the module will be
 	  called atmel-pwm-bl.
 
+config BACKLIGHT_EP93XX
+	tristate "Cirrus EP93xx Backlight Driver"
+	depends on FB_EP93XX
+	help
+	  If you have a LCD backlight connected to the BRIGHT output of
+	  the EP93xx, say Y here to enable this driver.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called ep93xx_bl.
+
 config BACKLIGHT_GENERIC
 	tristate "Generic (aka Sharp Corgi) Backlight Driver"
 	default y
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 09d1f14..c89dc92 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_LCD_TOSA)		   += tosa_lcd.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)    += atmel-pwm-bl.o
+obj-$(CONFIG_BACKLIGHT_EP93XX)	+= ep93xx_bl.o
 obj-$(CONFIG_BACKLIGHT_GENERIC)	+= generic_bl.o
 obj-$(CONFIG_BACKLIGHT_HP700)	+= jornada720_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
new file mode 100644
index 0000000..b0cc491
--- /dev/null
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -0,0 +1,160 @@
+/*
+ * Driver for the Cirrus EP93xx lcd backlight
+ *
+ * Copyright (c) 2010 H Hartley Sweeten <hsweeten@visionengravers.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver controls the pulse width modulated brightness control output,
+ * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
+ */
+
+
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+
+#include <mach/hardware.h>
+
+#define EP93XX_RASTER_REG(x)		(EP93XX_RASTER_BASE + (x))
+#define EP93XX_RASTER_BRIGHTNESS	EP93XX_RASTER_REG(0x20)
+
+#define EP93XX_MAX_COUNT		255
+#define EP93XX_MAX_BRIGHT		255
+#define EP93XX_DEF_BRIGHT		128
+
+struct ep93xxbl {
+	void __iomem *mmio;
+	int brightness;
+};
+
+static int ep93xxbl_set(struct backlight_device *bl, int brightness)
+{
+	struct ep93xxbl *ep93xxbl = bl_get_data(bl);
+
+	__raw_writel((brightness << 8) | EP93XX_MAX_COUNT, ep93xxbl->mmio);
+
+	ep93xxbl->brightness = brightness;
+
+	return 0;
+}
+
+static int ep93xxbl_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+
+	if (bl->props.power != FB_BLANK_UNBLANK ||
+	    bl->props.fb_blank != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	return ep93xxbl_set(bl, brightness);
+}
+
+static int ep93xxbl_get_brightness(struct backlight_device *bl)
+{
+	struct ep93xxbl *ep93xxbl = bl_get_data(bl);
+
+	return ep93xxbl->brightness;
+}
+
+static const struct backlight_ops ep93xxbl_ops = {
+	.update_status	= ep93xxbl_update_status,
+	.get_brightness	= ep93xxbl_get_brightness,
+};
+
+static int __init ep93xxbl_probe(struct platform_device *dev)
+{
+	struct ep93xxbl *ep93xxbl;
+	struct backlight_device *bl;
+	struct backlight_properties props;
+
+	ep93xxbl = devm_kzalloc(&dev->dev, sizeof(*ep93xxbl), GFP_KERNEL);
+	if (!ep93xxbl)
+		return -ENOMEM;
+
+	/*
+	 * This register is located in the range already ioremap'ed by
+	 * the framebuffer driver.  A MFD driver seems a bit of overkill
+	 * to handle this so use the static I/O mapping; this address
+	 * is already virtual.
+	 *
+	 * NOTE: No locking is required; the framebuffer does not touch
+	 * this register.
+	 */
+	ep93xxbl->mmio = EP93XX_RASTER_BRIGHTNESS;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = EP93XX_MAX_BRIGHT;
+	bl = backlight_device_register(dev->name, &dev->dev, ep93xxbl,
+				       &ep93xxbl_ops, &props);
+	if (IS_ERR(bl))
+		return PTR_ERR(bl);
+
+	bl->props.brightness = EP93XX_DEF_BRIGHT;
+
+	platform_set_drvdata(dev, bl);
+
+	ep93xxbl_update_status(bl);
+
+	return 0;
+}
+
+static int ep93xxbl_remove(struct platform_device *dev)
+{
+	struct backlight_device *bl = platform_get_drvdata(dev);
+
+	backlight_device_unregister(bl);
+	platform_set_drvdata(dev, NULL);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ep93xxbl_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct backlight_device *bl = platform_get_drvdata(dev);
+
+	return ep93xxbl_set(bl, 0);
+}
+
+static int ep93xxbl_resume(struct platform_device *dev)
+{
+	struct backlight_device *bl = platform_get_drvdata(dev);
+
+	backlight_update_status(bl);
+	return 0;
+}
+#else
+#define ep93xxbl_suspend	NULL
+#define ep93xxbl_resume		NULL
+#endif
+
+static struct platform_driver ep93xxbl_driver = {
+	.driver		= {
+		.name	= "ep93xx-bl",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ep93xxbl_probe,
+	.remove		= __devexit_p(ep93xxbl_remove),
+	.suspend	= ep93xxbl_suspend,
+	.resume		= ep93xxbl_resume,
+};
+
+static int __init ep93xxbl_init(void)
+{
+	return platform_driver_register(&ep93xxbl_driver);
+}
+module_init(ep93xxbl_init);
+
+static void __exit ep93xxbl_exit(void)
+{
+	platform_driver_unregister(&ep93xxbl_driver);
+}
+module_exit(ep93xxbl_exit);
+
+MODULE_DESCRIPTION("EP93xx Backlight Driver");
+MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ep93xx-bl");
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
