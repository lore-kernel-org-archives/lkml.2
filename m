Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0JSXNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:13:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3054 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab0JSXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:13:43 -0400
Subject: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 16:13:40 -0700
Message-ID: <1287530020.10409.594.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>
Coalesce long formats
Removed prefixes from formats
Added #define pr_fmt KBUILD_MODNAME ": " fmt
Standardized abitguru messages for reporting and finding MAINTAINER

Compiled x86 allyesconfig only.
I inspected "strings drivers/hwmon/built-in.o",
but it's otherwise untested.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/abituguru.c    |   36 ++++++++++++-------------
 drivers/hwmon/abituguru3.c   |   45 +++++++++++++------------------
 drivers/hwmon/adt7470.c      |    4 ++-
 drivers/hwmon/applesmc.c     |   60 +++++++++++++++++++-----------------------
 drivers/hwmon/asb100.c       |    9 +++---
 drivers/hwmon/asus_atk0110.c |    7 +++--
 drivers/hwmon/coretemp.c     |   11 ++++---
 drivers/hwmon/dme1737.c      |   12 ++++----
 drivers/hwmon/f71805f.c      |   29 +++++++++-----------
 drivers/hwmon/f71882fg.c     |   23 ++++++++-------
 drivers/hwmon/hp_accel.c     |   13 +++++----
 drivers/hwmon/hwmon-vid.c    |   11 ++++---
 drivers/hwmon/hwmon.c        |    4 ++-
 drivers/hwmon/ibmaem.c       |    4 ++-
 drivers/hwmon/it87.c         |   30 ++++++++++-----------
 drivers/hwmon/lis3lv02d.c    |   23 +++++++--------
 drivers/hwmon/lm70.c         |    5 ++-
 drivers/hwmon/lm78.c         |   14 +++++-----
 drivers/hwmon/pc87360.c      |   32 +++++++++-------------
 drivers/hwmon/pc87427.c      |   26 +++++++++---------
 drivers/hwmon/pcf8591.c      |    5 ++-
 drivers/hwmon/pkgtemp.c      |    7 +++--
 drivers/hwmon/sis5595.c      |   10 +++---
 drivers/hwmon/smsc47b397.c   |   13 ++++-----
 drivers/hwmon/smsc47m1.c     |   31 ++++++++++-----------
 drivers/hwmon/via-cputemp.c  |   10 +++---
 drivers/hwmon/via686a.c      |   10 +++---
 drivers/hwmon/vt1211.c       |   30 +++++++++------------
 drivers/hwmon/vt8231.c       |   10 +++---
 drivers/hwmon/w83627ehf.c    |   23 +++++++---------
 drivers/hwmon/w83627hf.c     |   17 +++++------
 drivers/hwmon/w83781d.c      |   29 ++++++++++----------
 32 files changed, 285 insertions(+), 308 deletions(-)

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
 
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 9e77571..fc5da44 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
@@ -274,7 +276,7 @@ static int adt7470_read_temperatures(struct i2c_client *client,
 	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(2), pwm_cfg[1]);
 
 	if (res) {
-		printk(KERN_ERR "ha ha, interrupted");
+		pr_err("ha ha, interrupted\n");
 		return -EAGAIN;
 	}
 
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
diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index 7dada55..c02a052 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -36,6 +36,8 @@
     asb100	7	3	1	4	0x31	0x0694	yes	no
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -701,8 +703,7 @@ static int asb100_detect(struct i2c_client *client,
 	int val1, val2;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
-		pr_debug("asb100.o: detect failed, "
-				"smbus byte data not supported!\n");
+		pr_debug("detect failed, smbus byte data not supported!\n");
 		return -ENODEV;
 	}
 
@@ -715,7 +716,7 @@ static int asb100_detect(struct i2c_client *client,
 			(((!(val1 & 0x80)) && (val2 != 0x94)) ||
 			/* Check for ASB100 ID (high byte ) */
 			((val1 & 0x80) && (val2 != 0x06)))) {
-		pr_debug("asb100: detect failed, bad chip id 0x%02x!\n", val2);
+		pr_debug("detect failed, bad chip id 0x%02x!\n", val2);
 		return -ENODEV;
 	}
 
@@ -744,7 +745,7 @@ static int asb100_probe(struct i2c_client *client,
 
 	data = kzalloc(sizeof(struct asb100_data), GFP_KERNEL);
 	if (!data) {
-		pr_debug("asb100.o: probe failed, kzalloc failed!\n");
+		pr_debug("probe failed, kzalloc failed!\n");
 		err = -ENOMEM;
 		goto ERROR0;
 	}
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 23b8555..2d68cf3 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -5,6 +5,8 @@
  * See COPYING in the top level directory of the kernel tree.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/hwmon.h>
@@ -1414,14 +1416,13 @@ static int __init atk0110_init(void)
 
 	/* Make sure it's safe to access the device through ACPI */
 	if (!acpi_resources_are_enforced()) {
-		pr_err("atk: Resources not safely usable due to "
-		       "acpi_enforce_resources kernel parameter\n");
+		pr_err("Resources not safely usable due to acpi_enforce_resources kernel parameter\n");
 		return -EBUSY;
 	}
 
 	ret = acpi_bus_register_driver(&atk_driver);
 	if (ret)
-		pr_info("atk: acpi_bus_register_driver failed: %d\n", ret);
+		pr_info("acpi_bus_register_driver failed: %d\n", ret);
 
 	return ret;
 }
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 42de98d..194ca0a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -20,6 +20,8 @@
  * 02110-1301 USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -445,8 +447,8 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 	 * without thermal sensors will be filtered out.
 	 */
 	if (!cpu_has(c, X86_FEATURE_DTS)) {
-		printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
-		       " has no thermal sensor.\n", c->x86_model);
+		pr_info("CPU (model=0x%x) has no thermal sensor\n",
+			c->x86_model);
 		return 0;
 	}
 
