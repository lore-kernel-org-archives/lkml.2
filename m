Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0GCWOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:14:54 -0400
Received: from imr1.ericy.com ([198.24.6.9]:46420 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0GCWOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:14:52 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>, Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Iain <selsinork@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, lars4910@hotmail.com,
       birdie@permonline.ru, jadcock@cox.net, binximeng@gmail.com,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v4 2/2] hwmon: Add support for W83667HG-B to w83627ehf driver
Date: Sat, 3 Jul 2010 15:13:22 -0700
Message-ID: <1278195202-2683-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1278195202-2683-1-git-send-email-guenter.roeck@ericsson.com>
References: <1278195202-2683-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/w83627ehf |   15 +++++++++----
 drivers/hwmon/w83627ehf.c     |   42 ++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/Documentation/hwmon/w83627ehf b/Documentation/hwmon/w83627ehf
index b7e42ec..13d5561 100644
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
+prog  -> pwm4 (not on 667HG and 667HG-B; the programmable setting is not
+	       supported by the driver)
 
 /sys files
 ----------
 
 name - this is a standard hwmon device entry. For the W83627EHF and W83627EHG,
-       it is set to "w83627ehf" and for the W83627DHG it is set to "w83627dhg"
+       it is set to "w83627ehf", for the W83627DHG it is set to "w83627dhg",
+       and for the W83667HG it is set to "w83667hg".
 
 pwm[1-4] - this file stores PWM duty cycle or DC value (fan speed) in range:
 	   0 (stop) to 255 (full)
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index e01a3e9..e96e69d 100644
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
@@ -1382,10 +1391,11 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
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
@@ -1393,8 +1403,17 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 
 	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
 	data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
-	data->REG_FAN_MAX_OUTPUT = W83627EHF_REG_FAN_MAX_OUTPUT;
-	data->REG_FAN_STEP_OUTPUT = W83627EHF_REG_FAN_STEP_OUTPUT;
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
 
 	/* Initialize the chip */
 	w83627ehf_init_device(data);
@@ -1402,7 +1421,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
 	/* Read VID value */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		/* W83667HG has different pins for VID input and output, so
 		we can get the VID input values directly at logical device D
 		0xe3. */
@@ -1453,7 +1472,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	}
 
 	/* fan4 and fan5 share some pins with the GPIO and serial flash */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		fan5pin = superio_inb(sio_data->sioreg, 0x27) & 0x20;
 		fan4pin = superio_inb(sio_data->sioreg, 0x27) & 0x40;
 	} else {
@@ -1609,6 +1628,7 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
 	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
 	static const char __initdata sio_name_W83667HG[] = "W83667HG";
+	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
 
 	u16 val;
 	const char *sio_name;
@@ -1641,6 +1661,10 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
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

