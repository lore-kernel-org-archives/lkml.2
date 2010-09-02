Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0IBVgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:36:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15710 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0IBVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:36:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 02 Sep 2010 14:36:20 -0700
From: achew@nvidia.com
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Cc: akpm@linux-foundation.org, khali@linux-fr.org, ldewangan@nvidia.com,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Date: Thu,  2 Sep 2010 14:35:51 -0700
Message-Id: <1283463351-15816-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 02 Sep 2010 21:36:20.0020 (UTC) FILETIME=[E1BA2F40:01CB4AE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

This is for the Asahi Kasei AK8975 3-axis magnetometer.  It resides within
the magnetometer section of the IIO subsystem, and implements the raw
magn_x,y,z attributes, as well as x,y,z factory calibration attributes.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/staging/iio/magnetometer/Kconfig  |   11 +
 drivers/staging/iio/magnetometer/Makefile |    1 +
 drivers/staging/iio/magnetometer/ak8975.c |  517 +++++++++++++++++++++++++++++
 3 files changed, 529 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/magnetometer/ak8975.c

diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
index d014450..00e1204 100644
--- a/drivers/staging/iio/magnetometer/Kconfig
+++ b/drivers/staging/iio/magnetometer/Kconfig
@@ -3,6 +3,17 @@
 #
 comment "Magnetometer sensors"
 
+config SENSORS_AK8975
+	tristate "Asahi Kasei AK8975 3-Axis Magnetometer"
+	default n
+	depends on I2C
+	help
+	  Say yes here to build support for Asahi Kasei AK8975 3-Axis
+	  Magnetometer.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ak8975.
+
 config SENSORS_HMC5843
 	tristate "Honeywell HMC5843 3-Axis Magnetometer"
 	depends on I2C
diff --git a/drivers/staging/iio/magnetometer/Makefile b/drivers/staging/iio/magnetometer/Makefile
index f9bfb2e..e3dbaa4 100644
--- a/drivers/staging/iio/magnetometer/Makefile
+++ b/drivers/staging/iio/magnetometer/Makefile
@@ -2,4 +2,5 @@
 # Makefile for industrial I/O Magnetometer sensors
 #
 
+obj-$(CONFIG_SENSORS_AK8975)	:= ak8975.o
 obj-$(CONFIG_SENSORS_HMC5843)	+= hmc5843.o
diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
new file mode 100644
index 0000000..421a4ff
--- /dev/null
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -0,0 +1,517 @@
+/*
+ * A sensor driver for the magnetometer AK8975.
+ *
+ * Magnetic compass sensor driver for monitoring magnetic flux information.
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+
+#include <linux/gpio.h>
+
+#include "../iio.h"
+#include "magnet.h"
+
+/*
+ * Register definitions, as well as various shifts and masks to get at the
+ * individual fields of the registers.
+ */
+#define AK8975_REG_WIA			0x00
+#define AK8975_DEVICE_ID		0x48
+
+#define AK8975_REG_INFO			0x01
+
+#define AK8975_REG_ST1			0x02
+#define AK8975_REG_ST1_DRDY_SHIFT	0
+#define AK8975_REG_ST1_DRDY_MASK	(1 << AK8975_REG_ST1_DRDY_SHIFT)
+
+#define AK8975_REG_HXL			0x03
+#define AK8975_REG_HXH			0x04
+#define AK8975_REG_HYL			0x05
+#define AK8975_REG_HYH			0x06
+#define AK8975_REG_HZL			0x07
+#define AK8975_REG_HZH			0x08
+#define AK8975_REG_ST2			0x09
+#define AK8975_REG_ST2_DERR_SHIFT	2
+#define AK8975_REG_ST2_DERR_MASK	(1 << AK8975_REG_ST2_DERR_SHIFT)
+
+#define AK8975_REG_ST2_HOFL_SHIFT	3
+#define AK8975_REG_ST2_HOFL_MASK	(1 << AK8975_REG_ST2_HOFL_SHIFT)
+
+#define AK8975_REG_CNTL			0x0A
+#define AK8975_REG_CNTL_MODE_SHIFT	0
+#define AK8975_REG_CNTL_MODE_MASK	(0xF << AK8975_REG_CNTL_MODE_SHIFT)
+#define AK8975_REG_CNTL_MODE_POWER_DOWN	0
+#define AK8975_REG_CNTL_MODE_ONCE	1
+#define AK8975_REG_CNTL_MODE_SELF_TEST	8
+#define AK8975_REG_CNTL_MODE_FUSE_ROM	0xF
+
+#define AK8975_REG_RSVC			0x0B
+#define AK8975_REG_ASTC			0x0C
+#define AK8975_REG_TS1			0x0D
+#define AK8975_REG_TS2			0x0E
+#define AK8975_REG_I2CDIS		0x0F
+#define AK8975_REG_ASAX			0x10
+#define AK8975_REG_ASAY			0x11
+#define AK8975_REG_ASAZ			0x12
+
+#define AK8975_MAX_REGS			AK8975_REG_ASAZ
+
+/*
+ * Miscellaneous values.
+ */
+#define AK8975_MAX_CONVERSION_TRIAL	5
+#define AK8975_MAX_CONVERSION_TIMEOUT	500
+#define AK8975_CONVERSION_DONE_POLL_TIME 10
+
+/*
+ * Per-instance context data for the device.
+ */
+struct ak8975_data {
+	struct i2c_client	*client;
+	struct iio_dev		*indio_dev;
+	struct attribute_group  attrs;
+	struct mutex            lock;
+	u8                      asa[3];
+	unsigned long           mode;
+	u8                      reg_cache[AK8975_MAX_REGS];
+	int                     eoc_gpio;
+	int                     eoc_irq;
+};
+
+/*
+ * Helper function to write to the I2C device's registers.
+ */
+static bool ak8975_write_data(struct i2c_client *client,
+			      u8 reg, u8 val, u8 mask, u8 shift)
+{
+	u8 regval;
+	struct i2c_msg msg;
+	u8 w_data[2];
+	int ret = 0;
+
+	struct ak8975_data *data = i2c_get_clientdata(client);
+
+	regval = data->reg_cache[reg];
+	regval &= ~mask;
+	regval |= val << shift;
+
+	w_data[0] = reg;
+	w_data[1] = regval;
+
+	msg.addr = client->addr;
+	msg.flags = 0;
+	msg.len = 2;
+	msg.buf = w_data;
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "Write to device fails status %x\n", ret);
+		return false;
+	}
+	data->reg_cache[reg] = regval;
+
+	return true;
+}
+
+/*
+ * Helper function to read a contiguous set of the I2C device's registers.
+ */
+static bool ak8975_read_data(struct i2c_client *client,
+			     u8 reg, u8 length, u8 *buffer)
+{
+	struct i2c_msg msg[2];
+	u8 w_data[2];
+	int ret = 0;
+
+	w_data[0] = reg;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = I2C_M_NOSTART;	/* set repeated start and write */
+	msg[0].len = 1;
+	msg[0].buf = w_data;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = length;
+	msg[1].buf = buffer;
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "Read from device fails\n");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Perform some start-of-day setup, including reading the asa calibration
+ * values and caching them.
+ */
+static int ak8975_setup(struct i2c_client *client)
+{
+	struct ak8975_data *data = i2c_get_clientdata(client);
+	u8 device_id;
+	u8 buffer[3];
+	bool status;
+
+	/* Confirm that the device we're talking to is really an AK8975. */
+	status = ak8975_read_data(client, AK8975_REG_WIA, 1, &device_id);
+	if ((!status) || (device_id != AK8975_DEVICE_ID)) {
+		dev_err(&client->dev, "Device ak8975 not found\n");
+		return -ENODEV;
+	}
+
+	/* Write the fused rom access mode. */
+	status = ak8975_write_data(client,
+				   AK8975_REG_CNTL,
+				   AK8975_REG_CNTL_MODE_FUSE_ROM,
+				   AK8975_REG_CNTL_MODE_MASK,
+				   AK8975_REG_CNTL_MODE_SHIFT);
+	if (!status) {
+		dev_err(&client->dev, "Error in setting fuse access mode\n");
+		return false;
+	}
+
+	/* Get asa data and store in the device data. */
+	status = ak8975_read_data(client, AK8975_REG_ASAX, 3, buffer);
+	if (!status) {
+		dev_err(&client->dev, "Not able to read asa data\n");
+		return -ENODEV;
+	}
+
+	data->asa[0] = buffer[0] & 0xFF;
+	data->asa[1] = buffer[1] & 0xFF;
+	data->asa[2] = buffer[2] & 0xFF;
+
+	return 0;
+}
+
+/*
+ * Shows the device's mode.  0 = off, 1 = on.
+ */
+static ssize_t show_mode(struct device *dev, struct device_attribute *devattr,
+			 char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct ak8975_data *data = indio_dev->dev_data;
+
+	return sprintf(buf, "%lu\n", data->mode);
+}
+
+/*
+ * Sets the device's mode.  0 = off, 1 = on.  The device's mode must be on
+ * for the magn raw attributes to be available.
+ */
+static ssize_t store_mode(struct device *dev, struct device_attribute *devattr,
+			  const char *buf, size_t count)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct ak8975_data *data = indio_dev->dev_data;
+	struct i2c_client *client = data->client;
+	unsigned long oval;
+	bool status;
+
+	/* Convert mode string and do some basic sanity checking on it.
+	   only 0 or 1 are valid. */
+	if (strict_strtol(buf, 10, &oval))
+		return -EINVAL;
+
+	if ((oval < 0) || (oval > 1)) {
+		dev_err(dev, "mode value is not supported\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&data->lock);
+
+	/* Write the mode to the device. */
+	if (data->mode != oval) {
+		status = ak8975_write_data(client,
+					   AK8975_REG_CNTL,
+					   (u8)oval,
+					   AK8975_REG_CNTL_MODE_MASK,
+					   AK8975_REG_CNTL_MODE_SHIFT);
+
+		if (!status) {
+			dev_err(&client->dev, "Error in setting mode\n");
+			mutex_unlock(&data->lock);
+			return -EINVAL;
+		}
+		data->mode = oval;
+	}
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+/*
+ * Emits the ASA sensitivity adjustment value for the x, y, or z axis.
+ * These ASA values are read from the sensor device at start of day, and
+ * cached in the device context struct.
+ */
+static ssize_t show_calibscale(struct device *dev,
+			       struct device_attribute *devattr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct ak8975_data *data = indio_dev->dev_data;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(devattr);
+
+	if (!data) {
+		dev_err(dev, "No device found\n");
+		return -ENODEV;
+	}
+
+	return sprintf(buf, "%d\n", data->asa[this_attr->address]);
+}
+
+/*
+ * Emits the raw flux value for the x, y, or z axis.
+ *
+ * Adjusting the flux value with the sensitivity adjustment value should be
+ * done via the following formula:
+ *
+ * Hadj = H * ( ( ( (ASA-128)*0.5 ) / 128 ) + 1 )
+ *
+ * where H is the raw value, ASA is the sensitivity adjustment, and Hadj
+ * is the resultant adjusted value.
+ */
+static ssize_t show_raw(struct device *dev, struct device_attribute *devattr,
+			char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct ak8975_data *data = indio_dev->dev_data;
+	struct i2c_client *client = data->client;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(devattr);
+	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
+	u16 meas_reg;
+	s16 raw;
+	u8 read_status;
+	bool status;
+	int state;
+
+	/* Set up the device for taking a sample. */
+	status = ak8975_write_data(client,
+				   AK8975_REG_CNTL,
+				   AK8975_REG_CNTL_MODE_ONCE,
+				   AK8975_REG_CNTL_MODE_MASK,
+				   AK8975_REG_CNTL_MODE_SHIFT);
+	if (!status) {
+		dev_err(&client->dev, "Error in setting operating mode\n");
+		return false;
+	}
+
+	/* Wait for the conversion to complete. */
+	while (timeout_ms) {
+		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
+		state = (gpio_get_value(data->eoc_gpio) ? 1 : 0);
+		if (state)
+			break;
+		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
+	}
+	if (!timeout_ms) {
+		dev_err(&client->dev, "Conversion timeout happend\n");
+		return false;
+	}
+
+	status = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
+	if (!status) {
+		dev_err(&client->dev, "Error in reading ST1\n");
+		return false;
+	}
+
+	if (read_status & AK8975_REG_ST1_DRDY_MASK) {
+		status = ak8975_read_data(client, AK8975_REG_ST2,
+					  1, &read_status);
+		if (!status) {
+			dev_err(&client->dev, "Error in reading ST2\n");
+			return false;
+		}
+		if (read_status & (AK8975_REG_ST2_DERR_MASK |
+				   AK8975_REG_ST2_HOFL_MASK)) {
+			dev_err(&client->dev, "ST2 status error 0x%x\n",
+				read_status);
+			return false;
+		}
+	}
+
+	/* Read the flux value from the appropriate register
+	   (the register is specified in the iio device attributes). */
+	status = ak8975_read_data(client, this_attr->address, 2,
+				  (u8 *)&meas_reg);
+	if (!status) {
+		dev_err(&client->dev, "Read axis data fails\n");
+		return false;
+	}
+
+	/* Endian conversion of the measured values */
+	raw = (s16) (le16_to_cpu(meas_reg));
+
+	return sprintf(buf, "%d\n", raw);
+}
+
+static IIO_DEVICE_ATTR(mode, S_IRUGO | S_IWUSR, show_mode, store_mode, 0);
+static IIO_DEVICE_ATTR(magn_x_calibscale, S_IRUGO, show_calibscale, NULL, 0);
+static IIO_DEVICE_ATTR(magn_y_calibscale, S_IRUGO, show_calibscale, NULL, 1);
+static IIO_DEVICE_ATTR(magn_z_calibscale, S_IRUGO, show_calibscale, NULL, 2);
+static IIO_DEV_ATTR_MAGN_X(show_raw, AK8975_REG_HXL);
+static IIO_DEV_ATTR_MAGN_Y(show_raw, AK8975_REG_HYL);
+static IIO_DEV_ATTR_MAGN_Z(show_raw, AK8975_REG_HZL);
+
+static struct attribute *ak8975_attr[] = {
+	&iio_dev_attr_mode.dev_attr.attr,
+	&iio_dev_attr_magn_x_calibscale.dev_attr.attr,
+	&iio_dev_attr_magn_y_calibscale.dev_attr.attr,
+	&iio_dev_attr_magn_z_calibscale.dev_attr.attr,
+	&iio_dev_attr_magn_x_raw.dev_attr.attr,
+	&iio_dev_attr_magn_y_raw.dev_attr.attr,
+	&iio_dev_attr_magn_z_raw.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group ak8975_attr_group = {
+	.attrs = ak8975_attr,
+};
+
+static int ak8975_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct ak8975_data *data;
+	int err;
+
+	/* Allocate our device context. */
+	data = kzalloc(sizeof(struct ak8975_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&client->dev, "Memory allocation fails\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	i2c_set_clientdata(client, data);
+	data->client = client;
+
+	mutex_init(&data->lock);
+
+	/* Grab and set up the supplied GPIO. */
+	data->eoc_irq = client->irq;
+	data->eoc_gpio = irq_to_gpio(client->irq);
+
+	err = gpio_request(data->eoc_gpio, "ak_8975");
+	if (err < 0) {
+		dev_err(&client->dev, "failed to request GPIO %d, error %d\n",
+			data->eoc_gpio, err);
+		goto exit_free;
+	}
+
+	err = gpio_direction_input(data->eoc_gpio);
+	if (err < 0) {
+		dev_err(&client->dev, "Failed to configure input direction for"
+			" GPIO %d, error %d\n", data->eoc_gpio, err);
+		gpio_free(data->eoc_gpio);
+		goto exit_gpio;
+	}
+
+	/* Perform some basic start-of-day setup of the device. */
+	err = ak8975_setup(client);
+	if (err < 0) {
+		dev_err(&client->dev, "AK8975 initialization fails\n");
+		goto exit_gpio;
+	}
+
+	/* Register with IIO */
+	data->indio_dev = iio_allocate_device();
+	if (data->indio_dev == NULL) {
+		err = -ENOMEM;
+		goto exit_gpio;
+	}
+
+	data->indio_dev->dev.parent = &client->dev;
+	data->indio_dev->attrs = &ak8975_attr_group;
+	data->indio_dev->dev_data = (void *)(data);
+	data->indio_dev->driver_module = THIS_MODULE;
+	data->indio_dev->modes = INDIO_DIRECT_MODE;
+
+	err = iio_device_register(data->indio_dev);
+	if (err < 0)
+		goto exit_free_iio;
+
+	return 0;
+
+exit_free_iio:
+	iio_free_device(data->indio_dev);
+exit_gpio:
+	gpio_free(data->eoc_gpio);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int ak8975_remove(struct i2c_client *client)
+{
+	struct ak8975_data *data = i2c_get_clientdata(client);
+
+	iio_device_unregister(data->indio_dev);
+	iio_free_device(data->indio_dev);
+
+	gpio_free(data->eoc_gpio);
+
+	kfree(data);
+
+	return 0;
+}
+
+static const struct i2c_device_id ak8975_id[] = {
+	{"ak8975", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, ak8975_id);
+
+static struct i2c_driver ak8975_driver = {
+	.driver = {
+		.name	= "ak8975",
+	},
+	.probe		= ak8975_probe,
+	.remove		= __devexit_p(ak8975_remove),
+	.id_table	= ak8975_id,
+};
+
+static int __init ak8975_init(void)
+{
+	return i2c_add_driver(&ak8975_driver);
+}
+
+static void __exit ak8975_exit(void)
+{
+	i2c_del_driver(&ak8975_driver);
+}
+
+module_init(ak8975_init);
+module_exit(ak8975_exit);
+
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_DESCRIPTION("AK8975 magnetometer driver");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

