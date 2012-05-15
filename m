Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab2EOQq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:46:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48555 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2EOQqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:46:55 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3] iio: add LM3533 ambient-light-sensor driver
Date: Tue, 15 May 2012 18:46:36 +0200
Message-Id: <1337100396-29024-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1336040799-18433-3-git-send-email-jhovold@gmail.com>
References: <1336040799-18433-3-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sub-driver for the ambient-light-sensor interface on National
Semiconductor / TI LM3533 lighting power chips.

The sensor interface can be used to control the LEDs and backlights of
the chip through defining five light zones and three sets of
corresponding brightness target levels.

The driver provides raw and mean adc readings along with the current
light zone through sysfs. A threshold event can be generated on zone
changes.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

This is a v3 rebased against staging-next of today (93c66ee1186a). Note
that I added calibscale to the platform data and that the modification
of the header file probably needs to go in via mfd once we have agreed
on the type.

Thanks,
Johan


v2:
 - reimplement using iio
 - add sysfs-ABI documentation
v3
 - use indexed channel
 - fix sysfs-ABI documentation typo and style
 - replace gain attribute with in_illuminance0_calibscale
 - add calibscale to platform data
 - fix adc register definitions
 - replace to_lm3533_dev_attr macro with inline function
 - fix device used for error reporting at irq allocation
 - use iio device for error reporting during setup/enable
 - rebase on staging-next
   - fix header include paths
   - use dev_to_iio_dev
   - add IIO_CHAN_INFO_RAW to info mask
   - use iio_device_{alloc,free}


 .../Documentation/sysfs-bus-iio-light-lm3533-als   |   52 ++
 drivers/staging/iio/light/Kconfig                  |   16 +
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/lm3533-als.c             |  726 ++++++++++++++++++++
 include/linux/mfd/lm3533.h                         |    3 +
 5 files changed, 798 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
 create mode 100644 drivers/staging/iio/light/lm3533-als.c

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
new file mode 100644
index 0000000..ba31538
--- /dev/null
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
@@ -0,0 +1,52 @@
+What:		/sys/bus/iio/devices/iio:deviceX/in_illuminance0_calibscale
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the ALS calibration scale (internal resistors) for
+		analog input mode, where the scale factor is the current in uA
+		at 2V full-scale (10..1270, 10uA step), that is,
+
+		R_als = 2V / in_illuminance0_calibscale
+
+		This setting is ignored in PWM mode.
+
+What:		/sys/.../events/in_illuminance0_thresh_either_en
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Event generated when channel passes one of the four thresholds
+		in each direction (rising|falling) and a zone change occurs.
+		The corresponding light zone can be read from
+		in_illuminance0_zone.
+
+What:		/sys/.../events/illuminance_threshY_falling_value
+What:		/sys/.../events/illuminance_threshY_raising_value
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Specifies the value of threshold that the device is
+		comparing against for the events enabled by
+		in_illuminance0_thresh_either_en, where Y in 0..3.
+
+		These thresholds correspond to the eight zone-boundary
+		registers (boundaryY_{low,high}) and defines the five light
+		zones.
+
+What:		/sys/bus/iio/devices/iio:deviceX/in_illuminance0_zone
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Get the current light zone (0..4) as defined by the
+		in_illuminance0_threshY_{falling,rising} thresholds.
+
+What:		/sys/bus/iio/devices/iio:deviceX/targetY_Z
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the target brightness for ALS-mapper Y in light zone Z
+		(0..255), where Y in 1..3 and Z in 0..4.
diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index 4bed30e..2170124 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -35,6 +35,22 @@ config SENSORS_TSL2563
 	 This driver can also be built as a module.  If so, the module
 	 will be called tsl2563.
 
+config SENSORS_LM3533
+	tristate "LM3533 ambient light sensor"
+	depends on MFD_LM3533
+	help
+	  If you say yes here you get support for the ambient light sensor
+	  interface on National Semiconductor / TI LM3533 Lighting Power
+	  chips.
+
+	  The sensor interface can be used to control the LEDs and backlights
+	  of the chip through defining five light zones and three sets of
+	  corresponding brightness target levels.
+
+	  The driver provides raw and mean adc readings along with the current
+	  light zone through sysfs. A threshold event can be generated on zone
+	  changes.
+
 config TSL2583
 	tristate "TAOS TSL2580, TSL2581 and TSL2583 light-to-digital converters"
 	depends on I2C
diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
index 141af1e..a8c6144 100644
--- a/drivers/staging/iio/light/Makefile
+++ b/drivers/staging/iio/light/Makefile
@@ -5,5 +5,6 @@
 obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
 obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
 obj-$(CONFIG_SENSORS_ISL29028)	+= isl29028.o
