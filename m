Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0GCPI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 11:08:56 -0400
Received: from imr3.ericy.com ([198.24.6.13]:47388 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab0GCPIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 11:08:54 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guenter Roeck <guenter.roeck@ericsson.com>,
       Ethan Lawrence <e.law87@yahoo.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       lars4910@hotmail.com, birdie@permonline.ru, jadcock@cox.net,
       binximeng@gmail.com, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH/RFC v3] hwmon: Add support for W83667HG-B to w83627ehf driver.
Date: Sat, 3 Jul 2010 08:07:46 -0700
Message-ID: <1278169666-11612-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

---

Key relevant difference between W83667HG and W83667HG-B are the Chip ID as well
as fan output and step output register addresses. Those differences are
addressed with this patch.

There are other relevant changes in the mapping of input sensors to fan
control (W83667HG datasheet chapter 8.7, W83667HG-B datasheet chapter 8.5).
However, control of those mappings is not implemented in the driver, thus the
respective changes should not have an impact on driver operation.

Changes made in this patch are based on information from datasheets only. The
patch has not yet been tested with real hardware. The patch will have to be
tested with real hardware before it is integrated, and is thus submitted as RFC.

The next version of this patch will be split in two parts: generic changes
which also apply to W83667HG, and W83667HG-B specific changes.

Changes in v3:
- Updated driver documentation
- Read data from max and step registers in update_device function.
- In update_device, read fan pwm registers only for installed/supported fans.
- Removed W83667HG-I code; that should really have been W83677HG-I.
  Without datasheet, adding support for this chip would be too risky.
- For W83667HG-B, create max and step attribute files for all fans.

Changes in v2:
- Removed dash from hwmon device name.
- Moved global array pointers to per-device data.
- Added chip detection for W83667HG-I
  (assumed to be identical to W83667HG; needs to be validated).

---
 Documentation/hwmon/w83627ehf |   15 ++++--
 drivers/hwmon/w83627ehf.c     |   97 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/Documentation/hwmon/w83627ehf b/Documentation/hwmon/w83627ehf
index b7e42ec..c74cf09 100644
--- a/Documentation/hwmon/w83627ehf
+++ b/Documentation/hwmon/w83627ehf
@@ -20,6 +20,10 @@ Supported chips:
     Prefix: 'w83667hg'
     Addresses scanned: ISA address retrieved from Super I/O registers
     Datasheet: not available
+  * Winbond W83667HG-B
+    Prefix: 'w83667hg'
+    Addresses scanned: ISA address retrieved from Super I/O registers
+    Datasheet: Available from Nuvoton upon request
 
 Authors:
         Jean Delvare <khali@linux-fr.org>
@@ -32,8 +36,8 @@ Description
 -----------
 
 This driver implements support for the Winbond W83627EHF, W83627EHG,
-W83627DHG, W83627DHG-P and W83667HG super I/O chips. We will refer to them
-collectively as Winbond chips.
+W83627DHG, W83627DHG-P, W83667HG and W83667HG-B super I/O chips.
+We will refer to them collectively as Winbond chips.
 
 The chips implement three temperature sensors, five fan rotation
 speed sensors, ten analog voltage sensors (only nine for the 627DHG), one
@@ -68,14 +72,15 @@ follows:
 temp1 -> pwm1
 temp2 -> pwm2
 temp3 -> pwm3
-prog  -> pwm4 (not on 667HG; the programmable setting is not supported by
-	       the driver)
+prog  -> pwm4 (not on 667HG and 667-B; the programmable setting is not supported
+               by the driver)
 
 /sys files
 ----------
 
 name - this is a standard hwmon device entry. For the W83627EHF and W83627EHG,
-       it is set to "w83627ehf" and for the W83627DHG it is set to "w83627dhg"
+       it is set to "w83627ehf", for the W83627DHG it is set to "w83627dhg",
+       and for the W83667HG it is set to "w83667hg".
 
 pwm[1-4] - this file stores PWM duty cycle or DC value (fan speed) in range:
 	   0 (stop) to 255 (full)
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 0dcaba9..31c7da5 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -39,6 +39,7 @@
     w83627dhg    9      5       4       3      0xa020 0xc1    0x5ca3
     w83627dhg-p  9      5       4       3      0xb070 0xc1    0x5ca3
     w83667hg     9      5       3       3      0xa510 0xc1    0x5ca3
+    w83667hg-b   9      5       3       3      0xb350 0xc1    0x5ca3
 */
 
 #include <linux/module.h>
@@ -55,7 +56,7 @@
 #include <linux/io.h>
 #include "lm75.h"
 
-enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg };
+enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg, w83667hg_b };
 
 /* used to set data->name = w83627ehf_device_names[data->sio_kind] */
 static const char * w83627ehf_device_names[] = {
@@ -63,6 +64,7 @@ static const char * w83627ehf_device_names[] = {
 	"w83627dhg",
 	"w83627dhg",
 	"w83667hg",
+	"w83667hg",
 };
 
 static unsigned short force_id;
@@ -91,6 +93,7 @@ MODULE_PARM_DESC(force_id, "Override the detected device ID");
 #define SIO_W83627DHG_ID	0xa020
 #define SIO_W83627DHG_P_ID	0xb070
 #define SIO_W83667HG_ID 	0xa510
+#define SIO_W83667HG_B_ID	0xb350
 #define SIO_ID_MASK		0xFFF0
 
 static inline void
@@ -201,8 +204,14 @@ static const u8 W83627EHF_REG_TOLERANCE[] = { 0x07, 0x07, 0x14, 0x62 };
 static const u8 W83627EHF_REG_FAN_START_OUTPUT[] = { 0x0a, 0x0b, 0x16, 0x65 };
 static const u8 W83627EHF_REG_FAN_STOP_OUTPUT[] = { 0x08, 0x09, 0x15, 0x64 };
 static const u8 W83627EHF_REG_FAN_STOP_TIME[] = { 0x0c, 0x0d, 0x17, 0x66 };
-static const u8 W83627EHF_REG_FAN_MAX_OUTPUT[] = { 0xff, 0x67, 0xff, 0x69 };
-static const u8 W83627EHF_REG_FAN_STEP_OUTPUT[] = { 0xff, 0x68, 0xff, 0x6a };
+
+static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_COMMON[]
+						= { 0xff, 0x67, 0xff, 0x69 };
+static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
+						= { 0xff, 0x68, 0xff, 0x6a };
+
+static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
+static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[] = { 0x68, 0x6a, 0x6c };
 
 /*
  * Conversions
@@ -277,6 +286,11 @@ struct w83627ehf_data {
 	struct device *hwmon_dev;
 	struct mutex lock;
 
+	const u8 *REG_FAN_START_OUTPUT;
+	const u8 *REG_FAN_STOP_OUTPUT;
+	const u8 *REG_FAN_MAX_OUTPUT;
+	const u8 *REG_FAN_STEP_OUTPUT;
+
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -524,7 +538,10 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			}
 		}
 
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < data->pwm_num; i++) {
+			if (!(data->has_fan & (1 << i)))
+				continue;
+
 			/* pwmcfg, tolerance mapped for i=0, i=1 to same reg */
 			if (i != 1) {
 				pwmcfg = w83627ehf_read_value(data,
@@ -546,6 +563,17 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 						W83627EHF_REG_FAN_STOP_OUTPUT[i]);
 			data->fan_stop_time[i] = w83627ehf_read_value(data,
 						W83627EHF_REG_FAN_STOP_TIME[i]);
+
+			if (data->REG_FAN_MAX_OUTPUT[i] != 0xff)
+				data->fan_max_output[i] =
+				  w83627ehf_read_value(data,
+					       data->REG_FAN_MAX_OUTPUT[i]);
+
+			if (data->REG_FAN_STEP_OUTPUT[i] != 0xff)
+				data->fan_step_output[i] =
+				  w83627ehf_read_value(data,
+					       data->REG_FAN_STEP_OUTPUT[i]);
+
 			data->target_temp[i] =
 				w83627ehf_read_value(data,
 					W83627EHF_REG_TARGET[i]) &
@@ -1126,7 +1154,7 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 	u32 val = SENSORS_LIMIT(simple_strtoul(buf, NULL, 10), 1, 255); \
 	mutex_lock(&data->update_lock); \
 	data->reg[nr] = val; \
-	w83627ehf_write_value(data, W83627EHF_REG_##REG[nr], val); \
+	w83627ehf_write_value(data, data->REG_##REG[nr], val); \
 	mutex_unlock(&data->update_lock); \
 	return count; \
 }
@@ -1206,12 +1234,26 @@ static struct sensor_device_attribute sda_sf3_arrays[] = {
 		    store_fan_stop_output, 1),
 	SENSOR_ATTR(pwm3_stop_output, S_IWUSR | S_IRUGO, show_fan_stop_output,
 		    store_fan_stop_output, 2),
+};
+
 
-	/* pwm1 and pwm3 don't support max and step settings */
+/*
+ * pwm1 and pwm3 don't support max and step settings on all chips.
+ * Need to check support while generating/removing attribute files.
+ */
+static struct sensor_device_attribute sda_sf3_max_step_arrays[] = {
+	SENSOR_ATTR(pwm2_max_output, S_IWUSR | S_IRUGO, show_fan_max_output,
+		    store_fan_max_output, 0),
+	SENSOR_ATTR(pwm2_step_output, S_IWUSR | S_IRUGO, show_fan_step_output,
+		    store_fan_step_output, 0),
 	SENSOR_ATTR(pwm2_max_output, S_IWUSR | S_IRUGO, show_fan_max_output,
 		    store_fan_max_output, 1),
 	SENSOR_ATTR(pwm2_step_output, S_IWUSR | S_IRUGO, show_fan_step_output,
 		    store_fan_step_output, 1),
+	SENSOR_ATTR(pwm2_max_output, S_IWUSR | S_IRUGO, show_fan_max_output,
+		    store_fan_max_output, 2),
+	SENSOR_ATTR(pwm2_step_output, S_IWUSR | S_IRUGO, show_fan_step_output,
+		    store_fan_step_output, 2),
 };
 
 static ssize_t
@@ -1235,6 +1277,12 @@ static void w83627ehf_device_remove_files(struct device *dev)
 
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++)
 		device_remove_file(dev, &sda_sf3_arrays[i].dev_attr);
+	for (i = 0; i < ARRAY_SIZE(sda_sf3_max_step_arrays); i++) {
+		struct sensor_device_attribute *attr =
+		  &sda_sf3_max_step_arrays[i];
+		if (data->REG_FAN_STEP_OUTPUT[attr->index] != 0xff)
+			device_remove_file(dev, &attr->dev_attr);
+	}
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays_fan4); i++)
 		device_remove_file(dev, &sda_sf3_arrays_fan4[i].dev_attr);
 	for (i = 0; i < data->in_num; i++) {
@@ -1343,22 +1391,37 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	/* 627EHG and 627EHF have 10 voltage inputs; 627DHG and 667HG have 9 */
 	data->in_num = (sio_data->kind == w83627ehf) ? 10 : 9;
 	/* 667HG has 3 pwms */
-	data->pwm_num = (sio_data->kind == w83667hg) ? 3 : 4;
+	data->pwm_num = (sio_data->kind == w83667hg
+			 || sio_data->kind == w83667hg_b) ? 3 : 4;
 
 	/* Check temp3 configuration bit for 667HG */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		data->temp3_disable = w83627ehf_read_value(data,
 					W83627EHF_REG_TEMP_CONFIG[1]) & 0x01;
 		data->in6_skip = !data->temp3_disable;
 	}
 
