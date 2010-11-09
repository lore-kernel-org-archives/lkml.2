Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0KIPRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:17:38 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:60294 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983Ab0KIPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:17:33 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 07/11] hwmon: applesmc: Extract all features generically (rev2)
Date: Tue,  9 Nov 2010 16:15:07 +0100
Message-Id: <1289315711-3011-8-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpwk-0007Up-6n.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PFpwk-0007Up-6n 08d658699103ed5b320a67af3600c2a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With temperature keys being determined automatically, the dmi match
data is only used to assign features that can easily be detected from
the smc. This patch removes the dmi match data altogether, and reduces
the match table to the main machine models.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |  241 +++++++++++----------------------------------
 1 files changed, 59 insertions(+), 182 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 6663721..4e45aa7 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -106,16 +106,6 @@ static const char* fan_speed_keys[] = {
 
 #define to_index(attr) (to_sensor_dev_attr(attr)->index)
 
-/* Structure to be passed to DMI_MATCH function */
-struct dmi_match_data {
-/* Indicates whether this computer has an accelerometer. */
-	int accelerometer;
-/* Indicates whether this computer has light sensors and keyboard backlight. */
-	int light;
-/* Indicates which temperature sensors set to use. */
-	int temperature_set;
-};
-
 /* Dynamic device node attributes */
 struct applesmc_dev_attr {
 	struct sensor_device_attribute sda;	/* hwmon attributes */
@@ -146,6 +136,9 @@ static struct applesmc_registers {
 	unsigned int temp_count;	/* number of temperature registers */
 	unsigned int temp_begin;	/* temperature lower index bound */
 	unsigned int temp_end;		/* temperature upper index bound */
+	int num_light_sensors;		/* number of light sensors */
+	bool has_accelerometer;		/* has motion sensor */
+	bool has_key_backlight;		/* has keyboard backlight */
 	bool init_complete;		/* true when fully initialized */
 	struct applesmc_entry *cache;	/* cached key entries */
 } smcreg;
@@ -159,12 +152,6 @@ static u8 backlight_state[2];
 static struct device *hwmon_dev;
 static struct input_polled_dev *applesmc_idev;
 
-/* Indicates whether this computer has an accelerometer. */
-static unsigned int applesmc_accelerometer;
-
-/* Indicates whether this computer has light sensors and keyboard backlight. */
-static unsigned int applesmc_light;
-
 /* The number of fans handled by the driver */
 static unsigned int fans_handled;
 
@@ -431,6 +418,18 @@ static int applesmc_write_key(const char *key, const u8 *buffer, u8 len)
 	return applesmc_write_entry(entry, buffer, len);
 }
 
+static int applesmc_has_key(const char *key, bool *value)
+{
+	const struct applesmc_entry *entry;
+
+	entry = applesmc_get_entry_by_key(key);
+	if (IS_ERR(entry) && PTR_ERR(entry) != -EINVAL)
+		return PTR_ERR(entry);
+
+	*value = !IS_ERR(entry);
+	return 0;
+}
+
 /*
  * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z).
  */
@@ -466,7 +465,7 @@ static void applesmc_device_init(void)
 	int total;
 	u8 buffer[2];
 
-	if (!applesmc_accelerometer)
+	if (!smcreg.has_accelerometer)
 		return;
 
 	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
@@ -504,6 +503,7 @@ static int applesmc_get_fan_count(void)
 static int applesmc_init_smcreg_try(void)
 {
 	struct applesmc_registers *s = &smcreg;
+	bool left_light_sensor, right_light_sensor;
 	int ret;
 
 	if (s->init_complete)
@@ -528,9 +528,27 @@ static int applesmc_init_smcreg_try(void)
 		return ret;
 	s->temp_count = s->temp_end - s->temp_begin;
 
+	ret = applesmc_has_key(LIGHT_SENSOR_LEFT_KEY, &left_light_sensor);
+	if (ret)
+		return ret;
+	ret = applesmc_has_key(LIGHT_SENSOR_RIGHT_KEY, &right_light_sensor);
+	if (ret)
+		return ret;
+	ret = applesmc_has_key(MOTION_SENSOR_KEY, &s->has_accelerometer);
+	if (ret)
+		return ret;
+	ret = applesmc_has_key(BACKLIGHT_KEY, &s->has_key_backlight);
+	if (ret)
+		return ret;
+
+	s->num_light_sensors = left_light_sensor + right_light_sensor;
 	s->init_complete = true;
 
-	pr_info("key=%d temp=%d\n", s->key_count, s->temp_count);
+	pr_info("key=%d temp=%d acc=%d lux=%d kbd=%d\n",
+	       s->key_count, s->temp_count,
+	       s->has_accelerometer,
+	       s->num_light_sensors,
+	       s->has_key_backlight);
 
 	return 0;
 }
@@ -579,7 +597,7 @@ static int applesmc_probe(struct platform_device *dev)
 /* Synchronize device with memorized backlight state */
 static int applesmc_pm_resume(struct device *dev)
 {
-	if (applesmc_light)
+	if (smcreg.has_key_backlight)
 		applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
 	return 0;
 }
@@ -1107,23 +1125,6 @@ static struct applesmc_node_group temp_group[] = {
 /* Module stuff */
 
 /*
- * applesmc_dmi_match - found a match.  return one, short-circuiting the hunt.
- */
-static int applesmc_dmi_match(const struct dmi_system_id *id)
-{
-	struct dmi_match_data* dmi_data = id->driver_data;
-	pr_info("%s detected:\n", id->ident);
-	applesmc_accelerometer = dmi_data->accelerometer;
-	pr_info(" - Model %s accelerometer\n",
-		applesmc_accelerometer ? "with" : "without");
-	applesmc_light = dmi_data->light;
-	pr_info(" - Model %s light sensors and backlight\n",
-		applesmc_light ? "with" : "without");
-
-	return 1;
-}
-
-/*
  * applesmc_destroy_nodes - remove files and free associated memory
  */
 static void applesmc_destroy_nodes(struct applesmc_node_group *groups)
@@ -1237,165 +1238,38 @@ static void applesmc_release_accelerometer(void)
 	input_free_polled_device(applesmc_idev);
 	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
 }
-
-static __initdata struct dmi_match_data applesmc_dmi_data[] = {
-/* MacBook Pro: accelerometer, backlight and temperature set 0 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 0 },
-/* MacBook2: accelerometer and temperature set 1 */
-	{ .accelerometer = 1, .light = 0, .temperature_set = 1 },
-/* MacBook: accelerometer and temperature set 2 */
-	{ .accelerometer = 1, .light = 0, .temperature_set = 2 },
-/* MacMini: temperature set 3 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 3 },
-/* MacPro: temperature set 4 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
-/* iMac: temperature set 5 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
-/* MacBook3, MacBook4: accelerometer and temperature set 6 */
-	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
-/* MacBook Air: accelerometer, backlight and temperature set 7 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
-/* MacBook Pro 4: accelerometer, backlight and temperature set 8 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
-/* MacBook Pro 3: accelerometer, backlight and temperature set 9 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
-/* iMac 5: light sensor only, temperature set 10 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
-/* MacBook 5: accelerometer, backlight and temperature set 11 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
-/* MacBook Pro 5: accelerometer, backlight and temperature set 12 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
-/* iMac 8: light sensor only, temperature set 13 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
-/* iMac 6: light sensor only, temperature set 14 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
-/* MacBook Air 2,1: accelerometer, backlight and temperature set 15 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
-/* MacPro3,1: temperature set 16 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
-/* iMac 9,1: light sensor only, temperature set 17 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
-/* MacBook Pro 2,2: accelerometer, backlight and temperature set 18 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
-/* MacBook Pro 5,3: accelerometer, backlight and temperature set 19 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 19 },
-/* MacBook Pro 5,4: accelerometer, backlight and temperature set 20 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
-/* MacBook Pro 6,2: accelerometer, backlight and temperature set 21 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
-/* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
-	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
-/* MacBook Air 3,1: accelerometer, backlight and temperature set 23 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 23 },
-};
+static int applesmc_dmi_match(const struct dmi_system_id *id)
+{
+	return 1;
+}
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
-	{ applesmc_dmi_match, "Apple MacBook Air 3", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3") },
-		&applesmc_dmi_data[23]},
-	{ applesmc_dmi_match, "Apple MacBook Air 2", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2") },
-		&applesmc_dmi_data[15]},
 	{ applesmc_dmi_match, "Apple MacBook Air", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
-		&applesmc_dmi_data[7]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 7", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro7") },
-		&applesmc_dmi_data[22]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 5,4", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,4") },
-		&applesmc_dmi_data[20]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 5,3", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3") },
-		&applesmc_dmi_data[19]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 6", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro6") },
-		&applesmc_dmi_data[21]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },
-		&applesmc_dmi_data[12]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
-		&applesmc_dmi_data[8]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 3", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
-		&applesmc_dmi_data[9]},
-	{ applesmc_dmi_match, "Apple MacBook Pro 2,2", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Computer, Inc."),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2") },
-		&applesmc_dmi_data[18]},
+	},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
-		&applesmc_dmi_data[0]},
-	{ applesmc_dmi_match, "Apple MacBook (v2)", {
-	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
-		&applesmc_dmi_data[1]},
-	{ applesmc_dmi_match, "Apple MacBook (v3)", {
-	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
-		&applesmc_dmi_data[6]},
-	{ applesmc_dmi_match, "Apple MacBook 4", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4") },
-		&applesmc_dmi_data[6]},
-	{ applesmc_dmi_match, "Apple MacBook 5", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5") },
-		&applesmc_dmi_data[11]},
+	},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
-		&applesmc_dmi_data[2]},
+	},
 	{ applesmc_dmi_match, "Apple Macmini", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
-		&applesmc_dmi_data[3]},
-	{ applesmc_dmi_match, "Apple MacPro2", {
-	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
-		&applesmc_dmi_data[4]},
-	{ applesmc_dmi_match, "Apple MacPro3", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro3") },
-		&applesmc_dmi_data[16]},
+	},
 	{ applesmc_dmi_match, "Apple MacPro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
-		&applesmc_dmi_data[4]},
-	{ applesmc_dmi_match, "Apple iMac 9,1", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1") },
-		&applesmc_dmi_data[17]},
-	{ applesmc_dmi_match, "Apple iMac 8", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
-		&applesmc_dmi_data[13]},
-	{ applesmc_dmi_match, "Apple iMac 6", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac6") },
-		&applesmc_dmi_data[14]},
-	{ applesmc_dmi_match, "Apple iMac 5", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
-		&applesmc_dmi_data[10]},
+	},
 	{ applesmc_dmi_match, "Apple iMac", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
-		&applesmc_dmi_data[5]},
+	},
 	{ .ident = NULL }
 };
 
@@ -1465,18 +1339,20 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_fans;
 
-	if (applesmc_accelerometer) {
+	if (smcreg.has_accelerometer) {
 		ret = applesmc_create_accelerometer();
 		if (ret)
 			goto out_temperature;
 	}
 
-	if (applesmc_light) {
+	if (smcreg.num_light_sensors) {
 		/* Add light sensor file */
 		ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_light.attr);
 		if (ret)
 			goto out_accelerometer;
+	}
 
