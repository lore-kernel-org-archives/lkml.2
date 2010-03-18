Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0CRNha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:37:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0CRNh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:37:26 -0400
From: Matthew Garrett <mjg@redhat.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] hwmon: Add basic support for LM64 to lm63.c
Date: Thu, 18 Mar 2010 09:36:59 -0400
Message-Id: <1268919419-2125-1-git-send-email-mjg@redhat.com>
In-Reply-To: <20100318084135.15fb1996@hyperion.delvare>
References: <20100318084135.15fb1996@hyperion.delvare>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LM64 appears to be an LM63 with added GPIO lines. Add support for the
hwmon functionality - GPIO can be added at some later stage if someone
has a need for them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---

Capitalisation fixes and remove an unused variable.

 Documentation/hwmon/lm63 |    7 +++++++
 drivers/hwmon/Kconfig    |    9 +++++----
 drivers/hwmon/lm63.c     |   16 ++++++++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/hwmon/lm63 b/Documentation/hwmon/lm63
index 31660bf..b9843ea 100644
--- a/Documentation/hwmon/lm63
+++ b/Documentation/hwmon/lm63
@@ -7,6 +7,11 @@ Supported chips:
     Addresses scanned: I2C 0x4c
     Datasheet: Publicly available at the National Semiconductor website
                http://www.national.com/pf/LM/LM63.html
+  * National Semiconductor LM64
+    Prefix: 'lm64'
+    Addresses scanned: I2C 0x18 and 0x4e
+    Datasheet: Publicly available at the National Semiconductor website
+               http://www.national.com/pf/LM/LM64.html
 
 Author: Jean Delvare <khali@linux-fr.org>
 
@@ -55,3 +60,5 @@ The lm63 driver will not update its values more frequently than every
 second; reading them more often will do no harm, but will return 'old'
 values.
 
+The LM64 is effectively an LM63 with GPIO lines. The driver does not
+support these GPIO lines at present.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index e4595e6..1aca601 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -450,10 +450,11 @@ config SENSORS_LM63
 	tristate "National Semiconductor LM63"
 	depends on I2C
 	help
-	  If you say yes here you get support for the National Semiconductor
-	  LM63 remote diode digital temperature sensor with integrated fan
-	  control.  Such chips are found on the Tyan S4882 (Thunder K8QS Pro)
-	  motherboard, among others.
+	  If you say yes here you get support for the National
+	  Semiconductor LM63 and LM64 remote diode digital temperature
+	  sensors with integrated fan control.  Such chips are found
+	  on the Tyan S4882 (Thunder K8QS Pro) motherboard, among
+	  others.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm63.
diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index bf81aff..776aeb3 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -53,7 +53,7 @@
  * Address is fully defined internally and cannot be changed.
  */
 
-static const unsigned short normal_i2c[] = { 0x4c, I2C_CLIENT_END };
+static const unsigned short normal_i2c[] = { 0x18, 0x4c, 0x4e, I2C_CLIENT_END };
 
 /*
  * The LM63 registers
@@ -131,12 +131,15 @@ static struct lm63_data *lm63_update_device(struct device *dev);
 static int lm63_detect(struct i2c_client *client, struct i2c_board_info *info);
 static void lm63_init_client(struct i2c_client *client);
 
+enum chips { lm63, lm64 };
+
 /*
  * Driver data (common to all clients)
  */
 
 static const struct i2c_device_id lm63_id[] = {
-	{ "lm63", 0 },
+	{ "lm63", lm63 },
+	{ "lm64", lm64 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lm63_id);
@@ -422,6 +425,7 @@ static int lm63_detect(struct i2c_client *new_client,
 	struct i2c_adapter *adapter = new_client->adapter;
 	u8 man_id, chip_id, reg_config1, reg_config2;
 	u8 reg_alert_status, reg_alert_mask;
+	int address = new_client->addr;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -439,7 +443,6 @@ static int lm63_detect(struct i2c_client *new_client,
 			 LM63_REG_ALERT_MASK);
 
 	if (man_id != 0x01 /* National Semiconductor */
-	 || chip_id != 0x41 /* LM63 */
 	 || (reg_config1 & 0x18) != 0x00
 	 || (reg_config2 & 0xF8) != 0x00
 	 || (reg_alert_status & 0x20) != 0x00
@@ -450,7 +453,12 @@ static int lm63_detect(struct i2c_client *new_client,
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, "lm63", I2C_NAME_SIZE);
+	if (chip_id == 0x41 && address == 0x4c)
+		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
+	else if (chip_id == 0x51 && (address == 0x18 || address == 0x4e))
+		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
+	else
+		return -ENODEV;
 
 	return 0;
 }
-- 
1.7.0.1

