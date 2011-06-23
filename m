Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab1FWRYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:24:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab1FWRY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:24:28 -0400
Date: Thu, 23 Jun 2011 13:24:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172426.27722.94483.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [PATCH 22/35] drivers/platform changes for SMBIOS and System
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/platform changes for SMBIOS and System  Firmware

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- add exactmatch functionality
- edit udev notifiers
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/platform/x86/acer-wmi.c       |  119 +++++++++++-----------
 drivers/platform/x86/acerhdf.c        |   28 +++---
 drivers/platform/x86/asus-laptop.c    |   29 +++---
 drivers/platform/x86/compal-laptop.c  |  118 +++++++++++-----------
 drivers/platform/x86/dell-laptop.c    |   69 +++++++------
 drivers/platform/x86/dell-wmi.c       |   15 ++-
 drivers/platform/x86/eeepc-laptop.c   |   58 +++++++++--
 drivers/platform/x86/eeepc-wmi.c      |   30 +++---
 drivers/platform/x86/fujitsu-laptop.c |   44 ++++----
 drivers/platform/x86/hdaps.c          |   76 +++++++-------
 drivers/platform/x86/hp_accel.c       |   98 +++++++++---------
 drivers/platform/x86/ibm_rtl.c        |   21 ++--
 drivers/platform/x86/intel_oaktrail.c |   16 ++--
 drivers/platform/x86/msi-laptop.c     |  123 +++++++++++-----------
 drivers/platform/x86/samsung-laptop.c |  183 +++++++++++++++++----------------
 drivers/platform/x86/sony-laptop.c    |   16 ++--
 drivers/platform/x86/thinkpad_acpi.c  |   66 ++++++------
 17 files changed, 581 insertions(+), 528 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 005417b..2431dbf 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -28,7 +28,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
+#include <linux/sysfw.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/leds.h>
@@ -278,9 +279,9 @@ static void set_quirks(void)
 		interface->capability |= ACER_CAP_BRIGHTNESS;
 }
 
-static int dmi_matched(const struct dmi_system_id *dmi)
+static int quirk_matched(const struct sysfw_id *quirk)
 {
-	quirks = dmi->driver_data;
+	quirks = quirk->driver_data;
 	return 1;
 }
 
@@ -305,148 +306,148 @@ static struct quirk_entry quirk_fujitsu_amilo_li_1718 = {
 };
 
 /* The Aspire One has a dummy ACPI-WMI interface - disable it */
-static struct dmi_system_id __devinitdata acer_blacklist[] = {
+static struct sysfw_id __devinitdata acer_blacklist[] = {
 	{
 		.ident = "Acer Aspire One (SSD)",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AOA110"),
 		},
 	},
 	{
 		.ident = "Acer Aspire One (HDD)",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AOA150"),
 		},
 	},
 	{}
 };
 
-static struct dmi_system_id acer_quirks[] = {
+static struct sysfw_id acer_quirks[] = {
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 1360",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 1360"),
 		},
 		.driver_data = &quirk_acer_aspire_1520,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 1520",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1520"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 1520"),
 		},
 		.driver_data = &quirk_acer_aspire_1520,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 3100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 3100"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 3610",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3610"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 3610"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 5100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5100"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 5610",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5610"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 5630",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5630"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5630"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 5650",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5650"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5650"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 5680",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5680"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5680"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer Aspire 9110",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 9110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 9110"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer TravelMate 2490",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2490"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 2490"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Acer TravelMate 4200",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4200"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 4200"),
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Fujitsu Siemens Amilo Li 1718",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Li 1718"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Li 1718"),
 		},
 		.driver_data = &quirk_fujitsu_amilo_li_1718,
 	},
 	{
-		.callback = dmi_matched,
+		.callback = quirk_matched,
 		.ident = "Medion MD 98300",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "WAM2030"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDION"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "WAM2030"),
 		},
 		.driver_data = &quirk_medion_md_98300,
 	},
@@ -457,7 +458,7 @@ static struct dmi_system_id acer_quirks[] = {
 static void find_quirks(void)
 {
 	if (!force_series) {
-		dmi_check_system(acer_quirks);
+		sysfw_callback(acer_quirks);
 	} else if (force_series == 2490) {
 		quirks = &quirk_acer_travelmate_2490;
 	}
@@ -848,16 +849,16 @@ static acpi_status WMID_set_u32(u32 value, u32 cap, struct wmi_interface *iface)
 	return WMI_execute_u32(method_id, (u32)value, NULL);
 }
 
-static void type_aa_dmi_decode(const struct dmi_header *header, void *dummy)
+static int type_aa_smbios_decode(const union smbios_struct *ss, void *dummy)
 {
 	struct hotkey_function_type_aa *type_aa;
 
 	/* We are looking for OEM-specific Type AAh */
-	if (header->type != 0xAA)
-		return;
+	if (ss->header.type != 0xAA)
+		return SMBIOS_WALK_CONTINUE;
 
 	has_type_aa = true;
-	type_aa = (struct hotkey_function_type_aa *) header;
+	type_aa = (struct hotkey_function_type_aa *) &ss->header;
 
 	pr_info("Function bitmap for Communication Button: 0x%x\n",
 		type_aa->commun_func_bitmap);
@@ -868,6 +869,8 @@ static void type_aa_dmi_decode(const struct dmi_header *header, void *dummy)
 		interface->capability |= ACER_CAP_THREEG;
 	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_BLUETOOTH)
 		interface->capability |= ACER_CAP_BLUETOOTH;
+
+	return SMBIOS_WALK_STOP;
 }
 
 static acpi_status WMID_set_capabilities(void)
@@ -893,7 +896,7 @@ static acpi_status WMID_set_capabilities(void)
 		return AE_ERROR;
 	}
 
