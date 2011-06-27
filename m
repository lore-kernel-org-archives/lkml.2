Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1F0PtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:49:20 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:60552 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1F0PtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:49:15 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v2] hwmon: LM95245 driver
Date: Mon, 27 Jun 2011 17:49:09 +0200
Message-Id: <1309189749-7740-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110623153556.GG28311@ericsson.com>
References: <20110623153556.GG28311@ericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An hwmon driver for the National Semiconductor LM95245 dual temperature
sensors chip.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changes in v2:
* The diode mode isn't overwritten upon probe
* Added crit, crit_hyst, alarm, fault
* Added i2c address 0x29

I didn't change the signed/unsigned part. I also didn't include offset support.
Strangely enough the alarmfor remote (temp2) is set everytime I tested it,
where temp is at +47.4 C and crit is 110 C with hyst at 10 C. I don't have any
explanation for that.

 drivers/hwmon/Kconfig   |    9 +
 drivers/hwmon/Makefile  |    1 +
 drivers/hwmon/lm95245.c |  532 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 542 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/lm95245.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 16db83c..4c2400b 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -702,6 +702,15 @@ config SENSORS_LM95241
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm95241.
 
+config SENSORS_LM95245
+	tristate "National Semiconductor LM95245 sensor chip"
+	depends on I2C
+	help
+	  If you say yes here you get support for LM95245 sensor chip.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called lm95245.
+
 config SENSORS_MAX1111
 	tristate "Maxim MAX1111 Multichannel, Serial 8-bit ADC chip"
 	depends on SPI_MASTER
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 28061cf..5598712 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_SENSORS_LM90)	+= lm90.o
 obj-$(CONFIG_SENSORS_LM92)	+= lm92.o
 obj-$(CONFIG_SENSORS_LM93)	+= lm93.o
 obj-$(CONFIG_SENSORS_LM95241)	+= lm95241.o
+obj-$(CONFIG_SENSORS_LM95245)	+= lm95245.o
 obj-$(CONFIG_SENSORS_LTC4151)	+= ltc4151.o
 obj-$(CONFIG_SENSORS_LTC4215)	+= ltc4215.o
 obj-$(CONFIG_SENSORS_LTC4245)	+= ltc4245.o
diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
new file mode 100644
index 0000000..1d93086
--- /dev/null
+++ b/drivers/hwmon/lm95245.c
@@ -0,0 +1,532 @@
+/*
+ * Copyright (C) 2011 Alexander Stein <alexander.stein@systec-electronic.com>
+ *
+ * The LM95245 is a sensor chip made by National Semiconductors.
+ * It reports up to two temperatures (its own plus an external one).
+ * Complete datasheet can be obtained from National's website at:
+ *   http://www.national.com/ds.cgi/LM/LM95245.pdf
+ *
+ * This driver is based on lm95241.c
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
+#include <linux/sysfs.h>
+
+#define DEVNAME "lm95245"
+
+static const unsigned short normal_i2c[] = {
+	0x18, 0x19, 0x29, 0x4c, 0x4d, I2C_CLIENT_END };
+
+/* LM95245 registers */
+/* general registers */
+#define LM95245_REG_RW_CONFIG1		0x03
+#define LM95245_REG_RW_CONVERS_RATE	0x04
+#define LM95245_REG_W_ONE_SHOT		0x0F
+
+/* diode configuration */
+#define LM95245_REG_RW_CONFIG2		0xBF
+#define LM95245_REG_RW_REMOTE_OFFH	0x11
+#define LM95245_REG_RW_REMOTE_OFFL	0x12
+
+/* status registers */
+#define LM95245_REG_R_STATUS1		0x02
+#define LM95245_REG_R_STATUS2		0x33
+
+/* limit registers */
+#define LM95245_REG_RW_REMOTE_OS_LIMIT		0x07
+#define LM95245_REG_RW_LOCAL_OS_TCRIT_LIMIT	0x20
+#define LM95245_REG_RW_REMOTE_TCRIT_LIMIT	0x19
+#define LM95245_REG_RW_COMMON_HYSTERESIS	0x21
+
+/* temperature signed */
+#define LM95245_REG_R_LOCAL_TEMPH_S	0x00
+#define LM95245_REG_R_LOCAL_TEMPL_S	0x30
+#define LM95245_REG_R_REMOTE_TEMPH_S	0x01
+#define LM95245_REG_R_REMOTE_TEMPL_S	0x10
+/* temperature unsigned */
+#define LM95245_REG_R_REMOTE_TEMPH_U	0x31
+#define LM95245_REG_R_REMOTE_TEMPL_U	0x32
+
+/* id registers */
+#define LM95245_REG_R_MAN_ID		0xFE
+#define LM95245_REG_R_CHIP_ID		0xFF
+
+/* LM95245 specific bitfields */
+#define CFG_STOP		0x40
+#define CFG_REMOTE_TCRIT_MASK	0x10
+#define CFG_REMOTE_OS_MASK	0x08
+#define CFG_LOCAL_TCRIT_MASK	0x04
+#define CFG_LOCAL_OS_MASK	0x02
+
+#define CFG2_OS_A0		0x40
+#define CFG2_DIODE_FAULT_OS	0x20
+#define CFG2_DIODE_FAULT_TCRIT	0x10
+#define CFG2_REMOTE_TT		0x08
+#define CFG2_REMOTE_FILTER_DIS	0x00
+#define CFG2_REMOTE_FILTER_EN	0x06
+
+/* conversation rate in ms */
+#define RATE_CR0063 0x00
+#define RATE_CR0364 0x01
+#define RATE_CR1000 0x02
+#define RATE_CR2500 0x03
+
+#define STATUS1_BUSY		0x80
+#define STATUS1_ROS		0x10
+#define STATUS1_DIODE_FAULT	0x04
+#define STATUS1_RTCRIT		0x02
+#define STATUS1_LOC		0x01
+
+#define MANUFACTURER_ID 0x01
+#define DEFAULT_REVISION 0xB3
+
+static const u8 lm95245_reg_address[] = {
+	LM95245_REG_R_LOCAL_TEMPH_S,
+	LM95245_REG_R_LOCAL_TEMPL_S,
+	LM95245_REG_R_REMOTE_TEMPH_S,
+	LM95245_REG_R_REMOTE_TEMPL_S,
+	LM95245_REG_R_REMOTE_TEMPH_U,
+	LM95245_REG_R_REMOTE_TEMPL_U,
+	LM95245_REG_RW_LOCAL_OS_TCRIT_LIMIT,
+	LM95245_REG_RW_REMOTE_TCRIT_LIMIT,
+	LM95245_REG_RW_COMMON_HYSTERESIS,
+	LM95245_REG_R_STATUS1,
+};
+
+/* Client data (each client gets its own) */
+struct lm95245_data {
+	struct device *hwmon_dev;
+	struct mutex update_lock;
+	unsigned long last_updated;	/* in jiffies */
+	unsigned long interval;	/* in msecs */
+	char valid;		/* zero until following fields are valid */
+	/* registers values */
+	u8 temp[ARRAY_SIZE(lm95245_reg_address)];
+	u8 config1, config2;
+};
+
+/* Conversions */
+static int TempFromRegUnsigned(u8 val_h, u8 val_l)
+{
+	return val_h * 1000 + val_l * 1000 / 256;
+}
+
+static int TempFromRegSigned(u8 val_h, u8 val_l)
+{
+	if (val_h & 0x80)
+		return val_h - 0x100;
+	return TempFromRegUnsigned(val_h, val_l);
+}
+
+static struct lm95245_data *lm95245_update_device(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lm95245_data *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->update_lock);
+
+	if (time_after(jiffies, data->last_updated + msecs_to_jiffies(data->interval)) ||
+	    !data->valid) {
+		int i;
+
+		dev_dbg(&client->dev, "Updating lm95245 data.\n");
+		for (i = 0; i < ARRAY_SIZE(lm95245_reg_address); i++)
+			data->temp[i]
+			  = i2c_smbus_read_byte_data(client,
+						     lm95245_reg_address[i]);
+		data->last_updated = jiffies;
+		data->valid = 1;
+	}
+
+	mutex_unlock(&data->update_lock);
+
+	return data;
+}
+
+static unsigned long lm95245_set_conversation_rate(struct i2c_client *client, unsigned long interval)
+{
+	int rate;
+
+	if (interval < 63) {
+		interval = 63;
+		rate = RATE_CR0063;
+	} else if (interval < 364) {
+		interval = 364;
+		rate = RATE_CR0364;
+	} else if (interval < 1000) {
+		interval = 1000;
+		rate = RATE_CR1000;
+	} else {
+		interval = 2500;
+		rate = RATE_CR2500;
+	}
+
+	i2c_smbus_write_byte_data(client, LM95245_REG_RW_CONVERS_RATE, rate);
+
+	return interval;
+}
+
+/* Sysfs stuff */
+static ssize_t show_input(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct lm95245_data *data = lm95245_update_device(dev);
+	int temp;
+	int index = to_sensor_dev_attr(attr)->index;
+
+	/*
+	 * Index 0 (Local temp) is always signed
+	 * Index 2 (Remote temp) has both signed and unsigned data
+	 * use signed calculation for remote if signed bit is set
+	 */
+	if (index == 0 || data->temp[index] & 0x80)
+		temp = TempFromRegSigned(data->temp[index],
+			    data->temp[index + 1]);
+	else
+		temp = TempFromRegUnsigned(data->temp[index + 2],
+			    data->temp[index + 3]);
+
+	return snprintf(buf, PAGE_SIZE - 1, "%d\n", temp);
+}
+
+static ssize_t show_crit(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct lm95245_data *data = lm95245_update_device(dev);
+	int index = to_sensor_dev_attr(attr)->index;
+	int crit;
+
+	crit = TempFromRegUnsigned(data->temp[index], 0);
+
+	return snprintf(buf, PAGE_SIZE - 1, "%d\n", crit);
+}
+static ssize_t set_crit(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lm95245_data *data = i2c_get_clientdata(client);
+	int index = to_sensor_dev_attr(attr)->index;
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	val /= 1000;
+
+	val = SENSORS_LIMIT(val, 0, (index == 6 ? 127 : 256));
+
+	mutex_lock(&data->update_lock);
+
+	data->valid = 0;
+
+	if (index == 6)
+		/* local crit */
+		i2c_smbus_write_byte_data(client,
+			LM95245_REG_RW_LOCAL_OS_TCRIT_LIMIT, val);
+	else if (index == 7)
+		/* remote crit */
+		i2c_smbus_write_byte_data(client,
+			LM95245_REG_RW_REMOTE_TCRIT_LIMIT, val);
+	else
+		return -EINVAL;
+
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+static ssize_t set_crit_hyst(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lm95245_data *data = i2c_get_clientdata(client);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	val /= 1000;
+
+	val = SENSORS_LIMIT(val, 0, 31);
+
+	mutex_lock(&data->update_lock);
+
+	data->valid = 0;
+
+	/* shared crit hysteresis */
+	i2c_smbus_write_byte_data(client, LM95245_REG_RW_COMMON_HYSTERESIS, val);
+
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+static ssize_t show_type(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lm95245_data *data = i2c_get_clientdata(client);
+
+	return snprintf(buf, PAGE_SIZE - 1,
+		data->config2 & CFG2_REMOTE_TT ? "1\n" : "2\n");
+}
+static ssize_t set_type(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lm95245_data *data = i2c_get_clientdata(client);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+	if (val != 1 && val != 2)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+
+	if (val == 1)
+		data->config2 |= CFG2_REMOTE_TT;
+	else
+		data->config2 &= ~CFG2_REMOTE_TT;
+
+	data->valid = 0;
+
+	i2c_smbus_write_byte_data(client, LM95245_REG_RW_CONFIG2,
+				  data->config2);
+
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct lm95245_data *data = lm95245_update_device(dev);
+	int index = to_sensor_dev_attr(attr)->index;
+	bool alarm;
+
+	mutex_lock(&data->update_lock);
+
+	alarm = lm95245_reg_address[9] & index;
+
+	mutex_unlock(&data->update_lock);
+
+	return snprintf(buf, PAGE_SIZE - 1, "%d\n", !!alarm);
+}
+
+static ssize_t show_interval(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct lm95245_data *data = lm95245_update_device(dev);
+
+	return snprintf(buf, PAGE_SIZE - 1, "%lu\n", data->interval);
+}
+
+static ssize_t set_interval(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lm95245_data *data = i2c_get_clientdata(client);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+
+	data->interval = lm95245_set_conversation_rate(client, val);
+
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_input, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO, show_crit, set_crit, 6);
+static SENSOR_DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO, show_crit,
+		set_crit_hyst, 8);
+static SENSOR_DEVICE_ATTR(temp1_alarm, S_IRUGO, show_alarm, NULL, STATUS1_LOC);
+
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_input, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_crit, set_crit, 7);
+static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_crit,
+		set_crit_hyst, 8);
+static SENSOR_DEVICE_ATTR(temp2_type, S_IWUSR | S_IRUGO, show_type,
+		set_type, 0);
+static SENSOR_DEVICE_ATTR(temp2_alarm, S_IRUGO, show_alarm, NULL, STATUS1_RTCRIT);
+static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, STATUS1_DIODE_FAULT);
+
+static DEVICE_ATTR(update_interval, S_IWUSR | S_IRUGO, show_interval,
+		set_interval);
+
+static struct attribute *lm95245_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp1_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp2_type.dev_attr.attr,
+	&sensor_dev_attr_temp2_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_fault.dev_attr.attr,
+	&dev_attr_update_interval.attr,
+	NULL
+};
+
+static const struct attribute_group lm95245_group = {
+	.attrs = lm95245_attributes,
+};
+
+/* Return 0 if detection is successful, -ENODEV otherwise */
+static int lm95245_detect(struct i2c_client *new_client,
+			  struct i2c_board_info *info)
+{
+	struct i2c_adapter *adapter = new_client->adapter;
+	int address = new_client->addr;
+	const char *name;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	if ((i2c_smbus_read_byte_data(new_client, LM95245_REG_R_MAN_ID)
+	     == MANUFACTURER_ID)
+	    && (i2c_smbus_read_byte_data(new_client, LM95245_REG_R_CHIP_ID)
+		>= DEFAULT_REVISION)) {
+		name = DEVNAME;
+	} else {
+		dev_dbg(&adapter->dev, "LM95245 detection failed at 0x%02x\n",
+			address);
+		return -ENODEV;
+	}
+
+	/* Fill the i2c board info */
+	strlcpy(info->type, name, I2C_NAME_SIZE);
+	return 0;
+}
+
+static void lm95245_init_client(struct i2c_client *client)
+{
+	struct lm95245_data *data = i2c_get_clientdata(client);
+
+	data->interval = 1000;	/* 1 sec default */
+	data->valid = 0;
+	data->config1 = 0;
+
+	data->config2 = i2c_smbus_read_byte_data(client, data->config2);
+
+	/* Do not set diode model in ervery case */
+	data->config2 |= CFG2_DIODE_FAULT_TCRIT | CFG2_REMOTE_FILTER_EN;
+
+	i2c_smbus_write_byte_data(client, LM95245_REG_RW_CONFIG1, data->config1);
+	i2c_smbus_write_byte_data(client, LM95245_REG_RW_CONFIG2, data->config2);
+	lm95245_set_conversation_rate(client, data->interval);
+}
+
+static int lm95245_probe(struct i2c_client *new_client,
+			 const struct i2c_device_id *id)
+{
+	struct lm95245_data *data;
+	int err;
+
+	data = kzalloc(sizeof(struct lm95245_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	i2c_set_clientdata(new_client, data);
+	mutex_init(&data->update_lock);
+
+	/* Initialize the LM95245 chip */
+	lm95245_init_client(new_client);
+
+	/* Register sysfs hooks */
+	err = sysfs_create_group(&new_client->dev.kobj, &lm95245_group);
+	if (err)
+		goto exit_free;
+
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		goto exit_remove_files;
+	}
+
+	return 0;
+
+exit_remove_files:
+	sysfs_remove_group(&new_client->dev.kobj, &lm95245_group);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int lm95245_remove(struct i2c_client *client)
+{
+	struct lm95245_data *data = i2c_get_clientdata(client);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &lm95245_group);
+
+	kfree(data);
+	return 0;
+}
+
+/* Driver data (common to all clients) */
+static const struct i2c_device_id lm95245_id[] = {
+	{ DEVNAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lm95245_id);
+
+static struct i2c_driver lm95245_driver = {
+	.class		= I2C_CLASS_HWMON,
+	.driver = {
+		.name	= DEVNAME,
+	},
+	.probe		= lm95245_probe,
+	.remove		= lm95245_remove,
+	.id_table	= lm95245_id,
+	.detect		= lm95245_detect,
+	.address_list	= normal_i2c,
+};
+
+static int __init sensors_lm95245_init(void)
+{
+	return i2c_add_driver(&lm95245_driver);
+}
+
+static void __exit sensors_lm95245_exit(void)
+{
+	i2c_del_driver(&lm95245_driver);
+}
+
+MODULE_AUTHOR("Alexander Stein <alexander.stein@systec-electronic.com>");
+MODULE_DESCRIPTION("LM95245 sensor driver");
+MODULE_LICENSE("GPL");
+
+module_init(sensors_lm95245_init);
+module_exit(sensors_lm95245_exit);
-- 
1.7.3.4

