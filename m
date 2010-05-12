Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0ELApU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:45:20 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:46183 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754070Ab0ELApN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:45:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 1517
From: Lars-Peter Clausen <lars@metafoo.de>
To: rpurdie@rpsys.net
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/3] backlight: Add pcf50633 backlight driver
Date: Wed, 12 May 2010 02:44:32 +0200
Message-Id: <1273625074-15312-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273625074-15312-1-git-send-email-lars@metafoo.de>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a backlight driver for controlling the pcf50633 LED module.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/video/backlight/Kconfig              |    7 +
 drivers/video/backlight/Makefile             |    1 +
 drivers/video/backlight/pcf50633-backlight.c |  190 ++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/backlight.h       |   51 +++++++
 4 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/pcf50633-backlight.c
 create mode 100644 include/linux/mfd/pcf50633/backlight.h

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 4dfb5f4..3e8e7f7 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -270,6 +270,13 @@ config BACKLIGHT_88PM860X
 	help
 	  Say Y to enable the backlight driver for Marvell 88PM8606.
 
+config BACKLIGHT_PCF50633
+	tristate "Backlight driver for NXP PCF50633 MFD"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_PCF50633
+	help
+	  If you have a backlight driven by a NXP PCF50633 MFD, say Y here to
+	  enable its driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 09d1f14..8b714c1 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -31,4 +31,5 @@ obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
 obj-$(CONFIG_BACKLIGHT_ADX)    += adx_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
+obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
 
diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
new file mode 100644
index 0000000..3c424f7
--- /dev/null
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -0,0 +1,190 @@
+/*
+ *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *      PCF50633 backlight device driver
+ *
+ *  This program is free software; you can redistribute	 it and/or modify it
+ *  under  the terms of	 the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+
+#include <linux/backlight.h>
+#include <linux/fb.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/backlight.h>
+
+struct pcf50633_bl {
+	struct pcf50633 *pcf;
+	struct backlight_device *bl;
+
+	unsigned int brightness;
+	unsigned int brightness_limit;
+};
+
+/*
+ * pcf50633_bl_set_brightness_limit
+ *
+ * Update the brightness limit for the pc50633 backlight. The actual brightness
+ * will not go above the limit. This is useful to limit power drain for example
+ * on low battery.
+ *
+ * @dev: Pointer to a pcf50633 device
+ * @limit: The brightness limit. Valid values are 0-63
+ */
+int pcf50633_bl_set_brightness_limit(struct pcf50633 *pcf, unsigned int limit)
+{
+	struct pcf50633_bl *pcf_bl = platform_get_drvdata(pcf->bl_pdev);
+
+	if (!pcf_bl)
+		return -ENODEV;
+
+	pcf_bl->brightness_limit = limit & 0x3f;
+	backlight_update_status(pcf_bl->bl);
+
+    return 0;
+}
+
+static int pcf50633_bl_update_status(struct backlight_device *bl)
+{
+	struct pcf50633_bl *pcf_bl = bl_get_data(bl);
+	unsigned int new_brightness;
+
+
+	if (bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK) ||
+		bl->props.power != FB_BLANK_UNBLANK)
+		new_brightness = 0;
+	else if (bl->props.brightness < pcf_bl->brightness_limit)
+		new_brightness = bl->props.brightness;
+	else
+		new_brightness = pcf_bl->brightness_limit;
+
+
+	if (pcf_bl->brightness == new_brightness)
+		return 0;
+
+	if (new_brightness) {
+		pcf50633_reg_write(pcf_bl->pcf, PCF50633_REG_LEDOUT,
+					new_brightness);
+		if (!pcf_bl->brightness)
+			pcf50633_reg_write(pcf_bl->pcf, PCF50633_REG_LEDENA, 1);
+	} else {
+		pcf50633_reg_write(pcf_bl->pcf, PCF50633_REG_LEDENA, 0);
+	}
+
+	pcf_bl->brightness = new_brightness;
+
+	return 0;
+}
+
+static int pcf50633_bl_get_brightness(struct backlight_device *bl)
+{
+	struct pcf50633_bl *pcf_bl = bl_get_data(bl);
+	return pcf_bl->brightness;
+}
+
+static const struct backlight_ops pcf50633_bl_ops = {
+	.get_brightness = pcf50633_bl_get_brightness,
+	.update_status	= pcf50633_bl_update_status,
+	.options	= BL_CORE_SUSPENDRESUME,
+};
+
+static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct pcf50633_bl *pcf_bl;
+	struct device *parent = pdev->dev.parent;
+	struct pcf50633_platform_data *pcf50633_data = parent->platform_data;
+	struct pcf50633_bl_platform_data *pdata = pcf50633_data->backlight_data;
+	struct backlight_properties bl_props;
+
+	pcf_bl = kzalloc(sizeof(*pcf_bl), GFP_KERNEL);
+	if (!pcf_bl)
+		return -ENOMEM;
+
+	bl_props.max_brightness = 0x3f;
+	bl_props.power = FB_BLANK_UNBLANK;
+
+	if (pdata) {
+		bl_props.brightness = pdata->default_brightness;
+		pcf_bl->brightness_limit = pdata->default_brightness_limit;
+	} else {
+		bl_props.brightness = 0x3f;
+		pcf_bl->brightness_limit = 0x3f;
+	}
+
+	pcf_bl->pcf = dev_to_pcf50633(pdev->dev.parent);
+
+	pcf_bl->bl = backlight_device_register(pdev->name, &pdev->dev, pcf_bl,
+						&pcf50633_bl_ops, &bl_props);
+
+	if (IS_ERR(pcf_bl->bl)) {
+		ret = PTR_ERR(pcf_bl->bl);
+		goto err_free;
+	}
+
+	platform_set_drvdata(pdev, pcf_bl);
+
+	pcf50633_reg_write(pcf_bl->pcf, PCF50633_REG_LEDDIM, pdata->ramp_time);
+
+	/* Should be different from bl_props.brightness, so we do not exit
+	 * update_status early the first time it's called */
+	pcf_bl->brightness = pcf_bl->bl->props.brightness + 1;
+
+	backlight_update_status(pcf_bl->bl);
+
+	return 0;
+
+err_free:
+	kfree(pcf_bl);
+
+	return ret;
+}
+
+static int __devexit pcf50633_bl_remove(struct platform_device *pdev)
+{
+	struct pcf50633_bl *pcf_bl = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(pcf_bl->bl);
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(pcf_bl);
+
+	return 0;
+}
+
+static struct platform_driver pcf50633_bl_driver = {
+	.probe =	pcf50633_bl_probe,
+	.remove =	__devexit_p(pcf50633_bl_remove),
+	.driver = {
+		.name = "pcf50633-backlight",
+	},
+};
+
+static int __init pcf50633_bl_init(void)
+{
+	return platform_driver_register(&pcf50633_bl_driver);
+}
+module_init(pcf50633_bl_init);
+
+static void __exit pcf50633_bl_exit(void)
+{
+	platform_driver_unregister(&pcf50633_bl_driver);
+}
+module_exit(pcf50633_bl_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("PCF50633 backlight driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-backlight");
diff --git a/include/linux/mfd/pcf50633/backlight.h b/include/linux/mfd/pcf50633/backlight.h
new file mode 100644
index 0000000..83747e2
--- /dev/null
+++ b/include/linux/mfd/pcf50633/backlight.h
@@ -0,0 +1,51 @@
+/*
+ *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *      PCF50633 backlight device driver
+ *
+ *  This program is free software; you can redistribute	 it and/or modify it
+ *  under  the terms of	 the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_PCF50633_BACKLIGHT
+#define __LINUX_MFD_PCF50633_BACKLIGHT
+
+/*
+* @default_brightness: Backlight brightness is initialized to this value
+*
+* Brightness to be used after the driver has been probed.
+* Valid range 0-63.
+*
+* @default_brightness_limit: The actual brightness is limited by this value
+*
+* Brightness limit to be used after the driver has been probed. This is useful
+* when it is not known how much power is available for the backlight during
+* probe.
+* Valid range 0-63. Can be changed later with pcf50633_bl_set_brightness_limit.
+*
+* @ramp_time: Display ramp time when changing brightness
+*
+* When changing the backlights brightness the change is not instant, instead
+* it fades smooth from one state to another. This value specifies how long
+* the fade should take. The lower the value the higher the fade time.
+* Valid range 0-255
+*/
+struct pcf50633_bl_platform_data {
+	unsigned int	default_brightness;
+	unsigned int	default_brightness_limit;
+	uint8_t		ramp_time;
+};
+
+
+struct pcf50633;
+
+int pcf50633_bl_set_brightness_limit(struct pcf50633 *pcf, unsigned int limit);
+
+#endif
+
-- 
1.5.6.5

