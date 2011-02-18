Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1BRKQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:16:09 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:47226 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab1BRKQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:16:05 -0500
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: khali@linux-fr.org, guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH v3] hwmon: Add support for Texas Instruments ADS1015
Date: Fri, 18 Feb 2011 11:15:58 +0100
Message-Id: <1298024158-21076-1-git-send-email-eibach@gdsys.de>
In-Reply-To: <20110217134203.0556a7ab@endymion.delvare>
References: <20110217134203.0556a7ab@endymion.delvare>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110218101601Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.170; VDF: 7.11.3.131; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
Changes since v1:
- fixed/extended Documentation
- removed unused register definitions
- hardcoded PGA fullscale table size
- made sure patch applies against v2.6.38-rc4
- reordered functions to avoid forward declaration
- results from i2c_smbus_read_word_data() are handled correctly
- moved locking into ads1015_read_value()
- removed unnecessray clearing of bit
- proper error handling in ads1015_read_value()
- use DIV_ROUND_CLOSEST for scaling result
- removed detect()

Changes since v2:
- removed *all* leftovers from detect()
- fixed return with mutex held
- made sysfs representation configurable
  (hope this will be the reference implementation for generations to come ;)

 Documentation/hwmon/ads1015 |   72 +++++++++++
 drivers/hwmon/Kconfig       |   10 ++
 drivers/hwmon/Makefile      |    1 +
 drivers/hwmon/ads1015.c     |  295 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/ads1015.h |   30 +++++
 5 files changed, 408 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/ads1015
 create mode 100644 drivers/hwmon/ads1015.c
 create mode 100644 include/linux/i2c/ads1015.h

diff --git a/Documentation/hwmon/ads1015 b/Documentation/hwmon/ads1015
new file mode 100644
index 0000000..2494e99
--- /dev/null
+++ b/Documentation/hwmon/ads1015
@@ -0,0 +1,72 @@
+Kernel driver ads1015
+=====================
+
+Supported chips:
+  * Texas Instruments ADS1015
+    Prefix: 'ads1015'
+    Datasheet: Publicly available at the Texas Instruments website :
+               http://focus.ti.com/lit/ds/symlink/ads1015.pdf
+
+Authors:
+        Dirk Eibach, Guntermann & Drunck GmbH <eibach@gdsys.de>
+
+Description
+-----------
+
+This driver implements support for the Texas Instruments ADS1015.
+
+This device is a 12-bit A-D converter with 4 inputs.
+
+The inputs can be used single ended or in certain differential combinations.
+
+The inputs are mapped to 8 sysfs input files in0_input - in7_input.
+The mapping can be configured using platform data or devicetree.
+
+Data sources for configuration:
+0: Voltage over AIN0 and AIN1.
+1: Voltage over AIN0 and AIN3.
+2: Voltage over AIN1 and AIN3.
+3: Voltage over AIN2 and AIN3.
+4: Voltage over AIN0 and GND.
+5: Voltage over AIN1 and GND.
+6: Voltage over AIN2 and GND.
+7: Voltage over AIN3 and GND.
+Any other value: disable
+
+By default in0_input is mapped to source 0, in1_input to source 1 and so on.
+
+Platform Data
+-------------
+
+In linux/i2c/ads1015.h platform data is defined as:
+
+struct ads1015_platform_data {
+	int exported_channels[8];
+};
+
+exported_channels contains the data sources for the 8 sysfs input files.
+
+Example:
+struct ads1015_platform_data data = {
+	4, 2, -1, -1, -1, -1, -1, -1 };
+
+In this case only in0_input and in1_input would be created.
+in0_input would give the voltage over AIN0 and GND.
+in0_input would give the voltage over AIN1 and AIN3.
+
+Devicetree
+----------
+
+The ads1015 node may have an "exported-channels" property with 8 integer
+values. The 8 values are the data sources for the 8 sysfs input files.
+
+Example:
+ads1015@49 {
+	compatible = "ti,ads1015";
+	reg = <0x49>;
+	exported-channels = < 4 2 0xff 0xff 0xff 0xff 0xff 0xff >;
+};
+
+In this case only in0_input and in1_input would be created.
+in0_input would give the voltage over AIN0 and GND.
+in0_input would give the voltage over AIN1 and AIN3.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 773e484..7e247f7 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -871,6 +871,16 @@ config SENSORS_SMSC47B397
 	  This driver can also be built as a module.  If so, the module
 	  will be called smsc47b397.
 
+config SENSORS_ADS1015
+	tristate "Texas Instruments ADS1015"
+	depends on I2C
+	help
+	  If you say yes here you get support for Texas Instruments ADS1015
+	  12-bit 4-input ADC device.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ads1015.
+
 config SENSORS_ADS7828
 	tristate "Texas Instruments ADS7828"
 	depends on I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index dde02d9..aae4036 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_SENSORS_ADM1026)	+= adm1026.o
 obj-$(CONFIG_SENSORS_ADM1029)	+= adm1029.o
 obj-$(CONFIG_SENSORS_ADM1031)	+= adm1031.o
 obj-$(CONFIG_SENSORS_ADM9240)	+= adm9240.o
