Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab0JTGwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:08 -0400
Received: from mail.perches.com ([173.55.12.10]:3191 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138Ab0JTGwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:05 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/32] drivers/hwmon/abituguru.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:25 -0700
Message-Id: <26de47ba1bd7356e5b4c2490a3377bc2860007a4.1287556801.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <20101020035346.GA20178@ericsson.com>
References: <20101020035346.GA20178@ericsson.com>
In-Reply-To: <cover.1287556800.git.joe@perches.com>
References: <cover.1287556800.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt KBUILD_MODNAME ": " fmt
Converted printks to pr_<level>
Coalesced any long formats
Removed prefixes from formats
Added a few static strings to standardize logging messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/abituguru.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 03694cc..8f07a9d 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -20,6 +20,9 @@
     the custom Abit uGuru chip found on Abit uGuru motherboards. Note: because
     of lack of specs the CPU/RAM voltage & frequency control is not supported!
 */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init.h>
@@ -220,6 +223,10 @@ struct abituguru_data {
 	u8 pwm_settings[ABIT_UGURU_MAX_PWMS][5];
 };
 
+static const char *never_happen = "This should never happen.";
+static const char *report_this =
+	"Please report this to the abituguru maintainer (see MAINTAINERS)";
+
 /* wait till the uguru is in the specified state */
 static int abituguru_wait(struct abituguru_data *data, u8 state)
 {
@@ -438,8 +445,7 @@ abituguru_detect_bank1_sensor_type(struct abituguru_data *data,
 
 	/* Test val is sane / usable for sensor type detection. */
 	if ((val < 10u) || (val > 250u)) {
-		printk(KERN_WARNING ABIT_UGURU_NAME
-			": bank1-sensor: %d reading (%d) too close to limits, "
+		pr_warn("bank1-sensor: %d reading (%d) too close to limits, "
 			"unable to determine sensor type, skipping sensor\n",
 			(int)sensor_addr, (int)val);
 		/* assume no sensor is there for sensors for which we can't
@@ -535,10 +541,8 @@ abituguru_detect_bank1_sensor_type_exit:
 				3) == 3)
 			break;
 	if (i == 3) {
-		printk(KERN_ERR ABIT_UGURU_NAME
-			": Fatal error could not restore original settings. "
-			"This should never happen please report this to the "
-			"abituguru maintainer (see MAINTAINERS)\n");
+		pr_err("Fatal error could not restore original settings. %s %s\n",
+		       never_happen, report_this);
 		return -ENODEV;
 	}
 	return ret;
@@ -1268,14 +1272,12 @@ static int __devinit abituguru_probe(struct platform_device *pdev)
 	}
 	/* Fail safe check, this should never happen! */
 	if (sysfs_names_free < 0) {
-		printk(KERN_ERR ABIT_UGURU_NAME ": Fatal error ran out of "
-		       "space for sysfs attr names. This should never "
-		       "happen please report to the abituguru maintainer "
-		       "(see MAINTAINERS)\n");
+		pr_err("Fatal error ran out of space for sysfs attr names. %s %s",
+		       never_happen, report_this);
 		res = -ENAMETOOLONG;
 		goto abituguru_probe_error;
 	}
-	printk(KERN_INFO ABIT_UGURU_NAME ": found Abit uGuru\n");
+	pr_info("found Abit uGuru\n");
 
 	/* Register sysfs hooks */
 	for (i = 0; i < sysfs_attr_i; i++)
@@ -1432,8 +1434,7 @@ static int __init abituguru_detect(void)
 		"0x%02X\n", (unsigned int)data_val, (unsigned int)cmd_val);
 
 	if (force) {
-		printk(KERN_INFO ABIT_UGURU_NAME ": Assuming Abit uGuru is "
-				"present because of \"force\" parameter\n");
+		pr_info("Assuming Abit uGuru is present because of \"force\" parameter\n");
 		return ABIT_UGURU_BASE;
 	}
 
@@ -1467,8 +1468,7 @@ static int __init abituguru_init(void)
 
 	abituguru_pdev = platform_device_alloc(ABIT_UGURU_NAME, address);
 	if (!abituguru_pdev) {
-		printk(KERN_ERR ABIT_UGURU_NAME
-			": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		err = -ENOMEM;
 		goto exit_driver_unregister;
 	}
@@ -1479,15 +1479,13 @@ static int __init abituguru_init(void)
 
 	err = platform_device_add_resources(abituguru_pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR ABIT_UGURU_NAME
-			": Device resource addition failed (%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(abituguru_pdev);
 	if (err) {
-		printk(KERN_ERR ABIT_UGURU_NAME
-			": Device addition failed (%d)\n", err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
-- 
1.7.3.1.g432b3.dirty

