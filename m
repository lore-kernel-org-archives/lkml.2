Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab1FWRWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab1FWRWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:41 -0400
Date: Thu, 23 Jun 2011 13:22:40 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172240.27628.71518.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 05/35] drivers/ata changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/ata/acard-ahci.c  |    1 -
 drivers/ata/ahci.c        |  177 +++++++++++++++++++++++----------------------
 drivers/ata/ata_piix.c    |  156 +++++++++++++++++++++++-----------------
 drivers/ata/pata_ali.c    |   18 +++---
 drivers/ata/pata_cs5530.c |   12 ++--
 drivers/ata/pata_rdc.c    |    1 -
 drivers/ata/pata_sch.c    |    1 -
 drivers/ata/pata_via.c    |   14 ++--
 drivers/ata/sata_sil.c    |   19 +++---
 9 files changed, 210 insertions(+), 189 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index ae22be4..d16b700 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -42,7 +42,6 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
-#include <linux/dmi.h>
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 71afe03..90100c4 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -41,7 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
@@ -742,21 +742,22 @@ static void ahci_pci_print_info(struct ata_host *host)
  */
 static void ahci_p5wdh_workaround(struct ata_host *host)
 {
-	static struct dmi_system_id sysids[] = {
+	static struct sysfw_id sysids[] = {
 		{
 			.ident = "P5W DH Deluxe",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR,
-					  "ASUSTEK COMPUTER INC"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "P5W DH Deluxe"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "ASUSTEK COMPUTER INC"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "P5W DH Deluxe"),
 			},
 		},
-		{ }
+		{}
 	};
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 
 	if (pdev->bus->number == 0 && pdev->devfn == PCI_DEVFN(0x1f, 2) &&
-	    dmi_check_system(sysids)) {
+	    sysfw_callback(sysids)) {
 		struct ata_port *ap = host->ports[1];
 
 		dev_printk(KERN_INFO, &pdev->dev, "enabling ASUS P5W DH "
@@ -770,7 +771,7 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 /* only some SB600 ahci controllers can do 64bit DMA */
 static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 {
-	static const struct dmi_system_id sysids[] = {
+	static const struct sysfw_id sysids[] = {
 		/*
 		 * The oldest version known to be broken is 0901 and
 		 * working is 1501 which was released on 2007-10-26.
@@ -781,43 +782,41 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 		{
 			.ident = "ASUS M2A-VM",
 			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "ASUSTeK Computer INC."),
-				DMI_MATCH(DMI_BOARD_NAME, "M2A-VM"),
+				SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+					    "ASUSTeK Computer INC."),
+				SYSFW_MATCH(SYSFW_BOARD_NAME, "M2A-VM"),
 			},
-			.driver_data = "20071026",	/* yyyymmdd */
+			.driver_data = (void *)20071026, /* yyyymmdd */
 		},
 		/*
 		 * All BIOS versions for the MSI K9A2 Platinum (MS-7376)
 		 * support 64bit DMA.
 		 *
-		 * BIOS versions earlier than 1.5 had the Manufacturer DMI
+		 * BIOS versions earlier than 1.5 had the Manufacturer SMBIOS
 		 * fields as "MICRO-STAR INTERANTIONAL CO.,LTD".
 		 * This spelling mistake was fixed in BIOS version 1.5, so
 		 * 1.5 and later have the Manufacturer as
 		 * "MICRO-STAR INTERNATIONAL CO.,LTD".
-		 * So try to match on DMI_BOARD_VENDOR of "MICRO-STAR INTER".
+		 * So try to match on SYSFW_BOARD_VENDOR of "MICRO-STAR INTER".
 		 *
 		 * BIOS versions earlier than 1.9 had a Board Product Name
-		 * DMI field of "MS-7376". This was changed to be
+		 * SMBIOS field of "MS-7376". This was changed to be
 		 * "K9A2 Platinum (MS-7376)" in version 1.9, but we can still
-		 * match on DMI_BOARD_NAME of "MS-7376".
+		 * match on SYSFW_BOARD_NAME of "MS-7376".
 		 */
 		{
 			.ident = "MSI K9A2 Platinum",
 			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "MICRO-STAR INTER"),
-				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
+				SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+					    "MICRO-STAR INTER"),
+				SYSFW_MATCH(SYSFW_BOARD_NAME, "MS-7376"),
 			},
 		},
-		{ }
+		{}
 	};
-	const struct dmi_system_id *match;
-	int year, month, date;
-	char buf[9];
+	const struct sysfw_id *match;
 
