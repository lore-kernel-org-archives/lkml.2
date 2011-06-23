Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab1FWReq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:34:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759Ab1FWRWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:35 -0400
Date: Thu, 23 Jun 2011 13:22:34 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172234.27623.1456.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 04/35] drivers/acpi changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/acpi changes for SMBIOS and System Firmware interface

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/acpi/battery.c           |    5 +-
 drivers/acpi/blacklist.c         |  125 ++++++++++++++++++-------------------
 drivers/acpi/bus.c               |   16 +++---
 drivers/acpi/ec.c                |  101 ++++++++++++++++++++++---------
 drivers/acpi/osl.c               |   17 +++---
 drivers/acpi/pci_irq.c           |   33 +++++-----
 drivers/acpi/pci_slot.c          |   12 ++--
 drivers/acpi/processor_core.c    |   25 +++++---
 drivers/acpi/processor_driver.c  |    1 -
 drivers/acpi/processor_idle.c    |   51 +++++++++++-----
 drivers/acpi/scan.c              |    4 +-
 drivers/acpi/sleep.c             |   46 +++++++-------
 drivers/acpi/thermal.c           |   42 +++++++------
 drivers/acpi/video.c             |   28 ++++----
 drivers/acpi/video_detect.c      |    3 +-
 drivers/hwmon/acpi_power_meter.c |   15 +++--
 16 files changed, 295 insertions(+), 229 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fcc13ac..cf4faba 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -31,7 +31,7 @@
 #include <linux/types.h>
 #include <linux/jiffies.h>
 #include <linux/async.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
 
@@ -575,9 +575,8 @@ static void sysfs_remove_battery(struct acpi_battery *battery)
 
 static void acpi_battery_quirks(struct acpi_battery *battery)
 {
-	if (dmi_name_in_vendors("Acer") && battery->power_unit) {
+	if (sysfw_vendor_is("Acer") && battery->power_unit)
 		set_bit(ACPI_BATTERY_QUIRK_SIGNED16_CURRENT, &battery->flags);
-	}
 }
 
 /*
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index af308d0..4e44fbe 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -3,7 +3,7 @@
  *
  *  Check to see if the given machine has a known bad ACPI BIOS
  *  or if the BIOS is too old.
- *  Check given machine against acpi_osi_dmi_table[].
+ *  Check given machine against acpi_osi_smbios_table[].
  *
  *  Copyright (C) 2004 Len Brown <len.brown@intel.com>
  *  Copyright (C) 2002 Andy Grover <andrew.grover@intel.com>
@@ -32,7 +32,7 @@
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include "internal.h"
 
@@ -53,7 +53,7 @@ struct acpi_blacklist_item {
 	u32 is_critical_error;
 };
 
-static struct dmi_system_id acpi_osi_dmi_table[] __initdata;
+static struct sysfw_id acpi_osi_table[] __initdata;
 
 /*
  * POLICY: If *anything* doesn't work, put it on the blacklist.
@@ -83,18 +83,18 @@ static int __init blacklist_by_year(void)
 	int year;
 
 	/* Doesn't exist? Likely an old system */
