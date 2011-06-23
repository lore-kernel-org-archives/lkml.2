Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab1FWRXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab1FWRXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:38 -0400
Date: Thu, 23 Jun 2011 13:23:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172336.27679.6981.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 14/35] drivers/input changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/input changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/input/keyboard/atkbd.c        |   80 ++++----
 drivers/input/misc/wistron_btns.c     |  239 +++++++++++-----------
 drivers/input/mouse/lifebook.c        |   42 ++--
 drivers/input/mouse/synaptics.c       |   44 ++--
 drivers/input/serio/i8042-x86ia64io.h |  367 +++++++++++++++++----------------
 drivers/input/tablet/wacom.h          |    1 -
 drivers/input/touchscreen/htcpen.c    |   13 +-
 7 files changed, 405 insertions(+), 381 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 11478eb..b66c8dd 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -27,7 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/libps2.h>
 #include <linux/mutex.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define DRIVER_DESC	"AT and PS/2 keyboard driver"
 
@@ -1573,7 +1573,7 @@ static ssize_t atkbd_show_err_count(struct atkbd *atkbd, char *buf)
 	return sprintf(buf, "%lu\n", atkbd->err_count);
 }
 
-static int __init atkbd_setup_forced_release(const struct dmi_system_id *id)
+static int __init atkbd_setup_forced_release(const struct sysfw_id *id)
 {
 	atkbd_platform_fixup = atkbd_apply_forced_release_keylist;
 	atkbd_platform_fixup_data = id->driver_data;
@@ -1581,66 +1581,67 @@ static int __init atkbd_setup_forced_release(const struct dmi_system_id *id)
 	return 0;
 }
 
-static int __init atkbd_setup_scancode_fixup(const struct dmi_system_id *id)
+static int __init atkbd_setup_scancode_fixup(const struct sysfw_id *id)
 {
 	atkbd_platform_scancode_fixup = id->driver_data;
 
 	return 0;
 }
 
-static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
+static const struct sysfw_id atkbd_id_quirk_table[] __initconst = {
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "8"), /* Portable */
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_dell_laptop_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Dell Computer Corporation"),
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "8"), /* Portable */
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_dell_laptop_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP 2133"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "HP 2133"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_hp_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion ZV6100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Pavilion ZV6100"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_volume_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Presario R4000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Presario R4000"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_volume_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Presario R4100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Presario R4100"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_volume_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Presario R4200"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Presario R4200"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_volume_forced_release_keys,
@@ -1648,8 +1649,8 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Inventec Symphony */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "INVENTEC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SYMPHONY 6.0/7.0"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "INVENTEC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "SYMPHONY 6.0/7.0"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_volume_forced_release_keys,
@@ -1657,8 +1658,9 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Samsung NC10 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "NC10"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_samsung_forced_release_keys,
@@ -1666,8 +1668,9 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Samsung NC20 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NC20"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "NC20"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_samsung_forced_release_keys,
@@ -1675,8 +1678,9 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Samsung SQ45S70S */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SQ45S70S"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "SAMSUNG ELECTRONICS CO., LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "SQ45S70S"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_samsung_forced_release_keys,
@@ -1684,8 +1688,8 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Fujitsu Amilo PA 1510 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pa 1510"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Pa 1510"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_volume_forced_release_keys,
@@ -1693,8 +1697,8 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Fujitsu Amilo Pi 3525 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pi 3525"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Pi 3525"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_amilo_pi3525_forced_release_keys,
@@ -1702,16 +1706,16 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* Fujitsu Amilo Xi 3650 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xi 3650"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Xi 3650"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_amilo_xi3650_forced_release_keys,
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Soltech Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TA12"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Soltech Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TA12"),
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkdb_soltech_ta12_forced_release_keys,
@@ -1719,18 +1723,18 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		/* OQO Model 01+ */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OQO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPTO"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "OQO"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "ZEPTO"),
 		},
 		.callback = atkbd_setup_scancode_fixup,
 		.driver_data = atkbd_oqo_01plus_scancode_fixup,
 	},
-	{ }
+	{}
 };
 
 static int __init atkbd_init(void)
 {
-	dmi_check_system(atkbd_dmi_quirk_table);
+	sysfw_callback(atkbd_id_quirk_table);
 
 	return serio_register_driver(&atkbd_drv);
 }
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index 52b4193..f4aabda 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -18,7 +18,7 @@
  * 59 Temple Place Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/io.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/init.h>
 #include <linux/input-polldev.h>
 #include <linux/input/sparse-keymap.h>
