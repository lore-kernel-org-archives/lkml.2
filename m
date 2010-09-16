Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0IPCCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:02:05 -0400
Received: from imr3.ericy.com ([198.24.6.13]:38507 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPCCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:02:03 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 2/2] hwmon: (lm95241) Replace rate sysfs attribute with update_interval
Date: Wed, 15 Sep 2010 19:07:15 -0700
Message-ID: <1284602835-7605-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_interval is the matching attribute defined in the hwmon sysfs ABI.
Use it.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/lm95241.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 94741d4..464340f 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -91,7 +91,7 @@ static struct lm95241_data *lm95241_update_device(struct device *dev);
 struct lm95241_data {
 	struct device *hwmon_dev;
 	struct mutex update_lock;
-	unsigned long last_updated, rate; /* in jiffies */
+	unsigned long last_updated, interval; /* in jiffies */
 	char valid; /* zero until following fields are valid */
 	/* registers values */
 	u8 local_h, local_l; /* local */
@@ -114,23 +114,23 @@ show_temp(local);
 show_temp(remote1);
 show_temp(remote2);
 
-static ssize_t show_rate(struct device *dev, struct device_attribute *attr,
+static ssize_t show_interval(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct lm95241_data *data = lm95241_update_device(dev);
 
-	snprintf(buf, PAGE_SIZE - 1, "%lu\n", 1000 * data->rate / HZ);
+	snprintf(buf, PAGE_SIZE - 1, "%lu\n", 1000 * data->interval / HZ);
 	return strlen(buf);
 }
 
-static ssize_t set_rate(struct device *dev, struct device_attribute *attr,
+static ssize_t set_interval(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lm95241_data *data = i2c_get_clientdata(client);
 
-	strict_strtol(buf, 10, &data->rate);
-	data->rate = data->rate * HZ / 1000;
+	strict_strtol(buf, 10, &data->interval);
+	data->interval = data->interval * HZ / 1000;
 
 	return count;
 }
@@ -286,7 +286,8 @@ static DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_min1, set_min1);
 static DEVICE_ATTR(temp3_min, S_IWUSR | S_IRUGO, show_min2, set_min2);
 static DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_max1, set_max1);
 static DEVICE_ATTR(temp3_max, S_IWUSR | S_IRUGO, show_max2, set_max2);
-static DEVICE_ATTR(rate, S_IWUSR | S_IRUGO, show_rate, set_rate);
+static DEVICE_ATTR(update_interval, S_IWUSR | S_IRUGO, show_interval,
+		   set_interval);
 
 static struct attribute *lm95241_attributes[] = {
 	&dev_attr_temp1_input.attr,
@@ -298,7 +299,7 @@ static struct attribute *lm95241_attributes[] = {
 	&dev_attr_temp3_min.attr,
 	&dev_attr_temp2_max.attr,
 	&dev_attr_temp3_max.attr,
-	&dev_attr_rate.attr,
+	&dev_attr_update_interval.attr,
 	NULL
 };
 
@@ -376,7 +377,7 @@ static void lm95241_init_client(struct i2c_client *client)
 {
 	struct lm95241_data *data = i2c_get_clientdata(client);
 
-	data->rate = HZ;    /* 1 sec default */
+	data->interval = HZ;    /* 1 sec default */
 	data->valid = 0;
 	data->config = CFG_CR0076;
 	data->model = 0;
@@ -410,7 +411,7 @@ static struct lm95241_data *lm95241_update_device(struct device *dev)
 
 	mutex_lock(&data->update_lock);
 
-	if (time_after(jiffies, data->last_updated + data->rate) ||
+	if (time_after(jiffies, data->last_updated + data->interval) ||
 	    !data->valid) {
 		dev_dbg(&client->dev, "Updating lm95241 data.\n");
 		data->local_h =
-- 
1.7.0.87.g0901d