-	dmi_walk(type_aa_dmi_decode, NULL);
+	smbios_walk(type_aa_smbios_decode, NULL);
 	if (!has_type_aa) {
 		interface->capability |= ACER_CAP_WIRELESS;
 		if (devices & 0x40)
@@ -1824,7 +1827,7 @@ static int __init acer_wmi_init(void)
 
 	pr_info("Acer Laptop ACPI-WMI Extras\n");
 
-	if (dmi_check_system(acer_blacklist)) {
+	if (sysfw_callback(acer_blacklist)) {
 		pr_info("Blacklisted hardware detected - not loading\n");
 		return -ENODEV;
 	}
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index fca3489..4b74070 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -35,7 +35,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/acpi.h>
 #include <linux/thermal.h>
 #include <linux/platform_device.h>
@@ -544,9 +544,9 @@ static int acerhdf_check_hardware(void)
 	const struct bios_settings_t *bt = NULL;
 
 	/* get BIOS data */
-	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
-	version = dmi_get_system_info(DMI_BIOS_VERSION);
-	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	vendor  = sysfw_lookup(SYSFW_SYS_VENDOR);
+	version = sysfw_lookup(SYSFW_BIOS_VERSION);
+	product = sysfw_lookup(SYSFW_PRODUCT_NAME);
 
 	if (!vendor || !version || !product) {
 		pr_err("error getting hardware information\n");
@@ -702,16 +702,16 @@ static void __exit acerhdf_exit(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
-MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
-MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
-MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
-MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
-MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
-MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMU*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMA*:");
+MODULE_ALIAS("sysfw:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("sysfw:*:*Acer*:pnAspire 1410*:");
+MODULE_ALIAS("sysfw:*:*Acer*:pnAspire 1810*:");
+MODULE_ALIAS("sysfw:*:*Acer*:pnAO531*:");
+MODULE_ALIAS("sysfw:*:*Gateway*:pnAOA*:");
+MODULE_ALIAS("sysfw:*:*Gateway*:pnLT31*:");
+MODULE_ALIAS("sysfw:*:*Packard Bell*:pnAOA*:");
+MODULE_ALIAS("sysfw:*:*Packard Bell*:pnDOA*:");
+MODULE_ALIAS("sysfw:*:*Packard Bell*:pnDOTMU*:");
+MODULE_ALIAS("sysfw:*:*Packard Bell*:pnDOTMA*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index d65df92..1841e01 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -50,7 +50,7 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/rfkill.h>
 #include <linux/slab.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 
@@ -1401,19 +1401,16 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	return result;
 }
 
-static void __devinit asus_dmi_check(void)
-{
-	const char *model;
-
-	model = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!model)
-		return;
-
-	/* On L1400B WLED control the sound card, don't mess with it ... */
-	if (strncmp(model, "L1400B", 6) == 0) {
-		wlan_status = -1;
-	}
-}
+static struct sysfw_id asus_wlan_table[] = {
+	{
+		 .ident = "L1400B",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "L1400B"),
+		},
+		.exactmatch = 1,
+	},
+	{},
+};
 
 static bool asus_device_present;
 
@@ -1433,7 +1430,9 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	device->driver_data = asus;
 	asus->device = device;
 
-	asus_dmi_check();
+	/* On L1400B WLED control the sound card, don't mess with it ... */
+	if (sysfw_callback(asus_wlan_table))
+		wlan_status = -1;
 
 	result = asus_acpi_init(asus);
 	if (result)
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 3f204fd..f62538c 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -46,7 +46,7 @@
  *
  * This driver might work on other laptops produced by Compal. If you
  * want to try it you can pass force=1 as argument to the module which
- * will force it to load even when the DMI data doesn't identify the
+ * will force it to load even when the SMBIOS data doesn't identify the
  * laptop as compatible.
  *
  * Lots of data available at:
@@ -74,7 +74,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
@@ -191,7 +191,7 @@ struct compal_data{
 /* =============== */
 static int force;
 module_param(force, bool, 0);
-MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
+MODULE_PARM_DESC(force, "Force driver load, ignore SMBIOS data");
 
 /* Support for the wake_on_XXX, hwmon and power_supply interface. Currently
  * only gets enabled on a JHL90 board. Might work with the others too */
@@ -760,14 +760,14 @@ static struct rfkill *bt_rfkill;
 /* Initialization & clean-up functions */
 /* =================================== */
 
-static int dmi_check_cb(const struct dmi_system_id *id)
+static int id_check_cb(const struct sysfw_id *id)
 {
 	pr_info("Identified laptop model '%s'\n", id->ident);
 	extra_features = false;
 	return 1;
 }
 
-static int dmi_check_cb_extra(const struct dmi_system_id *id)
+static int id_check_cb_extra(const struct sysfw_id *id)
 {
 	pr_info("Identified laptop model '%s', enabling extra features\n",
 		id->ident);
@@ -775,112 +775,112 @@ static int dmi_check_cb_extra(const struct dmi_system_id *id)
 	return 1;
 }
 
-static struct dmi_system_id __initdata compal_dmi_table[] = {
+static struct sysfw_id __initdata compal_id_table[] = {
 	{
 		.ident = "FL90/IFL90",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "IFL90"),
-			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "IFL90"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "IFT00"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "FL90/IFL90",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "IFL90"),
-			DMI_MATCH(DMI_BOARD_VERSION, "REFERENCE"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "IFL90"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "REFERENCE"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "FL91/IFL91",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "IFL91"),
-			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "IFL91"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "IFT00"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "FL92/JFL92",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "JFL92"),
-			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "JFL92"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "IFT00"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "FT00/IFT00",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "IFT00"),
-			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "IFT00"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "IFT00"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Dell Mini 9",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 910"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 910"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Dell Mini 10",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1010"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1010"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Dell Mini 10v",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1011"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1011"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Dell Mini 1012",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1012"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Dell Inspiron 11z",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1110"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Dell Mini 12",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1210"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1210"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "JHL90",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "JHL90"),
-			DMI_MATCH(DMI_BOARD_VERSION, "REFERENCE"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "JHL90"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "REFERENCE"),
 		},
-		.callback = dmi_check_cb_extra
+		.callback = id_check_cb_extra
 	},
 	{
 		.ident = "KHLB2",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "KHLB2"),
-			DMI_MATCH(DMI_BOARD_VERSION, "REFERENCE"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "KHLB2"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "REFERENCE"),
 		},
-		.callback = dmi_check_cb_extra
+		.callback = id_check_cb_extra
 	},
-	{ }
+	{}
 };
 
 static void initialize_power_supply_data(struct compal_data *data)
@@ -960,7 +960,7 @@ static int __init compal_init(void)
 		return -ENODEV;
 	}
 
-	if (!force && !dmi_check_system(compal_dmi_table)) {
+	if (!force && !sysfw_callback(compal_id_table)) {
 		pr_err("Motherboard not recognized (You could try the module's force-parameter)\n");
 		return -ENODEV;
 	}
@@ -1096,15 +1096,15 @@ MODULE_DESCRIPTION("Compal Laptop Support");
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS("dmi:*:rnIFL90:rvrIFT00:*");
-MODULE_ALIAS("dmi:*:rnIFL90:rvrREFERENCE:*");
-MODULE_ALIAS("dmi:*:rnIFL91:rvrIFT00:*");
-MODULE_ALIAS("dmi:*:rnJFL92:rvrIFT00:*");
-MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*");
-MODULE_ALIAS("dmi:*:rnJHL90:rvrREFERENCE:*");
-MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron910:*");
-MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1010:*");
-MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1011:*");
-MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1012:*");
-MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1110:*");
-MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1210:*");
+MODULE_ALIAS("sysfw:*:rnIFL90:rvrIFT00:*");
+MODULE_ALIAS("sysfw:*:rnIFL90:rvrREFERENCE:*");
+MODULE_ALIAS("sysfw:*:rnIFL91:rvrIFT00:*");
+MODULE_ALIAS("sysfw:*:rnJFL92:rvrIFT00:*");
+MODULE_ALIAS("sysfw:*:rnIFT00:rvrIFT00:*");
+MODULE_ALIAS("sysfw:*:rnJHL90:rvrREFERENCE:*");
+MODULE_ALIAS("sysfw:*:svnDellInc.:pnInspiron910:*");
+MODULE_ALIAS("sysfw:*:svnDellInc.:pnInspiron1010:*");
+MODULE_ALIAS("sysfw:*:svnDellInc.:pnInspiron1011:*");
+MODULE_ALIAS("sysfw:*:svnDellInc.:pnInspiron1012:*");
+MODULE_ALIAS("sysfw:*:svnDellInc.:pnInspiron1110:*");
+MODULE_ALIAS("sysfw:*:svnDellInc.:pnInspiron1210:*");
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index d3841de..eaa180b 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -19,7 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
+#include <linux/sysfw.h>
 #include <linux/io.h>
 #include <linux/rfkill.h>
 #include <linux/power_supply.h>
@@ -53,7 +54,7 @@ struct calling_interface_token {
 };
 
 struct calling_interface_structure {
-	struct dmi_header header;
+	struct smbios_header header;
 	u16 cmdIOAddress;
 	u8 cmdIOCode;
 	u32 supportedCmds;
@@ -78,72 +79,73 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static const struct dmi_system_id __initdata dell_device_table[] = {
+static const struct sysfw_id __initdata dell_device_table[] = {
 	{
 		.ident = "Dell laptop",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "8"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /*Laptop*/
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "9"), /*Laptop*/
 		},
 	},
 	{
 		.ident = "Dell Computer Corporation",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Dell Computer Corporation"),
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "8"),
 		},
 	},