-	if (!dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL)) {
-		printk(KERN_ERR PREFIX "no DMI BIOS year, "
+	if (!sysfw_lookup(SYSFW_BIOS_DATE)) {
+		printk(KERN_ERR PREFIX "no SMBIOS year, "
 			"acpi=force is required to enable ACPI\n" );
 		return 1;
 	}
 	/* 0? Likely a buggy new BIOS */
-	if (year == 0) {
-		printk(KERN_ERR PREFIX "DMI BIOS year==0, "
+	if (!sysfw_get_date()) {
+		printk(KERN_ERR PREFIX "SMBIOS date = 0, "
 			"assuming ACPI-capable machine\n" );
 		return 0;
 	}
-	if (year < CONFIG_ACPI_BLACKLIST_YEAR) {
+	if (sysfw_get_date() < (CONFIG_ACPI_BLACKLIST_YEAR * 10000)) {
 		printk(KERN_ERR PREFIX "BIOS age (%d) fails cutoff (%d), "
 		       "acpi=force is required to enable ACPI\n",
 		       year, CONFIG_ACPI_BLACKLIST_YEAR);
@@ -169,38 +169,37 @@ int __init acpi_blacklisted(void)
 
 	blacklisted += blacklist_by_year();
 
-	dmi_check_system(acpi_osi_dmi_table);
+	sysfw_callback(acpi_osi_table);
 
 	return blacklisted;
 }
-#ifdef CONFIG_DMI
-static int __init dmi_enable_osi_linux(const struct dmi_system_id *d)
+static int __init enable_osi_linux(const struct sysfw_id *d)
 {
-	acpi_dmi_osi_linux(1, d);	/* enable */
+	acpi_smbios_osi_linux(1, d);	/* enable */
 	return 0;
 }
-static int __init dmi_disable_osi_vista(const struct dmi_system_id *d)
+static int __init disable_osi_vista(const struct sysfw_id *d)
 {
-	printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
+	printk(KERN_NOTICE PREFIX "SMBIOS detected: %s\n", d->ident);
 	acpi_osi_setup("!Windows 2006");
 	acpi_osi_setup("!Windows 2006 SP1");
 	acpi_osi_setup("!Windows 2006 SP2");
 	return 0;
 }
-static int __init dmi_disable_osi_win7(const struct dmi_system_id *d)
+static int __init disable_osi_win7(const struct sysfw_id *d)
 {
-	printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
+	printk(KERN_NOTICE PREFIX "SMBIOS detected: %s\n", d->ident);
 	acpi_osi_setup("!Windows 2009");
 	return 0;
 }
 
-static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
+static struct sysfw_id acpi_osi_table[] __initdata = {
 	{
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "Fujitsu Siemens",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Mobile V5505"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "ESPRIMO Mobile V5505"),
 		},
 	},
 	{
@@ -209,63 +208,63 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 	 * driver (e.g. nouveau) when user press brightness hotkey.
 	 * Currently, nouveau driver didn't do the job and it causes there
 	 * have a infinite while loop in DSDT when user press hotkey.
-	 * We add MSI GX723's dmi information to this table for workaround
+	 * We add MSI GX723's smbios information to this table for workaround
 	 * this issue.
 	 * Will remove MSI GX723 from the table after nouveau grows support.
 	 */
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "MSI GX723",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "GX723"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "Micro-Star International"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "GX723"),
 		},
 	},
 	{
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "Sony VGN-NS10J_S",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NS10J_S"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-NS10J_S"),
 		},
 	},
 	{
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "Sony VGN-SR290J",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR290J"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-SR290J"),
 		},
 	},
 	{
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "VGN-NS50B_L",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NS50B_L"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-NS50B_L"),
 		},
 	},
 	{
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "Toshiba Satellite L355",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		     DMI_MATCH(DMI_PRODUCT_VERSION, "Satellite L355"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "Satellite L355"),
 		},
 	},
 	{
-	.callback = dmi_disable_osi_win7,
+	.callback = disable_osi_win7,
 	.ident = "ASUS K50IJ",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "K50IJ"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "K50IJ"),
 		},
 	},
 	{
-	.callback = dmi_disable_osi_vista,
+	.callback = disable_osi_vista,
 	.ident = "Toshiba P305D",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Satellite P305D"),
 		},
 	},
 
@@ -279,56 +278,54 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 	 * and thus we can not wildcard the vendor.
 	 *
 	 * _OSI(Linux) helps sound
-	 * DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad R61"),
-	 * DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T61"),
+	 * SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad R61"),
+	 * SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad T61"),
 	 * T400, T500
 	 * _OSI(Linux) has Linux specific hooks
-	 * DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X61"),
+	 * SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad X61"),
 	 * _OSI(Linux) is a NOP:
-	 * DMI_MATCH(DMI_PRODUCT_VERSION, "3000 N100"),
-	 * DMI_MATCH(DMI_PRODUCT_VERSION, "LENOVO3000 V100"),
+	 * SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "3000 N100"),
+	 * SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "LENOVO3000 V100"),
 	 */
 	{
-	.callback = dmi_enable_osi_linux,
+	.callback = enable_osi_linux,
 	.ident = "Lenovo ThinkPad R61",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad R61"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "LENOVO"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad R61"),
 		},
 	},
 	{
-	.callback = dmi_enable_osi_linux,
+	.callback = enable_osi_linux,
 	.ident = "Lenovo ThinkPad T61",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T61"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "LENOVO"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad T61"),
 		},
 	},
 	{
-	.callback = dmi_enable_osi_linux,
+	.callback = enable_osi_linux,
 	.ident = "Lenovo ThinkPad X61",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X61"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "LENOVO"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad X61"),
 		},
 	},
 	{
-	.callback = dmi_enable_osi_linux,
+	.callback = enable_osi_linux,
 	.ident = "Lenovo ThinkPad T400",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T400"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "LENOVO"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad T400"),
 		},
 	},
 	{
-	.callback = dmi_enable_osi_linux,
+	.callback = enable_osi_linux,
 	.ident = "Lenovo ThinkPad T500",
 	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T500"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "LENOVO"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "ThinkPad T500"),
 		},
 	},
 	{}
 };
