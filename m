Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0IDWcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 18:32:15 -0400
Received: from imr3.ericy.com ([198.24.6.13]:60475 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab0IDWcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 18:32:14 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] hwmon: Add support for max6695 and max6696 to lm90 driver
Date: Sat, 4 Sep 2010 15:34:35 -0700
Message-ID: <1283639675-31714-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
To apply this patch, the previously submitted lm90 cleanup patch has to be
applied first.

My main concern with this patch is the chip detection code, specifically if it
is able to safely distinguish between MAX6680/81 and MAX6695/96.
Would be great to get some test coverage from a system with one of those chips.

Sample sensors output:

max6695-i2c-0-19
Adapter: SMBus I801 adapter at 5080
temp1:       +24.5 C  (low  = -55.0 C, high = +70.0 C)
                      (crit = +70.0 C, hyst = +60.0 C)
temp2:       +26.5 C  (low  = -55.0 C, high = +70.0 C)
                      (crit = +90.0 C, hyst = +80.0 C)
temp3:       +24.1 C  (low  = -54.1 C, high = +70.2 C)
	              (crit = +90.0 C, hyst = +80.0 C)

 drivers/hwmon/lm90.c |  280 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 252 insertions(+), 28 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index aafed28..52ed792 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -42,6 +42,11 @@
  * chips. The MAX6680 and MAX6681 only differ in the pinout so they can
  * be treated identically.
  *
+ * This driver also supports the MAX6695 and MAX6696, two other sensor
+ * chips made by Maxim. These are also quite similar to other Maxim
+ * chips, but support three temperature sensors instead of two. MAX6695
+ * and MAX6696 only differ in the pinout so they can be treated identically.
+ *
  * This driver also supports the ADT7461 chip from Analog Devices.
  * It's supported in both compatibility and extended mode. It is mostly
  * compatible with LM90 except for a data format difference for the
@@ -94,7 +99,7 @@ static const unsigned short normal_i2c[] = {
 	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
-	w83l771 };
+	max6695, w83l771 };
 
 /*
  * The LM90 registers
@@ -109,6 +114,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
 #define LM90_REG_R_CONVRATE		0x04
 #define LM90_REG_W_CONVRATE		0x0A
 #define LM90_REG_R_STATUS		0x02
+#define LM90_REG_R_STATUS2		0x12
 #define LM90_REG_R_LOCAL_TEMP		0x00
 #define LM90_REG_R_LOCAL_HIGH		0x05
 #define LM90_REG_W_LOCAL_HIGH		0x0B
@@ -130,12 +136,16 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
 #define LM90_REG_W_REMOTE_LOWH		0x0E
 #define LM90_REG_R_REMOTE_LOWL		0x14
 #define LM90_REG_W_REMOTE_LOWL		0x14
+#define LM90_REG_R_REMOTE_EMERG		0x16
+#define LM90_REG_W_REMOTE_EMERG		0x16
+#define LM90_REG_R_LOCAL_EMERG		0x17
+#define LM90_REG_W_LOCAL_EMERG		0x17
 #define LM90_REG_R_REMOTE_CRIT		0x19
 #define LM90_REG_W_REMOTE_CRIT		0x19
 #define LM90_REG_R_TCRIT_HYST		0x21
 #define LM90_REG_W_TCRIT_HYST		0x21
 
-/* MAX6646/6647/6649/6657/6658/6659 registers */
+/* MAX6646/6647/6649/6657/6658/6659/6695/6696 registers */
 
 #define MAX6657_REG_R_LOCAL_TEMPL	0x11
 
@@ -148,6 +158,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
  * Functions declaration
  */
 
+static int lm90_read_reg(struct i2c_client *client, u8 reg, u8 *value);
 static int lm90_detect(struct i2c_client *client, struct i2c_board_info *info);
 static int lm90_probe(struct i2c_client *client,
 		      const struct i2c_device_id *id);
@@ -157,6 +168,23 @@ static int lm90_remove(struct i2c_client *client);
 static struct lm90_data *lm90_update_device(struct device *dev);
 
 /*
+ * Some useful macros
+ */
+#define lm90_have_offset(data)  \
+		(data->kind != max6657 && data->kind != max6646 \
+		 && data->kind != max6695)
+
+#define lm90_have_local_temp_ext(data)  \
+		(data->kind == max6657 || data->kind == max6646 \
+		 || data->kind == max6695)
+
+#define lm90_have_remote_limit_ext(data) \
+		(data->kind != max6657 && data->kind != max6646 \
+		 && data->kind != max6680 && data->kind != max6695)
+
+#define lm90_have_emergency(data) (data->kind == max6695)
+
+/*
  * Driver data (common to all clients)
  */
 
