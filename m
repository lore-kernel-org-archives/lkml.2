Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1BEOWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1BEOVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rz+bBBfIIxlQHfyv1N/t/c9H7EmI0RoaZxpYRJXA6yK9P9bsVTAwGDx+Jle2VatDUo
         fQYaAmz8Uywia2oXj3x0BEzYwdokl4uxD+iQ+GjffV2XMCqgx9MZ9bbjJc0jvbl031L7
         GjYXOehqaCzM/0f7JLppmoB/o+QwgvXheAw7U=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 20/52] kstrtox: convert drivers/hwmon/
Date: Sat,  5 Feb 2011 16:20:23 +0200
Message-Id: <1296915654-7458-20-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/hwmon/adcxx.c     |    8 ++-
 drivers/hwmon/adm1031.c   |    6 +-
 drivers/hwmon/adm9240.c   |    2 +-
 drivers/hwmon/adt7411.c   |    8 ++-
 drivers/hwmon/adt7462.c   |   87 +++++++++++++++++++++++++----------
 drivers/hwmon/adt7470.c   |   80 +++++++++++++++++++++++----------
 drivers/hwmon/adt7475.c   |   83 +++++++++++++++++++---------------
 drivers/hwmon/amc6821.c   |   45 ++++++++++++-------
 drivers/hwmon/applesmc.c  |   27 +++++++-----
 drivers/hwmon/asc7621.c   |   83 ++++++++++++++++++++++------------
 drivers/hwmon/ds620.c     |    2 +-
 drivers/hwmon/emc1403.c   |   17 ++++---
 drivers/hwmon/emc2103.c   |   32 +++++++------
 drivers/hwmon/f71882fg.c  |   62 +++++++++++++-------------
 drivers/hwmon/g760a.c     |    6 ++-
 drivers/hwmon/gpio-fan.c  |   24 +++++++---
 drivers/hwmon/ibmaem.c    |    4 +-
 drivers/hwmon/it87.c      |  109 ++++++++++++++++++++++++++++++---------------
 drivers/hwmon/jc42.c      |   34 +++++++-------
 drivers/hwmon/lis3lv02d.c |    8 ++-
 drivers/hwmon/lm73.c      |    3 +-
 drivers/hwmon/lm75.c      |    4 +-
 drivers/hwmon/lm90.c      |   16 +++---
 drivers/hwmon/lm95241.c   |    8 ++--
 drivers/hwmon/pc87427.c   |   20 ++++++---
 drivers/hwmon/tmp102.c    |    5 +-
 drivers/hwmon/tmp401.c    |   37 +++++++++------
 drivers/hwmon/w83791d.c   |   28 +++++++----
 drivers/hwmon/w83792d.c   |    2 +-
 drivers/hwmon/w83793.c    |    2 +-
 drivers/hwmon/w83795.c    |  109 +++++++++++++++++++++++++++++---------------
 31 files changed, 603 insertions(+), 358 deletions(-)

diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index fbdc765..b6367e8 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -123,10 +123,12 @@ static ssize_t adcxx_set_max(struct device *dev,
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-	unsigned long value;
+	u32 value;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &value))
-		return -EINVAL;
+	rv = kstrtou32(buf, 10, &value);
+	if (rv < 0)
+		return rv;
 
 	if (mutex_lock_interruptible(&adc->lock))
 		return -ERESTARTSYS;
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 0683e6b..641a7e9 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -763,12 +763,12 @@ static ssize_t set_update_interval(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1031_data *data = i2c_get_clientdata(client);
-	unsigned long val;
+	unsigned int val;
 	int i, err;
 	u8 reg;
 
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
+	err = kstrtouint(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	/*
diff --git a/drivers/hwmon/adm9240.c b/drivers/hwmon/adm9240.c
index 9e234b9..3f63f5f 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -503,7 +503,7 @@ static ssize_t chassis_clear(struct device *dev,
 	struct adm9240_data *data = i2c_get_clientdata(client);
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val) || val != 0)
+	if (kstrtoul(buf, 10, &val) || val != 0)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index f13c843..dbc35a8 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -195,10 +195,12 @@ static ssize_t adt7411_set_bit(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7411_data *data = i2c_get_clientdata(client);
 	int ret;
-	unsigned long flag;
+	unsigned int flag;
 
-	ret = strict_strtoul(buf, 0, &flag);
-	if (ret || flag > 1)
+	ret = kstrtouint(buf, 0, &flag);
+	if (ret < 0)
+		return ret;
+	if (flag > 1)
 		return -EINVAL;
 
 	ret = adt7411_modify_bit(client, s_attr2->index, s_attr2->nr, flag);
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 2af0c7b..c9a3dcb 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -832,8 +832,12 @@ static ssize_t set_temp_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !temp_enabled(data, attr->index))
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!temp_enabled(data, attr->index))
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
@@ -870,8 +874,12 @@ static ssize_t set_temp_max(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !temp_enabled(data, attr->index))
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!temp_enabled(data, attr->index))
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
@@ -934,8 +942,12 @@ static ssize_t set_volt_max(struct device *dev,
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	int x = voltage_multiplier(data, attr->index);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !x)
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!x)
 		return -EINVAL;
 
 	temp *= 1000; /* convert mV to uV */
@@ -976,8 +988,12 @@ static ssize_t set_volt_min(struct device *dev,
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	int x = voltage_multiplier(data, attr->index);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !x)
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!x)
 		return -EINVAL;
 
 	temp *= 1000; /* convert mV to uV */
@@ -1065,9 +1081,12 @@ static ssize_t set_fan_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !temp ||
-	    !fan_enabled(data, attr->index))
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!temp || !fan_enabled(data, attr->index))
 		return -EINVAL;
 
 	temp = FAN_RPM_TO_PERIOD(temp);
