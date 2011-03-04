Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1CDR6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:58:39 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37370 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501Ab1CDR5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:57:05 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 09/11] hwmon: (w83627ehf) Use 16 bit fan count registers if supported
Date: Fri, 4 Mar 2011 09:58:04 -0800
Message-ID: <1299261486-15190-10-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the chips supported by this driver have 13 bit or 16 bit fan count
registers. This patch improves support for those registers, specifically for
NCT6775F. With the changes in this patch, fan speed is reported correctly even
if the fan divider is set to a low value, which results in a fan speed reading
above 0xff.

With this patch, the width of fan count registers is no longer used to determine
if the chip has fan divider register(s) or not. A dedicated flag is used instead
to determine if this is the case.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/w83627ehf.c |   86 +++++++++++++++++++++++++++++++--------------
 1 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index b3b4f2b..df6e502 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -234,7 +234,7 @@ static const u16 NCT6775_REG_FAN_STOP_TIME[] = { 0x107, 0x207, 0x307 };
 static const u16 NCT6775_REG_PWM[] = { 0x109, 0x209, 0x309 };
 static const u16 NCT6775_REG_FAN_MAX_OUTPUT[] = { 0x10a, 0x20a, 0x30a };
 static const u16 NCT6775_REG_FAN_STEP_OUTPUT[] = { 0x10b, 0x20b, 0x30b };
-static const u16 NCT6776_REG_FAN[] = { 0x630, 0x632, 0x634, 0x636, 0x638 };
+static const u16 NCT6775_REG_FAN[] = { 0x630, 0x632, 0x634, 0x636, 0x638 };
 static const u16 NCT6776_REG_FAN_MIN[] = { 0x63a, 0x63c, 0x63e, 0x640, 0x642};
 
 static const u16 NCT6775_REG_TEMP[]
@@ -342,21 +342,36 @@ static inline u8 step_time_to_reg(unsigned int msec, u8 mode)
 						(msec + 200) / 400), 1, 255);
 }
 
-static inline unsigned int
-fan_from_reg(int reg, u16 val, unsigned int div)
+static unsigned int fan_from_reg8(u16 reg, unsigned int divreg)
 {
-	if (val == 0)
+	if (reg == 0 || reg == 255)
 		return 0;
-	if (is_word_sized(reg)) {
-		if ((val & 0xff1f) == 0xff1f)
-			return 0;
-		val = (val & 0x1f) | ((val & 0xff00) >> 3);
-	} else {
-		if (val == 255 || div == 0)
-			return 0;
-		val *= div;
-	}
-	return 1350000U / val;
+	return 1350000U / (reg << divreg);
+}
+
+static unsigned int fan_from_reg13(u16 reg, unsigned int divreg)
+{
+	if ((reg & 0xff1f) == 0xff1f)
+		return 0;
+
+	reg = (reg & 0x1f) | ((reg & 0xff00) >> 3);
+
+	if (reg == 0)
+		return 0;
+
+	return 1350000U / reg;
+}
+
+static unsigned int fan_from_reg16(u16 reg, unsigned int divreg)
+{
+	if (reg == 0 || reg == 0xffff)
+		return 0;
+
+	/*
+	 * Even though the registers are 16 bit wide, the fan divisor
+	 * still applies.
+	 */
+	return 1350000U / (reg << divreg);
 }
 
 static inline unsigned int
