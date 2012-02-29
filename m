Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2B2UFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:05:51 -0500
Received: from csmtp3.one.com ([91.198.169.23]:18988 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab2B2UFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:05:01 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 15:05:00 EST
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, christoph.mair@gmail.com,
        stefan.nilsson@unixphere.com, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH 1/3] drivers/misc: add support for BMP18x pressure sensors
Date: Wed, 29 Feb 2012 20:58:07 +0100
Message-Id: <1330545489-31169-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for Bosch Sensortec's pressure sensors
BMP085 and BMP18x.

The driver is based on the bmp085 driver by Christoph Mair
and uses the same sysfs interface.

Tested-by: Zhengguang Guo <zhengguang.guo@bosch-sensortec.com>
Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 drivers/misc/Kconfig       |   30 +++
 drivers/misc/Makefile      |    3 +
 drivers/misc/bmp18x-core.c |  502 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/bmp18x-i2c.c  |  121 +++++++++++
 drivers/misc/bmp18x-spi.c  |  143 +++++++++++++
 include/linux/i2c/bmp18x.h |   65 ++++++
 6 files changed, 864 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/bmp18x-core.c
 create mode 100644 drivers/misc/bmp18x-i2c.c
 create mode 100644 drivers/misc/bmp18x-spi.c
 create mode 100644 include/linux/i2c/bmp18x.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..2e894fd 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -498,6 +498,36 @@ config MAX8997_MUIC
 	  Maxim MAX8997 PMIC.
 	  The MAX8997 MUIC is a USB port accessory detector and switch.
 