-
-#endif /* CONFIG_DMI */
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index d1e06c1..09ad035 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -39,7 +39,7 @@
 #include <linux/pci.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/suspend.h>
 
 #include "internal.h"
@@ -55,7 +55,7 @@ EXPORT_SYMBOL(acpi_root_dir);
 
 
 #ifdef CONFIG_X86
-static int set_copy_dsdt(const struct dmi_system_id *id)
+static int set_copy_dsdt(const struct sysfw_id *id)
 {
 	printk(KERN_NOTICE "%s detected - "
 		"force copy of DSDT to local memory\n", id->ident);
@@ -63,7 +63,7 @@ static int set_copy_dsdt(const struct dmi_system_id *id)
 	return 0;
 }
 
-static struct dmi_system_id dsdt_dmi_table[] __initdata = {
+static struct sysfw_id dsdt_id_table[] __initdata = {
 	/*
 	 * Invoke DSDT corruption work-around on all Toshiba Satellite.
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=14679
@@ -72,14 +72,14 @@ static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 	 .callback = set_copy_dsdt,
 	 .ident = "TOSHIBA Satellite",
 	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Satellite"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Satellite"),
 		},
 	},
 	{}
 };
 #else
-static struct dmi_system_id dsdt_dmi_table[] __initdata = {
+static struct sysfw_id dsdt_id_table[] __initdata = {
 	{}
 };
 #endif
@@ -856,10 +856,10 @@ void __init acpi_early_init(void)
 	acpi_gbl_permanent_mmap = 1;
 
 	/*
-	 * If the machine falls into the DMI check table,
+	 * If the machine falls into the SMBIOS check table,
 	 * DSDT will be copied to memory
 	 */
-	dmi_check_system(dsdt_dmi_table);
+	sysfw_callback(dsdt_id_table);
 
 	status = acpi_reallocate_root_table();
 	if (ACPI_FAILURE(status)) {
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index b19a18d..f0febee 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -41,7 +41,7 @@
 #include <asm/io.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include "internal.h"
 
@@ -892,21 +892,21 @@ static const struct acpi_device_id ec_device_ids[] = {
 };
 
 /* Some BIOS do not survive early DSDT scan, skip it */
-static int ec_skip_dsdt_scan(const struct dmi_system_id *id)
+static int ec_skip_dsdt_scan(const struct sysfw_id *id)
 {
 	EC_FLAGS_SKIP_DSDT_SCAN = 1;
 	return 0;
 }
 
 /* ASUStek often supplies us with broken ECDT, validate it */
-static int ec_validate_ecdt(const struct dmi_system_id *id)
+static int ec_validate_ecdt(const struct sysfw_id *id)
 {
 	EC_FLAGS_VALIDATE_ECDT = 1;
 	return 0;
 }
 
 /* MSI EC needs special treatment, enable it */
-static int ec_flag_msi(const struct dmi_system_id *id)
+static int ec_flag_msi(const struct sysfw_id *id)
 {
 	printk(KERN_DEBUG PREFIX "Detected MSI hardware, enabling workarounds.\n");
 	EC_FLAGS_MSI = 1;
@@ -914,41 +914,84 @@ static int ec_flag_msi(const struct dmi_system_id *id)
 	return 0;
 }
 
-static struct dmi_system_id __initdata ec_dmi_table[] = {
+static struct sysfw_id __initdata ec_smbios_table[] = {
 	{
-	ec_skip_dsdt_scan, "Compal JFL92", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
-	DMI_MATCH(DMI_BOARD_NAME, "JFL92") }, NULL},
+		.callback = ec_skip_dsdt_scan,
+		.ident = "Compal JFL92",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR, "COMPAL"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "JFL92")
+		},
+	},
+	{
+		.callback = ec_flag_msi,
+		.ident = "MSI hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR, "Micro-Star")
+		},
+	},
 	{
-	ec_flag_msi, "MSI hardware", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Micro-Star")}, NULL},
+		.callback = ec_flag_msi,
+		.ident = "MSI hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Micro-Star")
+		},
+	},
 	{
-	ec_flag_msi, "MSI hardware", {
-	DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star")}, NULL},
+		.callback = ec_flag_msi,
+		.ident = "MSI hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_CHASSIS_VENDOR, "MICRO-Star")
+		},
+	},
 	{
-	ec_flag_msi, "MSI hardware", {
-	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-Star")}, NULL},
+		.callback = ec_flag_msi,
+		.ident = "MSI hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_CHASSIS_VENDOR, "MICRO-STAR")
+		},
+	},
 	{
-	ec_flag_msi, "MSI hardware", {
-	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR")}, NULL},
+		.callback = ec_flag_msi,
+		.ident = "Quanta hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Quanta"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TW8/SW8/DW8")
+		},
+	},
 	{
-	ec_flag_msi, "Quanta hardware", {
-	DMI_MATCH(DMI_SYS_VENDOR, "Quanta"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "TW8/SW8/DW8"),}, NULL},
+		.callback = ec_flag_msi,
+		.ident = "Quanta hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Quanta"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TW9/SW9")
+		},
+	},
 	{
-	ec_flag_msi, "Quanta hardware", {
-	DMI_MATCH(DMI_SYS_VENDOR, "Quanta"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "TW9/SW9"),}, NULL},
+		.callback = ec_validate_ecdt,
+		.ident = "ASUS hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR, "ASUS")
+		},
+	},
 	{
-	ec_validate_ecdt, "ASUS hardware", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "ASUS") }, NULL},
+		.callback = ec_validate_ecdt,
+		.ident = "ASUS hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "ASUSTeK Computer Inc.")
+		},
+	},
 	{
-	ec_validate_ecdt, "ASUS hardware", {
-	DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc.") }, NULL},
+		.callback = ec_validate_ecdt,
+		.ident = "ASUS hardware",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR, "ASUS")
+		},
+	},
 	{},
 };
 
