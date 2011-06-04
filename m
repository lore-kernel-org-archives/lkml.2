Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1FDKh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:37:29 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:13172 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab1FDKh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:37:26 -0400
X-IronPort-AV: E=Sophos;i="4.65,319,1304294400"; 
   d="scan'208";a="33680890"
From: Stijn Devriendt <sdevrien@cisco.com>
To: khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, Stijn Devriendt <sdevrien@cisco.com>
Subject: [PATCH] Add support for the Philips SA56004 temperature sensor.
Date: Sat,  4 Jun 2011 12:37:11 +0200
Message-Id: <1307183831-19627-2-git-send-email-sdevrien@cisco.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Philips SA56004, an LM86
compatible temperature sensor.

Changes since v1:
- Updated documentation
- Trace replaced by BUG_ON
- style updates

Signed-off-by: Stijn Devriendt <sdevrien@cisco.com>
---
 Documentation/hwmon/lm90 |    9 ++++++++-
 drivers/hwmon/Kconfig    |    2 +-
 drivers/hwmon/lm90.c     |   39 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/Documentation/hwmon/lm90 b/Documentation/hwmon/lm90
index f3efd18..9cd14cfe 100644
--- a/Documentation/hwmon/lm90
+++ b/Documentation/hwmon/lm90
@@ -113,7 +113,11 @@ Supported chips:
     Prefix: 'w83l771'
     Addresses scanned: I2C 0x4c
     Datasheet: Not publicly available, can be requested from Nuvoton
-
+  * Philips/NXP SA56004X
+    Prefix: 'sa56004'
+    Addresses scanned: I2C 0x48 through 0x4F
+    Datasheet: Publicly available at NXP website
+               http://ics.nxp.com/products/interface/datasheet/sa56004x.pdf
 
 Author: Jean Delvare <khali@linux-fr.org>
 
@@ -193,6 +197,9 @@ W83L771AWG/ASG
   * The AWG and ASG variants only differ in package format.
   * Diode ideality factor configuration (remote sensor) at 0xE3
 
+SA56004X:
+  * Better local resolution
+
 All temperature values are given in degrees Celsius. Resolution
 is 1.0 degree for the local temperature, 0.125 degree for the remote
 temperature, except for the MAX6657, MAX6658 and MAX6659 which have a
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 50e40db..11c9339 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -620,7 +620,7 @@ config SENSORS_LM90
 	  LM86, LM89 and LM99, Analog Devices ADM1032, ADT7461, and ADT7461A,
 	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
 	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, ON Semiconductor NCT1008,
-	  and Winbond/Nuvoton W83L771W/G/AWG/ASG sensor chips.
+	  Winbond/Nuvoton W83L771W/G/AWG/ASG and Philips SA56004 sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm90.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 2f94f95..01b38a0 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -54,6 +54,9 @@
  * and extended mode. They are mostly compatible with LM90 except for a data
  * format difference for the temperature value registers.
  *
+ * This driver also supports the SA56004 from Philips. This device is
+ * pin-compatible with the LM86, the ED/EDP parts are also address-compatible.
+ *
  * Since the LM90 was the first chipset supported by this driver, most
  * comments will refer to this chipset, but are actually general and
  * concern all supported chipsets, unless mentioned otherwise.
@@ -96,13 +99,15 @@
  * MAX6659 can have address 0x4c, 0x4d or 0x4e.
  * MAX6680 and MAX6681 can have address 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
  * 0x4c, 0x4d or 0x4e.