@@ -466,7 +468,7 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -478,8 +480,7 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_free;
 	}
 
diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index 980c17d..e9a610b 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -25,6 +25,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -2446,7 +2448,7 @@ static int __init dme1737_isa_detect(int sio_cip, unsigned short *addr)
 	/* Get the base address of the runtime registers */
 	if (!(base_addr = (dme1737_sio_inb(sio_cip, 0x60) << 8) |
 			   dme1737_sio_inb(sio_cip, 0x61))) {
-		printk(KERN_ERR "dme1737: Base address not set.\n");
+		pr_err("Base address not set\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -2475,20 +2477,18 @@ static int __init dme1737_isa_device_add(unsigned short addr)
 		goto exit;
 
 	if (!(pdev = platform_device_alloc("dme1737", addr))) {
-		printk(KERN_ERR "dme1737: Failed to allocate device.\n");
+		pr_err("Failed to allocate device\n");
 		err = -ENOMEM;
 		goto exit;
 	}
 
 	if ((err = platform_device_add_resources(pdev, &res, 1))) {
-		printk(KERN_ERR "dme1737: Failed to add device resource "
-		       "(err = %d).\n", err);
+		pr_err("Failed to add device resource (err = %d)\n", err);
 		goto exit_device_put;
 	}
 
 	if ((err = platform_device_add(pdev))) {
-		printk(KERN_ERR "dme1737: Failed to add device (err = %d).\n",
-		       err);
+		pr_err("Failed to add device (err = %d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 525a00b..92f9497 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -28,6 +28,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1309,7 +1311,7 @@ static int __devinit f71805f_probe(struct platform_device *pdev)
 
 	if (!(data = kzalloc(sizeof(struct f71805f_data), GFP_KERNEL))) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Out of memory\n");
+		pr_err("Out of memory\n");
 		goto exit;
 	}
 
@@ -1451,7 +1453,7 @@ static int __init f71805f_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -1462,22 +1464,20 @@ static int __init f71805f_device_add(unsigned short address,
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct f71805f_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
@@ -1516,30 +1516,27 @@ static int __init f71805f_find(int sioaddr, unsigned short *address,
 		sio_data->fnsel1 = superio_inb(sioaddr, SIO_REG_FNSEL1);
 		break;
 	default:
-		printk(KERN_INFO DRVNAME ": Unsupported Fintek device, "
-		       "skipping\n");
+		pr_info("Unsupported Fintek device, skipping\n");
 		goto exit;
 	}
 
 	superio_select(sioaddr, F71805F_LD_HWM);
 	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Device not activated, "
-		       "skipping\n");
+		pr_warn("Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(sioaddr, SIO_REG_ADDR);
 	if (*address == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address not set, "
-		       "skipping\n");
+		pr_warn("Base address not set, skipping\n");
 		goto exit;
 	}
 	*address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
 	err = 0;
-	printk(KERN_INFO DRVNAME ": Found %s chip at %#x, revision %u\n",
-	       names[sio_data->kind], *address,
-	       superio_inb(sioaddr, SIO_REG_DEVREV));
+	pr_info("Found %s chip at %#x, revision %u\n",
+		names[sio_data->kind], *address,
+		superio_inb(sioaddr, SIO_REG_DEVREV));
 
 exit:
 	superio_exit(sioaddr);
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 75afb3b..3f49dd3 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -18,6 +18,8 @@
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -865,8 +867,7 @@ static inline int superio_enter(int base)
 {
 	/* Don't step on other drivers' I/O space by accident */
 	if (!request_muxed_region(base, 2, DRVNAME)) {
-		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
-				base);
+		pr_err("I/O address 0x%04x already in use\n", base);
 		return -EBUSY;
 	}
 
@@ -2192,7 +2193,7 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
 
 	devid = superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid != SIO_FINTEK_ID) {
-		pr_debug(DRVNAME ": Not a Fintek device\n");
+		pr_debug("Not a Fintek device\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -2215,8 +2216,8 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
 		sio_data->type = f8000;
 		break;
 	default:
-		printk(KERN_INFO DRVNAME ": Unsupported Fintek device: %04x\n",
-		       (unsigned int)devid);
+		pr_info("Unsupported Fintek device: %04x\n",
+			(unsigned int)devid);
 		err = -ENODEV;
 		goto exit;
 	}
@@ -2227,21 +2228,21 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
 		superio_select(sioaddr, SIO_F71882FG_LD_HWM);
 
 	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Device not activated\n");
+		pr_warn("Device not activated\n");
 		err = -ENODEV;
 		goto exit;
 	}
 
 	*address = superio_inw(sioaddr, SIO_REG_ADDR);
 	if (*address == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address not set\n");
+		pr_warn("Base address not set\n");
 		err = -ENODEV;
 		goto exit;
 	}
 	*address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
 	err = 0;
-	printk(KERN_INFO DRVNAME ": Found %s chip at %#x, revision %d\n",
+	pr_info("Found %s chip at %#x, revision %d\n",
 		f71882fg_names[sio_data->type],	(unsigned int)*address,
 		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
 exit:
@@ -2270,20 +2271,20 @@ static int __init f71882fg_device_add(unsigned short address,
 
 	err = platform_device_add_resources(f71882fg_pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed\n");
+		pr_err("Device resource addition failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(f71882fg_pdev, sio_data,
 				       sizeof(struct f71882fg_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(f71882fg_pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed\n");
+		pr_err("Device addition failed\n");
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index a56a784..3d21fa2 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -147,7 +149,7 @@ int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
 {
 	lis3_dev.ac = *((union axis_conversion *)dmi->driver_data);
-	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
+	pr_info("hardware type %s found\n", dmi->ident);
 
 	return 1;
 }
@@ -303,11 +305,10 @@ static int lis3lv02d_add(struct acpi_device *device)
 
 	/* If possible use a "standard" axes order */
 	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
-		printk(KERN_INFO DRIVER_NAME ": Using custom axes %d,%d,%d\n",
-		       lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
+		pr_info("Using custom axes %d,%d,%d\n",
+			lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
 	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
-		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
-				 "using default axes configuration\n");
+		pr_info("laptop model unknown, using default axes configuration\n");
 		lis3_dev.ac = lis3lv02d_axis_normal;
 	}
 
@@ -385,7 +386,7 @@ static int __init lis3lv02d_init_module(void)
 	if (ret < 0)
 		return ret;
 
-	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
+	pr_info("driver loaded\n");
 
 	return 0;
 }
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index bf0862a..5328ad5 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -22,6 +22,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/hwmon-vid.h>
@@ -146,8 +148,8 @@ int vid_from_reg(int val, u8 vrm)
 		return(val > 0x77 ? 0 : (1500000 - (val * 12500) + 500) / 1000);
 	default:		/* report 0 for unknown */
 		if (vrm)
-			printk(KERN_WARNING "hwmon-vid: Requested unsupported "
-			       "VRM version (%u)\n", (unsigned int)vrm);
+			pr_warn("Requested unsupported VRM version (%u)\n",
+				(unsigned int)vrm);
 		return 0;
 	}
 }
@@ -246,8 +248,7 @@ u8 vid_which_vrm(void)
 	}
 	vrm_ret = find_vrm(eff_family, eff_model, eff_stepping, c->x86_vendor);
 	if (vrm_ret == 0)
-		printk(KERN_INFO "hwmon-vid: Unknown VRM version of your "
-		       "x86 CPU\n");
+		pr_info("Unknown VRM version of your x86 CPU\n");
 	return vrm_ret;
 }
 
@@ -255,7 +256,7 @@ u8 vid_which_vrm(void)
 #else
 u8 vid_which_vrm(void)
 {
-	printk(KERN_INFO "hwmon-vid: Unknown VRM version of your CPU\n");
+	pr_info("Unknown VRM version of your CPU\n");
 	return 0;
 }
 #endif
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 29ea675..a61e781 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -10,6 +10,8 @@
     the Free Software Foundation; version 2 of the License.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -119,7 +121,7 @@ static int __init hwmon_init(void)
 
 	hwmon_class = class_create(THIS_MODULE, "hwmon");
 	if (IS_ERR(hwmon_class)) {
-		printk(KERN_ERR "hwmon.c: couldn't create sysfs class\n");
+		pr_err("couldn't create sysfs class\n");
 		return PTR_ERR(hwmon_class);
 	}
 	return 0;
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index eaee546..bc6e2ab 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -20,6 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/ipmi.h>
 #include <linux/module.h>
 #include <linux/hwmon.h>
@@ -1090,7 +1092,7 @@ static int __init aem_init(void)
 
 	res = driver_register(&aem_driver.driver);
 	if (res) {
-		printk(KERN_ERR "Can't register aem driver\n");
+		pr_err("Can't register aem driver\n");
 		return res;
 	}
 
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index f770129..3d3da59 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -36,6 +36,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1493,26 +1495,25 @@ static int __init it87_find(unsigned short *address,
 	case 0xffff:	/* No device at all */
 		goto exit;
 	default:
-		pr_debug(DRVNAME ": Unsupported chip (DEVID=0x%x)\n",
-			 chip_type);
+		pr_debug("Unsupported chip (DEVID=0x%x)\n", chip_type);
 		goto exit;
 	}
 
 	superio_select(PME);
 	if (!(superio_inb(IT87_ACT_REG) & 0x01)) {
-		pr_info("it87: Device not activated, skipping\n");
+		pr_info("Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(IT87_BASE_REG) & ~(IT87_EXTENT - 1);
 	if (*address == 0) {
-		pr_info("it87: Base address not set, skipping\n");
+		pr_info("Base address not set, skipping\n");
 		goto exit;
 	}
 
 	err = 0;
 	sio_data->revision = superio_inb(DEVREV) & 0x0f;
-	pr_info("it87: Found IT%04xF chip at 0x%x, revision %d\n",
+	pr_info("Found IT%04xF chip at 0x%x, revision %d\n",
 		chip_type, *address, sio_data->revision);
 
 	/* in8 (Vbat) is always internal */
@@ -1533,7 +1534,7 @@ static int __init it87_find(unsigned short *address,
 		/* We need at least 4 VID pins */
 		reg = superio_inb(IT87_SIO_GPIO3_REG);
 		if (reg & 0x0f) {
-			pr_info("it87: VID is disabled (pins used for GPIO)\n");
+			pr_info("VID is disabled (pins used for GPIO)\n");
 			sio_data->skip_vid = 1;
 		}
 
@@ -1568,7 +1569,7 @@ static int __init it87_find(unsigned short *address,
 		if (sio_data->type == it8720 && !(reg & (1 << 1))) {
 			reg |= (1 << 1);
 			superio_outb(IT87_SIO_PINX2_REG, reg);
-			pr_notice("it87: Routing internal VCCH to in7\n");
+			pr_notice("Routing internal VCCH to in7\n");
 		}
 		if (reg & (1 << 0))
 			sio_data->internal |= (1 << 0);
@@ -1578,7 +1579,7 @@ static int __init it87_find(unsigned short *address,
 		sio_data->beep_pin = superio_inb(IT87_SIO_BEEP_PIN_REG) & 0x3f;
 	}
 	if (sio_data->beep_pin)
-		pr_info("it87: Beeping is supported\n");
+		pr_info("Beeping is supported\n");
 
 	/* Disable specific features based on DMI strings */
 	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
@@ -1592,8 +1593,7 @@ static int __init it87_find(unsigned short *address,
 			   the PWM2 duty cycle, so we disable it.
 			   I use the board name string as the trigger in case
 			   the same board is ever used in other systems. */
-			pr_info("it87: Disabling pwm2 due to "
-				"hardware constraints\n");
+			pr_info("Disabling pwm2 due to hardware constraints\n");
 			sio_data->skip_pwm = (1 << 1);
 		}
 	}
@@ -2086,28 +2086,26 @@ static int __init it87_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct it87_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 25f3850..fcedcae 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -673,8 +675,7 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 					IRQF_ONESHOT,
 					DRIVER_NAME, &lis3_dev);
 		if (err < 0)
-			printk(KERN_ERR DRIVER_NAME
-				"No second IRQ. Limited functionality\n");
+			pr_err("No second IRQ. Limited functionality\n");
 	}
 }
 
@@ -691,7 +692,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	switch (dev->whoami) {
 	case WAI_12B:
-		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
+		pr_info("12 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
@@ -700,7 +701,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->scale = LIS3_SENSITIVITY_12B;
 		break;
 	case WAI_8B:
-		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
+		pr_info("8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
@@ -709,7 +710,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->scale = LIS3_SENSITIVITY_8B;
 		break;
 	case WAI_3DC:
-		printk(KERN_INFO DRIVER_NAME ": 8 bits 3DC sensor found\n");
+		pr_info("8 bits 3DC sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
@@ -718,8 +719,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->scale = LIS3_SENSITIVITY_8B;
 		break;
 	default:
-		printk(KERN_ERR DRIVER_NAME
-			": unknown sensor type 0x%X\n", dev->whoami);
+		pr_err("unknown sensor type 0x%X\n", dev->whoami);
 		return -EINVAL;
 	}
 
@@ -729,7 +729,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	lis3lv02d_poweron(dev);
 
 	if (lis3lv02d_joystick_enable())
-		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
+		pr_err("joystick initialization failed\n");
 
 	/* passing in platform specific data is purely optional and only
 	 * used by the SPI transport layer at the moment */
@@ -745,8 +745,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
-		printk(KERN_ERR DRIVER_NAME
-			": No IRQ. Disabling /dev/freefall\n");
+		pr_err("No IRQ. Disabling /dev/freefall\n");
 		goto out;
 	}
 
@@ -772,12 +771,12 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 				DRIVER_NAME, &lis3_dev);
 
 	if (err < 0) {
-		printk(KERN_ERR DRIVER_NAME "Cannot get IRQ\n");
+		pr_err("Cannot get IRQ\n");
 		goto out;
 	}
 
 	if (misc_register(&lis3lv02d_misc_device))
-		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+		pr_err("misc_register failed\n");
 out:
 	return 0;
 }
diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index fd108cf..3b84fb5 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -67,8 +69,7 @@ static ssize_t lm70_sense_temp(struct device *dev,
 	 */
 	status = spi_write_then_read(spi, NULL, 0, &rxbuf[0], 2);
 	if (status < 0) {
-		printk(KERN_WARNING
-		"spi_write_then_read failed with status %d\n", status);
+		pr_warn("spi_write_then_read failed with status %d\n", status);
 		goto out;
 	}
 	raw = (rxbuf[0] << 8) + rxbuf[1];
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index 72ff2c4..4cb24ea 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -19,6 +19,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -858,7 +860,7 @@ static int __init lm78_isa_found(unsigned short address)
 	 * individually for the probing phase. */
 	for (port = address; port < address + LM78_EXTENT; port++) {
 		if (!request_region(port, 1, "lm78")) {
-			pr_debug("lm78: Failed to request port 0x%x\n", port);
+			pr_debug("Failed to request port 0x%x\n", port);
 			goto release;
 		}
 	}
@@ -920,7 +922,7 @@ static int __init lm78_isa_found(unsigned short address)
 		found = 1;
 
 	if (found)
-		pr_info("lm78: Found an %s chip at %#x\n",
+		pr_info("Found an %s chip at %#x\n",
 			val & 0x80 ? "LM79" : "LM78", (int)address);
 
  release:
@@ -942,21 +944,19 @@ static int __init lm78_isa_device_add(unsigned short address)
 	pdev = platform_device_alloc("lm78", address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR "lm78: Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR "lm78: Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR "lm78: Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index 68e69a4..f8459a9 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -33,6 +33,8 @@
  *  the standard Super-I/O addresses is used (0x2E/0x2F or 0x4E/0x4F).
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1031,16 +1033,15 @@ static int __init pc87360_find(int sioaddr, u8 *devid, unsigned short *addresses
 
 		val = superio_inb(sioaddr, ACT);
 		if (!(val & 0x01)) {
-			printk(KERN_INFO "pc87360: Device 0x%02x not "
-			       "activated\n", logdev[i]);
+			pr_info("Device 0x%02x not activated\n", logdev[i]);
 			continue;
 		}
 
 		val = (superio_inb(sioaddr, BASE) << 8)
 		    | superio_inb(sioaddr, BASE + 1);
 		if (!val) {
-			printk(KERN_INFO "pc87360: Base address not set for "
-			       "device 0x%02x\n", logdev[i]);
+			pr_info("Base address not set for device 0x%02x\n",
+				logdev[i]);
 			continue;
 		}
 
@@ -1071,14 +1072,11 @@ static int __init pc87360_find(int sioaddr, u8 *devid, unsigned short *addresses
 				confreg[3] = superio_inb(sioaddr, 0x25);
 
 				if (confreg[2] & 0x40) {
-					printk(KERN_INFO "pc87360: Using "
-					       "thermistors for temperature "
-					       "monitoring\n");
+					pr_info("Using thermistors for temperature monitoring\n");
 				}
 				if (confreg[3] & 0xE0) {
-					printk(KERN_INFO "pc87360: VID "
-					       "inputs routed (mode %u)\n",
-					       confreg[3] >> 5);
+					pr_info("VID inputs routed (mode %u)\n",
+						confreg[3] >> 5);
 				}
 			}
 		}
@@ -1616,7 +1614,7 @@ static int __init pc87360_device_add(unsigned short address)
 	pdev = platform_device_alloc("pc87360", address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR "pc87360: Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -1639,15 +1637,13 @@ static int __init pc87360_device_add(unsigned short address)
 
 	err = platform_device_add_resources(pdev, res, res_count);
 	if (err) {
-		printk(KERN_ERR "pc87360: Device resources addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resources addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR "pc87360: Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
@@ -1666,8 +1662,7 @@ static int __init pc87360_init(void)
 
 	if (pc87360_find(0x2e, &devid, extra_isa)
 	 && pc87360_find(0x4e, &devid, extra_isa)) {
-		printk(KERN_WARNING "pc87360: PC8736x not detected, "
-		       "module not inserted.\n");
+		pr_warn("PC8736x not detected, module not inserted\n");
 		return -ENODEV;
 	}
 
@@ -1680,8 +1675,7 @@ static int __init pc87360_init(void)
 	}
 
 	if (address == 0x0000) {
-		printk(KERN_WARNING "pc87360: No active logical device, "
-		       "module not inserted.\n");
+		pr_warn("No active logical device, module not inserted\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 9ec4daa..78c3e32 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -22,6 +22,8 @@
  *  mode, and voltages aren't supported at all.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1077,7 +1079,7 @@ static int __devinit pc87427_probe(struct platform_device *pdev)
 	data = kzalloc(sizeof(struct pc87427_data), GFP_KERNEL);
 	if (!data) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Out of memory\n");
+		pr_err("Out of memory\n");
 		goto exit;
 	}
 
@@ -1196,28 +1198,26 @@ static int __init pc87427_device_add(const struct pc87427_sio_data *sio_data)
 	pdev = platform_device_alloc(DRVNAME, res[0].start);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, res, res_count);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct pc87427_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
@@ -1249,23 +1249,23 @@ static int __init pc87427_find(int sioaddr, struct pc87427_sio_data *sio_data)
 
 		val = superio_inb(sioaddr, SIOREG_ACT);
 		if (!(val & 0x01)) {
-			printk(KERN_INFO DRVNAME ": Logical device 0x%02x "
-			       "not activated\n", logdev[i]);
+			pr_info("Logical device 0x%02x not activated\n",
+				logdev[i]);
 			continue;
 		}
 
 		val = superio_inb(sioaddr, SIOREG_MAP);
 		if (val & 0x01) {
-			printk(KERN_WARNING DRVNAME ": Logical device 0x%02x "
-			       "is memory-mapped, can't use\n", logdev[i]);
+			pr_warn("Logical device 0x%02x is memory-mapped, can't use\n",
+				logdev[i]);
 			continue;
 		}
 
 		val = (superio_inb(sioaddr, SIOREG_IOBASE) << 8)
 		    | superio_inb(sioaddr, SIOREG_IOBASE + 1);
 		if (!val) {
-			printk(KERN_INFO DRVNAME ": I/O base address not set "
-			       "for logical device 0x%02x\n", logdev[i]);
+			pr_info("I/O base address not set for logical device 0x%02x\n",
+				logdev[i]);
 			continue;
 		}
 		sio_data->address[i] = val;
diff --git a/drivers/hwmon/pcf8591.c b/drivers/hwmon/pcf8591.c
index dc7259d..731b09a 100644
--- a/drivers/hwmon/pcf8591.c
+++ b/drivers/hwmon/pcf8591.c
@@ -18,6 +18,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -290,8 +292,7 @@ static struct i2c_driver pcf8591_driver = {
 static int __init pcf8591_init(void)
 {
 	if (input_mode < 0 || input_mode > 3) {
-		printk(KERN_WARNING "pcf8591: invalid input_mode (%d)\n",
-		       input_mode);
+		pr_warn("invalid input_mode (%d)\n", input_mode);
 		input_mode = 0;
 	}
 	return i2c_add_driver(&pcf8591_driver);
diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index 0798210..21c817d 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -20,6 +20,8 @@
  * 02110-1301 USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -303,7 +305,7 @@ static int __cpuinit pkgtemp_device_add(unsigned int cpu)
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -315,8 +317,7 @@ static int __cpuinit pkgtemp_device_add(unsigned int cpu)
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_free;
 	}
 
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 79c2931..47d7ce9 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -50,6 +50,8 @@
 	 735		0008		0735
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
@@ -735,21 +737,19 @@ static int __devinit sis5595_device_add(unsigned short address)
 	pdev = platform_device_alloc("sis5595", address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR "sis5595: Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR "sis5595: Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR "sis5595: Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/smsc47b397.c b/drivers/hwmon/smsc47b397.c
index f46d936..9fb7516 100644
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -26,6 +26,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
@@ -311,21 +313,19 @@ static int __init smsc47b397_device_add(unsigned short address)
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
@@ -367,8 +367,7 @@ static int __init smsc47b397_find(unsigned short *addr)
 	*addr = (superio_inb(SUPERIO_REG_BASE_MSB) << 8)
 		 |  superio_inb(SUPERIO_REG_BASE_LSB);
 
-	printk(KERN_INFO DRVNAME ": found SMSC %s "
-		"(base address 0x%04x, revision %u)\n",
+	pr_info("found SMSC %s (base address 0x%04x, revision %u)\n",
 		name, *addr, rev);
 
 	superio_exit();
diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index 8fa462f..f44a89a 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -26,6 +26,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
@@ -435,30 +437,29 @@ static int __init smsc47m1_find(unsigned short *addr,
 	 */
 	switch (val) {
 	case 0x51:
-		pr_info(DRVNAME ": Found SMSC LPC47B27x\n");
+		pr_info("Found SMSC LPC47B27x\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x59:
-		pr_info(DRVNAME ": Found SMSC LPC47M10x/LPC47M112/LPC47M13x\n");
+		pr_info("Found SMSC LPC47M10x/LPC47M112/LPC47M13x\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x5F:
-		pr_info(DRVNAME ": Found SMSC LPC47M14x\n");
+		pr_info("Found SMSC LPC47M14x\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x60:
-		pr_info(DRVNAME ": Found SMSC LPC47M15x/LPC47M192/LPC47M997\n");
+		pr_info("Found SMSC LPC47M15x/LPC47M192/LPC47M997\n");
 		sio_data->type = smsc47m1;
 		break;
 	case 0x6B:
 		if (superio_inb(SUPERIO_REG_DEVREV) & 0x80) {
-			pr_debug(DRVNAME ": "
-				 "Found SMSC LPC47M233, unsupported\n");
+			pr_debug("Found SMSC LPC47M233, unsupported\n");
 			superio_exit();
 			return -ENODEV;
 		}
 
-		pr_info(DRVNAME ": Found SMSC LPC47M292\n");
+		pr_info("Found SMSC LPC47M292\n");
 		sio_data->type = smsc47m2;
 		break;
 	default:
@@ -470,7 +471,7 @@ static int __init smsc47m1_find(unsigned short *addr,
 	*addr = (superio_inb(SUPERIO_REG_BASE) << 8)
 	      |  superio_inb(SUPERIO_REG_BASE + 1);
 	if (*addr == 0) {
-		pr_info(DRVNAME ": Device address not set, will not use\n");
+		pr_info("Device address not set, will not use\n");
 		superio_exit();
 		return -ENODEV;
 	}
@@ -479,7 +480,7 @@ static int __init smsc47m1_find(unsigned short *addr,
 	 * Compaq Presario S4000NX) */
 	sio_data->activate = superio_inb(SUPERIO_REG_ACT);
 	if ((sio_data->activate & 0x01) == 0) {
-		pr_info(DRVNAME ": Enabling device\n");
+		pr_info("Enabling device\n");
 		superio_outb(SUPERIO_REG_ACT, sio_data->activate | 0x01);
 	}
 
@@ -494,7 +495,7 @@ static void smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
 		superio_enter();
 		superio_select();
 
-		pr_info(DRVNAME ": Disabling device\n");
+		pr_info("Disabling device\n");
 		superio_outb(SUPERIO_REG_ACT, sio_data->activate);
 
 		superio_exit();
@@ -823,28 +824,26 @@ static int __init smsc47m1_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct smsc47m1_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index ec7fad7..45b08c7 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -21,6 +21,8 @@
  * 02110-1301 USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -202,7 +204,7 @@ static int __cpuinit via_cputemp_device_add(unsigned int cpu)
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
@@ -214,8 +216,7 @@ static int __cpuinit via_cputemp_device_add(unsigned int cpu)
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_free;
 	}
 
@@ -295,8 +296,7 @@ static int __init via_cputemp_init(void)
 			continue;
 
 		if (c->x86_model > 0x0f) {
-			printk(KERN_WARNING DRVNAME ": Unknown CPU "
-				"model 0x%x\n", c->x86_model);
+			pr_warn("Unknown CPU model 0x%x\n", c->x86_model);
 			continue;
 		}
 
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index f397ce7..13e8d21 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -30,6 +30,8 @@
     Warning - only supports a single device.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -791,21 +793,19 @@ static int __devinit via686a_device_add(unsigned short address)
 	pdev = platform_device_alloc("via686a", address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR "via686a: Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR "via686a: Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR "via686a: Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index ae33bbb..77648c4 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -21,6 +21,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1254,8 +1256,7 @@ static int __init vt1211_device_add(unsigned short address)
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed (%d)\n",
-		       err);
+		pr_err("Device allocation failed (%d)\n", err);
 		goto EXIT;
 	}
 
@@ -1266,15 +1267,13 @@ static int __init vt1211_device_add(unsigned short address)
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto EXIT_DEV_PUT;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto EXIT_DEV_PUT;
 	}
 
@@ -1301,23 +1300,20 @@ static int __init vt1211_find(int sio_cip, unsigned short *address)
 	superio_select(sio_cip, SIO_VT1211_LDN_HWMON);
 
 	if ((superio_inb(sio_cip, SIO_VT1211_ACTIVE) & 1) == 0) {
-		printk(KERN_WARNING DRVNAME ": HW monitor is disabled, "
-		       "skipping\n");
+		pr_warn("HW monitor is disabled, skipping\n");
 		goto EXIT;
 	}
 
 	*address = ((superio_inb(sio_cip, SIO_VT1211_BADDR) << 8) |
 		    (superio_inb(sio_cip, SIO_VT1211_BADDR + 1))) & 0xff00;
 	if (*address == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address is not set, "
-		       "skipping\n");
+		pr_warn("Base address is not set, skipping\n");
 		goto EXIT;
 	}
 
 	err = 0;
-	printk(KERN_INFO DRVNAME ": Found VT1211 chip at 0x%04x, "
-	       "revision %u\n", *address,
-	       superio_inb(sio_cip, SIO_VT1211_DEVREV));
+	pr_info("Found VT1211 chip at 0x%04x, revision %u\n",
+		*address, superio_inb(sio_cip, SIO_VT1211_DEVREV));
 
 EXIT:
 	superio_exit(sio_cip);
@@ -1336,15 +1332,15 @@ static int __init vt1211_init(void)
 
 	if ((uch_config < -1) || (uch_config > 31)) {
 		err = -EINVAL;
-		printk(KERN_WARNING DRVNAME ": Invalid UCH configuration %d. "
-		       "Choose a value between 0 and 31.\n", uch_config);
+		pr_warn("Invalid UCH configuration %d. Choose a value between 0 and 31.\n",
+			uch_config);
 	  goto EXIT;
 	}
 
 	if ((int_mode < -1) || (int_mode > 0)) {
 		err = -EINVAL;
-		printk(KERN_WARNING DRVNAME ": Invalid interrupt mode %d. "
-		       "Only mode 0 is supported.\n", int_mode);
+		pr_warn("Invalid interrupt mode %d. Only mode 0 is supported.\n",
+			int_mode);
 	  goto EXIT;
 	}
 
diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index e6078c9..db3b2e8 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -24,6 +24,8 @@
 /* Supports VIA VT8231 South Bridge embedded sensors
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -902,21 +904,19 @@ static int __devinit vt8231_device_add(unsigned short address)
 	pdev = platform_device_alloc("vt8231", address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR "vt8231: Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR "vt8231: Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR "vt8231: Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 072c580..073eabe 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -42,6 +42,8 @@
     w83667hg-b   9      5       3       3      0xb350 0xc1    0x5ca3
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1668,8 +1670,7 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 		break;
 	default:
 		if (val != 0xffff)
-			pr_debug(DRVNAME ": unsupported chip ID: 0x%04x\n",
-				 val);
+			pr_debug("unsupported chip ID: 0x%04x\n", val);
 		superio_exit(sioaddr);
 		return -ENODEV;
 	}
@@ -1680,8 +1681,7 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	    | superio_inb(sioaddr, SIO_REG_ADDR + 1);
 	*addr = val & IOREGION_ALIGNMENT;
 	if (*addr == 0) {
-		printk(KERN_ERR DRVNAME ": Refusing to enable a Super-I/O "
-		       "device with a base I/O port 0.\n");
+		pr_err("Refusing to enable a Super-I/O device with a base I/O port 0\n");
 		superio_exit(sioaddr);
 		return -ENODEV;
 	}
@@ -1689,13 +1689,12 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	/* Activate logical device if needed */
 	val = superio_inb(sioaddr, SIO_REG_ENABLE);
 	if (!(val & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Forcibly enabling Super-I/O. "
-		       "Sensor is probably unusable.\n");
+		pr_warn("Forcibly enabling Super-I/O. Sensor is probably unusable.\n");
 		superio_outb(sioaddr, SIO_REG_ENABLE, val | 0x01);
 	}
 
 	superio_exit(sioaddr);
-	pr_info(DRVNAME ": Found %s chip at %#x\n", sio_name, *addr);
+	pr_info("Found %s chip at %#x\n", sio_name, *addr);
 	sio_data->sioreg = sioaddr;
 
 	return 0;
@@ -1729,14 +1728,14 @@ static int __init sensors_w83627ehf_init(void)
 
 	if (!(pdev = platform_device_alloc(DRVNAME, address))) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit_unregister;
 	}
 
 	err = platform_device_add_data(pdev, &sio_data,
 				       sizeof(struct w83627ehf_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
@@ -1752,16 +1751,14 @@ static int __init sensors_w83627ehf_init(void)
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	/* platform_device_add calls probe() */
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index 38e2805..bde50e3 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -39,6 +39,8 @@
     supported yet.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1166,14 +1168,13 @@ static int __init w83627hf_find(int sioaddr, unsigned short *addr,
 	       superio_inb(sio_data, WINB_BASE_REG + 1);
 	*addr = val & WINB_ALIGNMENT;
 	if (*addr == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address not set, "
-		       "skipping\n");
+		pr_warn("Base address not set, skipping\n");
 		goto exit;
 	}
 
 	val = superio_inb(sio_data, WINB_ACT_REG);
 	if (!(val & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Enabling HWM logical device\n");
+		pr_warn("Enabling HWM logical device\n");
 		superio_outb(sio_data, WINB_ACT_REG, val | 0x01);
 	}
 
@@ -1789,28 +1790,26 @@ static int __init w83627hf_device_add(unsigned short address,
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add_data(pdev, sio_data,
 				       sizeof(struct w83627hf_sio_data));
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Platform data allocation failed\n");
+		pr_err("Platform data allocation failed\n");
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index c84b9b4..d452a20 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -33,6 +33,8 @@
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1798,8 +1800,7 @@ w83781d_isa_found(unsigned short address)
 	 * individually for the probing phase. */
 	for (port = address; port < address + W83781D_EXTENT; port++) {
 		if (!request_region(port, 1, "w83781d")) {
-			pr_debug("w83781d: Failed to request port 0x%x\n",
-				 port);
+			pr_debug("Failed to request port 0x%x\n", port);
 			goto release;
 		}
 	}
@@ -1811,7 +1812,7 @@ w83781d_isa_found(unsigned short address)
 	if (inb_p(address + 2) != val
 	 || inb_p(address + 3) != val
 	 || inb_p(address + 7) != val) {
-		pr_debug("w83781d: Detection failed at step 1\n");
+		pr_debug("Detection failed at step 1\n");
 		goto release;
 	}
 #undef REALLY_SLOW_IO
@@ -1820,14 +1821,14 @@ w83781d_isa_found(unsigned short address)
 	   MSB (busy flag) should be clear initially, set after the write. */
 	save = inb_p(address + W83781D_ADDR_REG_OFFSET);
 	if (save & 0x80) {
-		pr_debug("w83781d: Detection failed at step 2\n");
+		pr_debug("Detection failed at step 2\n");
 		goto release;
 	}
 	val = ~save & 0x7f;
 	outb_p(val, address + W83781D_ADDR_REG_OFFSET);
 	if (inb_p(address + W83781D_ADDR_REG_OFFSET) != (val | 0x80)) {
 		outb_p(save, address + W83781D_ADDR_REG_OFFSET);
-		pr_debug("w83781d: Detection failed at step 3\n");
+		pr_debug("Detection failed at step 3\n");
 		goto release;
 	}
 
@@ -1835,7 +1836,7 @@ w83781d_isa_found(unsigned short address)
 	outb_p(W83781D_REG_CONFIG, address + W83781D_ADDR_REG_OFFSET);
 	val = inb_p(address + W83781D_DATA_REG_OFFSET);
 	if (val & 0x80) {
-		pr_debug("w83781d: Detection failed at step 4\n");
+		pr_debug("Detection failed at step 4\n");
 		goto release;
 	}
 	outb_p(W83781D_REG_BANK, address + W83781D_ADDR_REG_OFFSET);
@@ -1844,19 +1845,19 @@ w83781d_isa_found(unsigned short address)
 	val = inb_p(address + W83781D_DATA_REG_OFFSET);
 	if ((!(save & 0x80) && (val != 0xa3))
 	 || ((save & 0x80) && (val != 0x5c))) {
-		pr_debug("w83781d: Detection failed at step 5\n");
+		pr_debug("Detection failed at step 5\n");
 		goto release;
 	}
 	outb_p(W83781D_REG_I2C_ADDR, address + W83781D_ADDR_REG_OFFSET);
 	val = inb_p(address + W83781D_DATA_REG_OFFSET);
 	if (val < 0x03 || val > 0x77) {	/* Not a valid I2C address */
-		pr_debug("w83781d: Detection failed at step 6\n");
+		pr_debug("Detection failed at step 6\n");
 		goto release;
 	}
 
 	/* The busy flag should be clear again */
 	if (inb_p(address + W83781D_ADDR_REG_OFFSET) & 0x80) {
-		pr_debug("w83781d: Detection failed at step 7\n");
+		pr_debug("Detection failed at step 7\n");
 		goto release;
 	}
 
@@ -1871,7 +1872,7 @@ w83781d_isa_found(unsigned short address)
 		found = 1;
 
 	if (found)
-		pr_info("w83781d: Found a %s chip at %#x\n",
+		pr_info("Found a %s chip at %#x\n",
 			val == 0x30 ? "W83782D" : "W83781D", (int)address);
 
  release:
@@ -1894,21 +1895,19 @@ w83781d_isa_device_add(unsigned short address)
 	pdev = platform_device_alloc("w83781d", address);
 	if (!pdev) {
 		err = -ENOMEM;
-		printk(KERN_ERR "w83781d: Device allocation failed\n");
+		pr_err("Device allocation failed\n");
 		goto exit;
 	}
 
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
-		printk(KERN_ERR "w83781d: Device resource addition failed "
-		       "(%d)\n", err);
+		pr_err("Device resource addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);
 	if (err) {
-		printk(KERN_ERR "w83781d: Device addition failed (%d)\n",
-		       err);
+		pr_err("Device addition failed (%d)\n", err);
 		goto exit_device_put;
 	}
 


