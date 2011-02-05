Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1BEOWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1BEOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jV4nf65vNwFhZM4/i4GGoQ/Cn5K+gn2WBgidVpEbsBn/allpGFMMYHbqqOF6KONC8i
         hcAlXdgKip3rNk9NxgdBuYE6fWbweqFcxze2XZGGceI9Ik8VKtHTcN7n/fBkmIyAjERD
         wA2WZE6IeBkPxZ/6PPJh+PTE8YFMdGE/wbezM=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 29/52] kstrtox: convert drivers/misc/
Date: Sat,  5 Feb 2011 16:20:32 +0200
Message-Id: <1296915654-7458-29-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/misc/ad525x_dpot.c       |    2 +-
 drivers/misc/apds9802als.c       |    7 ++-
 drivers/misc/apds990x.c          |   45 +++++++++++++---------
 drivers/misc/bh1770glc.c         |   72 ++++++++++++++++++++++--------------
 drivers/misc/bh1780gli.c         |    4 +-
 drivers/misc/bmp085.c            |   31 ++++++---------
 drivers/misc/ep93xx_pwm.c        |   33 ++++++++--------
 drivers/misc/hmc6352.c           |    7 ++-
 drivers/misc/isl29003.c          |   28 ++++++++++----
 drivers/misc/isl29020.c          |    7 ++-
 drivers/misc/iwmc3200top/log.c   |   76 ++++++++++++++++----------------------
 drivers/misc/sgi-gru/gruprocfs.c |    7 ++-
 drivers/misc/ti_dac7512.c        |   10 +++--
 13 files changed, 175 insertions(+), 154 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 7cb9110..d0de26a 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -472,7 +472,7 @@ static ssize_t sysfs_set_reg(struct device *dev,
 		!test_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtoul(buf, 10, &value);
 	if (err)
 		return err;
 
diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 644d4cd..e6d0ebc 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -123,11 +123,12 @@ static ssize_t als_sensing_range_store(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct als_data *data = i2c_get_clientdata(client);
+	unsigned int val;
 	int ret_val;
-	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret_val = kstrtouint(buf, 10, &val);
+	if (ret_val < 0)
+		return ret_val;
 
 	if (val < 4096)
 		val = 1;
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 200311f..411ab79 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -694,11 +694,12 @@ static ssize_t apds990x_lux_calib_store(struct device *dev,
 {
 	struct apds990x_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
-
-	if (chip->lux_calib > APDS_RANGE)
+	rv = kstrtoul(buf, 0, &value);
+	if (rv < 0)
+		return rv;
+	if (value > APDS_RANGE)
 		return -EINVAL;
 
 	chip->lux_calib = value;
@@ -757,11 +758,12 @@ static ssize_t apds990x_rate_store(struct device *dev,
 				  const char *buf, size_t len)
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
-	unsigned long value;
+	unsigned int value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtouint(buf, 0, &value);
+	if (ret < 0)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	ret = apds990x_set_arate(chip, value);
@@ -814,9 +816,11 @@ static ssize_t apds990x_prox_enable_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtoul(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&chip->mutex);
 
@@ -893,12 +897,12 @@ static ssize_t apds990x_lux_thresh_below_show(struct device *dev,
 static ssize_t apds990x_set_lux_thresh(struct apds990x_chip *chip, u32 *target,
 				const char *buf)
 {
-	int ret = 0;
 	unsigned long thresh;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &thresh))
-		return -EINVAL;
-
+	ret = kstrtoul(buf, 0, &thresh);
+	if (ret < 0)
+		return ret;
 	if (thresh > APDS_RANGE)
 		return -EINVAL;
 
@@ -957,11 +961,12 @@ static ssize_t apds990x_prox_threshold_store(struct device *dev,
 				  const char *buf, size_t len)
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
-	unsigned long value;
-
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	unsigned int value;
+	int rv;
 
+	rv = kstrtouint(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 	if ((value > APDS_RANGE) || (value == 0) ||
 		(value < APDS_PROX_HYSTERESIS))
 		return -EINVAL;
@@ -991,9 +996,11 @@ static ssize_t apds990x_power_state_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtoul(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 	if (value) {
 		pm_runtime_get_sync(dev);
 		mutex_lock(&chip->mutex);
diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index d79a972..e9bd722 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -649,10 +649,11 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
-	ssize_t ret;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret < 0)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	if (value) {
@@ -726,9 +727,11 @@ static ssize_t bh1770_prox_enable_store(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtoul(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&chip->mutex);
 	/* Assume no proximity. Sensor will tell real state soon */
@@ -823,10 +826,12 @@ static ssize_t bh1770_set_prox_rate_above(struct device *dev,
 					const char *buf, size_t count)
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
-	unsigned long value;
+	int value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtoint(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&chip->mutex);
 	chip->prox_rate_threshold = bh1770_prox_rate_validate(value);
@@ -839,10 +844,12 @@ static ssize_t bh1770_set_prox_rate_below(struct device *dev,
 					const char *buf, size_t count)
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
-	unsigned long value;
+	int value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtoint(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&chip->mutex);
 	chip->prox_rate = bh1770_prox_rate_validate(value);
@@ -862,11 +869,12 @@ static ssize_t bh1770_set_prox_thres(struct device *dev,
 				      const char *buf, size_t count)
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
-	unsigned long value;
+	unsigned int value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtouint(buf, 0, &value);
+	if (ret < 0)
+		return ret;
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
 
@@ -892,10 +900,12 @@ static ssize_t bh1770_prox_persistence_store(struct device *dev,
 				const char *buf, size_t len)
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
-	unsigned long value;
+	unsigned int value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtouint(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	if (value > BH1770_PROX_MAX_PERSISTENCE)
 		return -EINVAL;
@@ -917,10 +927,12 @@ static ssize_t bh1770_prox_abs_thres_store(struct device *dev,
 				const char *buf, size_t len)
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
-	unsigned long value;
+	unsigned int value;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtouint(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
@@ -960,12 +972,14 @@ static ssize_t bh1770_lux_calib_store(struct device *dev,
 				  const char *buf, size_t len)
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
-	unsigned long value;
+	u32 value;
 	u32 old_calib;
 	u32 new_corr;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	rv = kstrtou32(buf, 0, &value);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&chip->mutex);
 	old_calib = chip->lux_calib;
@@ -1012,8 +1026,9 @@ static ssize_t bh1770_set_lux_rate(struct device *dev,
 	unsigned long rate_hz;
 	int ret, i;
 
-	if (strict_strtoul(buf, 0, &rate_hz))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &rate_hz);
+	if (ret < 0)
+		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(lux_rates_hz) - 1; i++)
 		if (rate_hz >= lux_rates_hz[i])
@@ -1047,11 +1062,12 @@ static ssize_t bh1770_get_lux_thresh_below(struct device *dev,
 static ssize_t bh1770_set_lux_thresh(struct bh1770_chip *chip, u16 *target,
 				const char *buf)
 {
-	int ret = 0;
 	unsigned long thresh;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &thresh))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &thresh);
+	if (ret < 0)
+		return ret;
 
 	if (thresh > BH1770_LUX_RANGE)
 		return -EINVAL;
diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index d5f3a3f..5faca8e 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -103,10 +103,10 @@ static ssize_t bh1780_store_power_state(struct device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct bh1780_data *ddata = platform_get_drvdata(pdev);
-	unsigned long val;
+	int val;
 	int error;
 
-	error = strict_strtoul(buf, 0, &val);
+	error = kstrtoint(buf, 0, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 63ee4c1..b656c36 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -86,7 +86,7 @@ struct bmp085_data {
 	struct bmp085_calibration_data calibration;
 	u32 raw_temperature;
 	u32 raw_pressure;
-	unsigned char oversampling_setting;
+	u8 oversampling_setting; /* [0, 3] */
 	u32 last_temp_measurement;
 	s32 b6; /* calculated temperature correction coefficient */
 };
@@ -284,22 +284,13 @@ exit:
  * increase both. The datasheet gives on overview on how measurement time,
  * accuracy and noise correlate.
  */
-static void bmp085_set_oversampling(struct bmp085_data *data,
-						unsigned char oversampling)
+static void bmp085_set_oversampling(struct bmp085_data *data, u8 oversampling)
 {
 	if (oversampling > 3)
 		oversampling = 3;
 	data->oversampling_setting = oversampling;
 }
 
-/*
- * Returns the currently selected oversampling. Range: 0..3
- */
-static unsigned char bmp085_get_oversampling(struct bmp085_data *data)
-{
-	return data->oversampling_setting;
-}
-
 /* sysfs callbacks */
 static ssize_t set_oversampling(struct device *dev,
 				struct device_attribute *attr,
@@ -307,13 +298,14 @@ static ssize_t set_oversampling(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct bmp085_data *data = i2c_get_clientdata(client);
-	unsigned long oversampling;
-	int success = strict_strtoul(buf, 10, &oversampling);
-	if (success == 0) {
-		bmp085_set_oversampling(data, oversampling);
-		return count;
-	}
-	return success;
+	u8 oversampling;
+	int rv;
+
+	rv = kstrtou8(buf, 10, &oversampling);
+	if (rv < 0)
+		return rv;
+	bmp085_set_oversampling(data, oversampling);
+	return count;
 }
 
 static ssize_t show_oversampling(struct device *dev,
@@ -321,7 +313,8 @@ static ssize_t show_oversampling(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct bmp085_data *data = i2c_get_clientdata(client);
-	return sprintf(buf, "%u\n", bmp085_get_oversampling(data));
+
+	return sprintf(buf, "%hhu\n", data->oversampling_setting);
 }
 static DEVICE_ATTR(oversampling, S_IWUSR | S_IRUGO,
 					show_oversampling, set_oversampling);
diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 46b3439..b7a653e 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -149,9 +149,9 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 	long val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err)
-		return -EINVAL;
+		return err;
 
 	if (val == 0) {
 		ep93xx_pwm_disable(pwm);
@@ -191,7 +191,7 @@ static ssize_t ep93xx_pwm_get_duty_percent(struct device *dev,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
 
-	return sprintf(buf, "%d\n", pwm->duty_percent);
+	return sprintf(buf, "%u\n", pwm->duty_percent);
 }
 
 static ssize_t ep93xx_pwm_set_duty_percent(struct device *dev,
@@ -199,21 +199,20 @@ static ssize_t ep93xx_pwm_set_duty_percent(struct device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	long val;
+	u32 term;
+	unsigned int val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
-	if (err)
+	err = kstrtouint(buf, 10, &val);
+	if (err < 0)
+		return err;
+	if (val >= 100)
 		return -EINVAL;
 
-	if (val > 0 && val < 100) {
-		u32 term = ep93xx_pwm_read_tc(pwm);
-		ep93xx_pwm_write_dc(pwm, ((term + 1) * val / 100) - 1);
-		pwm->duty_percent = val;
-		return count;
-	}
-
-	return -EINVAL;
+	term = ep93xx_pwm_read_tc(pwm);
+	ep93xx_pwm_write_dc(pwm, ((term + 1) * val / 100) - 1);
+	pwm->duty_percent = val;
+	return count;
 }
 
 static ssize_t ep93xx_pwm_get_invert(struct device *dev,
@@ -230,12 +229,12 @@ static ssize_t ep93xx_pwm_set_invert(struct device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	long val;
+	int val;
 	int err;
 
-	err = strict_strtol(buf, 10, &val);
+	err = kstrtoint(buf, 10, &val);
 	if (err)
-		return -EINVAL;
+		return err;
 
 	if (val == 0)
 		ep93xx_pwm_normal(pwm);
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 234bfca..8503368 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -43,11 +43,12 @@ static int compass_store(struct device *dev, const char *buf, size_t count,
 			const char *map)
 {
 	struct i2c_client *c = to_i2c_client(dev);
+	unsigned int val;
 	int ret;
-	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
 	if (val >= strlen(map))
 		return -EINVAL;
 	mutex_lock(&compass_mutex);
diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index a71e245..f66cda4 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -205,10 +205,13 @@ static ssize_t isl29003_store_range(struct device *dev,
 				    const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned long val;
+	unsigned int val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 3)
 		return -EINVAL;
 
 	ret = isl29003_set_range(client, val);
@@ -236,10 +239,13 @@ static ssize_t isl29003_store_resolution(struct device *dev,
 					 const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned long val;
+	unsigned int val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 3)
 		return -EINVAL;
 
 	ret = isl29003_set_resolution(client, val);
@@ -264,10 +270,13 @@ static ssize_t isl29003_store_mode(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned long val;
+	unsigned int val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 2))
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 2)
 		return -EINVAL;
 
 	ret = isl29003_set_mode(client, val);
@@ -295,10 +304,13 @@ static ssize_t isl29003_store_power_state(struct device *dev,
 					  const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned long val;
+	unsigned int val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 1))
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 1)
 		return -EINVAL;
 
 	ret = isl29003_set_power_state(client, val);
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 307aada..4d63b37 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -87,11 +87,12 @@ static ssize_t als_sensing_range_store(struct device *dev,
 		struct device_attribute *attr, const  char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	unsigned int val;
 	int ret_val;
-	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret_val = kstrtouint(buf, 10, &val);
+	if (ret_val < 0)
+		return ret_val;
 	if (val < 1 || val > 64000)
 		return -EINVAL;
 
diff --git a/drivers/misc/iwmc3200top/log.c b/drivers/misc/iwmc3200top/log.c
index a36a55a..9df9391 100644
--- a/drivers/misc/iwmc3200top/log.c
+++ b/drivers/misc/iwmc3200top/log.c
@@ -169,7 +169,6 @@ int log_get_fw_filter_str(char *buf, int size)
 	return _log_get_filter_str(iwmct_fw_logdefs, FW_LOG_SRC_MAX, buf, size);
 }
 
-#define HEXADECIMAL_RADIX	16
 #define LOG_SRC_FORMAT		7 /* log level is in format of "0xXXXX," */
 
 ssize_t show_iwmct_log_level(struct device *d,
@@ -206,40 +205,34 @@ ssize_t store_iwmct_log_level(struct device *d,
 			const char *buf, size_t count)
 {
 	struct iwmct_priv *priv = dev_get_drvdata(d);
-	char *token, *str_buf = NULL;
-	long val;
-	ssize_t ret = count;
-	u8 src, mask;
+	char *token, *str_buf, *p;
+	int ret;
 
 	if (!count)
-		goto exit;
+		return -EINVAL;
 
-	str_buf = kzalloc(count, GFP_KERNEL);
+	p = str_buf = kstrdup(buf, GFP_KERNEL);
 	if (!str_buf) {
 		LOG_ERROR(priv, DEBUGFS,
 			"failed to allocate %zd bytes\n", count);
-		ret = -ENOMEM;
-		goto exit;
+		return -ENOMEM;
 	}
 
-	memcpy(str_buf, buf, count);
+	while ((token = strsep(&p, ",")) != NULL) {
+		u16 val;
 
-	while ((token = strsep(&str_buf, ",")) != NULL) {
 		while (isspace(*token))
 			++token;
-		if (strict_strtol(token, HEXADECIMAL_RADIX, &val)) {
+		ret = kstrtou16(token, 16, &val);
+		if (ret < 0) {
 			LOG_ERROR(priv, DEBUGFS,
-				  "failed to convert string to long %s\n",
+				  "invalid integer \"%s\"\n",
 				  token);
-			ret = -EINVAL;
 			goto exit;
 		}
-
-		mask  = val & 0xFF;
-		src = (val & 0XFF00) >> 8;
-		iwmct_log_set_filter(src, mask);
+		iwmct_log_set_filter(val >> 8, val & 0xFF);
 	}
-
+	ret = count;
 exit:
 	kfree(str_buf);
 	return ret;
@@ -281,51 +274,50 @@ ssize_t store_iwmct_log_level_fw(struct device *d,
 {
 	struct iwmct_priv *priv = dev_get_drvdata(d);
 	struct top_msg cmd;
-	char *token, *str_buf = NULL;
-	ssize_t ret = count;
+	char *token, *str_buf, *p;
 	u16 cmdlen = 0;
 	int i;
-	long val;
-	u8 src, mask;
+	int ret;
 
 	if (!count)
-		goto exit;
+		return -EINVAL;
 
-	str_buf = kzalloc(count, GFP_KERNEL);
+	p = str_buf = kstrdup(buf, GFP_KERNEL);
 	if (!str_buf) {
 		LOG_ERROR(priv, DEBUGFS,
 			"failed to allocate %zd bytes\n", count);
-		ret = -ENOMEM;
-		goto exit;
+		return -ENOMEM;
 	}
 
-	memcpy(str_buf, buf, count);
-
 	cmd.hdr.type = COMM_TYPE_H2D;
 	cmd.hdr.category = COMM_CATEGORY_DEBUG;
 	cmd.hdr.opcode = CMD_DBG_LOG_LEVEL;
 
-	for (i = 0; ((token = strsep(&str_buf, ",")) != NULL) &&
+	for (i = 0; ((token = strsep(&p, ",")) != NULL) &&
 		     (i < FW_LOG_SRC_MAX); i++) {
+		u16 val;
+		u8 src, mask;
 
 		while (isspace(*token))
 			++token;
 
-		if (strict_strtol(token, HEXADECIMAL_RADIX, &val)) {
+		ret = kstrtou16(token, 16, &val);
+		if (ret < 0) {
 			LOG_ERROR(priv, DEBUGFS,
 				  "failed to convert string to long %s\n",
 				  token);
-			ret = -EINVAL;
-			goto exit;
+			kfree(str_buf);
+			return ret;
 		}
+		src = val >> 8;
+		mask = val & 0xFF;
 
-		mask  = val & 0xFF; /* LSB */
-		src = (val & 0XFF00) >> 8; /* 2nd least significant byte. */
 		iwmct_log_set_fw_filter(src, mask);
 
 		cmd.u.logdefs[i].logsource = src;
 		cmd.u.logdefs[i].sevmask = mask;
 	}
+	kfree(str_buf);
 
 	cmd.hdr.length = cpu_to_le16(i * sizeof(cmd.u.logdefs[0]));
 	cmdlen = (i * sizeof(cmd.u.logdefs[0]) + sizeof(cmd.hdr));
@@ -333,16 +325,12 @@ ssize_t store_iwmct_log_level_fw(struct device *d,
 	ret = iwmct_send_hcmd(priv, (u8 *)&cmd, cmdlen);
 	if (ret) {
 		LOG_ERROR(priv, DEBUGFS,
-			  "Failed to send %d bytes of fwcmd, ret=%zd\n",
+			  "Failed to send %d bytes of fwcmd, ret=%d\n",
 			  cmdlen, ret);
-		goto exit;
-	} else
-		LOG_INFO(priv, DEBUGFS, "fwcmd sent (%d bytes)\n", cmdlen);
-
-	ret = count;
+		return ret;
+	}
+	LOG_INFO(priv, DEBUGFS, "fwcmd sent (%d bytes)\n", cmdlen);
 
-exit:
-	kfree(str_buf);
-	return ret;
+	return count;
 }
 
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 7768b87..c29500c 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -161,15 +161,16 @@ static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
 	char buf[20];
+	int rv;
 
 	if (count >= sizeof(buf))
 		return -EINVAL;
 	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 	buf[count] = '\0';
-	if (strict_strtoul(buf, 0, &gru_options))
-		return -EINVAL;
-
+	rv = kstrtoul(buf, 0, &gru_options);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index d3f229a..ef9fd33 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -31,11 +31,13 @@ static ssize_t dac7512_store_val(struct device *dev,
 				 const char *buf, size_t count)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	unsigned char tmp[2];
-	unsigned long val;
+	u8 tmp[2];
+	u16 val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	rv = kstrtou16(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	tmp[0] = val >> 8;
 	tmp[1] = val & 0xff;
-- 
1.7.3.4

