Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0L2Mp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:45:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44848 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab0L2MpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=X0lwPHN48rPzZAk3xedIQLReD7MviUx2AL1sJa1ZVDtkQUZW4RJexInRjPpHjFGWfT
         P6VKDUe+42UaLRDMaZ9OejU+knhnyJiqcqYTrzxPX4GlYvnI/aYnFPswjm2ue2O+O+Ws
         Mf2eUowi4kLJDSVm8GeEfIVkDGKb+b1UWHz8M=
Date: Wed, 29 Dec 2010 13:45:11 +0100
From: Urs Fleisch <urs.fleisch@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: driver for Sensirion SHT21 humidity and temperature
 sensor
Message-Id: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a driver for the new humidity and temperature sensors SHT21 and SHT25 from Sensirion.

Regards,
Urs


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
@@ -0,0 +1,392 @@
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
+enum sht21_command {
+	SHT21_TRIG_T_MEASUREMENT_HM    = 0xe3,
+	SHT21_TRIG_RH_MEASUREMENT_HM   = 0xe5,
+	SHT21_TRIG_T_MEASUREMENT_POLL  = 0xf3,
+	SHT21_TRIG_RH_MEASUREMENT_POLL = 0xf5,
+	SHT21_USER_REG_W               = 0xe6,
+	SHT21_USER_REG_R               = 0xe7,
+	SHT21_SOFT_RESET               = 0xfe
+};
+
+/* User register bit masks */
+enum sht21_userreg {
+	SHT21_RES_12_14BIT   = 0x00,
+	SHT21_RES_8_12BIT    = 0x01,
+	SHT21_RES_10_13BIT   = 0x80,
+	SHT21_RES_11_11BIT   = 0x81,
+	SHT21_RES_MASK       = 0x81,
+	SHT21_END_OF_BATTERY = 0x40,
+	SHT21_ENABLE_HEATER  = 0x04,
+	SHT21_WRITABLE_MASK  = 0x87
+};
+
+/* Types of measurements */
+enum sht21_measurement_index {
+	SHT21_TEMPERATURE,
+	SHT21_HUMIDITY,
+	SHT21_NUM_MEASUREMENTS
+};
+
+/**
+ * struct sht21 - SHT21 device specific data
+ * @hwmon_dev: device registered with hwmon
+ * @lock: mutex to ensure only one I2C transfer in progress at a time
+ * @userreg_orig: original value of user register
+ * @valid: !=0 if measurements are valid
+ * @last_update: time of last update (jiffies)
+ * @measurements: cached measurement values, temperature and humidity
+ */
+struct sht21 {
+	struct device *hwmon_dev;
+	struct mutex lock;
+	u8 userreg_orig;
+	char valid;
+	unsigned long last_update;
+	int measurements[SHT21_NUM_MEASUREMENTS];
+};
+
+/* I2C command to be used for a specifc measurement */
+static u8 sht21_measurement_commands[SHT21_NUM_MEASUREMENTS] = {
+	SHT21_TRIG_T_MEASUREMENT_HM,
+	SHT21_TRIG_RH_MEASUREMENT_HM
+};
+
+/**
+ * sht21_temp_ticks_to_millicelsius() - convert raw temperature ticks to
+ * milli celsius
+ * @ticks: temperature ticks value received from sensor
+ */
+static int sht21_temp_ticks_to_millicelsius(int ticks)
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
+static int sht21_rh_ticks_to_per_cent_mille(int ticks)
+{
+	ticks &= ~0x0003; /* clear status bits */
+	/* Formula RH = -6 + 125 * SRH / 2^16 from data sheet 6.1,
+	   optimized for integer fixed point (3 digits) arithmetic */
+	return ((15625 * ticks) >> 13) - 6000;
+}
+
+typedef int (*convert_func)(int);
+
+/* Conversion function to be used for a specifc measurement */
+static convert_func sht21_convert_raw_value[SHT21_NUM_MEASUREMENTS] = {
+	sht21_temp_ticks_to_millicelsius,
+	sht21_rh_ticks_to_per_cent_mille
+};
+
+/**
+ * sht21_update_measurements() - get updated measurements from device
+ * @client: I2C client device
+ *
+ * Returns SHT21 client data containing measurements.
+ */
+static struct sht21 *sht21_update_measurements(struct i2c_client *client)
+{
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+
+	mutex_lock(&sht21->lock);
+	/* Data sheet 2.4:
+	 * SHT2x should not be active for more than 10% of the time - e.g. maximum
+	 * two measurements per second at 12bit accuracy shall be made. */
+	if (time_after(jiffies, sht21->last_update + HZ / 2) || !sht21->valid) {
+		int meas_idx;
+		for (meas_idx = 0; meas_idx < SHT21_NUM_MEASUREMENTS; ++meas_idx) {
+			int result = i2c_smbus_read_word_data(client,
+			  sht21_measurement_commands[meas_idx]);
+			/* SMBus specifies low byte first, but the SHT21 returns MSB first,
+			 * so we have to swab16 the values */
+			if (result >= 0)
+				sht21->measurements[meas_idx] =
+				  sht21_convert_raw_value[meas_idx](swab16(result));
+		}
+		sht21->last_update = jiffies;
+		sht21->valid = 1;
+	}
+	mutex_unlock(&sht21->lock);
+
+	return sht21;
+}
+
+/**
+ * sht21_show_measurement() - show measurement value in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where measurement values are written to
+ *
+ * Will be called on read access to a measurement sysfs attribute.
+ * Returns number of bytes written into buffer.
+ */
+static ssize_t sht21_show_measurement(struct device *dev,
+        struct device_attribute *attr,
+        char *buf)
+{
+	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
+	struct sht21 *sht21 = sht21_update_measurements(to_i2c_client(dev));
+
+	return sprintf(buf, "%d\n", sht21->measurements[sda->index]);
+}
+
+/**
+ * sht21_show_userreg() - show user register value in sysfs
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer (PAGE_SIZE) where user register value is written to
+ *
+ * Will be called on read access to user_register sysfs attribute.
+ * Returns number of bytes written into buffer, -EIO on error.
+ */
+static ssize_t sht21_show_userreg(struct device *dev,
+        struct device_attribute *attr,
+        char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+	int result;
+	mutex_lock(&sht21->lock);
+	result = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	mutex_unlock(&sht21->lock);
+
+	return result >= 0 ? sprintf(buf, "%d\n", result) : -EIO;
+}
+
+/**
+ * sht21_store_userreg() - store sysfs value in user register
+ * @dev: device
+ * @attr: device attribute
+ * @buf: sysfs buffer containing value as string
+ * @count: number of characters in @buf
+ *
+ * Will be called on write access to user_register sysfs attribute.
+ * Returns @count, -EIO on error.
+ */
+static ssize_t sht21_store_userreg(struct device *dev, struct device_attribute *attr,
+        const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+	int result;
+	char *endptr;
+	unsigned long value = simple_strtoul(buf, &endptr, 0);
+	if (endptr == buf || value > 0xff)
+		return -EINVAL;
+
+	mutex_lock(&sht21->lock);
+	result = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	if (result >= 0)
+		result = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W,
+		  (result & ~SHT21_WRITABLE_MASK) | (value & SHT21_WRITABLE_MASK));
+	mutex_unlock(&sht21->lock);
+
+	return result >= 0 ? count : -EIO;
+}
+
+/* sysfs attributes */
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, sht21_show_measurement,
+  NULL, SHT21_TEMPERATURE);
+static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO, sht21_show_measurement,
+  NULL, SHT21_HUMIDITY);
+static SENSOR_DEVICE_ATTR(user_register, S_IRUGO | S_IWUSR, sht21_show_userreg,
+  sht21_store_userreg, 0);
+
+static struct attribute *sht21_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_humidity1_input.dev_attr.attr,
+	&sensor_dev_attr_user_register.dev_attr.attr,
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
+        const struct i2c_device_id *id)
+{
+	struct sht21 *sht21;
+	int status;
+	u8 userreg_changed;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
+		dev_err(&client->dev, "adapter does not support SMBus word transactions\n");
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
+	sht21->userreg_orig = status;
+
+	userreg_changed = status ^ SHT21_RES_MASK;
+	status = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, userreg_changed);
+	if (status < 0) {
+		dev_err(&client->dev, "error writing user register\n");
+		goto fail_restore_config;
+	}
+	status = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	if (status < 0) {
+		dev_err(&client->dev, "error reading user register\n");
+		goto fail_restore_config;
+	}
+	if (status != userreg_changed) {
+		dev_err(&client->dev, "user register settings did not stick\n");
+		status = -ENODEV;
+		goto fail_restore_config;
+	}
+	status = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, sht21->userreg_orig);
+	if (status < 0) {
+		dev_err(&client->dev, "error restoring user register\n");
+		goto fail_restore_config;
+	}
+	sht21->last_update = jiffies - HZ;
+	mutex_init(&sht21->lock);
+
+	status = sysfs_create_group(&client->dev.kobj, &sht21_attr_group);
+	if (status) {
+		dev_dbg(&client->dev, "could not create sysfs files\n");
+		goto fail_restore_config;
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
+fail_restore_config:
+	i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, sht21->userreg_orig);
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
+	int status;
+
+	hwmon_device_unregister(sht21->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &sht21_attr_group);
+
+	status = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
+	if (status >= 0 && status != sht21->userreg_orig) {
+		i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, sht21->userreg_orig);
+	}
+
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