-	{ }
+	{}
 };
 
-static struct dmi_system_id __devinitdata dell_blacklist[] = {
+static struct sysfw_id __devinitdata dell_blacklist[] = {
 	/* Supported by compal-laptop */
 	{
 		.ident = "Dell Mini 9",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 910"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 910"),
 		},
 	},
 	{
 		.ident = "Dell Mini 10",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1010"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1010"),
 		},
 	},
 	{
 		.ident = "Dell Mini 10v",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1011"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1011"),
 		},
 	},
 	{
 		.ident = "Dell Mini 1012",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1012"),
 		},
 	},
 	{
 		.ident = "Dell Inspiron 11z",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1110"),
 		},
 	},
 	{
 		.ident = "Dell Mini 12",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1210"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron 1210"),
 		},
 	},
 	{}
@@ -166,7 +168,7 @@ static void release_buffer(void)
 	mutex_unlock(&buffer_mutex);
 }
 
-static void __init parse_da_table(const struct dmi_header *dm)
+static void __init parse_da_table(const struct smbios_header *dm)
 {
 	/* Final token is a terminator, so we don't want to copy it */
 	int tokens = (dm->length-11)/sizeof(struct calling_interface_token)-1;
@@ -195,9 +197,9 @@ static void __init parse_da_table(const struct dmi_header *dm)
 	da_num_tokens += tokens;
 }
 
-static void __init find_tokens(const struct dmi_header *dm, void *dummy)
+static int __init find_tokens(const union smbios_struct *ss, void *dummy)
 {
-	switch (dm->type) {
+	switch (ss->header.type) {
 	case 0xd4: /* Indexed IO */
 		break;
 	case 0xd5: /* Protected Area Type 1 */
@@ -205,9 +207,10 @@ static void __init find_tokens(const struct dmi_header *dm, void *dummy)
 	case 0xd6: /* Protected Area Type 2 */
 		break;
 	case 0xda: /* Calling interface */
-		parse_da_table(dm);
+		parse_da_table(&ss->header);
 		break;
 	}
+	return SMBIOS_WALK_CONTINUE;
 }
 
 static int find_token_location(int tokenid)
@@ -435,7 +438,7 @@ static int __init dell_setup_rfkill(void)
 	int status;
 	int ret;
 
-	if (dmi_check_system(dell_blacklist)) {
+	if (sysfw_callback(dell_blacklist)) {
 		pr_info("Blacklisted hardware detected - not enabling rfkill\n");
 		return 0;
 	}
@@ -601,10 +604,10 @@ static int __init dell_init(void)
 	int max_intensity = 0;
 	int ret;
 
-	if (!dmi_check_system(dell_device_table))
+	if (!sysfw_callback(dell_device_table))
 		return -ENODEV;
 
-	dmi_walk(find_tokens, NULL);
+	smbios_walk(find_tokens, NULL);
 
 	if (!da_tokens)  {
 		pr_info("Unable to find dmi tokens\n");
@@ -731,6 +734,6 @@ module_exit(dell_exit);
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");
-MODULE_ALIAS("dmi:*svnDellInc.:*:ct9:*");
-MODULE_ALIAS("dmi:*svnDellComputerCorporation.:*:ct8:*");
+MODULE_ALIAS("sysfw:*svnDellInc.:*:ct8:*");
+MODULE_ALIAS("sysfw:*svnDellInc.:*:ct9:*");
+MODULE_ALIAS("sysfw:*svnDellComputerCorporation.:*:ct8:*");
diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index ce79082..b71c908 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -35,7 +35,7 @@
 #include <acpi/acpi_drivers.h>
 #include <linux/acpi.h>
 #include <linux/string.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Dell laptop WMI hotkeys driver");
@@ -103,7 +103,7 @@ struct dell_bios_keymap_entry {
 };
 
 struct dell_bios_hotkey_table {
-	struct dmi_header header;
+	struct smbios_header header;
 	struct dell_bios_keymap_entry keymap[];
 
 };
@@ -261,13 +261,16 @@ static void dell_wmi_input_destroy(void)
 	input_unregister_device(dell_wmi_input_dev);
 }
 
-static void __init find_hk_type(const struct dmi_header *dm, void *dummy)
+static int __init find_hk_type(const union smbios_struct *ss, void *dummy)
 {
-	if (dm->type == 0xb2 && dm->length > 6) {
+	if (ss->header.type == 0xb2 && ss->header.length > 6) {
 		dell_new_hk_type = true;
 		dell_bios_hotkey_table =
-			container_of(dm, struct dell_bios_hotkey_table, header);
+			container_of(&ss->header, struct dell_bios_hotkey_table,
+				     header);
+		return SMBIOS_WALK_STOP;
 	}
+	return SMBIOS_WALK_CONTINUE;
 }
 
 static int __init dell_wmi_init(void)
@@ -280,7 +283,7 @@ static int __init dell_wmi_init(void)
 		return -ENODEV;
 	}
 
-	dmi_walk(find_hk_type, NULL);
+	smbios_walk(find_hk_type, NULL);
 	acpi_video = acpi_video_backlight_support();
 
 	err = dell_wmi_input_setup();
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 1c45d92..8fcc6f5 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -37,7 +37,7 @@
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/leds.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define EEEPC_LAPTOP_VERSION	"0.1"
 #define EEEPC_LAPTOP_NAME	"Eee PC Hotkey Driver"
@@ -1296,11 +1296,54 @@ static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 	}
 }
 