-	match = dmi_first_match(sysids);
+	match = sysfw_callback(sysids);
 	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
 	    !match)
 		return false;
@@ -825,14 +824,12 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 	if (!match->driver_data)
 		goto enable_64bit;
 
-	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
-	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
-
-	if (strcmp(buf, match->driver_data) >= 0)
+	if (sysfw_get_date() >= (unsigned long)match->driver_data)
 		goto enable_64bit;
 	else {
-		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
-			   "forcing 32bit DMA, update BIOS\n", match->ident);
+		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, %s "
+			   "forcing 32bit DMA, update BIOS\n", match->ident,
+			   sysfw_lookup(SYSFW_BIOS_DATE));
 		return false;
 	}
 
@@ -844,12 +841,14 @@ enable_64bit:
 
 static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 {
-	static const struct dmi_system_id broken_systems[] = {
+	static const struct sysfw_id broken_systems[] = {
 		{
 			.ident = "HP Compaq nx6310",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6310"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Compaq nx6310"),
 			},
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
@@ -857,19 +856,20 @@ static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 		{
 			.ident = "HP Compaq 6720s",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6720s"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Compaq 6720s"),
 			},
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
 		},
-
-		{ }	/* terminate list */
+		{}
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+	const struct sysfw_id *id = sysfw_callback(broken_systems);
 
-	if (dmi) {
-		unsigned long slot = (unsigned long)dmi->driver_data;
+	if (id) {
+		unsigned long slot = (unsigned long)id->driver_data;
 		/* apply the quirk only to on-board controllers */
 		return slot == PCI_SLOT(pdev->devfn);
 	}
@@ -879,7 +879,7 @@ static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 
 static bool ahci_broken_suspend(struct pci_dev *pdev)
 {
-	static const struct dmi_system_id sysids[] = {
+	static const struct sysfw_id sysids[] = {
 		/*
 		 * On HP dv[4-6] and HDX18 with earlier BIOSen, link
 		 * to the harddisk doesn't become online after
@@ -896,38 +896,42 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 		{
 			.ident = "dv4",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP Pavilion dv4 Notebook PC"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Pavilion dv4 Notebook PC"),
 			},
-			.driver_data = "20090105",	/* F.30 */
+			.driver_data = (void *)20090105, /* F.30 */
 		},
 		{
 			.ident = "dv5",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP Pavilion dv5 Notebook PC"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Pavilion dv5 Notebook PC"),
 			},
-			.driver_data = "20090506",	/* F.16 */
+			.driver_data = (void *)20090506, /* F.16 */
 		},
 		{
 			.ident = "dv6",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP Pavilion dv6 Notebook PC"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Pavilion dv6 Notebook PC"),
 			},
-			.driver_data = "20090423",	/* F.21 */
+			.driver_data = (void *)20090423, /* F.21 */
 		},
 		{
 			.ident = "HDX18",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP HDX18 Notebook PC"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP HDX18 Notebook PC"),
 			},
-			.driver_data = "20090430",	/* F.23 */
+			.driver_data = (void *)20090430, /* F.23 */
 		},
 		/*
 		 * Acer eMachines G725 has the same problem.  BIOS
@@ -941,31 +945,27 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 		{
 			.ident = "G725",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "eMachines"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "eMachines G725"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "eMachines"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "eMachines G725"),
 			},
-			.driver_data = "20091216",	/* V3.04 */
+			.driver_data = (void *)20091216, /* V3.04 */
 		},
-		{ }	/* terminate list */
+		{}
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
-	int year, month, date;
-	char buf[9];
+	const struct sysfw_id *id = sysfw_callback(sysids);
 
-	if (!dmi || pdev->bus->number || pdev->devfn != PCI_DEVFN(0x1f, 2))
+	if (!id || pdev->bus->number || pdev->devfn != PCI_DEVFN(0x1f, 2))
 		return false;
 
