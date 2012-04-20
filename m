Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2DTPbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:31:23 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58046 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145Ab2DTPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:30:59 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/4] mfd: add LM3533 lighting-power core driver
Date: Fri, 20 Apr 2012 17:30:23 +0200
Message-Id: <1334935826-12527-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for National Semiconductor / TI LM3533 lighting power chips.

This is the core driver which provides register access over I2C and
registers the ambient light sensor, LED and backlight sub-drivers.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/Kconfig           |   12 +
 drivers/mfd/Makefile          |    3 +
 drivers/mfd/lm3533-core.c     |  738 +++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/lm3533-ctrlbank.c |  134 ++++++++
 drivers/mfd/lm3533-i2c.c      |  115 +++++++
 include/linux/mfd/lm3533.h    |  106 ++++++
 6 files changed, 1108 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/lm3533-core.c
 create mode 100644 drivers/mfd/lm3533-ctrlbank.c
 create mode 100644 drivers/mfd/lm3533-i2c.c
 create mode 100644 include/linux/mfd/lm3533.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 29f463c..e2760d9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -106,6 +106,18 @@ config UCB1400_CORE
 	  To compile this driver as a module, choose M here: the
 	  module will be called ucb1400_core.
 
+config MFD_LM3533
+	tristate "LM3533 Lighting Power chip"
+	depends on I2C
+	select MFD_CORE
+	help
+	  Say yes here to enable support for National Semiconductor / TI
+	  LM3533 Lighting Power chips.
+
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the LED,
+	  backlight or ambient-light-sensor functionality of the device.
+
 config TPS6105X
 	tristate "TPS61050/61052 Boost Converters"
 	depends on I2C
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 05fa538..563fffa 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,6 +15,9 @@ obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
 
+lm3533-objs			:= lm3533-core.o lm3533-i2c.o
+obj-$(CONFIG_MFD_LM3533)	+= lm3533.o lm3533-ctrlbank.o
+
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
 obj-$(CONFIG_STMPE_I2C)		+= stmpe-i2c.o
 obj-$(CONFIG_STMPE_SPI)		+= stmpe-spi.o
diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
new file mode 100644
index 0000000..7a2d174
--- /dev/null
+++ b/drivers/mfd/lm3533-core.c
@@ -0,0 +1,738 @@
+/*
+ * lm3533-core.c -- LM3533 Core
+ *
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * Author: Johan Hovold <jhovold@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+#define LM3533_BOOST_OVP_MAX		0x03
+#define LM3533_BOOST_OVP_MASK		0x06
+#define LM3533_BOOST_OVP_SHIFT		1
+
+#define LM3533_BOOST_FREQ_MAX		0x01
+#define LM3533_BOOST_FREQ_MASK		0x01
+#define LM3533_BOOST_FREQ_SHIFT		0
+
+#define LM3533_BL_ID_MASK		1
+#define LM3533_LED_ID_MASK		3
+#define LM3533_BL_ID_MAX		1
+#define LM3533_LED_ID_MAX		3
+
+#define LM3533_HVLED_ID_MAX		2
+#define LM3533_LVLED_ID_MAX		5
+
+#define LM3533_REG_OUTPUT_CONF1		0x10
+#define LM3533_REG_OUTPUT_CONF2		0x11
+#define LM3533_REG_BOOST_PWM		0x2c
+
+
+static struct mfd_cell lm3533_als_devs[] = {
+	{
+		.name	= "lm3533-als",
+		.id	= -1,
+	},
+};
+
+static struct mfd_cell lm3533_bl_devs[] = {
+	{
+		.name	= "lm3533-backlight",
+		.id	= 0,
+	},
+	{
+		.name	= "lm3533-backlight",
+		.id	= 1,
+	},
+};
+
+static struct mfd_cell lm3533_led_devs[] = {
+	{
+		.name	= "lm3533-leds",
+		.id	= 0,
+	},
+	{
+		.name	= "lm3533-leds",
+		.id	= 1,
+	},
+	{
+		.name	= "lm3533-leds",
+		.id	= 2,
+	},
+	{
+		.name	= "lm3533-leds",
+		.id	= 3,
+	},
+};
+
+static int __lm3533_read(struct lm3533 *lm3533, u8 reg, u8 *val)
+{
+	int ret;
+
+	ret = lm3533->read(lm3533, reg, val);
+	if (ret < 0) {
+		dev_err(lm3533->dev, "failed to read register %02x: %d\n",
+								reg, ret);
+		return ret;
+	}
+
+	dev_dbg(lm3533->dev, "read [%02x]: %02x\n", reg, *val);
+
+	return 0;
+}
+
+static int __lm3533_write(struct lm3533 *lm3533, u8 reg, u8 val)
+{
+	int ret;
+
+	dev_dbg(lm3533->dev, "write [%02x]: %02x\n", reg, val);
+
+	ret = lm3533->write(lm3533, reg, val);
+	if (ret < 0) {
+		dev_err(lm3533->dev, "failed to write register %02x: %d\n",
+								reg, ret);
+	}
+
+	return ret;
+}
+
+int lm3533_read(struct lm3533 *lm3533, u8 reg, u8 *val)
+{
+	int ret;
+
+	mutex_lock(&lm3533->io_mutex);
+	ret = __lm3533_read(lm3533, reg, val);
+	mutex_unlock(&lm3533->io_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lm3533_read);
+
+int lm3533_write(struct lm3533 *lm3533, u8 reg, u8 val)
+{
+	int ret;
+
+	mutex_lock(&lm3533->io_mutex);
+	ret = __lm3533_write(lm3533, reg, val);
+	mutex_unlock(&lm3533->io_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lm3533_write);
+
+int lm3533_update(struct lm3533 *lm3533, u8 reg, u8 val, u8 mask)
+{
+	u8 old_val;
+	u8 new_val;
+	int ret;
+
+	mutex_lock(&lm3533->io_mutex);
+	ret = __lm3533_read(lm3533, reg, &old_val);
+	if (ret)
+		goto out;
+	new_val = (old_val & ~mask) | (val & mask);
+	if (new_val != old_val)
+		ret = __lm3533_write(lm3533, reg, new_val);
+out:
+	mutex_unlock(&lm3533->io_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lm3533_update);
+
+/*
+ * HVLED output config -- output hvled controlled by backlight bl
+ */
+static int lm3533_set_hvled_config(struct lm3533 *lm3533, u8 hvled, u8 bl)
+{
+	u8 val;
+	u8 mask;
+	int shift;
+	int ret;
+
+	if (hvled == 0 || hvled > LM3533_HVLED_ID_MAX)
+		return -EINVAL;
+
+	if (bl > LM3533_BL_ID_MAX)
+		return -EINVAL;
+
+	shift = hvled - 1;
+	mask = LM3533_BL_ID_MASK << shift;
+	val = bl << shift;
+
+	ret = lm3533_update(lm3533, LM3533_REG_OUTPUT_CONF1, val, mask);
+	if (ret)
+		dev_err(lm3533->dev, "failed to set hvled config\n");
+
+	return ret;
+}
+
+/*
+ * LVLED output config -- output lvled controlled by LED led
+ */
+static int lm3533_set_lvled_config(struct lm3533 *lm3533, u8 lvled, u8 led)
+{
+	u8 reg;
+	u8 val;
+	u8 mask;
+	int shift;
+	int ret;
+
+	if (lvled == 0 || lvled > LM3533_LVLED_ID_MAX)
+		return -EINVAL;
+
+	if (led > LM3533_LED_ID_MAX)
+		return -EINVAL;
+
+	if (lvled < 4) {
+		reg = LM3533_REG_OUTPUT_CONF1;
+		shift = 2 * lvled;
+	} else {
+		reg = LM3533_REG_OUTPUT_CONF2;
+		shift = 2 * (lvled - 4);
+	}
+
+	mask = LM3533_LED_ID_MASK << shift;
+	val = led << shift;
+
+	ret = lm3533_update(lm3533, reg, val, mask);
+	if (ret)
+		dev_err(lm3533->dev, "failed to set lvled config\n");
+
+	return ret;
+}
+
+static void lm3533_enable(struct lm3533 *lm3533)
+{
+	if (gpio_is_valid(lm3533->gpio_hwen))
+		gpio_set_value(lm3533->gpio_hwen, 1);
+}
+
+static void lm3533_disable(struct lm3533 *lm3533)
+{
+	if (gpio_is_valid(lm3533->gpio_hwen))
+		gpio_set_value(lm3533->gpio_hwen, 0);
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+const struct {
+	u8 min;
+	u8 max;
+} lm3533_regs[] = {
+	{ 0x10, 0x2c },
+	{ 0x30, 0x38 },
+	{ 0x40, 0x45 },
+	{ 0x50, 0x57 },
+	{ 0x60, 0x6e },
+	{ 0x70, 0x75 },
+	{ 0x80, 0x85 },
+	{ 0x90, 0x95 },
+	{ 0xa0, 0xa5 },
+	{ 0xb0, 0xb2 },
+};
+
+static int lm3533_regs_show(struct seq_file *s, void *__unused)
+{
+	struct lm3533 *lm3533 = s->private;
+	u8 reg;
+	u8 val;
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lm3533_regs); ++i) {
+		for (reg = lm3533_regs[i].min;
+					reg <= lm3533_regs[i].max; ++reg) {
+			ret = lm3533_read(lm3533, reg, &val);
+			if (ret)
+				return ret;
+
+			seq_printf(s, "[%02x]: %02x\n", reg, val);
+		}
+	}
+
+	return 0;
+}
+
+static int lm3533_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, lm3533_regs_show, inode->i_private);
+}
+
+static int lm3533_set_reg_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t lm3533_set_reg_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct lm3533 *lm3533 = file->private_data;
+	char buf[32];
+	int len;
+	unsigned reg;
+	unsigned val;
+	int ret;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = 0;
+
+	if (sscanf(buf, "%x %x", &reg, &val) != 2)
+		return -EINVAL;
+
+	if (reg > 0xff || val > 0xff)
+		return -EINVAL;
+
+	ret = lm3533_write(lm3533, (u8)reg, (u8)val);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static const struct file_operations lm3533_regs_fops = {
+	.open		= lm3533_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations lm3533_set_reg_fops = {
+	.open		= lm3533_set_reg_open,
+	.write		= lm3533_set_reg_write,
+};
+
+static void __devinit lm3533_debugfs_init(struct lm3533 *lm3533)
+{
+	struct dentry *d;
+
+	lm3533->debugfs_root = debugfs_create_dir("lm3533", NULL);
+	if (!lm3533->debugfs_root) {
+		dev_err(lm3533->dev, "failed to create debugfs root\n");
+		return;
+	}
+
+	d = debugfs_create_file("regs", 0444, lm3533->debugfs_root, lm3533,
+							&lm3533_regs_fops);
+	if (!d)
+		dev_err(lm3533->dev, "failed to create debugfs regs file\n");
+
+	d = debugfs_create_file("set_reg", 0644, lm3533->debugfs_root, lm3533,
+							&lm3533_set_reg_fops);
+	if (!d) {
+		dev_err(lm3533->dev,
+				"failed to create debugfs set_reg file\n");
+	}
+}
+
+static void __devexit lm3533_debugfs_cleanup(struct lm3533 *lm3533)
+{
+	debugfs_remove_recursive(lm3533->debugfs_root);
+}
+
+#else	/* CONFIG_DEBUG_FS */
+static void lm3533_debugfs_init(struct lm3533 *lm3533) { }
+static void lm3533_debugfs_cleanup(struct lm3533 *lm3533) { }
+#endif	/* CONFIG_DEBUG_FS */
+
+enum lm3533_attribute_type {
+	LM3533_ATTR_TYPE_BACKLIGHT,
+	LM3533_ATTR_TYPE_LED,
+};
+
+struct lm3533_device_attribute {
+	struct device_attribute dev_attr;
+	enum lm3533_attribute_type type;
+	union {
+		struct {
+			u8 id;
+		} output;
+		struct {
+			u8 reg;
+			u8 shift;
+			u8 mask;
+			u8 max;
+		} generic;
+	} u;
+};
+
+#define to_lm3533_dev_attr(_attr) \
+	container_of(_attr, struct lm3533_device_attribute, dev_attr)
+
+static ssize_t show_lm3533_reg(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533 *lm3533 = dev_get_drvdata(dev);
+	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(attr);
+	u8 val;
+	int ret;
+
+	ret = lm3533_read(lm3533, lattr->u.generic.reg, &val);
+	if (ret)
+		return ret;
+
+	val = (val & lattr->u.generic.mask) >> lattr->u.generic.shift;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t store_lm3533_reg(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t len)
+{
+	struct lm3533 *lm3533 = dev_get_drvdata(dev);
+	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(attr);
+	u8 val;
+	int ret;
+
+	if (kstrtou8(buf, 0, &val) || val > lattr->u.generic.max)
+		return -EINVAL;
+
+	val = val << lattr->u.generic.shift;
+	ret = lm3533_update(lm3533, lattr->u.generic.reg, val,
+							lattr->u.generic.mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+#define GENERIC_ATTR(_reg, _max, _mask, _shift) \
+	{ .reg		= _reg, \
+	  .max		= _max, \
+	  .mask		= _mask, \
+	  .shift	= _shift }
+
+#define LM3533_GENERIC_ATTR(_name, _mode, _show, _store, _type,	\
+						_reg, _max, _mask, _shift) \
+	struct lm3533_device_attribute lm3533_dev_attr_##_name = { \
+		.dev_attr	= __ATTR(_name, _mode, _show, _store), \
+		.type		= _type, \
+		.u.generic	= GENERIC_ATTR(_reg, _max, _mask, _shift) }
+
+#define LM3533_GENERIC_ATTR_RW(_name, _type, _reg, _max, _mask, _shift) \
+	LM3533_GENERIC_ATTR(_name, S_IRUGO | S_IWUSR, \
+					show_lm3533_reg, store_lm3533_reg, \
+					_type, _reg, _max, _mask, _shift)
+
+#define LM3533_BOOST_ATTR_RW(_name, _NAME) \
+	LM3533_GENERIC_ATTR_RW(_name, LM3533_ATTR_TYPE_BACKLIGHT, \
+				LM3533_REG_BOOST_PWM, LM3533_##_NAME##_MAX, \
+				LM3533_##_NAME##_MASK, LM3533_##_NAME##_SHIFT)
+/*
+ * Boost Over Voltage Protection Select
+ *
+ *   0 -- 16 V (default)
+ *   1 -- 24 V
+ *   2 -- 32 V
+ *   3 -- 40 V
+ */
+static LM3533_BOOST_ATTR_RW(boost_ovp, BOOST_OVP);
+
+/*
+ * Boost Frequency Select
+ *
+ *   0 -- 500 kHz (default)
+ *   1 -- 1 MHz
+ */
+static LM3533_BOOST_ATTR_RW(boost_freq, BOOST_FREQ);
+
+static ssize_t show_output(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533 *lm3533 = dev_get_drvdata(dev);
+	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(attr);
+	int id = lattr->u.output.id;
+	u8 reg;
+	u8 val;
+	u8 mask;
+	int shift;
+	int ret;
+
+	if (lattr->type == LM3533_ATTR_TYPE_BACKLIGHT) {
+		reg = LM3533_REG_OUTPUT_CONF1;
+		shift = id - 1;
+		mask = LM3533_BL_ID_MASK << shift;
+	} else {
+		if (id < 4) {
+			reg = LM3533_REG_OUTPUT_CONF1;
+			shift = 2 * id;
+		} else {
+			reg = LM3533_REG_OUTPUT_CONF2;
+			shift = 2 * (id - 4);
+		}
+		mask = LM3533_LED_ID_MASK << shift;
+	}
+
+	ret = lm3533_read(lm3533, reg, &val);
+	if (ret)
+		return ret;
+
+	val = (val & mask) >> shift;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t store_output(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct lm3533 *lm3533 = dev_get_drvdata(dev);
+	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(attr);
+	int id = lattr->u.output.id;
+	u8 val;
+	int ret;
+
+	if (kstrtou8(buf, 0, &val))
+		return -EINVAL;
+
+	if (lattr->type == LM3533_ATTR_TYPE_BACKLIGHT)
+		ret = lm3533_set_hvled_config(lm3533, id, val);
+	else
+		ret = lm3533_set_lvled_config(lm3533, id, val);
+
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+#define LM3533_OUTPUT_ATTR(_name, _mode, _show, _store, _type, _id) \
+	struct lm3533_device_attribute lm3533_dev_attr_##_name = \
+		{ .dev_attr	= __ATTR(_name, _mode, _show, _store), \
+		  .type		= _type, \
+		  .u.output	= { .id = _id }, }
+
+#define LM3533_OUTPUT_ATTR_RW(_name, _type, _id) \
+	LM3533_OUTPUT_ATTR(output_##_name, S_IRUGO | S_IWUSR, \
+					show_output, store_output, _type, _id)
+
+#define LM3533_OUTPUT_HVLED_ATTR_RW(_nr) \
+	LM3533_OUTPUT_ATTR_RW(hvled##_nr, LM3533_ATTR_TYPE_BACKLIGHT, _nr)
+#define LM3533_OUTPUT_LVLED_ATTR_RW(_nr) \
+	LM3533_OUTPUT_ATTR_RW(lvled##_nr, LM3533_ATTR_TYPE_LED, _nr)
+/*
+ * Output config:
+ *
+ * output_hvled<nr> -- 0-1
+ * output_lvled<nr> -- 0-3
+ */
+static LM3533_OUTPUT_HVLED_ATTR_RW(1);
+static LM3533_OUTPUT_HVLED_ATTR_RW(2);
+static LM3533_OUTPUT_LVLED_ATTR_RW(1);
+static LM3533_OUTPUT_LVLED_ATTR_RW(2);
+static LM3533_OUTPUT_LVLED_ATTR_RW(3);
+static LM3533_OUTPUT_LVLED_ATTR_RW(4);
+static LM3533_OUTPUT_LVLED_ATTR_RW(5);
+
+static struct attribute *lm3533_attributes[] = {
+	&lm3533_dev_attr_boost_freq.dev_attr.attr,
+	&lm3533_dev_attr_boost_ovp.dev_attr.attr,
+	&lm3533_dev_attr_output_hvled1.dev_attr.attr,
+	&lm3533_dev_attr_output_hvled2.dev_attr.attr,
+	&lm3533_dev_attr_output_lvled1.dev_attr.attr,
+	&lm3533_dev_attr_output_lvled2.dev_attr.attr,
+	&lm3533_dev_attr_output_lvled3.dev_attr.attr,
+	&lm3533_dev_attr_output_lvled4.dev_attr.attr,
+	&lm3533_dev_attr_output_lvled5.dev_attr.attr,
+	NULL,
+};
+
+#define to_dev_attr(_attr) \
+	container_of(_attr, struct device_attribute, attr)
+
+static mode_t lm3533_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct lm3533 *lm3533 = dev_get_drvdata(dev);
+	struct device_attribute *dattr = to_dev_attr(attr);
+	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(dattr);
+	enum lm3533_attribute_type type = lattr->type;
+	mode_t mode = attr->mode;
+
+	if (!lm3533->have_backlights && type == LM3533_ATTR_TYPE_BACKLIGHT)
+		mode = 0;
+	else if (!lm3533->have_leds && type == LM3533_ATTR_TYPE_LED)
+		mode = 0;
+
+	return mode;
+};
+
+static struct attribute_group lm3533_attribute_group = {
+	.is_visible	= lm3533_attr_is_visible,
+	.attrs		= lm3533_attributes
+};
+
+static int __devinit lm3533_device_als_init(struct lm3533 *lm3533)
+{
+	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	int ret;
+
+	if (!pdata->als)
+		return 0;
+
+	lm3533_als_devs[0].platform_data = pdata->als;
+	lm3533_als_devs[0].pdata_size = sizeof(*pdata->als);
+
+	ret = mfd_add_devices(lm3533->dev, 0, lm3533_als_devs, 1, NULL, 0);
+	if (ret) {
+		dev_err(lm3533->dev, "failed to add ALS device\n");
+		return ret;
+	}
+
+	lm3533->have_als = 1;
+
+	return 0;
+}
+
+static int __devinit lm3533_device_bl_init(struct lm3533 *lm3533)
+{
+	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	int i;
+	int ret;
+
+	if (!pdata->backlights || pdata->num_backlights == 0)
+		return 0;
+
+	if (pdata->num_backlights > ARRAY_SIZE(lm3533_bl_devs))
+		pdata->num_backlights = ARRAY_SIZE(lm3533_bl_devs);
+
+	for (i = 0; i < pdata->num_backlights; ++i) {
+		lm3533_bl_devs[i].platform_data = &pdata->backlights[i];
+		lm3533_bl_devs[i].pdata_size = sizeof(pdata->backlights[i]);
+	}
+
+	ret = mfd_add_devices(lm3533->dev, 0, lm3533_bl_devs,
+					pdata->num_backlights, NULL, 0);
+	if (ret) {
+		dev_err(lm3533->dev, "failed to add backlight devices\n");
+		return ret;
+	}
+
+	lm3533->have_backlights = 1;
+
+	return 0;
+}
+
+static int __devinit lm3533_device_led_init(struct lm3533 *lm3533)
+{
+	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	int i;
+	int ret;
+
+	if (!pdata->leds || pdata->num_leds == 0)
+		return 0;
+
+	if (pdata->num_leds > ARRAY_SIZE(lm3533_led_devs))
+		pdata->num_leds = ARRAY_SIZE(lm3533_led_devs);
+
+	for (i = 0; i < pdata->num_leds; ++i) {
+		lm3533_led_devs[i].platform_data = &pdata->leds[i];
+		lm3533_led_devs[i].pdata_size = sizeof(pdata->leds[i]);
+	}
+
+	ret = mfd_add_devices(lm3533->dev, 0, lm3533_led_devs,
+						pdata->num_leds, NULL, 0);
+	if (ret) {
+		dev_err(lm3533->dev, "failed to add LED devices\n");
+		return ret;
+	}
+
+	lm3533->have_leds = 1;
+
+	return 0;
+}
+
+int __devinit lm3533_device_init(struct lm3533 *lm3533)
+{
+	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	int ret;
+
+	dev_dbg(lm3533->dev, "%s\n", __func__);
+
+	if (!pdata) {
+		dev_err(lm3533->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&lm3533->io_mutex);
+	lm3533->gpio_hwen = pdata->gpio_hwen;
+
+	dev_set_drvdata(lm3533->dev, lm3533);
+
+	if (gpio_is_valid(lm3533->gpio_hwen)) {
+		ret = gpio_request_one(lm3533->gpio_hwen, GPIOF_OUT_INIT_LOW,
+								"lm3533-hwen");
+		if (ret < 0) {
+			dev_err(lm3533->dev,
+				"failed to request HWEN GPIO %d\n",
+				lm3533->gpio_hwen);
+			return ret;
+		}
+	}
+
+	lm3533_enable(lm3533);
+
+	lm3533_device_als_init(lm3533);
+	lm3533_device_bl_init(lm3533);
+	lm3533_device_led_init(lm3533);
+
+	ret = sysfs_create_group(&lm3533->dev->kobj, &lm3533_attribute_group);
+	if (ret < 0) {
+		dev_err(lm3533->dev, "failed to create sysfs attributes\n");
+		goto err_unregister;
+	}
+
+	lm3533_debugfs_init(lm3533);
+
+	return 0;
+
+err_unregister:
+	mfd_remove_devices(lm3533->dev);
+	lm3533_disable(lm3533);
+	if (gpio_is_valid(lm3533->gpio_hwen))
+		gpio_free(lm3533->gpio_hwen);
+
+	return ret;
+}
+
+void __devexit lm3533_device_exit(struct lm3533 *lm3533)
+{
+	dev_dbg(lm3533->dev, "%s\n", __func__);
+
+	lm3533_debugfs_cleanup(lm3533);
+
+	sysfs_remove_group(&lm3533->dev->kobj, &lm3533_attribute_group);
+
+	mfd_remove_devices(lm3533->dev);
+	lm3533_disable(lm3533);
+	if (gpio_is_valid(lm3533->gpio_hwen))
+		gpio_free(lm3533->gpio_hwen);
+}
+
+MODULE_AUTHOR("Johan Hovold <jhovold@gmail.com>");
+MODULE_DESCRIPTION("LM3533 Core");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/lm3533-ctrlbank.c b/drivers/mfd/lm3533-ctrlbank.c
new file mode 100644
index 0000000..2feb4e8
--- /dev/null
+++ b/drivers/mfd/lm3533-ctrlbank.c
@@ -0,0 +1,134 @@
+/*
+ * lm3533-ctrlbank.c -- LM3533 Generic Control Bank interface
+ *
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * Author: Johan Hovold <jhovold@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+#define LM3533_BRIGHTNESS_MAX		255
+#define LM3533_MAX_CURRENT_MAX		31
+#define LM3533_PWM_MAX			0x3f
+
+#define LM3533_REG_PWM_BASE		0x14
+#define LM3533_REG_MAX_CURRENT_BASE	0x1f
+#define LM3533_REG_CTRLBANK_ENABLE	0x27
+#define LM3533_REG_BRIGHTNESS_BASE	0x40
+
+
+static inline u8 lm3533_ctrlbank_get_reg(struct lm3533_ctrlbank *cb, u8 base)
+{
+	return base + cb->id;
+}
+
+int lm3533_ctrlbank_enable(struct lm3533_ctrlbank *cb)
+{
+	u8 mask;
+	int ret;
+
+	dev_dbg(cb->dev, "%s - %d\n", __func__, cb->id);
+
+	mask = 1 << cb->id;
+	ret = lm3533_update(cb->lm3533, LM3533_REG_CTRLBANK_ENABLE,
+								mask, mask);
+	if (ret)
+		dev_err(cb->dev, "failed to enable ctrlbank %d\n", cb->id);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lm3533_ctrlbank_enable);
+
+int lm3533_ctrlbank_disable(struct lm3533_ctrlbank *cb)
+{
+	u8 mask;
+	int ret;
+
+	dev_dbg(cb->dev, "%s - %d\n", __func__, cb->id);
+
+	mask = 1 << cb->id;
+	ret = lm3533_update(cb->lm3533, LM3533_REG_CTRLBANK_ENABLE, 0, mask);
+	if (ret)
+		dev_err(cb->dev, "failed to disable ctrlbank %d\n", cb->id);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lm3533_ctrlbank_disable);
+
+#define lm3533_ctrlbank_set(_name, _NAME)				\
+int lm3533_ctrlbank_set_##_name(struct lm3533_ctrlbank *cb, u8 val)	\
+{									\
+	u8 reg;								\
+	int ret;							\
+									\
+	if (val > LM3533_##_NAME##_MAX)					\
+		return -EINVAL;						\
+									\
+	reg = lm3533_ctrlbank_get_reg(cb, LM3533_REG_##_NAME##_BASE);	\
+	ret = lm3533_write(cb->lm3533, reg, val);			\
+	if (ret)							\
+		dev_err(cb->dev, "failed to set " #_name "\n");		\
+									\
+	return ret;							\
+}									\
+EXPORT_SYMBOL_GPL(lm3533_ctrlbank_set_##_name);
+
+#define lm3533_ctrlbank_get(_name, _NAME)				\
+int lm3533_ctrlbank_get_##_name(struct lm3533_ctrlbank *cb, u8 *val)	\
+{									\
+	u8 reg;								\
+	int ret;							\
+									\
+	reg = lm3533_ctrlbank_get_reg(cb, LM3533_REG_##_NAME##_BASE);	\
+	ret = lm3533_read(cb->lm3533, reg, val);			\
+	if (ret)							\
+		dev_err(cb->dev, "failed to get " #_name "\n");		\
+									\
+	return ret;							\
+}									\
+EXPORT_SYMBOL_GPL(lm3533_ctrlbank_get_##_name);
+
+lm3533_ctrlbank_set(brightness, BRIGHTNESS);
+lm3533_ctrlbank_get(brightness, BRIGHTNESS);
+
+/*
+ * Full scale current.
+ *
+ * Imax = 5 + val * 0.8 mA, e.g.:
+ *
+ *    0 - 5 mA
+ *     ...
+ *   19 - 20.2 mA (default)
+ *     ...
+ *   31 - 29.8 mA
+ */
+lm3533_ctrlbank_set(max_current, MAX_CURRENT);
+lm3533_ctrlbank_get(max_current, MAX_CURRENT);
+
+/*
+ * PWM control:
+ *
+ *   bit 5 - PWM enabled in Zone 4
+ *   bit 4 - PWM enabled in Zone 3
+ *   bit 3 - PWM enabled in Zone 2
+ *   bit 2 - PWM enabled in Zone 1
+ *   bit 1 - PWM enabled in Zone 0
+ *   bit 0 - PWM enabled
+ */
+lm3533_ctrlbank_set(pwm, PWM);
+lm3533_ctrlbank_get(pwm, PWM);
+
+
+MODULE_AUTHOR("Johan Hovold <jhovold@gmail.com>");
+MODULE_DESCRIPTION("LM3533 Control Bank interface");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/lm3533-i2c.c b/drivers/mfd/lm3533-i2c.c
new file mode 100644
index 0000000..d479b62
--- /dev/null
+++ b/drivers/mfd/lm3533-i2c.c
@@ -0,0 +1,115 @@
+/*
+ * lm3533-i2c.c -- LM3533 I2C interface
+ *
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * Author: Johan Hovold <jhovold@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+static int lm3533_i2c_read(struct lm3533 *lm3533, u8 reg, u8 *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(lm3533->i2c, reg);
+	if (ret < 0)
+		return ret;
+
+	*val = (u8)ret;
+
+	return 0;
+}
+
+static int lm3533_i2c_write(struct lm3533 *lm3533, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(lm3533->i2c, reg, val);
+}
+
+static int __devinit lm3533_i2c_probe(struct i2c_client *i2c,
+					const struct i2c_device_id *id)
+{
+	struct lm3533 *lm3533;
+	int ret;
+
+	dev_dbg(&i2c->dev, "%s\n", __func__);
+
+	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EINVAL;
+
+	lm3533 = kzalloc(sizeof(*lm3533), GFP_KERNEL);
+	if (!lm3533)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, lm3533);
+
+	lm3533->dev = &i2c->dev;
+	lm3533->i2c = i2c;
+	lm3533->irq = i2c->irq;
+	lm3533->read = lm3533_i2c_read;
+	lm3533->write = lm3533_i2c_write;
+
+	ret = lm3533_device_init(lm3533);
+	if (ret) {
+		kfree(lm3533);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit lm3533_i2c_remove(struct i2c_client *i2c)
+{
+	struct lm3533 *lm3533 = i2c_get_clientdata(i2c);
+
+	dev_dbg(&i2c->dev, "%s\n", __func__);
+
+	lm3533_device_exit(lm3533);
+
+	kfree(lm3533);
+
+	return 0;
+}
+
+static const struct i2c_device_id lm3533_i2c_ids[] = {
+	{ "lm3533", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, lm3533_i2c_ids);
+
+static struct i2c_driver lm3533_i2c_driver = {
+	.driver = {
+		   .name = "lm3533",
+		   .owner = THIS_MODULE,
+	},
+	.id_table	= lm3533_i2c_ids,
+	.probe		= lm3533_i2c_probe,
+	.remove		= __devexit_p(lm3533_i2c_remove),
+};
+
+static int __init lm3533_i2c_init(void)
+{
+	return i2c_add_driver(&lm3533_i2c_driver);
+}
+subsys_initcall(lm3533_i2c_init);
+
+static void __exit lm3533_i2c_exit(void)
+{
+	i2c_del_driver(&lm3533_i2c_driver);
+}
+module_exit(lm3533_i2c_exit);
+
+MODULE_AUTHOR("Johan Hovold <jhovold@gmail.com>");
+MODULE_DESCRIPTION("LM3533 I2C interface");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/lm3533.h b/include/linux/mfd/lm3533.h
new file mode 100644
index 0000000..cb8bf33
--- /dev/null
+++ b/include/linux/mfd/lm3533.h
@@ -0,0 +1,106 @@
+/*
+ * lm3533.h -- LM3533 interface
+ *
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * Author: Johan Hovold <jhovold@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_LM3533_H
+#define __LINUX_MFD_LM3533_H
+
+#include <linux/mutex.h>
+
+
+#define LM3533_ATTR_RO(_name) \
+	DEVICE_ATTR(_name, S_IRUGO, show_##_name, NULL)
+#define LM3533_ATTR_RW(_name) \
+	DEVICE_ATTR(_name, S_IRUGO | S_IWUSR , show_##_name, store_##_name)
+
+struct device;
+struct dentry;
+struct i2c_client;
+
+struct lm3533 {
+	struct device *dev;
+	struct i2c_client *i2c;
+
+	struct mutex io_mutex;
+
+	int (*read)(struct lm3533 *lm3533, u8 reg, u8 *val);
+	int (*write)(struct lm3533 *lm3533, u8 reg, u8 val);
+
+	int gpio_hwen;
+	int irq;
+
+	unsigned have_als:1;
+	unsigned have_backlights:1;
+	unsigned have_leds:1;
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_root;
+#endif
+};
+
+struct lm3533_ctrlbank {
+	struct lm3533 *lm3533;
+	struct device *dev;
+	int id;
+};
+
+struct lm3533_als_platform_data {
+	unsigned pwm_mode:1;		/* PWM input mode (default analog) */
+	unsigned int_mode:1;		/* interrupt mode (default polled) */
+	unsigned poll_interval;		/* in polled mode (in ms) */
+};
+
+struct lm3533_bl_platform_data {
+	char *name;
+	u8 default_brightness;		/* 0 - 255 */
+	u8 max_current;			/* 0 - 31 */
+	u8 pwm;				/* 0 - 0x3f */
+};
+
+struct lm3533_led_platform_data {
+	char *name;
+	const char *default_trigger;
+	u8 max_current;			/* 0 - 31 */
+	u8 pwm;				/* 0 - 0x3f */
+};
+
+struct lm3533_platform_data {
+	int gpio_hwen;
+
+	struct lm3533_als_platform_data *als;
+
+	struct lm3533_bl_platform_data *backlights;
+	int num_backlights;
+
+	struct lm3533_led_platform_data *leds;
+	int num_leds;
+};
+
+extern int lm3533_ctrlbank_enable(struct lm3533_ctrlbank *cb);
+extern int lm3533_ctrlbank_disable(struct lm3533_ctrlbank *cb);
+
+extern int lm3533_ctrlbank_set_brightness(struct lm3533_ctrlbank *cb, u8 val);
+extern int lm3533_ctrlbank_get_brightness(struct lm3533_ctrlbank *cb, u8 *val);
+extern int lm3533_ctrlbank_set_max_current(struct lm3533_ctrlbank *cb, u8 val);
+extern int lm3533_ctrlbank_get_max_current(struct lm3533_ctrlbank *cb,
+								u8 *val);
+extern int lm3533_ctrlbank_set_pwm(struct lm3533_ctrlbank *cb, u8 val);
+extern int lm3533_ctrlbank_get_pwm(struct lm3533_ctrlbank *cb, u8 *val);
+
+extern int lm3533_read(struct lm3533 *lm3533, u8 reg, u8 *val);
+extern int lm3533_write(struct lm3533 *lm3533, u8 reg, u8 val);
+extern int lm3533_update(struct lm3533 *lm3533, u8 reg, u8 val, u8 mask);
+
+extern int __devinit lm3533_device_init(struct lm3533 *lm3533);
+extern void __devinit lm3533_device_exit(struct lm3533 *lm3533);
+
+#endif	/* __LINUX_MFD_LM3533_H */
-- 
1.7.8.5

