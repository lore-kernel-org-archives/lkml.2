Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0KIPRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:17:54 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54423 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717Ab0KIPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:17:44 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 09/11] hwmon: applesmc: Simplify feature sysfs handling (rev2)
Date: Tue,  9 Nov 2010 16:15:09 +0100
Message-Id: <1289315711-3011-10-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpww-0003qt-3p.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpww-0003qt-3p d1d9ed21b075f2c63ec4becc57046f67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given the dynamic node construction method, the setup of the
accelerometer, light sensor and keyboard backlight sysfs nodes
can be simplified. This patch does not contain any logic changes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |  169 +++++++++++++++++++++-------------------------
 1 files changed, 76 insertions(+), 93 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 733d4c9..b907c20 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -981,47 +981,27 @@ static struct led_classdev applesmc_backlight = {
 	.brightness_set		= applesmc_brightness_set,
 };
 
-static DEVICE_ATTR(name, 0444, applesmc_name_show, NULL);
-
-static DEVICE_ATTR(position, 0444, applesmc_position_show, NULL);
-static DEVICE_ATTR(calibrate, 0644,
-			applesmc_calibrate_show, applesmc_calibrate_store);
-
-static struct attribute *accelerometer_attributes[] = {
-	&dev_attr_position.attr,
-	&dev_attr_calibrate.attr,
-	NULL
+static struct applesmc_node_group info_group[] = {
+	{ "name", applesmc_name_show },
+	{ "key_count", applesmc_key_count_show },
+	{ "key_at_index", applesmc_key_at_index_show, applesmc_key_at_index_store },
+	{ "key_at_index_name", applesmc_key_at_index_name_show },
+	{ "key_at_index_type", applesmc_key_at_index_type_show },
+	{ "key_at_index_data_length", applesmc_key_at_index_data_length_show },
+	{ "key_at_index_data", applesmc_key_at_index_read_show },
+	{ }
 };
 
-static const struct attribute_group accelerometer_attributes_group =
-	{ .attrs = accelerometer_attributes };
-
-static DEVICE_ATTR(light, 0444, applesmc_light_show, NULL);
-
-static DEVICE_ATTR(key_count, 0444, applesmc_key_count_show, NULL);
-static DEVICE_ATTR(key_at_index, 0644,
-		applesmc_key_at_index_show, applesmc_key_at_index_store);
-static DEVICE_ATTR(key_at_index_name, 0444,
-					applesmc_key_at_index_name_show, NULL);
-static DEVICE_ATTR(key_at_index_type, 0444,
-					applesmc_key_at_index_type_show, NULL);
-static DEVICE_ATTR(key_at_index_data_length, 0444,
-				applesmc_key_at_index_data_length_show, NULL);
-static DEVICE_ATTR(key_at_index_data, 0444,
-				applesmc_key_at_index_read_show, NULL);
-
-static struct attribute *key_enumeration_attributes[] = {
-	&dev_attr_key_count.attr,
-	&dev_attr_key_at_index.attr,
-	&dev_attr_key_at_index_name.attr,
-	&dev_attr_key_at_index_type.attr,
-	&dev_attr_key_at_index_data_length.attr,
-	&dev_attr_key_at_index_data.attr,
-	NULL
+static struct applesmc_node_group accelerometer_group[] = {
+	{ "position", applesmc_position_show },
+	{ "calibrate", applesmc_calibrate_show, applesmc_calibrate_store },
+	{ }
 };
 
-static const struct attribute_group key_enumeration_group =
-	{ .attrs = key_enumeration_attributes };
+static struct applesmc_node_group light_sensor_group[] = {
+	{ "light", applesmc_light_show },
+	{ }
+};
 
 static struct applesmc_node_group fan_group[] = {
 	{ "fan%d_label", applesmc_show_fan_position },
@@ -1104,8 +1084,10 @@ static int applesmc_create_accelerometer(void)
 	struct input_dev *idev;
 	int ret;
 
-	ret = sysfs_create_group(&pdev->dev.kobj,
-					&accelerometer_attributes_group);
+	if (!smcreg.has_accelerometer)
+		return 0;
+
+	ret = applesmc_create_nodes(accelerometer_group, 1);
 	if (ret)
 		goto out;
 
@@ -1142,7 +1124,7 @@ out_idev:
 	input_free_polled_device(applesmc_idev);
 
 out_sysfs:
-	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
+	applesmc_destroy_nodes(accelerometer_group);
 
 out:
 	pr_warn("driver init failed (ret=%d)!\n", ret);
@@ -1152,10 +1134,45 @@ out:
 /* Release all ressources used by the accelerometer */
 static void applesmc_release_accelerometer(void)
 {
+	if (!smcreg.has_accelerometer)
+		return;
 	input_unregister_polled_device(applesmc_idev);
 	input_free_polled_device(applesmc_idev);
-	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
+	applesmc_destroy_nodes(accelerometer_group);
 }
+
+static int applesmc_create_light_sensor(void)
+{
+	if (!smcreg.num_light_sensors)
+		return 0;
+	return applesmc_create_nodes(light_sensor_group, 1);
+}
+
+static void applesmc_release_light_sensor(void)
+{
+	if (!smcreg.num_light_sensors)
+		return;
+	applesmc_destroy_nodes(light_sensor_group);
+}
+
+static int applesmc_create_key_backlight(void)
+{
+	if (!smcreg.has_key_backlight)
+		return 0;
+	applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
+	if (!applesmc_led_wq)
+		return -ENOMEM;
+	return led_classdev_register(&pdev->dev, &applesmc_backlight);
+}
+
+static void applesmc_release_key_backlight(void)
+{
+	if (!smcreg.has_key_backlight)
+		return;
+	led_classdev_unregister(&applesmc_backlight);
+	destroy_workqueue(applesmc_led_wq);
+}
+
 static int applesmc_dmi_match(const struct dmi_system_id *id)
 {
 	return 1;
@@ -1223,15 +1240,10 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_device;
 
-	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_name.attr);
+	ret = applesmc_create_nodes(info_group, 1);
 	if (ret)
 		goto out_smcreg;
 
-	/* Create key enumeration sysfs files */
-	ret = sysfs_create_group(&pdev->dev.kobj, &key_enumeration_group);
-	if (ret)
-		goto out_name;
-
 	ret = applesmc_create_nodes(fan_group, smcreg.fan_count);
 	if (ret)
 		goto out_info;
@@ -1240,32 +1252,17 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_fans;
 
-	if (smcreg.has_accelerometer) {
-		ret = applesmc_create_accelerometer();
-		if (ret)
-			goto out_temperature;
-	}
-
-	if (smcreg.num_light_sensors) {
-		/* Add light sensor file */
-		ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_light.attr);
-		if (ret)
-			goto out_accelerometer;
-	}
+	ret = applesmc_create_accelerometer();
+	if (ret)
+		goto out_temperature;
 
-	if (smcreg.has_key_backlight) {
-		/* Create the workqueue */
-		applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
-		if (!applesmc_led_wq) {
-			ret = -ENOMEM;
-			goto out_light_sysfs;
-		}
+	ret = applesmc_create_light_sensor();
+	if (ret)
+		goto out_accelerometer;
 
-		/* register as a led device */
-		ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
-		if (ret < 0)
-			goto out_light_wq;
-	}
+	ret = applesmc_create_key_backlight();
+	if (ret)
+		goto out_light_sysfs;
 
 	hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(hwmon_dev)) {
@@ -1278,25 +1275,17 @@ static int __init applesmc_init(void)
 	return 0;
 
 out_light_ledclass:
-	if (smcreg.has_key_backlight)
-		led_classdev_unregister(&applesmc_backlight);
-out_light_wq:
-	if (smcreg.has_key_backlight)
-		destroy_workqueue(applesmc_led_wq);
+	applesmc_release_key_backlight();
 out_light_sysfs:
-	if (smcreg.num_light_sensors)
-		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
+	applesmc_release_light_sensor();
 out_accelerometer:
-	if (smcreg.has_accelerometer)
-		applesmc_release_accelerometer();
+	applesmc_release_accelerometer();
 out_temperature:
 	applesmc_destroy_nodes(temp_group);
 out_fans:
 	applesmc_destroy_nodes(fan_group);
 out_info:
-	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
-out_name:
-	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
+	applesmc_destroy_nodes(info_group);
 out_smcreg:
 	applesmc_destroy_smcreg();
 out_device:
@@ -1313,18 +1302,12 @@ out:
 static void __exit applesmc_exit(void)
 {
 	hwmon_device_unregister(hwmon_dev);
-	if (smcreg.has_key_backlight) {
-		led_classdev_unregister(&applesmc_backlight);
-		destroy_workqueue(applesmc_led_wq);
-	}
-	if (smcreg.num_light_sensors)
-		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
-	if (smcreg.has_accelerometer)
-		applesmc_release_accelerometer();
+	applesmc_release_key_backlight();
+	applesmc_release_light_sensor();
+	applesmc_release_accelerometer();
 	applesmc_destroy_nodes(temp_group);
 	applesmc_destroy_nodes(fan_group);
-	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
-	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
+	applesmc_destroy_nodes(info_group);
 	applesmc_destroy_smcreg();
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&applesmc_driver);
-- 
1.7.1