@@ -238,11 +238,11 @@ static bool have_wifi;
 static bool have_bluetooth;
 static int leds_present;	/* bitmask of leds present */
 
-static int __init dmi_matched(const struct dmi_system_id *dmi)
+static int __init sysfw_matched(const struct sysfw_id *id)
 {
 	const struct key_entry *key;
 
-	keymap = dmi->driver_data;
+	keymap = id->driver_data;
 	for (key = keymap; key->type != KE_END; key++) {
 		if (key->type == KE_WIFI)
 			have_wifi = true;
@@ -635,342 +635,345 @@ static struct key_entry keymap_prestigio[] __initdata = {
  * a list of buttons and their key codes (reported when loading this module
  * with force=1) and the output of dmidecode to $MODULE_AUTHOR.
  */
-static const struct dmi_system_id __initconst dmi_ids[] = {
+static const struct sysfw_id __initconst sysfw_ids[] = {
 	{
 		/* Fujitsu-Siemens Amilo Pro V2000 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Pro V2000"),
 		},
 		.driver_data = keymap_fs_amilo_pro_v2000
 	},
 	{
 		/* Fujitsu-Siemens Amilo Pro Edition V3505 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro Edition V3505"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "AMILO Pro Edition V3505"),
 		},
 		.driver_data = keymap_fs_amilo_pro_v3505
 	},
 	{
 		/* Fujitsu-Siemens Amilo M7400 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO M        "),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO M        "),
 		},
 		.driver_data = keymap_fs_amilo_pro_v2000
 	},
 	{
 		/* Maxdata Pro 7000 DX */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MAXDATA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pro 7000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MAXDATA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Pro 7000"),
 		},
 		.driver_data = keymap_fs_amilo_pro_v2000
 	},
 	{
 		/* Fujitsu N3510 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N3510"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N3510"),
 		},
 		.driver_data = keymap_fujitsu_n3510
 	},
 	{
 		/* Acer Aspire 1500 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1500"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 1500"),
 		},
 		.driver_data = keymap_acer_aspire_1500
 	},
 	{
 		/* Acer Aspire 1600 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1600"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 1600"),
 		},
 		.driver_data = keymap_acer_aspire_1600
 	},
 	{
 		/* Acer Aspire 3020 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3020"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 3020"),
 		},
 		.driver_data = keymap_acer_aspire_5020
 	},
 	{
 		/* Acer Aspire 5020 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5020"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5020"),
 		},
 		.driver_data = keymap_acer_aspire_5020
 	},
 	{
 		/* Acer TravelMate 2100 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 2100"),
 		},
 		.driver_data = keymap_acer_aspire_5020
 	},
 	{
 		/* Acer TravelMate 2410 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2410"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 2410"),
 		},
 		.driver_data = keymap_acer_travelmate_2410
 	},
 	{
 		/* Acer TravelMate C300 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C300"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate C300"),
 		},
 		.driver_data = keymap_acer_travelmate_300
 	},
 	{
 		/* Acer TravelMate C100 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate C100"),
 		},
 		.driver_data = keymap_acer_travelmate_300
 	},
 	{
 		/* Acer TravelMate C110 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate C110"),
 		},
 		.driver_data = keymap_acer_travelmate_110
 	},
 	{
 		/* Acer TravelMate 380 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 380"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 380"),
 		},
 		.driver_data = keymap_acer_travelmate_380
 	},
 	{
 		/* Acer TravelMate 370 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 370"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 370"),
 		},
-		.driver_data = keymap_acer_travelmate_380 /* keyboard minus 1 key */
+		/* keyboard minus 1 key */
+		.driver_data = keymap_acer_travelmate_380
 	},
 	{
 		/* Acer TravelMate 220 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 220"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 220"),
 		},
 		.driver_data = keymap_acer_travelmate_220
 	},
 	{
 		/* Acer TravelMate 260 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 260"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 260"),
 		},
 		.driver_data = keymap_acer_travelmate_220
 	},
 	{
 		/* Acer TravelMate 230 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 230"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 230"),
 			/* acerhk looks for "TravelMate F4..." ?! */
 		},
 		.driver_data = keymap_acer_travelmate_230
 	},
 	{
 		/* Acer TravelMate 280 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 280"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 280"),
 		},
 		.driver_data = keymap_acer_travelmate_230
 	},
 	{
 		/* Acer TravelMate 240 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 240"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 240"),
 		},
 		.driver_data = keymap_acer_travelmate_240
 	},
 	{
 		/* Acer TravelMate 250 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 250"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 250"),
 		},
 		.driver_data = keymap_acer_travelmate_240
 	},
 	{
 		/* Acer TravelMate 2424NWXCi */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2420"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 2420"),
 		},
 		.driver_data = keymap_acer_travelmate_240
 	},
 	{
 		/* Acer TravelMate 350 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 350"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 350"),
 		},
 		.driver_data = keymap_acer_travelmate_350
 	},
 	{
 		/* Acer TravelMate 360 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 360"),
 		},
 		.driver_data = keymap_acer_travelmate_360
 	},
 	{
 		/* Acer TravelMate 610 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 610"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ACER"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 610"),
 		},
 		.driver_data = keymap_acer_travelmate_610
 	},
 	{
 		/* Acer TravelMate 620 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 620"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 620"),
 		},
 		.driver_data = keymap_acer_travelmate_630
 	},
 	{
 		/* Acer TravelMate 630 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 630"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 630"),
 		},
 		.driver_data = keymap_acer_travelmate_630
 	},
 	{
 		/* AOpen 1559AS */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "E2U"),
-			DMI_MATCH(DMI_BOARD_NAME, "E2U"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "E2U"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "E2U"),
 		},
 		.driver_data = keymap_aopen_1559as
 	},
 	{
 		/* Medion MD 9783 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MD 9783"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDIONNB"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MD 9783"),
 		},
 		.driver_data = keymap_wistron_ms2111
 	},
 	{
 		/* Medion MD 40100 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "WID2000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDIONNB"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "WID2000"),
 		},
 		.driver_data = keymap_wistron_md40100
 	},
 	{
 		/* Medion MD 2900 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDIONNB"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "WIM 2000"),
 		},
 		.driver_data = keymap_wistron_md2900
 	},
 	{
 		/* Medion MD 42200 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2030"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Medion"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "WIM 2030"),
 		},
 		.driver_data = keymap_fs_amilo_pro_v2000
 	},
 	{
 		/* Medion MD 96500 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONPC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2040"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDIONPC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "WIM 2040"),
 		},
 		.driver_data = keymap_wistron_md96500
 	},
 	{
 		/* Medion MD 95400 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONPC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2050"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDIONPC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "WIM 2050"),
 		},
 		.driver_data = keymap_wistron_md96500
 	},
 	{
 		/* Fujitsu Siemens Amilo D7820 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"), /* not sure */
-			DMI_MATCH(DMI_PRODUCT_NAME, "Amilo D"),
+			/* not sure */
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Amilo D"),
 		},
 		.driver_data = keymap_fs_amilo_d88x0
 	},
 	{
 		/* Fujitsu Siemens Amilo D88x0 */
-		.callback = dmi_matched,
+		.callback = sysfw_matched,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO D"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO D"),
 		},
 		.driver_data = keymap_fs_amilo_d88x0
 	},
