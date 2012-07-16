Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2GPHRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:17:39 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:60877 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2GPHRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:17:38 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjZHAMe/A1BV5qoUPGdsb2JhbABFiiSuGBkBAQEBNzSCTi8TAQ8YgQIKGhOIEbpvFJFzA5sgjQI
X-IronPort-AV: E=Sophos;i="4.77,592,1336341600"; 
   d="scan'208";a="153957170"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] hwmon: (applesmc) Allow negative temperature values
Date: Mon, 16 Jul 2012 09:18:10 +0200
Message-Id: <1342423091-330-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many userland reports of sensors with unreasonably small and
large temperatures. There seem to be several reasons for this:

Firstly, the major sensor type (sp78) is actually a signed number.
This explains why some sensors show very small or large values - they
are in fact all small, but of different sign.

Secondly, the other sensor type (1-hex) is not properly understood; it
may be that it is not a temperature after all.

Thirdly, some sensors are differential in nature, showing changes over
time rather than absolute numbers.  This explains why those values are
small and of varying sign.

This patch interprets the sp78 type as signed short, but keeps the
original scaling. For other types, -EINVAL is returned, since the
nature of those sensors is unknown.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index f41585e..75f87f1 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -80,6 +80,8 @@
 #define FANS_MANUAL		"FS! " /* r-w ui16 */
 #define FAN_ID_FMT		"F%dID" /* r-o char[16] */
 
+#define TEMP_SENSOR_TYPE	"sp78"
+
 /* List of keys used to read/write fan speeds */
 static const char *const fan_speed_fmt[] = {
 	"F%dAc",		/* actual speed */
@@ -720,27 +722,22 @@ static ssize_t applesmc_show_temperature(struct device *dev,
 	int index = smcreg.temp_begin + to_index(devattr);
 	const struct applesmc_entry *entry;
 	int ret;
-	u8 buffer[2];
-	unsigned int temp;
+	s16 value;
+	int temp;
 
 	entry = applesmc_get_entry_by_index(index);
 	if (IS_ERR(entry))
 		return PTR_ERR(entry);
-	if (entry->len > 2)
+	if (strcmp(entry->type, TEMP_SENSOR_TYPE))
 		return -EINVAL;
 
-	ret = applesmc_read_entry(entry, buffer, entry->len);
+	ret = applesmc_read_s16(entry->key, &value);
 	if (ret)
 		return ret;
 
-	if (entry->len == 2) {
-		temp = buffer[0] * 1000;
-		temp += (buffer[1] >> 6) * 250;
-	} else {
-		temp = buffer[0] * 4000;
-	}
+	temp = 250 * (value >> 6);
 
-	return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", temp);
+	return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", temp);
 }
 
 static ssize_t applesmc_show_fan_speed(struct device *dev,
-- 
1.7.11.2