+	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
+	data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
+	if (sio_data->kind == w83667hg_b) {
+		data->REG_FAN_MAX_OUTPUT =
+		  W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B;
+		data->REG_FAN_STEP_OUTPUT =
+		  W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B;
+	} else {
+		data->REG_FAN_MAX_OUTPUT =
+		  W83627EHF_REG_FAN_MAX_OUTPUT_COMMON;
+		data->REG_FAN_STEP_OUTPUT =
+		  W83627EHF_REG_FAN_STEP_OUTPUT_COMMON;
+	}
+
 	/* Initialize the chip */
 	w83627ehf_init_device(data);
 
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
 	/* Read VID value */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		/* W83667HG has different pins for VID input and output, so
 		we can get the VID input values directly at logical device D
 		0xe3. */
@@ -1409,7 +1472,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	}
 
 	/* fan4 and fan5 share some pins with the GPIO and serial flash */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		fan5pin = superio_inb(sio_data->sioreg, 0x27) & 0x20;
 		fan4pin = superio_inb(sio_data->sioreg, 0x27) & 0x40;
 	} else {
@@ -1440,6 +1503,15 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 			&sda_sf3_arrays[i].dev_attr)))
 			goto exit_remove;
 
+	for (i = 0; i < ARRAY_SIZE(sda_sf3_max_step_arrays); i++) {
+		struct sensor_device_attribute *attr =
+		  &sda_sf3_max_step_arrays[i];
+		if (data->REG_FAN_STEP_OUTPUT[attr->index] != 0xff) {
+			err = device_create_file(dev, &attr->dev_attr);
+			if (err)
+				goto exit_remove;
+		}
+	}
 	/* if fan4 is enabled create the sf3 files for it */
 	if ((data->has_fan & (1 << 3)) && data->pwm_num >= 4)
 		for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays_fan4); i++) {
@@ -1556,6 +1628,7 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
 	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
 	static const char __initdata sio_name_W83667HG[] = "W83667HG";
+	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
 
 	u16 val;
 	const char *sio_name;
@@ -1588,6 +1661,10 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 		sio_data->kind = w83667hg;
 		sio_name = sio_name_W83667HG;
 		break;
+	case SIO_W83667HG_B_ID:
+		sio_data->kind = w83667hg_b;
+		sio_name = sio_name_W83667HG_B;
+		break;
 	default:
 		if (val != 0xffff)
 			pr_debug(DRVNAME ": unsupported chip ID: 0x%04x\n",
-- 
1.7.0.87.g0901d

