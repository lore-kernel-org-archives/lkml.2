Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1BIJvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:51:43 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:56461 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1BIJvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:51:38 -0500
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: khali@linux-fr.org, guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH v2] hwmon: Consider LM64 temperature offset
Date: Wed,  9 Feb 2011 10:51:34 +0100
Message-Id: <1297245094-13681-1-git-send-email-eibach@gdsys.de>
In-Reply-To: <20110208152815.GA13436@ericsson.com>
References: <20110208152815.GA13436@ericsson.com>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110209095138Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.162; VDF: 7.11.2.104; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LM64 has 16 degrees Celsius temperature offset on all
remote sensor registers.
This was not considered When LM64 support was added to lm63.c.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
Changes since v1:
- avoid calculating offset repeatedly
- gave reasonable names to 8bit temperature accessors
- removed redundant chip id detection
- added comment why temp2_crit cannot be set

 drivers/hwmon/lm63.c |   56 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index 776aeb3..2d0cf6d 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -98,6 +98,9 @@ static const unsigned short normal_i2c[] = { 0x18, 0x4c, 0x4e, I2C_CLIENT_END };
  * value, it uses signed 8-bit values with LSB = 1 degree Celsius.
  * For remote temperature, low and high limits, it uses signed 11-bit values
  * with LSB = 0.125 degree Celsius, left-justified in 16-bit registers.
+ * For LM64 the actual remote diode temperature is 16 degree Celsius higher
+ * than the register reading. Remote temperature setpoints have to be
+ * adapted accordingly.
  */
 
 #define FAN_FROM_REG(reg)	((reg) == 0xFFFC || (reg) == 0 ? 0 : \
@@ -165,6 +168,8 @@ struct lm63_data {
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
+	int kind;
+	int temp2_offset;
 
 	/* registers values */
 	u8 config, config_fan;
@@ -247,16 +252,34 @@ static ssize_t show_pwm1_enable(struct device *dev, struct device_attribute *dum
 	return sprintf(buf, "%d\n", data->config_fan & 0x20 ? 1 : 2);
 }
 
-static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
-			  char *buf)
+/*
+ * There are 8bit registers for both local(temp1) and remote(temp2) sensor.
+ * For remote sensor registers temp2_offset has to be considered,
+ * for local sensor it must not.
+ * So we need separate 8bit accessors for local and remote sensor.
+ */
+static ssize_t show_local_temp8(struct device *dev,
+				struct device_attribute *devattr,
+				char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct lm63_data *data = lm63_update_device(dev);
 	return sprintf(buf, "%d\n", TEMP8_FROM_REG(data->temp8[attr->index]));
 }
 
-static ssize_t set_temp8(struct device *dev, struct device_attribute *dummy,
-			 const char *buf, size_t count)
+static ssize_t show_remote_temp8(struct device *dev,
+				 struct device_attribute *devattr,
+				 char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct lm63_data *data = lm63_update_device(dev);
+	return sprintf(buf, "%d\n", TEMP8_FROM_REG(data->temp8[attr->index])
+		       + data->temp2_offset);
+}
+
+static ssize_t set_local_temp8(struct device *dev,
+			       struct device_attribute *dummy,
+			       const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lm63_data *data = i2c_get_clientdata(client);
@@ -274,7 +297,8 @@ static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct lm63_data *data = lm63_update_device(dev);
-	return sprintf(buf, "%d\n", TEMP11_FROM_REG(data->temp11[attr->index]));
+	return sprintf(buf, "%d\n", TEMP11_FROM_REG(data->temp11[attr->index])
+		       + data->temp2_offset);
 }
 
 static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
@@ -294,7 +318,7 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 	int nr = attr->index;
 
 	mutex_lock(&data->update_lock);
-	data->temp11[nr] = TEMP11_TO_REG(val);
+	data->temp11[nr] = TEMP11_TO_REG(val - data->temp2_offset);
 	i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2],
 				  data->temp11[nr] >> 8);
 	i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2 + 1],
@@ -310,6 +334,7 @@ static ssize_t show_temp2_crit_hyst(struct device *dev, struct device_attribute
 {
 	struct lm63_data *data = lm63_update_device(dev);
 	return sprintf(buf, "%d\n", TEMP8_FROM_REG(data->temp8[2])
+		       + data->temp2_offset
 		       - TEMP8_FROM_REG(data->temp2_crit_hyst));
 }
 
@@ -324,7 +349,7 @@ static ssize_t set_temp2_crit_hyst(struct device *dev, struct device_attribute *
 	long hyst;
 
 	mutex_lock(&data->update_lock);
-	hyst = TEMP8_FROM_REG(data->temp8[2]) - val;
+	hyst = TEMP8_FROM_REG(data->temp8[2]) + data->temp2_offset - val;
 	i2c_smbus_write_byte_data(client, LM63_REG_REMOTE_TCRIT_HYST,
 				  HYST_TO_REG(hyst));
 	mutex_unlock(&data->update_lock);
@@ -355,16 +380,18 @@ static SENSOR_DEVICE_ATTR(fan1_min, S_IWUSR | S_IRUGO, show_fan,
 static DEVICE_ATTR(pwm1, S_IWUSR | S_IRUGO, show_pwm1, set_pwm1);
 static DEVICE_ATTR(pwm1_enable, S_IRUGO, show_pwm1_enable, NULL);
 
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp8, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 1);
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_local_temp8, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_local_temp8,
+	set_local_temp8, 1);
 
 static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_temp11, NULL, 0);
 static SENSOR_DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp11,
 	set_temp11, 1);
 static SENSOR_DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp11,
 	set_temp11, 2);
-static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO, show_temp8, NULL, 2);
+/* temp2_crit can only be set once which should be job of the bootloader */
+static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO, show_remote_temp8,
+	NULL, 2);
 static DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_temp2_crit_hyst,
 	set_temp2_crit_hyst);
 
@@ -479,7 +506,12 @@ static int lm63_probe(struct i2c_client *new_client,
 	data->valid = 0;
 	mutex_init(&data->update_lock);
 
-	/* Initialize the LM63 chip */
+	/* Set the device type */
+	data->kind = id->driver_data;
+	if (data->kind == lm64)
+		data->temp2_offset = 16000;
+
+	/* Initialize chip */
 	lm63_init_client(new_client);
 
 	/* Register sysfs hooks */
-- 
1.5.6.5