+config BMP18X
+        tristate "BMP18X digital pressure sensor"
+        depends on (I2C || SPI_MASTER) && SYSFS
+        help
+          Say Y here if you want support for Bosch Sensortec's digital
+	  pressure sensors BMP085 and BMP18x.
+
+          To compile this driver as a module, choose M here: the
+          module will be called bmp18x-core.
+
+config BMP18X_I2C
+        tristate "support I2C bus connection"
+        depends on BMP18X && I2C
+        help
+          Say Y here if you want to support Bosch Sensortec's digital pressure
+          sensor hooked to an I2C bus.
+
+          To compile this driver as a module, choose M here: the
+          module will be called bmp18x-i2c.
+
+config BMP18X_SPI
+        tristate "support SPI bus connection"
+        depends on BMP18X && SPI_MASTER
+        help
+          Say Y here if you want to support Bosch Sensortec's digital pressure
+          sensor hooked to a SPI bus.
+
+          To compile this driver as a module, choose M here: the
+          module will be called bmp18x-spi.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3e1d801..a1aa04a 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -11,6 +11,9 @@ obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_BMP085)		+= bmp085.o
+obj-$(CONFIG_BMP18X)		+= bmp18x-core.o
+obj-$(CONFIG_BMP18X_I2C)	+= bmp18x-i2c.o
+obj-$(CONFIG_BMP18X_SPI)	+= bmp18x-spi.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
diff --git a/drivers/misc/bmp18x-core.c b/drivers/misc/bmp18x-core.c
new file mode 100644
index 0000000..62ab8ca
--- /dev/null
+++ b/drivers/misc/bmp18x-core.c
@@ -0,0 +1,502 @@
+/*
+ * Copyright (c) 2012  Bosch Sensortec GmbH
+ * Copyright (c) 2012  Unixphere AB
+ *
+ * Based on:
+ * BMP085 driver, bmp085.c
+ * Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
+ *
+ * This driver supports the bmp18x digital barometric pressure
+ * and temperature sensors from Bosch Sensortec. The datasheet
+ * is available from their website:
+ * http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP180-DS000-07.pdf
+ *
+ * A pressure measurement is issued by reading from pressure0_input.
+ * The return value ranges from 30000 to 110000 pascal with a resulution
+ * of 1 pascal (0.01 millibar) which enables measurements from 9000m above
+ * to 500m below sea level.
+ *
+ * The temperature can be read from temp0_input. Values range from
+ * -400 to 850 representing the ambient temperature in degree celsius
+ * multiplied by 10.The resolution is 0.1 celsius.
+ *
+ * Because ambient pressure is temperature dependent, a temperature
+ * measurement will be executed automatically even if the user is reading
+ * from pressure0_input. This happens if the last temperature measurement
+ * has been executed more then one second ago.
+ *
+ * To decrease RMS noise from pressure measurements, the bmp18x can
+ * autonomously calculate the average of up to eight samples. This is
+ * set up by writing to the oversampling sysfs file. Accepted values
+ * are 0, 1, 2 and 3. 2^x when x is the value written to this file
+ * specifies the number of samples used to calculate the ambient pressure.
+ * RMS noise is specified with six pascal (without averaging) and decreases
+ * down to 3 pascal when using an oversampling setting of 3.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/i2c/bmp18x.h>
+
+#define BMP18X_CHIP_ID			0x55
+
+#define BMP18X_CALIBRATION_DATA_START	0xAA
+#define BMP18X_CALIBRATION_DATA_LENGTH	11	/* 16 bit values */
+#define BMP18X_CHIP_ID_REG		0xD0
+#define BMP18X_CTRL_REG			0xF4
+#define BMP18X_TEMP_MEASUREMENT		0x2E
+#define BMP18X_PRESSURE_MEASUREMENT	0x34
+#define BMP18X_CONVERSION_REGISTER_MSB	0xF6
+#define BMP18X_CONVERSION_REGISTER_LSB	0xF7
+#define BMP18X_CONVERSION_REGISTER_XLSB	0xF8
+#define BMP18X_TEMP_CONVERSION_TIME	5
+
+struct bmp18x_calibration_data {
+	s16 AC1, AC2, AC3;
+	u16 AC4, AC5, AC6;
+	s16 B1, B2;
+	s16 MB, MC, MD;
+};
+
+struct bmp18x_data {
+	struct	bmp18x_data_bus data_bus;
+	struct	device *dev;
+	struct	mutex lock;
+	struct	bmp18x_calibration_data calibration;
+	u8	oversampling_setting;
+	u32	raw_temperature;
+	u32	raw_pressure;
+	u32	temp_measurement_period;
+	u32	last_temp_measurement;
+	s32	b6; /* calculated temperature correction coefficient */
+};
+
+static inline int bmp18x_read_block(struct bmp18x_data *data, u8 reg, int len,
+				    char *buf)
+{
+	return data->data_bus.bops->read_block(data->data_bus.client, reg,
+					       len, buf);
+}
+
+static inline int bmp18x_read_byte(struct bmp18x_data *data, u8 reg)
+{
+	return data->data_bus.bops->read_byte(data->data_bus.client, reg);
+}
+
+static inline int bmp18x_write_byte(struct bmp18x_data *data, u8 reg, u8 value)
+{
+	return data->data_bus.bops->write_byte(data->data_bus.client, reg,
+					       value);
+}
+
+static s32 bmp18x_read_calibration_data(struct bmp18x_data *data)
+{
+	u16 tmp[BMP18X_CALIBRATION_DATA_LENGTH];
+	struct bmp18x_calibration_data *cali = &(data->calibration);
+	s32 status = bmp18x_read_block(data, BMP18X_CALIBRATION_DATA_START,
+				(BMP18X_CALIBRATION_DATA_LENGTH << 1),
+				(u8 *)tmp);
+	if (status < 0)
+		return status;
+
+	if (status != (BMP18X_CALIBRATION_DATA_LENGTH << 1))
+		return -EIO;
+
+	cali->AC1 =  be16_to_cpu(tmp[0]);
+	cali->AC2 =  be16_to_cpu(tmp[1]);
+	cali->AC3 =  be16_to_cpu(tmp[2]);
+	cali->AC4 =  be16_to_cpu(tmp[3]);
+	cali->AC5 =  be16_to_cpu(tmp[4]);
+	cali->AC6 = be16_to_cpu(tmp[5]);
+	cali->B1 = be16_to_cpu(tmp[6]);
+	cali->B2 = be16_to_cpu(tmp[7]);
+	cali->MB = be16_to_cpu(tmp[8]);
+	cali->MC = be16_to_cpu(tmp[9]);
+	cali->MD = be16_to_cpu(tmp[10]);
+	return 0;
+}
+
+static s32 bmp18x_update_raw_temperature(struct bmp18x_data *data)
+{
+	u16 tmp;
+	s32 status;
+
+	mutex_lock(&data->lock);
+	status = bmp18x_write_byte(data, BMP18X_CTRL_REG,
+				   BMP18X_TEMP_MEASUREMENT);
+	if (status < 0) {
+		dev_err(data->dev,
+			"Error while requesting temperature measurement.\n");
+		goto exit;
+	}
+	msleep(BMP18X_TEMP_CONVERSION_TIME);
+
+	status = bmp18x_read_block(data, BMP18X_CONVERSION_REGISTER_MSB,
+				   sizeof(tmp), (u8 *)&tmp);
+	if (status < 0)
+		goto exit;
+	if (status != sizeof(tmp)) {
+		dev_err(data->dev,
+			"Error while reading temperature measurement result\n");
+		status = -EIO;
+		goto exit;
+	}
+	data->raw_temperature = be16_to_cpu(tmp);
+	data->last_temp_measurement = jiffies;
+	status = 0;	/* everything ok, return 0 */
+
+exit:
+	mutex_unlock(&data->lock);
+	return status;
+}
+
+static s32 bmp18x_update_raw_pressure(struct bmp18x_data *data)
+{
+	u32 tmp = 0;
+	s32 status;
+
+	mutex_lock(&data->lock);
+	status = bmp18x_write_byte(data, BMP18X_CTRL_REG,
+			BMP18X_PRESSURE_MEASUREMENT +
+			(data->oversampling_setting << 6));
+	if (status < 0) {
+		dev_err(data->dev,
+			"Error while requesting pressure measurement.\n");
+		goto exit;
+	}
+
+	/* wait for the end of conversion */
+	msleep(2+(3 << data->oversampling_setting));
+
+	/* copy data into a u32 (4 bytes), but skip the first byte. */
+	status = bmp18x_read_block(data, BMP18X_CONVERSION_REGISTER_MSB, 3,
+				   ((u8 *)&tmp)+1);
+	if (status < 0)
+		goto exit;
+	if (status != 3) {
+		dev_err(data->dev,
+			"Error while reading pressure measurement results\n");
+		status = -EIO;
+		goto exit;
+	}
+	data->raw_pressure = be32_to_cpu((tmp));
+	data->raw_pressure >>= (8-data->oversampling_setting);
+	status = 0;	/* everything ok, return 0 */
+
+exit:
+	mutex_unlock(&data->lock);
+	return status;
+}
+
+/*
+ * This function starts the temperature measurement and returns the value
+ * in tenth of a degree celsius.
+ */
+static s32 bmp18x_get_temperature(struct bmp18x_data *data, int *temperature)
+{
+	struct bmp18x_calibration_data *cali = &data->calibration;
+	long x1, x2;
+	int status;
+
+	status = bmp18x_update_raw_temperature(data);
+	if (status < 0)
+		goto exit;
+
+	x1 = ((data->raw_temperature - cali->AC6) * cali->AC5) >> 15;
+	x2 = (cali->MC << 11) / (x1 + cali->MD);
+	data->b6 = x1 + x2 - 4000;
+	/* if NULL just update b6. Used for pressure only measurements */
+	if (temperature != NULL)
+		*temperature = (x1+x2+8) >> 4;
+
+exit:
+	return status;
+}
+
+/*
+ * This function starts the pressure measurement and returns the value
+ * in millibar. Since the pressure depends on the ambient temperature,
+ * a temperature measurement is executed according to the given temperature
+ * measurememt period (default is 1 sec boundary). This period could vary
+ * and needs to be adjusted according to the sensor environment, i.e. if big
+ * temperature variations then the temperature needs to be read out often.
+ */
+static s32 bmp18x_get_pressure(struct bmp18x_data *data, int *pressure)
+{
+	struct bmp18x_calibration_data *cali = &data->calibration;
+	s32 x1, x2, x3, b3;
+	u32 b4, b7;
+	s32 p;
+	int status;
+
+	/* update the ambient temperature according to the given meas. period */
+	if (data->last_temp_measurement +
+			data->temp_measurement_period < jiffies) {
+		status = bmp18x_get_temperature(data, NULL);
+		if (status < 0)
+			return status;
+	}
+
+	status = bmp18x_update_raw_pressure(data);
+	if (status < 0)
+		return status;
+
+	x1 = (data->b6 * data->b6) >> 12;
+	x1 *= cali->B2;
+	x1 >>= 11;
+
+	x2 = cali->AC2 * data->b6;
+	x2 >>= 11;
+
+	x3 = x1 + x2;
+
+	b3 = (((((s32)cali->AC1) * 4 + x3) << data->oversampling_setting) + 2);
+	b3 >>= 2;
+
+	x1 = (cali->AC3 * data->b6) >> 13;
+	x2 = (cali->B1 * ((data->b6 * data->b6) >> 12)) >> 16;
+	x3 = (x1 + x2 + 2) >> 2;
+	b4 = (cali->AC4 * (u32)(x3 + 32768)) >> 15;
+
+	b7 = ((u32)data->raw_pressure - b3) *
+					(50000 >> data->oversampling_setting);
+	p = ((b7 < 0x80000000) ? ((b7 << 1) / b4) : ((b7 / b4) * 2));
+
+	x1 = p >> 8;
+	x1 *= x1;
+	x1 = (x1 * 3038) >> 16;
+	x2 = (-7357 * p) >> 16;
+	p += (x1 + x2 + 3791) >> 4;
+
+	*pressure = p;
+
+	return 0;
+}
+
+/*
+ * This function sets the chip-internal oversampling. Valid values are 0..3.
+ * The chip will use 2^oversampling samples for internal averaging.
+ * This influences the measurement time and the accuracy; larger values
+ * increase both. The datasheet gives an overview on how measurement time,
+ * accuracy and noise correlate.
+ */
+static void bmp18x_set_oversampling(struct bmp18x_data *data,
+						unsigned char oversampling)
+{
+	if (oversampling > 3)
+		oversampling = 3;
+	data->oversampling_setting = oversampling;
+}
+
+/*
+ * Returns the currently selected oversampling. Range: 0..3
+ */
+static unsigned char bmp18x_get_oversampling(struct bmp18x_data *data)
+{
+	return data->oversampling_setting;
+}
+
+/* sysfs callbacks */
+static ssize_t set_oversampling(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct bmp18x_data *data = dev_get_drvdata(dev);
+	unsigned long oversampling;
+	int err = kstrtoul(buf, 10, &oversampling);
+
+	if (err == 0) {
+		mutex_lock(&data->lock);
+		bmp18x_set_oversampling(data, oversampling);
+		mutex_unlock(&data->lock);
+		return count;
+	}
+
+	return err;
+}
+
+static ssize_t show_oversampling(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bmp18x_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", bmp18x_get_oversampling(data));
+}
+static DEVICE_ATTR(oversampling, S_IWUSR | S_IRUGO,
+					show_oversampling, set_oversampling);
+
+
+static ssize_t show_temperature(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int temperature;
+	int status;
+	struct bmp18x_data *data = dev_get_drvdata(dev);
+
+	status = bmp18x_get_temperature(data, &temperature);
+	if (status < 0)
+		return status;
+	else
+		return sprintf(buf, "%d\n", temperature);
+}
+static DEVICE_ATTR(temp0_input, S_IRUGO, show_temperature, NULL);
+
+
+static ssize_t show_pressure(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	int pressure;
+	int status;
+	struct bmp18x_data *data = dev_get_drvdata(dev);
+
+	status = bmp18x_get_pressure(data, &pressure);
+	if (status < 0)
+		return status;
+	else
+		return sprintf(buf, "%d\n", pressure);
+}
+static DEVICE_ATTR(pressure0_input, S_IRUGO, show_pressure, NULL);
+
+
+static struct attribute *bmp18x_attributes[] = {
+	&dev_attr_temp0_input.attr,
+	&dev_attr_pressure0_input.attr,
+	&dev_attr_oversampling.attr,
+	NULL
+};
+
+static const struct attribute_group bmp18x_attr_group = {
+	.attrs = bmp18x_attributes,
+};
+
+static int bmp18x_init_client(struct bmp18x_data *data,
+			      struct bmp18x_platform_data *pdata)
+{
+	int status = bmp18x_read_calibration_data(data);
+
+	if (status < 0)
+		return status;
+
+	data->last_temp_measurement = 0;
+	data->temp_measurement_period =
+		pdata ? (pdata->temp_measurement_period/1000)*HZ : 1*HZ;
+	data->oversampling_setting = pdata ? pdata->default_oversampling : 3;
+	mutex_init(&data->lock);
+
+	return 0;
+}
+
+__devinit int bmp18x_probe(struct device *dev, struct bmp18x_data_bus *data_bus)
+{
+	struct bmp18x_data *data;
+	struct bmp18x_platform_data *pdata = dev->platform_data;
+	u8 chip_id = (pdata && pdata->chip_id) ? pdata->chip_id : BMP18X_CHIP_ID;
+	int err = 0;
+
+	if (pdata && pdata->init_hw) {
+		err = pdata->init_hw();
+		if (err) {
+			dev_err(dev, "%s: init_hw failed!\n",
+				BMP18X_NAME);
+			return err;
+		}
+	}
+
+	data = kzalloc(sizeof(struct bmp18x_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	dev_set_drvdata(dev, data);
+	data->data_bus = *data_bus;
+	data->dev = dev;
+
+	if (bmp18x_read_byte(data, BMP18X_CHIP_ID_REG) != chip_id) {
+		dev_err(dev, "%s: chip_id failed!\n", BMP18X_NAME);
+		err = -ENODEV;
+		goto exit_free;
+	}
+
+	/* Initialize the BMP18X chip */
+	err = bmp18x_init_client(data, pdata);
+	if (err < 0)
+		goto exit_free;
+
+	/* Register sysfs hooks */
+	err = sysfs_create_group(&dev->kobj, &bmp18x_attr_group);
+	if (err)
+		goto exit_free;
+
+	dev_info(dev, "Succesfully initialized bmp18x!\n");
+	return 0;
+
+exit_free:
+	kfree(data);
+exit:
+	if (pdata && pdata->deinit_hw)
+		pdata->deinit_hw();
+	return err;
+}
+EXPORT_SYMBOL(bmp18x_probe);
+
+int bmp18x_remove(struct device *dev)
+{
+	struct bmp18x_data *data = dev_get_drvdata(dev);
+	struct bmp18x_platform_data *pdata = dev->platform_data;
+
+	sysfs_remove_group(&dev->kobj, &bmp18x_attr_group);
+
+	if (pdata && pdata->deinit_hw)
+		pdata->deinit_hw();
+
+	kfree(data);
+
+	return 0;
+}
+EXPORT_SYMBOL(bmp18x_remove);
+
+#ifdef CONFIG_PM
+int bmp18x_disable(struct device *dev)
+{
+	struct bmp18x_platform_data *pdata = dev->platform_data;
+
+	if (pdata && pdata->deinit_hw)
+		pdata->deinit_hw();
+
+	return 0;
+}
+EXPORT_SYMBOL(bmp18x_disable);
+
+int bmp18x_enable(struct device *dev)
+{
+	struct bmp18x_platform_data *pdata = dev->platform_data;
+
+	if (pdata && pdata->init_hw)
+		return pdata->init_hw();
+
+	return 0;
+}
+EXPORT_SYMBOL(bmp18x_enable);
+#endif
+
+MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
+MODULE_DESCRIPTION("BMP18X driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/bmp18x-i2c.c b/drivers/misc/bmp18x-i2c.c
new file mode 100644
index 0000000..b7d7ade
--- /dev/null
+++ b/drivers/misc/bmp18x-i2c.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2012  Bosch Sensortec GmbH
+ * Copyright (c) 2012  Unixphere AB
+ *
+ * Based on:
+ * BMP085 driver, bmp085.c
+ * Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/i2c/bmp18x.h>
+
+static int bmp18x_i2c_read_block(void *client, u8 reg, int len, char *buf)
+{
+	return i2c_smbus_read_i2c_block_data(client, reg, len, buf);
+}
+
+static int bmp18x_i2c_read_byte(void *client, u8 reg)
+{
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int bmp18x_i2c_write_byte(void *client, u8 reg, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static const struct bmp18x_bus_ops bmp18x_i2c_bus_ops = {
+	.read_block	= bmp18x_i2c_read_block,
+	.read_byte	= bmp18x_i2c_read_byte,
+	.write_byte	= bmp18x_i2c_write_byte
+};
+
+static int __devinit bmp18x_i2c_probe(struct i2c_client *client,
+				      const struct i2c_device_id *id)
+{
+	struct bmp18x_data_bus data_bus = {
+		.bops = &bmp18x_i2c_bus_ops,
+		.client = client
+	};
+
+	return bmp18x_probe(&client->dev, &data_bus);
+}
+
+static void bmp18x_i2c_shutdown(struct i2c_client *client)
+{
+	bmp18x_disable(&client->dev);
+}
+
+static int bmp18x_i2c_remove(struct i2c_client *client)
+{
+	return bmp18x_remove(&client->dev);
+}
+
+#ifdef CONFIG_PM
+static int bmp18x_i2c_suspend(struct device *dev)
+{
+	return bmp18x_disable(dev);
+}
+
+static int bmp18x_i2c_resume(struct device *dev)
+{
+	return bmp18x_enable(dev);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(bmp18x_i2c_pm_ops, bmp18x_i2c_suspend,
+			 bmp18x_i2c_resume);
+
+static const struct i2c_device_id bmp18x_id[] = {
+	{ BMP18X_NAME, 0 },
+	{ "bmp085", 0 },
+	{ "bmp180", 0 },
+	{ "bmp181", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bmp18x_id);
+
+static struct i2c_driver bmp18x_i2c_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= BMP18X_NAME,
+		.pm	= &bmp18x_i2c_pm_ops,
+	},
+	.id_table	= bmp18x_id,
+	.probe		= bmp18x_i2c_probe,
+	.shutdown	= bmp18x_i2c_shutdown,
+	.remove		= __devexit_p(bmp18x_i2c_remove)
+};
+
+static int __init bmp18x_i2c_init(void)
+{
+	return i2c_add_driver(&bmp18x_i2c_driver);
+}
+
+static void __exit bmp18x_i2c_exit(void)
+{
+	i2c_del_driver(&bmp18x_i2c_driver);
+}
+
+MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
+MODULE_DESCRIPTION("BMP18X I2C bus driver");
+MODULE_LICENSE("GPL");
+
+module_init(bmp18x_i2c_init);
+module_exit(bmp18x_i2c_exit);
diff --git a/drivers/misc/bmp18x-spi.c b/drivers/misc/bmp18x-spi.c
new file mode 100644
index 0000000..d2525b2
--- /dev/null
+++ b/drivers/misc/bmp18x-spi.c
@@ -0,0 +1,143 @@
+/*
+ * Copyright (c) 2012  Bosch Sensortec GmbH
+ * Copyright (c) 2012  Unixphere AB
+ *
+ * Based on:
+ * BMP085 driver, bmp085.c
+ * Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c/bmp18x.h>
+
+static int bmp18x_spi_write_byte(void *client, u8 reg, u8 value)
+{
+	u8 data[2] = {reg, value};
+	return spi_write(client, data, 2);
+}
+
+static int bmp18x_spi_read_block(void *client, u8 reg, int len, char *buf)
+{
+	int err = bmp18x_spi_write_byte(client, reg, 0);
+
+	if (err < 0)
+		return err;
+
+	return spi_read(client, buf, len);
+}
+
+static int bmp18x_spi_read_byte(void *client, u8 reg)
+{
+	u8 data;
+	int err = bmp18x_spi_write_byte(client, reg, 0);
+
+	if (err < 0)
+		return err;
+
+	err = spi_read(client, &data, 1);
+	if (err < 0)
+		return err;
+
+	return data;
+}
+
+static const struct bmp18x_bus_ops bmp18x_spi_bus_ops = {
+	.read_block	= bmp18x_spi_read_block,
+	.read_byte	= bmp18x_spi_read_byte,
+	.write_byte	= bmp18x_spi_write_byte
+};
+
+static int __devinit bmp18x_spi_probe(struct spi_device *client)
+{
+	int err;
+	struct bmp18x_data_bus data_bus = {
+		.bops = &bmp18x_spi_bus_ops,
+		.client = client
+	};
+
+	client->bits_per_word = 8;
+	err = spi_setup(client);
+	if (err < 0) {
+		dev_err(&client->dev, "spi_setup failed!\n");
+		return err;
+	}
+
+	return bmp18x_probe(&client->dev, &data_bus);
+}
+
+static void bmp18x_spi_shutdown(struct spi_device *client)
+{
+	bmp18x_disable(&client->dev);
+}
+
+static int bmp18x_spi_remove(struct spi_device *client)
+{
+	return bmp18x_remove(&client->dev);
+}
+
+#ifdef CONFIG_PM
+static int bmp18x_spi_suspend(struct device *dev)
+{
+	return bmp18x_disable(dev);
+}
+
+static int bmp18x_spi_resume(struct device *dev)
+{
+	return bmp18x_enable(dev);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(bmp18x_spi_pm_ops, bmp18x_spi_suspend, bmp18x_spi_resume);
+
+static const struct spi_device_id bmp18x_id[] = {
+	{ BMP18X_NAME, 0 },
+	{ "bmp085", 0 },
+	{ "bmp180", 0 },
+	{ "bmp181", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, bmp18x_id);
+
+static struct spi_driver bmp18x_spi_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= BMP18X_NAME,
+		.pm	= &bmp18x_spi_pm_ops,
+	},
+	.id_table	= bmp18x_id,
+	.probe		= bmp18x_spi_probe,
+	.shutdown	= bmp18x_spi_shutdown,
+	.remove		= __devexit_p(bmp18x_spi_remove)
+};
+
+static int __init bmp18x_spi_init(void)
+{
+	return spi_register_driver(&bmp18x_spi_driver);
+}
+
+static void __exit bmp18x_spi_exit(void)
+{
+	spi_unregister_driver(&bmp18x_spi_driver);
+}
+
+MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
+MODULE_DESCRIPTION("BMP18X SPI bus driver");
+MODULE_LICENSE("GPL");
+
+module_init(bmp18x_spi_init);
+module_exit(bmp18x_spi_exit);
diff --git a/include/linux/i2c/bmp18x.h b/include/linux/i2c/bmp18x.h
new file mode 100644
index 0000000..30fa636
--- /dev/null
+++ b/include/linux/i2c/bmp18x.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2012  Bosch Sensortec GmbH
+ * Copyright (c) 2012  Unixphere AB
+ *
+ * Based on:
+ * BMP085 driver, bmp085.c
+ * Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _BMP18X_H
+#define _BMP18X_H
+
+#define BMP18X_NAME "bmp18x"
+
+/**
+ * struct bmp18x_platform_data - represents platform data for the bmp18x driver
+ * @chip_id: Configurable chip id for non-default chip revisions
+ * @default_oversampling: Default oversampling value to be used at startup,
+ * value range is 0-3 with rising sensitivity.
+ * @temp_measurement_period: Temperature measurement period (milliseconds), set
+ * to zero if unsure.
+ * @init_hw: Callback for hw specific startup
+ * @deinit_hw: Callback for hw specific shutdown
+ */
+struct bmp18x_platform_data {
+	u8	chip_id;
+	u8	default_oversampling;
+	u32	temp_measurement_period;
+	int	(*init_hw)(void);
+	void	(*deinit_hw)(void);
+};
+
+struct bmp18x_bus_ops {
+	int	(*read_block)(void *client, u8 reg, int len, char *buf);
+	int	(*read_byte)(void *client, u8 reg);
+	int	(*write_byte)(void *client, u8 reg, u8 value);
+};
+
+struct bmp18x_data_bus {
+	const struct bmp18x_bus_ops	*bops;
+	void	*client;
+};
+
+int bmp18x_probe(struct device *dev, struct bmp18x_data_bus *data_bus);
+int bmp18x_remove(struct device *dev);
+#ifdef CONFIG_PM
+int bmp18x_enable(struct device *dev);
+int bmp18x_disable(struct device *dev);
+#endif
+
+#endif
-- 
1.7.3.4

