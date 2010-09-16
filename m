Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0IPPoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:44:03 -0400
Received: from imr3.ericy.com ([198.24.6.13]:34368 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab0IPPoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:44:01 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 1/2] hwmon: (adm1031) Replace update_rate sysfs attribute with update_interval
Date: Thu, 16 Sep 2010 08:49:57 -0700
Message-ID: <1284652197-17069-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attribute reflects an interval, not a rate.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
v2: Modified sysfs-interface text

 Documentation/hwmon/sysfs-interface |    9 +++----
 drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index ff45d1f..dcb7636 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -91,12 +91,11 @@ name		The chip name.
 		I2C devices get this attribute created automatically.
 		RO
 
-update_rate	The rate at which the chip will update readings.
-		Unit: millisecond
+update_interval	The interval at which the chip will update readings.
+		Unit: milliseconds
 		RW
-		Some devices have a variable update rate. This attribute
-		can be used to change the update rate to the desired
-		frequency.
+		Some devices have a variable update rate or interval.
+		This attribute can be used to change it to the desired value.
 
 
 ************
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 15c1a96..0683e6b 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -79,7 +79,7 @@ struct adm1031_data {
 	int chip_type;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
-	unsigned int update_rate;	/* In milliseconds */
+	unsigned int update_interval;	/* In milliseconds */
 	/* The chan_select_table contains the possible configurations for
 	 * auto fan control.
 	 */
@@ -743,23 +743,23 @@ static SENSOR_DEVICE_ATTR(temp3_crit_alarm, S_IRUGO, show_alarm, NULL, 12);
 static SENSOR_DEVICE_ATTR(temp3_fault, S_IRUGO, show_alarm, NULL, 13);
 static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL, 14);
 
-/* Update Rate */
-static const unsigned int update_rates[] = {
+/* Update Interval */
+static const unsigned int update_intervals[] = {
 	16000, 8000, 4000, 2000, 1000, 500, 250, 125,
 };
 
-static ssize_t show_update_rate(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t show_update_interval(struct device *dev,
+				    struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1031_data *data = i2c_get_clientdata(client);
 
-	return sprintf(buf, "%u\n", data->update_rate);
+	return sprintf(buf, "%u\n", data->update_interval);
 }
 
-static ssize_t set_update_rate(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
+static ssize_t set_update_interval(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1031_data *data = i2c_get_clientdata(client);
@@ -771,12 +771,15 @@ static ssize_t set_update_rate(struct device *dev,
 	if (err)
 		return err;
 
-	/* find the nearest update rate from the table */
-	for (i = 0; i < ARRAY_SIZE(update_rates) - 1; i++) {
-		if (val >= update_rates[i])
+	/*
+	 * Find the nearest update interval from the table.
+	 * Use it to determine the matching update rate.
+	 */
+	for (i = 0; i < ARRAY_SIZE(update_intervals) - 1; i++) {
+		if (val >= update_intervals[i])
 			break;
 	}
-	/* if not found, we point to the last entry (lowest update rate) */
+	/* if not found, we point to the last entry (lowest update interval) */
 
 	/* set the new update rate while preserving other settings */
 	reg = adm1031_read_value(client, ADM1031_REG_FAN_FILTER);
@@ -785,14 +788,14 @@ static ssize_t set_update_rate(struct device *dev,
 	adm1031_write_value(client, ADM1031_REG_FAN_FILTER, reg);
 
 	mutex_lock(&data->update_lock);
-	data->update_rate = update_rates[i];
+	data->update_interval = update_intervals[i];
 	mutex_unlock(&data->update_lock);
 
 	return count;
 }
 
-static DEVICE_ATTR(update_rate, S_IRUGO | S_IWUSR, show_update_rate,
-		   set_update_rate);
+static DEVICE_ATTR(update_interval, S_IRUGO | S_IWUSR, show_update_interval,
+		   set_update_interval);
 
 static struct attribute *adm1031_attributes[] = {
 	&sensor_dev_attr_fan1_input.dev_attr.attr,
@@ -830,7 +833,7 @@ static struct attribute *adm1031_attributes[] = {
 
 	&sensor_dev_attr_auto_fan1_min_pwm.dev_attr.attr,
 
-	&dev_attr_update_rate.attr,
+	&dev_attr_update_interval.attr,
 	&dev_attr_alarms.attr,
 
 	NULL
@@ -981,7 +984,8 @@ static void adm1031_init_client(struct i2c_client *client)
 	mask = ADM1031_UPDATE_RATE_MASK;
 	read_val = adm1031_read_value(client, ADM1031_REG_FAN_FILTER);
 	i = (read_val & mask) >> ADM1031_UPDATE_RATE_SHIFT;
-	data->update_rate = update_rates[i];
+	/* Save it as update interval */
+	data->update_interval = update_intervals[i];
 }
 
 static struct adm1031_data *adm1031_update_device(struct device *dev)
@@ -993,7 +997,8 @@ static struct adm1031_data *adm1031_update_device(struct device *dev)
 
 	mutex_lock(&data->update_lock);
 
-	next_update = data->last_updated + msecs_to_jiffies(data->update_rate);
+	next_update = data->last_updated
+	  + msecs_to_jiffies(data->update_interval);
 	if (time_after(jiffies, next_update) || !data->valid) {
 
 		dev_dbg(&client->dev, "Starting adm1031 update\n");
-- 
1.7.0.87.g0901d

