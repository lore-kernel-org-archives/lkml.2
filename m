Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1ACOCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:02:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1ACOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=J0h2P69wbzt2N0pt8TQmZUhd38UfEVho5JonpA44jhm5Xm/VyfP6e6FbMllsHmnmNi
         BT46t6HAG30TIPIlivcULsAzQ5eoPd3MruU41ma9lEvW2RPFFDfKW0rqhyPKL+mLinqM
         iCND7wcz9jexK6XirKiOddmVMzVaidD0TuknI=
Date: Mon, 3 Jan 2011 15:01:34 +0100
From: Urs Fleisch <urs.fleisch@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH V3] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-Id: <20110103150134.e4858844.urs.fleisch@gmail.com>
In-Reply-To: <4D21ADCB.4070206@cam.ac.uk>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
	<4D1DF097.1080200@cam.ac.uk>
	<20110103081448.f96c413e.urs.fleisch@gmail.com>
	<4D21ADCB.4070206@cam.ac.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

> Is there actualy a use case that means these can't both be set
> by platform data?  Also, if these are acceptable, should they have
> some means of indicating which combination of values are available?

I can imagine a use case where an embedded device wants to operate in a
low-power mode while still monitoring humidity and/or temperature. Measurement
time and thus power consumption of the SHT21 are significantly smaller when
using a low resolution. Or you can use a low resolution while waiting for a
significant change in humidity and/or temperature and then switch to a higher
resolution to actually report the measurement values.

> Rely on platform data to get this right rather than an adhoc test that
> might well pass on some random devices.

I removed that probing stuff. As read and write addresses for the user
register are different, it would probably not pass on another device, but it
could disturb another device.

> Sorry to say I missed some error handling issues the first time around.
> Please always provide userspace with the most detailed and correct error
> possible. Normally this is the one comming up from the bus subsystem.

All error codes should now be passed up to userspace.

Thanks again,
Urs

Signed-off-by: Urs Fleisch <urs.fleisch@sensirion.com>
---
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 95ccbe3..4a96429 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -688,6 +688,16 @@ config SENSORS_SHT15
 	  This driver can also be built as a module.  If so, the module
 	  will be called sht15.
 
+config SENSORS_SHT21
+	tristate "Sensiron humidity and temperature sensors. SHT21 and compat."
+	depends on I2C
+	help
+	  If you say yes here you get support for the Sensiron SHT21, SHT25
+	  humidity and temperature sensors.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called sht21.
+
 config SENSORS_S3C
 	tristate "S3C24XX/S3C64XX Inbuilt ADC"
 	depends on ARCH_S3C2410
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 33c2ee1..7439653 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
 obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
 obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
+obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
 obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
 obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
 obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
