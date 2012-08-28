Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2H1Qa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:30:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57107 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2H1Qay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:30:54 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 28 Aug 2012 11:30:49 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>,
        Dirk Eibach <eibach@gdsys.de>,
        Steve Glendinning <steve.glendinning@shawell.net>
Subject: =?UTF-8?q?=5BPATCH=202/2=5D=20hwmon=3A=20Use=20IDIV=5FROUND=5FCLOSEST=20if=20the=20dividend=20can=20be=20negative?=
Date: Tue, 28 Aug 2012 09:30:56 -0700
Message-Id: <1346171456-29255-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1346171456-29255-1-git-send-email-linux@roeck-us.net>
References: <1346171456-29255-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DIV_ROUND_CLOSEST returns bad values for negative dividends.
Replace with IDIV_ROUND_CLOSEST where this can happen.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Dirk Eibach <eibach@gdsys.de>
Cc: Steve Glendinning <steve.glendinning@shawell.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ad7314.c           |    2 +-
 drivers/hwmon/ads1015.c          |    2 +-
 drivers/hwmon/adt7410.c          |    6 +++---
 drivers/hwmon/emc2103.c          |    4 ++--
 drivers/hwmon/pmbus/pmbus_core.c |    4 ++--
 drivers/hwmon/w83627ehf.c        |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index 455294f..6fb3013 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -81,7 +81,7 @@ static ssize_t ad7314_show_temperature(struct device *dev,
 		data = (data << 2) >> 2;
 
 		return sprintf(buf, "%d\n",
-			       DIV_ROUND_CLOSEST(data * 3125, 100));
+			       IDIV_ROUND_CLOSEST(data * 3125, 100));
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index 2798246..ab12c7f 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -114,7 +114,7 @@ static int ads1015_reg_to_mv(struct i2c_client *client, unsigned int channel,
 	unsigned int pga = data->channel_data[channel].pga;
 	int fullscale = fullscale_table[pga];
 
-	return DIV_ROUND_CLOSEST(reg * fullscale, 0x7ff0);
+	return IDIV_ROUND_CLOSEST(reg * fullscale, 0x7ff0);
 }
 
 /* sysfs callback function */
diff --git a/drivers/hwmon/adt7410.c b/drivers/hwmon/adt7410.c
index 030c8d7..0acc887 100644
--- a/drivers/hwmon/adt7410.c
+++ b/drivers/hwmon/adt7410.c
@@ -173,8 +173,8 @@ abort:
 
 static s16 ADT7410_TEMP_TO_REG(long temp)
 {
-	return DIV_ROUND_CLOSEST(SENSORS_LIMIT(temp, ADT7410_TEMP_MIN,
-					       ADT7410_TEMP_MAX) * 128, 1000);
+	return IDIV_ROUND_CLOSEST(SENSORS_LIMIT(temp, ADT7410_TEMP_MIN,
+						ADT7410_TEMP_MAX) * 128, 1000);
 }
 
 static int ADT7410_REG_TO_TEMP(struct adt7410_data *data, s16 reg)
@@ -186,7 +186,7 @@ static int ADT7410_REG_TO_TEMP(struct adt7410_data *data, s16 reg)
 	 * temperature is stored in twos complement format, in steps of
 	 * 1/128°C
 	 */
-	return DIV_ROUND_CLOSEST(reg * 1000, 128);
+	return IDIV_ROUND_CLOSEST(reg * 1000, 128);
 }
 
 /*-----------------------------------------------------------------------*/
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index 77f434c..161343d 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -250,7 +250,7 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *da,
 	if (result < 0)
 		return -EINVAL;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
+	val = IDIV_ROUND_CLOSEST(val, 1000);
 	if ((val < -63) || (val > 127))
 		return -EINVAL;
 
@@ -274,7 +274,7 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *da,
 	if (result < 0)
 		return -EINVAL;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
+	val = IDIV_ROUND_CLOSEST(val, 1000);
 	if ((val < -63) || (val > 127))
 		return -EINVAL;
 
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 29b319d..58ddf57 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -507,7 +507,7 @@ static long pmbus_reg2data_direct(struct pmbus_data *data,
 		R--;
 	}
 	while (R < 0) {
-		val = DIV_ROUND_CLOSEST(val, 10);
+		val = IDIV_ROUND_CLOSEST(val, 10);
 		R++;
 	}
 
@@ -647,7 +647,7 @@ static u16 pmbus_data2reg_direct(struct pmbus_data *data,
 		R--;
 	}
 	while (R < 0) {
-		val = DIV_ROUND_CLOSEST(val, 10);
+		val = IDIV_ROUND_CLOSEST(val, 10);
 		R++;
 	}
 
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 1821b74..f500fa9 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1258,7 +1258,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = SENSORS_LIMIT(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = SENSORS_LIMIT(IDIV_ROUND_CLOSEST(val, 1000), -128, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
1.7.9.7