-	{ NULL, }
+	{}
 };
 
 /* Copy the good keymap, as the original ones are free'd */
@@ -995,7 +998,7 @@ static int __init copy_keymap(void)
 
 static int __init select_keymap(void)
 {
-	dmi_check_system(dmi_ids);
+	sysfw_callback(sysfw_ids);
 	if (keymap_name != NULL) {
 		if (strcmp (keymap_name, "1557/MS2141") == 0)
 			keymap = keymap_wistron_ms2141;
diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index c31ad11..37af398 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -15,8 +15,8 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
-#include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/sysfw.h>
 
 #include "psmouse.h"
 #include "lifebook.h"
@@ -30,7 +30,7 @@ static bool lifebook_present;
 
 static const char *desired_serio_phys;
 
-static int lifebook_limit_serio3(const struct dmi_system_id *d)
+static int lifebook_limit_serio3(const struct sysfw_id *d)
 {
 	desired_serio_phys = "isa0060/serio3";
 	return 0;
@@ -38,97 +38,99 @@ static int lifebook_limit_serio3(const struct dmi_system_id *d)
 
 static bool lifebook_use_6byte_proto;
 
-static int lifebook_set_6byte_proto(const struct dmi_system_id *d)
+static int lifebook_set_6byte_proto(const struct sysfw_id *d)
 {
 	lifebook_use_6byte_proto = true;
 	return 0;
 }
 
-static const struct dmi_system_id __initconst lifebook_dmi_table[] = {
+static const struct sysfw_id __initconst lifebook_smbios_table[] = {
 	{
 		/* FLORA-ie 55mi */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "FLORA-ie 55mi"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "FLORA-ie 55mi"),
 		},
 	},
 	{
 		/* LifeBook B */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lifebook B Series"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Lifebook B Series"),
 		},
 	},
 	{
 		/* LifeBook B */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B Series"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LifeBook B Series"),
 		},
 	},
 	{
 		/* Lifebook B */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK B Series"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LIFEBOOK B Series"),
 		},
 	},
 	{
 		/* Lifebook B-2130 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "ZEPHYR"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "ZEPHYR"),
 		},
 	},
 	{
 		/* Lifebook B213x/B2150 */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B2131/B2133/B2150"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "LifeBook B2131/B2133/B2150"),
 		},
 	},
 	{
 		/* Zephyr */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPHYR"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "ZEPHYR"),
 		},
 	},
 	{
 		/* Panasonic CF-18 */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "CF-18"),
 		},
 		.callback = lifebook_limit_serio3,
 	},
 	{
 		/* Panasonic CF-28 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-28"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Matsushita"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "CF-28"),
 		},
 		.callback = lifebook_set_6byte_proto,
 	},
 	{
 		/* Panasonic CF-29 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Matsushita"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "CF-29"),
 		},
 		.callback = lifebook_set_6byte_proto,
 	},
 	{
 		/* Panasonic CF-72 */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-72"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "CF-72"),
 		},
 		.callback = lifebook_set_6byte_proto,
 	},
 	{
 		/* Lifebook B142 */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B142"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LifeBook B142"),
 		},
 	},