+obj-$(CONFIG_SENSORS_ADS1015)	+= ads1015.o
 obj-$(CONFIG_SENSORS_ADS7828)	+= ads7828.o
 obj-$(CONFIG_SENSORS_ADS7871)	+= ads7871.o
 obj-$(CONFIG_SENSORS_ADT7411)	+= adt7411.o
diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
new file mode 100644
index 0000000..cf7aff4
--- /dev/null
+++ b/drivers/hwmon/ads1015.c
@@ -0,0 +1,295 @@
+/*
+ * ads1015.c - lm_sensors driver for ads1015 12-bit 4-input ADC
+ * (C) Copyright 2010
+ * Dirk Eibach, Guntermann & Drunck GmbH <eibach@gdsys.de>
+ *
+ * Based on the ads7828 driver by Steve Hardy.
+ *
+ * Datasheet available at: http://focus.ti.com/lit/ds/symlink/ads1015.pdf
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
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/i2c/ads1015.h>
+
+/* ADS1015 registers */
+enum {
+	ADS1015_CONVERSION = 0,
+	ADS1015_CONFIG = 1,
+};
+
+/* PGA fullscale voltages in mV */
+static const unsigned int fullscale_table[8] = {
+	6144, 4096, 2048, 1024, 512, 256, 256, 256 };
+
+/* Default set of exported channels */
+#define ADS1015_CONFIG_CHANNELS 8
+static const int default_channels[ADS1015_CONFIG_CHANNELS] = {
+	0, 1, 2, 3, 4, 5, 6, 7 };
+
+/* strings for sysfs */
+static const char *input_names[8] = {
+	"in0_input",
+	"in1_input",
+	"in2_input",
+	"in3_input",
+	"in4_input",
+	"in5_input",
+	"in6_input",
+	"in7_input"
+};
+
+struct ads1015_data {
+	struct device *hwmon_dev;
+	struct mutex update_lock; /* mutex protect updates */
+	struct sensor_device_attribute attr[ADS1015_CONFIG_CHANNELS];
+	struct attribute *attr_table[ADS1015_CONFIG_CHANNELS + 1];
+	struct attribute_group attr_group;
+};
+
+static s32 ads1015_read_reg(struct i2c_client *client, unsigned int reg)
+{
+	s32 data = i2c_smbus_read_word_data(client, reg);
+
+	return (data < 0) ? data : swab16(data);
+}
+
+static s32 ads1015_write_reg(struct i2c_client *client, unsigned int reg,
+			     u16 val)
+{
+	return i2c_smbus_write_word_data(client, reg, swab16(val));
+}
+
+static int ads1015_read_value(struct i2c_client *client, unsigned int channel,
+			      int *value)
+{
+	u16 config;
+	s16 conversion;
+	unsigned int pga;
+	int fullscale;
+	unsigned int k;
+	struct ads1015_data *data = i2c_get_clientdata(client);
+	int res;
+
+	mutex_lock(&data->update_lock);
+
+	/* get fullscale voltage */
+	res = ads1015_read_reg(client, ADS1015_CONFIG);
+	if (res < 0)
+		goto err_unlock;
+	config = res;
+	pga = (config >> 9) & 0x0007;
+	fullscale = fullscale_table[pga];
+
+	/* set channel and start single conversion */
+	config &= ~(0x0007 << 12);
+	config |= (1 << 15) | (1 << 8) | (channel & 0x0007) << 12;
+
+	/* wait until conversion finished */
+	res = ads1015_write_reg(client, ADS1015_CONFIG, config);
+	if (res < 0)
+		goto err_unlock;
+	for (k = 0; k < 5; ++k) {
+		schedule_timeout(msecs_to_jiffies(1));
+		res = ads1015_read_reg(client, ADS1015_CONFIG);
+		if (res < 0)
+			goto err_unlock;
+		config = res;
+		if (config & (1 << 15))
+			break;
+	}
+	if (k == 5) {
+		res = -EIO;
+		goto err_unlock;
+	}
+
+	res = ads1015_read_reg(client, ADS1015_CONVERSION);
+	if (res < 0)
+		goto err_unlock;
+	conversion = res;
+
+	mutex_unlock(&data->update_lock);
+
+	*value = DIV_ROUND_CLOSEST(conversion * fullscale, 0x7ff0);
+
+	return 0;
+
+err_unlock:
+	mutex_unlock(&data->update_lock);
+	return res;
+}
+
+/* sysfs callback function */
+static ssize_t show_in(struct device *dev, struct device_attribute *da,
+	char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
+	struct i2c_client *client = to_i2c_client(dev);
+	int in;
+	int res;
+
+	res = ads1015_read_value(client, attr->index, &in);
+
+	return (res < 0) ? res : sprintf(buf, "%d\n", in);
+}
+
+/*
+ * Driver interface
+ */
+
+static int ads1015_remove(struct i2c_client *client)
+{
+	struct ads1015_data *data = i2c_get_clientdata(client);
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &data->attr_group);
+	kfree(data);
+	return 0;
+}
+
+static void ads1015_get_exported_channels(struct i2c_client *client,
+					  int *exported_channels)
+{
+	struct ads1015_platform_data *pdata = dev_get_platdata(&client->dev);
+#ifdef CONFIG_OF
+	struct device_node *np = client->dev.of_node;
+	const int *of_channels;
+	int of_channels_size;
+#endif
+
+	/* prefer platform data */
+	if (pdata) {
+		memcpy(exported_channels, pdata->exported_channels,
+		       sizeof(default_channels));
+		return;
+	}
+
+#ifdef CONFIG_OF
+	/* fallback on OF */
+	of_channels = of_get_property(np, "exported-channels",
+				      &of_channels_size);
+	if (of_channels && (of_channels_size == sizeof(default_channels))) {
+		memcpy(exported_channels, of_channels,
+		       sizeof(default_channels));
+		return;
+	}
+#endif
+
+	/* fallback on default configuration */
+	memcpy(exported_channels, default_channels, sizeof(default_channels));
+}
+
+/* create sysfs attribute according to channel setup */
+static struct attribute *ads1015_export_channel(struct i2c_client *client,
+						unsigned int input, int channel)
+{
+	struct ads1015_data *data = i2c_get_clientdata(client);
+	struct sensor_device_attribute attr =
+		SENSOR_ATTR(input, S_IRUGO, show_in, NULL, channel);
+
+	attr_name(attr.dev_attr) = input_names[input];
+
+	memcpy(&data->attr[input], &attr, sizeof(attr));
+
+	return &data->attr[input].dev_attr.attr;
+}
+
+static int ads1015_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct ads1015_data *data;
+	int err;
+	int exported_channels[ADS1015_CONFIG_CHANNELS];
+	unsigned int k;
+	unsigned int act_attr = 0;
+
+	data = kzalloc(sizeof(struct ads1015_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->update_lock);
+
+	/* Register sysfs hooks */
+	data->attr_group.attrs = data->attr_table;
+	ads1015_get_exported_channels(client, exported_channels);
+	for (k = 0; k < ADS1015_CONFIG_CHANNELS; ++k) {
+		int channel = exported_channels[k];
+		if ((channel < 0) || (channel > 7))
+			continue;
+		data->attr_table[act_attr++] =
+			ads1015_export_channel(client, k, channel);
+	}
+	err = sysfs_create_group(&client->dev.kobj, &data->attr_group);
+	if (err)
+		goto exit_free;
+
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		goto exit_remove;
+	}
+
+	return 0;
+
+exit_remove:
+	sysfs_remove_group(&client->dev.kobj, &data->attr_group);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static const struct i2c_device_id ads1015_id[] = {
+	{ "ads1015", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ads1015_id);
+
+static struct i2c_driver ads1015_driver = {
+	.driver = {
+		.name = "ads1015",
+	},
+	.probe = ads1015_probe,
+	.remove = ads1015_remove,
+	.id_table = ads1015_id,
+};
+
+static int __init sensors_ads1015_init(void)
+{
+	return i2c_add_driver(&ads1015_driver);
+}
+
+static void __exit sensors_ads1015_exit(void)
+{
+	i2c_del_driver(&ads1015_driver);
+}
+
+MODULE_AUTHOR("Dirk Eibach <eibach@gdsys.de>");
+MODULE_DESCRIPTION("ADS1015 driver");
+MODULE_LICENSE("GPL");
+
+module_init(sensors_ads1015_init);
+module_exit(sensors_ads1015_exit);
diff --git a/include/linux/i2c/ads1015.h b/include/linux/i2c/ads1015.h
new file mode 100644
index 0000000..152bf5f
--- /dev/null
+++ b/include/linux/i2c/ads1015.h
@@ -0,0 +1,30 @@
+/*
+ * Platform Data for ADS1015 12-bit 4-input ADC
+ * (C) Copyright 2010
+ * Dirk Eibach, Guntermann & Drunck GmbH <eibach@gdsys.de>
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
+#ifndef LINUX_ADS1015_H
+#define LINUX_ADS1015_H
+
+#include <linux/types.h>
+
+struct ads1015_platform_data {
+	int exported_channels[8];
+};
+
+#endif /* LINUX_ADS1015_H */
-- 
1.5.6.5