-	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
-	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
-
-	return strcmp(buf, dmi->driver_data) < 0;
+	return (sysfw_get_date() < (unsigned long)id->driver_data);
 }
 
 static bool ahci_broken_online(struct pci_dev *pdev)
 {
 #define ENCODE_BUSDEVFN(bus, slot, func)			\
 	(void *)(unsigned long)(((bus) << 8) | PCI_DEVFN((slot), (func)))
-	static const struct dmi_system_id sysids[] = {
+	static const struct sysfw_id sysids[] = {
 		/*
 		 * There are several gigabyte boards which use
 		 * SIMG5723s configured as hardware RAID.  Certain
@@ -982,31 +982,31 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 		{
 			.ident = "EP45-DQ6",
 			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "Gigabyte Technology Co., Ltd."),
-				DMI_MATCH(DMI_BOARD_NAME, "EP45-DQ6"),
+				SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+					    "Gigabyte Technology Co., Ltd."),
+				SYSFW_MATCH(SYSFW_BOARD_NAME, "EP45-DQ6"),
 			},
 			.driver_data = ENCODE_BUSDEVFN(0x0a, 0x00, 0),
 		},
 		{
 			.ident = "EP45-DS5",
 			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "Gigabyte Technology Co., Ltd."),
-				DMI_MATCH(DMI_BOARD_NAME, "EP45-DS5"),
+				SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+					    "Gigabyte Technology Co., Ltd."),
+				SYSFW_MATCH(SYSFW_BOARD_NAME, "EP45-DS5"),
 			},
 			.driver_data = ENCODE_BUSDEVFN(0x03, 0x00, 0),
 		},
-		{ }	/* terminate list */
+		{}
 	};
 #undef ENCODE_BUSDEVFN
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	const struct sysfw_id *id = sysfw_callback(sysids);
 	unsigned int val;
 
-	if (!dmi)
+	if (!id)
 		return false;
 
-	val = (unsigned long)dmi->driver_data;
+	val = (unsigned long)id->driver_data;
 
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
@@ -1014,7 +1014,7 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 #ifdef CONFIG_ATA_ACPI
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
-	static const struct dmi_system_id sysids[] = {
+	static const struct sysfw_id sysids[] = {
 		/*
 		 * Aspire 3810T issues a bunch of SATA enable commands
 		 * via _GTF including an invalid one and one which is
@@ -1026,24 +1026,25 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
 		{
 			.ident = "Aspire 3810T",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3810T"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "Acer"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "Aspire 3810T"),
 			},
 			.driver_data = (void *)ATA_ACPI_FILTER_FPDMA_OFFSET,
 		},
-		{ }
+		{}
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	const struct sysfw_id *id = sysfw_callback(sysids);
 	unsigned int filter;
 	int i;
 
-	if (!dmi)
+	if (!id)
 		return;
 
-	filter = (unsigned long)dmi->driver_data;
+	filter = (unsigned long)id->driver_data;
 	dev_printk(KERN_INFO, host->dev,
 		   "applying extra ACPI _GTF filter 0x%x for %s\n",
-		   filter, dmi->ident);
+		   filter, id->ident);
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6f6e771..d1e0b19 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -93,7 +93,8 @@
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
+#include <linux/sysfw.h>
 
 #define DRV_NAME	"ata_piix"
 #define DRV_VERSION	"2.13"
@@ -1015,156 +1016,175 @@ static bool piix_irq_check(struct ata_port *ap)
 }
 
 #ifdef CONFIG_PM
+bool sysfw_match(int field, const char *str)
+{
+	const char *info = sysfw_lookup(field);
+
+	if (info == NULL || str == NULL)
+		return info == str;
+
+	return !strcmp(info, str);
+}
+
 static int piix_broken_suspend(void)
 {
-	static const struct dmi_system_id sysids[] = {
+	static const struct sysfw_id sysids[] = {
 		{
 			.ident = "TECRA M3",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M3"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA M3"),
 			},
 		},
 		{
 			.ident = "TECRA M3",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Tecra M3"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Tecra M3"),
 			},
 		},
 		{
 			.ident = "TECRA M4",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Tecra M4"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Tecra M4"),
 			},
 		},
 		{
 			.ident = "TECRA M4",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M4"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA M4"),
 			},
 		},
 		{
 			.ident = "TECRA M5",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M5"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA M5"),
 			},
 		},
 		{
 			.ident = "TECRA M6",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M6"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA M6"),
 			},
 		},
 		{
 			.ident = "TECRA M7",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M7"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA M7"),
 			},
 		},
 		{
 			.ident = "TECRA A8",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA A8"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA A8"),
 			},
 		},
 		{
 			.ident = "Satellite R20",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite R20"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "Satellite R20"),
 			},
 		},
 		{
 			.ident = "Satellite R25",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite R25"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "Satellite R25"),
 			},
 		},
 		{
 			.ident = "Satellite U200",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U200"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "Satellite U200"),
 			},
 		},
 		{
 			.ident = "Satellite U200",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE U200"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "SATELLITE U200"),
 			},
 		},
 		{
 			.ident = "Satellite Pro U200",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE PRO U200"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "SATELLITE PRO U200"),
 			},
 		},
 		{
 			.ident = "Satellite U205",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U205"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "Satellite U205"),
 			},
 		},
 		{
 			.ident = "SATELLITE U205",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE U205"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "SATELLITE U205"),
 			},
 		},
 		{
 			.ident = "Portege M500",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "PORTEGE M500"),
 			},
 		},
 		{
 			.ident = "VGN-BX297XP",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "VGN-BX297XP"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Sony Corporation"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "VGN-BX297XP"),
 			},
 		},
-
-		{ }	/* terminate list */
+		{}
 	};
 	static const char *oemstrs[] = {
 		"Tecra M3,",
 	};
 	int i;
 
-	if (dmi_check_system(sysids))
+	if (sysfw_callback(sysids))
 		return 1;
 
 	for (i = 0; i < ARRAY_SIZE(oemstrs); i++)
-		if (dmi_find_device(DMI_DEV_TYPE_OEM_STRING, oemstrs[i], NULL))
+		if (smbios_match_oem_string(oemstrs[i]))
 			return 1;
 
 	/* TECRA M4 sometimes forgets its identify and reports bogus
-	 * DMI information.  As the bogus information is a bit
-	 * generic, match as many entries as possible.  This manual
-	 * matching is necessary because dmi_system_id.matches is
+	 * system firmware(SMBIOS) information.  As the bogus information
+	 * is a bit generic, match as many entries as possible.  This manual
+	 * matching is necessary because sysfw_id.matches is
 	 * limited to four entries.
 	 */
-	if (dmi_match(DMI_SYS_VENDOR, "TOSHIBA") &&
-	    dmi_match(DMI_PRODUCT_NAME, "000000") &&
-	    dmi_match(DMI_PRODUCT_VERSION, "000000") &&
-	    dmi_match(DMI_PRODUCT_SERIAL, "000000") &&
-	    dmi_match(DMI_BOARD_VENDOR, "TOSHIBA") &&
-	    dmi_match(DMI_BOARD_NAME, "Portable PC") &&
-	    dmi_match(DMI_BOARD_VERSION, "Version A0"))
+	if (sysfw_match(SYSFW_SYS_VENDOR, "TOSHIBA") &&
+	    sysfw_match(SYSFW_PRODUCT_NAME, "000000") &&
+	    sysfw_match(SYSFW_PRODUCT_VERSION, "000000") &&
+	    sysfw_match(SYSFW_PRODUCT_SERIAL, "000000") &&
+	    sysfw_match(SYSFW_BOARD_VENDOR, "TOSHIBA") &&
+	    sysfw_match(SYSFW_BOARD_NAME, "Portable PC") &&
+	    sysfw_match(SYSFW_BOARD_VERSION, "Version A0"))
 		return 1;
 
 	return 0;
@@ -1383,7 +1403,7 @@ static bool piix_no_sidpr(struct ata_host *host)
 	 * while not responding to SRST protocol causing excessive
 	 * detection delay.
 	 *
-	 * Unfortunately, the system doesn't carry enough DMI
+	 * Unfortunately, the system doesn't carry enough SMBIOS
 	 * information to identify the machine but does have subsystem
 	 * vendor and device set.  As it's unclear whether the
 	 * subsystem vendor/device is used only for this specific
@@ -1475,7 +1495,7 @@ static int __devinit piix_init_sidpr(struct ata_host *host)
 
 static void piix_iocfg_bit18_quirk(struct ata_host *host)
 {
-	static const struct dmi_system_id sysids[] = {
+	static const struct sysfw_id sysids[] = {
 		{
 			/* Clevo M570U sets IOCFG bit 18 if the cdrom
 			 * isn't used to boot the system which
@@ -1483,17 +1503,16 @@ static void piix_iocfg_bit18_quirk(struct ata_host *host)
 			 */
 			.ident = "M570U",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Clevo Co."),
-				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR, "Clevo Co."),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "M570U"),
 			},
 		},
-
-		{ }	/* terminate list */
+		{}
 	};
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct piix_host_priv *hpriv = host->private_data;
 
-	if (!dmi_check_system(sysids))
+	if (!sysfw_callback(sysids))
 		return;
 
 	/* The datasheet says that bit 18 is NOOP but certain systems
@@ -1510,12 +1529,14 @@ static void piix_iocfg_bit18_quirk(struct ata_host *host)
 
 static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 {
-	static const struct dmi_system_id broken_systems[] = {
+	static const struct sysfw_id broken_systems[] = {
 		{
 			.ident = "HP Compaq 2510p",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2510p"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Compaq 2510p"),
 			},
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
@@ -1523,19 +1544,20 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 		{
 			.ident = "HP Compaq nc6000",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nc6000"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Compaq nc6000"),
 			},
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
 		},
-
-		{ }	/* terminate list */
+		{}
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+	const struct sysfw_id *id = sysfw_callback(broken_systems);
 
-	if (dmi) {
-		unsigned long slot = (unsigned long)dmi->driver_data;
+	if (id) {
+		unsigned long slot = (unsigned long)id->driver_data;
 		/* apply the quirk only to on-board controllers */
 		return slot == PCI_SLOT(pdev->devfn);
 	}
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 794ec6e..d6e158b 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -32,7 +32,7 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define DRV_NAME "pata_ali"
 #define DRV_VERSION "0.7.8"
@@ -47,22 +47,22 @@ static struct pci_dev *ali_isa_bridge;
  *	Cable special cases
  */
 
-static const struct dmi_system_id cable_dmi_table[] = {
+static const struct sysfw_id cable_override_table[] = {
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
 		.ident = "Toshiba Satelite S1800-814",
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
@@ -73,8 +73,8 @@ static int ali_cable_override(struct pci_dev *pdev)
 	/* Mitac 8317 (Winbook-A) and relatives */
 	if (pdev->subsystem_vendor == 0x1071 && pdev->subsystem_device == 0x8317)
 		return 1;
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
+	/* Systems by SMBIOS */
+	if (sysfw_callback(cable_override_table))
 		return 1;
 	return 0;
 }
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index f792330..085820a 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -31,7 +31,7 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define DRV_NAME	"pata_cs5530"
 #define DRV_VERSION	"0.7.4"
@@ -175,20 +175,20 @@ static struct ata_port_operations cs5530_port_ops = {
 	.set_dmamode	= cs5530_set_dmamode,
 };
 
-static const struct dmi_system_id palmax_dmi_table[] = {
+static const struct sysfw_id palmax_id_table[] = {
 	{
 		.ident = "Palmax PD1100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Cyrix"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Caddis"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Cyrix"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Caddis"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int cs5530_is_palmax(void)
 {
-	if (dmi_check_system(palmax_dmi_table)) {
+	if (sysfw_callback(palmax_id_table)) {
 		printk(KERN_INFO "Palmax PD1100: Disabling DMA on docking port.\n");
 		return 1;
 	}
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 5fbe9b1..497f514 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -31,7 +31,6 @@
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
 
 #define DRV_NAME	"pata_rdc"
 #define DRV_VERSION	"0.01"
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index e97b32f..8b95c13 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -33,7 +33,6 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
 
 #define DRV_NAME	"pata_sch"
 #define DRV_VERSION	"0.2"
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ac8d7d9..2175119 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -61,7 +61,7 @@
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define DRV_NAME "pata_via"
 #define DRV_VERSION "0.3.4"
@@ -132,21 +132,21 @@ struct via_port {
  *	Cable special cases
  */
 
-static const struct dmi_system_id cable_dmi_table[] = {
+static const struct sysfw_id cable_override_table[] = {
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
+	if (sysfw_callback(cable_override_table))
 		return 1;
 	/* Arima W730-K8/Targa Visionary 811/... */
 	if (pdev->subsystem_vendor == 0x161F && pdev->subsystem_device == 0x2032)
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index b42edaa..fff0e2b 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -44,7 +44,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define DRV_NAME	"sata_sil"
 #define DRV_VERSION	"2.4"
@@ -707,23 +707,24 @@ static void sil_init_controller(struct ata_host *host)
 
 static bool sil_broken_system_poweroff(struct pci_dev *pdev)
 {
-	static const struct dmi_system_id broken_systems[] = {
+	static const struct sysfw_id broken_systems[] = {
 		{
 			.ident = "HP Compaq nx6325",
 			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					    "Hewlett-Packard"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME,
+					    "HP Compaq nx6325"),
 			},
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x12UL,
 		},
-
-		{ }	/* terminate list */
+		{}	/* terminate list */
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+	const struct sysfw_id *id = sysfw_callback(broken_systems);
 
-	if (dmi) {
-		unsigned long slot = (unsigned long)dmi->driver_data;
+	if (id) {
+		unsigned long slot = (unsigned long)id->driver_data;
 		/* apply the quirk only to on-board controllers */
 		return slot == PCI_SLOT(pdev->devfn);
 	}
-- 
1.7.5.4