-	{ }
+	{}
 };
 
 void __init lifebook_module_init(void)
 {
-	lifebook_present = dmi_check_system(lifebook_dmi_table);
+	if (sysfw_callback(lifebook_smbios_table))
+		lifebook_present = 1;
 }
 
 static psmouse_ret_t lifebook_process_byte(struct psmouse *psmouse)
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index e06e045..ac7fc41 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -24,7 +24,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/input/mt.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
@@ -803,62 +803,64 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 
 static bool impaired_toshiba_kbc;
 
-static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
-#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+static const struct sysfw_id __initconst toshiba_smbios_table[] = {
+#ifdef CONFIG_X86
 	{
 		/* Toshiba Satellite */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Satellite"),
 		},
 	},
 	{
 		/* Toshiba Dynabook */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "dynabook"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "dynabook"),
 		},
 	},
 	{
 		/* Toshiba Portege M300 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M300"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "PORTEGE M300"),
 		},
 
 	},
 	{
 		/* Toshiba Portege M300 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Portable PC"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Version 1.0"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Portable PC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "Version 1.0"),
 		},
 
 	},
 #endif
-	{ }
+	{}
 };
 
 static bool broken_olpc_ec;
 
-static const struct dmi_system_id __initconst olpc_dmi_table[] = {
-#if defined(CONFIG_DMI) && defined(CONFIG_OLPC)
+static const struct sysfw_id __initconst olpc_smbios_table[] = {
+#ifdef CONFIG_OLPC
 	{
 		/* OLPC XO-1 or XO-1.5 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "OLPC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "XO"),
 		},
 	},
 #endif
-	{ }
+	{}
 };
 
 void __init synaptics_module_init(void)
 {
-	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
-	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
+	if (sysfw_callback(toshiba_smbios_table))
+		impaired_toshiba_kbc = 1;
+	if (sysfw_callback(olpc_smbios_table))
+		broken_olpc_ec = 1;
 }
 
 int synaptics_init(struct psmouse *psmouse)
@@ -938,7 +940,7 @@ int synaptics_init(struct psmouse *psmouse)
 	 */
 	if (psmouse->rate >= 80 && impaired_toshiba_kbc) {
 		printk(KERN_INFO "synaptics: Toshiba %s detected, limiting rate to 40pps.\n",
-			dmi_get_system_info(DMI_PRODUCT_NAME));
+			sysfw_lookup(SYSFW_PRODUCT_NAME));
 		psmouse->rate = 40;
 	}
 
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index bb9f5d3..8a8e2d2 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -69,121 +69,125 @@ static inline void i8042_write_command(int val)
 
 #ifdef CONFIG_X86
 
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
-static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
+static const struct sysfw_id __initconst i8042_id_noloop_table[] = {
 	{
 		/*
 		 * Arima-Rioworks HDAMB -
 		 * AUX LOOP command does not raise AUX IRQ
 		 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "RIOWORKS"),
-			DMI_MATCH(DMI_BOARD_NAME, "HDAMB"),
-			DMI_MATCH(DMI_BOARD_VERSION, "Rev E"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "RIOWORKS"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "HDAMB"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "Rev E"),
 		},
 	},
 	{
 		/* ASUS G1S */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "G1S"),
-			DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "G1S"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "1.0"),
 		},
 	},
 	{
 		/* ASUS P65UP5 - AUX LOOP command does not raise AUX IRQ */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "P/I-P65UP5"),
