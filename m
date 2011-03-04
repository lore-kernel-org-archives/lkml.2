Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1CDR4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:56:49 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37318 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab1CDR4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:56:47 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 01/11] hwmon: (w83627ehf) Unify temperature register access, and use strict string conversions
Date: Fri, 4 Mar 2011 09:57:56 -0800
Message-ID: <1299261486-15190-2-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies temperature register access, and replaces simple_strtoXXX
with strict_strtoXXX throughout the driver.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/w83627ehf.c |  219 +++++++++++++++++++++++----------------------
 1 files changed, 113 insertions(+), 106 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 073eabe..66e6855 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -164,13 +164,10 @@ static const u16 W83627EHF_REG_FAN_MIN[] = { 0x3b, 0x3c, 0x3d, 0x3e, 0x55c };
 #define W83627EHF_REG_IN(nr)		((nr < 7) ? (0x20 + (nr)) : \
 					 (0x550 + (nr) - 7))
 
-#define W83627EHF_REG_TEMP1		0x27
-#define W83627EHF_REG_TEMP1_HYST	0x3a
-#define W83627EHF_REG_TEMP1_OVER	0x39
-static const u16 W83627EHF_REG_TEMP[] = { 0x150, 0x250 };
-static const u16 W83627EHF_REG_TEMP_HYST[] = { 0x153, 0x253 };
-static const u16 W83627EHF_REG_TEMP_OVER[] = { 0x155, 0x255 };
-static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0x152, 0x252 };
+static const u16 W83627EHF_REG_TEMP[] = { 0x27, 0x150, 0x250 };
+static const u16 W83627EHF_REG_TEMP_HYST[] = { 0x3a, 0x153, 0x253 };
+static const u16 W83627EHF_REG_TEMP_OVER[] = { 0x39, 0x155, 0x255 };
+static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252 };
 
 /* Fan clock dividers are spread over the following five registers */
 #define W83627EHF_REG_FANDIV1		0x47
@@ -216,6 +213,15 @@ static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
 static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
 static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[] = { 0x68, 0x6a, 0x6c };
 
+static inline int is_word_sized(u16 reg)
+{
+	return (((reg & 0xff00) == 0x100
+	      || (reg & 0xff00) == 0x200)
+	     && ((reg & 0x00ff) == 0x50
+	      || (reg & 0x00ff) == 0x53
+	      || (reg & 0x00ff) == 0x55));
+}
+
 /*
  * Conversions
  */
@@ -247,21 +253,19 @@ div_from_reg(u8 reg)
 }
 
 static inline int
-temp1_from_reg(s8 reg)
+temp_from_reg(u16 reg, s16 regval)
 {
-	return reg * 1000;
+	if (is_word_sized(reg))
+		return LM75_TEMP_FROM_REG(regval);
+	return regval * 1000;
 }
 
-static inline s8
-temp1_to_reg(long temp, int min, int max)
+static inline s16
+temp_to_reg(u16 reg, long temp)
 {
-	if (temp <= min)
-		return min / 1000;
-	if (temp >= max)
-		return max / 1000;
-	if (temp < 0)
-		return (temp - 500) / 1000;
-	return (temp + 500) / 1000;
+	if (is_word_sized(reg))
+		return LM75_TEMP_TO_REG(temp);
+	return DIV_ROUND_CLOSEST(SENSORS_LIMIT(temp, -127000, 128000), 1000);
 }
 
 /* Some of analog inputs have internal scaling (2x), 8mV is ADC LSB */
