Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2DTPbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:31:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35498 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab2DTPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:30:58 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/4] misc: add LM3533 ambient light sensor driver
Date: Fri, 20 Apr 2012 17:30:24 +0200
Message-Id: <1334935826-12527-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sub-driver for the ambient light sensor in National Semiconductor /
TI LM3533 lighting power chips.

Raw ADC values as well as current ALS zone can be retrieved through
sysfs. The ALS zone can also be read using a character device
(/dev/lm3533-als) which is updated on zone changes (interrupt driven or
polled).

The driver provides a configuration interface through sysfs.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/misc/Kconfig      |   13 +
 drivers/misc/Makefile     |    1 +
 drivers/misc/lm3533-als.c |  662 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 676 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/lm3533-als.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..cc8cbf0 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -314,6 +314,19 @@ config APDS9802ALS
 	  This driver can also be built as a module.  If so, the module
 	  will be called apds9802als.
 
+config ALS_LM3533
+	tristate "LM3533 Ambient Light Sensor"
+	depends on MFD_LM3533
+	help
+	  If you say yes here you get support for the ambient light sensor on
+	  National Semiconductor / TI LM3533 Lighting Power chips.
+
+	  The sensor can be used to control the LEDs and backlights of the chip
+	  through defining five light zones and three sets of corresponding
+	  brightness target levels. The driver presents a character device
+	  (/dev/lm3533-als) which can be used to retrieve the current light
+	  zone or to poll for zone changes.
+
 config ISL29003
 	tristate "Intersil ISL29003 ambient light sensor"
 	depends on I2C && SYSFS
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3e1d8010..122a168 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_CS5535_MFGPT)	+= cs5535-mfgpt.o
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_APDS9802ALS)	+= apds9802als.o
+obj-$(CONFIG_ALS_LM3533)	+= lm3533-als.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_ISL29020)		+= isl29020.o
 obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
