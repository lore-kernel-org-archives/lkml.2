Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab0EDNkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:40:21 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:40726 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759930Ab0EDNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:40:17 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] hwmon: applesmc: Correct sysfs fan error handling
Date: Tue,  4 May 2010 15:39:02 +0200
Message-Id: <1272980343-3880-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O9ILI-0005yN-61.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1O9ILI-0005yN-61 fca13f93997f5b5f92699f6ed26606b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code will not remove the sysfs files for fan numbers three
and up. Also, upon exit, fans one and two are removed regardless of
their existence.  This patch cleans up the sysfs error handling for
the fans.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   61 +++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 36a0d62..57c0331 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -209,6 +209,9 @@ static unsigned int applesmc_accelerometer;
 /* Indicates whether this computer has light sensors and keyboard backlight. */
 static unsigned int applesmc_light;
 
+/* The number of fans handled by the driver */
+static unsigned int fans_handled;
+
 /* Indicates which temperature sensors set to use. */
 static unsigned int applesmc_temperature_set;
 
@@ -1530,39 +1533,24 @@ static int __init applesmc_init(void)
 
 	/* create fan files */
 	count = applesmc_get_fan_count();
-	if (count < 0) {
+	if (count < 0)
 		printk(KERN_ERR "applesmc: Cannot get the number of fans.\n");
-	} else {
+	else
 		printk(KERN_INFO "applesmc: %d fans found.\n", count);
 
-		switch (count) {
-		default:
-			printk(KERN_WARNING "applesmc: More than 4 fans found,"
-					" but at most 4 fans are supported"
-						" by the driver.\n");
-		case 4:
-			ret = sysfs_create_group(&pdev->dev.kobj,
-						 &fan_attribute_groups[3]);
-			if (ret)
-				goto out_key_enumeration;
-		case 3:
-			ret = sysfs_create_group(&pdev->dev.kobj,
-						 &fan_attribute_groups[2]);
-			if (ret)
-				goto out_key_enumeration;
-		case 2:
-			ret = sysfs_create_group(&pdev->dev.kobj,
-						 &fan_attribute_groups[1]);
-			if (ret)
-				goto out_key_enumeration;
-		case 1:
-			ret = sysfs_create_group(&pdev->dev.kobj,
-						 &fan_attribute_groups[0]);
-			if (ret)
-				goto out_fan_1;
-		case 0:
-			;
-		}
+	if (count > 4) {
+		count = 4;
+		printk(KERN_WARNING "applesmc: More than 4 fans found,"
+		       " but at most 4 fans are supported"
+		       " by the driver.\n");
+	}
+
+	while (fans_handled < count) {
+		ret = sysfs_create_group(&pdev->dev.kobj,
+					 &fan_attribute_groups[fans_handled]);
+		if (ret)
+			goto out_fans;
+		fans_handled++;
 	}
 
 	for (i = 0;
@@ -1631,10 +1619,10 @@ out_accelerometer:
 		applesmc_release_accelerometer();
 out_temperature:
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
-	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
-out_fan_1:
-	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
-out_key_enumeration:
+out_fans:
+	while (fans_handled)
+		sysfs_remove_group(&pdev->dev.kobj,
+				   &fan_attribute_groups[--fans_handled]);
 	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 out_name:
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
@@ -1660,8 +1648,9 @@ static void __exit applesmc_exit(void)
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
-	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
-	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
+	while (fans_handled)
+		sysfs_remove_group(&pdev->dev.kobj,
+				   &fan_attribute_groups[--fans_handled]);
 	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
 	platform_device_unregister(pdev);
-- 
1.6.3.3

