Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0KIPQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:16:44 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:53684 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab0KIPQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:16:43 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 03/11] drivers/hwmon/applesmc.c: Use pr_fmt and pr_<level>
Date: Tue,  9 Nov 2010 16:15:03 +0100
Message-Id: <1289315711-3011-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpvv-0001F5-45.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpvv-0001F5-45 e3f71800a15c61dc120e40423db8d5d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Added #define pr_fmt KBUILD_MODNAME ": " fmt
Converted printks to pr_<level>
Coalesced any long formats
Removed prefixes from formats

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   58 ++++++++++++++++++++-------------------------
 1 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 87a5fd5..5f67e39 100644
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
@@ -251,8 +253,7 @@ static int __wait_status(u8 val)
 		}
 	}
 
-	printk(KERN_WARNING "applesmc: wait status failed: %x != %x\n",
-						val, inb(APPLESMC_CMD_PORT));
+	pr_warn("wait status failed: %x != %x\n", val, inb(APPLESMC_CMD_PORT));
 
 	return -EIO;
 }
@@ -271,8 +272,7 @@ static int send_command(u8 cmd)
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
 			return 0;
 	}
-	printk(KERN_WARNING "applesmc: command failed: %x -> %x\n",
-		cmd, inb(APPLESMC_CMD_PORT));
+	pr_warn("command failed: %x -> %x\n", cmd, inb(APPLESMC_CMD_PORT));
 	return -EIO;
 }
 
@@ -286,8 +286,8 @@ static int applesmc_read_key(const char* key, u8* buffer, u8 len)
 	int i;
 
 	if (len > APPLESMC_MAX_DATA_LENGTH) {
-		printk(KERN_ERR	"applesmc_read_key: cannot read more than "
-					"%d bytes\n", APPLESMC_MAX_DATA_LENGTH);
+		pr_err("%s(): cannot read more than %d bytes\n",
+		       __func__, APPLESMC_MAX_DATA_LENGTH);
 		return -EINVAL;
 	}
 
@@ -329,8 +329,8 @@ static int applesmc_write_key(const char* key, u8* buffer, u8 len)
 	int i;
 
 	if (len > APPLESMC_MAX_DATA_LENGTH) {
-		printk(KERN_ERR	"applesmc_write_key: cannot write more than "
-					"%d bytes\n", APPLESMC_MAX_DATA_LENGTH);
+		pr_err("%s(): cannot write more than %d bytes\n",
+		       __func__, APPLESMC_MAX_DATA_LENGTH);
 		return -EINVAL;
 	}
 
@@ -470,7 +470,7 @@ static void applesmc_device_init(void)
 		msleep(INIT_WAIT_MSECS);
 	}
 
-	printk(KERN_WARNING "applesmc: failed to init the device\n");
+	pr_warn("failed to init the device\n");
 
 out:
 	mutex_unlock(&applesmc_lock);
@@ -616,8 +616,7 @@ static ssize_t applesmc_light_show(struct device *dev,
 		if (ret)
 			goto out;
 		data_length = clamp_val(query[0], 0, 10);
-		printk(KERN_INFO "applesmc: light sensor data length set to "
-			"%d\n", data_length);
+		pr_info("light sensor data length set to %d\n", data_length);
 	}
 
 	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, data_length);
@@ -1383,18 +1382,18 @@ static int applesmc_dmi_match(const struct dmi_system_id *id)
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
 
@@ -1445,7 +1444,7 @@ out_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
 
 out:
-	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	pr_warn("driver init failed (ret=%d)!\n", ret);
 	return ret;
 }
 
@@ -1625,7 +1624,7 @@ static int __init applesmc_init(void)
 	int i;
 
 	if (!dmi_check_system(applesmc_whitelist)) {
-		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
+		pr_warn("supported laptop not found!\n");
 		ret = -ENODEV;
 		goto out;
 	}
@@ -1659,15 +1658,13 @@ static int __init applesmc_init(void)
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
@@ -1683,11 +1680,8 @@ static int __init applesmc_init(void)
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
@@ -1731,7 +1725,7 @@ static int __init applesmc_init(void)
 		goto out_light_ledclass;
 	}
 
-	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
+	pr_info("driver successfully loaded\n");
 
 	return 0;
 
@@ -1764,7 +1758,7 @@ out_driver:
 out_region:
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
 out:
-	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	pr_warn("driver init failed (ret=%d)!\n", ret);
 	return ret;
 }
 
@@ -1789,7 +1783,7 @@ static void __exit applesmc_exit(void)
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
 
-	printk(KERN_INFO "applesmc: driver unloaded.\n");
+	pr_info("driver unloaded\n");
 }
 
 module_init(applesmc_init);
-- 
1.7.1

