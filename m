Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0IINWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:22:48 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58447 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab0IINWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:22:43 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 6/7] hwmon: (lm90) Add support for additional features of max6659
Date: Thu, 9 Sep 2010 06:25:49 -0700
Message-ID: <1284038750-8833-7-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/lm90 |   13 ++++++-----
 drivers/hwmon/lm90.c     |   51 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/Documentation/hwmon/lm90 b/Documentation/hwmon/lm90
index 6a03dd4..bc2c2b4 100644
--- a/Documentation/hwmon/lm90
+++ b/Documentation/hwmon/lm90
@@ -63,8 +63,8 @@ Supported chips:
     Datasheet: Publicly available at the Maxim website
                http://www.maxim-ic.com/quick_view2.cfm/qv_pk/2578
   * Maxim MAX6659
-    Prefix: 'max6657'
-    Addresses scanned: I2C 0x4c, 0x4d (unsupported 0x4e)
+    Prefix: 'max6659'
+    Addresses scanned: I2C 0x4c, 0x4d, 0x4e
     Datasheet: Publicly available at the Maxim website
                http://www.maxim-ic.com/quick_view2.cfm/qv_pk/2578
   * Maxim MAX6680
@@ -101,10 +101,11 @@ well as the temperature of up to one external diode. It is compatible
 with many other devices, many of which are supported by this driver.
 
 Note that there is no easy way to differentiate between the MAX6657,
-MAX6658 and MAX6659 variants. The extra address and features of the
-MAX6659 are not supported by this driver. The MAX6680 and MAX6681 only
-differ in their pinout, therefore they obviously can't (and don't need to)
-be distinguished.
+MAX6658 and MAX6659 variants. The extra features of the MAX6659 are only
+supported by this driver if the chip is located at address 0x4d or 0x4e,
+or if the chip type is explicitly selected as max6659.
+The MAX6680 and MAX6681 only differ in their pinout, therefore they obviously
+can't (and don't need to) be distinguished.
 
 The specificity of this family of chipsets over the ADM1021/LM84
 family is that it features critical limits with hysteresis, and an
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index d2bcb47..690949b 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -85,7 +85,7 @@
  * and MAX6658 have address 0x4c.
  * ADM1032-2, ADT7461-2, LM89-1, LM99-1 and MAX6646 have address 0x4d.
  * MAX6647 has address 0x4e.
- * MAX6659 can have address 0x4c, 0x4d or 0x4e (unsupported).
+ * MAX6659 can have address 0x4c, 0x4d or 0x4e.
  * MAX6680 and MAX6681 can have address 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
  * 0x4c, 0x4d or 0x4e.
  */
@@ -94,7 +94,7 @@ static const unsigned short normal_i2c[] = {
 	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
-	w83l771 };
+	w83l771, max6659 };
 
 /*
  * The LM90 registers
@@ -138,6 +138,10 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
 /* MAX6646/6647/6649/6657/6658/6659 registers */
 
 #define MAX6657_REG_R_LOCAL_TEMPL	0x11
+#define MAX6659_REG_R_REMOTE_EMERG	0x16
+#define MAX6659_REG_W_REMOTE_EMERG	0x16
+#define MAX6659_REG_R_LOCAL_EMERG	0x17
+#define MAX6659_REG_W_LOCAL_EMERG	0x17
 
 /*
  * Device flags
@@ -177,7 +181,7 @@ static const struct i2c_device_id lm90_id[] = {
 	{ "max6649", max6646 },
 	{ "max6657", max6657 },
 	{ "max6658", max6657 },
-	{ "max6659", max6657 },
+	{ "max6659", max6659 },
 	{ "max6680", max6680 },
 	{ "max6681", max6680 },
 	{ "w83l771", w83l771 },
@@ -218,12 +222,12 @@ struct lm90_data {
 			   1: local high limit
 			   2: local critical limit
 			   3: remote critical limit
-			   4: local emergency limit
-			   5: remote emergency limit */
+			   4: local emergency limit (max6659 only)
+			   5: remote emergency limit (max6659 only) */
 	s16 temp11[5];	/* 0: remote input
 			   1: remote low limit
 			   2: remote high limit
-			   3: remote offset (except max6646 and max6657)
+			   3: remote offset (except max6646 and max6657/58/59)
 			   4: local input */
 	u8 temp_hyst;
 	u8 alarms; /* bitvector */
@@ -384,11 +388,13 @@ static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 			 const char *buf, size_t count)
 {
-	static const u8 reg[4] = {
+	static const u8 reg[6] = {
 		LM90_REG_W_LOCAL_LOW,
 		LM90_REG_W_LOCAL_HIGH,
 		LM90_REG_W_LOCAL_CRIT,
 		LM90_REG_W_REMOTE_CRIT,
+		MAX6659_REG_W_LOCAL_EMERG,
+		MAX6659_REG_W_REMOTE_EMERG,
 	};
 
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
@@ -787,12 +793,20 @@ static int lm90_detect(struct i2c_client *new_client,
 		 * register. Likewise, the config1 register seems to lack a
 		 * low nibble, so the value will be those of the previous
 		 * read, so in our case those of the man_id register.
+		 * MAX6659 has a third set of upper temperature limit registers.
+		 * Those registers also return values on MAX6657 and MAX6658,
+		 * thus the only way to detect MAX6659 is by its address.
+		 * For this reason it will be mis-detected as MAX6657 if its
+		 * address is 0x4C.
 		 */
 		if (chip_id == man_id
-		 && (address == 0x4C || address == 0x4D)
+		 && (address == 0x4C || address == 0x4D || address == 0x4E)
 		 && (reg_config1 & 0x1F) == (man_id & 0x0F)
 		 && reg_convrate <= 0x09) {
-			name = "max6657";
+			if (address == 0x4C)
+				name = "max6657";
+			else
+				name = "max6659";
 		} else
 		/*
 		 * The chip_id register of the MAX6680 and MAX6681 holds the
@@ -885,16 +899,21 @@ static int lm90_probe(struct i2c_client *new_client,
 	}
 
 	/* Set chip capabilities */
-	if (data->kind != max6657 && data->kind != max6646)
+	if (data->kind != max6657 && data->kind != max6659
+	    && data->kind != max6646)
 		data->flags |= LM90_HAVE_OFFSET;
 
-	if (data->kind == max6657 || data->kind == max6646)
+	if (data->kind == max6657 || data->kind == max6659
+	    || data->kind == max6646)
 		data->flags |= LM90_HAVE_LOCAL_EXT;
 
-	if (data->kind != max6657 && data->kind != max6646
-	    && data->kind != max6680)
+	if (data->kind != max6657 && data->kind != max6659
+	    && data->kind != max6646 && data->kind != max6680)
 		data->flags |= LM90_HAVE_REM_LIMIT_EXT;
 
+	if (data->kind == max6659)
+		data->flags |= LM90_HAVE_EMERGENCY;
+
 	/* Initialize the LM90 chip */
 	lm90_init_client(new_client);
 
@@ -1102,6 +1121,12 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 					  &l) == 0)
 				data->temp11[3] = (h << 8) | l;
 		}
+		if (data->flags & LM90_HAVE_EMERGENCY) {
+			lm90_read_reg(client, MAX6659_REG_R_LOCAL_EMERG,
+				      &data->temp8[4]);
+			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
+				      &data->temp8[5]);
+		}
 		lm90_read_reg(client, LM90_REG_R_STATUS, &data->alarms);
 
 		/* Re-enable ALERT# output if it was originally enabled and
-- 
1.7.0.87.g0901d