-
 int __init acpi_ec_ecdt_probe(void)
 {
 	acpi_status status;
@@ -961,7 +1004,7 @@ int __init acpi_ec_ecdt_probe(void)
 	/*
 	 * Generate a boot ec context
 	 */
-	dmi_check_system(ec_dmi_table);
+	sysfw_callback(ec_smbios_table);
 	status = acpi_get_table(ACPI_SIG_ECDT, 1,
 				(struct acpi_table_header **)&ecdt_ptr);
 	if (ACPI_SUCCESS(status)) {
@@ -1009,7 +1052,7 @@ int __init acpi_ec_ecdt_probe(void)
 		* Keep boot_ec struct as it will be needed soon.
 		*/
 		acpi_handle dummy;
-		if (!dmi_name_in_vendors("ASUS") ||
+		if (!sysfw_vendor_is("ASUS") ||
 		    ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI",
 							&dummy)))
 			return -ENODEV;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 52ca964..bbf1c68 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -141,13 +141,13 @@ static void __init acpi_osi_setup_late(void);
  * BIOS writers should NOT query _OSI(Linux) on future systems.
  * Linux will complain on the console when it sees it, and return FALSE.
  * To get Linux to return TRUE for your system  will require
- * a kernel source update to add a DMI entry,
+ * a kernel source update to add a SMBIOS entry,
  * or boot with "acpi_osi=Linux"
  */
 
 static struct osi_linux {
 	unsigned int	enable:1;
-	unsigned int	dmi:1;
+	unsigned int	smbios:1;
 	unsigned int	cmdline:1;
 } osi_linux = {0, 0, 0};
 
@@ -159,7 +159,7 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 			"BIOS _OSI(Linux) query %s%s\n",
 			osi_linux.enable ? "honored" : "ignored",
 			osi_linux.cmdline ? " via cmdline" :
-			osi_linux.dmi ? " via DMI" : "");
+			osi_linux.smbios ? " via SMBIOS" : "");
 	}
 
 	return supported;
@@ -1133,21 +1133,22 @@ static void __init set_osi_linux(unsigned int enable)
 
 static void __init acpi_cmdline_osi_linux(unsigned int enable)
 {
-	osi_linux.cmdline = 1;	/* cmdline set the default and override DMI */
-	osi_linux.dmi = 0;
+	/* cmdline set the default and override SMBIOS */
+	osi_linux.cmdline = 1;
+	osi_linux.smbios = 0;
 	set_osi_linux(enable);
 
 	return;
 }
 
