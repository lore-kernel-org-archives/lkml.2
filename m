Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab1FWRXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab1FWRXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:25 -0400
Date: Thu, 23 Jun 2011 13:23:24 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172324.27664.88502.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 12/35] drivers/i2c changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/i2c changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/i2c/busses/i2c-i801.c    |   76 ++++++++++---------------------------
 drivers/i2c/busses/i2c-nforce2.c |   12 +++---
 drivers/i2c/busses/i2c-piix4.c   |   24 ++++++------
 3 files changed, 39 insertions(+), 73 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ab26840d..7e19ea2 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -73,7 +73,8 @@
 #include <linux/i2c.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
+#include <linux/sysfw.h>
 #include <linux/slab.h>
 
 /* I801 SMBus address offsets */
@@ -669,69 +670,34 @@ static void __init input_apanel_init(void)
 	iounmap(bios);
 }
 
-struct dmi_onboard_device_info {
+struct smbios_onboard_device_info {
 	const char *name;
-	u8 type;
 	unsigned short i2c_addr;
 	const char *i2c_type;
 };
 
-static struct dmi_onboard_device_info __devinitdata dmi_devices[] = {
-	{ "Syleus", DMI_DEV_TYPE_OTHER, 0x73, "fscsyl" },
-	{ "Hermes", DMI_DEV_TYPE_OTHER, 0x73, "fscher" },
-	{ "Hades",  DMI_DEV_TYPE_OTHER, 0x73, "fschds" },
+static struct smbios_onboard_device_info __devinitdata smbios_devices[] = {
+	{ "Syleus", 0x73, "fscsyl" },
+	{ "SYLEUS", 0x73, "fscsyl" },
+	{ "Hermes", 0x73, "fscher" },
+	{ "HERMES", 0x73, "fscher" },
+	{ "Hades", 0x73, "fschds" },
+	{ "HADES", 0x73, "fschds" },
 };
 
-static void __devinit dmi_check_onboard_device(u8 type, const char *name,
-					       struct i2c_adapter *adap)
+static void __devinit smbios_check_fschmd(struct i2c_adapter *adap)
 {
 	int i;
 	struct i2c_board_info info;
 
-	for (i = 0; i < ARRAY_SIZE(dmi_devices); i++) {
-		/* & ~0x80, ignore enabled/disabled bit */
-		if ((type & ~0x80) != dmi_devices[i].type)
-			continue;
-		if (strcasecmp(name, dmi_devices[i].name))
-			continue;
-
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		info.addr = dmi_devices[i].i2c_addr;
-		strlcpy(info.type, dmi_devices[i].i2c_type, I2C_NAME_SIZE);
-		i2c_new_device(adap, &info);
-		break;
-	}
-}
-
-/* We use our own function to check for onboard devices instead of
-   dmi_find_device() as some buggy BIOS's have the devices we are interested
-   in marked as disabled */
-static void __devinit dmi_check_onboard_devices(const struct dmi_header *dm,
-						void *adap)
-{
-	int i, count;
-
-	if (dm->type != 10)
-		return;
-
-	count = (dm->length - sizeof(struct dmi_header)) / 2;
-	for (i = 0; i < count; i++) {
-		const u8 *d = (char *)(dm + 1) + (i * 2);
-		const char *name = ((char *) dm) + dm->length;
-		u8 type = d[0];
-		u8 s = d[1];
-
-		if (!s)
-			continue;
-		s--;
-		while (s > 0 && name[0]) {
-			name += strlen(name) + 1;
-			s--;
+	for (i = 0; i < ARRAY_SIZE(onboard); i++) {
+		/* some buggy BIOSes have the devices disabled */
+		if (smbios_is_onboard_device(onboard[i].name, 1)) {
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			info.addr = onboard[i].i2c_addr;
+			strlcpy(info.type, onboard[i].i2c_type,	I2C_NAME_SIZE);
+			i2c_new_device(adap, &info);
 		}
-		if (name[0] == 0) /* Bogus string reference */
-			continue;
-
-		dmi_check_onboard_device(type, name, adap);
 	}
 }
 
@@ -751,8 +717,8 @@ static void __devinit i801_probe_optional_slaves(struct i801_priv *priv)
 		i2c_new_device(&priv->adapter, &info);
 	}
 
-	if (dmi_name_in_vendors("FUJITSU"))
-		dmi_walk(dmi_check_onboard_devices, &priv->adapter);
+	if (sysfw_vendor_is("FUJITSU"))
+		smbios_check_fschmd(&priv->adapter);
 }
 #else
 static void __init input_apanel_init(void) {}
@@ -927,7 +893,7 @@ static struct pci_driver i801_driver = {
 
 static int __init i2c_i801_init(void)
 {
-	if (dmi_name_in_vendors("FUJITSU"))
+	if (sysfw_vendor_is("FUJITSU"))
 		input_apanel_init();
 	return pci_register_driver(&i801_driver);
 }
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index ff1e127..458623e 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -54,7 +54,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -117,15 +117,15 @@ struct nforce2_smbus {
 #define MAX_TIMEOUT	100
 
 /* We disable the second SMBus channel on these boards */
-static struct dmi_system_id __devinitdata nforce2_dmi_blacklist2[] = {
+static struct sysfw_id __devinitdata nforce2_id_blacklist2[] = {
 	{
 		.ident = "DFI Lanparty NF4 Expert",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "DFI Corp,LTD"),
-			DMI_MATCH(DMI_BOARD_NAME, "LP UT NF4 Expert"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "DFI Corp,LTD"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "LP UT NF4 Expert"),
 		},
 	},
-	{ }
+	{}
 };
 
 static struct pci_driver nforce2_driver;
@@ -408,7 +408,7 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
 		smbuses[0].base = 0;	/* to have a check value */
 
 	/* SMBus adapter 2 */
-	if (dmi_check_system(nforce2_dmi_blacklist2)) {
+	if (sysfw_callback(nforce2_id_blacklist2)) {
 		dev_err(&dev->dev, "Disabling SMB2 for safety reasons.\n");
 		res2 = -EPERM;
 		smbuses[1].base = 0;
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 6d14ac2..12b4019 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -37,7 +37,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
 
@@ -99,32 +99,32 @@ static int srvrworks_csb5_delay;
 static struct pci_driver piix4_driver;
 static struct i2c_adapter piix4_adapter;
 
-static struct dmi_system_id __devinitdata piix4_dmi_blacklist[] = {
+static struct sysfw_id __devinitdata piix4_id_blacklist[] = {
 	{
 		.ident = "Sapphire AM2RD790",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "SAPPHIRE Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "PC-AM2RD790"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "SAPPHIRE Inc."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "PC-AM2RD790"),
 		},
 	},
 	{
 		.ident = "DFI Lanparty UT 790FX",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "DFI Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "LP UT 790FX"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "DFI Inc."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "LP UT 790FX"),
 		},
 	},
-	{ }
+	{}
 };
 
 /* The IBM entry is in a separate table because we only check it
    on Intel-based systems */
-static struct dmi_system_id __devinitdata piix4_dmi_ibm[] = {
+static struct sysfw_id __devinitdata piix4_id_ibm[] = {
 	{
 		.ident = "IBM",
-		.matches = { DMI_MATCH(DMI_SYS_VENDOR, "IBM"), },
+		.matches = { SYSFW_MATCH(SYSFW_SYS_VENDOR, "IBM"), },
 	},
-	{ },
+	{},
 };
 
 static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
@@ -138,14 +138,14 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 
 	/* On some motherboards, it was reported that accessing the SMBus
 	   caused severe hardware problems */
-	if (dmi_check_system(piix4_dmi_blacklist)) {
+	if (sysfw_callback(piix4_id_blacklist)) {
 		dev_err(&PIIX4_dev->dev,
 			"Accessing the SMBus on this system is unsafe!\n");
 		return -EPERM;
 	}
 
 	/* Don't access SMBus on IBM systems which get corrupted eeproms */
-	if (dmi_check_system(piix4_dmi_ibm) &&
+	if (sysfw_callback(piix4_id_ibm) &&
 			PIIX4_dev->vendor == PCI_VENDOR_ID_INTEL) {
 		dev_err(&PIIX4_dev->dev, "IBM system detected; this module "
 			"may corrupt your serial eeprom! Refusing to load "
-- 
1.7.5.4

