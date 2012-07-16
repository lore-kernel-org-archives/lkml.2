Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2GPHRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:17:47 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:32960 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2GPHRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:17:42 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjxHAH6/A1BV5qoUPGdsb2JhbABFiiSuGBkBAQEBNzSCIQEFJy8TAQ8QCEk5ChQGE4gRum8UkXMDmyCNAg
X-IronPort-AV: E=Sophos;i="4.77,592,1336341600"; 
   d="scan'208";a="374506754"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/2] hwmon: (applesmc) Ignore some temperature registers
Date: Mon, 16 Jul 2012 09:18:11 +0200
Message-Id: <1342423091-330-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342423091-330-1-git-send-email-rydberg@euromail.se>
References: <1342423091-330-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all sensors in the T range are useful temperatures.  This patch
creates a subset of sensors to be exported to userland, excluding the
unknown types.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c | 75 ++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 75f87f1..4d937a1 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -133,11 +133,13 @@ static struct applesmc_registers {
 	unsigned int temp_count;	/* number of temperature registers */
 	unsigned int temp_begin;	/* temperature lower index bound */
 	unsigned int temp_end;		/* temperature upper index bound */
+	unsigned int index_count;	/* size of temperature index array */
 	int num_light_sensors;		/* number of light sensors */
 	bool has_accelerometer;		/* has motion sensor */
 	bool has_key_backlight;		/* has keyboard backlight */
 	bool init_complete;		/* true when fully initialized */
 	struct applesmc_entry *cache;	/* cached key entries */
+	const char **index;		/* temperature key index */
 } smcreg = {
 	.mutex = __MUTEX_INITIALIZER(smcreg.mutex),
 };
@@ -469,6 +471,30 @@ static void applesmc_device_init(void)
 	pr_warn("failed to init the device\n");
 }
 
+static int applesmc_init_index(struct applesmc_registers *s)
+{
+	const struct applesmc_entry *entry;
+	unsigned int i;
+
+	if (s->index)
+		return 0;
+
+	s->index = kcalloc(s->temp_count, sizeof(s->index[0]), GFP_KERNEL);
+	if (!s->index)
+		return -ENOMEM;
+
+	for (i = s->temp_begin; i < s->temp_end; i++) {
+		entry = applesmc_get_entry_by_index(i);
+		if (IS_ERR(entry))
+			continue;
+		if (strcmp(entry->type, TEMP_SENSOR_TYPE))
+			continue;
+		s->index[s->index_count++] = entry->key;
+	}
+
+	return 0;
+}
+
 /*
  * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
  */
@@ -504,6 +530,10 @@ static int applesmc_init_smcreg_try(void)
 		return ret;
 	s->temp_count = s->temp_end - s->temp_begin;
 
+	ret = applesmc_init_index(s);
+	if (ret)
+		return ret;
+
 	ret = applesmc_has_key(LIGHT_SENSOR_LEFT_KEY, &left_light_sensor);
 	if (ret)
 		return ret;
@@ -520,8 +550,8 @@ static int applesmc_init_smcreg_try(void)
 	s->num_light_sensors = left_light_sensor + right_light_sensor;
 	s->init_complete = true;
 
-	pr_info("key=%d fan=%d temp=%d acc=%d lux=%d kbd=%d\n",
-	       s->key_count, s->fan_count, s->temp_count,
+	pr_info("key=%d fan=%d temp=%d index=%d acc=%d lux=%d kbd=%d\n",
+	       s->key_count, s->fan_count, s->temp_count, s->index_count,
 	       s->has_accelerometer,
 	       s->num_light_sensors,
 	       s->has_key_backlight);
@@ -529,6 +559,15 @@ static int applesmc_init_smcreg_try(void)
 	return 0;
 }
 
+static void applesmc_destroy_smcreg(void)
+{
+	kfree(smcreg.index);
+	smcreg.index = NULL;
+	kfree(smcreg.cache);
+	smcreg.cache = NULL;
+	smcreg.init_complete = false;
+}
+
 /*
  * applesmc_init_smcreg - Initialize register cache.
  *
@@ -549,19 +588,11 @@ static int applesmc_init_smcreg(void)
 		msleep(INIT_WAIT_MSECS);
 	}
 
-	kfree(smcreg.cache);
-	smcreg.cache = NULL;
+	applesmc_destroy_smcreg();
 
 	return ret;
 }
 
-static void applesmc_destroy_smcreg(void)
-{
-	kfree(smcreg.cache);
-	smcreg.cache = NULL;
-	smcreg.init_complete = false;
-}
-
 /* Device model stuff */
 static int applesmc_probe(struct platform_device *dev)
 {
@@ -705,33 +736,21 @@ out:
 static ssize_t applesmc_show_sensor_label(struct device *dev,
 			struct device_attribute *devattr, char *sysfsbuf)
 {
-	int index = smcreg.temp_begin + to_index(devattr);
-	const struct applesmc_entry *entry;
+	const char *key = smcreg.index[to_index(devattr)];
 
-	entry = applesmc_get_entry_by_index(index);
-	if (IS_ERR(entry))
-		return PTR_ERR(entry);
-
-	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", entry->key);
+	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
 }
 
 /* Displays degree Celsius * 1000 */
 static ssize_t applesmc_show_temperature(struct device *dev,
 			struct device_attribute *devattr, char *sysfsbuf)
 {
-	int index = smcreg.temp_begin + to_index(devattr);
-	const struct applesmc_entry *entry;
+	const char *key = smcreg.index[to_index(devattr)];
 	int ret;
 	s16 value;
 	int temp;
 
-	entry = applesmc_get_entry_by_index(index);
-	if (IS_ERR(entry))
-		return PTR_ERR(entry);
-	if (strcmp(entry->type, TEMP_SENSOR_TYPE))
-		return -EINVAL;
-
-	ret = applesmc_read_s16(entry->key, &value);
+	ret = applesmc_read_s16(key, &value);
 	if (ret)
 		return ret;
 
@@ -1247,7 +1266,7 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_info;
 
-	ret = applesmc_create_nodes(temp_group, smcreg.temp_count);
+	ret = applesmc_create_nodes(temp_group, smcreg.index_count);
 	if (ret)
 		goto out_fans;
 
-- 
1.7.11.2