-			DMI_MATCH(DMI_BOARD_VERSION, "REV 2.X"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "ASUSTeK Computer INC."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "P/I-P65UP5"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "REV 2.X"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Compaq"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME , "ProLiant"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "8500"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "DL760"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Compaq"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME , "ProLiant"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "DL760"),
 		},
 	},
 	{
 		/* OQO Model 01 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OQO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPTO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "00"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "OQO"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "ZEPTO"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "00"),
 		},
 	},
 	{
 		/* ULI EV4873 - AUX LOOP does not work properly */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ULI"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EV4873"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ULI"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "EV4873"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "5a"),
 		},
 	},
 	{
 		/* Microsoft Virtual Machine */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Microsoft Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "VS2005R2"),
 		},
 	},
 	{
 		/* Medion MAM 2070 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MAM 2070"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Notebook"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MAM 2070"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "5a"),
 		},
 	},
 	{
 		/* Blue FB5601 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "blue"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "FB5601"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "M606"),
 		},
 	},
 	{
 		/* Gigabyte M912 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M912"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "GIGABYTE"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "M912"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "01"),
 		},
 	},
 	{
 		/* Gigabyte M1022M netbook */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co.,Ltd."),
-			DMI_MATCH(DMI_BOARD_NAME, "M1022E"),
-			DMI_MATCH(DMI_BOARD_VERSION, "1.02"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "Gigabyte Technology Co.,Ltd."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "M1022E"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "1.02"),
 		},
 	},
 	{
 		/* Gigabyte Spring Peak - defines wrong chassis type */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Spring Peak"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "GIGABYTE"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Spring Peak"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev 1"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "HP Pavilion dv9700"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "Rev 1"),
 		},
 	},
-	{ }
+	{}
 };
 
 /*
@@ -193,75 +197,75 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
  * ... apparently some Toshibas don't like MUX mode either and
  * die horrible death on reboot.
  */
