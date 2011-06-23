Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab1FWRXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab1FWRXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:31 -0400
Date: Thu, 23 Jun 2011 13:23:30 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172330.27670.82249.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 13/35] drivers/ide changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ide changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/ide/alim15x3.c  |   18 +++++++++---------
 drivers/ide/ide-acpi.c  |   16 ++++++++--------
 drivers/ide/ide-gd.c    |   10 +++++-----
 drivers/ide/via82cxxx.c |   14 +++++++-------
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index 2c8016a..d5194e1 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -33,7 +33,7 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <asm/io.h>
 
@@ -333,22 +333,22 @@ out:
  *	Cable special cases
  */
 
-static const struct dmi_system_id cable_dmi_table[] = {
+static const struct sysfw_id cable_smbios_table[] = {
 	{
 		.ident = "HP Pavilion N5430",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
 	{
 		.ident = "Toshiba Satellite S1800-814",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "S1800-814"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int ali_cable_override(struct pci_dev *pdev)
@@ -363,8 +363,8 @@ static int ali_cable_override(struct pci_dev *pdev)
 	    pdev->subsystem_device == 0x8317)
 		return 1;
 
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
+	/* Systems by SMBIOS */
+	if (sysfw_callback(cable_smbios_table))
 		return 1;
 
 	return 0;
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 2af8cb4..dfcff27 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -16,7 +16,7 @@
 #include <acpi/acpi.h>
 #include <linux/ide.h>
 #include <linux/pci.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <acpi/acpi_bus.h>
 
@@ -65,31 +65,31 @@ module_param_named(acpionboot, ide_acpionboot, bool, 0);
 MODULE_PARM_DESC(acpionboot, "call IDE ACPI methods on boot");
 
 static bool ide_noacpi_psx;
-static int no_acpi_psx(const struct dmi_system_id *id)
+static int no_acpi_psx(const struct sysfw_id *id)
 {
 	ide_noacpi_psx = true;
 	printk(KERN_NOTICE"%s detected - disable ACPI _PSx.\n", id->ident);
 	return 0;
 }
 
-static const struct dmi_system_id ide_acpi_dmi_table[] = {
+static const struct sysfw_id ide_acpi_smbios_table[] = {
 	/* Bug 9673. */
 	/* We should check if this is because ACPI NVS isn't save/restored. */
 	{
 		.callback = no_acpi_psx,
 		.ident    = "HP nx9005",
 		.matches  = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies Ltd."),
-			DMI_MATCH(DMI_BIOS_VERSION, "KAM1.60")
+			SYSFW_MATCH(SYSFW_BIOS_VENDOR,
+				    "Phoenix Technologies Ltd."),
+			SYSFW_MATCH(SYSFW_BIOS_VERSION, "KAM1.60")
 		},
 	},
-
-	{ }	/* terminate list */
+	{}
 };
 
 int ide_acpi_init(void)
 {
-	dmi_check_system(ide_acpi_dmi_table);
+	sysfw_callback(ide_acpi_smbios_table);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 70ea876..3801f49 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -7,8 +7,8 @@
 #include <linux/mutex.h>
 #include <linux/ide.h>
 #include <linux/hdreg.h>
-#include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/sysfw.h>
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define IDE_DISK_MINORS		(1 << PARTN_BITS)
@@ -102,13 +102,13 @@ static void ide_gd_resume(ide_drive_t *drive)
 		(void)drive->disk_ops->get_capacity(drive);
 }
 
-static const struct dmi_system_id ide_coldreboot_table[] = {
+static const struct sysfw_id ide_coldreboot_table[] = {
 	{
 		/* Acer TravelMate 66x cuts power during reboot */
 		.ident   = "Acer TravelMate 660",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TravelMate 660"),
 		},
 	},
 
@@ -132,7 +132,7 @@ static void ide_gd_shutdown(ide_drive_t *drive)
 	if (system_state != SYSTEM_POWER_OFF) {
 #else
 	if (system_state == SYSTEM_RESTART &&
-		!dmi_check_system(ide_coldreboot_table)) {
+	    !sysfw_callback(ide_coldreboot_table)) {
 #endif
 		drive->disk_ops->flush(drive);
 		return;
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index f46f49c..a51eb2b 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -30,7 +30,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #ifdef CONFIG_PPC_CHRP
 #include <asm/processor.h>
@@ -354,21 +354,21 @@ static int init_chipset_via82cxxx(struct pci_dev *dev)
  *	Cable special cases
  */
 
-static const struct dmi_system_id cable_dmi_table[] = {
+static const struct sysfw_id cable_smbios_table[] = {
 	{
 		.ident = "Acer Ferrari 3400",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Acer,Inc."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "Ferrari 3400"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int via_cable_override(struct pci_dev *pdev)
 {
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
+	/* Systems by SMBIOS */
+	if (sysfw_callback(cable_smbios_table))
 		return 1;
 
 	/* Arima W730-K8/Targa Visionary 811/... */
-- 
1.7.5.4