@@ -175,6 +203,8 @@ static const struct i2c_device_id lm90_id[] = {
 	{ "max6659", max6657 },
 	{ "max6680", max6680 },
 	{ "max6681", max6680 },
+	{ "max6695", max6695 },
+	{ "max6696", max6695 },
 	{ "w83l771", w83l771 },
 	{ }
 };
@@ -206,20 +236,29 @@ struct lm90_data {
 	int flags;
 
 	u8 config_orig;		/* Original configuration register value */
-	u8 alert_alarms;	/* Which alarm bits trigger ALERT# */
+	u16 alert_alarms;	/* Which alarm bits trigger ALERT# */
+				/* Upper 8 bits from max6695 STATUS2 register */
 
 	/* registers values */
-	s8 temp8[4];	/* 0: local low limit
+	s8 temp8[8];	/* 0: local low limit
 			   1: local high limit
 			   2: local critical limit
-			   3: remote critical limit */
-	s16 temp11[5];	/* 0: remote input
+			   3: remote critical limit
+			   4: local emergency limit (max6695/96 only)
+			   5: remote emergency limit (max6695/96 only)
+			   6: remote 2 critical limit (max6695/96 only)
+			   7: remote 2 emergency limit (max6695/96 only) */
+	s16 temp11[8];	/* 0: remote input
 			   1: remote low limit
 			   2: remote high limit
-			   3: remote offset (except max6646 and max6657)
-			   4: local input */
+			   3: remote offset (except max6646, max6657/59,
+					     and max6695/96)
+			   4: local input
+			   5: remote 2 input (max6695/96 only)
+			   6: remote 2 low limit (max6695/96 only)
+			   7: remote 2 high limit (ma6695/96 only) */
 	u8 temp_hyst;
-	u8 alarms; /* bitvector */
+	u16 alarms; /* bitvector (upper 8 bits for max6695/96) */
 };
 
 /*
@@ -377,11 +416,15 @@ static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 			 const char *buf, size_t count)
 {
-	static const u8 reg[4] = {
+	static const u8 reg[8] = {
 		LM90_REG_W_LOCAL_LOW,
 		LM90_REG_W_LOCAL_HIGH,
 		LM90_REG_W_LOCAL_CRIT,
 		LM90_REG_W_REMOTE_CRIT,
+		LM90_REG_W_LOCAL_EMERG,
+		LM90_REG_W_REMOTE_EMERG,
+		LM90_REG_W_REMOTE_CRIT,
+		LM90_REG_W_REMOTE_EMERG,
 	};
 
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
@@ -390,6 +433,7 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 	int nr = attr->index;
 	long val;
 	int err;
+	u8 config;
 
 	err = strict_strtol(buf, 10, &val);
 	if (err < 0)
@@ -406,7 +450,18 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 		data->temp8[nr] = temp_to_u8(val);
 	else
 		data->temp8[nr] = temp_to_s8(val);
+
+	if (data->kind == max6695 && nr >= 6) {
+		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+					  config | 0x08);
+	}
+
 	i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
+
+	if (data->kind == max6695 && nr >= 6)
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
+
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -450,6 +505,8 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 	int nr = attr->index;
 	long val;
 	int err;
+	int offset = 1;
+	u8 config;
 
 	err = strict_strtol(buf, 10, &val);
 	if (err < 0)
@@ -462,19 +519,31 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 	mutex_lock(&data->update_lock);
 	if (data->kind == adt7461)
 		data->temp11[nr] = temp_to_u16_adt7461(data, val);
-	else if (data->kind == max6657 || data->kind == max6680)
-		data->temp11[nr] = temp_to_s8(val) << 8;
 	else if (data->kind == max6646)
 		data->temp11[nr] = temp_to_u8(val) << 8;
+	else if (!lm90_have_remote_limit_ext(data))
+		data->temp11[nr] = temp_to_s8(val) << 8;
 	else
 		data->temp11[nr] = temp_to_s16(val);
 
-	i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2],
+	if (data->kind == max6695 && nr >= 6) {
+		/* select output channel 2 */
+		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+					  config | 0x08);
+		offset = 6;
+	}
+
+	i2c_smbus_write_byte_data(client, reg[(nr - offset) * 2],
 				  data->temp11[nr] >> 8);
