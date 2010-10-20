Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0JTGwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:09 -0400
Received: from mail.perches.com ([173.55.12.10]:3199 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247Ab0JTGwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:05 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/32] drivers/hwmon/abituguru3.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:26 -0700
Message-Id: <b613356834d854a5abb68637981c3c72d6e96822.1287556801.git.joe@perches.com>
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
 drivers/hwmon/abituguru3.c |   45 ++++++++++++++++++-------------------------
 1 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index 3cf28af..48d21e2 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -23,6 +23,9 @@
     chip found on newer Abit uGuru motherboards. Note: because of lack of specs
     only reading the sensors and their settings is supported.
 */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -608,6 +611,9 @@ static int verbose = 1;
 module_param(verbose, bool, 0644);
 MODULE_PARM_DESC(verbose, "Enable/disable verbose error reporting");
 
+static const char *never_happen = "This should never happen.";
+static const char *report_this =
+	"Please report this to the abituguru3 maintainer (see MAINTAINERS)";
 
 /* wait while the uguru is busy (usually after a write) */
 static int abituguru3_wait_while_busy(struct abituguru3_data *data)
@@ -940,15 +946,13 @@ static int __devinit abituguru3_probe(struct platform_device *pdev)
 		if (abituguru3_motherboards[i].id == id)
 			break;
 	if (!abituguru3_motherboards[i].id) {
-		printk(KERN_ERR ABIT_UGURU3_NAME ": error unknown motherboard "
-			"ID: %04X. Please report this to the abituguru3 "
-			"maintainer (see MAINTAINERS)\n", (unsigned int)id);
+		pr_err("error unknown motherboard ID: %04X. %s\n",
+		       (unsigned int)id, report_this);
 		goto abituguru3_probe_error;
 	}
 	data->sensors = abituguru3_motherboards[i].sensors;
 
-	printk(KERN_INFO ABIT_UGURU3_NAME ": found Abit uGuru3, motherboard "
-		"ID: %04X\n", (unsigned int)id);
+	pr_info("found Abit uGuru3, motherboard ID: %04X\n", (unsigned int)id);
 
 	/* Fill the sysfs attr array */
 	sysfs_attr_i = 0;
@@ -957,11 +961,8 @@ static int __devinit abituguru3_probe(struct platform_device *pdev)
 	for (i = 0; data->sensors[i].name; i++) {
 		/* Fail safe check, this should never happen! */
 		if (i >= ABIT_UGURU3_MAX_NO_SENSORS) {
-			printk(KERN_ERR ABIT_UGURU3_NAME
-				": Fatal error motherboard has more sensors "
-				"then ABIT_UGURU3_MAX_NO_SENSORS. This should "
-				"never happen please report to the abituguru3 "
-				"maintainer (see MAINTAINERS)\n");
+			pr_err("Fatal error motherboard has more sensors then ABIT_UGURU3_MAX_NO_SENSORS. %s %s\n",
+			       never_happen, report_this);
 			res = -ENAMETOOLONG;
 			goto abituguru3_probe_error;
 		}
@@ -983,10 +984,8 @@ static int __devinit abituguru3_probe(struct platform_device *pdev)
 	}
 	/* Fail safe check, this should never happen! */
 	if (sysfs_names_free < 0) {
-		printk(KERN_ERR ABIT_UGURU3_NAME
-			": Fatal error ran out of space for sysfs attr names. "
-			"This should never happen please report to the "
-			"abituguru3 maintainer (see MAINTAINERS)\n");
+		pr_err("Fatal error ran out of space for sysfs attr names. %s %s\n",
+		       never_happen, report_this);
 		res = -ENAMETOOLONG;
 		goto abituguru3_probe_error;
 	}
@@ -1189,8 +1188,7 @@ static int __init abituguru3_detect(void)
 		"0x%02X\n", (unsigned int)data_val, (unsigned int)cmd_val);
 
 	if (force) {
-		printk(KERN_INFO ABIT_UGURU3_NAME ": Assuming Abit uGuru3 is "
-				"present because of \"force\" parameter\n");
+		pr_info("Assuming Abit uGuru3 is present because of \"force\" parameter\n");
 		return 0;
 	}
 
@@ -1219,10 +1217,8 @@ static int __init abituguru3_init(void)
 			return err;
 
 #ifdef CONFIG_DMI
-		printk(KERN_WARNING ABIT_UGURU3_NAME ": this motherboard was "
-			"not detected using DMI. Please send the output of "
-			"\"dmidecode\" to the abituguru3 maintainer "
-			"(see MAINTAINERS)\n");
+		pr_warn("this motherboard was not detected using DMI. "
+			"Please send the output of \"dmidecode\" to the abituguru3 maintainer (see MAINTAINERS)\n");
 #endif
 	}
 
@@ -1233,8 +1229,7 @@ static int __init abituguru3_init(void)
 	abituguru3_pdev = platform_device_alloc(ABIT_UGURU3_NAME,
 						ABIT_UGURU3_BASE);
 	if (!abituguru3_pdev) {
-		printk(KERN_ERR ABIT_UGURU3_NAME
-			": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		err = -ENOMEM;
 		goto exit_driver_unregister;
 	}
@@ -1245,15 +1240,13 @@ static int __init abituguru3_init(void)
 
 	err = platform_device_add_resources(abituguru3_pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR ABIT_UGURU3_NAME
-			": Device resource addition failed (%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(abituguru3_pdev);
 	if (err) {
-		printk(KERN_ERR ABIT_UGURU3_NAME
-			": Device addition failed (%d)\n", err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
-- 
1.7.3.1.g432b3.dirty

