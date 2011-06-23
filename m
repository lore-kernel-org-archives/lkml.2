Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1FWRXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab1FWRXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:18 -0400
Date: Thu, 23 Jun 2011 13:23:17 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172317.27659.98551.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 11/35] drivers/hwmon changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/hwmon changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- add exactmatch functionality
- edit udev notifiers
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/hwmon/abituguru.c    |   18 ++++++--
 drivers/hwmon/abituguru3.c   |   75 ++++++++++++++++--------------
 drivers/hwmon/adcxx.c        |    1 -
 drivers/hwmon/applesmc.c     |   73 +++++++++++++++++------------
 drivers/hwmon/asus_atk0110.c |   10 ++--
 drivers/hwmon/fschmd.c       |  104 ++++++++++++++++++++++--------------------
 drivers/hwmon/it87.c         |   42 ++++++++++-------
 drivers/hwmon/lm70.c         |    1 -
 8 files changed, 181 insertions(+), 143 deletions(-)

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 65a35cf..b9053cb 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -34,7 +34,7 @@
 #include <linux/platform_device.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/io.h>
 
 /* Banks */
@@ -1444,15 +1444,25 @@ static int __init abituguru_detect(void)
 
 static struct platform_device *abituguru_pdev;
 
+static struct sysfw_id abitguru_id_table[] = {
+	{
+		 .ident = "Abit Motherboards",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "http://www.abit.com.tw/"),
+		},
+		.exactmatch = 1,
+	},
+	{},
+};
+
 static int __init abituguru_init(void)
 {
 	int address, err;
 	struct resource res = { .flags = IORESOURCE_IO };
-	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
 
 	/* safety check, refuse to load on non Abit motherboards */
-	if (!force && (!board_vendor ||
-			strcmp(board_vendor, "http://www.abit.com.tw/")))
+	if (!force && !sysfw_callback(abitguru_id_table))
 		return -ENODEV;
 
 	address = abituguru_detect();
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index d30855a..7d36abc 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -36,7 +36,8 @@
 #include <linux/platform_device.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
+#include <linux/sysfw.h>
 #include <linux/io.h>
 
 /* uGuru3 bank addresses */
@@ -121,11 +122,11 @@ struct abituguru3_sensor_info {
 };
 
 /* Avoid use of flexible array members */
-#define ABIT_UGURU3_MAX_DMI_NAMES 2
+#define ABIT_UGURU3_MAX_SMBIOS_NAMES 2
 
 struct abituguru3_motherboard_info {
 	u16 id;
-	const char *dmi_name[ABIT_UGURU3_MAX_DMI_NAMES + 1];
+	const char *smbios_name[ABIT_UGURU3_MAX_SMBIOS_NAMES + 1];
 	/* + 1 -> end of sensors indicated by a sensor with name == NULL */
 	struct abituguru3_sensor_info sensors[ABIT_UGURU3_MAX_NO_SENSORS + 1];
 };
@@ -170,7 +171,7 @@ struct abituguru3_data {
 
 /* Constants */
 static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
-	{ 0x000C, { NULL } /* Unknown, need DMI string */, {
+	{ 0x000C, { NULL } /* Unknown, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -192,7 +193,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "AUX1 Fan",		35, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x000D, { NULL } /* Abit AW8, need DMI string */, {
+	{ 0x000D, { NULL } /* Abit AW8, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -221,7 +222,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "AUX5 Fan",		39, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x000E, { NULL } /* AL-8, need DMI string */, {
+	{ 0x000E, { NULL } /* AL-8, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -242,7 +243,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "SYS Fan",		34, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x000F, { NULL } /* Unknown, need DMI string */, {
+	{ 0x000F, { NULL } /* Unknown, need SMBIOS string */, {
 
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
@@ -264,7 +265,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "SYS Fan",		34, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0010, { NULL } /* Abit NI8 SLI GR, need DMI string */, {
+	{ 0x0010, { NULL } /* Abit NI8 SLI GR, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -313,7 +314,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "AUX3 Fan",		37, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0012, { NULL } /* Abit AN8 32X, need DMI string */, {
+	{ 0x0012, { NULL } /* Abit AN8 32X, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 20, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -335,7 +336,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "AUX1 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0013, { NULL } /* Abit AW8D, need DMI string */, {
+	{ 0x0013, { NULL } /* Abit AW8D, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -385,7 +386,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "SYS Fan",		34, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0015, { NULL } /* Unknown, need DMI string */, {
+	{ 0x0015, { NULL } /* Unknown, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 20, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -437,7 +438,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "OTES1 Fan",		38, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0017, { NULL } /* Unknown, need DMI string */, {
+	{ 0x0017, { NULL } /* Unknown, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
@@ -544,7 +545,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "AUX4 Fan",		37, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x001B, { NULL } /* Unknown, need DMI string */, {
+	{ 0x001B, { NULL } /* Unknown, need SMBIOS string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR3",		 1, 0, 20, 1, 0 },
 		{ "DDR3 VTT",		 2, 0, 10, 1, 0 },
@@ -1119,23 +1120,23 @@ static struct platform_driver abituguru3_driver = {
 	.resume = abituguru3_resume
 };
 
-static int __init abituguru3_dmi_detect(void)
+static int __init abituguru3_smbios_detect(void)
 {
 	const char *board_vendor, *board_name;
 	int i, err = (force) ? 1 : -ENODEV;
-	const char *const *dmi_name;
+	const char *const *smbios_name;
 	size_t sublen;
 
-	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
+	board_vendor = sysfw_lookup(SYSFW_BOARD_VENDOR);
 	if (!board_vendor || strcmp(board_vendor, "http://www.abit.com.tw/"))
 		return err;
 
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	board_name = sysfw_lookup(SYSFW_BOARD_NAME);
 	if (!board_name)
 		return err;
 
 	/* At the moment, we don't care about the part of the vendor
-	 * DMI string contained in brackets. Truncate the string at
+	 * SMBIOS string contained in brackets. Truncate the string at
 	 * the first occurrence of a bracket. Trim any trailing space
 	 * from the substring.
 	 */
@@ -1144,11 +1145,11 @@ static int __init abituguru3_dmi_detect(void)
 		sublen--;
 
 	for (i = 0; abituguru3_motherboards[i].id; i++) {
-		dmi_name = abituguru3_motherboards[i].dmi_name;
-		for ( ; *dmi_name; dmi_name++) {
-			if (strlen(*dmi_name) != sublen)
+		smbios_name = abituguru3_motherboards[i].smbios_name;
+		for ( ; *smbios_name; smbios_name++) {
+			if (strlen(*smbios_name) != sublen)
 				continue;
-			if (!strncasecmp(board_name, *dmi_name, sublen))
+			if (!strncasecmp(board_name, *smbios_name, sublen))
 				return 0;
 		}
 	}
@@ -1158,7 +1159,8 @@ static int __init abituguru3_dmi_detect(void)
 }
 
 /* FIXME: Manual detection should die eventually; we need to collect stable
- *        DMI model names first before we can rely entirely on CONFIG_DMI.
+ *        SMBIOS model names first before we can rely entirely on
+ *	  CONFIG_SMBIOS.
  */
 
 static int __init abituguru3_detect(void)
@@ -1192,21 +1194,26 @@ static int __init abituguru3_init(void)
 	struct resource res = { .flags = IORESOURCE_IO };
 	int err;
 
-	/* Attempt DMI detection first */
-	err = abituguru3_dmi_detect();
-	if (err < 0)
-		return err;
-
-	/* Fall back to manual detection if there was no exact
-	 * board name match, or force was specified.
-	 */
-	if (err > 0) {
+	err = 1;
+	if (smbios_available) {
+		/* Attempts SMBIOS detection first */
+		err = abituguru3_smbios_detect();
+		if (err < 0)
+			return err;
+	}
+	if (err) {
+		/* Fall back to manual detection if there was no exact
+		 * board name match, or force was specified.
+		 */
 		err = abituguru3_detect();
 		if (err)
 			return err;
 
-		pr_warn("this motherboard was not detected using DMI. "
-			"Please send the output of \"dmidecode\" to the abituguru3 maintainer (see MAINTAINERS)\n");
+		if (smbios_available)
+			pr_warn("this motherboard was not detected using "
+				"SMBIOS.  Please send the output of "
+				"\"dmidecode\" to the abituguru3 maintainer "
+				"(see MAINTAINERS)\n");
 	}
 
 	err = platform_driver_register(&abituguru3_driver);
diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index b2cacbe..ff47453 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -44,7 +44,6 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/mutex.h>
-#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 
 #define DRVNAME		"adcxx"
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4c07436..a2dc0f8 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -36,7 +36,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/timer.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/mutex.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/io.h>
@@ -1184,46 +1184,59 @@ static void applesmc_release_key_backlight(void)
 	destroy_workqueue(applesmc_led_wq);
 }
 
-static int applesmc_dmi_match(const struct dmi_system_id *id)
-{
-	return 1;
-}
-
-/* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
- * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
-static __initdata struct dmi_system_id applesmc_whitelist[] = {
-	{ applesmc_dmi_match, "Apple MacBook Air", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
+static __initdata struct sysfw_id applesmc_whitelist[] = {
+	{
+		.ident = "Apple MacBook Air",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MacBookAir")
+		},
+		.exactmatch = 1,
 	},
-	{ applesmc_dmi_match, "Apple MacBook Pro", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro") },
+	{
+		.ident = "Apple MacBook Pro",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MacBookPro")
+		},
+		.exactmatch = 1,
 	},
-	{ applesmc_dmi_match, "Apple MacBook", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook") },
+	{
+		.ident = "Apple MacBook",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MacBook")
+		},
 	},
-	{ applesmc_dmi_match, "Apple Macmini", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "Macmini") },
+	{
+		.ident = "Apple Macmini",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Macmini")
+		},
 	},
-	{ applesmc_dmi_match, "Apple MacPro", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
+	{
+		.ident = "Apple MacPro",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MacPro")
+		},
 	},
-	{ applesmc_dmi_match, "Apple iMac", {
-	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac") },
+	{
+		.ident = "Apple iMac",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "iMac")
+		},
 	},
-	{ .ident = NULL }
+	{}
 };
 
 static int __init applesmc_init(void)
 {
 	int ret;
 
-	if (!dmi_check_system(applesmc_whitelist)) {
+	if (!sysfw_callback(applesmc_whitelist)) {
 		pr_warn("supported laptop not found!\n");
 		ret = -ENODEV;
 		goto out;
@@ -1329,4 +1342,4 @@ module_exit(applesmc_exit);
 MODULE_AUTHOR("Nicolas Boichat");
 MODULE_DESCRIPTION("Apple SMC");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
+MODULE_DEVICE_TABLE(sysfw, applesmc_whitelist);
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index dcb78a7..b355020 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -13,7 +13,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <acpi/acpi.h>
 #include <acpi/acpixf.h>
@@ -27,15 +27,15 @@ static bool new_if;
 module_param(new_if, bool, 0);
 MODULE_PARM_DESC(new_if, "Override detection heuristic and force the use of the new ATK0110 interface");
 
-static const struct dmi_system_id __initconst atk_force_new_if[] = {
+static const struct sysfw_id __initconst atk_force_new_if[] = {
 	{
 		/* Old interface has broken MCH temp monitoring */
 		.ident = "Asus Sabertooth X58",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "SABERTOOTH X58")
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "SABERTOOTH X58")
 		}
 	},
-	{ }
+	{}
 };
 
 /* Minimum time between readings, enforced in order to avoid
@@ -1435,7 +1435,7 @@ static int __init atk0110_init(void)
 		return -EBUSY;
 	}
 
-	if (dmi_check_system(atk_force_new_if))
+	if (sysfw_callback(atk_force_new_if))
 		new_if = true;
 
 	ret = acpi_bus_register_driver(&atk_driver);
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index aa6d8b6..ce28caf 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -41,7 +41,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 #include <linux/fs.h>
 #include <linux/watchdog.h>
 #include <linux/miscdevice.h>
@@ -290,14 +290,14 @@ struct fschmd_data {
 	u8 fan_ripple[7];	/* divider for rps */
 };
 
-/* Global variables to hold information read from special DMI tables, which are
-   available on FSC machines with an fscher or later chip. There is no need to
-   protect these with a lock as they are only modified from our attach function
-   which always gets called with the i2c-core lock held and never accessed
-   before the attach function is done with them. */
-static int dmi_mult[6] = { 490, 200, 100, 100, 200, 100 };
-static int dmi_offset[6] = { 0, 0, 0, 0, 0, 0 };
-static int dmi_vref = -1;
+/* Global variables to hold information read from special SMBIOS tables, which
+   are available on FSC machines with an fscher or later chip. There is no need
+   to protect these with a lock as they are only modified from our attach
+   function which always gets called with the i2c-core lock held and never
+   accessed before the attach function is done with them. */
+static int smbios_mult[6] = { 490, 200, 100, 100, 200, 100 };
+static int smbios_offset[6] = { 0, 0, 0, 0, 0, 0 };
+static int smbios_vref = -1;
 
 /* Somewhat ugly :( global data pointer list with all fschmd devices, so that
    we can find our device data as when using misc_register there is no other
@@ -326,8 +326,8 @@ static ssize_t show_in_value(struct device *dev,
 	struct fschmd_data *data = fschmd_update_device(dev);
 
 	if (data->kind == fscher || data->kind >= fschrc)
-		return sprintf(buf, "%d\n", (data->volt[index] * dmi_vref *
-			dmi_mult[index]) / 255 + dmi_offset[index]);
+		return sprintf(buf, "%d\n", (data->volt[index] * smbios_vref *
+			smbios_mult[index]) / 255 + smbios_offset[index]);
 	else
 		return sprintf(buf, "%d\n", (data->volt[index] *
 			max_reading[index] + 128) / 255);
@@ -930,54 +930,56 @@ static const struct file_operations watchdog_fops = {
  * Detect, register, unregister and update device functions
  */
 
-/* DMI decode routine to read voltage scaling factors from special DMI tables,
-   which are available on FSC machines with an fscher or later chip. */
-static void fschmd_dmi_decode(const struct dmi_header *header, void *dummy)
+/* SMBIOS decode routine to read voltage scaling factors from special SMBIOS
+   tables which are available on FSC machines with an fscher or later chip. */
+static int fschmd_smbios_decode(const union smbios_struct *ss, void *dummy)
 {
 	int i, mult[3] = { 0 }, offset[3] = { 0 }, vref = 0, found = 0;
 
-	/* dmi code ugliness, we get passed the address of the contents of
-	   a complete DMI record, but in the form of a dmi_header pointer, in
-	   reality this address holds header->length bytes of which the header
-	   are the first 4 bytes */
-	u8 *dmi_data = (u8 *)header;
+	/* smbios code ugliness, we get passed the address of the contents of
+	   a complete SMBIOS record, but in the form of a smbios_header pointer,
+	   in reality this address holds header->length bytes of which the
+	   header are the first 4 bytes */
+	u8 *smbios_data = (u8 *)ss;
 
 	/* We are looking for OEM-specific type 185 */
-	if (header->type != 185)
-		return;
+	if (ss->header.type != 185)
+		return SMBIOS_WALK_CONTINUE;
 
 	/* we are looking for what Siemens calls "subtype" 19, the subtype
-	   is stored in byte 5 of the dmi block */
-	if (header->length < 5 || dmi_data[4] != 19)
-		return;
+	   is stored in byte 5 of the smbios block */
+	if (ss->header.length < 5 || smbios_data[4] != 19)
+		return SMBIOS_WALK_CONTINUE;
 
 	/* After the subtype comes 1 unknown byte and then blocks of 5 bytes,
 	   consisting of what Siemens calls an "Entity" number, followed by
 	   2 16-bit words in LSB first order */
-	for (i = 6; (i + 4) < header->length; i += 5) {
+	for (i = 6; (i + 4) < ss->header.length; i += 5) {
 		/* entity 1 - 3: voltage multiplier and offset */
-		if (dmi_data[i] >= 1 && dmi_data[i] <= 3) {
-			/* Our in sensors order and the DMI order differ */
+		if (smbios_data[i] >= 1 && smbios_data[i] <= 3) {
+			/* Our in sensors order and the SMBIOS order differ */
 			const int shuffle[3] = { 1, 0, 2 };
-			int in = shuffle[dmi_data[i] - 1];
+			int in = shuffle[smbios_data[i] - 1];
 
 			/* Check for twice the same entity */
 			if (found & (1 << in))
-				return;
+				return SMBIOS_WALK_CONTINUE;
 
-			mult[in] = dmi_data[i + 1] | (dmi_data[i + 2] << 8);
-			offset[in] = dmi_data[i + 3] | (dmi_data[i + 4] << 8);
+			mult[in] = smbios_data[i + 1] |
+				   (smbios_data[i + 2] << 8);
+			offset[in] = smbios_data[i + 3] |
+				     (smbios_data[i + 4] << 8);
 
 			found |= 1 << in;
 		}
 
 		/* entity 7: reference voltage */
-		if (dmi_data[i] == 7) {
+		if (smbios_data[i] == 7) {
 			/* Check for twice the same entity */
 			if (found & 0x08)
-				return;
+				return SMBIOS_WALK_CONTINUE;
 
-			vref = dmi_data[i + 1] | (dmi_data[i + 2] << 8);
+			vref = smbios_data[i + 1] | (smbios_data[i + 2] << 8);
 
 			found |= 0x08;
 		}
@@ -985,20 +987,22 @@ static void fschmd_dmi_decode(const struct dmi_header *header, void *dummy)
 
 	if (found == 0x0F) {
 		for (i = 0; i < 3; i++) {
-			dmi_mult[i] = mult[i] * 10;
-			dmi_offset[i] = offset[i] * 10;
+			smbios_mult[i] = mult[i] * 10;
+			smbios_offset[i] = offset[i] * 10;
 		}
-		/* According to the docs there should be separate dmi entries
+		/* According to the docs there should be separate smbios entries
 		   for the mult's and offsets of in3-5 of the syl, but on
 		   my test machine these are not present */
-		dmi_mult[3] = dmi_mult[2];
-		dmi_mult[4] = dmi_mult[1];
-		dmi_mult[5] = dmi_mult[2];
-		dmi_offset[3] = dmi_offset[2];
-		dmi_offset[4] = dmi_offset[1];
-		dmi_offset[5] = dmi_offset[2];
-		dmi_vref = vref;
+		smbios_mult[3] = smbios_mult[2];
+		smbios_mult[4] = smbios_mult[1];
+		smbios_mult[5] = smbios_mult[2];
+		smbios_offset[3] = smbios_offset[2];
+		smbios_offset[4] = smbios_offset[1];
+		smbios_offset[5] = smbios_offset[2];
+		smbios_vref = vref;
 	}
+
+	return SMBIOS_WALK_CONTINUE;
 }
 
 static int fschmd_detect(struct i2c_client *client,
@@ -1072,14 +1076,14 @@ static int fschmd_probe(struct i2c_client *client,
 		data->temp_max[2] = 50 + 128;
 	}
 
-	/* Read the special DMI table for fscher and newer chips */
-	if ((kind == fscher || kind >= fschrc) && dmi_vref == -1) {
-		dmi_walk(fschmd_dmi_decode, NULL);
-		if (dmi_vref == -1) {
+	/* Read the special SMBIOS table for fscher and newer chips */
+	if ((kind == fscher || kind >= fschrc) && smbios_vref == -1) {
+		smbios_walk(fschmd_smbios_decode, NULL);
+		if (smbios_vref == -1) {
 			dev_warn(&client->dev,
 				"Couldn't get voltage scaling factors from "
-				"BIOS DMI table, using builtin defaults\n");
-			dmi_vref = 33;
+				"SMBIOS table, using builtin defaults\n");
+			smbios_vref = 33;
 		}
 	}
 
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index bb6405b..a0c5021 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -52,7 +52,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/string.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
 
@@ -219,7 +219,7 @@ struct it87_sio_data {
 	u8 vid_value;
 	u8 beep_pin;
 	u8 internal;	/* Internal sensors can be labeled */
-	/* Features skipped based on config or DMI */
+	/* Features skipped based on config or SMBIOS */
 	u8 skip_vid;
 	u8 skip_fan;
 	u8 skip_pwm;
@@ -1541,13 +1541,24 @@ static const struct attribute_group it87_group_label = {
 	.attrs = it87_attributes_vid,
 };
 
+static struct sysfw_id __initdata it87_id_table[] = {
+	{
+		 .ident = "nVIDIA FN68PT",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "nVIDIA"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "FN68PT"),
+		},
+		.exactmatch = 1,
+	},
+	{},
+};
+
 /* SuperIO detection - will change isa_address if a chip is found */
 static int __init it87_find(unsigned short *address,
 	struct it87_sio_data *sio_data)
 {
 	int err;
 	u16 chip_type;
-	const char *board_vendor, *board_name;
 
 	err = superio_enter();
 	if (err)
@@ -1671,21 +1682,16 @@ static int __init it87_find(unsigned short *address,
 	if (sio_data->beep_pin)
 		pr_info("Beeping is supported\n");
 
-	/* Disable specific features based on DMI strings */
-	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	if (board_vendor && board_name) {
-		if (strcmp(board_vendor, "nVIDIA") == 0
-		 && strcmp(board_name, "FN68PT") == 0) {
-			/* On the Shuttle SN68PT, FAN_CTL2 is apparently not
-			   connected to a fan, but to something else. One user
-			   has reported instant system power-off when changing
-			   the PWM2 duty cycle, so we disable it.
-			   I use the board name string as the trigger in case
-			   the same board is ever used in other systems. */
-			pr_info("Disabling pwm2 due to hardware constraints\n");
-			sio_data->skip_pwm = (1 << 1);
-		}
+	/* Disable specific features based on system firmware strings */
+	if (sysfw_callback(it87_id_table)) {
+		/* On the Shuttle SN68PT, FAN_CTL2 is apparently not
+		   connected to a fan, but to something else. One user
+		   has reported instant system power-off when changing
+		   the PWM2 duty cycle, so we disable it.
+		   I use the board name string as the trigger in case
+		   the same board is ever used in other systems. */
+		pr_info("Disabling pwm2 due to hardware constraints\n");
+		sio_data->skip_pwm = (1 << 1);
 	}
 
 exit:
diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index c274ea2..bdb34f8 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -34,7 +34,6 @@
 #include <linux/sysfs.h>
 #include <linux/hwmon.h>
 #include <linux/mutex.h>
-#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 
-- 
1.7.5.4