@@ -424,6 +439,9 @@ struct w83627ehf_data {
 	const u16 *REG_FAN_MAX_OUTPUT;
 	const u16 *REG_FAN_STEP_OUTPUT;
 
+	unsigned int (*fan_from_reg)(u16 reg, unsigned int divreg);
+	unsigned int (*fan_from_reg_min)(u16 reg, unsigned int divreg);
+
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -439,6 +457,7 @@ struct w83627ehf_data {
 	u8 fan_div[5];
 	u8 has_fan;		/* some fan inputs can be disabled */
 	u8 has_fan_min;		/* some fans don't have min register */
+	bool has_fan_div;
 	u8 temp_type[3];
 	s16 temp[9];
 	s16 temp_max[9];
@@ -769,8 +788,8 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			/* If we failed to measure the fan speed and clock
 			   divider can be increased, let's try that for next
 			   time */
-			if (!is_word_sized(data->REG_FAN[i])
-			    && (data->fan[i] == 0xff
+			if (data->has_fan_div
+			    && (data->fan[i] >= 0xff
 				|| (sio_data->kind == nct6775
 				    && data->fan[i] == 0x00))
 			    && data->fan_div[i] < 0x07) {
@@ -966,9 +985,7 @@ show_fan(struct device *dev, struct device_attribute *attr, char *buf)
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
 	return sprintf(buf, "%d\n",
-		       fan_from_reg(data->REG_FAN[nr],
-				    data->fan[nr],
-				    div_from_reg(data->fan_div[nr])));
+		       data->fan_from_reg(data->fan[nr], data->fan_div[nr]));
 }
 
 static ssize_t
@@ -978,9 +995,8 @@ show_fan_min(struct device *dev, struct device_attribute *attr, char *buf)
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
 	return sprintf(buf, "%d\n",
-		       fan_from_reg(data->REG_FAN_MIN[nr],
-				    data->fan_min[nr],
-				    div_from_reg(data->fan_div[nr])));
+		       data->fan_from_reg_min(data->fan_min[nr],
+					      data->fan_div[nr]));
 }
 
 static ssize_t
@@ -1010,7 +1026,11 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	mutex_lock(&data->update_lock);
-	if (is_word_sized(data->REG_FAN_MIN[nr])) {
+	if (!data->has_fan_div) {
+		/*
+		 * Only NCT6776F for now, so we know that this is a 13 bit
+		 * register
+		 */
 		if (!val) {
 			val = 0xff1f;
 		} else {
@@ -1034,7 +1054,7 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		new_div = 7; /* 128 == (1 << 7) */
 		dev_warn(dev, "fan%u low limit %lu below minimum %u, set to "
 			 "minimum\n", nr + 1, val,
-			 fan_from_reg(data->REG_FAN_MIN[nr], 254, 128));
+			 data->fan_from_reg_min(254, 7));
 	} else if (!reg) {
 		/* Speed above this value cannot possibly be represented,
 		   even with the lowest divider (1) */
@@ -1042,7 +1062,7 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		new_div = 0; /* 1 == (1 << 0) */
 		dev_warn(dev, "fan%u low limit %lu above maximum %u, set to "
 			 "maximum\n", nr + 1, val,
-			 fan_from_reg(data->REG_FAN_MIN[nr], 1, 1));
+			 data->fan_from_reg_min(1, 0));
 	} else {
 		/* Automatically pick the best divider, i.e. the one such
 		   that the min limit will correspond to a register value
@@ -1943,9 +1963,12 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	}
 
 	if (sio_data->kind == nct6775) {
+		data->has_fan_div = true;
+		data->fan_from_reg = fan_from_reg16;
+		data->fan_from_reg_min = fan_from_reg8;
 		data->REG_PWM = NCT6775_REG_PWM;
 		data->REG_TARGET = NCT6775_REG_TARGET;
-		data->REG_FAN = W83627EHF_REG_FAN;
+		data->REG_FAN = NCT6775_REG_FAN;
 		data->REG_FAN_MIN = W83627EHF_REG_FAN_MIN;
 		data->REG_FAN_START_OUTPUT = NCT6775_REG_FAN_START_OUTPUT;
 		data->REG_FAN_STOP_OUTPUT = NCT6775_REG_FAN_STOP_OUTPUT;
@@ -1953,14 +1976,20 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 		data->REG_FAN_MAX_OUTPUT = NCT6775_REG_FAN_MAX_OUTPUT;
 		data->REG_FAN_STEP_OUTPUT = NCT6775_REG_FAN_STEP_OUTPUT;
 	} else if (sio_data->kind == nct6776) {
+		data->has_fan_div = false;
+		data->fan_from_reg = fan_from_reg13;
+		data->fan_from_reg_min = fan_from_reg13;
 		data->REG_PWM = NCT6775_REG_PWM;
 		data->REG_TARGET = NCT6775_REG_TARGET;
-		data->REG_FAN = NCT6776_REG_FAN;
+		data->REG_FAN = NCT6775_REG_FAN;
 		data->REG_FAN_MIN = NCT6776_REG_FAN_MIN;
 		data->REG_FAN_START_OUTPUT = NCT6775_REG_FAN_START_OUTPUT;
 		data->REG_FAN_STOP_OUTPUT = NCT6775_REG_FAN_STOP_OUTPUT;
 		data->REG_FAN_STOP_TIME = NCT6775_REG_FAN_STOP_TIME;
 	} else if (sio_data->kind == w83667hg_b) {
+		data->has_fan_div = true;
+		data->fan_from_reg = fan_from_reg8;
+		data->fan_from_reg_min = fan_from_reg8;
 		data->REG_PWM = W83627EHF_REG_PWM;
 		data->REG_TARGET = W83627EHF_REG_TARGET;
 		data->REG_FAN = W83627EHF_REG_FAN;
@@ -1973,6 +2002,9 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 		data->REG_FAN_STEP_OUTPUT =
 		  W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B;
 	} else {
+		data->has_fan_div = true;
+		data->fan_from_reg = fan_from_reg8;
+		data->fan_from_reg_min = fan_from_reg8;
 		data->REG_PWM = W83627EHF_REG_PWM;
 		data->REG_TARGET = W83627EHF_REG_TARGET;
 		data->REG_FAN = W83627EHF_REG_FAN;
-- 
1.7.3.1