@@ -308,12 +312,9 @@ struct w83627ehf_data {
 	u8 fan_div[5];
 	u8 has_fan;		/* some fan inputs can be disabled */
 	u8 temp_type[3];
-	s8 temp1;
-	s8 temp1_max;
-	s8 temp1_max_hyst;
-	s16 temp[2];
-	s16 temp_max[2];
-	s16 temp_max_hyst[2];
+	s16 temp[3];
+	s16 temp_max[3];
+	s16 temp_max_hyst[3];
 	u32 alarms;
 
 	u8 pwm_mode[4]; /* 0->DC variable voltage, 1->PWM variable duty cycle */
@@ -344,15 +345,6 @@ struct w83627ehf_sio_data {
 	enum kinds kind;
 };
 
-static inline int is_word_sized(u16 reg)
-{
-	return (((reg & 0xff00) == 0x100
-	      || (reg & 0xff00) == 0x200)
-	     && ((reg & 0x00ff) == 0x50
-	      || (reg & 0x00ff) == 0x53
-	      || (reg & 0x00ff) == 0x55));
-}
-
 /* Registers 0x50-0x5f are banked */
 static inline void w83627ehf_set_bank(struct w83627ehf_data *data, u16 reg)
 {
@@ -586,13 +578,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 		}
 
 		/* Measured temperatures and limits */
-		data->temp1 = w83627ehf_read_value(data,
-			      W83627EHF_REG_TEMP1);
-		data->temp1_max = w83627ehf_read_value(data,
-				  W83627EHF_REG_TEMP1_OVER);
-		data->temp1_max_hyst = w83627ehf_read_value(data,
-				       W83627EHF_REG_TEMP1_HYST);
-		for (i = 0; i < 2; i++) {
+		for (i = 0; i < 3; i++) {
 			data->temp[i] = w83627ehf_read_value(data,
 					W83627EHF_REG_TEMP[i]);
 			data->temp_max[i] = w83627ehf_read_value(data,
@@ -641,8 +627,11 @@ store_in_##reg (struct device *dev, struct device_attribute *attr, \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
-	u32 val = simple_strtoul(buf, NULL, 10); \
- \
+	unsigned long val; \
+	int err; \
+	err = strict_strtoul(buf, 10, &val); \
+	if (err < 0) \
+		return err; \
 	mutex_lock(&data->update_lock); \
 	data->in_##reg[nr] = in_to_reg(val, nr); \
 	w83627ehf_write_value(data, W83627EHF_REG_IN_##REG(nr), \
@@ -746,10 +735,15 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
-	unsigned int val = simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+	int err;
 	unsigned int reg;
 	u8 new_div;
 
+	err = strict_strtoul(buf, 10, &val);
+	if (err < 0)
+		return err;
+
 	mutex_lock(&data->update_lock);
 	if (!val) {
 		/* No min limit, alarm disabled */
@@ -761,14 +755,14 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		   even with the highest divider (128) */
 		data->fan_min[nr] = 254;
 		new_div = 7; /* 128 == (1 << 7) */
-		dev_warn(dev, "fan%u low limit %u below minimum %u, set to "
+		dev_warn(dev, "fan%u low limit %lu below minimum %u, set to "
 			 "minimum\n", nr + 1, val, fan_from_reg(254, 128));
 	} else if (!reg) {
 		/* Speed above this value cannot possibly be represented,
 		   even with the lowest divider (1) */
 		data->fan_min[nr] = 1;
 		new_div = 0; /* 1 == (1 << 0) */
-		dev_warn(dev, "fan%u low limit %u above maximum %u, set to "
+		dev_warn(dev, "fan%u low limit %lu above maximum %u, set to "
 			 "maximum\n", nr + 1, val, fan_from_reg(1, 1));
 	} else {
 		/* Automatically pick the best divider, i.e. the one such
@@ -847,37 +841,7 @@ static struct sensor_device_attribute sda_fan_div[] = {
 	SENSOR_ATTR(fan5_div, S_IRUGO, show_fan_div, NULL, 4),
 };
 
-#define show_temp1_reg(reg) \
-static ssize_t \
-show_##reg(struct device *dev, struct device_attribute *attr, \
-	   char *buf) \
-{ \
-	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	return sprintf(buf, "%d\n", temp1_from_reg(data->reg)); \
-}
-show_temp1_reg(temp1);
-show_temp1_reg(temp1_max);
-show_temp1_reg(temp1_max_hyst);
-
-#define store_temp1_reg(REG, reg) \
-static ssize_t \
-store_temp1_##reg(struct device *dev, struct device_attribute *attr, \
-		  const char *buf, size_t count) \
-{ \
-	struct w83627ehf_data *data = dev_get_drvdata(dev); \
-	long val = simple_strtol(buf, NULL, 10); \
- \
-	mutex_lock(&data->update_lock); \
-	data->temp1_##reg = temp1_to_reg(val, -128000, 127000); \
-	w83627ehf_write_value(data, W83627EHF_REG_TEMP1_##REG, \
-			      data->temp1_##reg); \
-	mutex_unlock(&data->update_lock); \
-	return count; \
-}
-store_temp1_reg(OVER, max);
-store_temp1_reg(HYST, max_hyst);
-
-#define show_temp_reg(reg) \
+#define show_temp_reg(REG, reg) \
 static ssize_t \
 show_##reg(struct device *dev, struct device_attribute *attr, \
 	   char *buf) \
@@ -886,11 +850,11 @@ show_##reg(struct device *dev, struct device_attribute *attr, \
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", \
-		       LM75_TEMP_FROM_REG(data->reg[nr])); \
+		       temp_from_reg(W83627EHF_REG_##REG[nr], data->reg[nr])); \
 }
-show_temp_reg(temp);
-show_temp_reg(temp_max);
-show_temp_reg(temp_max_hyst);
+show_temp_reg(TEMP, temp);
+show_temp_reg(TEMP_OVER, temp_max);
+show_temp_reg(TEMP_HYST, temp_max_hyst);
 
 #define store_temp_reg(REG, reg) \
 static ssize_t \
@@ -900,10 +864,13 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
-	long val = simple_strtol(buf, NULL, 10); \
- \
+	int err; \
+	long val; \
+	err = strict_strtol(buf, 10, &val); \
+	if (err < 0) \
+		return err; \
 	mutex_lock(&data->update_lock); \
-	data->reg[nr] = LM75_TEMP_TO_REG(val); \
+	data->reg[nr] = temp_to_reg(W83627EHF_REG_TEMP_##REG[nr], val); \
 	w83627ehf_write_value(data, W83627EHF_REG_TEMP_##REG[nr], \
 			      data->reg[nr]); \
 	mutex_unlock(&data->update_lock); \
@@ -922,27 +889,27 @@ show_temp_type(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static struct sensor_device_attribute sda_temp_input[] = {
-	SENSOR_ATTR(temp1_input, S_IRUGO, show_temp1, NULL, 0),
-	SENSOR_ATTR(temp2_input, S_IRUGO, show_temp, NULL, 0),
-	SENSOR_ATTR(temp3_input, S_IRUGO, show_temp, NULL, 1),
+	SENSOR_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0),
+	SENSOR_ATTR(temp2_input, S_IRUGO, show_temp, NULL, 1),
+	SENSOR_ATTR(temp3_input, S_IRUGO, show_temp, NULL, 2),
 };
 
 static struct sensor_device_attribute sda_temp_max[] = {
-	SENSOR_ATTR(temp1_max, S_IRUGO | S_IWUSR, show_temp1_max,
-		    store_temp1_max, 0),
-	SENSOR_ATTR(temp2_max, S_IRUGO | S_IWUSR, show_temp_max,
+	SENSOR_ATTR(temp1_max, S_IRUGO | S_IWUSR, show_temp_max,
 		    store_temp_max, 0),
-	SENSOR_ATTR(temp3_max, S_IRUGO | S_IWUSR, show_temp_max,
+	SENSOR_ATTR(temp2_max, S_IRUGO | S_IWUSR, show_temp_max,
 		    store_temp_max, 1),
+	SENSOR_ATTR(temp3_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 2),
 };
 
 static struct sensor_device_attribute sda_temp_max_hyst[] = {
-	SENSOR_ATTR(temp1_max_hyst, S_IRUGO | S_IWUSR, show_temp1_max_hyst,
-		    store_temp1_max_hyst, 0),
-	SENSOR_ATTR(temp2_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+	SENSOR_ATTR(temp1_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
 		    store_temp_max_hyst, 0),
-	SENSOR_ATTR(temp3_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+	SENSOR_ATTR(temp2_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
 		    store_temp_max_hyst, 1),
+	SENSOR_ATTR(temp3_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 2),
 };
 
 static struct sensor_device_attribute sda_temp_alarm[] = {
@@ -978,9 +945,14 @@ store_pwm_mode(struct device *dev, struct device_attribute *attr,
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
-	u32 val = simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+	int err;
 	u16 reg;
 
+	err = strict_strtoul(buf, 10, &val);
+	if (err < 0)
+		return err;
+
 	if (val > 1)
 		return -EINVAL;
 	mutex_lock(&data->update_lock);
@@ -1001,7 +973,14 @@ store_pwm(struct device *dev, struct device_attribute *attr,
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
-	u32 val = SENSORS_LIMIT(simple_strtoul(buf, NULL, 10), 0, 255);
+	unsigned long val;
+	int err;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err < 0)
+		return err;
+
+	val = SENSORS_LIMIT(val, 0, 255);
 
 	mutex_lock(&data->update_lock);
 	data->pwm[nr] = val;
@@ -1017,9 +996,14 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
-	u32 val = simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+	int err;
 	u16 reg;
 
+	err = strict_strtoul(buf, 10, &val);
+	if (err < 0)
+		return err;
+
 	if (!val || (val > 4))
 		return -EINVAL;
 	mutex_lock(&data->update_lock);
@@ -1040,7 +1024,7 @@ static ssize_t show_##reg(struct device *dev, struct device_attribute *attr, \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
-	return sprintf(buf, "%d\n", temp1_from_reg(data->reg[nr])); \
+	return sprintf(buf, "%d\n", data->reg[nr] * 1000); \
 }
 
 show_tol_temp(tolerance)
@@ -1053,7 +1037,14 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
-	u8 val = temp1_to_reg(simple_strtoul(buf, NULL, 10), 0, 127000);
+	long val;
+	int err;
+
+	err = strict_strtol(buf, 10, &val);
+	if (err < 0)
+		return err;
+
+	val = SENSORS_LIMIT(DIV_ROUND_CLOSEST(val, 1000), 0, 127);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -1070,8 +1061,15 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
 	u16 reg;
+	long val;
+	int err;
+
+	err = strict_strtol(buf, 10, &val);
+	if (err < 0)
+		return err;
+
 	/* Limit the temp to 0C - 15C */
-	u8 val = temp1_to_reg(simple_strtoul(buf, NULL, 10), 0, 15000);
+	val = SENSORS_LIMIT(DIV_ROUND_CLOSEST(val, 1000), 0, 15);
 
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_TOLERANCE[nr]);
@@ -1154,7 +1152,12 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
-	u32 val = SENSORS_LIMIT(simple_strtoul(buf, NULL, 10), 1, 255); \
+	unsigned long val; \
+	int err; \
+	err = strict_strtoul(buf, 10, &val); \
+	if (err < 0) \
+		return err; \
+	val = SENSORS_LIMIT(val, 1, 255); \
 	mutex_lock(&data->update_lock); \
 	data->reg[nr] = val; \
 	w83627ehf_write_value(data, data->REG_##REG[nr], val); \
@@ -1185,8 +1188,12 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
-	u8 val = step_time_to_reg(simple_strtoul(buf, NULL, 10), \
-					data->pwm_mode[nr]); \
+	unsigned long val; \
+	int err; \
+	err = strict_strtoul(buf, 10, &val); \
+	if (err < 0) \
+		return err; \
+	val = step_time_to_reg(val, data->pwm_mode[nr]); \
 	mutex_lock(&data->update_lock); \
 	data->reg[nr] = val; \
 	w83627ehf_write_value(data, W83627EHF_REG_##REG[nr], val); \
@@ -1336,10 +1343,10 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
 				      tmp | 0x01);
 
 	/* Enable temp2 and temp3 if needed */
-	for (i = 0; i < 2; i++) {
+	for (i = 1; i < 3; i++) {
 		tmp = w83627ehf_read_value(data,
 					   W83627EHF_REG_TEMP_CONFIG[i]);
-		if ((i == 1) && data->temp3_disable)
+		if ((i == 2) && data->temp3_disable)
 			continue;
 		if (tmp & 0x01)
 			w83627ehf_write_value(data,
@@ -1400,7 +1407,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	/* Check temp3 configuration bit for 667HG */
 	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		data->temp3_disable = w83627ehf_read_value(data,
-					W83627EHF_REG_TEMP_CONFIG[1]) & 0x01;
+					W83627EHF_REG_TEMP_CONFIG[2]) & 0x01;
 		data->in6_skip = !data->temp3_disable;
 	}
 
-- 
1.7.3.1