-void __init acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d)
+void __init acpi_smbios_osi_linux(int enable, const struct sysfw_id *d)
 {
-	printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
+	printk(KERN_NOTICE PREFIX "SMBIOS detected: %s\n", d->ident);
 
 	if (enable == -1)
 		return;
 
-	osi_linux.dmi = 1;	/* DMI knows that this box asks OSI(Linux) */
+	osi_linux.smbios = 1;	/* SMBIOS knows that this box asks OSI(Linux) */
 	set_osi_linux(enable);
 
 	return;
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index f907cfb..ffc7af3 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -27,7 +27,7 @@
  */
 
 
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -88,44 +88,45 @@ static struct acpi_prt_entry *acpi_pci_irq_find_prt_entry(struct pci_dev *dev,
 }
 
 /* http://bugzilla.kernel.org/show_bug.cgi?id=4773 */
-static const struct dmi_system_id medion_md9580[] = {
+static const struct sysfw_id medion_md9580[] = {
 	{
 		.ident = "Medion MD9580-F laptop",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A555"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MEDIONNB"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A555"),
 		},
 	},
-	{ }
+	{}
 };
 
 /* http://bugzilla.kernel.org/show_bug.cgi?id=5044 */
-static const struct dmi_system_id dell_optiplex[] = {
+static const struct sysfw_id dell_optiplex[] = {
 	{
 		.ident = "Dell Optiplex GX1",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex GX1 600S+"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Dell Computer Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "OptiPlex GX1 600S+"),
 		},
 	},
-	{ }
+	{}
 };
 
 /* http://bugzilla.kernel.org/show_bug.cgi?id=10138 */
-static const struct dmi_system_id hp_t5710[] = {
+static const struct sysfw_id hp_t5710[] = {
 	{
 		.ident = "HP t5710",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "hp t5000 series"),
-			DMI_MATCH(DMI_BOARD_NAME, "098Ch"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "hp t5000 series"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "098Ch"),
 		},
 	},
-	{ }
+	{}
 };
 
 struct prt_quirk {
-	const struct dmi_system_id *system;
+	const struct sysfw_id *system;
 	unsigned int		segment;
 	unsigned int		bus;
 	unsigned int		device;
@@ -166,7 +167,7 @@ static void do_prt_fixups(struct acpi_prt_entry *entry,
 		if (!prt->source)
 			continue;
 
-		if (dmi_check_system(quirk->system) &&
+		if (sysfw_callback(quirk->system) &&
 		    entry->id.segment == quirk->segment &&
 		    entry->id.bus == quirk->bus &&
 		    entry->id.device == quirk->device &&
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index 07f7fea..1db7f02 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -32,7 +32,7 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 static int debug;
 static int check_sta_before_sun;
@@ -329,14 +329,14 @@ acpi_pci_slot_remove(acpi_handle handle)
 	mutex_unlock(&slot_list_lock);
 }
 
-static int do_sta_before_sun(const struct dmi_system_id *d)
+static int do_sta_before_sun(const struct sysfw_id *d)
 {
 	info("%s detected: will evaluate _STA before calling _SUN\n", d->ident);
 	check_sta_before_sun = 1;
 	return 0;
 }
 
-static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
+static struct sysfw_id acpi_pci_slot_id_table[] __initdata = {
 	/*
 	 * Fujitsu Primequest machines will return 1023 to indicate an
 	 * error if the _SUN method is evaluated on SxFy objects that
@@ -347,8 +347,8 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
 	 .callback = do_sta_before_sun,
 	 .ident = "Fujitsu PRIMEQUEST",
 	 .matches = {
-		DMI_MATCH(DMI_BIOS_VENDOR, "FUJITSU LIMITED"),
-		DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
+		SYSFW_MATCH(SYSFW_BIOS_VENDOR, "FUJITSU LIMITED"),
+		SYSFW_MATCH(SYSFW_BIOS_VERSION, "PRIMEQUEST"),
 		},
 	},
 	{}
@@ -357,7 +357,7 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
 static int __init
 acpi_pci_slot_init(void)
 {
-	dmi_check_system(acpi_pci_slot_dmi_table);
+	sysfw_callback(acpi_pci_slot_id_table);
 	acpi_pci_register_driver(&acpi_pci_slot_driver);
 	return 0;
 }
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 02d2a4c..ab3955a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -7,7 +7,7 @@
  *	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
  *	- Added _PDC for platforms with Intel CPUs
  */
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/slab.h>
 
 #include <acpi/acpi_drivers.h>
@@ -19,7 +19,7 @@
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_core");
 
-static int __init set_no_mwait(const struct dmi_system_id *id)
+static int __init set_no_mwait(const struct sysfw_id *id)
 {
 	printk(KERN_NOTICE PREFIX "%s detected - "
 		"disabling mwait for CPU C-states\n", id->ident);
@@ -27,13 +27,18 @@ static int __init set_no_mwait(const struct dmi_system_id *id)
 	return 0;
 }
 
-static struct dmi_system_id __initdata processor_idle_dmi_table[] = {
+static struct sysfw_id __initdata processor_idle_id_table[] = {
 	{
-	set_no_mwait, "Extensa 5220", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
-	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
-	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
+		.callback = set_no_mwait,
+		.ident = "Extensa 5220",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR,
+				    "Phoenix Technologies LTD"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0100"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "Columbia")
+		}
+	},
 	{},
 };
 
@@ -343,10 +348,10 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 void __init acpi_early_processor_set_pdc(void)
 {
 	/*
-	 * Check whether the system is DMI table. If yes, OSPM
+	 * Check whether the system is SMBIOS table. If yes, OSPM
 	 * should not use mwait for CPU-states.
 	 */
-	dmi_check_system(processor_idle_dmi_table);
+	sysfw_callback(processor_idle_id_table);
 
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index a4e0f1b..a78045e 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -40,7 +40,6 @@
 #include <linux/pm.h>
 #include <linux/cpufreq.h>
 #include <linux/cpu.h>
-#include <linux/dmi.h>
 #include <linux/moduleparam.h>
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 431ab11..7fe9632 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -34,7 +34,7 @@
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>	/* need_resched() */
 #include <linux/pm_qos_params.h>
@@ -92,7 +92,7 @@ static int disabled_by_idle_boot_param(void)
  *
  * To skip this limit, boot/load with a large max_cstate limit.
  */
-static int set_max_cstate(const struct dmi_system_id *id)
+static int set_max_cstate(const struct sysfw_id *id)
 {
 	if (max_cstate > ACPI_PROCESSOR_MAX_POWER)
 		return 0;
@@ -108,19 +108,38 @@ static int set_max_cstate(const struct dmi_system_id *id)
 
 /* Actually this shouldn't be __cpuinitdata, would be better to fix the
    callers to only run once -AK */
-static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
-	{ set_max_cstate, "Clevo 5600D", {
-	  DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
-	  DMI_MATCH(DMI_BIOS_VERSION,"SHE845M0.86C.0013.D.0302131307")},
-	 (void *)2},
-	{ set_max_cstate, "Pavilion zv5000", {
-	  DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"Pavilion zv5000 (DS502A#ABA)")},
-	 (void *)1},
-	{ set_max_cstate, "Asus L8400B", {
-	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
-	 (void *)1},
+static struct sysfw_id __cpuinitdata processor_power_id_table[] = {
+	{
+		.callback = set_max_cstate,
+		.ident = "Clevo 5600D",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR,
+				    "Phoenix Technologies LTD"),
+			SYSFW_MATCH(SYSFW_BIOS_VERSION,
+				    "SHE845M0.86C.0013.D.0302131307")
+		},
+		.driver_data = (void *)2
+	},
+	{
+		.callback = set_max_cstate,
+		.ident = "Pavilion zv5000",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "Pavilion zv5000 (DS502A#ABA)")
+		},
+		.driver_data = (void *)1
+	},
+	{
+		.callback = set_max_cstate,
+		.ident = "Asus L8400B",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+				    "L8400B series Notebook PC")
+		},
+		.driver_data = (void *)1
+	},
 	{},
 };
 