-static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
+static struct sysfw_id eeepc_disable_cpufv_id[] = {
+	{
+		 .ident = "701",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "701"),
+		},
+		.exactmatch = 1,
+	},
+	{
+		 .ident = "702",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "702"),
+		},
+		.exactmatch = 1,
+	},
+	{},
+};
+
+static struct sysfw_id eeepc_wlan_hotplug_id[] = {
+	{
+		 .ident = "1005HA",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "1005HA"),
+		},
+		.exactmatch = 1,
+	},
+	{
+		 .ident = "1201N",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "1201N"),
+		},
+		.exactmatch = 1,
+	},
+	{
+		 .ident = "1005PE",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "1005PE"),
+		},
+		.exactmatch = 1,
+	},
+	{},
+};
+
+static void eeepc_sysfw_check(struct eeepc_laptop *eeepc)
 {
 	const char *model;
 
-	model = dmi_get_system_info(DMI_PRODUCT_NAME);
+	model = sysfw_lookup(SYSFW_PRODUCT_NAME);
 	if (!model)
 		return;
 
@@ -1319,11 +1362,11 @@ static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
 	 *
 	 * The hang has also been reported on a "702" (Model name "8G"?).
 	 *
-	 * We avoid dmi_check_system() / dmi_match(), because they use
+	 * We avoid sysfw_*() functions, because they use
 	 * substring matching.  We don't want to affect the "701SD"
 	 * and "701SDX" models, because they do support S.H.E.
 	 */
-	if (strcmp(model, "701") == 0 || strcmp(model, "702") == 0) {
+	if (sysfw_callback(eeepc_disable_cpufv_id)) {
 		eeepc->cpufv_disabled = true;
 		pr_info("model %s does not officially support setting cpu "
 			"speed\n", model);
@@ -1337,8 +1380,7 @@ static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
 	 * hotplug code. In fact, current hotplug code seems to unplug another
 	 * device...
 	 */
-	if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0 ||
-	    strcmp(model, "1005PE") == 0) {
+	if (sysfw_callback(eeepc_wlan_hotplug_id)) {
 		eeepc->hotplug_disabled = true;
 		pr_info("wlan hotplug disabled\n");
 	}
@@ -1427,7 +1469,7 @@ static int __devinit eeepc_acpi_add(struct acpi_device *device)
 
 	eeepc->hotplug_disabled = hotplug_disabled;
 
-	eeepc_dmi_check(eeepc);
+	eeepc_sysfw_check(eeepc);
 
 	result = eeepc_acpi_init(eeepc);
 	if (result)
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 4aa867a..8494074 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -31,7 +31,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <acpi/acpi_bus.h>
 
 #include "asus-wmi.h"
@@ -116,14 +116,20 @@ static int eeepc_wmi_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void eeepc_dmi_check(struct asus_wmi_driver *driver)
-{
-	const char *model;
-
-	model = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!model)
-		return;
+static struct sysfw_id eeepc_wlan_hotplug_id[] = {
+	{
+		 .ident = "Asus 1000H",
+		.matches = {
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "1000H"),
+		},
+		.exactmatch = 1,
+	},
+	{},
+};
 
+static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
+{
+	driver->hotplug_wireless = hotplug_wireless;
 	/*
 	 * Whitelist for wlan hotplug
 	 *
@@ -132,18 +138,12 @@ static void eeepc_dmi_check(struct asus_wmi_driver *driver)
 	 * it seems that most of the laptops supported by asus-wmi
 	 * don't need to be on this list
 	 */
-	if (strcmp(model, "1000H") == 0) {
+	if (sysfw_callback(eeepc_wlan_hotplug_id)) {
 		driver->hotplug_wireless = true;
 		pr_info("wlan hotplug enabled\n");
 	}
 }
 
-static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
-{
-	driver->hotplug_wireless = hotplug_wireless;
-	eeepc_dmi_check(driver);
-}
-
 static struct asus_wmi_driver asus_wmi_driver = {
 	.name = EEEPC_WMI_FILE,
 	.owner = THIS_MODULE,
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 6b26666..0b92a53 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -62,7 +62,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/backlight.h>
 #include <linux/input.h>
 #include <linux/kfifo.h>
@@ -584,7 +584,7 @@ static struct platform_driver fujitsupf_driver = {
 		   }
 };
 
-static void dmi_check_cb_common(const struct dmi_system_id *id)
+static void id_check_cb_common(const struct sysfw_id *id)
 {
 	acpi_handle handle;
 	pr_info("Identified laptop model '%s'\n", id->ident);
@@ -599,53 +599,53 @@ static void dmi_check_cb_common(const struct dmi_system_id *id)
 	}
 }
 
-static int dmi_check_cb_s6410(const struct dmi_system_id *id)
+static int id_check_cb_s6410(const struct sysfw_id *id)
 {
-	dmi_check_cb_common(id);
+	id_check_cb_common(id);
 	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
 	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
 	return 1;
 }
 
-static int dmi_check_cb_s6420(const struct dmi_system_id *id)
+static int id_check_cb_s6420(const struct sysfw_id *id)
 {
-	dmi_check_cb_common(id);
+	id_check_cb_common(id);
 	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
 	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
 	return 1;
 }
 
-static int dmi_check_cb_p8010(const struct dmi_system_id *id)
+static int id_check_cb_p8010(const struct sysfw_id *id)
 {
-	dmi_check_cb_common(id);
+	id_check_cb_common(id);
 	fujitsu->keycode1 = KEY_HELP;	/* "Support" */
 	fujitsu->keycode3 = KEY_SWITCHVIDEOMODE;	/* "Presentation" */
 	fujitsu->keycode4 = KEY_WWW;	/* "Internet" */
 	return 1;
 }
 
-static struct dmi_system_id fujitsu_dmi_table[] = {
+static struct sysfw_id fujitsu_id_table[] = {
 	{
 	 .ident = "Fujitsu Siemens S6410",
 	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK S6410"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LIFEBOOK S6410"),
 		     },
-	 .callback = dmi_check_cb_s6410},
+	 .callback = id_check_cb_s6410},
 	{
 	 .ident = "Fujitsu Siemens S6420",
 	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK S6420"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LIFEBOOK S6420"),
 		     },
-	 .callback = dmi_check_cb_s6420},
+	 .callback = id_check_cb_s6420},
 	{
 	 .ident = "Fujitsu LifeBook P8010",
 	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P8010"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LifeBook P8010"),
 		     },
-	 .callback = dmi_check_cb_p8010},
+	 .callback = id_check_cb_p8010},
 	{}
 };
 
@@ -1095,7 +1095,7 @@ static int __init fujitsu_init(void)
 	fujitsu->keycode2 = KEY_PROG2;
 	fujitsu->keycode3 = KEY_PROG3;
 	fujitsu->keycode4 = KEY_PROG4;