diff --git a/drivers/misc/lm3533-als.c b/drivers/misc/lm3533-als.c
new file mode 100644
index 0000000..0348c6d
--- /dev/null
+++ b/drivers/misc/lm3533-als.c
@@ -0,0 +1,662 @@
+/*
+ * lm3533-als.c -- LM3533 Ambient Light Sensor driver
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
+#include <linux/atomic.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+/* Default poll intervall for zone changes in polled mode in ms. */
+#define LM3533_ALS_POLL_INTERVAL		1000
+
+#define LM3533_ALS_RESISTOR_MAX			0x7f
+#define LM3533_ALS_BOUNDARY_MAX			0xff
+#define LM3533_ALS_TARGET_MAX			0xff
+#define LM3533_ALS_ZONE_MAX			4
+
+#define LM3533_REG_ALS_RESISTOR_SELECT		0x30
+#define LM3533_REG_ALS_CONF			0x31
+#define LM3533_REG_ALS_ZONE_INFO		0x34
+#define LM3533_REG_ALS_READ_ADC_AVERAGE		0x37
+#define LM3533_REG_ALS_READ_ADC_RAW		0x38
+#define LM3533_REG_ALS_BOUNDARY0_HIGH		0x50
+#define LM3533_REG_ALS_BOUNDARY0_LOW		0x51
+#define LM3533_REG_ALS_BOUNDARY1_HIGH		0x52
+#define LM3533_REG_ALS_BOUNDARY1_LOW		0x53
+#define LM3533_REG_ALS_BOUNDARY2_HIGH		0x54
+#define LM3533_REG_ALS_BOUNDARY2_LOW		0x55
+#define LM3533_REG_ALS_BOUNDARY3_HIGH		0x56
+#define LM3533_REG_ALS_BOUNDARY3_LOW		0x57
+#define LM3533_REG_ALS_M1_TARGET_0		0x60
+#define LM3533_REG_ALS_M1_TARGET_1		0x61
+#define LM3533_REG_ALS_M1_TARGET_2		0x62
+#define LM3533_REG_ALS_M1_TARGET_3		0x63
+#define LM3533_REG_ALS_M1_TARGET_4		0x64
+#define LM3533_REG_ALS_M2_TARGET_0		0x65
+#define LM3533_REG_ALS_M2_TARGET_1		0x66
+#define LM3533_REG_ALS_M2_TARGET_2		0x67
+#define LM3533_REG_ALS_M2_TARGET_3		0x68
+#define LM3533_REG_ALS_M2_TARGET_4		0x69
+#define LM3533_REG_ALS_M3_TARGET_0		0x6a
+#define LM3533_REG_ALS_M3_TARGET_1		0x6b
+#define LM3533_REG_ALS_M3_TARGET_2		0x6c
+#define LM3533_REG_ALS_M3_TARGET_3		0x6d
+#define LM3533_REG_ALS_M3_TARGET_4		0x6e
+
+#define LM3533_ALS_ENABLE_MASK			0x01
+#define LM3533_ALS_INPUT_MODE_MASK		0x02
+#define LM3533_ALS_INT_ENABLE_MASK		0x01
+
+#define LM3533_ALS_ZONE_SHIFT			2
+#define LM3533_ALS_ZONE_MASK			0x1c
+
+#define LM3533_ALS_FLAG_ZONE_CHANGED		1
+
+
+struct lm3533_als {
+	struct lm3533 *lm3533;
+	struct miscdevice cdev;
+
+	int irq;
+
+	atomic_t open_ref;
+
+	unsigned long poll_interval;
+	struct delayed_work dwork;
+
+	wait_queue_head_t read_wait;
+
+	struct mutex mutex;
+	unsigned long flags;
+	u8 zone;
+};
+
+#define to_lm3533_als(_cdev) \
+	container_of(_cdev, struct lm3533_als, cdev)
+
+
+static int lm3533_als_get_zone(struct lm3533_als *als, u8 *zone)
+{
+	u8 val;
+	int ret;
+
+	ret = lm3533_read(als->lm3533, LM3533_REG_ALS_ZONE_INFO, &val);
+	if (ret) {
+		dev_err(als->cdev.this_device, "failed to read zone\n");
+		return ret;
+	}
+
+	*zone = (val & LM3533_ALS_ZONE_MASK) >> LM3533_ALS_ZONE_SHIFT;
+	*zone = min_t(u8, *zone, LM3533_ALS_ZONE_MAX);
+
+	return 0;
+}
+
+static void lm3533_als_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct lm3533_als *als = container_of(dwork, struct lm3533_als, dwork);
+	u8 zone;
+	int ret;
+
+	ret = lm3533_als_get_zone(als, &zone);
+	if (ret)
+		goto out;
+
+	mutex_lock(&als->mutex);
+	if (als->zone != zone) {
+		als->zone = zone;
+		set_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags);
+	}
+	mutex_unlock(&als->mutex);
+
+	if (test_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags))
+		wake_up_interruptible(&als->read_wait);
+out:
+	if (als->irq < 0)
+		schedule_delayed_work(dwork, als->poll_interval);
+}
+
+static irqreturn_t lm3533_als_isr(int irq, void *dev_id)
+{
+	struct lm3533_als *als = dev_id;
+	u8 zone;
+	int ret;
+
+	ret = lm3533_als_get_zone(als, &zone);
+	if (ret)
+		goto out;
+
+	mutex_lock(&als->mutex);
+	als->zone = zone;
+	set_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags);
+	mutex_unlock(&als->mutex);
+
+	wake_up_interruptible(&als->read_wait);
+out:
+	return IRQ_HANDLED;
+}
+
+static int lm3533_als_set_int_mode(struct lm3533_als *als, int enable)
+{
+	u8 mask = LM3533_ALS_INT_ENABLE_MASK;
+	u8 val;
+
+	if (enable)
+		val = mask;
+	else
+		val = 0;
+
+	return lm3533_update(als->lm3533, LM3533_REG_ALS_ZONE_INFO, val, mask);
+}
+
+static int lm3533_als_int_enable(struct lm3533_als *als)
+{
+	int ret;
+
+	dev_dbg(als->cdev.this_device, "%s\n", __func__);
+
+	ret = lm3533_als_set_int_mode(als, 1);
+	if (ret) {
+		dev_warn(als->cdev.this_device, "could not enable int mode\n");
+		goto err;
+	}
+
+	ret = request_threaded_irq(als->irq, NULL, lm3533_als_isr,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					als->cdev.name, als);
+	if (ret) {
+		dev_warn(als->cdev.this_device, "could not get irq %d\n",
+								als->irq);
+		goto err;
+	}
+
+	return ret;
+err:
+	als->irq = -EINVAL;
+
+	return ret;
+}
+
+static int lm3533_als_int_disable(struct lm3533_als *als)
+{
+	int ret;
+
+	dev_dbg(als->cdev.this_device, "%s\n", __func__);
+
+	free_irq(als->irq, als);
+
+	ret = lm3533_als_set_int_mode(als, 0);
+	if (ret) {
+		dev_warn(als->cdev.this_device,
+					"could not disable int mode\n");
+	}
+
+	return ret;
+}
+
+static int lm3533_als_open(struct inode *inode, struct file *file)
+{
+	struct lm3533_als *als = to_lm3533_als(file->private_data);
+
+	dev_dbg(als->cdev.this_device, "%s\n", __func__);
+
+	file->private_data = als;
+
+	if (atomic_inc_return(&als->open_ref) != 1)
+		goto out;
+
+	/* Enable interrupt mode if requested, but fall back to polled mode on
+	 * errors.
+	 */
+	if (als->irq >= 0)
+		lm3533_als_int_enable(als);
+
+	/* Make sure first read returns current zone. */
+	mutex_lock(&als->mutex);
+	clear_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags);
+	als->zone = (u8)-1;
+	mutex_unlock(&als->mutex);
+
+	schedule_delayed_work(&als->dwork, 0);
+out:
+	return nonseekable_open(inode, file);
+}
+
+static int lm3533_als_release(struct inode *inode, struct file *file)
+{
+	struct lm3533_als *als = file->private_data;
+
+	dev_dbg(als->cdev.this_device, "%s\n", __func__);
+
+	if (atomic_dec_return(&als->open_ref))
+		return 0;
+
+	if (als->irq >= 0)
+		lm3533_als_int_disable(als);
+
+	cancel_delayed_work_sync(&als->dwork);
+
+	return 0;
+}
+
+static unsigned int lm3533_als_poll(struct file *file,
+						struct poll_table_struct *pt)
+{
+	struct lm3533_als *als = file->private_data;
+	unsigned mask = 0;
+
+	poll_wait(file, &als->read_wait, pt);
+
+	if (test_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static ssize_t lm3533_als_read(struct file *file, char __user *buf,
+						size_t count, loff_t *f_pos)
+{
+	struct lm3533_als *als = file->private_data;
+	int ret;
+
+	dev_dbg(als->cdev.this_device, "%s\n", __func__);
+
+	if (!count)
+		return 0;
+
+	mutex_lock(&als->mutex);
+	while (!test_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags)) {
+		mutex_unlock(&als->mutex);
+
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		ret = wait_event_interruptible(als->read_wait,
+					test_bit(LM3533_ALS_FLAG_ZONE_CHANGED,
+								&als->flags));
+		if (ret)
+			return -ERESTARTSYS;
+
+		mutex_lock(&als->mutex);
+	}
+
+	count = min(count, sizeof(als->zone));
+	if (copy_to_user(buf, &als->zone, count)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	*f_pos += count;
+	ret = count;
+
+	clear_bit(LM3533_ALS_FLAG_ZONE_CHANGED, &als->flags);
+out:
+	mutex_unlock(&als->mutex);
+
+	return ret;
+}
+
+static const struct file_operations lm3533_als_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= lm3533_als_open,
+	.release	= lm3533_als_release,
+	.poll		= lm3533_als_poll,
+	.read		= lm3533_als_read,
+};
+
+struct lm3533_device_attribute {
+	struct device_attribute dev_attr;
+	u8 reg;
+	u8 max;
+};
+
+#define to_lm3533_dev_attr(_dev_attr) \
+	container_of(_dev_attr, struct lm3533_device_attribute, dev_attr)
+
+static ssize_t show_zone(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct miscdevice *cdev = dev_get_drvdata(dev);
+	struct lm3533_als *als = to_lm3533_als(cdev);
+	u8 zone;
+	int ret;
+
+	ret = lm3533_als_get_zone(als, &zone);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", zone);
+}
+
+static ssize_t show_lm3533_als_reg(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct miscdevice *cdev = dev_get_drvdata(dev);
+	struct lm3533_als *als = to_lm3533_als(cdev);
+	struct lm3533_device_attribute *lm3533_attr = to_lm3533_dev_attr(attr);
+	u8 val;
+	int ret;
+
+	ret = lm3533_read(als->lm3533, lm3533_attr->reg, &val);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t store_lm3533_als_reg(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct miscdevice *cdev = dev_get_drvdata(dev);
+	struct lm3533_als *als = to_lm3533_als(cdev);
+	struct lm3533_device_attribute *lm3533_attr = to_lm3533_dev_attr(attr);
+	u8 val;
+	int ret;
+
+	if (kstrtou8(buf, 0, &val) || val > lm3533_attr->max)
+		return -EINVAL;
+
+	ret = lm3533_write(als->lm3533, lm3533_attr->reg, val);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+#define REG_ATTR(_name, _mode, _show, _store, _reg, _max) \
+	{ .dev_attr = __ATTR(_name, _mode, _show, _store), \
+	  .reg = _reg, \
+	  .max = _max }
+
+#define LM3533_REG_ATTR(_name, _mode, _show, _store, _reg, _max) \
+	struct lm3533_device_attribute lm3533_dev_attr_##_name \
+		= REG_ATTR(_name, _mode, _show, _store, _reg, _max)
+
+#define LM3533_REG_ATTR_RO(_name, _reg) \
+	LM3533_REG_ATTR(_name, S_IRUGO, show_lm3533_als_reg, NULL, _reg, 0)
+#define LM3533_REG_ATTR_RW(_name, _reg, _max) \
+	LM3533_REG_ATTR(_name, S_IRUGO | S_IWUSR, show_lm3533_als_reg, \
+					store_lm3533_als_reg, _reg, _max)
+
+#define ALS_BOUNDARY_LOW_ATTR_RW(_nr) \
+	LM3533_REG_ATTR_RW(boundary##_nr##_low, \
+		LM3533_REG_ALS_BOUNDARY##_nr##_LOW, LM3533_ALS_BOUNDARY_MAX)
+
+#define ALS_BOUNDARY_HIGH_ATTR_RW(_nr) \
+	LM3533_REG_ATTR_RW(boundary##_nr##_high, \
+		LM3533_REG_ALS_BOUNDARY##_nr##_HIGH, LM3533_ALS_BOUNDARY_MAX)
+
+/* ALS Zone boundaries
+ *
+ * boundary[0-3]_low	0-255
+ * boundary[0-3]_high	0-255
+ */
+static ALS_BOUNDARY_LOW_ATTR_RW(0);
+static ALS_BOUNDARY_LOW_ATTR_RW(1);
+static ALS_BOUNDARY_LOW_ATTR_RW(2);
+static ALS_BOUNDARY_LOW_ATTR_RW(3);
+
+static ALS_BOUNDARY_HIGH_ATTR_RW(0);
+static ALS_BOUNDARY_HIGH_ATTR_RW(1);
+static ALS_BOUNDARY_HIGH_ATTR_RW(2);
+static ALS_BOUNDARY_HIGH_ATTR_RW(3);
+
+#define ALS_TARGET_ATTR_RW(_mapper, _nr) \
+	LM3533_REG_ATTR_RW(target##_mapper##_##_nr, \
+		LM3533_REG_ALS_M##_mapper##_TARGET_##_nr, LM3533_ALS_TARGET_MAX)
+
+/* ALS Mapper targets
+ *
+ * target[1-3]_[0-4]		0-255
+ */
+static ALS_TARGET_ATTR_RW(1, 0);
+static ALS_TARGET_ATTR_RW(1, 1);
+static ALS_TARGET_ATTR_RW(1, 2);
+static ALS_TARGET_ATTR_RW(1, 3);
+static ALS_TARGET_ATTR_RW(1, 4);
+
+static ALS_TARGET_ATTR_RW(2, 0);
+static ALS_TARGET_ATTR_RW(2, 1);
+static ALS_TARGET_ATTR_RW(2, 2);
+static ALS_TARGET_ATTR_RW(2, 3);
+static ALS_TARGET_ATTR_RW(2, 4);
+
+static ALS_TARGET_ATTR_RW(3, 0);
+static ALS_TARGET_ATTR_RW(3, 1);
+static ALS_TARGET_ATTR_RW(3, 2);
+static ALS_TARGET_ATTR_RW(3, 3);
+static ALS_TARGET_ATTR_RW(3, 4);
+
+/* ALS ADC
+ *
+ * adc_average	0-255
+ * adc_raw	0-255
+ */
+static LM3533_REG_ATTR_RO(adc_average, LM3533_REG_ALS_READ_ADC_AVERAGE);
+static LM3533_REG_ATTR_RO(adc_raw, LM3533_REG_ALS_READ_ADC_RAW);
+
+/* ALS Gain resistor setting
+ *
+ * gain		0-31
+ */
+static LM3533_REG_ATTR_RW(gain, LM3533_REG_ALS_RESISTOR_SELECT,
+						LM3533_ALS_RESISTOR_MAX);
+/* ALS Current Zone
+ *
+ * zone		0-4
+ */
+static LM3533_ATTR_RO(zone);
+
+static struct attribute *lm3533_als_attributes[] = {
+	&lm3533_dev_attr_adc_average.dev_attr.attr,
+	&lm3533_dev_attr_adc_raw.dev_attr.attr,
+	&lm3533_dev_attr_boundary0_high.dev_attr.attr,
+	&lm3533_dev_attr_boundary0_low.dev_attr.attr,
+	&lm3533_dev_attr_boundary1_high.dev_attr.attr,
+	&lm3533_dev_attr_boundary1_low.dev_attr.attr,
+	&lm3533_dev_attr_boundary2_high.dev_attr.attr,
+	&lm3533_dev_attr_boundary2_low.dev_attr.attr,
+	&lm3533_dev_attr_boundary3_high.dev_attr.attr,
+	&lm3533_dev_attr_boundary3_low.dev_attr.attr,
+	&lm3533_dev_attr_target1_0.dev_attr.attr,
+	&lm3533_dev_attr_target1_1.dev_attr.attr,
+	&lm3533_dev_attr_target1_2.dev_attr.attr,
+	&lm3533_dev_attr_target1_3.dev_attr.attr,
+	&lm3533_dev_attr_target1_4.dev_attr.attr,
+	&lm3533_dev_attr_target2_0.dev_attr.attr,
+	&lm3533_dev_attr_target2_1.dev_attr.attr,
+	&lm3533_dev_attr_target2_2.dev_attr.attr,
+	&lm3533_dev_attr_target2_3.dev_attr.attr,
+	&lm3533_dev_attr_target2_4.dev_attr.attr,
+	&lm3533_dev_attr_target3_0.dev_attr.attr,
+	&lm3533_dev_attr_target3_1.dev_attr.attr,
+	&lm3533_dev_attr_target3_2.dev_attr.attr,
+	&lm3533_dev_attr_target3_3.dev_attr.attr,
+	&lm3533_dev_attr_target3_4.dev_attr.attr,
+	&lm3533_dev_attr_gain.dev_attr.attr,
+	&dev_attr_zone.attr,
+	NULL,
+};
+
+static struct attribute_group lm3533_als_attribute_group = {
+	.attrs = lm3533_als_attributes
+};
+
+static int __devinit lm3533_als_set_input_mode(struct lm3533 *lm3533,
+								int pwm_mode)
+{
+	u8 mask = LM3533_ALS_INPUT_MODE_MASK;
+	u8 val;
+	int ret;
+
+	if (pwm_mode)
+		val = mask;	/* pwm input */
+	else
+		val = 0;	/* analog input */
+
+	ret = lm3533_update(lm3533, LM3533_REG_ALS_CONF, mask, mask);
+	if (ret) {
+		dev_err(lm3533->dev,
+				"failed to set input mode %d\n", pwm_mode);
+	}
+
+	return ret;
+}
+
+static int __devinit lm3533_als_enable(struct lm3533 *lm3533)
+{
+	u8 mask = LM3533_ALS_ENABLE_MASK;
+	int ret;
+
+	ret = lm3533_update(lm3533, LM3533_REG_ALS_CONF, mask, mask);
+	if (ret)
+		dev_err(lm3533->dev, "failed to enable ALS\n");
+
+	return ret;
+}
+
+static int lm3533_als_disable(struct lm3533 *lm3533)
+{
+	u8 mask = LM3533_ALS_ENABLE_MASK;
+	int ret;
+
+	ret = lm3533_update(lm3533, LM3533_REG_ALS_CONF, 0, mask);
+	if (ret)
+		dev_err(lm3533->dev, "failed to disable ALS\n");
+
+	return ret;
+}
+
+static int __devinit lm3533_als_probe(struct platform_device *pdev)
+{
+	struct lm3533 *lm3533;
+	struct lm3533_als_platform_data *pdata;
+	struct lm3533_als *als;
+	int ret;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533 = dev_get_drvdata(pdev->dev.parent);
+	if (!lm3533)
+		return -EINVAL;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	als = kzalloc(sizeof(*als), GFP_KERNEL);
+	if (!als)
+		return -ENOMEM;
+
+	als->lm3533 = lm3533;
+	if (pdata->int_mode)
+		als->irq = lm3533->irq;
+	else
+		als->irq = -EINVAL;
+
+	if (!pdata->poll_interval)
+		pdata->poll_interval = LM3533_ALS_POLL_INTERVAL;
+	als->poll_interval = msecs_to_jiffies(pdata->poll_interval);
+
+	als->cdev.name = "lm3533-als";
+	als->cdev.parent = pdev->dev.parent;
+	als->cdev.minor = MISC_DYNAMIC_MINOR;
+	als->cdev.fops = &lm3533_als_fops;
+
+	mutex_init(&als->mutex);
+	INIT_DELAYED_WORK(&als->dwork, lm3533_als_work);
+	init_waitqueue_head(&als->read_wait);
+
+	platform_set_drvdata(pdev, als);
+
+	ret = lm3533_als_set_input_mode(lm3533, pdata->pwm_mode);
+	if (ret)
+		goto err;
+
+	ret = lm3533_als_enable(lm3533);
+	if (ret)
+		goto err;
+
+	ret = misc_register(&als->cdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register ALS\n");
+		goto err_disable;
+	}
+
+	ret = sysfs_create_group(&als->cdev.this_device->kobj,
+						&lm3533_als_attribute_group);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to create sysfs attributes\n");
+		goto err_unregister;
+	}
+
+	return 0;
+
+err_unregister:
+	misc_deregister(&als->cdev);
+err_disable:
+	lm3533_als_disable(lm3533);
+err:
+	kfree(als);
+
+	return ret;
+}
+
+static int __devexit lm3533_als_remove(struct platform_device *pdev)
+{
+	struct lm3533_als *als = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	sysfs_remove_group(&als->cdev.this_device->kobj,
+						&lm3533_als_attribute_group);
+	misc_deregister(&als->cdev);
+	lm3533_als_disable(als->lm3533);
+	kfree(als);
+
+	return 0;
+}
+
+static struct platform_driver lm3533_als_driver = {
+	.driver = {
+		.name = "lm3533-als",
+		.owner = THIS_MODULE,
+	},
+	.probe		= lm3533_als_probe,
+	.remove		= __devexit_p(lm3533_als_remove),
+};
+module_platform_driver(lm3533_als_driver);
+
+MODULE_AUTHOR("Johan Hovold <jhovold@gmail.com>");
+MODULE_DESCRIPTION("LM3533 Ambient Light Sensor driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lm3533-als");
-- 
1.7.8.5