@@ -1096,7 +1115,7 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 		return 0;
 
 	if (!first_run) {
-		dmi_check_system(processor_power_dmi_table);
+		sysfw_callback(processor_power_id_table);
 		max_cstate = acpi_processor_cstate_check(max_cstate);
 		if (max_cstate < ACPI_C_STATES_MAX)
 			printk(KERN_NOTICE
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 449c556..ff94b79 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -9,7 +9,7 @@
 #include <linux/acpi.h>
 #include <linux/signal.h>
 #include <linux/kthread.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <acpi/acpi_drivers.h>
 
@@ -1083,7 +1083,7 @@ static int acpi_ibm_smbus_match(struct acpi_device *device)
 	struct acpi_buffer path = {ACPI_ALLOCATE_BUFFER, NULL};
 	int result;
 
-	if (!dmi_name_in_vendors("IBM"))
+	if (!sysfw_vendor_is("IBM"))
 		return -ENODEV;
 
 	/* Look for SMBS object */
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 6c94960..2fe5d12 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -12,7 +12,7 @@
 
 #include <linux/delay.h>
 #include <linux/irq.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
@@ -342,90 +342,90 @@ static const struct platform_suspend_ops acpi_suspend_ops_old = {
 	.recover = acpi_pm_finish,
 };
 
-static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
+static int __init init_old_suspend_ordering(const struct sysfw_id *d)
 {
 	old_suspend_ordering = true;
 	return 0;
 }
 
-static int __init init_nvs_nosave(const struct dmi_system_id *d)
+static int __init init_nvs_nosave(const struct sysfw_id *d)
 {
 	acpi_nvs_nosave();
 	return 0;
 }
 
-static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
+static struct sysfw_id __initdata acpisleep_table[] = {
 	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Abit KN9 (nForce4 variant)",
 	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
-		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "http://www.abit.com.tw/"),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "KN9 Series(NF-CK804)"),
 		},
 	},
 	{
 	.callback = init_old_suspend_ordering,
 	.ident = "HP xw4600 Workstation",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "HP xw4600 Workstation"),
 		},
 	},
 	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Asus Pundit P1-AH2 (M2N8L motherboard)",
 	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTek Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "M2N8L"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "ASUSTek Computer INC."),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "M2N8L"),
 		},
 	},
 	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Panasonic CF51-2L",
 	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR,
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR,
 				"Matsushita Electric Industrial Co.,Ltd."),
