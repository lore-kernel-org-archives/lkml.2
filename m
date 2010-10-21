Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0JUVDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:03:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35305 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0JUVCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:02:01 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 10/12] backlight: add support for tps6116x controller
Date: Thu, 21 Oct 2010 17:01:11 -0400
Message-Id: <1287694873-12904-11-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287694873-12904-1-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS6116x is an EasyScale backlight controller device.  This driver supports
TPS6116x devices connected on a single GPIO.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 drivers/video/backlight/Kconfig    |    7 +
 drivers/video/backlight/Makefile   |    2 +-
 drivers/video/backlight/tps6116x.c |  340 ++++++++++++++++++++++++++++++++++++
 3 files changed, 348 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/backlight/tps6116x.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index e54a337..06e868e 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -307,6 +307,13 @@ config BACKLIGHT_PCF50633
 	  If you have a backlight driven by a NXP PCF50633 MFD, say Y here to
 	  enable its driver.
 
+config BACKLIGHT_TPS6116X
+	tristate "TPS6116X LCD Backlight"
+	depends on GENERIC_GPIO
+	help
+	  This driver controls the LCD backlight level for EasyScale capable
+	  SSP connected backlight controllers.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 44c0f81..5d407c8 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -35,4 +35,4 @@ obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
-
+obj-$(CONFIG_BACKLIGHT_TPS6116X)+= tps6116x.o
diff --git a/drivers/video/backlight/tps6116x.c b/drivers/video/backlight/tps6116x.c
new file mode 100644
index 0000000..7a9f8ca
--- /dev/null
+++ b/drivers/video/backlight/tps6116x.c
@@ -0,0 +1,340 @@
+/*
+ * TPS6116X LCD Backlight Controller Driver
+ *
+ * Copyright (C) 2010 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/fb.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/backlight.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+
+#define TPS6116X_MAX_INTENSITY		31
+#define TPS6116X_DEFAULT_INTENSITY	10
+
+/* Easyscale timing w/ margin (usecs) */
+#define T_POWER_SETTLE			2000
+#define T_ES_DELAY			120
+#define T_ES_DETECT			280
+#define T_ES_WINDOW			(1000 - T_ES_DELAY - T_ES_DETECT)
+#define T_START				3
+#define T_EOS				3
+#define T_INACTIVE			3
+#define T_ACTIVE			(3 * T_INACTIVE)
+
+#define CMD_SET				0x72
+
+struct tps6116x {
+	struct ti_ssp_device		*handle;
+	struct device			*dev;
+	int				gpio, gpio_initialized;
+	struct mutex			lock;
+	int				intensity;
+	int				power;
+	struct backlight_properties	props;
+	struct backlight_device		*bl;
+	int				suspended:1;
+	struct regulator		*regulator;
+};
+
+static int __set_power(struct tps6116x *hw, int power)
+{
+	unsigned long flags;
+	int error;
+
+	power = !!power;
+	if (power == hw->power)
+		return 0; /* nothing to do */
+
+	/* disabling is simple... choke power */
+	if (!power) {
+		error = regulator_disable(hw->regulator);
+		goto done;
+	}
+
+	/* set ctrl pin init state for easyscale detection */
+	gpio_set_value(hw->gpio, 0);
+
+	error = regulator_enable(hw->regulator);
+	if (error < 0)
+		goto done;
+
+	udelay(T_POWER_SETTLE);
+
+	/*
+	 * Now that the controller is powered up, we need to put it into 1-wire
+	 * mode.  This is a timing sensitive operation, hence the irq disable.
+	 * Ideally, this should happen rarely, and mostly at init, so disabling
+	 * interrupts for the duration should not be a problem.
+	 */
+	local_irq_save(flags);
+
+	gpio_set_value(hw->gpio, 1);
+	udelay(T_ES_DELAY);
+	gpio_set_value(hw->gpio, 0);
+	udelay(T_ES_DETECT);
+	gpio_set_value(hw->gpio, 1);
+
+	local_irq_restore(flags);
+
+done:
+	if (error >= 0)
+		hw->power = power;
+
+	return error;
+}
+
+static void __write_byte(struct tps6116x *hw, u8 data)
+{
+	int bit;
+
+	gpio_set_value(hw->gpio, 1);
+	udelay(T_START);
+
+	for (bit = 0; bit < 8; bit++, data <<= 1) {
+		int val = data & 0x80;
+		int t_lo = val ? T_INACTIVE : T_ACTIVE;
+		int t_hi = val ? T_ACTIVE : T_INACTIVE;
+
+		gpio_set_value(hw->gpio, 0);
+		udelay(t_lo);
+		gpio_set_value(hw->gpio, 1);
+		udelay(t_hi);
+	}
+
+	gpio_set_value(hw->gpio, 0);
+	udelay(T_EOS);
+	gpio_set_value(hw->gpio, 1);
+}
+
+static void __set_intensity(struct tps6116x *hw, int intensity)
+{
+	unsigned long flags;
+
+	intensity = clamp(intensity, 0, TPS6116X_MAX_INTENSITY);
+
+	local_irq_save(flags);
+	__write_byte(hw, CMD_SET);
+	__write_byte(hw, intensity);
+	local_irq_restore(flags);
+}
+
+static int set_intensity(struct tps6116x *hw, int intensity)
+{
+	int error = 0;
+
+	if (intensity == hw->intensity)
+		return 0;
+
+	mutex_lock(&hw->lock);
+
+	if (!hw->gpio_initialized) {
+		error = gpio_request_one(hw->gpio, GPIOF_DIR_OUT,
+					 dev_name(hw->dev));
+		if (error < 0)
+			goto error;
+		hw->gpio_initialized = 1;
+	}
+
+	error = __set_power(hw, intensity ? 1 : 0);
+	if (error < 0)
+		goto error;
+
+	if (intensity > 0)
+		__set_intensity(hw, intensity);
+
+	hw->intensity = intensity;
+error:
+	mutex_unlock(&hw->lock);
+
+	return error;
+}
+
+static ssize_t intensity_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct tps6116x *hw = dev_get_drvdata(dev);
+	ssize_t len = 0;
+
+	len += snprintf(buf+len, PAGE_SIZE-len, "%d\n", hw->intensity);
+
+	return len;
+}
+
+static ssize_t intensity_store(struct device *dev,
+			       struct device_attribute *attr, const char *buf,
+			       size_t count)
+{
+	struct tps6116x *hw = dev_get_drvdata(dev);
+	unsigned long intensity;
+	int error;
+
+	error = strict_strtoul(buf, 10, &intensity);
+	if (error < 0)
+		return error;
+
+	error = set_intensity(hw, intensity);
+	if (error < 0)
+		return error;
+
+	return count;
+}
+
+DEVICE_ATTR(intensity, S_IWUSR | S_IRUGO, intensity_show, intensity_store);
+
+static int get_brightness(struct backlight_device *bl)
+{
+	struct tps6116x *hw = bl_get_data(bl);
+
+	return hw->intensity;
+}
+
+static int update_status(struct backlight_device *bl)
+{
+	struct tps6116x *hw = bl_get_data(bl);
+	int intensity = bl->props.brightness;
+
+	if (hw->suspended)
+		intensity = 0;
+	if (bl->props.power != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
+		intensity = 0;
+
+	return set_intensity(hw, intensity);
+}
+
+static const struct backlight_ops tps6116x_backlight_ops = {
+	.get_brightness	= get_brightness,
+	.update_status	= update_status,
+};
+
+static int __devinit tps6116x_probe(struct platform_device *pdev)
+{
+	struct tps6116x *hw;
+	struct device *dev = &pdev->dev;
+	struct backlight_properties props;
+	int error;
+
+	hw = kzalloc(sizeof(struct tps6116x), GFP_KERNEL);
+	if (!hw) {
+		error = -ENOMEM;
+		dev_err(dev, "cannot allocate driver data\n");
+		goto fail0;
+	}
+	platform_set_drvdata(pdev, hw);
+
+	memset(hw, 0, sizeof(struct tps6116x));
+	hw->gpio = (int)dev->platform_data;
+	hw->dev = dev;
+
+	mutex_init(&hw->lock);
+
+	error = device_create_file(dev, &dev_attr_intensity);
+	if (error < 0) {
+		dev_err(dev, "cannot create device attributes\n");
+		goto fail1;
+	}
+
+	hw->regulator = regulator_get(dev, "vlcd");
+	if (IS_ERR(hw->regulator)) {
+		error = PTR_ERR(hw->regulator);
+		dev_err(dev, "cannot claim regulator\n");
+		goto fail2;
+	}
+
+	memset(&props, 0, sizeof(props));
+	props.max_brightness = TPS6116X_MAX_INTENSITY;
+	props.brightness     = TPS6116X_DEFAULT_INTENSITY;
+
+	hw->bl = backlight_device_register("tps6116x", hw->dev, hw,
+					   &tps6116x_backlight_ops, &props);
+	if (IS_ERR(hw->bl)) {
+		error = PTR_ERR(hw->bl);
+		dev_err(dev, "backlight registration failed\n");
+		goto fail3;
+	}
+
+	dev_info(dev, "registered backlight controller\n");
+	return 0;
+
+fail3:
+	regulator_put(hw->regulator);
+fail2:
+	device_remove_file(dev, &dev_attr_intensity);
+fail1:
+	kfree(hw);
+	platform_set_drvdata(pdev, NULL);
+fail0:
+	return error;
+}
+
+static int __devexit tps6116x_remove(struct platform_device *pdev)
+{
+	struct tps6116x *hw = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(hw->bl);
+	regulator_disable(hw->regulator);
+	regulator_put(hw->regulator);
+	device_remove_file(hw->dev, &dev_attr_intensity);
+	kfree(hw);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static int tps6116x_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct tps6116x *hw = platform_get_drvdata(pdev);
+	hw->suspended = 1;
+	update_status(hw->bl);
+	return 0;
+}
+
+static int tps6116x_resume(struct platform_device *pdev)
+{
+	struct tps6116x *hw = platform_get_drvdata(pdev);
+	hw->suspended = 0;
+	update_status(hw->bl);
+	return 0;
+}
+
+static struct platform_driver tps6116x_driver = {
+	.probe		= tps6116x_probe,
+	.remove		= __devexit_p(tps6116x_remove),
+	.suspend	= tps6116x_suspend,
+	.resume		= tps6116x_resume,
+	.driver		= {
+		.name	= "tps6116x",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init tps6116x_init(void)
+{
+	return platform_driver_register(&tps6116x_driver);
+}
+module_init(tps6116x_init);
+
+static void __exit tps6116x_exit(void)
+{
+	platform_driver_unregister(&tps6116x_driver);
+}
+module_exit(tps6116x_exit);
+
+MODULE_DESCRIPTION("SSP TPS6116X Driver");
+MODULE_AUTHOR("Cyril Chemparathy");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:tps6116x");
-- 
1.7.0.4

