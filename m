Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab1CDR6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:58:00 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37377 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab1CDR5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:57:06 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 06/11] hwmon: (w83627ehf) Convert register arrays to 16 bit, and convert access to pointers
Date: Fri, 4 Mar 2011 09:58:01 -0800
Message-ID: <1299261486-15190-7-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For newer chips, several registers are banked and thus need to be 16 bit.
Also, register addresses change.

To prepare for those chips, convert affected register arrays to 16 bit,
and change access to those registers to array pointers in struct w83627ehf_data.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/w83627ehf.c |   60 +++++++++++++++++++++++++++------------------
 1 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index d10fe70..2420f1c 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -196,22 +196,23 @@ static const u8 W83627EHF_PWM_MODE_SHIFT[] = { 0, 1, 0, 6 };
 static const u8 W83627EHF_PWM_ENABLE_SHIFT[] = { 2, 4, 1, 4 };
 
 /* FAN Duty Cycle, be used to control */
-static const u8 W83627EHF_REG_PWM[] = { 0x01, 0x03, 0x11, 0x61 };
-static const u8 W83627EHF_REG_TARGET[] = { 0x05, 0x06, 0x13, 0x63 };
+static const u16 W83627EHF_REG_PWM[] = { 0x01, 0x03, 0x11, 0x61 };
+static const u16 W83627EHF_REG_TARGET[] = { 0x05, 0x06, 0x13, 0x63 };
 static const u8 W83627EHF_REG_TOLERANCE[] = { 0x07, 0x07, 0x14, 0x62 };
 
 /* Advanced Fan control, some values are common for all fans */
-static const u8 W83627EHF_REG_FAN_START_OUTPUT[] = { 0x0a, 0x0b, 0x16, 0x65 };
-static const u8 W83627EHF_REG_FAN_STOP_OUTPUT[] = { 0x08, 0x09, 0x15, 0x64 };
-static const u8 W83627EHF_REG_FAN_STOP_TIME[] = { 0x0c, 0x0d, 0x17, 0x66 };
+static const u16 W83627EHF_REG_FAN_START_OUTPUT[] = { 0x0a, 0x0b, 0x16, 0x65 };
+static const u16 W83627EHF_REG_FAN_STOP_OUTPUT[] = { 0x08, 0x09, 0x15, 0x64 };
+static const u16 W83627EHF_REG_FAN_STOP_TIME[] = { 0x0c, 0x0d, 0x17, 0x66 };
 
-static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_COMMON[]
+static const u16 W83627EHF_REG_FAN_MAX_OUTPUT_COMMON[]
 						= { 0xff, 0x67, 0xff, 0x69 };
-static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
+static const u16 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
 						= { 0xff, 0x68, 0xff, 0x6a };
 
