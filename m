Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2HYO0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 10:26:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53524 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab2HYO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 10:26:29 -0400
Date: Sat, 25 Aug 2012 10:26:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20120825142628.GA20643@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Changes:
1) libata-acpi regression fix

2) additional or corrected drive quirks for ata_blacklist

3) Kconfig text tweaking

4) new PCI IDs

5) pata_atiixp: quirk for MSI motherboard

6) export ahci_dev_classify for an ahci_platform driver


Please pull d17d794c63e2dc0a5b1ffc8367c9475880427fc7 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

 drivers/ata/Kconfig       |    2 +-
 drivers/ata/ahci.c        |    8 ++++++++
 drivers/ata/ahci.h        |    1 +
 drivers/ata/ata_piix.c    |    8 ++++++++
 drivers/ata/libahci.c     |    3 ++-
 drivers/ata/libata-acpi.c |   15 ++++-----------
 drivers/ata/libata-core.c |    3 ++-
 drivers/ata/pata_atiixp.c |   16 ++++++++++++++++
 8 files changed, 42 insertions(+), 14 deletions(-)

Aaron Lu (1):
      [libata] acpi: call ata_acpi_gtm during ata port init time

Arnd Hannemann (1):
      pata_atiixp: override cable detection on MSI E350DM-E33

James Ralston (2):
      ahci: Add Device IDs for Intel Lynx Point-LP PCH
      ata_piix: Add Device IDs for Intel Lynx Point-LP PCH

Jeff Garzik (1):
      [libata] new quirk, lift bridge limits for Buffalo DriveStation Quattro

Paul Menzel (1):
      [libata] Kconfig: Elaborate that SFF is meant for legacy and PATA stuff

Prarit Bhargava (1):
      libata: Add a space to " 2GB ATA Flash Disk" DMA blacklist entry

Rob Herring (1):
      ahci: un-staticize ahci_dev_classify

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 2be8ef1..27cecd3 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -115,7 +115,7 @@ config SATA_SIL24
 	  If unsure, say N.
 
 config ATA_SFF
-	bool "ATA SFF support"
+	bool "ATA SFF support (for legacy IDE and PATA)"
 	default y
 	help
 	  This option adds support for ATA controllers with SFF
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 062e6a1..50d5dea 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -256,6 +256,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x8c07), board_ahci }, /* Lynx Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c0e), board_ahci }, /* Lynx Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c0f), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c02), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c03), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c04), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c05), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c06), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index c2594dd..57eb1c2 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -320,6 +320,7 @@ extern struct device_attribute *ahci_sdev_attrs[];
 extern struct ata_port_operations ahci_ops;
 extern struct ata_port_operations ahci_pmp_retry_srst_ops;
 
+unsigned int ahci_dev_classify(struct ata_port *ap);
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts);
 void ahci_save_initial_config(struct device *dev,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3c809bf..ef773e1 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -329,6 +329,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index f9eaa82..555c07a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1139,7 +1139,7 @@ static void ahci_dev_config(struct ata_device *dev)
 	}
 }
 
-static unsigned int ahci_dev_classify(struct ata_port *ap)
+unsigned int ahci_dev_classify(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_taskfile tf;
@@ -1153,6 +1153,7 @@ static unsigned int ahci_dev_classify(struct ata_port *ap)
 
 	return ata_dev_classify(&tf);
 }
+EXPORT_SYMBOL_GPL(ahci_dev_classify);
 
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..fd9ecf7 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -60,17 +60,7 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
 
-	/*
-	 * If acpi bind operation has already happened, we can get the handle
-	 * for the port by checking the corresponding scsi_host device's
-	 * firmware node, otherwise we will need to find out the handle from
-	 * its parent's acpi node.
-	 */
-	if (ap->scsi_host)
-		return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
-	else
-		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
-				ap->port_no);
+	return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), ap->port_no);
 }
 EXPORT_SYMBOL(ata_ap_acpi_handle);
 
@@ -1101,6 +1091,9 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
+	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
+
 	return 0;
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fadd586..8e1039c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4062,7 +4062,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124", "N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
-	{ "2GB ATA Flash Disk", "ADMA428M",	ATA_HORKAGE_NODMA },
+	{ " 2GB ATA Flash Disk", "ADMA428M",	ATA_HORKAGE_NODMA },
 	/* Odd clown on sil3726/4726 PMPs */
 	{ "Config  Disk",	NULL,		ATA_HORKAGE_DISABLE },
 
@@ -4128,6 +4128,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Devices that do not need bridging limits applied */
 	{ "MTRON MSP-SATA*",		NULL,	ATA_HORKAGE_BRIDGE_OK, },
+	{ "BUFFALO HD-QSU2/R5",		NULL,	ATA_HORKAGE_BRIDGE_OK, },
 
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 361c75c..24e5105 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include <linux/dmi.h>
 
 #define DRV_NAME "pata_atiixp"
 #define DRV_VERSION "0.4.6"
@@ -33,11 +34,26 @@ enum {
 	ATIIXP_IDE_UDMA_MODE 	= 0x56
 };
 
+static const struct dmi_system_id attixp_cable_override_dmi_table[] = {
+	{
+		/* Board has onboard PATA<->SATA converters */
+		.ident = "MSI E350DM-E33",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
+			DMI_MATCH(DMI_BOARD_NAME, "E350DM-E33(MS-7720)"),
+		},
+	},
+	{ }
+};
+
 static int atiixp_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 udma;
 
+	if (dmi_check_system(attixp_cable_override_dmi_table))
+		return ATA_CBL_PATA40_SHORT;
+
 	/* Hack from drivers/ide/pci. Really we want to know how to do the
 	   raw detection not play follow the bios mode guess */
 	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
