Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1DGOpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:45:52 -0400
Received: from imr4.ericy.com ([198.24.6.8]:38041 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab1DGOpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:45:51 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Chew <achew@nvidia.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2] hwmon: (lm90) Add support for ADT7461A and NCT1008
Date: Thu, 7 Apr 2011 07:57:14 -0700
Message-ID: <1302188234-22621-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ADT7461A and NCT1008 to the lm90 driver.
Both chips have identical functionality and report the same manufacturing ID
and device ID values.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
v2:
- Updated documentation
- Added device ID for nct1008

 Documentation/hwmon/lm90 |   22 ++++++++++++++++------
 drivers/hwmon/Kconfig    |    8 ++++----
 drivers/hwmon/lm90.c     |   22 +++++++++++++++-------
 3 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/Documentation/hwmon/lm90 b/Documentation/hwmon/lm90
index fa475c0..ed58f17 100644
--- a/Documentation/hwmon/lm90
+++ b/Documentation/hwmon/lm90
@@ -32,6 +32,16 @@ Supported chips:
     Addresses scanned: I2C 0x4c and 0x4d
     Datasheet: Publicly available at the ON Semiconductor website
                http://www.onsemi.com/PowerSolutions/product.do?id=ADT7461
+  * Analog Devices ADT7461A
+    Prefix: 'adt7461a'
+    Addresses scanned: I2C 0x4c and 0x4d
+    Datasheet: Publicly available at the ON Semiconductor website
+               http://www.onsemi.com/PowerSolutions/product.do?id=ADT7461A
+  * ON Semiconductor NCT1008
+    Prefix: 'nct1008'
+    Addresses scanned: I2C 0x4c and 0x4d
+    Datasheet: Publicly available at the ON Semiconductor website
+               http://www.onsemi.com/PowerSolutions/product.do?id=NCT1008
   * Maxim MAX6646
     Prefix: 'max6646'
     Addresses scanned: I2C 0x4d
@@ -149,7 +159,7 @@ ADM1032:
   * ALERT is triggered by open remote sensor.
   * SMBus PEC support for Write Byte and Receive Byte transactions.
 
-ADT7461:
+ADT7461, ADT7461A, NCT1008:
   * Extended temperature range (breaks compatibility)
   * Lower resolution for remote temperature
 
@@ -205,11 +215,11 @@ SMBus Alert Support
 This driver has basic support for SMBus alert. When an alert is received,
 the status register is read and the faulty temperature channel is logged.
 
-The Analog Devices chips (ADM1032 and ADT7461) do not implement the SMBus
-alert protocol properly so additional care is needed: the ALERT output is
-disabled when an alert is received, and is re-enabled only when the alarm
-is gone. Otherwise the chip would block alerts from other chips in the bus
-as long as the alarm is active.
+The Analog Devices chips (ADM1032, ADT7461, ADT7461A, and NCT1008) do not
+implement the SMBus alert protocol properly so additional care is needed:
+the ALERT output is disabled when an alert is received, and is re-enabled
+only when the alarm is gone. Otherwise the chip would block alerts from other
+chips in the bus as long as the alarm is active.
 
 PEC Support
 -----------
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 060ef63..92d0251 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -618,10 +618,10 @@ config SENSORS_LM90
 	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
-	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, Maxim
-	  MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
-	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, and Winbond/Nuvoton
-	  W83L771W/G/AWG/ASG sensor chips.
+	  LM86, LM89 and LM99, Analog Devices ADM1032, ADT7461, and ADT7461A,
+	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
+	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, ON Semiconductor NCT1008,
+	  and Winbond/Nuvoton W83L771W/G/AWG/ASG sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm90.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 812781c..e19b87c 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -49,10 +49,10 @@
  * chips, but support three temperature sensors instead of two. MAX6695
  * and MAX6696 only differ in the pinout so they can be treated identically.
  *
- * This driver also supports the ADT7461 chip from Analog Devices.
- * It's supported in both compatibility and extended mode. It is mostly
- * compatible with LM90 except for a data format difference for the
- * temperature value registers.
+ * This driver also supports ADT7461 and ADT7461A from Analog Devices as well as
+ * NCT1008 from ON Semiconductor. The chips are supported in both compatibility
+ * and extended mode. They are is mostly compatible with LM90 except for a data
+ * format difference for the temperature value registers.
  *
  * Since the LM90 was the first chipset supported by this driver, most
  * comments will refer to this chipset, but are actually general and
@@ -88,9 +88,10 @@
  * Addresses to scan
  * Address is fully defined internally and cannot be changed except for
  * MAX6659, MAX6680 and MAX6681.
- * LM86, LM89, LM90, LM99, ADM1032, ADM1032-1, ADT7461, MAX6649, MAX6657,
- * MAX6658 and W83L771 have address 0x4c.
- * ADM1032-2, ADT7461-2, LM89-1, LM99-1 and MAX6646 have address 0x4d.
+ * LM86, LM89, LM90, LM99, ADM1032, ADM1032-1, ADT7461, ADT7461A, MAX6649,
+ * MAX6657, MAX6658, NCT1008 and W83L771 have address 0x4c.
+ * ADM1032-2, ADT7461-2, ADT7461A-2, LM89-1, LM99-1, MAX6646, and NCT1008D
+ * have address 0x4d.
  * MAX6647 has address 0x4e.
  * MAX6659 can have address 0x4c, 0x4d or 0x4e.
  * MAX6680 and MAX6681 can have address 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
@@ -174,6 +175,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 static const struct i2c_device_id lm90_id[] = {
 	{ "adm1032", adm1032 },
 	{ "adt7461", adt7461 },
+	{ "adt7461a", adt7461 },
 	{ "lm90", lm90 },
 	{ "lm86", lm86 },
 	{ "lm89", lm86 },
@@ -188,6 +190,7 @@ static const struct i2c_device_id lm90_id[] = {
 	{ "max6681", max6680 },
 	{ "max6695", max6696 },
 	{ "max6696", max6696 },
+	{ "nct1008", adt7461 },
 	{ "w83l771", w83l771 },
 	{ }
 };
@@ -1153,6 +1156,11 @@ static int lm90_detect(struct i2c_client *new_client,
 		 && (reg_config1 & 0x1B) == 0x00
 		 && reg_convrate <= 0x0A) {
 			name = "adt7461";
+		} else
+		if (chip_id == 0x57 /* ADT7461A, NCT1008 */
+		 && (reg_config1 & 0x1B) == 0x00
+		 && reg_convrate <= 0x0A) {
+			name = "adt7461a";
 		}
 	} else
 	if (man_id == 0x4D) { /* Maxim */
-- 
1.7.3.1

