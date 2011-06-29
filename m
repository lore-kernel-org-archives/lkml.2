Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1F2OHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:07:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5394 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1F2OG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:06:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 Jun 2011 07:06:56 -0700
From: Jin Park <jinyoungp@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>
Subject: [PATCH 2/3] backlight: aat2870: Add AAT2870 backlight driver
Date: Wed, 29 Jun 2011 23:06:51 +0900
Message-Id: <1309356412-23881-3-git-send-email-jinyoungp@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com>
References: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add backlight driver for AnalogicTech AAT2870.

Signed-off-by: Jin Park <jinyoungp@nvidia.com>
---
 drivers/video/backlight/Kconfig      |    7 +
 drivers/video/backlight/Makefile     |    1 +
 drivers/video/backlight/aat2870_bl.c |  246 ++++++++++++++++++++++++++++++++++
 3 files changed, 254 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/aat2870_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 2d93c8d..07ce8f0 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -327,6 +327,13 @@ config BACKLIGHT_PCF50633
 	  If you have a backlight driven by a NXP PCF50633 MFD, say Y here to
 	  enable its driver.
 
+config BACKLIGHT_AAT2870
+	bool "AnalogicTech AAT2870 Backlight"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_AAT2870_CORE
+	help
+	  If you have a AnalogicTech AAT2870 say Y to enable the
+	  backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index ee72adb..27f99d1 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -37,4 +37,5 @@ obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
+obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
 
diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
new file mode 100644
index 0000000..4952a61
--- /dev/null
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -0,0 +1,246 @@
+/*
+ * linux/drivers/video/backlight/aat2870_bl.c
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ * Author: Jin Park <jinyoungp@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/mfd/aat2870.h>
+
+struct aat2870_bl_driver_data {
+	struct platform_device *pdev;
+	struct backlight_device *bd;
+
+	int channels;
+	int max_current;
+	int brightness; /* current brightness */
+};
+
+static inline int aat2870_brightness(struct aat2870_bl_driver_data *aat2870_bl,
+				     int brightness)
+{
+	struct backlight_device *bd = aat2870_bl->bd;
+	int val;
+
+	val = brightness * aat2870_bl->max_current;
+	val /= bd->props.max_brightness;
+
+	return val;
+}
+
+static inline int aat2870_bl_enable(struct aat2870_bl_driver_data *aat2870_bl)
+{
+	struct aat2870_data *aat2870
+			= dev_get_drvdata(aat2870_bl->pdev->dev.parent);
+
+	return aat2870->write(aat2870, AAT2870_BL_CH_EN,
+			      (u8)aat2870_bl->channels);
+}
+
+static inline int aat2870_bl_disable(struct aat2870_bl_driver_data *aat2870_bl)
+{
+	struct aat2870_data *aat2870
+			= dev_get_drvdata(aat2870_bl->pdev->dev.parent);
+
+	return aat2870->write(aat2870, AAT2870_BL_CH_EN, 0x0);
+}
+
+static int aat2870_bl_get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static int aat2870_bl_update_status(struct backlight_device *bd)
+{
+	struct aat2870_bl_driver_data *aat2870_bl = dev_get_drvdata(&bd->dev);
+	struct aat2870_data *aat2870 =
+			dev_get_drvdata(aat2870_bl->pdev->dev.parent);
+	int brightness = bd->props.brightness;
+	int ret;
+
+	if ((brightness < 0) || (bd->props.max_brightness < brightness)) {
+		dev_err(&bd->dev, "invalid brightness, %d\n", brightness);
+		return -EINVAL;
+	}
+
+	dev_dbg(&bd->dev, "brightness=%d, power=%d, state=%d\n",
+		 bd->props.brightness, bd->props.power, bd->props.state);
+
+	if ((bd->props.power != FB_BLANK_UNBLANK) ||
+			(bd->props.state & BL_CORE_FBBLANK) ||
+			(bd->props.state & BL_CORE_SUSPENDED))
+		brightness = 0;
+
+	ret = aat2870->write(aat2870, AAT2870_BLM,
+			     (u8)aat2870_brightness(aat2870_bl, brightness));
+	if (ret < 0)
+		return ret;
+
+	if (brightness == 0) {
+		ret = aat2870_bl_disable(aat2870_bl);
+		if (ret < 0)
+			return ret;
+	} else if (aat2870_bl->brightness == 0) {
+		ret = aat2870_bl_enable(aat2870_bl);
+		if (ret < 0)
+			return ret;
+	}
+
+	aat2870_bl->brightness = brightness;
+
+	return 0;
+}
+
+static int aat2870_bl_check_fb(struct backlight_device *bd, struct fb_info *fi)
+{
+	return 1;
+}
+
+static const struct backlight_ops aat2870_bl_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.get_brightness = aat2870_bl_get_brightness,
+	.update_status = aat2870_bl_update_status,
+	.check_fb = aat2870_bl_check_fb,
+};
+
+static int aat2870_bl_probe(struct platform_device *pdev)
+{
+	struct aat2870_bl_platform_data *pdata = pdev->dev.platform_data;
+	struct aat2870_bl_driver_data *aat2870_bl;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	int ret = 0;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (pdev->id != AAT2870_ID_BL) {
+		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	aat2870_bl = kzalloc(sizeof(struct aat2870_bl_driver_data), GFP_KERNEL);
+	if (!aat2870_bl) {
+		dev_err(&pdev->dev,
+			"Failed to allocate memory for aat2870 backlight\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+
+	props.type = BACKLIGHT_RAW;
+	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
+				       aat2870_bl, &aat2870_bl_ops, &props);
+	if (!bd) {
+		dev_err(&pdev->dev,
+			"Failed allocate memory for backlight device\n");
+		ret = -ENOMEM;
+		goto out_kfree;
+	}
+
+	aat2870_bl->pdev = pdev;
+	platform_set_drvdata(pdev, aat2870_bl);
+
+	aat2870_bl->bd = bd;
+
+	if (pdata->channels > 0)
+		aat2870_bl->channels = pdata->channels;
+	else
+		aat2870_bl->channels = AAT2870_BL_CH_ALL;
+
+	if (pdata->max_brightness > 0)
+		aat2870_bl->max_current = pdata->max_current;
+	else
+		aat2870_bl->max_current = AAT2870_CURRENT_27_9;
+
+	if (pdata->max_brightness > 0)
+		bd->props.max_brightness = pdata->max_brightness;
+	else
+		bd->props.max_brightness = 255;
+
+	aat2870_bl->brightness = 0;
+	bd->props.power = FB_BLANK_UNBLANK;
+	bd->props.brightness = bd->props.max_brightness;
+
+	ret = aat2870_bl_update_status(bd);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize\n");
+		goto out_bl_dev_unregister;
+	}
+
+	return 0;
+
+out_bl_dev_unregister:
+	backlight_device_unregister(bd);
+out_kfree:
+	kfree(aat2870_bl);
+out:
+	return ret;
+}
+
+static int aat2870_bl_remove(struct platform_device *pdev)
+{
+	struct aat2870_bl_driver_data *aat2870_bl = platform_get_drvdata(pdev);
+	struct backlight_device *bd = aat2870_bl->bd;
+
+	bd->props.power = FB_BLANK_POWERDOWN;
+	bd->props.brightness = 0;
+	backlight_update_status(bd);
+
+	backlight_device_unregister(bd);
+	kfree(aat2870_bl);
+
+	return 0;
+}
+
+static struct platform_driver aat2870_bl_driver = {
+	.driver = {
+		.name	= "aat2870-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aat2870_bl_probe,
+	.remove		= aat2870_bl_remove,
+};
+
+static int __init aat2870_bl_init(void)
+{
+	return platform_driver_register(&aat2870_bl_driver);
+}
+subsys_initcall(aat2870_bl_init);
+
+static void __exit aat2870_bl_exit(void)
+{
+	platform_driver_unregister(&aat2870_bl_driver);
+}
+module_exit(aat2870_bl_exit);
+
+MODULE_DESCRIPTION("AnalogicTech AAT2870 Backlight");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jin Park <jinyoungp@nvidia.com>");
-- 
1.7.1

