Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab2JAXQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:16:33 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47021 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2JAXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:16:29 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>
Subject: [PATCH v2 1/2] hwmon: (ads7828) driver cleanup
Date: Mon,  1 Oct 2012 19:16:23 -0400
Message-Id: <1349133384-5181-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove unused macros;
* Point to the documentation;
* Coding Style fixes (Kernel Doc, spacing);
* Move driver declaration to avoid adding function prototypes.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/hwmon/ads7828.c | 91 +++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index bf3fdf4..fb3010d 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -6,7 +6,7 @@
  *
  * Written by Steve Hardy <shardy@redhat.com>
  *
- * Datasheet available at: http://focus.ti.com/lit/ds/symlink/ads7828.pdf
+ * For further information, see the Documentation/hwmon/ads7828 file.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -34,14 +34,12 @@
 #include <linux/mutex.h>
 
 /* The ADS7828 registers */
-#define ADS7828_NCH 8 /* 8 channels of 12-bit A-D supported */
-#define ADS7828_CMD_SD_SE 0x80 /* Single ended inputs */
-#define ADS7828_CMD_SD_DIFF 0x00 /* Differential inputs */
-#define ADS7828_CMD_PD0 0x0 /* Power Down between A-D conversions */
-#define ADS7828_CMD_PD1 0x04 /* Internal ref OFF && A-D ON */
-#define ADS7828_CMD_PD2 0x08 /* Internal ref ON && A-D OFF */
-#define ADS7828_CMD_PD3 0x0C /* Internal ref ON && A-D ON */
-#define ADS7828_INT_VREF_MV 2500 /* Internal vref is 2.5V, 2500mV */
+#define ADS7828_NCH		8	/* 8 channels supported */
+#define ADS7828_CMD_SD_SE	0x80	/* Single ended inputs */
+#define ADS7828_CMD_SD_DIFF	0x00	/* Differential inputs */
+#define ADS7828_CMD_PD1		0x04	/* Internal ref OFF && A/D ON */
+#define ADS7828_CMD_PD3		0x0C	/* Internal ref ON && A/D ON */
+#define ADS7828_INT_VREF_MV	2500	/* Internal vref is 2.5V, 2500mV */
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
@@ -59,25 +57,26 @@ module_param(vref_mv, int, S_IRUGO);
 static u8 ads7828_cmd_byte; /* cmd byte without channel bits */
 static unsigned int ads7828_lsb_resol; /* resolution of the ADC sample lsb */
 
-/* Each client has this additional data */
+/**
+ * struct ads7828_data - client specific data
+ * @hwmon_dev:		The hwmon device.
+ * @update_lock:	Mutex protecting updates.
+ * @valid:		Validity flag.
+ * @last_updated:	Last updated time (in jiffies).
+ * @adc_input:		ADS7828_NCH samples.
+ */
 struct ads7828_data {
 	struct device *hwmon_dev;
-	struct mutex update_lock; /* mutex protect updates */
-	char valid; /* !=0 if following fields are valid */
-	unsigned long last_updated; /* In jiffies */
-	u16 adc_input[ADS7828_NCH]; /* ADS7828_NCH 12-bit samples */
+	struct mutex update_lock;
+	char valid;
+	unsigned long last_updated;
+	u16 adc_input[ADS7828_NCH];
 };
 
-/* Function declaration - necessary due to function dependencies */
-static int ads7828_detect(struct i2c_client *client,
-			  struct i2c_board_info *info);
-static int ads7828_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id);
-
 static inline u8 channel_cmd_byte(int ch)
 {
 	/* cmd byte C2,C1,C0 - see datasheet */
-	u8 cmd = (((ch>>1) | (ch&0x01)<<2)<<4);
+	u8 cmd = (((ch >> 1) | (ch & 0x01) << 2) << 4);
 	cmd |= ads7828_cmd_byte;
 	return cmd;
 }
@@ -120,9 +119,8 @@ static ssize_t show_in(struct device *dev, struct device_attribute *da,
 		ads7828_lsb_resol)/1000);
 }
 
-#define in_reg(offset)\
-static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in,\
-	NULL, offset)
+#define in_reg(offset) \
+static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in, NULL, offset)
 
 in_reg(0);
 in_reg(1);
@@ -158,25 +156,6 @@ static int ads7828_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct i2c_device_id ads7828_id[] = {
-	{ "ads7828", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, ads7828_id);
-
-/* This is the driver that will be inserted */
-static struct i2c_driver ads7828_driver = {
-	.class = I2C_CLASS_HWMON,
-	.driver = {
-		.name = "ads7828",
-	},
-	.probe = ads7828_probe,
-	.remove = ads7828_remove,
-	.id_table = ads7828_id,
-	.detect = ads7828_detect,
-	.address_list = normal_i2c,
-};
-
 /* Return 0 if detection is successful, -ENODEV otherwise */
 static int ads7828_detect(struct i2c_client *client,
 			  struct i2c_board_info *info)
@@ -247,13 +226,29 @@ exit:
 	return err;
 }
 
+static const struct i2c_device_id ads7828_ids[] = {
+	{ "ads7828", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ads7828_ids);
+
+static struct i2c_driver ads7828_driver = {
+	.class = I2C_CLASS_HWMON,
+	.driver = {
+		.name = "ads7828",
+	},
+	.address_list = normal_i2c,
+	.detect = ads7828_detect,
+	.probe = ads7828_probe,
+	.remove = ads7828_remove,
+	.id_table = ads7828_ids,
+};
+
 static int __init sensors_ads7828_init(void)
 {
 	/* Initialize the command byte according to module parameters */
-	ads7828_cmd_byte = se_input ?
-		ADS7828_CMD_SD_SE : ADS7828_CMD_SD_DIFF;
-	ads7828_cmd_byte |= int_vref ?
-		ADS7828_CMD_PD3 : ADS7828_CMD_PD1;
+	ads7828_cmd_byte = se_input ? ADS7828_CMD_SD_SE : ADS7828_CMD_SD_DIFF;
+	ads7828_cmd_byte |= int_vref ? ADS7828_CMD_PD3 : ADS7828_CMD_PD1;
 
 	/* Calculate the LSB resolution */
 	ads7828_lsb_resol = (vref_mv*1000)/4096;
@@ -267,7 +262,7 @@ static void __exit sensors_ads7828_exit(void)
 }
 
 MODULE_AUTHOR("Steve Hardy <shardy@redhat.com>");
-MODULE_DESCRIPTION("ADS7828 driver");
+MODULE_DESCRIPTION("Driver for TI ADS7828 A/D converter");
 MODULE_LICENSE("GPL");
 
 module_init(sensors_ads7828_init);
-- 
1.7.11.4