-static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
+static const struct sysfw_id __initconst i8042_id_nomux_table[] = {
 	{
 		/* Fujitsu Lifebook P7010/P7010D */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P7010"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "P7010"),
 		},
 	},
 	{
 		/* Fujitsu Lifebook P7010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "0000000000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "0000000000"),
 		},
 	},
 	{
 		/* Fujitsu Lifebook P5020D */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P Series"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LifeBook P Series"),
 		},
 	},
 	{
 		/* Fujitsu Lifebook S2000 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LifeBook S Series"),
 		},
 	},
 	{
 		/* Fujitsu Lifebook S6230 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S6230"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LifeBook S6230"),
 		},
 	},
 	{
 		/* Fujitsu T70H */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FMVLT70H"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "FMVLT70H"),
 		},
 	},
 	{
 		/* Fujitsu-Siemens Lifebook T3010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T3010"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LIFEBOOK T3010"),
 		},
 	},
 	{
 		/* Fujitsu-Siemens Lifebook E4010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E4010"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "LIFEBOOK E4010"),
 		},
 	},
 	{
 		/* Fujitsu-Siemens Amilo Pro 2010 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Pro V2010"),
 		},
 	},
 	{
 		/* Fujitsu-Siemens Amilo Pro 2030 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO PRO V2030"),
 		},
 	},
 	{
@@ -271,8 +275,8 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		 */
 		/* Panasonic CF-29 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Matsushita"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "CF-29"),
 		},
 	},
 	{
@@ -282,8 +286,9 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		 * causing "spurious NAK" messages.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EA032EA#ABF)"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "Pavilion dv4000 (EA032EA#ABF)"),
 		},
 	},
 	{
@@ -292,9 +297,11 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Notebook PC"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook ZT1000"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "HP Pavilion Notebook PC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION,
+				    "HP Pavilion Notebook ZT1000"),
 		},
 	},
 	{
@@ -303,40 +310,41 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "Pavilion dv4000 (EH476UA#ABL)"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P10"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Satellite P10"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EQUIUM A110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "EQUIUM A110"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ALIENWARE"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Sentia"),
 		},
 	},
 	{
 		/* Sharp Actius MM20 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-MM20 Series"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "SHARP"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "PC-MM20 Series"),
 		},
 	},
 	{
 		/* Sony Vaio FS-115b */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FS115B"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-FS115B"),
 		},
 	},
 	{
@@ -346,8 +354,8 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		 * sometimes being delivered to AUX3.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-FZ240E"),
 		},
 	},
 	{
@@ -357,210 +365,215 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		 * MUX discovery usually messes up keyboard/touchpad.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "VAIO"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "VAIO"),
 		},
 	},
 	{
 		/* Amoi M636/A737 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				     "Amoi Electronics CO.,LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "M636/A737 platform"),
 		},
 	},
 	{
 		/* Lenovo 3000 n100 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "LENOVO"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "076804U"),
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 1360"),
 		},
 	},
 	{
 		/* Gericom Bellagio */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Gericom"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N34AS6"),
 		},
 	},
 	{
 		/* IBM 2656 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "IBM"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "2656"),
 		},
 	},
 	{
 		/* Dell XPS M1530 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "XPS M1530"),
 		},
 	},
 	{
 		/* Compal HEL80I */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "COMPAL"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HEL80I"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "COMPAL"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "HEL80I"),
 		},
 	},
 	{
 		/* Dell Vostro 1510 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro1510"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro1510"),
 		},
 	},
 	{
 		/* Acer Aspire 5536 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5536"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5536"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0100"),
 		},
 	},
 	{
 		/* Dell Vostro V13 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro V13"),
 		},
 	},
-	{ }
+	{}
 };
 
-static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
+static const struct sysfw_id __initconst i8042_id_reset_table[] = {
 	{
 		/* MSI Wind U-100 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "U-100"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "MICRO-STAR INTERNATIONAL CO., LTD"),
 		},
 	},
 	{
 		/* LG Electronics X110 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "X110"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "X110"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				     "LG Electronics Inc."),
 		},
 	},
 	{
 		/* Acer Aspire One 150 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AOA150"),
 		},
 	},
 	{
 		/* Advent 4211 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "DIXONSXP"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Advent 4211"),
 		},
 	},
 	{
 		/* Medion Akoya Mini E1210 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "E1210"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDION"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "E1210"),
 		},
 	},
 	{
 		/* Medion Akoya E1222 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "E122X"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDION"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "E122X"),
 		},
 	},
 	{
 		/* Mivvy M310 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "VIOOO"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "N10"),
 		},
 	},
 	{
 		/* Dell Vostro 1320 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1320"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro 1320"),
 		},
 	},
 	{
 		/* Dell Vostro 1520 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro 1520"),
 		},
 	},
 	{
 		/* Dell Vostro 1720 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro 1720"),
 		},
 	},
-	{ }
+	{}
 };
 
 #ifdef CONFIG_PNP
-static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
+static const struct sysfw_id __initconst i8042_id_nopnp_table[] = {
 	{
 		/* Intel MBO Desktop D845PESV */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "D845PESV"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Intel Corporation"),
 		},
 	},
 	{
 		/* MSI Wind U-100 */
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "U-100"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				     "MICRO-STAR INTERNATIONAL CO., LTD"),
 		},
 	},
-	{ }
+	{}
 };
 
-static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
+static const struct sysfw_id __initconst i8042_id_laptop_table[] = {
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "8"), /* Portable */
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /* Laptop */
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "9"), /* Laptop */
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "10"), /* Notebook */
 		},
 	},
 	{
 		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
+			/* Sub-Notebook */
+			SYSFW_MATCH(SYSFW_CHASSIS_TYPE, "14"),
 		},
 	},
-	{ }
+	{}
 };
 #endif
 
