Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1AFHnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 02:43:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56017 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1AFHnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 02:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kymHjZ6awDgqvfrSeHH/CHXMHDHsUOZ83t8Q+PHW7JAGS4l7bUzkK4BQRq63RvnLBe
         cfK9xlKJOYxvK824W21BvN1L+HqYVKrppYWTvSVYOKKGFqd1ZTtk0fTB2goelR2h/azA
         JIudnDhF+GcPtw8xPjwTp6bQatUwFhXjlI9hQ=
Date: Thu, 6 Jan 2011 08:43:38 +0100
From: Urs Fleisch <urs.fleisch@gmail.com>
To: guenter.roeck@ericsson.com
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH V4] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-Id: <20110106084338.d31624e3.urs.fleisch@gmail.com>
In-Reply-To: <1294170132.9786.52.camel@groeck-laptop>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
	<4D1DF097.1080200@cam.ac.uk>
	<20110103081448.f96c413e.urs.fleisch@gmail.com>
	<4D21ADCB.4070206@cam.ac.uk>
	<1294078159.9786.9.camel@groeck-laptop>
	<4D230ED0.8060008@cam.ac.uk>
	<20110104152837.GA32138@ericsson.com>
	<20110104200001.3328dae3.urs.fleisch@gmail.com>
	<1294170132.9786.52.camel@groeck-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review, Jonathan and Guenter.

Changes:
- removed user register related sysfs attributes, keeping only temp1_input and
  humidity1_input
- cleaned up code flow when returning errors for better readability

Regards,
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
@@ -0,0 +1,300 @@
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
+/* I2C command bytes */
+#define SHT21_TRIG_T_MEASUREMENT_HM  0xe3
+#define SHT21_TRIG_RH_MEASUREMENT_HM 0xe5
+
+/**
+ * struct sht21 - SHT21 device specific data
+ * @hwmon_dev: device registered with hwmon
+ * @lock: mutex to protect measurement values
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
+ * sht21_read_word_data() - read word from register
+ * @client: I2C client device
+ * @reg: I2C command byte
+ *
+ * Returns value, negative errno on error.
+ */
+static inline int sht21_read_word_data(struct i2c_client *client, u8 reg)
+{
+	int ret = i2c_smbus_read_word_data(client, reg);
+	if (ret < 0)
+		return ret;
+	/* SMBus specifies low byte first, but the SHT21 returns MSB
+	 * first, so we have to swab16 the values */
+	return swab16(ret);
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
+	int ret = 0;
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+
+	mutex_lock(&sht21->lock);
+	/* Data sheet 2.4:
+	 * SHT2x should not be active for more than 10% of the time - e.g.
+	 * maximum two measurements per second at 12bit accuracy shall be made.
+	 */
+	if (time_after(jiffies, sht21->last_update + HZ / 2) || !sht21->valid) {
+		ret = sht21_read_word_data(client, SHT21_TRIG_T_MEASUREMENT_HM);
+		if (ret < 0)
+			goto out;
+		sht21->temperature = sht21_temp_ticks_to_millicelsius(ret);
+		ret = sht21_read_word_data(client,
+					SHT21_TRIG_RH_MEASUREMENT_HM);
+		if (ret < 0)
+			goto out;
+		sht21->humidity = sht21_rh_ticks_to_per_cent_mille(ret);
+		sht21->last_update = jiffies;
+		sht21->valid = 1;
+	}
+out:
+	mutex_unlock(&sht21->lock);
+
+	return ret >= 0 ? 0 : ret;
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
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+	int ret = sht21_update_measurements(client);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%d\n", sht21->temperature);
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
+	struct sht21 *sht21 = i2c_get_clientdata(client);
+	int ret = sht21_update_measurements(client);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%d\n", sht21->humidity);
+}
+
+/* sysfs attributes */
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, sht21_show_temperature,
+	NULL, 0);
+static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO, sht21_show_humidity,
+	NULL, 0);
+
+static struct attribute *sht21_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_humidity1_input.dev_attr.attr,
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
+	int err;
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
+	mutex_init(&sht21->lock);
+
+	err = sysfs_create_group(&client->dev.kobj, &sht21_attr_group);
+	if (err) {
+		dev_dbg(&client->dev, "could not create sysfs files\n");
+		goto fail_free;
+	}
+	sht21->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(sht21->hwmon_dev)) {
+		dev_dbg(&client->dev, "unable to register hwmon device\n");
+		err = PTR_ERR(sht21->hwmon_dev);
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
+	return err;
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
