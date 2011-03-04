Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1CDR56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:57:58 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37378 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1CDR5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:57:06 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 04/11] hwmon: (w83627ehf) Improve support for W83667HG-B
Date: Fri, 4 Mar 2011 09:57:59 -0800
Message-ID: <1299261486-15190-5-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for 4th temperature sensor on W83677HG-B.
Display temperature labels on W83677HG-B to report temperature sources.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/w83627ehf |   19 +++--
 drivers/hwmon/w83627ehf.c     |  155 ++++++++++++++++++++++++++++++++--------
 2 files changed, 136 insertions(+), 38 deletions(-)

diff --git a/Documentation/hwmon/w83627ehf b/Documentation/hwmon/w83627ehf
index 13d5561..0643019 100644
--- a/Documentation/hwmon/w83627ehf
+++ b/Documentation/hwmon/w83627ehf
@@ -39,16 +39,21 @@ This driver implements support for the Winbond W83627EHF, W83627EHG,
 W83627DHG, W83627DHG-P, W83667HG and W83667HG-B super I/O chips.
 We will refer to them collectively as Winbond chips.
 
-The chips implement three temperature sensors, five fan rotation
-speed sensors, ten analog voltage sensors (only nine for the 627DHG), one
-VID (6 pins for the 627EHF/EHG, 8 pins for the 627DHG and 667HG), alarms
-with beep warnings (control unimplemented), and some automatic fan
+The chips implement three temperature sensors (up to four for 667HG-B),
+five fan rotation speed sensors, ten analog voltage sensors (only nine for the
+627DHG), one VID (6 pins for the 627EHF/EHG, 8 pins for the 627DHG and 667HG),
+alarms with beep warnings (control unimplemented), and some automatic fan
 regulation strategies (plus manual fan control mode).
 
+The temperature sensor sources on W82677HG-B are configurable. temp4 is only
+reported if its temperature source differs from the temperature sources of the
+other three temperature sensors. The configured source for each of the
+temperature sensors is reported in tempX_label.
+
 Temperatures are measured in degrees Celsius and measurement resolution is 1
-degC for temp1 and 0.5 degC for temp2 and temp3. An alarm is triggered when
-the temperature gets higher than high limit; it stays on until the temperature
-falls below the hysteresis value.
+degC for temp1 and temp4, and 0.5 degC for temp2 and temp3. An alarm is
+triggered when the temperature gets higher than high limit; it stays on until
+the temperature falls below the hysteresis value.
 
 Fan rotation speeds are reported in RPM (rotations per minute). An alarm is
 triggered if the rotation speed has dropped below a programmable limit. Fan
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 5a627b9..d10fe70 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -39,7 +39,7 @@
     w83627dhg    9      5       4       3      0xa020 0xc1    0x5ca3
     w83627dhg-p  9      5       4       3      0xb070 0xc1    0x5ca3
     w83667hg     9      5       3       3      0xa510 0xc1    0x5ca3
-    w83667hg-b   9      5       3       3      0xb350 0xc1    0x5ca3
+    w83667hg-b   9      5       3       4      0xb350 0xc1    0x5ca3
 */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -164,10 +164,10 @@ static const u16 W83627EHF_REG_FAN_MIN[] = { 0x3b, 0x3c, 0x3d, 0x3e, 0x55c };
 #define W83627EHF_REG_IN(nr)		((nr < 7) ? (0x20 + (nr)) : \
 					 (0x550 + (nr) - 7))
 
-static const u16 W83627EHF_REG_TEMP[] = { 0x27, 0x150, 0x250 };
-static const u16 W83627EHF_REG_TEMP_HYST[] = { 0x3a, 0x153, 0x253 };
-static const u16 W83627EHF_REG_TEMP_OVER[] = { 0x39, 0x155, 0x255 };
-static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252 };
+static const u16 W83627EHF_REG_TEMP[] = { 0x27, 0x150, 0x250, 0x7e };
+static const u16 W83627EHF_REG_TEMP_HYST[] = { 0x3a, 0x153, 0x253, 0 };
+static const u16 W83627EHF_REG_TEMP_OVER[] = { 0x39, 0x155, 0x255, 0 };
+static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252, 0 };
 
 /* Fan clock dividers are spread over the following five registers */
 #define W83627EHF_REG_FANDIV1		0x47
@@ -213,6 +213,19 @@ static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
 static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
 static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[] = { 0x68, 0x6a, 0x6c };
 