-	dmi_check_system(fujitsu_dmi_table);
+	sysfw_callback(fujitsu_id_table);
 
 	result = acpi_bus_register_driver(&acpi_fujitsu_driver);
 	if (result < 0) {
@@ -1236,9 +1236,9 @@ MODULE_DESCRIPTION("Fujitsu laptop extras support");
 MODULE_VERSION(FUJITSU_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
-MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
-MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
+MODULE_ALIAS("sysfw:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
+MODULE_ALIAS("sysfw:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
+MODULE_ALIAS("sysfw:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
 
 static struct pnp_device_id pnp_ids[] __used = {
 	{.id = "FUJ02bf"},
diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
index 5a34973..d705002 100644
--- a/drivers/platform/x86/hdaps.c
+++ b/drivers/platform/x86/hdaps.c
@@ -35,7 +35,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/timer.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/jiffies.h>
 #include <linux/io.h>
 
@@ -479,62 +479,62 @@ static struct attribute_group hdaps_attribute_group = {
 
 /* Module stuff */
 
-/* hdaps_dmi_match - found a match.  return one, short-circuiting the hunt. */
-static int __init hdaps_dmi_match(const struct dmi_system_id *id)
+/* hdaps_id_match - found a match.  return one, short-circuiting the hunt. */
+static int __init hdaps_id_match(const struct sysfw_id *id)
 {
 	pr_info("%s detected\n", id->ident);
 	return 1;
 }
 
-/* hdaps_dmi_match_invert - found an inverted match. */
-static int __init hdaps_dmi_match_invert(const struct dmi_system_id *id)
+/* hdaps_id_match_invert - found an inverted match. */
+static int __init hdaps_id_match_invert(const struct sysfw_id *id)
 {
 	hdaps_invert = (unsigned long)id->driver_data;
 	pr_info("inverting axis (%u) readings\n", hdaps_invert);
-	return hdaps_dmi_match(id);
+	return hdaps_id_match(id);
 }
 
-#define HDAPS_DMI_MATCH_INVERT(vendor, model, axes) {	\
+#define HDAPS_SYSFW_MATCH_INVERT(vendor, model, axes) {	\
 	.ident = vendor " " model,			\
-	.callback = hdaps_dmi_match_invert,		\
+	.callback = hdaps_id_match_invert,		\
 	.driver_data = (void *)axes,			\
 	.matches = {					\
-		DMI_MATCH(DMI_BOARD_VENDOR, vendor),	\
-		DMI_MATCH(DMI_PRODUCT_VERSION, model)	\
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, vendor),	\
+		SYSFW_MATCH(SYSFW_PRODUCT_VERSION, model)	\
 	}						\
 }
 
-#define HDAPS_DMI_MATCH_NORMAL(vendor, model)		\
-	HDAPS_DMI_MATCH_INVERT(vendor, model, 0)
+#define HDAPS_SYSFW_MATCH_NORMAL(vendor, model)		\
+	HDAPS_SYSFW_MATCH_INVERT(vendor, model, 0)
 
-/* Note that HDAPS_DMI_MATCH_NORMAL("ThinkPad T42") would match
+/* Note that HDAPS_SYSFW_MATCH_NORMAL("ThinkPad T42") would match
    "ThinkPad T42p", so the order of the entries matters.
    If your ThinkPad is not recognized, please update to latest
    BIOS. This is especially the case for some R52 ThinkPads. */
-static struct dmi_system_id __initdata hdaps_whitelist[] = {
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad R50p", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T400", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad X41", HDAPS_Y_AXIS),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m", HDAPS_BOTH_AXES),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p", HDAPS_BOTH_AXES),
+static struct sysfw_id __initdata hdaps_whitelist[] = {
+	HDAPS_SYSFW_MATCH_INVERT("IBM", "ThinkPad R50p", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad R50"),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad R51"),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad R52"),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad R61i", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad R61", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("IBM", "ThinkPad T41p", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad T41"),
+	HDAPS_SYSFW_MATCH_INVERT("IBM", "ThinkPad T42p", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad T42"),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad T43"),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad T400", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad T60", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad X40"),
+	HDAPS_SYSFW_MATCH_INVERT("IBM", "ThinkPad X41", HDAPS_Y_AXIS),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad X60", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad X61s", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad X61", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad Z61m", HDAPS_BOTH_AXES),
+	HDAPS_SYSFW_MATCH_INVERT("LENOVO", "ThinkPad Z61p", HDAPS_BOTH_AXES),
 	{ .ident = NULL }
 };
 
@@ -543,7 +543,7 @@ static int __init hdaps_init(void)
 	struct input_dev *idev;
 	int ret;
 
-	if (!dmi_check_system(hdaps_whitelist)) {
+	if (!sysfw_callback(hdaps_whitelist)) {
 		pr_warn("supported laptop not found!\n");
 		ret = -ENODEV;
 		goto out;
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 1b52d00..6a47d3e 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -24,7 +24,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
@@ -146,10 +146,10 @@ int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
 	return 0;
 }
 
-static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
+static int lis3lv02d_id_matched(const struct sysfw_id *id)
 {
-	lis3_dev.ac = *((union axis_conversion *)dmi->driver_data);
-	pr_info("hardware type %s found\n", dmi->ident);
+	lis3_dev.ac = *((union axis_conversion *)id->driver_data);
+	pr_info("hardware type %s found\n", id->ident);
 
 	return 1;
 }
@@ -170,64 +170,64 @@ DEFINE_CONV(xy_swap_inverted, -2, -1, 3);
 DEFINE_CONV(xy_rotated_right, 2, -1, 3);
 DEFINE_CONV(xy_swap_yz_inverted, 2, -1, -3);
 
-#define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
+#define AXIS_SYSFW_MATCH(_ident, _name, _axis) {	\
 	.ident = _ident,				\
-	.callback = lis3lv02d_dmi_matched,		\
+	.callback = lis3lv02d_id_matched,		\
 	.matches = {					\
-		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, _name)	\
 	},						\
 	.driver_data = &lis3lv02d_axis_##_axis		\
 }
 
-#define AXIS_DMI_MATCH2(_ident, _class1, _name1,	\
-				_class2, _name2,	\
-				_axis) {		\
+#define AXIS_SYSFW_MATCH2(_ident, _class1, _name1,	\
+			   _class2, _name2,		\
+			   _axis) {			\
 	.ident = _ident,				\
-	.callback = lis3lv02d_dmi_matched,		\
+	.callback = lis3lv02d_id_matched,		\
 	.matches = {					\
-		DMI_MATCH(DMI_##_class1, _name1),	\
-		DMI_MATCH(DMI_##_class2, _name2),	\
+		SYSFW_MATCH(SYSFW_##_class1, _name1),	\
+		SYSFW_MATCH(SYSFW_##_class2, _name2),	\
 	},						\
 	.driver_data = &lis3lv02d_axis_##_axis		\
 }
-static struct dmi_system_id lis3lv02d_dmi_ids[] = {
+static struct sysfw_id lis3lv02d_ids[] = {
 	/* product names are truncated to match all kinds of a same model */
-	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
-	AXIS_DMI_MATCH("NC84x0", "HP Compaq nc84", z_inverted),
-	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
-	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
-	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
-	AXIS_DMI_MATCH("NC2710", "HP Compaq 2710", xy_swap),
-	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
-	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
-	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
-	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
-	AXIS_DMI_MATCH("NC6730b", "HP Compaq 6730b", xy_rotated_left_usd),
-	AXIS_DMI_MATCH("NC6730s", "HP Compaq 6730s", xy_swap),
-	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
-	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
-	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
-	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
-	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
+	AXIS_SYSFW_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
+	AXIS_SYSFW_MATCH("NC84x0", "HP Compaq nc84", z_inverted),
+	AXIS_SYSFW_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
+	AXIS_SYSFW_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
+	AXIS_SYSFW_MATCH("NC2510", "HP Compaq 2510", y_inverted),
+	AXIS_SYSFW_MATCH("NC2710", "HP Compaq 2710", xy_swap),
+	AXIS_SYSFW_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
+	AXIS_SYSFW_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	AXIS_SYSFW_MATCH("HP2140", "HP 2140", xy_swap_inverted),
+	AXIS_SYSFW_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
+	AXIS_SYSFW_MATCH("NC6730b", "HP Compaq 6730b", xy_rotated_left_usd),
+	AXIS_SYSFW_MATCH("NC6730s", "HP Compaq 6730s", xy_swap),
+	AXIS_SYSFW_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
+	AXIS_SYSFW_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
+	AXIS_SYSFW_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
+	AXIS_SYSFW_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
+	AXIS_SYSFW_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
 	/* Intel-based HP Pavilion dv5 */
-	AXIS_DMI_MATCH2("HPDV5_I",
-			PRODUCT_NAME, "HP Pavilion dv5",
-			BOARD_NAME, "3603",
-			x_inverted),
+	AXIS_SYSFW_MATCH2("HPDV5_I",
+			   PRODUCT_NAME, "HP Pavilion dv5",
+			   BOARD_NAME, "3603",
+			   x_inverted),
 	/* AMD-based HP Pavilion dv5 */
-	AXIS_DMI_MATCH2("HPDV5_A",
-			PRODUCT_NAME, "HP Pavilion dv5",
-			BOARD_NAME, "3600",
-			y_inverted),
-	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
-	AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
-	AXIS_DMI_MATCH("HDX18", "HP HDX 18", x_inverted),
-	AXIS_DMI_MATCH("HPB432x", "HP ProBook 432", xy_rotated_left),
-	AXIS_DMI_MATCH("HPB442x", "HP ProBook 442", xy_rotated_left),
-	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
-	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
-	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
-	AXIS_DMI_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
+	AXIS_SYSFW_MATCH2("HPDV5_A",
+			   PRODUCT_NAME, "HP Pavilion dv5",
+			   BOARD_NAME, "3600",
+			   y_inverted),
+	AXIS_SYSFW_MATCH("DV7", "HP Pavilion dv7", x_inverted),
+	AXIS_SYSFW_MATCH("HP8710", "HP Compaq 8710", y_inverted),
+	AXIS_SYSFW_MATCH("HDX18", "HP HDX 18", x_inverted),
+	AXIS_SYSFW_MATCH("HPB432x", "HP ProBook 432", xy_rotated_left),
+	AXIS_SYSFW_MATCH("HPB442x", "HP ProBook 442", xy_rotated_left),
+	AXIS_SYSFW_MATCH("HPB452x", "HP ProBook 452", y_inverted),
+	AXIS_SYSFW_MATCH("HPB522x", "HP ProBook 522", xy_swap),
+	AXIS_SYSFW_MATCH("HPB532x", "HP ProBook 532", y_inverted),
+	AXIS_SYSFW_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
@@ -307,7 +307,7 @@ static int lis3lv02d_add(struct acpi_device *device)
 	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
 		pr_info("Using custom axes %d,%d,%d\n",
 			lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
-	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
+	} else if (!sysfw_callback(lis3lv02d_ids)) {
 		pr_info("laptop model unknown, using default axes configuration\n");
 		lis3_dev.ac = lis3lv02d_axis_normal;
 	}
diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 811d436..570106c 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -29,14 +29,15 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/sysdev.h>
-#include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/mutex.h>
+#include <linux/sysfw.h>
+
 #include <asm/bios_ebda.h>
 
 static bool force;
 module_param(force, bool, 0);
-MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
+MODULE_PARM_DESC(force, "Force driver load, ignore SMBIOS data");
 
 static bool debug;
 module_param(debug, bool, 0644);
@@ -237,14 +238,14 @@ static void rtl_teardown_sysfs(void) {
 	sysdev_class_unregister(&class_rtl);
 }
 
-
-static struct dmi_system_id __initdata ibm_rtl_dmi_table[] = {
-	{                                                  \
-		.matches = {                               \
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),  \
-		},                                         \
+static struct sysfw_id __initdata ibm_rtl_smbios_table[] = {
+	{
+		.ident = "IBM",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "IBM"),
+		},
 	},
-	{ }
+	{}
 };
 
 static int __init ibm_rtl_init(void) {
@@ -255,7 +256,7 @@ static int __init ibm_rtl_init(void) {
 	if (force)
 		pr_warn("module loaded by force\n");
 	/* first ensure that we are running on IBM HW */
-	else if (efi_enabled || !dmi_check_system(ibm_rtl_dmi_table))
+	else if (efi_enabled || !sysfw_callback(ibm_rtl_smbios_table))
 		return -ENODEV;
 
 	/* Get the address for the Extended BIOS Data Area */
diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
index e936364..872c949 100644
--- a/drivers/platform/x86/intel_oaktrail.c
+++ b/drivers/platform/x86/intel_oaktrail.c
@@ -48,7 +48,7 @@
 #include <linux/i2c.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/rfkill.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -296,21 +296,21 @@ static struct platform_driver oaktrail_driver = {
 	.remove	= __devexit_p(oaktrail_remove)
 };
 
-static int dmi_check_cb(const struct dmi_system_id *id)
+static int system_check_cb(const struct sysfw_id *id)
 {
 	pr_info("Identified model '%s'\n", id->ident);
 	return 0;
 }
 
-static struct dmi_system_id __initdata oaktrail_dmi_table[] = {
+static struct sysfw_id __initdata oaktrail_system_table[] = {
 	{
 		.ident = "OakTrail platform",
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "OakTrail platform"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "OakTrail platform"),
 		},
-		.callback = dmi_check_cb
+		.callback = system_check_cb
 	},
-	{ }
+	{}
 };
 
 static int __init oaktrail_init(void)
@@ -322,7 +322,7 @@ static int __init oaktrail_init(void)
 		return -ENODEV;
 	}
 
-	if (!force && !dmi_check_system(oaktrail_dmi_table)) {
+	if (!force && !sysfw_callback(oaktrail_system_table)) {
 		pr_err("Platform not recognized (You could try the module's force-parameter)");
 		return -ENODEV;
 	}
@@ -393,4 +393,4 @@ MODULE_AUTHOR("Yin Kangkai (kangkai.yin@intel.com)");
 MODULE_DESCRIPTION("Intel Oaktrail Platform ACPI Extras");
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("dmi:*:svnIntelCorporation:pnOakTrailplatform:*");
+MODULE_ALIAS("sysfw:*:svnIntelCorporation:pnOakTrailplatform:*");
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 3ff629d..af5a8b2 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -47,7 +47,7 @@
  *
  * This driver might work on other laptops produced by MSI. If you
  * want to try it you can pass force=1 as argument to the module which
- * will force it to load even when the DMI data doesn't identify the
+ * will force it to load even when the SMBIOS data doesn't identify the
  * laptop as MSI S270. YMMV.
  */
 
@@ -57,7 +57,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
@@ -91,7 +91,7 @@ static int msi_laptop_resume(struct platform_device *device);
 
 static int force;
 module_param(force, bool, 0);
-MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
+MODULE_PARM_DESC(force, "Force driver load, ignore SMBIOS data");
 
 static int auto_brightness;
 module_param(auto_brightness, int, 0);
@@ -445,100 +445,103 @@ static struct platform_device *msipf_device;
 
 /* Initialization */
 
-static int dmi_check_cb(const struct dmi_system_id *id)
+static int id_check_cb(const struct sysfw_id *id)
 {
 	pr_info("Identified laptop model '%s'\n", id->ident);
 	return 1;
 }
 
-static struct dmi_system_id __initdata msi_dmi_table[] = {
+static struct sysfw_id __initdata msi_id_table[] = {
 	{
 		.ident = "MSI S270",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1013"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "MICRO-STAR INT'L CO.,LTD"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-1013"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0131"),
+			SYSFW_MATCH(SYSFW_CHASSIS_VENDOR,
+				    "MICRO-STAR INT'L CO.,LTD")
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "MSI S271",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1058"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0581"),
-			DMI_MATCH(DMI_BOARD_NAME, "MS-1058")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-1058"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0581"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "MS-1058")
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "MSI S420",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1412"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
-			DMI_MATCH(DMI_BOARD_NAME, "MS-1412")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-1412"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "MSI"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "MS-1412")
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "Medion MD96100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "NOTEBOOK"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SAM2000"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "NOTEBOOK"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "SAM2000"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0131"),
+			SYSFW_MATCH(SYSFW_CHASSIS_VENDOR,
+				    "MICRO-STAR INT'L CO.,LTD")
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
-	{ }
+	{}
 };
 
-static struct dmi_system_id __initdata msi_load_scm_models_dmi_table[] = {
+static struct sysfw_id __initdata msi_load_scm_models_id_table[] = {
 	{
 		.ident = "MSI N034",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-				"MICRO-STAR INTERNATIONAL CO., LTD"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-N034"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-			"MICRO-STAR INTERNATIONAL CO., LTD")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "MICRO-STAR INTERNATIONAL CO., LTD"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-N034"),
+			SYSFW_MATCH(SYSFW_CHASSIS_VENDOR,
+					    "MICRO-STAR INTERNATIONAL CO., LTD")
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "MSI N051",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-				"MICRO-STAR INTERNATIONAL CO., LTD"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-N051"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-			"MICRO-STAR INTERNATIONAL CO., LTD")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "MICRO-STAR INTERNATIONAL CO., LTD"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-N051"),
+			SYSFW_MATCH(SYSFW_CHASSIS_VENDOR,
+					    "MICRO-STAR INTERNATIONAL CO., LTD")
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "MSI N014",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-				"MICRO-STAR INTERNATIONAL CO., LTD"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-N014"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "MICRO-STAR INTERNATIONAL CO., LTD"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-N014"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
 	{
 		.ident = "MSI CR620",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-				"Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CR620"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "CR620"),
 		},
-		.callback = dmi_check_cb
+		.callback = id_check_cb
 	},
-	{ }
+	{}
 };
 
 static int rfkill_bluetooth_set(void *data, bool blocked)
@@ -860,13 +863,13 @@ static int __init msi_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	if (force || dmi_check_system(msi_dmi_table))
+	if (force || sysfw_callback(msi_id_table))
 		old_ec_model = 1;
 
 	if (!old_ec_model)
 		get_threeg_exists();
 
-	if (!old_ec_model && dmi_check_system(msi_load_scm_models_dmi_table))
+	if (!old_ec_model && sysfw_callback(msi_load_scm_models_id_table))
 		load_scm_model = 1;
 
 	if (auto_brightness < 0 || auto_brightness > 2)
@@ -988,11 +991,11 @@ MODULE_DESCRIPTION("MSI Laptop Support");
 MODULE_VERSION(MSI_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS("dmi:*:svnMICRO-STARINT'LCO.,LTD:pnMS-1013:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
-MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1058:pvr0581:rvnMSI:rnMS-1058:*:ct10:*");
-MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1412:*:rvnMSI:rnMS-1412:*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
-MODULE_ALIAS("dmi:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
-MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
-MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N051:*");
-MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N014:*");
-MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnCR620:*");
+MODULE_ALIAS("sysfw:*:svnMICRO-STARINT'LCO.,LTD:pnMS-1013:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
+MODULE_ALIAS("sysfw:*:svnMicro-StarInternational:pnMS-1058:pvr0581:rvnMSI:rnMS-1058:*:ct10:*");
+MODULE_ALIAS("sysfw:*:svnMicro-StarInternational:pnMS-1412:*:rvnMSI:rnMS-1412:*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
+MODULE_ALIAS("sysfw:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
+MODULE_ALIAS("sysfw:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
+MODULE_ALIAS("sysfw:*:svnMICRO-STARINTERNATIONAL*:pnMS-N051:*");
+MODULE_ALIAS("sysfw:*:svnMICRO-STARINTERNATIONAL*:pnMS-N014:*");
+MODULE_ALIAS("sysfw:*:svnMicro-StarInternational*:pnCR620:*");
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index d347116..80456c1 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -18,9 +18,9 @@
 #include <linux/pci.h>
 #include <linux/backlight.h>
 #include <linux/fb.h>
-#include <linux/dmi.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
+#include <linux/sysfw.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
@@ -230,7 +230,7 @@ static struct rfkill *rfk;
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force,
-		"Disable the DMI check and forces the driver to be loaded");
+		"Disable the SMBIOS check and forces the driver to be loaded");
 
 static int debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
@@ -492,183 +492,186 @@ static DEVICE_ATTR(performance_level, S_IWUSR | S_IRUGO,
 		   get_performance_level, set_performance_level);
 
 
-static int __init dmi_check_cb(const struct dmi_system_id *id)
+static int __init samsung_check_cb(const struct sysfw_id *id)
 {
-	pr_info("found laptop model '%s'\n",
-		id->ident);
+	pr_info("found laptop model '%s'\n", id->ident);
 	return 1;
 }
 
-static struct dmi_system_id __initdata samsung_dmi_table[] = {
+static struct sysfw_id __initdata samsung_id_table[] = {
 	{
 		.ident = "N128",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N128"),
-			DMI_MATCH(DMI_BOARD_NAME, "N128"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N128"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "N128"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "N130",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
-			DMI_MATCH(DMI_BOARD_NAME, "N130"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N130"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "N130"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "X125",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X125"),
-			DMI_MATCH(DMI_BOARD_NAME, "X125"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "X125"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "X125"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "X120/X170",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X120/X170"),
-			DMI_MATCH(DMI_BOARD_NAME, "X120/X170"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "X120/X170"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "X120/X170"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "NC10",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
-			DMI_MATCH(DMI_BOARD_NAME, "NC10"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "NC10"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "NC10"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 		{
 		.ident = "NP-Q45",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SQ45S70S"),
-			DMI_MATCH(DMI_BOARD_NAME, "SQ45S70S"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "SQ45S70S"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "SQ45S70S"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 		},
 	{
 		.ident = "X360",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
-			DMI_MATCH(DMI_BOARD_NAME, "X360"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "X360"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "X360"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "R410 Plus",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R410P"),
-			DMI_MATCH(DMI_BOARD_NAME, "R460"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "R410P"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "R460"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "R518",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R518"),
-			DMI_MATCH(DMI_BOARD_NAME, "R518"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "R518"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "R518"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "R519/R719",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R519/R719"),
-			DMI_MATCH(DMI_BOARD_NAME, "R519/R719"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "R519/R719"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "R519/R719"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "N150/N210/N220/N230",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220/N230"),
-			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220/N230"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N150/N210/N220/N230"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "N150/N210/N220/N230"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "N150P/N210P/N220P",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N150P/N210P/N220P"),
-			DMI_MATCH(DMI_BOARD_NAME, "N150P/N210P/N220P"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N150P/N210P/N220P"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "N150P/N210P/N220P"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "R530/R730",
 		.matches = {
-		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-		      DMI_MATCH(DMI_PRODUCT_NAME, "R530/R730"),
-		      DMI_MATCH(DMI_BOARD_NAME, "R530/R730"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					  "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "R530/R730"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "R530/R730"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "NF110/NF210/NF310",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
-			DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "NF110/NF210/NF310"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "NF110/NF210/NF310"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "N145P/N250P/N260P",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
-			DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N145P/N250P/N260P"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "N145P/N250P/N260P"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "R70/R71",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R70/R71"),
-			DMI_MATCH(DMI_BOARD_NAME, "R70/R71"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "R70/R71"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "R70/R71"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
 	{
 		.ident = "P460",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P460"),
-			DMI_MATCH(DMI_BOARD_NAME, "P460"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "P460"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "P460"),
 		},
-		.callback = dmi_check_cb,
+		.callback = samsung_check_cb,
 	},
-	{ },
+	{},
 };
-MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
+MODULE_DEVICE_TABLE(sysfw, samsung_id_table);
 
 static int find_signature(void __iomem *memcheck, const char *testStr)
 {
@@ -700,7 +703,7 @@ static int __init samsung_init(void)
 
 	mutex_init(&sabi_mutex);
 
-	if (!force && !dmi_check_system(samsung_dmi_table))
+	if (!force && !sysfw_callback(samsung_id_table))
 		return -ENODEV;
 
 	f0000_segment = ioremap_nocache(0xf0000, 0xffff);
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index bbd182e..b708f04 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -52,7 +52,7 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -3385,29 +3385,29 @@ static struct acpi_driver sony_pic_driver = {
 		},
 };
 
-static struct dmi_system_id __initdata sonypi_dmi_table[] = {
+static struct sysfw_id __initdata sonypi_id_table[] = {
 	{
 		.ident = "Sony Vaio",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PCG-"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "PCG-"),
 		},
 	},
 	{
 		.ident = "Sony Vaio",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int __init sony_laptop_init(void)
 {
 	int result;
 
-	if (!no_spic && dmi_check_system(sonypi_dmi_table)) {
+	if (!no_spic && sysfw_callback(sonypi_id_table)) {
 		result = acpi_bus_register_driver(&sony_pic_driver);
 		if (result) {
 			pr_err("Unable to register SPIC driver\n");
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 77f6e70..a4008e9 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -76,7 +76,8 @@
 #include <linux/rfkill.h>
 #include <asm/uaccess.h>
 
-#include <linux/dmi.h>
+#include <linux/smbios.h>
+#include <linux/sysfw.h>
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 
@@ -1763,7 +1764,7 @@ static const struct tpacpi_quirk tpacpi_bios_version_qtable[] __initconst = {
 	TPV_QL1('7', 'B',  'D', '7',  '4', '0'), /* X60/s */
 	TPV_QL1('7', 'J',  '3', '0',  '1', '3'), /* X60t */
 
-	/* (0) - older versions lack DMI EC fw string and functionality */
+	/* (0) - older versions lack SMBIOS EC fw string and functionality */
 	/* (1) - older versions known to lack functionality */
 };
 
@@ -8543,7 +8544,6 @@ static bool __pure __init tpacpi_is_valid_fw_id(const char* const s,
 static int __must_check __init get_thinkpad_model_data(
 						struct thinkpad_id_data *tp)
 {
-	const struct dmi_device *dev = NULL;
 	char ec_fw_string[18];
 	char const *s;
 
@@ -8552,14 +8552,14 @@ static int __must_check __init get_thinkpad_model_data(
 
 	memset(tp, 0, sizeof(*tp));
 
-	if (dmi_name_in_vendors("IBM"))
+	if (sysfw_vendor_is("IBM"))
 		tp->vendor = PCI_VENDOR_ID_IBM;
-	else if (dmi_name_in_vendors("LENOVO"))
+	else if (sysfw_vendor_is("LENOVO"))
 		tp->vendor = PCI_VENDOR_ID_LENOVO;
 	else
 		return 0;
 
-	s = dmi_get_system_info(DMI_BIOS_VERSION);
+	s = sysfw_lookup(SYSFW_BIOS_VERSION);
 	tp->bios_version_str = kstrdup(s, GFP_KERNEL);
 	if (s && !tp->bios_version_str)
 		return -ENOMEM;
@@ -8580,41 +8580,37 @@ static int __must_check __init get_thinkpad_model_data(
 	 *
 	 * See http://thinkwiki.org/wiki/List_of_DMI_IDs
 	 */
-	while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING, NULL, dev))) {
-		if (sscanf(dev->name,
-			   "IBM ThinkPad Embedded Controller -[%17c",
-			   ec_fw_string) == 1) {
-			ec_fw_string[sizeof(ec_fw_string) - 1] = 0;
-			ec_fw_string[strcspn(ec_fw_string, " ]")] = 0;
-
-			tp->ec_version_str = kstrdup(ec_fw_string, GFP_KERNEL);
-			if (!tp->ec_version_str)
-				return -ENOMEM;
-
-			if (tpacpi_is_valid_fw_id(ec_fw_string, 'H')) {
-				tp->ec_model = ec_fw_string[0]
-						| (ec_fw_string[1] << 8);
-				tp->ec_release = (ec_fw_string[4] << 8)
-						| ec_fw_string[5];
-			} else {
-				pr_notice("ThinkPad firmware release %s "
-					  "doesn't match the known patterns\n",
-					  ec_fw_string);
-				pr_notice("please report this to %s\n",
-					  TPACPI_MAIL);
-			}
-			break;
+	s = smbios_match_oem_string("IBM ThinkPad Embedded Controller -[");
+	if (sscanf(s, "IBM ThinkPad Embedded Controller -[%17c",
+		   ec_fw_string) == 1) {
+		ec_fw_string[sizeof(ec_fw_string) - 1] = 0;
+		ec_fw_string[strcspn(ec_fw_string, " ]")] = 0;
+
+		tp->ec_version_str = kstrdup(ec_fw_string, GFP_KERNEL);
+		if (!tp->ec_version_str)
+			return -ENOMEM;
+
+		if (tpacpi_is_valid_fw_id(ec_fw_string, 'H')) {
+			tp->ec_model = ec_fw_string[0]
+					| (ec_fw_string[1] << 8);
+			tp->ec_release = (ec_fw_string[4] << 8)
+					| ec_fw_string[5];
+		} else {
+			pr_notice("ThinkPad firmware release %s "
+				  "doesn't match the known patterns\n",
+				  ec_fw_string);
+			pr_notice("please report this to %s\n", TPACPI_MAIL);
 		}
 	}
 
-	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
+	s = sysfw_lookup(SYSFW_PRODUCT_VERSION);
 	if (s && !strnicmp(s, "ThinkPad", 8)) {
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
 			return -ENOMEM;
 	}
 
-	s = dmi_get_system_info(DMI_PRODUCT_NAME);
+	s = sysfw_lookup(SYSFW_PRODUCT_NAME);
 	tp->nummodel_str = kstrdup(s, GFP_KERNEL);
 	if (s && !tp->nummodel_str)
 		return -ENOMEM;
@@ -8634,7 +8630,7 @@ static int __init probe_for_thinkpad(void)
 		return -ENODEV;
 
 	/*
-	 * Non-ancient models have better DMI tagging, but very old models
+	 * Non-ancient models have better SMBIOS tagging, but very old models
 	 * don't.  tpacpi_is_fw_known() is a cheat to help in that case.
 	 */
 	is_thinkpad = (thinkpad_id.model_str != NULL) ||
@@ -9089,7 +9085,7 @@ MODULE_ALIAS(TPACPI_DRVR_SHORTNAME);
 MODULE_DEVICE_TABLE(acpi, ibm_htk_device_ids);
 
 /*
- * DMI matching for module autoloading
+ * SMBIOS matching for module autoloading
  *
  * See http://thinkwiki.org/wiki/List_of_DMI_IDs
  * See http://thinkwiki.org/wiki/BIOS_Upgrade_Downloads
@@ -9098,7 +9094,7 @@ MODULE_DEVICE_TABLE(acpi, ibm_htk_device_ids);
  * if it is not there yet.
  */
 #define IBM_BIOS_MODULE_ALIAS(__type) \
-	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW*")
+	MODULE_ALIAS("sysfw:bvnIBM:bvr" __type "ET??WW*")
 
 /* Ancient thinkpad BIOSes have to be identified by
  * BIOS type or model number, and there are far less
-- 
1.7.5.4