-static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
+static const struct sysfw_id __initconst i8042_id_notimeout_table[] = {
 	{
 		/* Dell Vostro V13 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro V13"),
 		},
 	},
-	{ }
+	{}
 };
 
 /*
@@ -569,78 +582,78 @@ static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
  * Originally, this was just confined to older laptops, but a few Acer laptops
  * have turned up in 2007 that also need this again.
  */
-static const struct dmi_system_id __initconst i8042_dmi_dritek_table[] = {
+static const struct sysfw_id __initconst i8042_id_dritek_table[] = {
 	{
 		/* Acer Aspire 5100 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5100"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5100"),
 		},
 	},
 	{
 		/* Acer Aspire 5610 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5610"),
 		},
 	},
 	{
 		/* Acer Aspire 5630 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5630"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5630"),
 		},
 	},
 	{
 		/* Acer Aspire 5650 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5650"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5650"),
 		},
 	},
 	{
 		/* Acer Aspire 5680 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5680"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5680"),
 		},
 	},
 	{
 		/* Acer Aspire 5720 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5720"),
 		},
 	},
 	{
 		/* Acer Aspire 9110 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 9110"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 9110"),
 		},
 	},
 	{
 		/* Acer TravelMate 660 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 660"),
 		},
 	},
 	{
 		/* Acer TravelMate 2490 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2490"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 2490"),
 		},
 	},
 	{
 		/* Acer TravelMate 4280 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 4280"),
 		},
 	},
-	{ }
+	{}
 };
 
 #endif /* CONFIG_X86 */
@@ -772,7 +785,7 @@ static int __init i8042_pnp_init(void)
 	int err;
 
 #ifdef CONFIG_X86
-	if (dmi_check_system(i8042_dmi_nopnp_table))
+	if (sysfw_callback(i8042_id_nopnp_table))
 		i8042_nopnp = true;
 #endif
 
@@ -864,7 +877,7 @@ static int __init i8042_pnp_init(void)
 
 #ifdef CONFIG_X86
 	i8042_bypass_aux_irq_test = !pnp_data_busted &&
-				    dmi_check_system(i8042_dmi_laptop_table);
+				    sysfw_callback(i8042_id_laptop_table);
 #endif
 
 	return 0;
@@ -905,19 +918,19 @@ static int __init i8042_platform_init(void)
 #endif
 
 #ifdef CONFIG_X86
-	if (dmi_check_system(i8042_dmi_reset_table))
+	if (sysfw_callback(i8042_id_reset_table))
 		i8042_reset = true;
 
-	if (dmi_check_system(i8042_dmi_noloop_table))
+	if (sysfw_callback(i8042_id_noloop_table))
 		i8042_noloop = true;
 
-	if (dmi_check_system(i8042_dmi_nomux_table))
+	if (sysfw_callback(i8042_id_nomux_table))
 		i8042_nomux = true;
 
-	if (dmi_check_system(i8042_dmi_notimeout_table))
+	if (sysfw_callback(i8042_id_notimeout_table))
 		i8042_notimeout = true;
 
-	if (dmi_check_system(i8042_dmi_dritek_table))
+	if (sysfw_callback(i8042_id_dritek_table))
 		i8042_dritek = true;
 #endif /* CONFIG_X86 */
 
diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 23317bd..1b43e02 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -85,7 +85,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/mod_devicetable.h>
 #include <linux/init.h>
 #include <linux/usb/input.h>
 #include <asm/unaligned.h>
diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 62811de..8375462 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -18,7 +18,7 @@
 #include <linux/irq.h>
 #include <linux/isa.h>
 #include <linux/ioport.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
 MODULE_DESCRIPTION("HTC Shift touchscreen driver");
@@ -227,20 +227,21 @@ static struct isa_driver htcpen_isa_driver = {
 	}
 };
 
-static struct dmi_system_id __initdata htcshift_dmi_table[] = {
+static struct sysfw_id __initdata htcshift_smbios_table[] = {
 	{
 		.ident = "Shift",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "High Tech Computer Corp"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Shift"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "High Tech Computer Corp"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Shift"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int __init htcpen_isa_init(void)
 {
-	if (!dmi_check_system(htcshift_dmi_table))
+	if (!sysfw_callback(htcshift_smbios_table))
 		return -ENODEV;
 
 	return isa_register_driver(&htcpen_isa_driver, 1);
-- 
1.7.5.4