diff --git a/drivers/hwmon/sht21.c b/drivers/hwmon/sht21.c
new file mode 100644
index 0000000..7d3ec82
--- /dev/null
+++ b/drivers/hwmon/sht21.c
@@ -0,0 +1,592 @@
+/* Sensirion SHT21 humidity and temperature sensor driver
+ *
+ * Copyright (C) 2010 Urs Fleisch <urs.fleisch@sensirion.com>
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Data sheet available (5/2010) at
+ * http://www.sensirion.com/en/pdf/product_information/Datasheet-humidity-sensor-SHT21.pdf
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+
+/* I2C commands bytes */
+#define SHT21_TRIG_T_MEASUREMENT_HM  0xe3
+#define SHT21_TRIG_RH_MEASUREMENT_HM 0xe5
+#define SHT21_USER_REG_W             0xe6
+#define SHT21_USER_REG_R             0xe7
+
+/* User register bit masks */
+#define SHT21_RES_12_14BIT   0x00
+#define SHT21_RES_8_12BIT    0x01
+#define SHT21_RES_10_13BIT   0x80
+#define SHT21_RES_11_11BIT   0x81
+#define SHT21_RES_MASK       0x81
+#define SHT21_END_OF_BATTERY 0x40
+#define SHT21_ENABLE_HEATER  0x04
+
+/**
+ * struct sht21 - SHT21 device specific data
+ * @hwmon_dev: device registered with hwmon
+ * @lock: mutex to protect measurement values and read-modify-write access to
+ * user register
+ * @valid: only 0 before first measurement is taken
+ * @last_update: time of last update (jiffies)
+ * @temperature: cached temperature measurement value
+ * @humidity: cached humidity measurement value
+ */
+struct sht21 {
+	struct device *hwmon_dev;
+	struct mutex lock;
+	char valid;
+	unsigned long last_update;
+	int temperature;
+	int humidity;
+};
+
+/**
+ * sht21_temp_ticks_to_millicelsius() - convert raw temperature ticks to
+ * milli celsius
+ * @ticks: temperature ticks value received from sensor
+ */
+static inline int sht21_temp_ticks_to_millicelsius(int ticks)
+{
+	ticks &= ~0x0003; /* clear status bits */
+	/* Formula T = -46.85 + 175.72 * ST / 2^16 from data sheet 6.2,
+	   optimized for integer fixed point (3 digits) arithmetic */
+	return ((21965 * ticks) >> 13) - 46850;
+}
+
+/**
+ * sht21_rh_ticks_to_per_cent_mille() - convert raw humidity ticks to
+ * one-thousandths of a percent relative humidity
+ * @ticks: humidity ticks value received from sensor
+ */
+static inline int sht21_rh_ticks_to_per_cent_mille(int ticks)
+{
+	ticks &= ~0x0003; /* clear status bits */
+	/* Formula RH = -6 + 125 * SRH / 2^16 from data sheet 6.1,
+	   optimized for integer fixed point (3 digits) arithmetic */
+	return ((15625 * ticks) >> 13) - 6000;
+}
+
+/**
+ * sht21_update_measurements() - get updated measurements from device
+ * @client: I2C client device
+ *
+ * Returns 0 on success, else negative errno.
+ */
+static int sht21_update_measurements(struct i2c_client *client)
+{
+	int result = 0;
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+
+	mutex_lock(&sht21->lock);
+	/* Data sheet 2.4:
+	 * SHT2x should not be active for more than 10% of the time - e.g.
+	 * maximum two measurements per second at 12bit accuracy shall be made.
+	 */
+	if (time_after(jiffies, sht21->last_update + HZ / 2) || !sht21->valid) {
+		result = i2c_smbus_read_word_data(client,
+				SHT21_TRIG_T_MEASUREMENT_HM);
+		/* SMBus specifies low byte first, but the SHT21 returns MSB
+		 * first, so we have to swab16 the values */
+		if (result >= 0) {
+			sht21->temperature = sht21_temp_ticks_to_millicelsius(
+				swab16(result));
+			result = i2c_smbus_read_word_data(client,
+					SHT21_TRIG_RH_MEASUREMENT_HM);
+			if (result >= 0) {
+				sht21->humidity =
+					sht21_rh_ticks_to_per_cent_mille(
+						swab16(result));
+				sht21->last_update = jiffies;
+				sht21->valid = 1;
+			}
+		}
+	}
+	mutex_unlock(&sht21->lock);
+
+	return result >= 0 ? 0 : result;
+}
+
+/**
+ * sht21_show_temperature() - show temperature measurement value in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where measurement values are written to
+ *
+ * Will be called on read access to temp1_input sysfs attribute.
+ * Returns number of bytes written into buffer, negative errno on error.
+ */
+static ssize_t sht21_show_temperature(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int result = sht21_update_measurements(client);
+	if (result >= 0) {
+		struct sht21 *sht21 = i2c_get_clientdata(client);
+
+		return sprintf(buf, "%d\n", sht21->temperature);
+	}
+	return result;
+}
+
+/**
+ * sht21_show_humidity() - show humidity measurement value in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where measurement values are written to
+ *
+ * Will be called on read access to humidity1_input sysfs attribute.
+ * Returns number of bytes written into buffer, negative errno on error.
+ */
+static ssize_t sht21_show_humidity(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int result = sht21_update_measurements(client);
+	if (result >= 0) {
+		struct sht21 *sht21 = i2c_get_clientdata(client);
+
+		return sprintf(buf, "%d\n", sht21->humidity);
+	}
+	return result;
+}
+
+/**
+ * sht21_read_user_register() - read user register
+ * @dev: device
+ *
+ * Returns byte value of user register, negative errno on error.
+ */
+static s32 sht21_read_user_register(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+	s32 result;
+	mutex_lock(&sht21->lock);
+	result = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	mutex_unlock(&sht21->lock);
+	return result;
+}
+
+/**
+ * sht21_modify_user_register() - modify user register
+ * @dev: device
+ * @mask: mask of bits to modify
+ * @value: bits to write into user register
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static s32 sht21_modify_user_register(struct device *dev, u8 mask, u8 value)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+	s32 result;
+
+	mutex_lock(&sht21->lock);
+	result = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	if (result >= 0)
+		result = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W,
+		  (result & ~mask) | (value & mask));
+	mutex_unlock(&sht21->lock);
+
+	return result;
+}
+
+/**
+ * sht21_show_temperature_resolution() - show temperature measurement resolution
+ * bits in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where user register value is written to
+ *
+ * Will be called on read access to temp1_resolution_bits sysfs attribute.
+ * Writes "11", "12", "13" or "14".
+ * Returns number of bytes written into buffer, negative errno on error.
+ */
+static ssize_t sht21_show_temperature_resolution(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	s32 userreg = sht21_read_user_register(dev);
+	if (userreg >= 0) {
+		int resolution;
+		switch (userreg & SHT21_RES_MASK) {
+		case SHT21_RES_8_12BIT:
+			resolution = 12;
+			break;
+		case SHT21_RES_10_13BIT:
+			resolution = 13;
+			break;
+		case SHT21_RES_11_11BIT:
+			resolution = 11;
+			break;
+		case SHT21_RES_12_14BIT:
+		default:
+			resolution = 14;
+		}
+		return sprintf(buf, "%d\n", resolution);
+	}
+	return userreg;
+}
+
+/**
+ * sht21_store_temperature_resolution() - set temperature measurement resolution
+ * bits from sysfs value
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer containing value "11", "12", "13" or "14"
+ * @count: number of characters in @buf
+ *
+ * Will be called on write access to temp1_resolution_bits sysfs attribute.
+ * Returns @count, negative errno on error.
+ */
+static ssize_t sht21_store_temperature_resolution(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	s32 result;
+	u8 res_bits;
+	unsigned long value;
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;
+
+	switch (value) {
+	case 11:
+		res_bits = SHT21_RES_11_11BIT;
+		break;
+	case 12:
+		res_bits = SHT21_RES_8_12BIT;
+		break;
+	case 13:
+		res_bits = SHT21_RES_10_13BIT;
+		break;
+	case 14:
+		res_bits = SHT21_RES_12_14BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	result = sht21_modify_user_register(dev, SHT21_RES_MASK, res_bits);
+
+	return result >= 0 ? count : result;
+}
+
+/**
+ * sht21_show_humidity_resolution() - show humidity measurement resolution
+ * bits in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where user register value is written to
+ *
+ * Will be called on read access to humidity1_resolution_bits sysfs attribute.
+ * Writes "8", "10", "11" or "12".
+ * Returns number of bytes written into buffer, negative errno on error.
+ */
+static ssize_t sht21_show_humidity_resolution(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	s32 userreg = sht21_read_user_register(dev);
+	if (userreg >= 0) {
+		int resolution;
+		switch (userreg & SHT21_RES_MASK) {
+		case SHT21_RES_8_12BIT:
+			resolution = 8;
+			break;
+		case SHT21_RES_10_13BIT:
+			resolution = 10;
+			break;
+		case SHT21_RES_11_11BIT:
+			resolution = 11;
+			break;
+		case SHT21_RES_12_14BIT:
+		default:
+			resolution = 12;
+		}
+		return sprintf(buf, "%d\n", resolution);
+	}
+	return userreg;
+}
+
+/**
+ * sht21_store_humidity_resolution() - set humidity measurement resolution
+ * bits from sysfs value
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer containing value "8", "10", "11" or "12"
+ * @count: number of characters in @buf
+ *
+ * Will be called on write access to humidity1_resolution_bits sysfs attribute.
+ * Returns @count, negative errno on error.
+ */
+static ssize_t sht21_store_humidity_resolution(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	s32 result;
+	u8 res_bits;
+	unsigned long value;
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;
+
+	switch (value) {
+	case 8:
+		res_bits = SHT21_RES_8_12BIT;
+		break;
+	case 10:
+		res_bits = SHT21_RES_10_13BIT;
+		break;
+	case 11:
+		res_bits = SHT21_RES_11_11BIT;
+		break;
+	case 12:
+		res_bits = SHT21_RES_12_14BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	result = sht21_modify_user_register(dev, SHT21_RES_MASK, res_bits);
+
+	return result >= 0 ? count : result;
+}
+
+/**
+ * sht21_show_end_of_battery() - show end of battery state in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where user register value is written to
+ *
+ * Will be called on read access to in0_min_alarm sysfs attribute.
+ * Writes "1" if VDD < 2.25V, else "0".
+ * Returns number of bytes written into buffer, negative errno on error.
+ */
+static ssize_t sht21_show_end_of_battery(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	s32 userreg = sht21_read_user_register(dev);
+	if (userreg >= 0)
+		return sprintf(buf, "%u\n", !!(userreg & SHT21_END_OF_BATTERY));
+	else
+		return userreg;
+}
+
+/**
+ * sht21_show_heater_enable() - show on-chip heater state in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where user register value is written to
+ *
+ * Will be called on read access to heater_enable sysfs attribute.
+ * Writes "1" if heater is enabled, else "0".
+ * Returns number of bytes written into buffer, negative errno on error.
+ */
+static ssize_t sht21_show_heater_enable(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	s32 userreg = sht21_read_user_register(dev);
+	if (userreg >= 0)
+		return sprintf(buf, "%u\n", !!(userreg & SHT21_ENABLE_HEATER));
+	else
+		return userreg;
+}
+
+/**
+ * sht21_store_heater_enable() - enable or disable heater from sysfs value
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer containing value "0" or "1"
+ * @count: number of characters in @buf
+ *
+ * Will be called on write access to heater_enable sysfs attribute.
+ * Returns @count, negative errno on error.
+ */
+static ssize_t sht21_store_heater_enable(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	s32 result;
+	unsigned long value;
+	if (strict_strtoul(buf, 10, &value) || value > 1)
+		return -EINVAL;
+
+	result = sht21_modify_user_register(dev, SHT21_ENABLE_HEATER,
+					    value ? SHT21_ENABLE_HEATER : 0);
+
+	return result >= 0 ? count : result;
+}
+
+
+/* sysfs attributes */
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, sht21_show_temperature,
+	NULL, 0);
+static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO, sht21_show_humidity,
+	NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_resolution_bits, S_IRUGO | S_IWUSR,
+	sht21_show_temperature_resolution, sht21_store_temperature_resolution,
+	0);
+static SENSOR_DEVICE_ATTR(humidity1_resolution_bits, S_IRUGO | S_IWUSR,
+	sht21_show_humidity_resolution, sht21_store_humidity_resolution, 0);
+static SENSOR_DEVICE_ATTR(in0_min_alarm, S_IRUGO, sht21_show_end_of_battery,
+	NULL, 0);
+static SENSOR_DEVICE_ATTR(heater_enable, S_IRUGO | S_IWUSR,
+	sht21_show_heater_enable, sht21_store_heater_enable, 0);
+
+static struct attribute *sht21_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_humidity1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_resolution_bits.dev_attr.attr,
+	&sensor_dev_attr_humidity1_resolution_bits.dev_attr.attr,
+	&sensor_dev_attr_in0_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_heater_enable.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group sht21_attr_group = {
+	.attrs = sht21_attributes,
+};
+
+/**
+ * sht21_probe() - probe device
+ * @client: I2C client device
+ * @id: device ID
+ *
+ * Called by the I2C core when an entry in the ID table matches a
+ * device's name.
+ * Returns 0 on success.
+ */
+static int __devinit sht21_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct sht21 *sht21;
+	int status;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_WORD_DATA)) {
+		dev_err(&client->dev,
+			"adapter does not support SMBus word transactions\n");
+		return -ENODEV;
+	}
+
+	sht21 = kzalloc(sizeof(*sht21), GFP_KERNEL);
+	if (!sht21) {
+		dev_dbg(&client->dev, "kzalloc failed\n");
+		return -ENOMEM;
+	}
+	i2c_set_clientdata(client, sht21);
+
+	status = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	if (status < 0) {
+		dev_err(&client->dev, "error reading user register\n");
+		goto fail_free;
+	}
+
+	mutex_init(&sht21->lock);
+
+	status = sysfs_create_group(&client->dev.kobj, &sht21_attr_group);
+	if (status) {
+		dev_dbg(&client->dev, "could not create sysfs files\n");
+		goto fail_free;
+	}
+	sht21->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(sht21->hwmon_dev)) {
+		dev_dbg(&client->dev, "unable to register hwmon device\n");
+		status = PTR_ERR(sht21->hwmon_dev);
+		goto fail_remove_sysfs;
+	}
+
+	dev_info(&client->dev, "initialized\n");
+
+	return 0;
+
+fail_remove_sysfs:
+	sysfs_remove_group(&client->dev.kobj, &sht21_attr_group);
+fail_free:
+	kfree(sht21);
+
+	return status;
+}
+
+/**
+ * sht21_remove() - remove device
+ * @client: I2C client device
+ */
+static int __devexit sht21_remove(struct i2c_client *client)
+{
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+
+	hwmon_device_unregister(sht21->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &sht21_attr_group);
+	kfree(sht21);
+
+	return 0;
+}
+
+/* Device ID table */
+static const struct i2c_device_id sht21_id[] = {
+	{ "sht21", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, sht21_id);
+
+static struct i2c_driver sht21_driver = {
+	.driver.name = "sht21",
+	.probe       = sht21_probe,
+	.remove      = __devexit_p(sht21_remove),
+	.id_table    = sht21_id,
+};
+
+/**
+ * sht21_init() - initialize driver
+ *
+ * Called when kernel is booted or module is inserted.
+ * Returns 0 on success.
+ */
+static int __init sht21_init(void)
+{
+	return i2c_add_driver(&sht21_driver);
+}
+module_init(sht21_init);
+
+/**
+ * sht21_init() - clean up driver
+ *
+ * Called when module is removed.
+ */
+static void __exit sht21_exit(void)
+{
+	i2c_del_driver(&sht21_driver);
+}
+module_exit(sht21_exit);
+
+MODULE_AUTHOR("Urs Fleisch <urs.fleisch@sensirion.com>");
+MODULE_DESCRIPTION("Sensirion SHT21 humidity and temperature sensor driver");
+MODULE_LICENSE("GPL");