+obj-$(CONFIG_SENSORS_LM3533)	+= lm3533-als.o
 obj-$(CONFIG_TSL2583)	+= tsl2583.o
 obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
diff --git a/drivers/staging/iio/light/lm3533-als.c b/drivers/staging/iio/light/lm3533-als.c
new file mode 100644
index 0000000..75b315c
--- /dev/null
+++ b/drivers/staging/iio/light/lm3533-als.c
@@ -0,0 +1,726 @@
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
+#include <linux/iio/events.h>
+#include <linux/iio/iio.h>
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+#define LM3533_ALS_ADC_MAX			0xff
+#define LM3533_ALS_BOUNDARY_MAX			LM3533_ALS_ADC_MAX
+#define LM3533_ALS_CALIBSCALE_MIN		10
+#define LM3533_ALS_CALIBSCALE_MAX		1270
+#define LM3533_ALS_CALIBSCALE_STEP		10
+#define LM3533_ALS_TARGET_MAX			LM3533_ALS_ADC_MAX
+#define LM3533_ALS_ZONE_MAX			4
+
+#define LM3533_REG_ALS_RESISTOR_SELECT		0x30
+#define LM3533_REG_ALS_CONF			0x31
+#define LM3533_REG_ALS_ZONE_INFO		0x34
+#define LM3533_REG_ALS_READ_ADC_RAW		0x37
+#define LM3533_REG_ALS_READ_ADC_AVERAGE		0x38
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
+#define LM3533_ALS_FLAG_INT_ENABLED		1
+
+
+struct lm3533_als {
+	struct lm3533 *lm3533;
+
+	unsigned long flags;
+	int irq;
+
+	int pwm_mode:1;
+
+	atomic_t zone;
+};
+
+
+static int lm3533_als_get_adc(struct iio_dev *indio_dev, bool average,
+								int *adc)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 reg;
+	u8 val;
+	int ret;
+
+	if (average)
+		reg = LM3533_REG_ALS_READ_ADC_AVERAGE;
+	else
+		reg = LM3533_REG_ALS_READ_ADC_RAW;
+
+	ret = lm3533_read(als->lm3533, reg, &val);
+	if (ret) {
+		dev_err(&indio_dev->dev, "failed to read adc\n");
+		return ret;
+	}
+
+	*adc = val;
+
+	return 0;
+}
+
+static int lm3533_als_get_calibscale(struct iio_dev *indio_dev, int *scale)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 val;
+	int ret;
+
+	/* calibscale is ignored in pwm-mode */
+	if (als->pwm_mode) {
+		*scale = 0;
+		return 0;
+	}
+
+	ret = lm3533_read(als->lm3533, LM3533_REG_ALS_RESISTOR_SELECT, &val);
+	if (ret) {
+		dev_err(&indio_dev->dev, "failed to read calibscale\n");
+		return ret;
+	}
+
+	*scale = val * LM3533_ALS_CALIBSCALE_STEP;
+
+	return 0;
+}
+
+static int lm3533_als_set_calibscale(struct iio_dev *indio_dev, int scale)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 val;
+	int ret;
+
+	/* calibscale is ignored in pwm-mode */
+	if (als->pwm_mode)
+		return -EINVAL;
+
+	if (scale < LM3533_ALS_CALIBSCALE_MIN ||
+					scale > LM3533_ALS_CALIBSCALE_MAX)
+		return -EINVAL;
+
+	val = (u8)(scale / LM3533_ALS_CALIBSCALE_STEP);
+
+	ret = lm3533_write(als->lm3533, LM3533_REG_ALS_RESISTOR_SELECT, val);
+	if (ret) {
+		dev_err(&indio_dev->dev, "failed to write calibscale\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lm3533_als_read_raw(struct iio_dev *indio_dev,
+				struct iio_chan_spec const *chan,
+				int *val, int *val2, long mask)
+{
+	int ret;
+
+	switch (mask) {
+	case 0:
+		ret = lm3533_als_get_adc(indio_dev, false, val);
+		break;
+	case IIO_CHAN_INFO_AVERAGE_RAW:
+		ret = lm3533_als_get_adc(indio_dev, true, val);
+		break;
+	case IIO_CHAN_INFO_CALIBSCALE:
+		ret = lm3533_als_get_calibscale(indio_dev, val);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	return IIO_VAL_INT;
+}
+
+static int lm3533_als_write_raw(struct iio_dev *indio_dev,
+				struct iio_chan_spec const *chan,
+				int val, int val2, long mask)
+{
+	if (mask != IIO_CHAN_INFO_CALIBSCALE)
+		return -EINVAL;
+
+	return lm3533_als_set_calibscale(indio_dev, val);
+}
+
+static const struct iio_chan_spec lm3533_als_channels[] = {
+	{
+		.type		= IIO_LIGHT,
+		.channel	= 0,
+		.indexed	= 1,
+		.info_mask	= (IIO_CHAN_INFO_AVERAGE_RAW_SEPARATE_BIT |
+				   IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
+				   IIO_CHAN_INFO_RAW_SEPARATE_BIT),
+	}
+};
+
+static int lm3533_als_get_zone(struct iio_dev *indio_dev, u8 *zone)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 val;
+	int ret;
+
+	ret = lm3533_read(als->lm3533, LM3533_REG_ALS_ZONE_INFO, &val);
+	if (ret) {
+		dev_err(&indio_dev->dev, "failed to read zone\n");
+		return ret;
+	}
+
+	val = (val & LM3533_ALS_ZONE_MASK) >> LM3533_ALS_ZONE_SHIFT;
+	*zone = min_t(u8, val, LM3533_ALS_ZONE_MAX);
+
+	return 0;
+}
+
+static irqreturn_t lm3533_als_isr(int irq, void *dev_id)
+{
+
+	struct iio_dev *indio_dev = dev_id;
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 zone;
+	int ret;
+
+	/* Clear interrupt by reading the ALS zone register. */
+	ret = lm3533_als_get_zone(indio_dev, &zone);
+	if (ret)
+		goto out;
+
+	atomic_set(&als->zone, zone);
+
+	iio_push_event(indio_dev,
+		       IIO_UNMOD_EVENT_CODE(IIO_LIGHT,
+					    0,
+					    IIO_EV_TYPE_THRESH,
+					    IIO_EV_DIR_EITHER),
+		       iio_get_time_ns());
+out:
+	return IRQ_HANDLED;
+}
+
+static int lm3533_als_set_int_mode(struct iio_dev *indio_dev, int enable)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 mask = LM3533_ALS_INT_ENABLE_MASK;
+	u8 val;
+	int ret;
+
+	if (enable)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(als->lm3533, LM3533_REG_ALS_ZONE_INFO, val, mask);
+	if (ret) {
+		dev_err(&indio_dev->dev, "failed to set int mode %d\n",
+								enable);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lm3533_als_get_int_mode(struct iio_dev *indio_dev, int *enable)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 mask = LM3533_ALS_INT_ENABLE_MASK;
+	u8 val;
+	int ret;
+
+	ret = lm3533_read(als->lm3533, LM3533_REG_ALS_ZONE_INFO, &val);
+	if (ret) {
+		dev_err(&indio_dev->dev, "failed to get int mode\n");
+		return ret;
+	}
+
+	*enable = !!(val & mask);
+
+	return 0;
+}
+
+static int show_thresh_either_en(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct lm3533_als *als = iio_priv(indio_dev);
+	int enable;
+	int ret;
+
+	if (als->irq) {
+		ret = lm3533_als_get_int_mode(indio_dev, &enable);
+		if (ret)
+			return ret;
+	} else {
+		enable = 0;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", enable);
+}
+
+static int store_thresh_either_en(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct lm3533_als *als = iio_priv(indio_dev);
+	unsigned long enable;
+	bool int_enabled;
+	u8 zone;
+	int ret;
+
+	if (!als->irq)
+		return -EBUSY;
+
+	if (kstrtoul(buf, 0, &enable))
+		return -EINVAL;
+
+	int_enabled = test_bit(LM3533_ALS_FLAG_INT_ENABLED, &als->flags);
+
+	if (enable && !int_enabled) {
+		ret = lm3533_als_get_zone(indio_dev, &zone);
+		if (ret)
+			return ret;
+
+		atomic_set(&als->zone, zone);
+
+		set_bit(LM3533_ALS_FLAG_INT_ENABLED, &als->flags);
+	}
+
+	ret = lm3533_als_set_int_mode(indio_dev, enable);
+	if (ret) {
+		if (!int_enabled)
+			clear_bit(LM3533_ALS_FLAG_INT_ENABLED, &als->flags);
+
+		return ret;
+	}
+
+	if (!enable)
+		clear_bit(LM3533_ALS_FLAG_INT_ENABLED, &als->flags);
+
+	return len;
+}
+
+static ssize_t show_zone(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 zone;
+	int ret;
+
+	if (test_bit(LM3533_ALS_FLAG_INT_ENABLED, &als->flags)) {
+		zone = atomic_read(&als->zone);
+	} else {
+		ret = lm3533_als_get_zone(indio_dev, &zone);
+		if (ret)
+			return ret;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", zone);
+}
+
+struct lm3533_device_attribute {
+	struct device_attribute dev_attr;
+	u8 reg;
+	u8 max;
+};
+
+static inline struct lm3533_device_attribute *
+to_lm3533_dev_attr(struct device_attribute *attr)
+{
+	return container_of(attr, struct lm3533_device_attribute, dev_attr);
+}
+
+static ssize_t show_lm3533_als_reg(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct lm3533_als *als = iio_priv(indio_dev);
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
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct lm3533_als *als = iio_priv(indio_dev);
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
+#define LM3533_REG_ATTR_RW(_name, _reg, _max) \
+	LM3533_REG_ATTR(_name, S_IRUGO | S_IWUSR, show_lm3533_als_reg, \
+					store_lm3533_als_reg, _reg, _max)
+
+#define ALS_THRESH_FALLING_ATTR_RW(_nr) \
+	LM3533_REG_ATTR_RW(in_illuminance0_thresh##_nr##_falling_value, \
+		LM3533_REG_ALS_BOUNDARY##_nr##_LOW, LM3533_ALS_BOUNDARY_MAX)
+
+#define ALS_THRESH_RAISING_ATTR_RW(_nr) \
+	LM3533_REG_ATTR_RW(in_illuminance0_thresh##_nr##_raising_value, \
+		LM3533_REG_ALS_BOUNDARY##_nr##_HIGH, LM3533_ALS_BOUNDARY_MAX)
+
+/*
+ * ALS Zone thresholds (boundaries)
+ *
+ * in_illuminance0_thresh[0-3]_falling_value	0-255
+ * in_illuminance0_thresh[0-3]_raising_value	0-255
+ */
+static ALS_THRESH_FALLING_ATTR_RW(0);
+static ALS_THRESH_FALLING_ATTR_RW(1);
+static ALS_THRESH_FALLING_ATTR_RW(2);
+static ALS_THRESH_FALLING_ATTR_RW(3);
+
+static ALS_THRESH_RAISING_ATTR_RW(0);
+static ALS_THRESH_RAISING_ATTR_RW(1);
+static ALS_THRESH_RAISING_ATTR_RW(2);
+static ALS_THRESH_RAISING_ATTR_RW(3);
+
+#define LM3533_ALS_ATTR_RO(_name) \
+	DEVICE_ATTR(in_illuminance0_##_name, S_IRUGO, show_##_name, NULL)
+#define LM3533_ALS_ATTR_RW(_name) \
+	DEVICE_ATTR(in_illuminance0_##_name, S_IRUGO | S_IWUSR , \
+						show_##_name, store_##_name)
+
+/*
+ * ALS Zone threshold-event enable
+ *
+ * in_illuminance0_thresh_either_en		0,1
+ */
+static LM3533_ALS_ATTR_RW(thresh_either_en);
+
+/*
+ * ALS Current Zone
+ *
+ * in_illuminance0_zone		0-4
+ */
+static LM3533_ALS_ATTR_RO(zone);
+
+#define ALS_TARGET_ATTR_RW(_mapper, _nr) \
+	LM3533_REG_ATTR_RW(target##_mapper##_##_nr, \
+		LM3533_REG_ALS_M##_mapper##_TARGET_##_nr, LM3533_ALS_TARGET_MAX)
+
+/*
+ * ALS Mapper targets
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
+static struct attribute *lm3533_als_event_attributes[] = {
+	&dev_attr_in_illuminance0_thresh_either_en.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh0_falling_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh0_raising_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh1_falling_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh1_raising_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh2_falling_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh2_raising_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh3_falling_value.dev_attr.attr,
+	&lm3533_dev_attr_in_illuminance0_thresh3_raising_value.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group lm3533_als_event_attribute_group = {
+	.attrs = lm3533_als_event_attributes
+};
+
+static struct attribute *lm3533_als_attributes[] = {
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
+	&dev_attr_in_illuminance0_zone.attr,
+	NULL
+};
+
+static struct attribute_group lm3533_als_attribute_group = {
+	.attrs = lm3533_als_attributes
+};
+
+static int __devinit lm3533_als_set_input_mode(struct iio_dev *indio_dev,
+								int pwm_mode)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 mask = LM3533_ALS_INPUT_MODE_MASK;
+	u8 val;
+	int ret;
+
+	if (pwm_mode)
+		val = mask;	/* pwm input */
+	else
+		val = 0;	/* analog input */
+
+	ret = lm3533_update(als->lm3533, LM3533_REG_ALS_CONF, mask, mask);
+	if (ret) {
+		dev_err(&indio_dev->dev,
+				"failed to set input mode %d\n", pwm_mode);
+	}
+
+	return ret;
+}
+
+static int __devinit lm3533_als_setup(struct iio_dev *indio_dev,
+					struct lm3533_als_platform_data *pdata)
+{
+	int ret;
+
+	ret = lm3533_als_set_input_mode(indio_dev, pdata->pwm_mode);
+	if (ret)
+		return ret;
+
+	if (!pdata->pwm_mode) {
+		ret = lm3533_als_set_calibscale(indio_dev, pdata->calibscale);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int __devinit lm3533_als_enable(struct iio_dev *indio_dev)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 mask = LM3533_ALS_ENABLE_MASK;
+	int ret;
+
+	ret = lm3533_update(als->lm3533, LM3533_REG_ALS_CONF, mask, mask);
+	if (ret)
+		dev_err(&indio_dev->dev, "failed to enable ALS\n");
+
+	return ret;
+}
+
+static int __devexit lm3533_als_disable(struct iio_dev *indio_dev)
+{
+	struct lm3533_als *als = iio_priv(indio_dev);
+	u8 mask = LM3533_ALS_ENABLE_MASK;
+	int ret;
+
+	ret = lm3533_update(als->lm3533, LM3533_REG_ALS_CONF, 0, mask);
+	if (ret)
+		dev_err(&indio_dev->dev, "failed to disable ALS\n");
+
+	return ret;
+}
+
+static const struct iio_info lm3533_als_info = {
+	.attrs		= &lm3533_als_attribute_group,
+	.event_attrs	= &lm3533_als_event_attribute_group,
+	.driver_module	= THIS_MODULE,
+	.read_raw	= &lm3533_als_read_raw,
+	.write_raw	= &lm3533_als_write_raw,
+};
+
+static int __devinit lm3533_als_probe(struct platform_device *pdev)
+{
+	struct lm3533 *lm3533;
+	struct lm3533_als_platform_data *pdata;
+	struct lm3533_als *als;
+	struct iio_dev *indio_dev;
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
+	indio_dev = iio_device_alloc(sizeof(*als));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	indio_dev->info = &lm3533_als_info;
+	indio_dev->channels = lm3533_als_channels;
+	indio_dev->num_channels = ARRAY_SIZE(lm3533_als_channels);
+	indio_dev->name = "lm3533-als";
+	indio_dev->dev.parent = pdev->dev.parent;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+
+	als = iio_priv(indio_dev);
+	als->lm3533 = lm3533;
+	als->irq = lm3533->irq;
+	als->pwm_mode = pdata->pwm_mode;
+	atomic_set(&als->zone, 0);
+
+	if (als->irq) {
+		ret = request_threaded_irq(als->irq, NULL, lm3533_als_isr,
+						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+						indio_dev->name, indio_dev);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to request irq %d\n",
+								als->irq);
+			goto err_free_dev;
+		}
+	}
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	ret = iio_device_register(indio_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register ALS\n");
+		goto err_free_irq;
+	}
+
+	ret = lm3533_als_setup(indio_dev, pdata);
+	if (ret)
+		goto err_unregister;
+
+	ret = lm3533_als_enable(indio_dev);
+	if (ret)
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	iio_device_unregister(indio_dev);
+err_free_irq:
+	if (als->irq)
+		free_irq(als->irq, indio_dev);
+err_free_dev:
+	iio_device_free(indio_dev);
+
+	return ret;
+}
+
+static int __devexit lm3533_als_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+	struct lm3533_als *als = iio_priv(indio_dev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533_als_disable(indio_dev);
+	iio_device_unregister(indio_dev);
+	if (als->irq)
+		free_irq(als->irq, indio_dev);
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+static struct platform_driver lm3533_als_driver = {
+	.driver	= {
+		.name	= "lm3533-als",
+		.owner	= THIS_MODULE,
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
diff --git a/include/linux/mfd/lm3533.h b/include/linux/mfd/lm3533.h
index 9660feb..c1404cc 100644
--- a/include/linux/mfd/lm3533.h
+++ b/include/linux/mfd/lm3533.h
@@ -43,6 +43,9 @@ struct lm3533_ctrlbank {
 
 struct lm3533_als_platform_data {
 	unsigned pwm_mode:1;		/* PWM input mode (default analog) */
+	u16 calibscale;			/* 10 - 1270 uA (10 uA step), current
+					 * at 2V full-scale (analog mode)
+					 */
 };
 
 struct lm3533_bl_platform_data {
-- 
1.7.8.5