+	if (smcreg.has_key_backlight) {
 		/* Create the workqueue */
 		applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
 		if (!applesmc_led_wq) {
@@ -1501,16 +1377,16 @@ static int __init applesmc_init(void)
 	return 0;
 
 out_light_ledclass:
-	if (applesmc_light)
+	if (smcreg.has_key_backlight)
 		led_classdev_unregister(&applesmc_backlight);
 out_light_wq:
-	if (applesmc_light)
+	if (smcreg.has_key_backlight)
 		destroy_workqueue(applesmc_led_wq);
 out_light_sysfs:
-	if (applesmc_light)
+	if (smcreg.num_light_sensors)
 		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
 out_accelerometer:
-	if (applesmc_accelerometer)
+	if (smcreg.has_accelerometer)
 		applesmc_release_accelerometer();
 out_temperature:
 	applesmc_destroy_nodes(temp_group);
@@ -1537,12 +1413,13 @@ out:
 static void __exit applesmc_exit(void)
 {
 	hwmon_device_unregister(hwmon_dev);
-	if (applesmc_light) {
+	if (smcreg.has_key_backlight) {
 		led_classdev_unregister(&applesmc_backlight);
 		destroy_workqueue(applesmc_led_wq);
-		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
 	}
-	if (applesmc_accelerometer)
+	if (smcreg.num_light_sensors)
+		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
+	if (smcreg.has_accelerometer)
 		applesmc_release_accelerometer();
 	applesmc_destroy_nodes(temp_group);
 	while (fans_handled)
-- 
1.7.1