+static const char *const w83667hg_b_temp_label[] = {
+	"SYSTIN",
+	"CPUTIN",
+	"AUXTIN",
+	"AMDTSI",
+	"PECI Agent 1",
+	"PECI Agent 2",
+	"PECI Agent 3",
+	"PECI Agent 4"
+};
+
+#define NUM_REG_TEMP	4
+
 static inline int is_word_sized(u16 reg)
 {
 	return (((reg & 0xff00) == 0x100
@@ -294,6 +307,9 @@ struct w83627ehf_data {
 	struct device *hwmon_dev;
 	struct mutex lock;
 
+	u8 temp_src[NUM_REG_TEMP];
+	const char * const *temp_label;
+
 	const u8 *REG_FAN_START_OUTPUT;
 	const u8 *REG_FAN_STOP_OUTPUT;
 	const u8 *REG_FAN_MAX_OUTPUT;
@@ -314,9 +330,9 @@ struct w83627ehf_data {
 	u8 fan_div[5];
 	u8 has_fan;		/* some fan inputs can be disabled */
 	u8 temp_type[3];
-	s16 temp[3];
-	s16 temp_max[3];
-	s16 temp_max_hyst[3];
+	s16 temp[4];
+	s16 temp_max[4];
+	s16 temp_max_hyst[4];
 	u32 alarms;
 
 	u8 pwm_mode[4]; /* 0->DC variable voltage, 1->PWM variable duty cycle */
@@ -339,7 +355,7 @@ struct w83627ehf_data {
 	u8 vid;
 	u8 vrm;
 
-	u8 temp3_disable;
+	u8 have_temp;
 	u8 in6_skip;
 };
 
@@ -577,12 +593,18 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 		}
 
 		/* Measured temperatures and limits */
-		for (i = 0; i < 3; i++) {
-			data->temp[i] = w83627ehf_read_value(data,
-					W83627EHF_REG_TEMP[i]);
-			data->temp_max[i] = w83627ehf_read_value(data,
-					    W83627EHF_REG_TEMP_OVER[i]);
-			data->temp_max_hyst[i] = w83627ehf_read_value(data,
+		for (i = 0; i < NUM_REG_TEMP; i++) {
+			if (!(data->have_temp & (1 << i)))
+				continue;
+			data->temp[i]
+			  = w83627ehf_read_value(data, W83627EHF_REG_TEMP[i]);
+			if (i > 2)
+				break;
+			data->temp_max[i]
+			  = w83627ehf_read_value(data,
+						 W83627EHF_REG_TEMP_OVER[i]);
+			data->temp_max_hyst[i]
+			  = w83627ehf_read_value(data,
 						 W83627EHF_REG_TEMP_HYST[i]);
 		}
 
@@ -844,6 +866,15 @@ static struct sensor_device_attribute sda_fan_div[] = {
 	SENSOR_ATTR(fan5_div, S_IRUGO, show_fan_div, NULL, 4),
 };
 
+static ssize_t
+show_temp_label(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct w83627ehf_data *data = w83627ehf_update_device(dev);
+	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
+	int nr = sensor_attr->index;
+	return sprintf(buf, "%s\n", data->temp_label[data->temp_src[nr]]);
+}
+
 #define show_temp_reg(REG, reg) \
 static ssize_t \
 show_##reg(struct device *dev, struct device_attribute *attr, \
@@ -897,6 +928,14 @@ static struct sensor_device_attribute sda_temp_input[] = {
 	SENSOR_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0),
 	SENSOR_ATTR(temp2_input, S_IRUGO, show_temp, NULL, 1),
 	SENSOR_ATTR(temp3_input, S_IRUGO, show_temp, NULL, 2),
+	SENSOR_ATTR(temp4_input, S_IRUGO, show_temp, NULL, 3),
+};
+
+static struct sensor_device_attribute sda_temp_label[] = {
+	SENSOR_ATTR(temp1_label, S_IRUGO, show_temp_label, NULL, 0),
+	SENSOR_ATTR(temp2_label, S_IRUGO, show_temp_label, NULL, 1),
+	SENSOR_ATTR(temp3_label, S_IRUGO, show_temp_label, NULL, 2),
+	SENSOR_ATTR(temp4_label, S_IRUGO, show_temp_label, NULL, 3),
 };
 
 static struct sensor_device_attribute sda_temp_max[] = {
@@ -1328,10 +1367,13 @@ static void w83627ehf_device_remove_files(struct device *dev)
 		device_remove_file(dev, &sda_target_temp[i].dev_attr);
 		device_remove_file(dev, &sda_tolerance[i].dev_attr);
 	}
-	for (i = 0; i < 3; i++) {
-		if ((i == 2) && data->temp3_disable)
+	for (i = 0; i < NUM_REG_TEMP; i++) {
+		if (!(data->have_temp & (1 << i)))
 			continue;
 		device_remove_file(dev, &sda_temp_input[i].dev_attr);
+		device_remove_file(dev, &sda_temp_label[i].dev_attr);
+		if (i > 2)
+			break;
 		device_remove_file(dev, &sda_temp_max[i].dev_attr);
 		device_remove_file(dev, &sda_temp_max_hyst[i].dev_attr);
 		device_remove_file(dev, &sda_temp_alarm[i].dev_attr);
@@ -1354,12 +1396,14 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
 		w83627ehf_write_value(data, W83627EHF_REG_CONFIG,
 				      tmp | 0x01);
 
-	/* Enable temp2 and temp3 if needed */
-	for (i = 1; i < 3; i++) {
+	/* Enable temperature sensors if needed */
+	for (i = 0; i < NUM_REG_TEMP; i++) {
+		if (!(data->have_temp & (1 << i)))
+			continue;
+		if (!W83627EHF_REG_TEMP_CONFIG[i])
+			continue;
 		tmp = w83627ehf_read_value(data,
 					   W83627EHF_REG_TEMP_CONFIG[i]);
-		if ((i == 2) && data->temp3_disable)
-			continue;
 		if (tmp & 0x01)
 			w83627ehf_write_value(data,
 					      W83627EHF_REG_TEMP_CONFIG[i],
@@ -1417,11 +1461,52 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	data->pwm_num = (sio_data->kind == w83667hg
 			 || sio_data->kind == w83667hg_b) ? 3 : 4;
 
+	data->have_temp = 0x07;
 	/* Check temp3 configuration bit for 667HG */
-	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
-		data->temp3_disable = w83627ehf_read_value(data,
-					W83627EHF_REG_TEMP_CONFIG[2]) & 0x01;
-		data->in6_skip = !data->temp3_disable;
+	if (sio_data->kind == w83667hg) {
+		u8 reg;
+
+		reg = w83627ehf_read_value(data, W83627EHF_REG_TEMP_CONFIG[2]);
+		if (reg & 0x01)
+			data->have_temp &= ~(1 << 2);
+		else
+			data->in6_skip = 1; /* Either temp3 or in6 */
+	} else if (sio_data->kind == w83667hg_b) {
+		u8 reg;
+
+		reg = w83627ehf_read_value(data, 0x4a);
+		data->temp_src[0] = reg >> 5;
+		reg = w83627ehf_read_value(data, 0x49);
+		data->temp_src[1] = reg & 0x07;
+		data->temp_src[2] = (reg >> 4)  & 0x07;
+
+		/*
+		 * W83667HG-B has another temperature register at 0x7e.
+		 * The temperature source is selected with register 0x7d.
+		 * Support it if the source differs from already reported
+		 * sources.
+		 */
+		reg = w83627ehf_read_value(data, 0x7d);
+		reg &= 0x07;
+		if (reg != data->temp_src[0] && reg != data->temp_src[1]
+		    && reg != data->temp_src[2]) {
+			data->temp_src[3] = reg;
+			data->have_temp |= 1 << 3;
+		}
+
+		/*
+		 * Chip supports either AUXTIN or VIN3. Try to find out which
+		 * one.
+		 */
+		reg = w83627ehf_read_value(data, W83627EHF_REG_TEMP_CONFIG[2]);
+		if (data->temp_src[2] == 2 && (reg & 0x01))
+			data->have_temp &= ~(1 << 2);
+
+		if ((data->temp_src[2] == 2 && (data->have_temp & (1 << 2)))
+		    || (data->temp_src[3] == 2 && (data->have_temp & (1 << 3))))
+			data->in6_skip = 1;
+
+		data->temp_label = w83667hg_b_temp_label;
 	}
 
 	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
@@ -1584,13 +1669,21 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < 3; i++) {
-		if ((i == 2) && data->temp3_disable)
+	for (i = 0; i < NUM_REG_TEMP; i++) {
+		if (!(data->have_temp & (1 << i)))
 			continue;
-		if ((err = device_create_file(dev,
-				&sda_temp_input[i].dev_attr))
-			|| (err = device_create_file(dev,
-				&sda_temp_max[i].dev_attr))
+		err = device_create_file(dev, &sda_temp_input[i].dev_attr);
+		if (err)
+			goto exit_remove;
+		if (data->temp_label) {
+			err = device_create_file(dev,
+						 &sda_temp_label[i].dev_attr);
+			if (err)
+				goto exit_remove;
+		}
+		if (i > 2)
+			break;
+		if ((err = device_create_file(dev, &sda_temp_max[i].dev_attr))
 			|| (err = device_create_file(dev,
 				&sda_temp_max_hyst[i].dev_attr))
 			|| (err = device_create_file(dev,
-- 
1.7.3.1