-	if (data->kind != max6657 && data->kind != max6680
-	    && data->kind != max6646)
-		i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2 + 1],
+	if (lm90_have_remote_limit_ext(data))
+		i2c_smbus_write_byte_data(client, reg[(nr - offset) * 2 + 1],
 					  data->temp11[nr] & 0xff);
+
+	if (data->kind == max6695 && nr >= 6)
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+					  config);
+
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -604,6 +673,62 @@ static const struct attribute_group lm90_group = {
 	.attrs = lm90_attributes,
 };
 
+/*
+ * Additional attributes for devices with emergency sensors
+ */
+static SENSOR_DEVICE_ATTR(temp1_emergency, S_IWUSR | S_IRUGO, show_temp8,
+	set_temp8, 4);
+static SENSOR_DEVICE_ATTR(temp2_emergency, S_IWUSR | S_IRUGO, show_temp8,
+	set_temp8, 5);
+
+/*
+ * Additional attributes for devices with 3 temperature sensors
+ */
+static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, show_temp11, NULL, 5);
+static SENSOR_DEVICE_ATTR(temp3_min, S_IWUSR | S_IRUGO, show_temp11,
+	set_temp11, 6);
+static SENSOR_DEVICE_ATTR(temp3_max, S_IWUSR | S_IRUGO, show_temp11,
+	set_temp11, 7);
+static SENSOR_DEVICE_ATTR(temp3_crit, S_IWUSR | S_IRUGO, show_temp8,
+	set_temp8, 6);
+static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL, 4);
+static SENSOR_DEVICE_ATTR(temp3_emergency, S_IWUSR | S_IRUGO, show_temp8,
+	set_temp8, 7);
+
+static SENSOR_DEVICE_ATTR(temp3_crit_alarm, S_IRUGO, show_alarm, NULL, 9);
+static SENSOR_DEVICE_ATTR(temp3_fault, S_IRUGO, show_alarm, NULL, 10);
+static SENSOR_DEVICE_ATTR(temp3_min_alarm, S_IRUGO, show_alarm, NULL, 11);
+static SENSOR_DEVICE_ATTR(temp3_max_alarm, S_IRUGO, show_alarm, NULL, 12);
+
+static struct attribute *lm90_emergency_attributes[] = {
+	&sensor_dev_attr_temp1_emergency.dev_attr.attr,
+	&sensor_dev_attr_temp2_emergency.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group lm90_emergency_group = {
+	.attrs = lm90_emergency_attributes,
+};
+
+static struct attribute *lm90_temp3_attributes[] = {
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_min.dev_attr.attr,
+	&sensor_dev_attr_temp3_max.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp3_emergency.dev_attr.attr,
+
+	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_fault.dev_attr.attr,
+	&sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group lm90_temp3_group = {
+	.attrs = lm90_temp3_attributes,
+};
+
 /* pec used for ADM1032 only */
 static ssize_t show_pec(struct device *dev, struct device_attribute *dummy,
 			char *buf)
@@ -688,7 +813,7 @@ static int lm90_detect(struct i2c_client *new_client,
 	struct i2c_adapter *adapter = new_client->adapter;
 	int address = new_client->addr;
 	const char *name = NULL;
-	int man_id, chip_id, reg_config1, reg_convrate;
+	int man_id, chip_id, reg_config1, reg_convrate, reg_emerg;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -704,6 +829,11 @@ static int lm90_detect(struct i2c_client *new_client,
 						LM90_REG_R_CONVRATE)) < 0)
 		return -ENODEV;
 
+	reg_emerg = i2c_smbus_read_byte_data(new_client,
+					     LM90_REG_R_REMOTE_EMERG);
+	if (reg_emerg < 0)
+		return -ENODEV;
+
 	if ((address == 0x4C || address == 0x4D)
 	 && man_id == 0x01) { /* National Semiconductor */
 		int reg_config2;
@@ -770,6 +900,22 @@ static int lm90_detect(struct i2c_client *new_client,
 			name = "max6657";
 		} else
 		/*
+		 * Even though MAX6695 and MAX6696 do not have a chip ID
+		 * register, reading it returns 0x01. Bit 4 of the config1
+		 * register is unused and should return zero when read.
+		 *
+		 * MAX6695 and MAX6696 have an additional set of temperature
+		 * limit registers. We can detect those chips by checking if
+		 * one of those registers exists (and thus returns a value
+		 * different to the previous reading).
+		 */
+		if (chip_id == 0x01
+		 && (reg_config1 & 0x10) == 0x00
+		 && reg_emerg != reg_convrate
+		 && reg_convrate <= 0x07) {
+			name = "max6695";
+		} else
+		/*
 		 * The chip_id register of the MAX6680 and MAX6681 holds the
 		 * revision of the chip. The lowest bit of the config1 register
 		 * is unused and should return zero when read, so should the
@@ -842,6 +988,9 @@ static int lm90_probe(struct i2c_client *new_client,
 	case lm86:
 		data->alert_alarms = 0x7b;
 		break;
+	case max6695:
+		data->alert_alarms = (0x18 << 8) | 0x7c;
+		break;
 	default:
 		data->alert_alarms = 0x7c;
 		break;
@@ -854,12 +1003,27 @@ static int lm90_probe(struct i2c_client *new_client,
 	err = sysfs_create_group(&new_client->dev.kobj, &lm90_group);
 	if (err)
 		goto exit_free;
+
+	if (lm90_have_emergency(data)) {
+		err = sysfs_create_group(&new_client->dev.kobj,
+					 &lm90_emergency_group);
+		if (err)
+			goto exit_remove_base;
+	}
+
+	if (data->kind == max6695) {
+		err = sysfs_create_group(&new_client->dev.kobj,
+					      &lm90_temp3_group);
+		if (err)
+			goto exit_remove_emergency;
+	}
+
 	if (new_client->flags & I2C_CLIENT_PEC) {
 		err = device_create_file(&new_client->dev, &dev_attr_pec);
 		if (err)
 			goto exit_remove_files;
 	}
-	if (data->kind != max6657 && data->kind != max6646) {
+	if (lm90_have_offset(data)) {
 		err = device_create_file(&new_client->dev,
 					&sensor_dev_attr_temp2_offset.dev_attr);
 		if (err)
@@ -875,6 +1039,13 @@ static int lm90_probe(struct i2c_client *new_client,
 	return 0;
 
 exit_remove_files:
+	if (data->kind == max6695)
+		sysfs_remove_group(&new_client->dev.kobj, &lm90_temp3_group);
+exit_remove_emergency:
+	if (lm90_have_emergency(data))
+		sysfs_remove_group(&new_client->dev.kobj,
+				   &lm90_emergency_group);
+exit_remove_base:
 	sysfs_remove_group(&new_client->dev.kobj, &lm90_group);
 	device_remove_file(&new_client->dev, &dev_attr_pec);
 exit_free:
@@ -913,6 +1084,12 @@ static void lm90_init_client(struct i2c_client *client)
 	if (data->kind == max6680)
 		config |= 0x18;
 
+	/*
+	 * Select external channel 1 for max6695
+	 */
+	if (data->kind == max6695)
+		config &= ~0x08;
+
 	config &= 0xBF;	/* run */
 	if (config != data->config_orig) /* Only write if changed */
 		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
@@ -923,9 +1100,13 @@ static int lm90_remove(struct i2c_client *client)
 	struct lm90_data *data = i2c_get_clientdata(client);
 
 	hwmon_device_unregister(data->hwmon_dev);
+	if (lm90_have_emergency(data))
+		sysfs_remove_group(&client->dev.kobj, &lm90_emergency_group);
+	if (data->kind == max6695)
+		sysfs_remove_group(&client->dev.kobj, &lm90_temp3_group);
 	sysfs_remove_group(&client->dev.kobj, &lm90_group);
 	device_remove_file(&client->dev, &dev_attr_pec);
-	if (data->kind != max6657 && data->kind != max6646)
+	if (lm90_have_offset(data))
 		device_remove_file(&client->dev,
 				   &sensor_dev_attr_temp2_offset.dev_attr);
 
@@ -940,10 +1121,14 @@ static int lm90_remove(struct i2c_client *client)
 static void lm90_alert(struct i2c_client *client, unsigned int flag)
 {
 	struct lm90_data *data = i2c_get_clientdata(client);
-	u8 config, alarms;
+	u8 config, alarms, alarms2 = 0;
 
 	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
-	if ((alarms & 0x7f) == 0) {
+
+	if (data->kind == max6695)
+		lm90_read_reg(client, LM90_REG_R_STATUS2, &alarms2);
+
+	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
 		dev_info(&client->dev, "Everything OK\n");
 	} else {
 		if (alarms & 0x61)
@@ -956,6 +1141,10 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
 			dev_warn(&client->dev,
 				 "temp%d diode open, please check!\n", 2);
 
+		if (alarms2 & 0x18)
+			dev_warn(&client->dev,
+				 "temp%d out of range, please check!\n", 3);
+
 		/* Disable ALERT# output, because these chips don't implement
 		  SMBus alert correctly; they should only hold the alert line
 		  low briefly. */
@@ -1011,6 +1200,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 	if (time_after(jiffies, data->last_updated + HZ / 2 + HZ / 10)
 	 || !data->valid) {
 		u8 h, l;
+		u8 alarms, alarms2 = 0;
 
 		dev_dbg(&client->dev, "Updating lm90 data.\n");
 		lm90_read_reg(client, LM90_REG_R_LOCAL_LOW, &data->temp8[0]);
@@ -1019,7 +1209,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 		lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT, &data->temp8[3]);
 		lm90_read_reg(client, LM90_REG_R_TCRIT_HYST, &data->temp_hyst);
 
-		if (data->kind == max6657 || data->kind == max6646) {
+		if (lm90_have_local_temp_ext(data)) {
 			lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
 				    MAX6657_REG_R_LOCAL_TEMPL,
 				    &data->temp11[4]);
@@ -1033,29 +1223,63 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 
 		if (lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h) == 0) {
 			data->temp11[1] = h << 8;
-			if (data->kind != max6657 && data->kind != max6680
-			 && data->kind != max6646
+			if (lm90_have_remote_limit_ext(data)
 			 && lm90_read_reg(client, LM90_REG_R_REMOTE_LOWL,
 					  &l) == 0)
 				data->temp11[1] |= l;
 		}
 		if (lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h) == 0) {
 			data->temp11[2] = h << 8;
-			if (data->kind != max6657 && data->kind != max6680
-			 && data->kind != max6646
+			if (lm90_have_remote_limit_ext(data)
 			 && lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHL,
 					  &l) == 0)
 				data->temp11[2] |= l;
 		}
 
-		if (data->kind != max6657 && data->kind != max6646) {
+		if (lm90_have_offset(data)) {
 			if (lm90_read_reg(client, LM90_REG_R_REMOTE_OFFSH,
 					  &h) == 0
 			 && lm90_read_reg(client, LM90_REG_R_REMOTE_OFFSL,
 					  &l) == 0)
 				data->temp11[3] = (h << 8) | l;
 		}
-		lm90_read_reg(client, LM90_REG_R_STATUS, &data->alarms);
+
+		if (data->kind == max6695) {
+			u8 config;
+
+			lm90_read_reg(client, LM90_REG_R_LOCAL_EMERG,
+				      &data->temp8[4]);
+			lm90_read_reg(client, LM90_REG_R_REMOTE_EMERG,
+				      &data->temp8[5]);
+
+			lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
+			i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+						  config | 0x08);
+
+			lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT,
+				      &data->temp8[6]);
+			lm90_read_reg(client, LM90_REG_R_REMOTE_EMERG,
+				      &data->temp8[7]);
+			lm90_read16(client, LM90_REG_R_REMOTE_TEMPH,
+				    LM90_REG_R_REMOTE_TEMPL, &data->temp11[5]);
+			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h)
+			    && !lm90_read_reg(client,
+					      LM90_REG_R_REMOTE_LOWL, &l))
+				data->temp11[6] = (h << 8) | l;
+			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h)
+			    && !lm90_read_reg(client,
+					      LM90_REG_R_REMOTE_HIGHL, &l))
+				data->temp11[7] = (h << 8) | l;
+
+			i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+						  config);
+
+			lm90_read_reg(client, LM90_REG_R_STATUS2,
+				      &alarms2);
+		}
+
+		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
+		data->alarms = (alarms2 << 8) | alarms;
 
 		/* Re-enable ALERT# output if it was originally enabled and
 		 * relevant alarms are all clear */
-- 
1.7.0.87.g0901d