-static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
-static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[] = { 0x68, 0x6a, 0x6c };
+static const u16 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
+static const u16 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[]
+						= { 0x68, 0x6a, 0x6c };
 
 static const char *const w83667hg_b_temp_label[] = {
 	"SYSTIN",
@@ -310,10 +311,15 @@ struct w83627ehf_data {
 	u8 temp_src[NUM_REG_TEMP];
 	const char * const *temp_label;
 
-	const u8 *REG_FAN_START_OUTPUT;
-	const u8 *REG_FAN_STOP_OUTPUT;
-	const u8 *REG_FAN_MAX_OUTPUT;
-	const u8 *REG_FAN_STEP_OUTPUT;
+	const u16 *REG_PWM;
+	const u16 *REG_TARGET;
+	const u16 *REG_FAN;
+	const u16 *REG_FAN_MIN;
+	const u16 *REG_FAN_START_OUTPUT;
+	const u16 *REG_FAN_STOP_OUTPUT;
+	const u16 *REG_FAN_STOP_TIME;
+	const u16 *REG_FAN_MAX_OUTPUT;
+	const u16 *REG_FAN_STEP_OUTPUT;
 
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
@@ -524,9 +530,9 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 				continue;
 
 			data->fan[i] = w83627ehf_read_value(data,
-				       W83627EHF_REG_FAN[i]);
+				       data->REG_FAN[i]);
 			data->fan_min[i] = w83627ehf_read_value(data,
-					   W83627EHF_REG_FAN_MIN[i]);
+					   data->REG_FAN_MIN[i]);
 
 			/* If we failed to measure the fan speed and clock
 			   divider can be increased, let's try that for next
@@ -543,7 +549,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 				if (data->fan_min[i] >= 2
 				 && data->fan_min[i] != 255)
 					w83627ehf_write_value(data,
-						W83627EHF_REG_FAN_MIN[i],
+						data->REG_FAN_MIN[i],
 						(data->fan_min[i] /= 2));
 			}
 		}
@@ -566,13 +572,13 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 				((pwmcfg >> W83627EHF_PWM_ENABLE_SHIFT[i])
 				& 3) + 1;
 			data->pwm[i] = w83627ehf_read_value(data,
-						W83627EHF_REG_PWM[i]);
+							    data->REG_PWM[i]);
 			data->fan_start_output[i] = w83627ehf_read_value(data,
-					W83627EHF_REG_FAN_START_OUTPUT[i]);
+					data->REG_FAN_START_OUTPUT[i]);
 			data->fan_stop_output[i] = w83627ehf_read_value(data,
-					W83627EHF_REG_FAN_STOP_OUTPUT[i]);
+					data->REG_FAN_STOP_OUTPUT[i]);
 			data->fan_stop_time[i] = w83627ehf_read_value(data,
-					W83627EHF_REG_FAN_STOP_TIME[i]);
+					data->REG_FAN_STOP_TIME[i]);
 
 			if (data->REG_FAN_MAX_OUTPUT[i] != 0xff)
 				data->fan_max_output[i] =
@@ -586,7 +592,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 
 			data->target_temp[i] =
 				w83627ehf_read_value(data,
-					W83627EHF_REG_TARGET[i]) &
+					data->REG_TARGET[i]) &
 					(data->pwm_mode[i] == 1 ? 0x7f : 0xff);
 			data->tolerance[i] = (tolerance >> (i == 1 ? 4 : 0))
 									& 0x0f;
@@ -822,7 +828,7 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		/* Give the chip time to sample a new speed value */
 		data->last_updated = jiffies;
 	}
-	w83627ehf_write_value(data, W83627EHF_REG_FAN_MIN[nr],
+	w83627ehf_write_value(data, data->REG_FAN_MIN[nr],
 			      data->fan_min[nr]);
 	mutex_unlock(&data->update_lock);
 
@@ -1029,7 +1035,7 @@ store_pwm(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->pwm[nr] = val;
-	w83627ehf_write_value(data, W83627EHF_REG_PWM[nr], val);
+	w83627ehf_write_value(data, data->REG_PWM[nr], val);
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -1094,7 +1100,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
-	w83627ehf_write_value(data, W83627EHF_REG_TARGET[nr], val);
+	w83627ehf_write_value(data, data->REG_TARGET[nr], val);
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -1509,8 +1515,14 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 		data->temp_label = w83667hg_b_temp_label;
 	}
 
+	data->REG_PWM = W83627EHF_REG_PWM;
+	data->REG_TARGET = W83627EHF_REG_TARGET;
+	data->REG_FAN = W83627EHF_REG_FAN;
+	data->REG_FAN_MIN = W83627EHF_REG_FAN_MIN;
 	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
 	data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
+	data->REG_FAN_STOP_TIME = W83627EHF_REG_FAN_STOP_TIME;
+	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
 	if (sio_data->kind == w83667hg_b) {
 		data->REG_FAN_MAX_OUTPUT =
 		  W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B;
-- 
1.7.3.1