-		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "CF51-2L"),
 		},
 	},
 	{
 	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VGN-SR11M",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR11M"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-SR11M"),
 		},
 	},
 	{
 	.callback = init_nvs_nosave,
 	.ident = "Everex StepNote Series",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Everex Systems, Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Everex StepNote Series"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "Everex Systems, Inc."),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Everex StepNote Series"),
 		},
 	},
 	{
 	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VPCEB1Z1E",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1Z1E"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VPCEB1Z1E"),
 		},
 	},
 	{
 	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VGN-NW130D",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NW130D"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-NW130D"),
 		},
 	},
 	{
 	.callback = init_nvs_nosave,
 	.ident = "Averatec AV1020-ED2",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "1000 Series"),
+		SYSFW_MATCH(SYSFW_SYS_VENDOR, "AVERATEC"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "1000 Series"),
 		},
 	},
 	{},
@@ -737,7 +737,7 @@ int __init acpi_sleep_init(void)
 #ifdef CONFIG_SUSPEND
 	int i = 0;
 
-	dmi_check_system(acpisleep_dmi_table);
+	sysfw_callback(acpisleep_table);
 #endif
 
 	if (acpi_disabled)
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 2607e17..7005de57 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -33,7 +33,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -1075,8 +1075,8 @@ static int acpi_thermal_resume(struct acpi_device *device)
 	return AE_OK;
 }
 
