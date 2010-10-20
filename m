Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab0JTG6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:58:22 -0400
Received: from mail.perches.com ([173.55.12.10]:3199 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292Ab0JTGwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:06 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/32] drivers/hwmon/applesmc.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:28 -0700
Message-Id: <e12d6edddfdcf543308dd81dfb6b7672f578bfb5.1287556801.git.joe@perches.com>
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

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/applesmc.c |   60 ++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b6598aa..d7a5b75 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -26,6 +26,8 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
@@ -247,8 +249,7 @@ static int __wait_status(u8 val)
 		}
 	}
 
-	printk(KERN_WARNING "applesmc: wait status failed: %x != %x\n",
-						val, inb(APPLESMC_CMD_PORT));
+	pr_warn("wait status failed: %x != %x\n", val, inb(APPLESMC_CMD_PORT));
 
 	return -EIO;
 }
@@ -267,8 +268,7 @@ static int send_command(u8 cmd)
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
 			return 0;
 	}
-	printk(KERN_WARNING "applesmc: command failed: %x -> %x\n",
-		cmd, inb(APPLESMC_CMD_PORT));
+	pr_warn("command failed: %x -> %x\n", cmd, inb(APPLESMC_CMD_PORT));
 	return -EIO;
 }
 
@@ -282,8 +282,8 @@ static int applesmc_read_key(const char* key, u8* buffer, u8 len)
 	int i;
 
 	if (len > APPLESMC_MAX_DATA_LENGTH) {
-		printk(KERN_ERR	"applesmc_read_key: cannot read more than "
-					"%d bytes\n", APPLESMC_MAX_DATA_LENGTH);
+		pr_err("%s(): cannot read more than %d bytes\n",
+		       __func__, APPLESMC_MAX_DATA_LENGTH);
 		return -EINVAL;
 	}
 
@@ -325,8 +325,8 @@ static int applesmc_write_key(const char* key, u8* buffer, u8 len)
 	int i;
 
 	if (len > APPLESMC_MAX_DATA_LENGTH) {
-		printk(KERN_ERR	"applesmc_write_key: cannot write more than "
-					"%d bytes\n", APPLESMC_MAX_DATA_LENGTH);
+		pr_err("%s(): cannot write more than %d bytes\n",
+		       __func__, APPLESMC_MAX_DATA_LENGTH);
 		return -EINVAL;
 	}
 
@@ -482,7 +482,7 @@ static int applesmc_device_init(void)
 		msleep(INIT_WAIT_MSECS);
 	}
 
-	printk(KERN_WARNING "applesmc: failed to init the device\n");
+	pr_warn("failed to init the device\n");
 
 out:
 	mutex_unlock(&applesmc_lock);
@@ -518,7 +518,7 @@ static int applesmc_probe(struct platform_device *dev)
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "applesmc: device successfully initialized.\n");
+	pr_info("device successfully initialized\n");
 	return 0;
 }
 
@@ -636,8 +636,7 @@ static ssize_t applesmc_light_show(struct device *dev,
 		if (ret)
 			goto out;
 		data_length = clamp_val(query[0], 0, 10);
-		printk(KERN_INFO "applesmc: light sensor data length set to "
-			"%d\n", data_length);
+		pr_info("light sensor data length set to %d\n", data_length);
 	}
 
 	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, data_length);
@@ -1403,18 +1402,18 @@ static int applesmc_dmi_match(const struct dmi_system_id *id)
 {
 	int i = 0;
 	struct dmi_match_data* dmi_data = id->driver_data;
-	printk(KERN_INFO "applesmc: %s detected:\n", id->ident);
+	pr_info("%s detected:\n", id->ident);
 	applesmc_accelerometer = dmi_data->accelerometer;
-	printk(KERN_INFO "applesmc:  - Model %s accelerometer\n",
-				applesmc_accelerometer ? "with" : "without");
+	pr_info(" - Model %s accelerometer\n",
+		applesmc_accelerometer ? "with" : "without");
 	applesmc_light = dmi_data->light;
-	printk(KERN_INFO "applesmc:  - Model %s light sensors and backlight\n",
-					applesmc_light ? "with" : "without");
+	pr_info(" - Model %s light sensors and backlight\n",
+		applesmc_light ? "with" : "without");
 
 	applesmc_temperature_set =  dmi_data->temperature_set;
 	while (temperature_sensors_sets[applesmc_temperature_set][i] != NULL)
 		i++;
-	printk(KERN_INFO "applesmc:  - Model with %d temperature sensors\n", i);
+	pr_info(" - Model with %d temperature sensors\n", i);
 	return 1;
 }
 
@@ -1465,7 +1464,7 @@ out_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
 
 out:
-	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	pr_warn("driver init failed (ret=%d)!\n", ret);
 	return ret;
 }
 
@@ -1639,7 +1638,7 @@ static int __init applesmc_init(void)
 	int i;
 
 	if (!dmi_check_system(applesmc_whitelist)) {
-		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
+		pr_warn("supported laptop not found!\n");
 		ret = -ENODEV;
 		goto out;
 	}
@@ -1673,15 +1672,13 @@ static int __init applesmc_init(void)
 	/* create fan files */
 	count = applesmc_get_fan_count();
 	if (count < 0)
-		printk(KERN_ERR "applesmc: Cannot get the number of fans.\n");
+		pr_err("Cannot get the number of fans\n");
 	else
-		printk(KERN_INFO "applesmc: %d fans found.\n", count);
+		pr_info("%d fans found\n", count);
 
 	if (count > 4) {
 		count = 4;
-		printk(KERN_WARNING "applesmc: More than 4 fans found,"
-		       " but at most 4 fans are supported"
-		       " by the driver.\n");
+		pr_warn("A maximum of 4 fans are supported by this driver\n");
 	}
 
 	while (fans_handled < count) {
@@ -1697,11 +1694,8 @@ static int __init applesmc_init(void)
 	     i++) {
 		if (temperature_attributes[i] == NULL ||
 		    label_attributes[i] == NULL) {
-			printk(KERN_ERR "applesmc: More temperature sensors "
-				"in temperature_sensors_sets (at least %i)"
-				"than available sysfs files in "
-				"temperature_attributes (%i), please report "
-				"this bug.\n", i, i-1);
+			pr_err("More temperature sensors in temperature_sensors_sets (at least %i) than available sysfs files in temperature_attributes (%i), please report this bug\n",
+			       i, i-1);
 			goto out_temperature;
 		}
 		ret = sysfs_create_file(&pdev->dev.kobj,
@@ -1745,7 +1739,7 @@ static int __init applesmc_init(void)
 		goto out_light_ledclass;
 	}
 
-	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
+	pr_info("driver successfully loaded\n");
 
 	return 0;
 
@@ -1778,7 +1772,7 @@ out_driver:
 out_region:
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
 out:
-	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	pr_warn("driver init failed (ret=%d)!\n", ret);
 	return ret;
 }
 
@@ -1803,7 +1797,7 @@ static void __exit applesmc_exit(void)
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
 
-	printk(KERN_INFO "applesmc: driver unloaded.\n");
+	pr_info("driver unloaded\n");
 }
 
 module_init(applesmc_init);
-- 
1.7.3.1.g432b3.dirty

