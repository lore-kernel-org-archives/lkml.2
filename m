Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1KPLNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:13:45 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54644 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab1KPLNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:13:44 -0500
Subject: [PATCH] backlight: drop ADX backlight device support
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 12:13:35 +0100
Message-ID: <1321442015.20271.269.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the Avionic Design Xanthos backlight device got added in
commit 3b96ea9ef8. That support depends on ARCH_PXA_ADX. The code that
should have provided that Kconfig symbol never got submitted. It has
never been possible to even build this driver. Drop it.

Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Thierry Reding acked the removal of this driver beforehand (see
https://lkml.org/lkml/2011/11/15/92 ) and should complain loudly if he
doesn't approve of the way I do that in this patch! (Wim Van Sebroeck
will remove the watchdog driver.)

1) "make menuconfig" tested and "git grep"  tested only. Does that
suffice?

 drivers/video/backlight/Kconfig  |    8 --
 drivers/video/backlight/Makefile |    1 -
 drivers/video/backlight/adx_bl.c |  182 --------------------------------------
 3 files changed, 0 insertions(+), 191 deletions(-)
 delete mode 100644 drivers/video/backlight/adx_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 278aeaa..681b369 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -280,14 +280,6 @@ config BACKLIGHT_WM831X
 	  If you have a backlight driven by the ISINK and DCDC of a
 	  WM831x PMIC say y to enable the backlight driver for it.
 
-config BACKLIGHT_ADX
-	tristate "Avionic Design Xanthos Backlight Driver"
-	depends on ARCH_PXA_ADX
-	default y
-	help
-	  Say Y to enable the backlight driver on Avionic Design Xanthos-based
-	  boards.
-
 config BACKLIGHT_ADP5520
 	tristate "Backlight Driver for ADP5520/ADP5501 using WLED"
 	depends on PMIC_ADP5520
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index fdd1fc4..af5cf65 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
 obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
-obj-$(CONFIG_BACKLIGHT_ADX)    += adx_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp8870_bl.o
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
deleted file mode 100644
index c861c41..0000000
--- a/drivers/video/backlight/adx_bl.c
+++ /dev/null
@@ -1,182 +0,0 @@
-/*
- * linux/drivers/video/backlight/adx.c
- *
- * Copyright (C) 2009 Avionic Design GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Written by Thierry Reding <thierry.reding@avionic-design.de>
- */
-
-#include <linux/backlight.h>
-#include <linux/fb.h>
-#include <linux/gfp.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-
-/* register definitions */
-#define ADX_BACKLIGHT_CONTROL		0x00
-#define ADX_BACKLIGHT_CONTROL_ENABLE	(1 << 0)
-#define ADX_BACKLIGHT_BRIGHTNESS	0x08
-#define ADX_BACKLIGHT_STATUS		0x10
-#define ADX_BACKLIGHT_ERROR		0x18
-
-struct adxbl {
-	void __iomem *base;
-};
-
-static int adx_backlight_update_status(struct backlight_device *bldev)
-{
-	struct adxbl *bl = bl_get_data(bldev);
-	u32 value;
-
-	value = bldev->props.brightness;
-	writel(value, bl->base + ADX_BACKLIGHT_BRIGHTNESS);
-
-	value = readl(bl->base + ADX_BACKLIGHT_CONTROL);
-
-	if (bldev->props.state & BL_CORE_FBBLANK)
-		value &= ~ADX_BACKLIGHT_CONTROL_ENABLE;
-	else
-		value |= ADX_BACKLIGHT_CONTROL_ENABLE;
-
-	writel(value, bl->base + ADX_BACKLIGHT_CONTROL);
-
-	return 0;
-}
-
-static int adx_backlight_get_brightness(struct backlight_device *bldev)
-{
-	struct adxbl *bl = bl_get_data(bldev);
-	u32 brightness;
-
-	brightness = readl(bl->base + ADX_BACKLIGHT_BRIGHTNESS);
-	return brightness & 0xff;
-}
-
-static int adx_backlight_check_fb(struct backlight_device *bldev, struct fb_info *fb)
-{
-	return 1;
-}
-
-static const struct backlight_ops adx_backlight_ops = {
-	.options = 0,
-	.update_status = adx_backlight_update_status,
-	.get_brightness = adx_backlight_get_brightness,
-	.check_fb = adx_backlight_check_fb,
-};
-
-static int __devinit adx_backlight_probe(struct platform_device *pdev)
-{
-	struct backlight_properties props;
-	struct backlight_device *bldev;
-	struct resource *res;
-	struct adxbl *bl;
-	int ret = 0;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-	res = devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), res->name);
-	if (!res) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
-	if (!bl) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	bl->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			resource_size(res));
-	if (!bl->base) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.type = BACKLIGHT_RAW;
-	props.max_brightness = 0xff;
-	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
-					  bl, &adx_backlight_ops, &props);
-	if (IS_ERR(bldev)) {
-		ret = PTR_ERR(bldev);
-		goto out;
-	}
-
-	bldev->props.brightness = 0xff;
-	bldev->props.power = FB_BLANK_UNBLANK;
-
-	platform_set_drvdata(pdev, bldev);
-
-out:
-	return ret;
-}
-
-static int __devexit adx_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bldev;
-	int ret = 0;
-
-	bldev = platform_get_drvdata(pdev);
-	bldev->props.power = FB_BLANK_UNBLANK;
-	bldev->props.brightness = 0xff;
-	backlight_update_status(bldev);
-	backlight_device_unregister(bldev);
-	platform_set_drvdata(pdev, NULL);
-
-	return ret;
-}
-
-#ifdef CONFIG_PM
-static int adx_backlight_suspend(struct platform_device *pdev,
-		pm_message_t state)
-{
-	return 0;
-}
-
-static int adx_backlight_resume(struct platform_device *pdev)
-{
-	return 0;
-}
-#else
-#define adx_backlight_suspend NULL
-#define adx_backlight_resume NULL
-#endif
-
-static struct platform_driver adx_backlight_driver = {
-	.probe = adx_backlight_probe,
-	.remove = __devexit_p(adx_backlight_remove),
-	.suspend = adx_backlight_suspend,
-	.resume = adx_backlight_resume,
-	.driver = {
-		.name = "adx-backlight",
-		.owner = THIS_MODULE,
-	},
-};
-
-static int __init adx_backlight_init(void)
-{
-	return platform_driver_register(&adx_backlight_driver);
-}
-
-static void __exit adx_backlight_exit(void)
-{
-	platform_driver_unregister(&adx_backlight_driver);
-}
-
-module_init(adx_backlight_init);
-module_exit(adx_backlight_exit);
-
-MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
-MODULE_DESCRIPTION("Avionic Design Xanthos Backlight Driver");
-MODULE_LICENSE("GPL v2");
-- 
1.7.4.4