-static int thermal_act(const struct dmi_system_id *d) {
-
+static int thermal_act(const struct sysfw_id *d)
+{
 	if (act == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
 			"disabling all active thermal trip points\n", d->ident);
@@ -1084,15 +1084,16 @@ static int thermal_act(const struct dmi_system_id *d) {
 	}
 	return 0;
 }
-static int thermal_nocrt(const struct dmi_system_id *d) {
-
+static int thermal_nocrt(const struct sysfw_id *d)
+{
 	printk(KERN_NOTICE "ACPI: %s detected: "
-		"disabling all critical thermal trip point actions.\n", d->ident);
+	       "disabling all critical thermal trip point actions.\n",
+	       d->ident);
 	nocrt = 1;
 	return 0;
 }
-static int thermal_tzp(const struct dmi_system_id *d) {
-
+static int thermal_tzp(const struct sysfw_id *d)
+{
 	if (tzp == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
 			"enabling thermal zone polling\n", d->ident);
@@ -1100,8 +1101,8 @@ static int thermal_tzp(const struct dmi_system_id *d) {
 	}
 	return 0;
 }
-static int thermal_psv(const struct dmi_system_id *d) {
-
+static int thermal_psv(const struct sysfw_id *d)
+{
 	if (psv == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
 			"disabling all passive thermal trip points\n", d->ident);
@@ -1110,7 +1111,7 @@ static int thermal_psv(const struct dmi_system_id *d) {
 	return 0;
 }
 
-static struct dmi_system_id thermal_dmi_table[] __initdata = {
+static struct sysfw_id thermal_id_table[] __initdata = {
 	/*
 	 * Award BIOS on this AOpen makes thermal control almost worthless.
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=8842
@@ -1119,32 +1120,33 @@ static struct dmi_system_id thermal_dmi_table[] __initdata = {
 	 .callback = thermal_act,
 	 .ident = "AOpen i915GMm-HFS",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
-		DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "AOpen"),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "i915GMm-HFS"),
 		},
 	},
 	{
 	 .callback = thermal_psv,
 	 .ident = "AOpen i915GMm-HFS",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
-		DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "AOpen"),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "i915GMm-HFS"),
 		},
 	},
 	{
 	 .callback = thermal_tzp,
 	 .ident = "AOpen i915GMm-HFS",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
-		DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "AOpen"),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "i915GMm-HFS"),
 		},
 	},
 	{
 	 .callback = thermal_nocrt,
 	 .ident = "Gigabyte GA-7ZX",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
-		DMI_MATCH(DMI_BOARD_NAME, "7ZX"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+			    "Gigabyte Technology Co., Ltd."),
+		SYSFW_MATCH(SYSFW_BOARD_NAME, "7ZX"),
 		},
 	},
 	{}
@@ -1154,7 +1156,7 @@ static int __init acpi_thermal_init(void)
 {
 	int result = 0;
 
-	dmi_check_system(thermal_dmi_table);
+	sysfw_callback(thermal_id_table);
 
 	if (off) {
 		printk(KERN_NOTICE "ACPI: thermal control disabled\n");
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index db39e9e..b28912b 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -38,7 +38,7 @@
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <linux/suspend.h>
@@ -384,13 +384,13 @@ acpi_video_device_lcd_set_level(struct acpi_video_device *device, int level)
  */
 
 static int bqc_offset_aml_bug_workaround;
-static int __init video_set_bqc_offset(const struct dmi_system_id *d)
+static int __init video_set_bqc_offset(const struct sysfw_id *d)
 {
 	bqc_offset_aml_bug_workaround = 9;
 	return 0;
 }
 
-static struct dmi_system_id video_dmi_table[] __initdata = {
+static struct sysfw_id video_id_table[] __initdata = {
 	/*
 	 * Broken _BQC workaround http://bugzilla.kernel.org/show_bug.cgi?id=13121
 	 */
@@ -398,40 +398,40 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 	 .callback = video_set_bqc_offset,
 	 .ident = "Acer Aspire 5720",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Acer"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5720"),
 		},
 	},
 	{
 	 .callback = video_set_bqc_offset,
 	 .ident = "Acer Aspire 5710Z",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5710Z"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Acer"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5710Z"),
 		},
 	},
 	{
 	 .callback = video_set_bqc_offset,
 	 .ident = "eMachines E510",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "EMACHINES"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "eMachines E510"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "EMACHINES"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "eMachines E510"),
 		},
 	},
 	{
 	 .callback = video_set_bqc_offset,
 	 .ident = "Acer Aspire 5315",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5315"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Acer"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 5315"),
 		},
 	},
 	{
 	 .callback = video_set_bqc_offset,
 	 .ident = "Acer Aspire 7720",
 	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7720"),
+		SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Acer"),
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aspire 7720"),
 		},
 	},
 	{}
@@ -1801,7 +1801,7 @@ EXPORT_SYMBOL(acpi_video_unregister);
 
 static int __init acpi_video_init(void)
 {
-	dmi_check_system(video_dmi_table);
+	sysfw_callback(video_id_table);
 
 	if (intel_opregion_present())
 		return 0;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 5af3479..41f0d10 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -34,7 +34,6 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/dmi.h>
 #include <linux/pci.h>
 
 #define PREFIX "ACPI: "
@@ -158,7 +157,7 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 		/* Add blacklists here. Be careful to use the right *DMI* bits
 		 * to still be able to override logic via boot params, e.g.:
 		 *
-		 *   if (dmi_name_in_vendors("XY")) {
+		 *   if (smbios_vendor_is("XY")) {
 		 *	acpi_video_support |=
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 66f6729..47175c6 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -24,7 +24,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/slab.h>
 #include <linux/kdev_t.h>
 #include <linux/sched.h>
@@ -975,17 +975,18 @@ static struct acpi_driver acpi_power_meter_driver = {
 };
 
 /* Module init/exit routines */
-static int __init enable_cap_knobs(const struct dmi_system_id *d)
+static int __init enable_cap_knobs(const struct sysfw_id *d)
 {
 	cap_in_hardware = 1;
 	return 0;
 }
 
-static struct dmi_system_id __initdata pm_dmi_table[] = {
+static struct sysfw_id __initdata pm_id_table[] = {
 	{
-		enable_cap_knobs, "IBM Active Energy Manager",
-		{
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM")
+		.callback = enable_cap_knobs,
+		.ident = "IBM Active Energy Manager",
+		.matches = {
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "IBM")
 		},
 	},
 	{}
@@ -998,7 +999,7 @@ static int __init acpi_power_meter_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	dmi_check_system(pm_dmi_table);
+	sysfw_callback(pm_id_table);
 
 	result = acpi_bus_register_driver(&acpi_power_meter_driver);
 	if (result < 0)
-- 
1.7.5.4