+ * SA56004 can have address 0x48 through 0x4F.
  */
 
 static const unsigned short normal_i2c[] = {
-	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
+	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x48, 0x49, 0x4a, 0x4b, 0x4c,
+	0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
-	max6646, w83l771, max6696 };
+	max6646, w83l771, max6696, sa56004 };
 
 /*
  * The LM90 registers
@@ -152,6 +157,10 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define MAX6659_REG_R_LOCAL_EMERG	0x17
 #define MAX6659_REG_W_LOCAL_EMERG	0x17
 
+/*  SA56004 registers */
+
+#define SA56004_REG_R_LOCAL_TEMPL 0x22
+
 #define LM90_DEF_CONVRATE_RVAL	6	/* Def conversion rate register value */
 #define LM90_MAX_CONVRATE_MS	16000	/* Maximum conversion rate in ms */
 
@@ -192,6 +201,7 @@ static const struct i2c_device_id lm90_id[] = {
 	{ "max6696", max6696 },
 	{ "nct1008", adt7461 },
 	{ "w83l771", w83l771 },
+	{ "sa56004", sa56004 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lm90_id);
@@ -204,6 +214,8 @@ struct lm90_params {
 	u16 alert_alarms;	/* Which alarm bits trigger ALERT# */
 				/* Upper 8 bits for max6695/96 */
 	u8 max_convrate;	/* Maximum conversion rate register value */
+	u8 reg_local_ext;	/* Local extension register if
+				   LM90_HAVE_LOCAL_EXT is set*/
 };
 
 static const struct lm90_params lm90_params[] = {
@@ -238,6 +250,7 @@ static const struct lm90_params lm90_params[] = {
 		.flags = LM90_HAVE_LOCAL_EXT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 6,
+		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6657] = {
 		.flags = LM90_HAVE_LOCAL_EXT,
@@ -248,6 +261,7 @@ static const struct lm90_params lm90_params[] = {
 		.flags = LM90_HAVE_LOCAL_EXT | LM90_HAVE_EMERGENCY,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
+		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6680] = {
 		.flags = LM90_HAVE_OFFSET,
@@ -259,12 +273,20 @@ static const struct lm90_params lm90_params[] = {
 		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
 		.alert_alarms = 0x187c,
 		.max_convrate = 6,
+		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[w83l771] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
 	},
+	[sa56004] = {
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
+		  | LM90_HAVE_LOCAL_EXT,
+		.alert_alarms = 0x7b,
+		.max_convrate = 9,
+		.reg_local_ext = SA56004_REG_R_LOCAL_TEMPL,
+	},
 };
 
 /*
@@ -286,6 +308,7 @@ struct lm90_data {
 	u16 alert_alarms;	/* Which alarm bits trigger ALERT# */
 				/* Upper 8 bits for max6695/96 */
 	u8 max_convrate;	/* Maximum conversion rate */
+	u8 reg_local_ext;	/* local extension register offset */
 
 	/* registers values */
 	s8 temp8[8];	/* 0: local low limit
@@ -454,7 +477,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 
 		if (data->flags & LM90_HAVE_LOCAL_EXT) {
 			lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
-				    MAX6657_REG_R_LOCAL_TEMPL,
+				    data->reg_local_ext,
 				    &data->temp11[4]);
 		} else {
 			if (lm90_read_reg(client, LM90_REG_R_LOCAL_TEMP,
@@ -1263,6 +1286,11 @@ static int lm90_detect(struct i2c_client *new_client,
 				name = "w83l771";
 			}
 		}
+	} else
+	if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
+		if (chip_id == 0x00 && address >= 0x48 && address <= 0x4F) {
+			name = "sa56004";
+		}
 	}
 
 	if (!name) { /* identification failed */
@@ -1372,6 +1400,11 @@ static int lm90_probe(struct i2c_client *new_client,
 	/* Set maximum conversion rate */
 	data->max_convrate = lm90_params[data->kind].max_convrate;
 
+	if (data->flags & LM90_HAVE_LOCAL_EXT) {
+		data->reg_local_ext = lm90_params[data->kind].reg_local_ext;
+		BUG_ON(data->reg_local_ext == 0);
+	}
+
 	/* Initialize the LM90 chip */
 	lm90_init_client(new_client);
 
-- 
1.7.3.3

