Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2JCUy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:54:28 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:54983 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2JCUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:54:24 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH v5 2/2] hwmon: (ads7828) add support for ADS7830
Date: Wed,  3 Oct 2012 16:54:08 -0400
Message-Id: <1349297648-19843-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349297648-19843-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1349297648-19843-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>

The ADS7830 device is almost the same as the ADS7828,
except that it does 8-bit sampling, instead of 12-bit.
This patch extends the ads7828 driver to support this chip.

Signed-off-by: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/hwmon/ads7828 | 11 +++++++++--
 drivers/hwmon/Kconfig       |  7 ++++---
 drivers/hwmon/ads7828.c     | 25 +++++++++++++++++++------
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/Documentation/hwmon/ads7828 b/Documentation/hwmon/ads7828
index a987c94..f6e263e 100644
--- a/Documentation/hwmon/ads7828
+++ b/Documentation/hwmon/ads7828
@@ -7,9 +7,15 @@ Supported chips:
     Datasheet: Publicly available at the Texas Instruments website:
                http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
+  * Texas Instruments ADS7830
+    Prefix: 'ads7830'
+    Datasheet: Publicly available at the Texas Instruments website:
+               http://focus.ti.com/lit/ds/symlink/ads7830.pdf
+
 Authors:
         Steve Hardy <shardy@redhat.com>
         Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+        Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
 
 Platform data
 -------------
@@ -35,9 +41,10 @@ in include/linux/platform_data/ads7828.h). The structure fields are:
 Description
 -----------
 
-This driver implements support for the Texas Instruments ADS7828.
+This driver implements support for the Texas Instruments ADS7828 and ADS7830.
 
-This device is a 12-bit 8-channel A-D converter.
+The ADS7828 device is a 12-bit 8-channel A/D converter, while the ADS7830 does
+8-bit sampling.
 
 It can operate in single ended mode (8 +ve inputs) or in differential mode,
 where 4 differential pairs can be measured.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 83e3e9d..960c8c5 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1060,11 +1060,12 @@ config SENSORS_ADS1015
 	  will be called ads1015.
 
 config SENSORS_ADS7828
-	tristate "Texas Instruments ADS7828"
+	tristate "Texas Instruments ADS7828 and compatibles"
 	depends on I2C
 	help
-	  If you say yes here you get support for Texas Instruments ADS7828
-	  12-bit 8-channel ADC device.
+	  If you say yes here you get support for Texas Instruments ADS7828 and
+	  ADS7830 8-channel A/D converters. ADS7828 resolution is 12-bit, while
+	  it is 8-bit on ADS7830.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called ads7828.
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index 42914fc..409b5c1 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -1,11 +1,13 @@
 /*
- * ads7828.c - lm_sensors driver for ads7828 12-bit 8-channel ADC
+ * ads7828.c - driver for TI ADS7828 8-channel A/D converter and compatibles
  * (C) 2007 EADS Astrium
  *
  * This driver is based on the lm75 and other lm_sensors/hwmon drivers
  *
  * Written by Steve Hardy <shardy@redhat.com>
  *
+ * ADS7830 support, by Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
+ *
  * For further information, see the Documentation/hwmon/ads7828 file.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -43,6 +45,9 @@
 #define ADS7828_EXT_VREF_MV_MIN	50	/* External vref min value 0.05V */
 #define ADS7828_EXT_VREF_MV_MAX	5250	/* External vref max value 5.25V */
 
+/* List of supported devices */
+enum ads7828_chips { ads7828, ads7830 };
+
 /* Client specific data */
 struct ads7828_data {
 	struct device *hwmon_dev;
@@ -55,6 +60,7 @@ struct ads7828_data {
 	unsigned int vref_mv;		/* voltage reference value */
 	u8 cmd_byte;			/* Command byte without channel bits */
 	unsigned int lsb_resol;		/* Resolution of the ADC sample LSB */
+	s32 (*read_channel)(const struct i2c_client *client, u8 command);
 };
 
 /* Command byte C2,C1,C0 - see datasheet */
@@ -78,8 +84,7 @@ static struct ads7828_data *ads7828_update_device(struct device *dev)
 
 		for (ch = 0; ch < ADS7828_NCH; ch++) {
 			u8 cmd = ads7828_cmd_byte(data->cmd_byte, ch);
-			data->adc_input[ch] =
-				i2c_smbus_read_word_swapped(client, cmd);
+			data->adc_input[ch] = data->read_channel(client, cmd);
 		}
 		data->last_updated = jiffies;
 		data->valid = true;
@@ -164,7 +169,14 @@ static int ads7828_probe(struct i2c_client *client,
 	else
 		data->vref_mv = ADS7828_INT_VREF_MV;
 
-	data->lsb_resol = DIV_ROUND_CLOSEST(data->vref_mv * 1000, 4096);
+	/* ADS7828 uses 12-bit samples, while ADS7830 is 8-bit */
+	if (id->driver_data == ads7828) {
+		data->lsb_resol = DIV_ROUND_CLOSEST(data->vref_mv * 1000, 4096);
+		data->read_channel = i2c_smbus_read_word_swapped;
+	} else {
+		data->lsb_resol = DIV_ROUND_CLOSEST(data->vref_mv * 1000, 256);
+		data->read_channel = i2c_smbus_read_byte_data;
+	}
 
 	data->cmd_byte = data->ext_vref ? ADS7828_CMD_PD1 : ADS7828_CMD_PD3;
 	if (!data->diff_input)
@@ -191,7 +203,8 @@ error:
 }
 
 static const struct i2c_device_id ads7828_device_ids[] = {
-	{ "ads7828", 0 },
+	{ "ads7828", ads7828 },
+	{ "ads7830", ads7830 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ads7828_device_ids);
@@ -210,4 +223,4 @@ module_i2c_driver(ads7828_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steve Hardy <shardy@redhat.com>");
-MODULE_DESCRIPTION("Driver for TI ADS7828 A/D converter");
+MODULE_DESCRIPTION("Driver for TI ADS7828 A/D converter and compatibles");
-- 
1.7.11.4