@@ -1114,9 +1133,11 @@ static ssize_t set_force_pwm_max(struct device *dev,
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 	reg = i2c_smbus_read_byte_data(client, ADT7462_REG_CFG2);
@@ -1146,9 +1167,11 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
@@ -1176,9 +1199,11 @@ static ssize_t set_pwm_max(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
@@ -1208,9 +1233,11 @@ static ssize_t set_pwm_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
@@ -1242,9 +1269,11 @@ static ssize_t set_pwm_hyst(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 15);
@@ -1288,9 +1317,11 @@ static ssize_t set_pwm_tmax(struct device *dev,
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	int tmin, trange_value;
 	long trange;
+	int rv;
 
-	if (strict_strtol(buf, 10, &trange))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &trange);
+	if (rv < 0)
+		return rv;
 
 	/* trange = tmax - tmin */
 	tmin = (data->pwm_tmin[attr->index] - 64) * 1000;
@@ -1329,9 +1360,11 @@ static ssize_t set_pwm_tmin(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
@@ -1385,10 +1418,12 @@ static ssize_t set_pwm_auto(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
-	long temp;
+	int temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtoint(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	switch (temp) {
 	case 0: /* off */
@@ -1445,9 +1480,11 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7462_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = cvt_auto_temp(temp);
 	if (temp < 0)
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index c6d1ce0..37cf052 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -448,9 +448,11 @@ static ssize_t set_auto_update_interval(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 60000);
 
@@ -477,9 +479,11 @@ static ssize_t set_num_temp_sensors(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, -1, 10);
 
@@ -510,9 +514,11 @@ static ssize_t set_temp_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
@@ -544,9 +550,11 @@ static ssize_t set_temp_max(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
@@ -599,8 +607,12 @@ static ssize_t set_fan_max(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !temp)
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!temp)
 		return -EINVAL;
 
 	temp = FAN_RPM_TO_PERIOD(temp);
@@ -636,8 +648,12 @@ static ssize_t set_fan_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp) || !temp)
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
+	if (!temp)
 		return -EINVAL;
 
 	temp = FAN_RPM_TO_PERIOD(temp);
@@ -681,9 +697,11 @@ static ssize_t set_force_pwm_max(struct device *dev,
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 	data->force_pwm_max = temp;
@@ -713,9 +731,11 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
@@ -745,9 +765,11 @@ static ssize_t set_pwm_max(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
@@ -778,9 +800,11 @@ static ssize_t set_pwm_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
@@ -821,9 +845,11 @@ static ssize_t set_pwm_tmin(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	long temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
@@ -856,11 +882,13 @@ static ssize_t set_pwm_auto(struct device *dev,
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	int pwm_auto_reg = ADT7470_REG_PWM_CFG(attr->index);
 	int pwm_auto_reg_mask;
-	long temp;
+	u8 temp;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtou8(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	if (attr->index % 2)
 		pwm_auto_reg_mask = ADT7470_PWM2_AUTO_MASK;
@@ -918,9 +946,11 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
 	int pwm_auto_reg = ADT7470_REG_PWM_AUTO_TEMP(attr->index);
 	long temp;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &temp))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &temp);
+	if (rv < 0)
+		return rv;
 
 	temp = cvt_auto_temp(temp);
 	if (temp < 0)
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index b5fcd87..e1867fc 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -342,9 +342,11 @@ static ssize_t set_voltage(struct device *dev, struct device_attribute *attr,
 	struct adt7475_data *data = i2c_get_clientdata(client);
 	unsigned char reg;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -431,9 +433,11 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *attr,
 	u8 out;
 	int temp;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -545,9 +549,11 @@ static ssize_t set_point2(struct device *dev, struct device_attribute *attr,
 	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
 	int temp;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -601,9 +607,11 @@ static ssize_t set_tach(struct device *dev, struct device_attribute *attr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7475_data *data = i2c_get_clientdata(client);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -652,9 +660,11 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 	struct adt7475_data *data = i2c_get_clientdata(client);
 	unsigned char reg = 0;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -755,20 +765,20 @@ static ssize_t set_pwmchan(struct device *dev, struct device_attribute *attr,
 	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7475_data *data = i2c_get_clientdata(client);
-	int r;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 	/* Read Modify Write PWM values */
 	adt7475_read_pwm(client, sattr->index);
-	r = hw_set_pwm(client, sattr->index, data->pwmctl[sattr->index], val);
-	if (r)
-		count = r;
+	rv = hw_set_pwm(client, sattr->index, data->pwmctl[sattr->index], val);
 	mutex_unlock(&data->lock);
-
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
@@ -778,20 +788,20 @@ static ssize_t set_pwmctrl(struct device *dev, struct device_attribute *attr,
 	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7475_data *data = i2c_get_clientdata(client);
-	int r;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 	/* Read Modify Write PWM values */
 	adt7475_read_pwm(client, sattr->index);
-	r = hw_set_pwm(client, sattr->index, val, data->pwmchan[sattr->index]);
-	if (r)
-		count = r;
+	rv = hw_set_pwm(client, sattr->index, val, data->pwmchan[sattr->index]);
 	mutex_unlock(&data->lock);
-
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
@@ -818,9 +828,11 @@ static ssize_t set_pwmfreq(struct device *dev, struct device_attribute *attr,
 	struct adt7475_data *data = i2c_get_clientdata(client);
 	int out;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	out = find_nearest(val, pwmfreq_table, ARRAY_SIZE(pwmfreq_table));
 
@@ -851,10 +863,12 @@ static ssize_t set_pwm_at_crit(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7475_data *data = i2c_get_clientdata(client);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
@@ -881,14 +895,11 @@ static ssize_t set_vrm(struct device *dev, struct device_attribute *devattr,
 		       const char *buf, size_t count)
 {
 	struct adt7475_data *data = dev_get_drvdata(dev);
-	long val;
-
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
-	if (val < 0 || val > 255)
-		return -EINVAL;
-	data->vrm = val;
+	int rv;
 
+	rv = kstrtou8(buf, 10, &data->vrm);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 4033974..b010cf4 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -237,9 +237,10 @@ static ssize_t set_temp(
 	struct amc6821_data *data = i2c_get_clientdata(client);
 	int ix = to_sensor_dev_attr(attr)->index;
 	long val;
+	int ret;
 
-	int ret = strict_strtol(buf, 10, &val);
-	if (ret)
+	ret = kstrtol(buf, 10, &val);
+	if (ret < 0)
 		return ret;
 	val = SENSORS_LIMIT(val / 1000, -128, 127);
 
@@ -327,8 +328,10 @@ static ssize_t set_pwm1(
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
 	long val;
-	int ret = strict_strtol(buf, 10, &val);
-	if (ret)
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret < 0)
 		return ret;
 
 	mutex_lock(&data->update_lock);
@@ -355,9 +358,11 @@ static ssize_t set_pwm1_enable(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
-	long val;
-	int config = strict_strtol(buf, 10, &val);
-	if (config)
+	int val;
+	int config;
+
+	config = kstrtoint(buf, 10, &val);
+	if (config < 0)
 		return config;
 
 	config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
@@ -477,8 +482,10 @@ static ssize_t set_temp_auto_point_temp(
 	u8 reg;
 	int dpwm;
 	long val;
-	int ret = strict_strtol(buf, 10, &val);
-	if (ret)
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret < 0)
 		return ret;
 
 	switch (nr) {
@@ -556,8 +563,10 @@ static ssize_t set_pwm1_auto_point_pwm(
 	struct amc6821_data *data = i2c_get_clientdata(client);
 	int dpwm;
 	long val;
-	int ret = strict_strtol(buf, 10, &val);
-	if (ret)
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret < 0)
 		return ret;
 
 	mutex_lock(&data->update_lock);
@@ -623,8 +632,10 @@ static ssize_t set_fan(
 	struct amc6821_data *data = i2c_get_clientdata(client);
 	long val;
 	int ix = to_sensor_dev_attr(attr)->index;
-	int ret = strict_strtol(buf, 10, &val);
-	if (ret)
+	int ret;
+
+	ret = kstrtol(buf, 10, &val);
+	if (ret < 0)
 		return ret;
 	val = 1 > val ? 0xFFFF : 6000000/val;
 
@@ -664,9 +675,11 @@ static ssize_t set_fan1_div(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
-	long val;
-	int config = strict_strtol(buf, 10, &val);
-	if (config)
+	int val;
+	int config;
+
+	config = kstrtoint(buf, 10, &val);
+	if (config < 0)
 		return config;
 
 	config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4c07436..303b519 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -777,12 +777,15 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
 					struct device_attribute *attr,
 					const char *sysfsbuf, size_t count)
 {
-	int ret;
 	unsigned long speed;
 	char newkey[5];
 	u8 buffer[2];
+	int ret;
 
-	if (strict_strtoul(sysfsbuf, 10, &speed) < 0 || speed >= 0x4000)
+	ret = kstrtoul(sysfsbuf, 10, &speed);
+	if (ret < 0)
+		return ret;
+	if (speed >= 0x4000)
 		return -EINVAL;		/* Bigger than a 14-bit value */
 
 	sprintf(newkey, fan_speed_fmt[to_option(attr)], to_index(attr));
@@ -790,11 +793,9 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
 	buffer[0] = (speed >> 6) & 0xff;
 	buffer[1] = (speed << 2) & 0xff;
 	ret = applesmc_write_key(newkey, buffer, 2);
-
 	if (ret)
 		return ret;
-	else
-		return count;
+	return count;
 }
 
 static ssize_t applesmc_show_fan_manual(struct device *dev,
@@ -817,13 +818,14 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *sysfsbuf, size_t count)
 {
-	int ret;
 	u8 buffer[2];
 	unsigned long input;
 	u16 val;
+	int ret;
 
-	if (strict_strtoul(sysfsbuf, 10, &input) < 0)
-		return -EINVAL;
+	ret = kstrtoul(sysfsbuf, 10, &input);
+	if (ret < 0)
+		return ret;
 
 	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
 	val = (buffer[0] << 8 | buffer[1]);
@@ -975,10 +977,13 @@ static ssize_t applesmc_key_at_index_show(struct device *dev,
 static ssize_t applesmc_key_at_index_store(struct device *dev,
 	struct device_attribute *attr, const char *sysfsbuf, size_t count)
 {
-	unsigned long newkey;
+	unsigned int newkey;
+	int rv;
 
-	if (strict_strtoul(sysfsbuf, 10, &newkey) < 0
-	    || newkey >= smcreg.key_count)
+	rv = kstrtouint(sysfsbuf, 10, &newkey);
+	if (rv < 0)
+		return rv;
+	if (newkey >= smcreg.key_count)
 		return -EINVAL;
 
 	key_at_index = newkey;
diff --git a/drivers/hwmon/asc7621.c b/drivers/hwmon/asc7621.c
index d2596ce..03aa1bd 100644
--- a/drivers/hwmon/asc7621.c
+++ b/drivers/hwmon/asc7621.c
@@ -187,9 +187,11 @@ static ssize_t store_u8(struct device *dev, struct device_attribute *attr,
 {
 	SETUP_STORE_data_param(dev, attr);
 	long reqval;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	reqval = SENSORS_LIMIT(reqval, 0, 255);
 
@@ -220,9 +222,11 @@ static ssize_t store_bitmask(struct device *dev,
 	SETUP_STORE_data_param(dev, attr);
 	long reqval;
 	u8 currval;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	reqval = SENSORS_LIMIT(reqval, 0, param->mask[0]);
 
@@ -264,9 +268,11 @@ static ssize_t store_fan16(struct device *dev,
 {
 	SETUP_STORE_data_param(dev, attr);
 	long reqval;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	/* If a minimum RPM of zero is requested, then we set the register to
 	   0xffff. This value allows the fan to be stopped completely without
@@ -337,9 +343,11 @@ static ssize_t store_in8(struct device *dev, struct device_attribute *attr,
 	SETUP_STORE_data_param(dev, attr);
 	long reqval;
 	u8 nr = sda->index;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	reqval = SENSORS_LIMIT(reqval, 0, 0xffff);
 
@@ -370,9 +378,11 @@ static ssize_t store_temp8(struct device *dev,
 	SETUP_STORE_data_param(dev, attr);
 	long reqval;
 	s8 temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	reqval = SENSORS_LIMIT(reqval, -127000, 127000);
 
@@ -426,9 +436,11 @@ static ssize_t store_temp62(struct device *dev,
 	SETUP_STORE_data_param(dev, attr);
 	long reqval, i, f;
 	s8 temp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	reqval = SENSORS_LIMIT(reqval, -32000, 31750);
 	i = reqval / 1000;
@@ -481,9 +493,11 @@ static ssize_t store_ap2_temp(struct device *dev,
 	long reqval, auto_point1;
 	int i;
 	u8 currval, newval = 0;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	auto_point1 = data->reg[param->msb[1]] * 1000;
@@ -529,7 +543,7 @@ static ssize_t store_pwm_ac(struct device *dev,
 			    const char *buf, size_t count)
 {
 	SETUP_STORE_data_param(dev, attr);
-	unsigned long reqval;
+	u8 reqval;
 	u8 currval, config, altbit, newval;
 	u16 map[] = {
 		0x04, 0x00, 0x01, 0xff, 0x02, 0xff, 0x05, 0x06,
@@ -537,10 +551,11 @@ static ssize_t store_pwm_ac(struct device *dev,
 		0x07, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x03,
 	};
+	int rv;
 
-	if (strict_strtoul(buf, 10, &reqval))
-		return -EINVAL;
-
+	rv = kstrtou8(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 	if (reqval > 31)
 		return -EINVAL;
 
@@ -598,11 +613,13 @@ static ssize_t store_pwm_enable(struct device *dev,
 				const char *buf, size_t count)
 {
 	SETUP_STORE_data_param(dev, attr);
-	long reqval;
+	int reqval;
 	u8 currval, config, altbit, newval, minoff = 255;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtoint(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	switch (reqval) {
 	case 0:
@@ -671,12 +688,14 @@ static ssize_t store_pwm_freq(struct device *dev,
 			      const char *buf, size_t count)
 {
 	SETUP_STORE_data_param(dev, attr);
-	unsigned long reqval;
+	u32 reqval;
 	u8 currval, newval = 255;
 	int i;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtou32(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	for (i = 0; i < ARRAY_SIZE(asc7621_pwm_freq_map); i++) {
 		if (reqval == asc7621_pwm_freq_map[i]) {
@@ -720,12 +739,14 @@ static ssize_t store_pwm_ast(struct device *dev,
 			     const char *buf, size_t count)
 {
 	SETUP_STORE_data_param(dev, attr);
-	long reqval;
+	u32 reqval;
 	u8 currval, newval = 255;
 	u32 i;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtou32(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	for (i = 0; i < ARRAY_SIZE(asc7621_pwm_auto_spinup_map); i++) {
 		if (reqval == asc7621_pwm_auto_spinup_map[i]) {
@@ -767,12 +788,14 @@ static ssize_t store_temp_st(struct device *dev,
 			     const char *buf, size_t count)
 {
 	SETUP_STORE_data_param(dev, attr);
-	long reqval;
+	u32 reqval;
 	u8 currval, newval = 255;
 	u32 i;
+	int rv;
 
-	if (strict_strtol(buf, 10, &reqval))
-		return -EINVAL;
+	rv = kstrtou32(buf, 10, &reqval);
+	if (rv < 0)
+		return rv;
 
 	for (i = 0; i < ARRAY_SIZE(asc7621_temp_smoothing_time_map); i++) {
 		if (reqval == asc7621_temp_smoothing_time_map[i]) {
diff --git a/drivers/hwmon/ds620.c b/drivers/hwmon/ds620.c
index 257957c..2a0529f 100644
--- a/drivers/hwmon/ds620.c
+++ b/drivers/hwmon/ds620.c
@@ -182,7 +182,7 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct ds620_data *data = i2c_get_clientdata(client);
 
-	res = strict_strtol(buf, 10, &val);
+	res = kstrtol(buf, 10, &val);
 
 	if (res)
 		return res;
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 5dea9fa..fe2b557 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -80,8 +80,9 @@ static ssize_t store_temp(struct device *dev,
 	unsigned long val;
 	int retval;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	retval = kstrtoul(buf, 10, &val);
+	if (retval < 0)
+		return retval;
 	retval = i2c_smbus_write_byte_data(client, sda->index,
 					DIV_ROUND_CLOSEST(val, 1000));
 	if (retval < 0)
@@ -95,11 +96,12 @@ static ssize_t store_bit(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct thermal_data *data = i2c_get_clientdata(client);
 	struct sensor_device_attribute_2 *sda = to_sensor_dev_attr_2(attr);
-	unsigned long val;
+	int val;
 	int retval;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	retval = kstrtoint(buf, 10, &val);
+	if (retval < 0)
+		return retval;
 
 	mutex_lock(&data->mutex);
 	retval = i2c_smbus_read_byte_data(client, sda->nr);
@@ -151,8 +153,9 @@ static ssize_t store_hyst(struct device *dev,
 	int hyst;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	retval = kstrtoul(buf, 10, &val);
+	if (retval < 0)
+		return retval;
 
 	mutex_lock(&data->mutex);
 	retval = i2c_smbus_read_byte_data(client, sda->index);
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index af914ad..72bcc0e 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -243,10 +243,11 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct emc2103_data *data = i2c_get_clientdata(client);
 	long val;
+	int result;
 
-	int result = strict_strtol(buf, 10, &val);
+	result = kstrtol(buf, 10, &val);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	val = DIV_ROUND_CLOSEST(val, 1000);
 	if ((val < -63) || (val > 127))
@@ -267,10 +268,11 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct emc2103_data *data = i2c_get_clientdata(client);
 	long val;
+	int result;
 
-	int result = strict_strtol(buf, 10, &val);
+	result = kstrtol(buf, 10, &val);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	val = DIV_ROUND_CLOSEST(val, 1000);
 	if ((val < -63) || (val > 127))
@@ -313,10 +315,11 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	int new_range_bits, old_div = 8 / data->fan_multiplier;
 	long new_div;
+	int status;
 
-	int status = strict_strtol(buf, 10, &new_div);
+	status = kstrtol(buf, 10, &new_div);
 	if (status < 0)
-		return -EINVAL;
+		return status;
 
 	if (new_div == old_div) /* No change */
 		return count;
@@ -386,14 +389,14 @@ static ssize_t set_fan_target(struct device *dev, struct device_attribute *da,
 {
 	struct emc2103_data *data = emc2103_update_device(dev);
 	struct i2c_client *client = to_i2c_client(dev);
-	long rpm_target;
+	unsigned int rpm_target;
+	int result;
 
-	int result = strict_strtol(buf, 10, &rpm_target);
+	result = kstrtouint(buf, 10, &rpm_target);
 	if (result < 0)
-		return -EINVAL;
-
+		return result;
 	/* Datasheet states 16384 as maximum RPM target (table 3.2) */
-	if ((rpm_target < 0) || (rpm_target > 16384))
+	if (rpm_target > 16384)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -431,12 +434,13 @@ static ssize_t set_pwm_enable(struct device *dev, struct device_attribute *da,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct emc2103_data *data = i2c_get_clientdata(client);
-	long new_value;
+	int new_value;
 	u8 conf_reg;
+	int result;
 
-	int result = strict_strtol(buf, 10, &new_value);
+	result = kstrtoint(buf, 10, &new_value);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	mutex_lock(&data->update_lock);
 	switch (new_value) {
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 3f49dd3..935910b 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -1135,8 +1135,8 @@ static ssize_t store_fan_full_speed(struct device *dev,
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val = SENSORS_LIMIT(val, 23, 1500000);
@@ -1169,8 +1169,8 @@ static ssize_t store_fan_beep(struct device *dev, struct device_attribute
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	unsigned long val;
 
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
+	err = kstrtoul(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	mutex_lock(&data->update_lock);
@@ -1222,8 +1222,8 @@ static ssize_t store_in_max(struct device *dev, struct device_attribute
 	int err;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val /= 8;
@@ -1256,8 +1256,8 @@ static ssize_t store_in_beep(struct device *dev, struct device_attribute
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	unsigned long val;
 
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
+	err = kstrtoul(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	mutex_lock(&data->update_lock);
@@ -1326,8 +1326,8 @@ static ssize_t store_temp_max(struct device *dev, struct device_attribute
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val /= 1000;
@@ -1368,8 +1368,8 @@ static ssize_t store_temp_max_hyst(struct device *dev, struct device_attribute
 	u8 reg;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val /= 1000;
@@ -1411,8 +1411,8 @@ static ssize_t store_temp_crit(struct device *dev, struct device_attribute
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val /= 1000;
@@ -1472,8 +1472,8 @@ static ssize_t store_temp_beep(struct device *dev, struct device_attribute
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	unsigned long val;
 
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
+	err = kstrtoul(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	mutex_lock(&data->update_lock);
@@ -1539,8 +1539,8 @@ static ssize_t store_pwm(struct device *dev,
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val = SENSORS_LIMIT(val, 0, 255);
@@ -1605,8 +1605,8 @@ static ssize_t store_pwm_enable(struct device *dev, struct device_attribute
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	/* Special case for F8000 pwm channel 3 which only does auto mode */
@@ -1685,8 +1685,8 @@ static ssize_t store_pwm_auto_point_pwm(struct device *dev,
 	int point = to_sensor_dev_attr_2(devattr)->nr;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val = SENSORS_LIMIT(val, 0, 255);
@@ -1739,8 +1739,8 @@ static ssize_t store_pwm_auto_point_temp_hyst(struct device *dev,
 	u8 reg;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val /= 1000;
@@ -1785,8 +1785,8 @@ static ssize_t store_pwm_interpolate(struct device *dev,
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
 	unsigned long val;
 
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
+	err = kstrtoul(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	mutex_lock(&data->update_lock);
@@ -1823,10 +1823,10 @@ static ssize_t store_pwm_auto_point_channel(struct device *dev,
 {
 	struct f71882fg_data *data = dev_get_drvdata(dev);
 	int err, nr = to_sensor_dev_attr_2(devattr)->index;
-	long val;
+	u8 val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtou8(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	switch (val) {
@@ -1876,8 +1876,8 @@ static ssize_t store_pwm_auto_point_temp(struct device *dev,
 	int point = to_sensor_dev_attr_2(devattr)->nr;
 	long val;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	val /= 1000;
diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
index 1d6a6fa..32191de 100644
--- a/drivers/hwmon/g760a.c
+++ b/drivers/hwmon/g760a.c
@@ -165,9 +165,11 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct g760a_data *data = g760a_update_client(dev);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->set_cnt = PWM_TO_CNT(SENSORS_LIMIT(val, 0, 255));
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index f141a1d..5e7bc1e 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -222,11 +222,15 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 	unsigned long pwm;
 	int speed_index;
-	int ret = count;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &pwm) || pwm > 255)
+	ret = kstrtoul(buf, 10, &pwm);
+	if (ret < 0)
+		return ret;
+	if (pwm > 255)
 		return -EINVAL;
 
+	ret = count;
 	mutex_lock(&fan_data->lock);
 
 	if (!fan_data->pwm_enable) {
@@ -255,9 +259,13 @@ static ssize_t set_pwm_enable(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
 	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
-	unsigned long val;
+	int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val > 1)
 		return -EINVAL;
 
 	if (fan_data->pwm_enable == val)
@@ -312,11 +320,13 @@ static ssize_t set_rpm(struct device *dev, struct device_attribute *attr,
 {
 	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 	unsigned long rpm;
-	int ret = count;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &rpm))
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &rpm);
+	if (ret < 0)
+		return ret;
 
+	ret = count;
 	mutex_lock(&fan_data->lock);
 
 	if (!fan_data->pwm_enable) {
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index bc6e2ab..570acf8 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -922,8 +922,8 @@ static ssize_t aem_set_power_period(struct device *dev,
 	unsigned long temp;
 	int res;
 
-	res = strict_strtoul(buf, 10, &temp);
-	if (res)
+	res = kstrtoul(buf, 10, &temp);
+	if (res < 0)
 		return res;
 
 	if (temp < AEM_MIN_POWER_INTERVAL)
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 316b648..10120cf 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -440,9 +440,11 @@ static ssize_t set_in_min(struct device *dev, struct device_attribute *attr,
 
 	struct it87_data *data = dev_get_drvdata(dev);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->in_min[nr] = in_to_reg(data, nr, val);
@@ -459,9 +461,11 @@ static ssize_t set_in_max(struct device *dev, struct device_attribute *attr,
 
 	struct it87_data *data = dev_get_drvdata(dev);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->in_max[nr] = in_to_reg(data, nr, val);
@@ -535,9 +539,11 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *attr,
 
 	struct it87_data *data = dev_get_drvdata(dev);
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->temp_high[nr] = TEMP_TO_REG(val);
@@ -553,9 +559,11 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *attr,
 
 	struct it87_data *data = dev_get_drvdata(dev);
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->temp_low[nr] = TEMP_TO_REG(val);
@@ -598,11 +606,13 @@ static ssize_t set_sensor(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->index;
 
 	struct it87_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	reg = it87_read_value(data, IT87_REG_TEMP_ENABLE);
 	reg &= ~(1 << nr);
@@ -714,9 +724,11 @@ static ssize_t set_fan_min(struct device *dev, struct device_attribute *attr,
 	struct it87_data *data = dev_get_drvdata(dev);
 	long val;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	reg = it87_read_value(data, IT87_REG_FAN_DIV);
@@ -747,9 +759,11 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int min;
 	u8 old;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	old = it87_read_value(data, IT87_REG_FAN_DIV);
@@ -815,9 +829,13 @@ static ssize_t set_pwm_enable(struct device *dev,
 	int nr = sensor_attr->index;
 
 	struct it87_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0 || val < 0 || val > 2)
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val < 0 || val > 2)
 		return -EINVAL;
 
 	/* Check trip points before switching to automatic mode */
@@ -862,8 +880,12 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 
 	struct it87_data *data = dev_get_drvdata(dev);
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0 || val < 0 || val > 255)
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val < 0 || val > 255)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -896,9 +918,11 @@ static ssize_t set_pwm_freq(struct device *dev,
 	struct it87_data *data = dev_get_drvdata(dev);
 	unsigned long val;
 	int i;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	/* Search for the nearest available frequency */
 	for (i = 0; i < 7; i++) {
@@ -936,8 +960,9 @@ static ssize_t set_pwm_temp_map(struct device *dev,
 	int nr = sensor_attr->index;
 
 	struct it87_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
 	u8 reg;
+	int rv;
 
 	/* This check can go away if we ever support automatic fan speed
 	   control on newer chips. */
@@ -946,8 +971,9 @@ static ssize_t set_pwm_temp_map(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	switch (val) {
 	case (1 << 0):
@@ -997,8 +1023,12 @@ static ssize_t set_auto_pwm(struct device *dev,
 	int nr = sensor_attr->nr;
 	int point = sensor_attr->index;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0 || val < 0 || val > 255)
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val < 0 || val > 255)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -1030,8 +1060,12 @@ static ssize_t set_auto_temp(struct device *dev,
 	int nr = sensor_attr->nr;
 	int point = sensor_attr->index;
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0 || val < -128000 || val > 127000)
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val < -128000 || val > 127000)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -1122,9 +1156,11 @@ static ssize_t set_fan16_min(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->index;
 	struct it87_data *data = dev_get_drvdata(dev);
 	long val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->fan_min[nr] = FAN16_TO_REG(val);
@@ -1198,10 +1234,13 @@ static ssize_t set_beep(struct device *dev, struct device_attribute *attr,
 {
 	int bitnr = to_sensor_dev_attr(attr)->index;
 	struct it87_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) < 0
-	 || (val != 0 && val != 1))
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val != 0 && val != 1)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -1245,13 +1284,11 @@ static ssize_t store_vrm_reg(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct it87_data *data = dev_get_drvdata(dev);
-	unsigned long val;
-
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
-
-	data->vrm = val;
+	int rv;
 
+	rv = kstrtou8(buf, 10, &data->vrm);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 static DEVICE_ATTR(vrm, S_IRUGO | S_IWUSR, show_vrm_reg, store_vrm_reg);
diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 340fc78..2f269f8 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -307,17 +307,19 @@ static ssize_t set_##value(struct device *dev,				\
 {									\
 	struct i2c_client *client = to_i2c_client(dev);			\
 	struct jc42_data *data = i2c_get_clientdata(client);		\
-	int err, ret = count;						\
-	long val;							\
-	if (strict_strtol(buf, 10, &val) < 0)				\
-		return -EINVAL;						\
+	int val;							\
+	int ret;							\
+									\
+	ret = kstrtoint(buf, 10, &val);					\
+	if (ret < 0)							\
+		return ret;						\
 	mutex_lock(&data->update_lock);					\
 	data->value = jc42_temp_to_reg(val, data->extended);		\
-	err = jc42_write_value(client, reg, data->value);		\
-	if (err < 0)							\
-		ret = err;						\
+	ret = jc42_write_value(client, reg, data->value);		\
 	mutex_unlock(&data->update_lock);				\
-	return ret;							\
+	if (ret < 0)							\
+		return ret;						\
+	return count;							\
 }
 
 set(temp_min, JC42_REG_TEMP_LOWER);
@@ -334,11 +336,11 @@ static ssize_t set_temp_crit_hyst(struct device *dev,
 	struct jc42_data *data = i2c_get_clientdata(client);
 	long val;
 	int diff, hyst;
-	int err;
-	int ret = count;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
 
 	diff = jc42_temp_from_reg(data->temp_crit) - val;
 	hyst = 0;
@@ -355,11 +357,11 @@ static ssize_t set_temp_crit_hyst(struct device *dev,
 	data->config = (data->config
 			& ~(JC42_CFG_HYST_MASK << JC42_CFG_HYST_SHIFT))
 	  | (hyst << JC42_CFG_HYST_SHIFT);
-	err = jc42_write_value(client, JC42_REG_CONFIG, data->config);
-	if (err < 0)
-		ret = err;
+	ret = jc42_write_value(client, JC42_REG_CONFIG, data->config);
 	mutex_unlock(&data->update_lock);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return count;
 }
 
 static ssize_t show_alarm(struct device *dev,
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index d805e8e..f138183 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -754,10 +754,12 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
-	unsigned long rate;
+	int rate;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &rate))
-		return -EINVAL;
+	rv = kstrtoint(buf, 0, &rate);
+	if (rv < 0)
+		return rv;
 
 	lis3lv02d_sysfs_poweron(&lis3_dev);
 	if (lis3lv02d_set_odr(rate))
diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index 29b9030..0ab02a6 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -49,8 +49,9 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	long temp;
 	short value;
+	int status;
 
-	int status = strict_strtol(buf, 10, &temp);
+	status = kstrtol(buf, 10, &temp);
 	if (status < 0)
 		return status;
 
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index f36eb80..dfddb06 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -106,8 +106,8 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 	long temp;
 	int error;
 
-	error = strict_strtol(buf, 10, &temp);
-	if (error)
+	error = kstrtol(buf, 10, &temp);
+	if (error < 0)
 		return error;
 
 	mutex_lock(&data->update_lock);
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 812781c..34907f5 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -708,7 +708,7 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 	long val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err < 0)
 		return err;
 
@@ -776,7 +776,7 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 	long val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err < 0)
 		return err;
 
@@ -837,7 +837,7 @@ static ssize_t set_temphyst(struct device *dev, struct device_attribute *dummy,
 	int err;
 	int temp;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err < 0)
 		return err;
 
@@ -887,11 +887,11 @@ static ssize_t set_update_interval(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lm90_data *data = i2c_get_clientdata(client);
-	unsigned long val;
+	unsigned int val;
 	int err;
 
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
+	err = kstrtouint(buf, 10, &val);
+	if (err < 0)
 		return err;
 
 	mutex_lock(&data->update_lock);
@@ -1055,10 +1055,10 @@ static ssize_t set_pec(struct device *dev, struct device_attribute *dummy,
 		       const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	long val;
+	int val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtoint(buf, 10, &val);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 1a6dfb6..1c04660 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -160,7 +160,7 @@ static ssize_t set_type(struct device *dev, struct device_attribute *attr,
 	int shift;
 	u8 mask = to_sensor_dev_attr(attr)->index;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
+	if (kstrtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 	if (val != 1 && val != 2)
 		return -EINVAL;
@@ -207,7 +207,7 @@ static ssize_t set_min(struct device *dev, struct device_attribute *attr,
 	struct lm95241_data *data = i2c_get_clientdata(client);
 	long val;
 
-	if (strict_strtol(buf, 10, &val) < 0)
+	if (kstrtol(buf, 10, &val) < 0)
 		return -EINVAL;
 	if (val < -128000)
 		return -EINVAL;
@@ -245,7 +245,7 @@ static ssize_t set_max(struct device *dev, struct device_attribute *attr,
 	struct lm95241_data *data = i2c_get_clientdata(client);
 	long val;
 
-	if (strict_strtol(buf, 10, &val) < 0)
+	if (kstrtol(buf, 10, &val) < 0)
 		return -EINVAL;
 	if (val >= 256000)
 		return -EINVAL;
@@ -281,7 +281,7 @@ static ssize_t set_interval(struct device *dev, struct device_attribute *attr,
 	struct lm95241_data *data = i2c_get_clientdata(client);
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
+	if (kstrtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
 	data->interval = val * HZ / 1000;
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 8da2181..7426024 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -417,9 +417,11 @@ static ssize_t set_fan_min(struct device *dev, struct device_attribute
 	int nr = to_sensor_dev_attr(devattr)->index;
 	unsigned long val;
 	int iobase = data->address[LD_FAN];
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 	outb(BANK_FM(nr), iobase + PC87427_REG_BANK);
@@ -571,8 +573,12 @@ static ssize_t set_pwm_enable(struct device *dev, struct device_attribute
 	struct pc87427_data *data = dev_get_drvdata(dev);
 	int nr = to_sensor_dev_attr(devattr)->index;
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0 || val > 2)
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val > 2)
 		return -EINVAL;
 	/* Can't go to automatic mode if it isn't configured */
 	if (val == 2 && !(data->pwm_auto_ok & (1 << nr)))
@@ -600,12 +606,14 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute
 {
 	struct pc87427_data *data = dev_get_drvdata(dev);
 	int nr = to_sensor_dev_attr(devattr)->index;
-	unsigned long val;
+	u8 val;
 	int iobase = data->address[LD_FAN];
 	u8 mode;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0 || val > 0xff)
-		return -EINVAL;
+	rv = kstrtou8(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 	pc87427_readall_pwm(data, nr);
diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 93187c3..f839a78 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -124,8 +124,9 @@ static ssize_t tmp102_set_temp(struct device *dev,
 	long val;
 	int status;
 
-	if (strict_strtol(buf, 10, &val) < 0)
-		return -EINVAL;
+	status = kstrtol(buf, 10, &val);
+	if (status < 0)
+		return status;
 	val = SENSORS_LIMIT(val, -256000, 255000);
 
 	mutex_lock(&tmp102->lock);
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index ad8d535..6e67bdb 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -333,9 +333,11 @@ static ssize_t store_temp_min(struct device *dev, struct device_attribute
 	struct tmp401_data *data = tmp401_update_device(dev);
 	long val;
 	u16 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	reg = tmp401_temp_to_register(val, data->config);
 
@@ -360,9 +362,11 @@ static ssize_t store_temp_max(struct device *dev, struct device_attribute
 	struct tmp401_data *data = tmp401_update_device(dev);
 	long val;
 	u16 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	reg = tmp401_temp_to_register(val, data->config);
 
@@ -387,9 +391,11 @@ static ssize_t store_temp_crit(struct device *dev, struct device_attribute
 	struct tmp401_data *data = tmp401_update_device(dev);
 	long val;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	reg = tmp401_crit_temp_to_register(val, data->config);
 
@@ -412,9 +418,11 @@ static ssize_t store_temp_crit_hyst(struct device *dev, struct device_attribute
 	struct tmp401_data *data = tmp401_update_device(dev);
 	long val;
 	u8 reg;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	if (data->config & TMP401_CONFIG_RANGE)
 		val = SENSORS_LIMIT(val, -64000, 191000);
@@ -445,18 +453,19 @@ static ssize_t store_temp_crit_hyst(struct device *dev, struct device_attribute
 static ssize_t reset_temp_history(struct device *dev,
 	struct device_attribute	*devattr, const char *buf, size_t count)
 {
-	long val;
-
-	if (strict_strtol(buf, 10, &val))
-		return -EINVAL;
+	int val;
+	int rv;
 
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	if (val != 1) {
-		dev_err(dev, "temp_reset_history value %ld not"
+		dev_err(dev, "temp_reset_history value %d not"
 			" supported. Use 1 to reset the history!\n", val);
 		return -EINVAL;
 	}
 	i2c_smbus_write_byte_data(to_i2c_client(dev),
-		TMP411_TEMP_LOWEST_MSB[0], val);
+		TMP411_TEMP_LOWEST_MSB[0], 1);
 
 	return count;
 }
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 400a88b..c588a76 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -710,9 +710,11 @@ static ssize_t store_pwm(struct device *dev, struct device_attribute *attr,
 	struct w83791d_data *data = i2c_get_clientdata(client);
 	int nr = sensor_attr->index;
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->pwm[nr] = SENSORS_LIMIT(val, 0, 255);
@@ -750,15 +752,17 @@ static ssize_t store_pwmenable(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct w83791d_data *data = i2c_get_clientdata(client);
 	int nr = sensor_attr->index;
-	unsigned long val;
+	u8 val;
 	u8 reg_cfg_tmp;
 	u8 reg_idx = 0;
 	u8 val_shift = 0;
 	u8 keep_mask = 0;
+	int ret;
 
-	int ret = strict_strtoul(buf, 10, &val);
-
-	if (ret || val < 1 || val > 3)
+	ret = kstrtou8(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val < 1 || val > 3)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -818,9 +822,11 @@ static ssize_t store_temp_target(struct device *dev,
 	int nr = sensor_attr->index;
 	unsigned long val;
 	u8 target_mask;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->temp_target[nr] = TARGET_TEMP_TO_REG(val);
@@ -862,9 +868,11 @@ static ssize_t store_temp_tolerance(struct device *dev,
 	u8 reg_idx = 0;
 	u8 val_shift = 0;
 	u8 keep_mask = 0;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	switch (nr) {
 	case 0:
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index 63841f8..f6b8aa1 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -749,7 +749,7 @@ store_chassis_clear(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	u8 reg;
 
-	if (strict_strtoul(buf, 10, &val) || val != 0)
+	if (kstrtoul(buf, 10, &val) || val != 0)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index e3bdedf..cc3906c 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -450,7 +450,7 @@ store_chassis_clear(struct device *dev,
 	unsigned long val;
 	u8 reg;
 
-	if (strict_strtoul(buf, 10, &val) || val != 0)
+	if (kstrtoul(buf, 10, &val) || val != 0)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
diff --git a/drivers/hwmon/w83795.c b/drivers/hwmon/w83795.c
index 845232d..6bdf597 100644
--- a/drivers/hwmon/w83795.c
+++ b/drivers/hwmon/w83795.c
@@ -728,10 +728,12 @@ store_beep(struct device *dev, struct device_attribute *attr,
 	int index = sensor_attr->index >> 3;
 	int shift = sensor_attr->index & 0x07;
 	u8 beep_bit = 1 << shift;
-	unsigned long val;
+	unsigned int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtouint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
@@ -753,9 +755,13 @@ store_chassis_clear(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct w83795_data *data = i2c_get_clientdata(client);
-	unsigned long val;
+	u8 val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0 || val != 0)
+	rv = kstrtou8(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val != 0)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -800,9 +806,11 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct w83795_data *data = i2c_get_clientdata(client);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	val = fan_to_reg(val);
 
 	mutex_lock(&data->update_lock);
@@ -862,9 +870,11 @@ store_pwm(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	switch (nr) {
@@ -921,16 +931,18 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 	struct sensor_device_attribute_2 *sensor_attr =
 	    to_sensor_dev_attr_2(attr);
 	int index = sensor_attr->index;
-	unsigned long val;
-	int i;
+	int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	if (val < 1 || val > 2)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
 	switch (val) {
+		int i;
 	case 1:
 		/* Clear speed cruise mode bits */
 		data->pwm_fcms[0] &= ~(1 << index);
@@ -1018,11 +1030,14 @@ store_temp_src(struct device *dev, struct device_attribute *attr,
 	    to_sensor_dev_attr_2(attr);
 	int index = sensor_attr->index;
 	int tmp;
-	unsigned long channel;
+	u8 channel;
 	u8 val = index / 2;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &channel) < 0 ||
-	    channel < 1 || channel > 14)
+	rv = kstrtou8(buf, 10, &channel);
+	if (rv < 0)
+		return rv;
+	if (channel < 1 || channel > 14)
 		return -EINVAL;
 
 	/* Check if request can be fulfilled */
@@ -1087,9 +1102,11 @@ store_temp_pwm_enable(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	unsigned long tmp;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &tmp) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &tmp);
+	if (rv < 0)
+		return rv;
 
 	switch (nr) {
 	case TEMP_PWM_ENABLE:
@@ -1148,9 +1165,11 @@ store_fanin(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	switch (nr) {
@@ -1197,9 +1216,11 @@ store_temp_pwm(struct device *dev, struct device_attribute *attr,
 	int index = sensor_attr->index;
 	unsigned long val;
 	u8 tmp;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	val /= 1000;
 
 	mutex_lock(&data->update_lock);
@@ -1256,9 +1277,11 @@ store_sf4_pwm(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	w83795_write(client, W83795_REG_SF4_PWM(index, nr), val);
@@ -1292,9 +1315,11 @@ store_sf4_temp(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	val /= 1000;
 
 	mutex_lock(&data->update_lock);
@@ -1332,9 +1357,11 @@ store_temp(struct device *dev, struct device_attribute *attr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct w83795_data *data = i2c_get_clientdata(client);
 	long tmp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &tmp) < 0)
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &tmp);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->temp[index][nr] = temp_to_reg(tmp, -128, 127);
@@ -1393,9 +1420,11 @@ store_dts_ext(struct device *dev, struct device_attribute *attr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct w83795_data *data = i2c_get_clientdata(client);
 	long tmp;
+	int rv;
 
-	if (strict_strtol(buf, 10, &tmp) < 0)
-		return -EINVAL;
+	rv = kstrtol(buf, 10, &tmp);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->update_lock);
 	data->dts_ext[nr] = temp_to_reg(tmp, -128, 127);
@@ -1433,11 +1462,13 @@ store_temp_mode(struct device *dev, struct device_attribute *attr,
 	    to_sensor_dev_attr_2(attr);
 	int index = sensor_attr->index;
 	int reg_shift;
-	unsigned long val;
+	u8 val;
 	u8 tmp;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtou8(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	if ((val != 4) && (val != 3))
 		return -EINVAL;
 
@@ -1511,9 +1542,11 @@ store_in(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	u8 tmp;
 	u8 lsb_idx;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 	val = in_to_reg(index, val);
 
 	if ((index >= 17) &&
@@ -1568,9 +1601,11 @@ store_sf_setup(struct device *dev, struct device_attribute *attr,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct w83795_data *data = i2c_get_clientdata(client);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	switch (nr) {
 	case SETUP_PWM_DEFAULT:
-- 
1.7.3.4

