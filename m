Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab0HDBzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:55:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60783 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008Ab0HDBzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:55:32 -0400
Date: Tue, 3 Aug 2010 21:55:30 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20100804015530.GA8136@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig           |   18 +
 drivers/ata/Makefile          |    2 +
 drivers/ata/ahci.c            |    2 +-
 drivers/ata/ahci_platform.c   |   26 +-
 drivers/ata/ata_generic.c     |    4 -
 drivers/ata/ata_piix.c        |    8 +
 drivers/ata/libata-core.c     |  161 ++---
 drivers/ata/libata-eh.c       |    1 +
 drivers/ata/pata_samsung_cf.c |  683 ++++++++++++++++
 drivers/ata/pata_scc.c        |    3 +-
 drivers/ata/sata_dwc_460ex.c  | 1756 +++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_fsl.c        |   20 +-
 drivers/ata/sata_mv.c         |   47 +-
 drivers/ata/sata_nv.c         |   32 +-
 drivers/pci/quirks.c          |    6 +
 include/linux/ahci_platform.h |    4 +-
 include/linux/pci_ids.h       |    2 +
 17 files changed, 2616 insertions(+), 159 deletions(-)
 create mode 100644 drivers/ata/pata_samsung_cf.c
 create mode 100644 drivers/ata/sata_dwc_460ex.c

Abhilash Kesavan (1):
      [libata] Add Samsung PATA controller driver, pata_samsung_cf

Anton Vorontsov (1):
      ahci_platform: Remove unneeded ahci_driver.probe assignment

FUJITA Tomonori (1):
      [libata] add ATA_CMD_DSM to ata_get_cmd_descript

Jassi Brar (1):
      ahci_platform: Provide for vendor specific init

Justin P. Mattock (1):
      [libata] ahci: Fix warning: comparison between 'enum <anonymous>' and 'enum <anonymous>'

Mark Lord (5):
      libata: glob_match for ata_device_blacklist (v2)
      libata: reduce blacklist size (v2)
      libata: reduce blacklist size even more (v2)
      libata: allow hyphenated pattern ranges
      [libata] update blacklist for new hyphenated pattern ranges (v2)

Peter Huewe (1):
      ata: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)

Rupjyoti Sarmah (1):
      [libata] Add 460EX on-chip SATA driver, sata_dwc_460ex

Tejun Heo (4):
      ata_generic: drop hard coded DMA force logic for CENATEK
      ata_piix: fix locking around SIDPR access
      libata: more PCI IDs for jmicron controllers
      sata_fsl,mv,nv: prepare for NCQ command completion update

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index aa85a98..8fae6af 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -187,6 +187,15 @@ config ATA_PIIX
 
 	  If unsure, say N.
 
+config SATA_DWC
+	tristate "DesignWare Cores SATA support"
+	depends on 460EX
+	help
+	  This option enables support for the on-chip SATA controller of the
+	  AppliedMicro processor 460EX.
+
+	  If unsure, say N.
+
 config SATA_MV
 	tristate "Marvell SATA support"
 	help
@@ -796,6 +805,15 @@ config PATA_RZ1000
 
 	  If unsure, say N.
 
+config PATA_SAMSUNG_CF
+	tristate "Samsung SoC PATA support"
+	depends on SAMSUNG_DEV_IDE
+	help
+	  This option enables basic support for Samsung's S3C/S5P board
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 7ef89d7..6540632 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
 obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
+obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
@@ -87,6 +88,7 @@ obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
 obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
 obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
+obj-$(CONFIG_PATA_SAMSUNG_CF)	+= pata_samsung_cf.o
 obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
 
 # Should be last but two libata driver
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index f252253..fe75d8b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1042,7 +1042,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	VPRINTK("ENTER\n");
 
-	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
+	WARN_ON((int)ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 5e11b16..4e97f33 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -54,19 +54,13 @@ static int __init ahci_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (pdata && pdata->init) {
-		rc = pdata->init(dev);
-		if (rc)
-			return rc;
-	}
-
 	if (pdata && pdata->ata_port_info)
 		pi = *pdata->ata_port_info;
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv) {
-		rc = -ENOMEM;
-		goto err0;
+		dev_err(dev, "can't alloc ahci_host_priv\n");
+		return -ENOMEM;
 	}
 
 	hpriv->flags |= (unsigned long)pi.private_data;
@@ -74,8 +68,19 @@ static int __init ahci_probe(struct platform_device *pdev)
 	hpriv->mmio = devm_ioremap(dev, mem->start, resource_size(mem));
 	if (!hpriv->mmio) {
 		dev_err(dev, "can't map %pR\n", mem);
-		rc = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
+	}
+
+	/*
+	 * Some platforms might need to prepare for mmio region access,
+	 * which could be done in the following init call. So, the mmio
+	 * region shouldn't be accessed before init (if provided) has
+	 * returned successfully.
+	 */
+	if (pdata && pdata->init) {
+		rc = pdata->init(dev, hpriv->mmio);
+		if (rc)
+			return rc;
 	}
 
 	ahci_save_initial_config(dev, hpriv,
@@ -166,7 +171,6 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver ahci_driver = {
-	.probe = ahci_probe,
 	.remove = __devexit_p(ahci_remove),
 	.driver = {
 		.name = "ahci",
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 7107a69..cc5f772 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -54,7 +54,6 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 	const struct pci_device_id *id = ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (id->driver_data & ATA_GEN_FORCE_DMA) {
 		dma_enabled = 0xff;
@@ -63,9 +62,6 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 	}
 
-	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
-		dma_enabled = 0xFF;
-
 	ata_for_each_dev(dev, link, ENABLED) {
 		/* We don't really care */
 		dev->pio_mode = XFER_PIO_0;
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7409f98..3971bc0 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -158,6 +158,7 @@ struct piix_map_db {
 struct piix_host_priv {
 	const int *map;
 	u32 saved_iocfg;
+	spinlock_t sidpr_lock;	/* FIXME: remove once locking in EH is fixed */
 	void __iomem *sidpr;
 };
 
@@ -951,12 +952,15 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
+	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
+	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	*val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
+	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -964,12 +968,15 @@ static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
+	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
+	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
+	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -1566,6 +1573,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
+	spin_lock_init(&hpriv->sidpr_lock);
 
 	/* Save IOCFG, this will be used for cable detection, quirk
 	 * detection and restoration on detach.  This is necessary
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ddf8e48..a0a4d69 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4167,15 +4167,13 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "WDC AC23200L",	"21.10N21",	ATA_HORKAGE_NODMA },
 	{ "Compaq CRD-8241B", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "CRD-8400B",		NULL, 		ATA_HORKAGE_NODMA },
-	{ "CRD-8480B",		NULL,		ATA_HORKAGE_NODMA },
-	{ "CRD-8482B",		NULL,		ATA_HORKAGE_NODMA },
+	{ "CRD-848[02]B",	NULL,		ATA_HORKAGE_NODMA },
 	{ "CRD-84",		NULL,		ATA_HORKAGE_NODMA },
 	{ "SanDisk SDP3B",	NULL,		ATA_HORKAGE_NODMA },
 	{ "SanDisk SDP3B-64",	NULL,		ATA_HORKAGE_NODMA },
 	{ "SANYO CD-ROM CRD",	NULL,		ATA_HORKAGE_NODMA },
 	{ "HITACHI CDR-8",	NULL,		ATA_HORKAGE_NODMA },
-	{ "HITACHI CDR-8335",	NULL,		ATA_HORKAGE_NODMA },
-	{ "HITACHI CDR-8435",	NULL,		ATA_HORKAGE_NODMA },
+	{ "HITACHI CDR-8[34]35",NULL,		ATA_HORKAGE_NODMA },
 	{ "Toshiba CD-ROM XM-6202B", NULL,	ATA_HORKAGE_NODMA },
 	{ "TOSHIBA CD-ROM XM-1702BC", NULL,	ATA_HORKAGE_NODMA },
 	{ "CD-532E-A", 		NULL,		ATA_HORKAGE_NODMA },
@@ -4211,70 +4209,16 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "OCZ CORE_SSD",	"02.10104",	ATA_HORKAGE_NONCQ },
 
 	/* Seagate NCQ + FLUSH CACHE firmware bug */
-	{ "ST31500341AS",	"SD15",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31500341AS",	"SD16",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31500341AS",	"SD17",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31500341AS",	"SD18",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31500341AS",	"SD19",		ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
-	{ "ST31000333AS",	"SD15",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31000333AS",	"SD16",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31000333AS",	"SD17",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31000333AS",	"SD18",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31000333AS",	"SD19",		ATA_HORKAGE_NONCQ |
+	{ "ST31000333AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
-	{ "ST3640623AS",	"SD15",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640623AS",	"SD16",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640623AS",	"SD17",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640623AS",	"SD18",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640623AS",	"SD19",		ATA_HORKAGE_NONCQ |
+	{ "ST3640[36]23AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
-	{ "ST3640323AS",	"SD15",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640323AS",	"SD16",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640323AS",	"SD17",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640323AS",	"SD18",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640323AS",	"SD19",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-
-	{ "ST3320813AS",	"SD15",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320813AS",	"SD16",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320813AS",	"SD17",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320813AS",	"SD18",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320813AS",	"SD19",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-
-	{ "ST3320613AS",	"SD15",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320613AS",	"SD16",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320613AS",	"SD17",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320613AS",	"SD18",		ATA_HORKAGE_NONCQ |
-						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320613AS",	"SD19",		ATA_HORKAGE_NONCQ |
+	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
@@ -4303,12 +4247,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices which get the IVB wrong */
 	{ "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
 	/* Maybe we should just blacklist TSSTcorp... */
-	{ "TSSTcorp CDDVDW SH-S202H", "SB00",	  ATA_HORKAGE_IVB, },
-	{ "TSSTcorp CDDVDW SH-S202H", "SB01",	  ATA_HORKAGE_IVB, },
-	{ "TSSTcorp CDDVDW SH-S202J", "SB00",	  ATA_HORKAGE_IVB, },
-	{ "TSSTcorp CDDVDW SH-S202J", "SB01",	  ATA_HORKAGE_IVB, },
-	{ "TSSTcorp CDDVDW SH-S202N", "SB00",	  ATA_HORKAGE_IVB, },
-	{ "TSSTcorp CDDVDW SH-S202N", "SB01",	  ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202[HJN]", "SB0[01]",  ATA_HORKAGE_IVB, },
 
 	/* Devices that do not need bridging limits applied */
 	{ "MTRON MSP-SATA*",		NULL,	ATA_HORKAGE_BRIDGE_OK, },
@@ -4326,29 +4265,73 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ }
 };
 
-static int strn_pattern_cmp(const char *patt, const char *name, int wildchar)
+/**
+ *	glob_match - match a text string against a glob-style pattern
+ *	@text: the string to be examined
+ *	@pattern: the glob-style pattern to be matched against
+ *
+ *	Either/both of text and pattern can be empty strings.
+ *
+ *	Match text against a glob-style pattern, with wildcards and simple sets:
+ *
+ *		?	matches any single character.
+ *		*	matches any run of characters.
+ *		[xyz]	matches a single character from the set: x, y, or z.
+ *		[a-d]	matches a single character from the range: a, b, c, or d.
+ *		[a-d0-9] matches a single character from either range.
+ *
+ *	The special characters ?, [, -, or *, can be matched using a set, eg. [*]
+ *	Behaviour with malformed patterns is undefined, though generally reasonable.
+ *
+ *	Example patterns:  "SD1?",  "SD1[0-5]",  "*R0",  SD*1?[012]*xx"
+ *
+ *	This function uses one level of recursion per '*' in pattern.
+ *	Since it calls _nothing_ else, and has _no_ explicit local variables,
+ *	this will not cause stack problems for any reasonable use here.
+ *
+ *	RETURNS:
+ *	0 on match, 1 otherwise.
+ */
+static int glob_match (const char *text, const char *pattern)
 {
-	const char *p;
-	int len;
-
-	/*
-	 * check for trailing wildcard: *\0
-	 */
-	p = strchr(patt, wildchar);
-	if (p && ((*(p + 1)) == 0))
-		len = p - patt;
-	else {
-		len = strlen(name);
-		if (!len) {
-			if (!*patt)
-				return 0;
-			return -1;
+	do {
+		/* Match single character or a '?' wildcard */
+		if (*text == *pattern || *pattern == '?') {
+			if (!*pattern++)
+				return 0;  /* End of both strings: match */
+		} else {
+			/* Match single char against a '[' bracketed ']' pattern set */
+			if (!*text || *pattern != '[')
+				break;  /* Not a pattern set */
+			while (*++pattern && *pattern != ']' && *text != *pattern) {
+				if (*pattern == '-' && *(pattern - 1) != '[')
+					if (*text > *(pattern - 1) && *text < *(pattern + 1)) {
+						++pattern;
+						break;
+					}
+			}
+			if (!*pattern || *pattern == ']')
+				return 1;  /* No match */
+			while (*pattern && *pattern++ != ']');
+		}
+	} while (*++text && *pattern);
+
+	/* Match any run of chars against a '*' wildcard */
+	if (*pattern == '*') {
+		if (!*++pattern)
+			return 0;  /* Match: avoid recursion at end of pattern */
+		/* Loop to handle additional pattern chars after the wildcard */
+		while (*text) {
+			if (glob_match(text, pattern) == 0)
+				return 0;  /* Remainder matched */
+			++text;  /* Absorb (match) this char and try again */
 		}
 	}
-
-	return strncmp(patt, name, len);
+	if (!*text && !*pattern)
+		return 0;  /* End of both strings: match */
+	return 1;  /* No match */
 }
-
+ 
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
@@ -4359,10 +4342,10 @@ static unsigned long ata_dev_blacklisted(const struct ata_device *dev)
 	ata_id_c_string(dev->id, model_rev, ATA_ID_FW_REV, sizeof(model_rev));
 
 	while (ad->model_num) {
-		if (!strn_pattern_cmp(ad->model_num, model_num, '*')) {
+		if (!glob_match(model_num, ad->model_num)) {
 			if (ad->model_rev == NULL)
 				return ad->horkage;
-			if (!strn_pattern_cmp(ad->model_rev, model_rev, '*'))
+			if (!glob_match(model_rev, ad->model_rev))
 				return ad->horkage;
 		}
 		ad++;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f77a673..697474b 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2214,6 +2214,7 @@ const char *ata_get_cmd_descript(u8 command)
 		{ ATA_CMD_SMART,		"SMART" },
 		{ ATA_CMD_MEDIA_LOCK,		"DOOR LOCK" },
 		{ ATA_CMD_MEDIA_UNLOCK,		"DOOR UNLOCK" },
+		{ ATA_CMD_DSM,			"DATA SET MANAGEMENT" },
 		{ ATA_CMD_CHK_MED_CRD_TYP, 	"CHECK MEDIA CARD TYPE" },
 		{ ATA_CMD_CFA_REQ_EXT_ERR, 	"CFA REQUEST EXTENDED ERROR" },
 		{ ATA_CMD_CFA_WRITE_NE,		"CFA WRITE SECTORS WITHOUT ERASE" },
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
new file mode 100644
index 0000000..6f9cfb2
--- /dev/null
+++ b/drivers/ata/pata_samsung_cf.c
@@ -0,0 +1,683 @@
+/*
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * PATA driver for Samsung SoCs.
+ * Supports CF Interface in True IDE mode. Currently only PIO mode has been
+ * implemented; UDMA support has to be added.
+ *
+ * Based on:
+ *	PATA driver for AT91SAM9260 Static Memory Controller
+ *	PATA driver for Toshiba SCC controller
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/libata.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include <plat/ata.h>
+#include <plat/regs-ata.h>
+
+#define DRV_NAME "pata_samsung_cf"
+#define DRV_VERSION "0.1"
+
+enum s3c_cpu_type {
+	TYPE_S3C64XX,
+	TYPE_S5PC100,
+	TYPE_S5PV210,
+};
+
+/*
+ * struct s3c_ide_info - S3C PATA instance.
+ * @clk: The clock resource for this controller.
+ * @ide_addr: The area mapped for the hardware registers.
+ * @sfr_addr: The area mapped for the special function registers.
+ * @irq: The IRQ number we are using.
+ * @cpu_type: The exact type of this controller.
+ * @fifo_status_reg: The ATA_FIFO_STATUS register offset.
+ */
+struct s3c_ide_info {
+	struct clk *clk;
+	void __iomem *ide_addr;
+	void __iomem *sfr_addr;
+	unsigned int irq;
+	enum s3c_cpu_type cpu_type;
+	unsigned int fifo_status_reg;
+};
+
+static void pata_s3c_set_endian(void __iomem *s3c_ide_regbase, u8 mode)
+{
+	u32 reg = readl(s3c_ide_regbase + S3C_ATA_CFG);
+	reg = mode ? (reg & ~S3C_ATA_CFG_SWAP) : (reg | S3C_ATA_CFG_SWAP);
+	writel(reg, s3c_ide_regbase + S3C_ATA_CFG);
+}
+
+static void pata_s3c_cfg_mode(void __iomem *s3c_ide_sfrbase)
+{
+	/* Select true-ide as the internal operating mode */
+	writel(readl(s3c_ide_sfrbase + S3C_CFATA_MUX) | S3C_CFATA_MUX_TRUEIDE,
+		s3c_ide_sfrbase + S3C_CFATA_MUX);
+}
+
+static unsigned long
+pata_s3c_setup_timing(struct s3c_ide_info *info, const struct ata_timing *ata)
+{
+	int t1 = ata->setup;
+	int t2 = ata->act8b;
+	int t2i = ata->rec8b;
+	ulong piotime;
+
+	piotime = ((t2i & 0xff) << 12) | ((t2 & 0xff) << 4) | (t1 & 0xf);
+
+	return piotime;
+}
+
+static void pata_s3c_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct s3c_ide_info *info = ap->host->private_data;
+	struct ata_timing timing;
+	int cycle_time;
+	ulong ata_cfg = readl(info->ide_addr + S3C_ATA_CFG);
+	ulong piotime;
+
+	/* Enables IORDY if mode requires it */
+	if (ata_pio_need_iordy(adev))
+		ata_cfg |= S3C_ATA_CFG_IORDYEN;
+	else
+		ata_cfg &= ~S3C_ATA_CFG_IORDYEN;
+
+	cycle_time = (int)(1000000000UL / clk_get_rate(info->clk));
+
+	ata_timing_compute(adev, adev->pio_mode, &timing,
+					cycle_time * 1000, 0);
+
+	piotime = pata_s3c_setup_timing(info, &timing);
+
+	writel(ata_cfg, info->ide_addr + S3C_ATA_CFG);
+	writel(piotime, info->ide_addr + S3C_ATA_PIO_TIME);
+}
+
+/*
+ * Waits until the IDE controller is able to perform next read/write
+ * operation to the disk. Needed for 64XX series boards only.
+ */
+static int wait_for_host_ready(struct s3c_ide_info *info)
+{
+	ulong timeout;
+	void __iomem *fifo_reg = info->ide_addr + info->fifo_status_reg;
+
+	/* wait for maximum of 20 msec */
+	timeout = jiffies + msecs_to_jiffies(20);
+	while (time_before(jiffies, timeout)) {
+		if ((readl(fifo_reg) >> 28) == 0)
+			return 0;
+	}
+	return -EBUSY;
+}
+
+/*
+ * Writes to one of the task file registers.
+ */
+static void ata_outb(struct ata_host *host, u8 addr, void __iomem *reg)
+{
+	struct s3c_ide_info *info = host->private_data;
+
+	wait_for_host_ready(info);
+	writeb(addr, reg);
+}
+
+/*
+ * Reads from one of the task file registers.
+ */
+static u8 ata_inb(struct ata_host *host, void __iomem *reg)
+{
+	struct s3c_ide_info *info = host->private_data;
+	u8 temp;
+
+	wait_for_host_ready(info);
+	(void) readb(reg);
+	wait_for_host_ready(info);
+	temp = readb(info->ide_addr + S3C_ATA_PIO_RDATA);
+	return temp;
+}
+
+/*
+ * pata_s3c_tf_load - send taskfile registers to host controller
+ */
+static void pata_s3c_tf_load(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	if (tf->ctl != ap->last_ctl) {
+		ata_outb(ap->host, tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+	}
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		ata_outb(ap->host, tf->hob_feature, ioaddr->feature_addr);
+		ata_outb(ap->host, tf->hob_nsect, ioaddr->nsect_addr);
+		ata_outb(ap->host, tf->hob_lbal, ioaddr->lbal_addr);
+		ata_outb(ap->host, tf->hob_lbam, ioaddr->lbam_addr);
+		ata_outb(ap->host, tf->hob_lbah, ioaddr->lbah_addr);
+	}
+
+	if (is_addr) {
+		ata_outb(ap->host, tf->feature, ioaddr->feature_addr);
+		ata_outb(ap->host, tf->nsect, ioaddr->nsect_addr);
+		ata_outb(ap->host, tf->lbal, ioaddr->lbal_addr);
+		ata_outb(ap->host, tf->lbam, ioaddr->lbam_addr);
+		ata_outb(ap->host, tf->lbah, ioaddr->lbah_addr);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE)
+		ata_outb(ap->host, tf->device, ioaddr->device_addr);
+
+	ata_wait_idle(ap);
+}
+
+/*
+ * pata_s3c_tf_read - input device's ATA taskfile shadow registers
+ */
+static void pata_s3c_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	tf->feature = ata_inb(ap->host, ioaddr->error_addr);
+	tf->nsect = ata_inb(ap->host, ioaddr->nsect_addr);
+	tf->lbal = ata_inb(ap->host, ioaddr->lbal_addr);
+	tf->lbam = ata_inb(ap->host, ioaddr->lbam_addr);
+	tf->lbah = ata_inb(ap->host, ioaddr->lbah_addr);
+	tf->device = ata_inb(ap->host, ioaddr->device_addr);
+
+	if (tf->flags & ATA_TFLAG_LBA48) {
+		ata_outb(ap->host, tf->ctl | ATA_HOB, ioaddr->ctl_addr);
+		tf->hob_feature = ata_inb(ap->host, ioaddr->error_addr);
+		tf->hob_nsect = ata_inb(ap->host, ioaddr->nsect_addr);
+		tf->hob_lbal = ata_inb(ap->host, ioaddr->lbal_addr);
+		tf->hob_lbam = ata_inb(ap->host, ioaddr->lbam_addr);
+		tf->hob_lbah = ata_inb(ap->host, ioaddr->lbah_addr);
+		ata_outb(ap->host, tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+	}
+}
+
+/*
+ * pata_s3c_exec_command - issue ATA command to host controller
+ */
+static void pata_s3c_exec_command(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	ata_outb(ap->host, tf->command, ap->ioaddr.command_addr);
+	ata_sff_pause(ap);
+}
+
+/*
+ * pata_s3c_check_status - Read device status register
+ */
+static u8 pata_s3c_check_status(struct ata_port *ap)
+{
+	return ata_inb(ap->host, ap->ioaddr.status_addr);
+}
+
+/*
+ * pata_s3c_check_altstatus - Read alternate device status register
+ */
+static u8 pata_s3c_check_altstatus(struct ata_port *ap)
+{
+	return ata_inb(ap->host, ap->ioaddr.altstatus_addr);
+}
+
+/*
+ * pata_s3c_data_xfer - Transfer data by PIO
+ */
+unsigned int pata_s3c_data_xfer(struct ata_device *dev, unsigned char *buf,
+				unsigned int buflen, int rw)
+{
+	struct ata_port *ap = dev->link->ap;
+	struct s3c_ide_info *info = ap->host->private_data;
+	void __iomem *data_addr = ap->ioaddr.data_addr;
+	unsigned int words = buflen >> 1, i;
+	u16 *data_ptr = (u16 *)buf;
+
+	/* Requires wait same as in ata_inb/ata_outb */
+	if (rw == READ)
+		for (i = 0; i < words; i++, data_ptr++) {
+			wait_for_host_ready(info);
+			(void) readw(data_addr);
+			wait_for_host_ready(info);
+			*data_ptr = readw(info->ide_addr
+					+ S3C_ATA_PIO_RDATA);
+		}
+	else
+		for (i = 0; i < words; i++, data_ptr++) {
+			wait_for_host_ready(info);
+			writew(*data_ptr, data_addr);
+		}
+
+	if (buflen & 0x01)
+		dev_err(ap->dev, "unexpected trailing data\n");
+
+	return words << 1;
+}
+
+/*
+ * pata_s3c_dev_select - Select device on ATA bus
+ */
+static void pata_s3c_dev_select(struct ata_port *ap, unsigned int device)
+{
+	u8 tmp = ATA_DEVICE_OBS;
+
+	if (device != 0)
+		tmp |= ATA_DEV1;
+
+	ata_outb(ap->host, tmp, ap->ioaddr.device_addr);
+	ata_sff_pause(ap);
+}
+
+/*
+ * pata_s3c_devchk - PATA device presence detection
+ */
+static unsigned int pata_s3c_devchk(struct ata_port *ap,
+				unsigned int device)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	u8 nsect, lbal;
+
+	pata_s3c_dev_select(ap, device);
+
+	ata_outb(ap->host, 0x55, ioaddr->nsect_addr);
+	ata_outb(ap->host, 0xaa, ioaddr->lbal_addr);
+
+	ata_outb(ap->host, 0xaa, ioaddr->nsect_addr);
+	ata_outb(ap->host, 0x55, ioaddr->lbal_addr);
+
+	ata_outb(ap->host, 0x55, ioaddr->nsect_addr);
+	ata_outb(ap->host, 0xaa, ioaddr->lbal_addr);
+
+	nsect = ata_inb(ap->host, ioaddr->nsect_addr);
+	lbal = ata_inb(ap->host, ioaddr->lbal_addr);
+
+	if ((nsect == 0x55) && (lbal == 0xaa))
+		return 1;	/* we found a device */
+
+	return 0;		/* nothing found */
+}
+
+/*
+ * pata_s3c_wait_after_reset - wait for devices to become ready after reset
+ */
+static int pata_s3c_wait_after_reset(struct ata_link *link,
+		unsigned long deadline)
+{
+	int rc;
+
+	msleep(ATA_WAIT_AFTER_RESET);
+
+	/* always check readiness of the master device */
+	rc = ata_sff_wait_ready(link, deadline);
+	/* -ENODEV means the odd clown forgot the D7 pulldown resistor
+	 * and TF status is 0xff, bail out on it too.
+	 */
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+/*
+ * pata_s3c_bus_softreset - PATA device software reset
+ */
+static unsigned int pata_s3c_bus_softreset(struct ata_port *ap,
+		unsigned long deadline)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	/* software reset.  causes dev0 to be selected */
+	ata_outb(ap->host, ap->ctl, ioaddr->ctl_addr);
+	udelay(20);
+	ata_outb(ap->host, ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+	udelay(20);
+	ata_outb(ap->host, ap->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = ap->ctl;
+
+	return pata_s3c_wait_after_reset(&ap->link, deadline);
+}
+
+/*
+ * pata_s3c_softreset - reset host port via ATA SRST
+ */
+static int pata_s3c_softreset(struct ata_link *link, unsigned int *classes,
+			 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	unsigned int devmask = 0;
+	int rc;
+	u8 err;
+
+	/* determine if device 0 is present */
+	if (pata_s3c_devchk(ap, 0))
+		devmask |= (1 << 0);
+
+	/* select device 0 again */
+	pata_s3c_dev_select(ap, 0);
+
+	/* issue bus reset */
+	rc = pata_s3c_bus_softreset(ap, deadline);
+	/* if link is occupied, -ENODEV too is an error */
+	if (rc && rc != -ENODEV) {
+		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	/* determine by signature whether we have ATA or ATAPI devices */
+	classes[0] = ata_sff_dev_classify(&ap->link.device[0],
+					  devmask & (1 << 0), &err);
+
+	return 0;
+}
+
+/*
+ * pata_s3c_set_devctl - Write device control register
+ */
+static void pata_s3c_set_devctl(struct ata_port *ap, u8 ctl)
+{
+	ata_outb(ap->host, ctl, ap->ioaddr.ctl_addr);
+}
+
+static struct scsi_host_template pata_s3c_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations pata_s3c_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+	.sff_check_status	= pata_s3c_check_status,
+	.sff_check_altstatus    = pata_s3c_check_altstatus,
+	.sff_tf_load		= pata_s3c_tf_load,
+	.sff_tf_read		= pata_s3c_tf_read,
+	.sff_data_xfer		= pata_s3c_data_xfer,
+	.sff_exec_command	= pata_s3c_exec_command,
+	.sff_dev_select         = pata_s3c_dev_select,
+	.sff_set_devctl         = pata_s3c_set_devctl,
+	.softreset		= pata_s3c_softreset,
+	.set_piomode		= pata_s3c_set_piomode,
+};
+
+static struct ata_port_operations pata_s5p_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+	.set_piomode		= pata_s3c_set_piomode,
+};
+
+static void pata_s3c_enable(void *s3c_ide_regbase, bool state)
+{
+	u32 temp = readl(s3c_ide_regbase + S3C_ATA_CTRL);
+	temp = state ? (temp | 1) : (temp & ~1);
+	writel(temp, s3c_ide_regbase + S3C_ATA_CTRL);
+}
+
+static irqreturn_t pata_s3c_irq(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct s3c_ide_info *info = host->private_data;
+	u32 reg;
+
+	reg = readl(info->ide_addr + S3C_ATA_IRQ);
+	writel(reg, info->ide_addr + S3C_ATA_IRQ);
+
+	return ata_sff_interrupt(irq, dev_instance);
+}
+
+static void pata_s3c_hwinit(struct s3c_ide_info *info,
+				struct s3c_ide_platdata *pdata)
+{
+	switch (info->cpu_type) {
+	case TYPE_S3C64XX:
+		/* Configure as big endian */
+		pata_s3c_cfg_mode(info->sfr_addr);
+		pata_s3c_set_endian(info->ide_addr, 1);
+		pata_s3c_enable(info->ide_addr, true);
+		msleep(100);
+
+		/* Remove IRQ Status */
+		writel(0x1f, info->ide_addr + S3C_ATA_IRQ);
+		writel(0x1b, info->ide_addr + S3C_ATA_IRQ_MSK);
+		break;
+
+	case TYPE_S5PC100:
+		pata_s3c_cfg_mode(info->sfr_addr);
+		/* FALLTHROUGH */
+
+	case TYPE_S5PV210:
+		/* Configure as little endian */
+		pata_s3c_set_endian(info->ide_addr, 0);
+		pata_s3c_enable(info->ide_addr, true);
+		msleep(100);
+
+		/* Remove IRQ Status */
+		writel(0x3f, info->ide_addr + S3C_ATA_IRQ);
+		writel(0x3f, info->ide_addr + S3C_ATA_IRQ_MSK);
+		break;
+
+	default:
+		BUG();
+	}
+}
+
+static int __init pata_s3c_probe(struct platform_device *pdev)
+{
+	struct s3c_ide_platdata *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct s3c_ide_info *info;
+	struct resource *res;
+	struct ata_port *ap;
+	struct ata_host *host;
+	enum s3c_cpu_type cpu_type;
+	int ret;
+
+	cpu_type = platform_get_device_id(pdev)->driver_data;
+
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev, "failed to allocate memory for device data\n");
+		return -ENOMEM;
+	}
+
+	info->irq = platform_get_irq(pdev, 0);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "failed to get mem resource\n");
+		return -EINVAL;
+	}
+
+	if (!devm_request_mem_region(dev, res->start,
+				resource_size(res), DRV_NAME)) {
+		dev_err(dev, "error requesting register region\n");
+		return -EBUSY;
+	}
+
+	info->ide_addr = devm_ioremap(dev, res->start, resource_size(res));
+	if (!info->ide_addr) {
+		dev_err(dev, "failed to map IO base address\n");
+		return -ENOMEM;
+	}
+
+	info->clk = clk_get(&pdev->dev, "cfcon");
+	if (IS_ERR(info->clk)) {
+		dev_err(dev, "failed to get access to cf controller clock\n");
+		ret = PTR_ERR(info->clk);
+		info->clk = NULL;
+		return ret;
+	}
+
+	clk_enable(info->clk);
+
+	/* init ata host */
+	host = ata_host_alloc(dev, 1);
+	if (!host) {
+		dev_err(dev, "failed to allocate ide host\n");
+		ret = -ENOMEM;
+		goto stop_clk;
+	}
+
+	ap = host->ports[0];
+	ap->flags |= ATA_FLAG_MMIO;
+	ap->pio_mask = ATA_PIO4;
+
+	if (cpu_type == TYPE_S3C64XX) {
+		ap->ops = &pata_s3c_port_ops;
+		info->sfr_addr = info->ide_addr + 0x1800;
+		info->ide_addr += 0x1900;
+		info->fifo_status_reg = 0x94;
+	} else if (cpu_type == TYPE_S5PC100) {
+		ap->ops = &pata_s5p_port_ops;
+		info->sfr_addr = info->ide_addr + 0x1800;
+		info->ide_addr += 0x1900;
+		info->fifo_status_reg = 0x84;
+	} else {
+		ap->ops = &pata_s5p_port_ops;
+		info->fifo_status_reg = 0x84;
+	}
+
+	info->cpu_type = cpu_type;
+
+	if (info->irq <= 0) {
+		ap->flags |= ATA_FLAG_PIO_POLLING;
+		info->irq = 0;
+		ata_port_desc(ap, "no IRQ, using PIO polling\n");
+	}
+
+	ap->ioaddr.cmd_addr =  info->ide_addr + S3C_ATA_CMD;
+	ap->ioaddr.data_addr = info->ide_addr + S3C_ATA_PIO_DTR;
+	ap->ioaddr.error_addr = info->ide_addr + S3C_ATA_PIO_FED;
+	ap->ioaddr.feature_addr = info->ide_addr + S3C_ATA_PIO_FED;
+	ap->ioaddr.nsect_addr = info->ide_addr + S3C_ATA_PIO_SCR;
+	ap->ioaddr.lbal_addr = info->ide_addr + S3C_ATA_PIO_LLR;
+	ap->ioaddr.lbam_addr = info->ide_addr + S3C_ATA_PIO_LMR;
+	ap->ioaddr.lbah_addr = info->ide_addr + S3C_ATA_PIO_LHR;
+	ap->ioaddr.device_addr = info->ide_addr + S3C_ATA_PIO_DVR;
+	ap->ioaddr.status_addr = info->ide_addr + S3C_ATA_PIO_CSD;
+	ap->ioaddr.command_addr = info->ide_addr + S3C_ATA_PIO_CSD;
+	ap->ioaddr.altstatus_addr = info->ide_addr + S3C_ATA_PIO_DAD;
+	ap->ioaddr.ctl_addr = info->ide_addr + S3C_ATA_PIO_DAD;
+
+	ata_port_desc(ap, "mmio cmd 0x%llx ",
+			(unsigned long long)res->start);
+
+	host->private_data = info;
+
+	if (pdata && pdata->setup_gpio)
+		pdata->setup_gpio();
+
+	/* Set endianness and enable the interface */
+	pata_s3c_hwinit(info, pdata);
+
+	platform_set_drvdata(pdev, host);
+
+	return ata_host_activate(host, info->irq,
+			info->irq ? pata_s3c_irq : NULL,
+			0, &pata_s3c_sht);
+
+stop_clk:
+	clk_disable(info->clk);
+	clk_put(info->clk);
+	return ret;
+}
+
+static int __exit pata_s3c_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = platform_get_drvdata(pdev);
+	struct s3c_ide_info *info = host->private_data;
+
+	ata_host_detach(host);
+
+	clk_disable(info->clk);
+	clk_put(info->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int pata_s3c_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ata_host *host = platform_get_drvdata(pdev);
+
+	return ata_host_suspend(host, PMSG_SUSPEND);
+}
+
+static int pata_s3c_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ata_host *host = platform_get_drvdata(pdev);
+	struct s3c_ide_platdata *pdata = pdev->dev.platform_data;
+	struct s3c_ide_info *info = host->private_data;
+
+	pata_s3c_hwinit(info, pdata);
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static const struct dev_pm_ops pata_s3c_pm_ops = {
+	.suspend	= pata_s3c_suspend,
+	.resume		= pata_s3c_resume,
+};
+#endif
+
+/* driver device registration */
+static struct platform_device_id pata_s3c_driver_ids[] = {
+	{
+		.name		= "s3c64xx-pata",
+		.driver_data	= TYPE_S3C64XX,
+	}, {
+		.name		= "s5pc100-pata",
+		.driver_data	= TYPE_S5PC100,
+	}, {
+		.name		= "s5pv210-pata",
+		.driver_data	= TYPE_S5PV210,
+	},
+	{ }
+};
+
+MODULE_DEVICE_TABLE(platform, pata_s3c_driver_ids);
+
+static struct platform_driver pata_s3c_driver = {
+	.remove		= __exit_p(pata_s3c_remove),
+	.id_table	= pata_s3c_driver_ids,
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &pata_s3c_pm_ops,
+#endif
+	},
+};
+
+static int __init pata_s3c_init(void)
+{
+	return platform_driver_probe(&pata_s3c_driver, pata_s3c_probe);
+}
+
+static void __exit pata_s3c_exit(void)
+{
+	platform_driver_unregister(&pata_s3c_driver);
+}
+
+module_init(pata_s3c_init);
+module_exit(pata_s3c_exit);
+
+MODULE_AUTHOR("Abhilash Kesavan, <a.kesavan@samsung.com>");
+MODULE_DESCRIPTION("low-level driver for Samsung PATA controller");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index d9db3f8..fe36966 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -168,8 +168,7 @@ static const unsigned long JCACTSELtbl[2][7] = {
 };
 
 static const struct pci_device_id scc_pci_tbl[] = {
-	{PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA), 0},
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
new file mode 100644
index 0000000..ea24c1e
--- /dev/null
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -0,0 +1,1756 @@
+/*
+ * drivers/ata/sata_dwc_460ex.c
+ *
+ * Synopsys DesignWare Cores (DWC) SATA host driver
+ *
+ * Author: Mark Miesfeld <mmiesfeld@amcc.com>
+ *
+ * Ported from 2.6.19.2 to 2.6.25/26 by Stefan Roese <sr@denx.de>
+ * Copyright 2008 DENX Software Engineering
+ *
+ * Based on versions provided by AMCC and Synopsys which are:
+ *          Copyright 2006 Applied Micro Circuits Corporation
+ *          COPYRIGHT (C) 2005  SYNOPSYS, INC.  ALL RIGHTS RESERVED
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifdef CONFIG_SATA_DWC_DEBUG
+#define DEBUG
+#endif
+
+#ifdef CONFIG_SATA_DWC_VDEBUG
+#define VERBOSE_DEBUG
+#define DEBUG_NCQ
+#endif
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/libata.h>
+#include <linux/slab.h>
+#include "libata.h"
+
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+
+#define DRV_NAME        "sata-dwc"
+#define DRV_VERSION     "1.0"
+
+/* SATA DMA driver Globals */
+#define DMA_NUM_CHANS		1
+#define DMA_NUM_CHAN_REGS	8
+
+/* SATA DMA Register definitions */
+#define AHB_DMA_BRST_DFLT	64	/* 16 data items burst length*/
+
+struct dmareg {
+	u32 low;		/* Low bits 0-31 */
+	u32 high;		/* High bits 32-63 */
+};
+
+/* DMA Per Channel registers */
+struct dma_chan_regs {
+	struct dmareg sar;	/* Source Address */
+	struct dmareg dar;	/* Destination address */
+	struct dmareg llp;	/* Linked List Pointer */
+	struct dmareg ctl;	/* Control */
+	struct dmareg sstat;	/* Source Status not implemented in core */
+	struct dmareg dstat;	/* Destination Status not implemented in core*/
+	struct dmareg sstatar;	/* Source Status Address not impl in core */
+	struct dmareg dstatar;	/* Destination Status Address not implemente */
+	struct dmareg cfg;	/* Config */
+	struct dmareg sgr;	/* Source Gather */
+	struct dmareg dsr;	/* Destination Scatter */
+};
+
+/* Generic Interrupt Registers */
+struct dma_interrupt_regs {
+	struct dmareg tfr;	/* Transfer Interrupt */
+	struct dmareg block;	/* Block Interrupt */
+	struct dmareg srctran;	/* Source Transfer Interrupt */
+	struct dmareg dsttran;	/* Dest Transfer Interrupt */
+	struct dmareg error;	/* Error */
+};
+
+struct ahb_dma_regs {
+	struct dma_chan_regs	chan_regs[DMA_NUM_CHAN_REGS];
+	struct dma_interrupt_regs interrupt_raw;	/* Raw Interrupt */
+	struct dma_interrupt_regs interrupt_status;	/* Interrupt Status */
+	struct dma_interrupt_regs interrupt_mask;	/* Interrupt Mask */
+	struct dma_interrupt_regs interrupt_clear;	/* Interrupt Clear */
+	struct dmareg		statusInt;	/* Interrupt combined*/
+	struct dmareg		rq_srcreg;	/* Src Trans Req */
+	struct dmareg		rq_dstreg;	/* Dst Trans Req */
+	struct dmareg		rq_sgl_srcreg;	/* Sngl Src Trans Req*/
+	struct dmareg		rq_sgl_dstreg;	/* Sngl Dst Trans Req*/
+	struct dmareg		rq_lst_srcreg;	/* Last Src Trans Req*/
+	struct dmareg		rq_lst_dstreg;	/* Last Dst Trans Req*/
+	struct dmareg		dma_cfg;		/* DMA Config */
+	struct dmareg		dma_chan_en;		/* DMA Channel Enable*/
+	struct dmareg		dma_id;			/* DMA ID */
+	struct dmareg		dma_test;		/* DMA Test */
+	struct dmareg		res1;			/* reserved */
+	struct dmareg		res2;			/* reserved */
+	/*
+	 * DMA Comp Params
+	 * Param 6 = dma_param[0], Param 5 = dma_param[1],
+	 * Param 4 = dma_param[2] ...
+	 */
+	struct dmareg		dma_params[6];
+};
+
+/* Data structure for linked list item */
+struct lli {
+	u32		sar;		/* Source Address */
+	u32		dar;		/* Destination address */
+	u32		llp;		/* Linked List Pointer */
+	struct dmareg	ctl;		/* Control */
+	struct dmareg	dstat;		/* Destination Status */
+};
+
+enum {
+	SATA_DWC_DMAC_LLI_SZ =	(sizeof(struct lli)),
+	SATA_DWC_DMAC_LLI_NUM =	256,
+	SATA_DWC_DMAC_LLI_TBL_SZ = (SATA_DWC_DMAC_LLI_SZ * \
+					SATA_DWC_DMAC_LLI_NUM),
+	SATA_DWC_DMAC_TWIDTH_BYTES = 4,
+	SATA_DWC_DMAC_CTRL_TSIZE_MAX = (0x00000800 * \
+						SATA_DWC_DMAC_TWIDTH_BYTES),
+};
+
+/* DMA Register Operation Bits */
+enum {
+	DMA_EN	=		0x00000001, /* Enable AHB DMA */
+	DMA_CTL_LLP_SRCEN =	0x10000000, /* Blk chain enable Src */
+	DMA_CTL_LLP_DSTEN =	0x08000000, /* Blk chain enable Dst */
+};
+
+#define	DMA_CTL_BLK_TS(size)	((size) & 0x000000FFF)	/* Blk Transfer size */
+#define DMA_CHANNEL(ch)		(0x00000001 << (ch))	/* Select channel */
+	/* Enable channel */
+#define	DMA_ENABLE_CHAN(ch)	((0x00000001 << (ch)) |			\
+				 ((0x000000001 << (ch)) << 8))
+	/* Disable channel */
+#define	DMA_DISABLE_CHAN(ch)	(0x00000000 | ((0x000000001 << (ch)) << 8))
+	/* Transfer Type & Flow Controller */
+#define	DMA_CTL_TTFC(type)	(((type) & 0x7) << 20)
+#define	DMA_CTL_SMS(num)	(((num) & 0x3) << 25) /* Src Master Select */
+#define	DMA_CTL_DMS(num)	(((num) & 0x3) << 23)/* Dst Master Select */
+	/* Src Burst Transaction Length */
+#define DMA_CTL_SRC_MSIZE(size) (((size) & 0x7) << 14)
+	/* Dst Burst Transaction Length */
+#define	DMA_CTL_DST_MSIZE(size) (((size) & 0x7) << 11)
+	/* Source Transfer Width */
+#define	DMA_CTL_SRC_TRWID(size) (((size) & 0x7) << 4)
+	/* Destination Transfer Width */
+#define	DMA_CTL_DST_TRWID(size) (((size) & 0x7) << 1)
+
+/* Assign HW handshaking interface (x) to destination / source peripheral */
+#define	DMA_CFG_HW_HS_DEST(int_num) (((int_num) & 0xF) << 11)
+#define	DMA_CFG_HW_HS_SRC(int_num) (((int_num) & 0xF) << 7)
+#define	DMA_LLP_LMS(addr, master) (((addr) & 0xfffffffc) | (master))
+
+/*
+ * This define is used to set block chaining disabled in the control low
+ * register.  It is already in little endian format so it can be &'d dirctly.
+ * It is essentially: cpu_to_le32(~(DMA_CTL_LLP_SRCEN | DMA_CTL_LLP_DSTEN))
+ */
+enum {
+	DMA_CTL_LLP_DISABLE_LE32 = 0xffffffe7,
+	DMA_CTL_TTFC_P2M_DMAC =	0x00000002, /* Per to mem, DMAC cntr */
+	DMA_CTL_TTFC_M2P_PER =	0x00000003, /* Mem to per, peripheral cntr */
+	DMA_CTL_SINC_INC =	0x00000000, /* Source Address Increment */
+	DMA_CTL_SINC_DEC =	0x00000200,
+	DMA_CTL_SINC_NOCHANGE =	0x00000400,
+	DMA_CTL_DINC_INC =	0x00000000, /* Destination Address Increment */
+	DMA_CTL_DINC_DEC =	0x00000080,
+	DMA_CTL_DINC_NOCHANGE =	0x00000100,
+	DMA_CTL_INT_EN =	0x00000001, /* Interrupt Enable */
+
+/* Channel Configuration Register high bits */
+	DMA_CFG_FCMOD_REQ =	0x00000001, /* Flow Control - request based */
+	DMA_CFG_PROTCTL	=	(0x00000003 << 2),/* Protection Control */
+
+/* Channel Configuration Register low bits */
+	DMA_CFG_RELD_DST =	0x80000000, /* Reload Dest / Src Addr */
+	DMA_CFG_RELD_SRC =	0x40000000,
+	DMA_CFG_HS_SELSRC =	0x00000800, /* Software handshake Src/ Dest */
+	DMA_CFG_HS_SELDST =	0x00000400,
+	DMA_CFG_FIFOEMPTY =     (0x00000001 << 9), /* FIFO Empty bit */
+
+/* Channel Linked List Pointer Register */
+	DMA_LLP_AHBMASTER1 =	0,	/* List Master Select */
+	DMA_LLP_AHBMASTER2 =	1,
+
+	SATA_DWC_MAX_PORTS = 1,
+
+	SATA_DWC_SCR_OFFSET = 0x24,
+	SATA_DWC_REG_OFFSET = 0x64,
+};
+
+/* DWC SATA Registers */
+struct sata_dwc_regs {
+	u32 fptagr;		/* 1st party DMA tag */
+	u32 fpbor;		/* 1st party DMA buffer offset */
+	u32 fptcr;		/* 1st party DMA Xfr count */
+	u32 dmacr;		/* DMA Control */
+	u32 dbtsr;		/* DMA Burst Transac size */
+	u32 intpr;		/* Interrupt Pending */
+	u32 intmr;		/* Interrupt Mask */
+	u32 errmr;		/* Error Mask */
+	u32 llcr;		/* Link Layer Control */
+	u32 phycr;		/* PHY Control */
+	u32 physr;		/* PHY Status */
+	u32 rxbistpd;		/* Recvd BIST pattern def register */
+	u32 rxbistpd1;		/* Recvd BIST data dword1 */
+	u32 rxbistpd2;		/* Recvd BIST pattern data dword2 */
+	u32 txbistpd;		/* Trans BIST pattern def register */
+	u32 txbistpd1;		/* Trans BIST data dword1 */
+	u32 txbistpd2;		/* Trans BIST data dword2 */
+	u32 bistcr;		/* BIST Control Register */
+	u32 bistfctr;		/* BIST FIS Count Register */
+	u32 bistsr;		/* BIST Status Register */
+	u32 bistdecr;		/* BIST Dword Error count register */
+	u32 res[15];		/* Reserved locations */
+	u32 testr;		/* Test Register */
+	u32 versionr;		/* Version Register */
+	u32 idr;		/* ID Register */
+	u32 unimpl[192];	/* Unimplemented */
+	u32 dmadr[256];	/* FIFO Locations in DMA Mode */
+};
+
+enum {
+	SCR_SCONTROL_DET_ENABLE	=	0x00000001,
+	SCR_SSTATUS_DET_PRESENT	=	0x00000001,
+	SCR_SERROR_DIAG_X	=	0x04000000,
+/* DWC SATA Register Operations */
+	SATA_DWC_TXFIFO_DEPTH	=	0x01FF,
+	SATA_DWC_RXFIFO_DEPTH	=	0x01FF,
+	SATA_DWC_DMACR_TMOD_TXCHEN =	0x00000004,
+	SATA_DWC_DMACR_TXCHEN	= (0x00000001 | SATA_DWC_DMACR_TMOD_TXCHEN),
+	SATA_DWC_DMACR_RXCHEN	= (0x00000002 | SATA_DWC_DMACR_TMOD_TXCHEN),
+	SATA_DWC_DMACR_TXRXCH_CLEAR =	SATA_DWC_DMACR_TMOD_TXCHEN,
+	SATA_DWC_INTPR_DMAT	=	0x00000001,
+	SATA_DWC_INTPR_NEWFP	=	0x00000002,
+	SATA_DWC_INTPR_PMABRT	=	0x00000004,
+	SATA_DWC_INTPR_ERR	=	0x00000008,
+	SATA_DWC_INTPR_NEWBIST	=	0x00000010,
+	SATA_DWC_INTPR_IPF	=	0x10000000,
+	SATA_DWC_INTMR_DMATM	=	0x00000001,
+	SATA_DWC_INTMR_NEWFPM	=	0x00000002,
+	SATA_DWC_INTMR_PMABRTM	=	0x00000004,
+	SATA_DWC_INTMR_ERRM	=	0x00000008,
+	SATA_DWC_INTMR_NEWBISTM	=	0x00000010,
+	SATA_DWC_LLCR_SCRAMEN	=	0x00000001,
+	SATA_DWC_LLCR_DESCRAMEN	=	0x00000002,
+	SATA_DWC_LLCR_RPDEN	=	0x00000004,
+/* This is all error bits, zero's are reserved fields. */
+	SATA_DWC_SERROR_ERR_BITS =	0x0FFF0F03
+};
+
+#define SATA_DWC_SCR0_SPD_GET(v)	(((v) >> 4) & 0x0000000F)
+#define SATA_DWC_DMACR_TX_CLEAR(v)	(((v) & ~SATA_DWC_DMACR_TXCHEN) |\
+						 SATA_DWC_DMACR_TMOD_TXCHEN)
+#define SATA_DWC_DMACR_RX_CLEAR(v)	(((v) & ~SATA_DWC_DMACR_RXCHEN) |\
+						 SATA_DWC_DMACR_TMOD_TXCHEN)
+#define SATA_DWC_DBTSR_MWR(size)	(((size)/4) & SATA_DWC_TXFIFO_DEPTH)
+#define SATA_DWC_DBTSR_MRD(size)	((((size)/4) & SATA_DWC_RXFIFO_DEPTH)\
+						 << 16)
+struct sata_dwc_device {
+	struct device		*dev;		/* generic device struct */
+	struct ata_probe_ent	*pe;		/* ptr to probe-ent */
+	struct ata_host		*host;
+	u8			*reg_base;
+	struct sata_dwc_regs	*sata_dwc_regs;	/* DW Synopsys SATA specific */
+	int			irq_dma;
+};
+
+#define SATA_DWC_QCMD_MAX	32
+
+struct sata_dwc_device_port {
+	struct sata_dwc_device	*hsdev;
+	int			cmd_issued[SATA_DWC_QCMD_MAX];
+	struct lli		*llit[SATA_DWC_QCMD_MAX];  /* DMA LLI table */
+	dma_addr_t		llit_dma[SATA_DWC_QCMD_MAX];
+	u32			dma_chan[SATA_DWC_QCMD_MAX];
+	int			dma_pending[SATA_DWC_QCMD_MAX];
+};
+
+/*
+ * Commonly used DWC SATA driver Macros
+ */
+#define HSDEV_FROM_HOST(host)  ((struct sata_dwc_device *)\
+					(host)->private_data)
+#define HSDEV_FROM_AP(ap)  ((struct sata_dwc_device *)\
+					(ap)->host->private_data)
+#define HSDEVP_FROM_AP(ap)   ((struct sata_dwc_device_port *)\
+					(ap)->private_data)
+#define HSDEV_FROM_QC(qc)	((struct sata_dwc_device *)\
+					(qc)->ap->host->private_data)
+#define HSDEV_FROM_HSDEVP(p)	((struct sata_dwc_device *)\
+						(hsdevp)->hsdev)
+
+enum {
+	SATA_DWC_CMD_ISSUED_NOT		= 0,
+	SATA_DWC_CMD_ISSUED_PEND	= 1,
+	SATA_DWC_CMD_ISSUED_EXEC	= 2,
+	SATA_DWC_CMD_ISSUED_NODATA	= 3,
+
+	SATA_DWC_DMA_PENDING_NONE	= 0,
+	SATA_DWC_DMA_PENDING_TX		= 1,
+	SATA_DWC_DMA_PENDING_RX		= 2,
+};
+
+struct sata_dwc_host_priv {
+	void	__iomem	 *scr_addr_sstatus;
+	u32	sata_dwc_sactive_issued ;
+	u32	sata_dwc_sactive_queued ;
+	u32	dma_interrupt_count;
+	struct	ahb_dma_regs	*sata_dma_regs;
+	struct	device	*dwc_dev;
+};
+struct sata_dwc_host_priv host_pvt;
+/*
+ * Prototypes
+ */
+static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag);
+static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
+				u32 check_status);
+static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32 check_status);
+static void sata_dwc_port_stop(struct ata_port *ap);
+static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag);
+static int dma_dwc_init(struct sata_dwc_device *hsdev, int irq);
+static void dma_dwc_exit(struct sata_dwc_device *hsdev);
+static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
+			      struct lli *lli, dma_addr_t dma_lli,
+			      void __iomem *addr, int dir);
+static void dma_dwc_xfer_start(int dma_ch);
+
+static void sata_dwc_tf_dump(struct ata_taskfile *tf)
+{
+	dev_vdbg(host_pvt.dwc_dev, "taskfile cmd: 0x%02x protocol: %s flags:"
+		"0x%lx device: %x\n", tf->command, ata_get_cmd_descript\
+		(tf->protocol), tf->flags, tf->device);
+	dev_vdbg(host_pvt.dwc_dev, "feature: 0x%02x nsect: 0x%x lbal: 0x%x "
+		"lbam: 0x%x lbah: 0x%x\n", tf->feature, tf->nsect, tf->lbal,
+		 tf->lbam, tf->lbah);
+	dev_vdbg(host_pvt.dwc_dev, "hob_feature: 0x%02x hob_nsect: 0x%x "
+		"hob_lbal: 0x%x hob_lbam: 0x%x hob_lbah: 0x%x\n",
+		tf->hob_feature, tf->hob_nsect, tf->hob_lbal, tf->hob_lbam,
+		tf->hob_lbah);
+}
+
+/*
+ * Function: get_burst_length_encode
+ * arguments: datalength: length in bytes of data
+ * returns value to be programmed in register corrresponding to data length
+ * This value is effectively the log(base 2) of the length
+ */
+static  int get_burst_length_encode(int datalength)
+{
+	int items = datalength >> 2;	/* div by 4 to get lword count */
+
+	if (items >= 64)
+		return 5;
+
+	if (items >= 32)
+		return 4;
+
+	if (items >= 16)
+		return 3;
+
+	if (items >= 8)
+		return 2;
+
+	if (items >= 4)
+		return 1;
+
+	return 0;
+}
+
+static  void clear_chan_interrupts(int c)
+{
+	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.tfr.low),
+		 DMA_CHANNEL(c));
+	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.block.low),
+		 DMA_CHANNEL(c));
+	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.srctran.low),
+		 DMA_CHANNEL(c));
+	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.dsttran.low),
+		 DMA_CHANNEL(c));
+	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.error.low),
+		 DMA_CHANNEL(c));
+}
+
+/*
+ * Function: dma_request_channel
+ * arguments: None
+ * returns channel number if available else -1
+ * This function assigns the next available DMA channel from the list to the
+ * requester
+ */
+static int dma_request_channel(void)
+{
+	int i;
+
+	for (i = 0; i < DMA_NUM_CHANS; i++) {
+		if (!(in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)) &\
+			DMA_CHANNEL(i)))
+			return i;
+	}
+	dev_err(host_pvt.dwc_dev, "%s NO channel chan_en: 0x%08x\n", __func__,
+		in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)));
+	return -1;
+}
+
+/*
+ * Function: dma_dwc_interrupt
+ * arguments: irq, dev_id, pt_regs
+ * returns channel number if available else -1
+ * Interrupt Handler for DW AHB SATA DMA
+ */
+static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
+{
+	int chan;
+	u32 tfr_reg, err_reg;
+	unsigned long flags;
+	struct sata_dwc_device *hsdev =
+		(struct sata_dwc_device *)hsdev_instance;
+	struct ata_host *host = (struct ata_host *)hsdev->host;
+	struct ata_port *ap;
+	struct sata_dwc_device_port *hsdevp;
+	u8 tag = 0;
+	unsigned int port = 0;
+
+	spin_lock_irqsave(&host->lock, flags);
+	ap = host->ports[port];
+	hsdevp = HSDEVP_FROM_AP(ap);
+	tag = ap->link.active_tag;
+
+	tfr_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.tfr\
+			.low));
+	err_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error\
+			.low));
+
+	dev_dbg(ap->dev, "eot=0x%08x err=0x%08x pending=%d active port=%d\n",
+		tfr_reg, err_reg, hsdevp->dma_pending[tag], port);
+
+	for (chan = 0; chan < DMA_NUM_CHANS; chan++) {
+		/* Check for end-of-transfer interrupt. */
+		if (tfr_reg & DMA_CHANNEL(chan)) {
+			/*
+			 * Each DMA command produces 2 interrupts.  Only
+			 * complete the command after both interrupts have been
+			 * seen. (See sata_dwc_isr())
+			 */
+			host_pvt.dma_interrupt_count++;
+			sata_dwc_clear_dmacr(hsdevp, tag);
+
+			if (hsdevp->dma_pending[tag] ==
+			    SATA_DWC_DMA_PENDING_NONE) {
+				dev_err(ap->dev, "DMA not pending eot=0x%08x "
+					"err=0x%08x tag=0x%02x pending=%d\n",
+					tfr_reg, err_reg, tag,
+					hsdevp->dma_pending[tag]);
+			}
+
+			if ((host_pvt.dma_interrupt_count % 2) == 0)
+				sata_dwc_dma_xfer_complete(ap, 1);
+
+			/* Clear the interrupt */
+			out_le32(&(host_pvt.sata_dma_regs->interrupt_clear\
+				.tfr.low),
+				 DMA_CHANNEL(chan));
+		}
+
+		/* Check for error interrupt. */
+		if (err_reg & DMA_CHANNEL(chan)) {
+			/* TODO Need error handler ! */
+			dev_err(ap->dev, "error interrupt err_reg=0x%08x\n",
+				err_reg);
+
+			/* Clear the interrupt. */
+			out_le32(&(host_pvt.sata_dma_regs->interrupt_clear\
+				.error.low),
+				 DMA_CHANNEL(chan));
+		}
+	}
+	spin_unlock_irqrestore(&host->lock, flags);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Function: dma_request_interrupts
+ * arguments: hsdev
+ * returns status
+ * This function registers ISR for a particular DMA channel interrupt
+ */
+static int dma_request_interrupts(struct sata_dwc_device *hsdev, int irq)
+{
+	int retval = 0;
+	int chan;
+
+	for (chan = 0; chan < DMA_NUM_CHANS; chan++) {
+		/* Unmask error interrupt */
+		out_le32(&(host_pvt.sata_dma_regs)->interrupt_mask.error.low,
+			 DMA_ENABLE_CHAN(chan));
+
+		/* Unmask end-of-transfer interrupt */
+		out_le32(&(host_pvt.sata_dma_regs)->interrupt_mask.tfr.low,
+			 DMA_ENABLE_CHAN(chan));
+	}
+
+	retval = request_irq(irq, dma_dwc_interrupt, 0, "SATA DMA", hsdev);
+	if (retval) {
+		dev_err(host_pvt.dwc_dev, "%s: could not get IRQ %d\n",
+		__func__, irq);
+		return -ENODEV;
+	}
+
+	/* Mark this interrupt as requested */
+	hsdev->irq_dma = irq;
+	return 0;
+}
+
+/*
+ * Function: map_sg_to_lli
+ * The Synopsis driver has a comment proposing that better performance
+ * is possible by only enabling interrupts on the last item in the linked list.
+ * However, it seems that could be a problem if an error happened on one of the
+ * first items.  The transfer would halt, but no error interrupt would occur.
+ * Currently this function sets interrupts enabled for each linked list item:
+ * DMA_CTL_INT_EN.
+ */
+static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
+			struct lli *lli, dma_addr_t dma_lli,
+			void __iomem *dmadr_addr, int dir)
+{
+	int i, idx = 0;
+	int fis_len = 0;
+	dma_addr_t next_llp;
+	int bl;
+
+	dev_dbg(host_pvt.dwc_dev, "%s: sg=%p nelem=%d lli=%p dma_lli=0x%08x"
+		" dmadr=0x%08x\n", __func__, sg, num_elems, lli, (u32)dma_lli,
+		(u32)dmadr_addr);
+
+	bl = get_burst_length_encode(AHB_DMA_BRST_DFLT);
+
+	for (i = 0; i < num_elems; i++, sg++) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		dev_dbg(host_pvt.dwc_dev, "%s: elem=%d sg_addr=0x%x sg_len"
+			"=%d\n", __func__, i, addr, sg_len);
+
+		while (sg_len) {
+			if (idx >= SATA_DWC_DMAC_LLI_NUM) {
+				/* The LLI table is not large enough. */
+				dev_err(host_pvt.dwc_dev, "LLI table overrun "
+				"(idx=%d)\n", idx);
+				break;
+			}
+			len = (sg_len > SATA_DWC_DMAC_CTRL_TSIZE_MAX) ?
+				SATA_DWC_DMAC_CTRL_TSIZE_MAX : sg_len;
+
+			offset = addr & 0xffff;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			/*
+			 * Make sure a LLI block is not created that will span
+			 * 8K max FIS boundary.  If the block spans such a FIS
+			 * boundary, there is a chance that a DMA burst will
+			 * cross that boundary -- this results in an error in
+			 * the host controller.
+			 */
+			if (fis_len + len > 8192) {
+				dev_dbg(host_pvt.dwc_dev, "SPLITTING: fis_len="
+					"%d(0x%x) len=%d(0x%x)\n", fis_len,
+					 fis_len, len, len);
+				len = 8192 - fis_len;
+				fis_len = 0;
+			} else {
+				fis_len += len;
+			}
+			if (fis_len == 8192)
+				fis_len = 0;
+
+			/*
+			 * Set DMA addresses and lower half of control register
+			 * based on direction.
+			 */
+			if (dir == DMA_FROM_DEVICE) {
+				lli[idx].dar = cpu_to_le32(addr);
+				lli[idx].sar = cpu_to_le32((u32)dmadr_addr);
+
+				lli[idx].ctl.low = cpu_to_le32(
+					DMA_CTL_TTFC(DMA_CTL_TTFC_P2M_DMAC) |
+					DMA_CTL_SMS(0) |
+					DMA_CTL_DMS(1) |
+					DMA_CTL_SRC_MSIZE(bl) |
+					DMA_CTL_DST_MSIZE(bl) |
+					DMA_CTL_SINC_NOCHANGE |
+					DMA_CTL_SRC_TRWID(2) |
+					DMA_CTL_DST_TRWID(2) |
+					DMA_CTL_INT_EN |
+					DMA_CTL_LLP_SRCEN |
+					DMA_CTL_LLP_DSTEN);
+			} else {	/* DMA_TO_DEVICE */
+				lli[idx].sar = cpu_to_le32(addr);
+				lli[idx].dar = cpu_to_le32((u32)dmadr_addr);
+
+				lli[idx].ctl.low = cpu_to_le32(
+					DMA_CTL_TTFC(DMA_CTL_TTFC_M2P_PER) |
+					DMA_CTL_SMS(1) |
+					DMA_CTL_DMS(0) |
+					DMA_CTL_SRC_MSIZE(bl) |
+					DMA_CTL_DST_MSIZE(bl) |
+					DMA_CTL_DINC_NOCHANGE |
+					DMA_CTL_SRC_TRWID(2) |
+					DMA_CTL_DST_TRWID(2) |
+					DMA_CTL_INT_EN |
+					DMA_CTL_LLP_SRCEN |
+					DMA_CTL_LLP_DSTEN);
+			}
+
+			dev_dbg(host_pvt.dwc_dev, "%s setting ctl.high len: "
+				"0x%08x val: 0x%08x\n", __func__,
+				len, DMA_CTL_BLK_TS(len / 4));
+
+			/* Program the LLI CTL high register */
+			lli[idx].ctl.high = cpu_to_le32(DMA_CTL_BLK_TS\
+						(len / 4));
+
+			/* Program the next pointer.  The next pointer must be
+			 * the physical address, not the virtual address.
+			 */
+			next_llp = (dma_lli + ((idx + 1) * sizeof(struct \
+							lli)));
+
+			/* The last 2 bits encode the list master select. */
+			next_llp = DMA_LLP_LMS(next_llp, DMA_LLP_AHBMASTER2);
+
+			lli[idx].llp = cpu_to_le32(next_llp);
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	/*
+	 * The last next ptr has to be zero and the last control low register
+	 * has to have LLP_SRC_EN and LLP_DST_EN (linked list pointer source
+	 * and destination enable) set back to 0 (disabled.) This is what tells
+	 * the core that this is the last item in the linked list.
+	 */
+	if (idx) {
+		lli[idx-1].llp = 0x00000000;
+		lli[idx-1].ctl.low &= DMA_CTL_LLP_DISABLE_LE32;
+
+		/* Flush cache to memory */
+		dma_cache_sync(NULL, lli, (sizeof(struct lli) * idx),
+			       DMA_BIDIRECTIONAL);
+	}
+
+	return idx;
+}
+
+/*
+ * Function: dma_dwc_xfer_start
+ * arguments: Channel number
+ * Return : None
+ * Enables the DMA channel
+ */
+static void dma_dwc_xfer_start(int dma_ch)
+{
+	/* Enable the DMA channel */
+	out_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low),
+		 in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)) |
+		 DMA_ENABLE_CHAN(dma_ch));
+}
+
+static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
+			      struct lli *lli, dma_addr_t dma_lli,
+			      void __iomem *addr, int dir)
+{
+	int dma_ch;
+	int num_lli;
+	/* Acquire DMA channel */
+	dma_ch = dma_request_channel();
+	if (dma_ch == -1) {
+		dev_err(host_pvt.dwc_dev, "%s: dma channel unavailable\n",
+			 __func__);
+		return -EAGAIN;
+	}
+
+	/* Convert SG list to linked list of items (LLIs) for AHB DMA */
+	num_lli = map_sg_to_lli(sg, num_elems, lli, dma_lli, addr, dir);
+
+	dev_dbg(host_pvt.dwc_dev, "%s sg: 0x%p, count: %d lli: %p dma_lli:"
+		" 0x%0xlx addr: %p lli count: %d\n", __func__, sg, num_elems,
+		 lli, (u32)dma_lli, addr, num_lli);
+
+	clear_chan_interrupts(dma_ch);
+
+	/* Program the CFG register. */
+	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.high),
+		 DMA_CFG_PROTCTL | DMA_CFG_FCMOD_REQ);
+	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.low), 0);
+
+	/* Program the address of the linked list */
+	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].llp.low),
+		 DMA_LLP_LMS(dma_lli, DMA_LLP_AHBMASTER2));
+
+	/* Program the CTL register with src enable / dst enable */
+	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].ctl.low),
+		 DMA_CTL_LLP_SRCEN | DMA_CTL_LLP_DSTEN);
+	return 0;
+}
+
+/*
+ * Function: dma_dwc_exit
+ * arguments: None
+ * returns status
+ * This function exits the SATA DMA driver
+ */
+static void dma_dwc_exit(struct sata_dwc_device *hsdev)
+{
+	dev_dbg(host_pvt.dwc_dev, "%s:\n", __func__);
+	if (host_pvt.sata_dma_regs)
+		iounmap(host_pvt.sata_dma_regs);
+
+	if (hsdev->irq_dma)
+		free_irq(hsdev->irq_dma, hsdev);
+}
+
+/*
+ * Function: dma_dwc_init
+ * arguments: hsdev
+ * returns status
+ * This function initializes the SATA DMA driver
+ */
+static int dma_dwc_init(struct sata_dwc_device *hsdev, int irq)
+{
+	int err;
+
+	err = dma_request_interrupts(hsdev, irq);
+	if (err) {
+		dev_err(host_pvt.dwc_dev, "%s: dma_request_interrupts returns"
+			" %d\n", __func__, err);
+		goto error_out;
+	}
+
+	/* Enabe DMA */
+	out_le32(&(host_pvt.sata_dma_regs->dma_cfg.low), DMA_EN);
+
+	dev_notice(host_pvt.dwc_dev, "DMA initialized\n");
+	dev_dbg(host_pvt.dwc_dev, "SATA DMA registers=0x%p\n", host_pvt.\
+		sata_dma_regs);
+
+	return 0;
+
+error_out:
+	dma_dwc_exit(hsdev);
+
+	return err;
+}
+
+static int sata_dwc_scr_read(struct ata_link *link, unsigned int scr, u32 *val)
+{
+	if (scr > SCR_NOTIFICATION) {
+		dev_err(link->ap->dev, "%s: Incorrect SCR offset 0x%02x\n",
+			__func__, scr);
+		return -EINVAL;
+	}
+
+	*val = in_le32((void *)link->ap->ioaddr.scr_addr + (scr * 4));
+	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=val=0x%08x\n",
+		__func__, link->ap->print_id, scr, *val);
+
+	return 0;
+}
+
+static int sata_dwc_scr_write(struct ata_link *link, unsigned int scr, u32 val)
+{
+	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=val=0x%08x\n",
+		__func__, link->ap->print_id, scr, val);
+	if (scr > SCR_NOTIFICATION) {
+		dev_err(link->ap->dev, "%s: Incorrect SCR offset 0x%02x\n",
+			 __func__, scr);
+		return -EINVAL;
+	}
+	out_le32((void *)link->ap->ioaddr.scr_addr + (scr * 4), val);
+
+	return 0;
+}
+
+static u32 core_scr_read(unsigned int scr)
+{
+	return in_le32((void __iomem *)(host_pvt.scr_addr_sstatus) +\
+			(scr * 4));
+}
+
+static void core_scr_write(unsigned int scr, u32 val)
+{
+	out_le32((void __iomem *)(host_pvt.scr_addr_sstatus) + (scr * 4),
+		val);
+}
+
+static void clear_serror(void)
+{
+	u32 val;
+	val = core_scr_read(SCR_ERROR);
+	core_scr_write(SCR_ERROR, val);
+
+}
+
+static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
+{
+	out_le32(&hsdev->sata_dwc_regs->intpr,
+		 in_le32(&hsdev->sata_dwc_regs->intpr));
+}
+
+static u32 qcmd_tag_to_mask(u8 tag)
+{
+	return 0x00000001 << (tag & 0x1f);
+}
+
+/* See ahci.c */
+static void sata_dwc_error_intr(struct ata_port *ap,
+				struct sata_dwc_device *hsdev, uint intpr)
+{
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	unsigned int err_mask = 0, action = 0;
+	struct ata_queued_cmd *qc;
+	u32 serror;
+	u8 status, tag;
+	u32 err_reg;
+
+	ata_ehi_clear_desc(ehi);
+
+	serror = core_scr_read(SCR_ERROR);
+	status = ap->ops->sff_check_status(ap);
+
+	err_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error.\
+			low));
+	tag = ap->link.active_tag;
+
+	dev_err(ap->dev, "%s SCR_ERROR=0x%08x intpr=0x%08x status=0x%08x "
+		"dma_intp=%d pending=%d issued=%d dma_err_status=0x%08x\n",
+		__func__, serror, intpr, status, host_pvt.dma_interrupt_count,
+		hsdevp->dma_pending[tag], hsdevp->cmd_issued[tag], err_reg);
+
+	/* Clear error register and interrupt bit */
+	clear_serror();
+	clear_interrupt_bit(hsdev, SATA_DWC_INTPR_ERR);
+
+	/* This is the only error happening now.  TODO check for exact error */
+
+	err_mask |= AC_ERR_HOST_BUS;
+	action |= ATA_EH_RESET;
+
+	/* Pass this on to EH */
+	ehi->serror |= serror;
+	ehi->action |= action;
+
+	qc = ata_qc_from_tag(ap, tag);
+	if (qc)
+		qc->err_mask |= err_mask;
+	else
+		ehi->err_mask |= err_mask;
+
+	ata_port_abort(ap);
+}
+
+/*
+ * Function : sata_dwc_isr
+ * arguments : irq, void *dev_instance, struct pt_regs *regs
+ * Return value : irqreturn_t - status of IRQ
+ * This Interrupt handler called via port ops registered function.
+ * .irq_handler = sata_dwc_isr
+ */
+static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
+{
+	struct ata_host *host = (struct ata_host *)dev_instance;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_HOST(host);
+	struct ata_port *ap;
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+	u8 status, tag;
+	int handled, num_processed, port = 0;
+	uint intpr, sactive, sactive2, tag_mask;
+	struct sata_dwc_device_port *hsdevp;
+	host_pvt.sata_dwc_sactive_issued = 0;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	/* Read the interrupt register */
+	intpr = in_le32(&hsdev->sata_dwc_regs->intpr);
+
+	ap = host->ports[port];
+	hsdevp = HSDEVP_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s intpr=0x%08x active_tag=%d\n", __func__, intpr,
+		ap->link.active_tag);
+
+	/* Check for error interrupt */
+	if (intpr & SATA_DWC_INTPR_ERR) {
+		sata_dwc_error_intr(ap, hsdev, intpr);
+		handled = 1;
+		goto DONE;
+	}
+
+	/* Check for DMA SETUP FIS (FP DMA) interrupt */
+	if (intpr & SATA_DWC_INTPR_NEWFP) {
+		clear_interrupt_bit(hsdev, SATA_DWC_INTPR_NEWFP);
+
+		tag = (u8)(in_le32(&hsdev->sata_dwc_regs->fptagr));
+		dev_dbg(ap->dev, "%s: NEWFP tag=%d\n", __func__, tag);
+		if (hsdevp->cmd_issued[tag] != SATA_DWC_CMD_ISSUED_PEND)
+			dev_warn(ap->dev, "CMD tag=%d not pending?\n", tag);
+
+		host_pvt.sata_dwc_sactive_issued |= qcmd_tag_to_mask(tag);
+
+		qc = ata_qc_from_tag(ap, tag);
+		/*
+		 * Start FP DMA for NCQ command.  At this point the tag is the
+		 * active tag.  It is the tag that matches the command about to
+		 * be completed.
+		 */
+		qc->ap->link.active_tag = tag;
+		sata_dwc_bmdma_start_by_tag(qc, tag);
+
+		handled = 1;
+		goto DONE;
+	}
+	sactive = core_scr_read(SCR_ACTIVE);
+	tag_mask = (host_pvt.sata_dwc_sactive_issued | sactive) ^ sactive;
+
+	/* If no sactive issued and tag_mask is zero then this is not NCQ */
+	if (host_pvt.sata_dwc_sactive_issued == 0 && tag_mask == 0) {
+		if (ap->link.active_tag == ATA_TAG_POISON)
+			tag = 0;
+		else
+			tag = ap->link.active_tag;
+		qc = ata_qc_from_tag(ap, tag);
+
+		/* DEV interrupt w/ no active qc? */
+		if (unlikely(!qc || (qc->tf.flags & ATA_TFLAG_POLLING))) {
+			dev_err(ap->dev, "%s interrupt with no active qc "
+				"qc=%p\n", __func__, qc);
+			ap->ops->sff_check_status(ap);
+			handled = 1;
+			goto DONE;
+		}
+		status = ap->ops->sff_check_status(ap);
+
+		qc->ap->link.active_tag = tag;
+		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
+
+		if (status & ATA_ERR) {
+			dev_dbg(ap->dev, "interrupt ATA_ERR (0x%x)\n", status);
+			sata_dwc_qc_complete(ap, qc, 1);
+			handled = 1;
+			goto DONE;
+		}
+
+		dev_dbg(ap->dev, "%s non-NCQ cmd interrupt, protocol: %s\n",
+			__func__, ata_get_cmd_descript(qc->tf.protocol));
+DRVSTILLBUSY:
+		if (ata_is_dma(qc->tf.protocol)) {
+			/*
+			 * Each DMA transaction produces 2 interrupts. The DMAC
+			 * transfer complete interrupt and the SATA controller
+			 * operation done interrupt. The command should be
+			 * completed only after both interrupts are seen.
+			 */
+			host_pvt.dma_interrupt_count++;
+			if (hsdevp->dma_pending[tag] == \
+					SATA_DWC_DMA_PENDING_NONE) {
+				dev_err(ap->dev, "%s: DMA not pending "
+					"intpr=0x%08x status=0x%08x pending"
+					"=%d\n", __func__, intpr, status,
+					hsdevp->dma_pending[tag]);
+			}
+
+			if ((host_pvt.dma_interrupt_count % 2) == 0)
+				sata_dwc_dma_xfer_complete(ap, 1);
+		} else if (ata_is_pio(qc->tf.protocol)) {
+			ata_sff_hsm_move(ap, qc, status, 0);
+			handled = 1;
+			goto DONE;
+		} else {
+			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
+				goto DRVSTILLBUSY;
+		}
+
+		handled = 1;
+		goto DONE;
+	}
+
+	/*
+	 * This is a NCQ command. At this point we need to figure out for which
+	 * tags we have gotten a completion interrupt.  One interrupt may serve
+	 * as completion for more than one operation when commands are queued
+	 * (NCQ).  We need to process each completed command.
+	 */
+
+	 /* process completed commands */
+	sactive = core_scr_read(SCR_ACTIVE);
+	tag_mask = (host_pvt.sata_dwc_sactive_issued | sactive) ^ sactive;
+
+	if (sactive != 0 || (host_pvt.sata_dwc_sactive_issued) > 1 || \
+							tag_mask > 1) {
+		dev_dbg(ap->dev, "%s NCQ:sactive=0x%08x  sactive_issued=0x%08x"
+			"tag_mask=0x%08x\n", __func__, sactive,
+			host_pvt.sata_dwc_sactive_issued, tag_mask);
+	}
+
+	if ((tag_mask | (host_pvt.sata_dwc_sactive_issued)) != \
+					(host_pvt.sata_dwc_sactive_issued)) {
+		dev_warn(ap->dev, "Bad tag mask?  sactive=0x%08x "
+			 "(host_pvt.sata_dwc_sactive_issued)=0x%08x  tag_mask"
+			 "=0x%08x\n", sactive, host_pvt.sata_dwc_sactive_issued,
+			  tag_mask);
+	}
+
+	/* read just to clear ... not bad if currently still busy */
+	status = ap->ops->sff_check_status(ap);
+	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
+
+	tag = 0;
+	num_processed = 0;
+	while (tag_mask) {
+		num_processed++;
+		while (!(tag_mask & 0x00000001)) {
+			tag++;
+			tag_mask <<= 1;
+		}
+
+		tag_mask &= (~0x00000001);
+		qc = ata_qc_from_tag(ap, tag);
+
+		/* To be picked up by completion functions */
+		qc->ap->link.active_tag = tag;
+		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
+
+		/* Let libata/scsi layers handle error */
+		if (status & ATA_ERR) {
+			dev_dbg(ap->dev, "%s ATA_ERR (0x%x)\n", __func__,
+				status);
+			sata_dwc_qc_complete(ap, qc, 1);
+			handled = 1;
+			goto DONE;
+		}
+
+		/* Process completed command */
+		dev_dbg(ap->dev, "%s NCQ command, protocol: %s\n", __func__,
+			ata_get_cmd_descript(qc->tf.protocol));
+		if (ata_is_dma(qc->tf.protocol)) {
+			host_pvt.dma_interrupt_count++;
+			if (hsdevp->dma_pending[tag] == \
+					SATA_DWC_DMA_PENDING_NONE)
+				dev_warn(ap->dev, "%s: DMA not pending?\n",
+					__func__);
+			if ((host_pvt.dma_interrupt_count % 2) == 0)
+				sata_dwc_dma_xfer_complete(ap, 1);
+		} else {
+			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
+				goto STILLBUSY;
+		}
+		continue;
+
+STILLBUSY:
+		ap->stats.idle_irq++;
+		dev_warn(ap->dev, "STILL BUSY IRQ ata%d: irq trap\n",
+			ap->print_id);
+	} /* while tag_mask */
+
+	/*
+	 * Check to see if any commands completed while we were processing our
+	 * initial set of completed commands (read status clears interrupts,
+	 * so we might miss a completed command interrupt if one came in while
+	 * we were processing --we read status as part of processing a completed
+	 * command).
+	 */
+	sactive2 = core_scr_read(SCR_ACTIVE);
+	if (sactive2 != sactive) {
+		dev_dbg(ap->dev, "More completed - sactive=0x%x sactive2"
+			"=0x%x\n", sactive, sactive2);
+	}
+	handled = 1;
+
+DONE:
+	spin_unlock_irqrestore(&host->lock, flags);
+	return IRQ_RETVAL(handled);
+}
+
+static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_HSDEVP(hsdevp);
+
+	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX) {
+		out_le32(&(hsdev->sata_dwc_regs->dmacr),
+			 SATA_DWC_DMACR_RX_CLEAR(
+				 in_le32(&(hsdev->sata_dwc_regs->dmacr))));
+	} else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX) {
+		out_le32(&(hsdev->sata_dwc_regs->dmacr),
+			 SATA_DWC_DMACR_TX_CLEAR(
+				 in_le32(&(hsdev->sata_dwc_regs->dmacr))));
+	} else {
+		/*
+		 * This should not happen, it indicates the driver is out of
+		 * sync.  If it does happen, clear dmacr anyway.
+		 */
+		dev_err(host_pvt.dwc_dev, "%s DMA protocol RX and"
+			"TX DMA not pending tag=0x%02x pending=%d"
+			" dmacr: 0x%08x\n", __func__, tag,
+			hsdevp->dma_pending[tag],
+			in_le32(&(hsdev->sata_dwc_regs->dmacr)));
+		out_le32(&(hsdev->sata_dwc_regs->dmacr),
+			SATA_DWC_DMACR_TXRXCH_CLEAR);
+	}
+}
+
+static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32 check_status)
+{
+	struct ata_queued_cmd *qc;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	u8 tag = 0;
+
+	tag = ap->link.active_tag;
+	qc = ata_qc_from_tag(ap, tag);
+	if (!qc) {
+		dev_err(ap->dev, "failed to get qc");
+		return;
+	}
+
+#ifdef DEBUG_NCQ
+	if (tag > 0) {
+		dev_info(ap->dev, "%s tag=%u cmd=0x%02x dma dir=%s proto=%s "
+			 "dmacr=0x%08x\n", __func__, qc->tag, qc->tf.command,
+			 ata_get_cmd_descript(qc->dma_dir),
+			 ata_get_cmd_descript(qc->tf.protocol),
+			 in_le32(&(hsdev->sata_dwc_regs->dmacr)));
+	}
+#endif
+
+	if (ata_is_dma(qc->tf.protocol)) {
+		if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_NONE) {
+			dev_err(ap->dev, "%s DMA protocol RX and TX DMA not "
+				"pending dmacr: 0x%08x\n", __func__,
+				in_le32(&(hsdev->sata_dwc_regs->dmacr)));
+		}
+
+		hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;
+		sata_dwc_qc_complete(ap, qc, check_status);
+		ap->link.active_tag = ATA_TAG_POISON;
+	} else {
+		sata_dwc_qc_complete(ap, qc, check_status);
+	}
+}
+
+static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
+				u32 check_status)
+{
+	u8 status = 0;
+	u32 mask = 0x0;
+	u8 tag = qc->tag;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	host_pvt.sata_dwc_sactive_queued = 0;
+	dev_dbg(ap->dev, "%s checkstatus? %x\n", __func__, check_status);
+
+	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX)
+		dev_err(ap->dev, "TX DMA PENDING\n");
+	else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX)
+		dev_err(ap->dev, "RX DMA PENDING\n");
+	dev_dbg(ap->dev, "QC complete cmd=0x%02x status=0x%02x ata%u:"
+		" protocol=%d\n", qc->tf.command, status, ap->print_id,
+		 qc->tf.protocol);
+
+	/* clear active bit */
+	mask = (~(qcmd_tag_to_mask(tag)));
+	host_pvt.sata_dwc_sactive_queued = (host_pvt.sata_dwc_sactive_queued) \
+						& mask;
+	host_pvt.sata_dwc_sactive_issued = (host_pvt.sata_dwc_sactive_issued) \
+						& mask;
+	ata_qc_complete(qc);
+	return 0;
+}
+
+static void sata_dwc_enable_interrupts(struct sata_dwc_device *hsdev)
+{
+	/* Enable selective interrupts by setting the interrupt maskregister*/
+	out_le32(&hsdev->sata_dwc_regs->intmr,
+		 SATA_DWC_INTMR_ERRM |
+		 SATA_DWC_INTMR_NEWFPM |
+		 SATA_DWC_INTMR_PMABRTM |
+		 SATA_DWC_INTMR_DMATM);
+	/*
+	 * Unmask the error bits that should trigger an error interrupt by
+	 * setting the error mask register.
+	 */
+	out_le32(&hsdev->sata_dwc_regs->errmr, SATA_DWC_SERROR_ERR_BITS);
+
+	dev_dbg(host_pvt.dwc_dev, "%s: INTMR = 0x%08x, ERRMR = 0x%08x\n",
+		 __func__, in_le32(&hsdev->sata_dwc_regs->intmr),
+		in_le32(&hsdev->sata_dwc_regs->errmr));
+}
+
+static void sata_dwc_setup_port(struct ata_ioports *port, unsigned long base)
+{
+	port->cmd_addr = (void *)base + 0x00;
+	port->data_addr = (void *)base + 0x00;
+
+	port->error_addr = (void *)base + 0x04;
+	port->feature_addr = (void *)base + 0x04;
+
+	port->nsect_addr = (void *)base + 0x08;
+
+	port->lbal_addr = (void *)base + 0x0c;
+	port->lbam_addr = (void *)base + 0x10;
+	port->lbah_addr = (void *)base + 0x14;
+
+	port->device_addr = (void *)base + 0x18;
+	port->command_addr = (void *)base + 0x1c;
+	port->status_addr = (void *)base + 0x1c;
+
+	port->altstatus_addr = (void *)base + 0x20;
+	port->ctl_addr = (void *)base + 0x20;
+}
+
+/*
+ * Function : sata_dwc_port_start
+ * arguments : struct ata_ioports *port
+ * Return value : returns 0 if success, error code otherwise
+ * This function allocates the scatter gather LLI table for AHB DMA
+ */
+static int sata_dwc_port_start(struct ata_port *ap)
+{
+	int err = 0;
+	struct sata_dwc_device *hsdev;
+	struct sata_dwc_device_port *hsdevp = NULL;
+	struct device *pdev;
+	int i;
+
+	hsdev = HSDEV_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s: port_no=%d\n", __func__, ap->port_no);
+
+	hsdev->host = ap->host;
+	pdev = ap->host->dev;
+	if (!pdev) {
+		dev_err(ap->dev, "%s: no ap->host->dev\n", __func__);
+		err = -ENODEV;
+		goto CLEANUP;
+	}
+
+	/* Allocate Port Struct */
+	hsdevp = kzalloc(sizeof(*hsdevp), GFP_KERNEL);
+	if (!hsdevp) {
+		dev_err(ap->dev, "%s: kmalloc failed for hsdevp\n", __func__);
+		err = -ENOMEM;
+		goto CLEANUP;
+	}
+	hsdevp->hsdev = hsdev;
+
+	for (i = 0; i < SATA_DWC_QCMD_MAX; i++)
+		hsdevp->cmd_issued[i] = SATA_DWC_CMD_ISSUED_NOT;
+
+	ap->bmdma_prd = 0;	/* set these so libata doesn't use them */
+	ap->bmdma_prd_dma = 0;
+
+	/*
+	 * DMA - Assign scatter gather LLI table. We can't use the libata
+	 * version since it's PRD is IDE PCI specific.
+	 */
+	for (i = 0; i < SATA_DWC_QCMD_MAX; i++) {
+		hsdevp->llit[i] = dma_alloc_coherent(pdev,
+						     SATA_DWC_DMAC_LLI_TBL_SZ,
+						     &(hsdevp->llit_dma[i]),
+						     GFP_ATOMIC);
+		if (!hsdevp->llit[i]) {
+			dev_err(ap->dev, "%s: dma_alloc_coherent failed\n",
+				 __func__);
+			err = -ENOMEM;
+			goto CLEANUP;
+		}
+	}
+
+	if (ap->port_no == 0)  {
+		dev_dbg(ap->dev, "%s: clearing TXCHEN, RXCHEN in DMAC\n",
+			__func__);
+		out_le32(&hsdev->sata_dwc_regs->dmacr,
+			 SATA_DWC_DMACR_TXRXCH_CLEAR);
+
+		dev_dbg(ap->dev, "%s: setting burst size in DBTSR\n",
+			 __func__);
+		out_le32(&hsdev->sata_dwc_regs->dbtsr,
+			 (SATA_DWC_DBTSR_MWR(AHB_DMA_BRST_DFLT) |
+			  SATA_DWC_DBTSR_MRD(AHB_DMA_BRST_DFLT)));
+	}
+
+	/* Clear any error bits before libata starts issuing commands */
+	clear_serror();
+	ap->private_data = hsdevp;
+
+CLEANUP:
+	if (err) {
+		sata_dwc_port_stop(ap);
+		dev_dbg(ap->dev, "%s: fail\n", __func__);
+	} else {
+		dev_dbg(ap->dev, "%s: done\n", __func__);
+	}
+
+	return err;
+}
+
+static void sata_dwc_port_stop(struct ata_port *ap)
+{
+	int i;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s: ap->id = %d\n", __func__, ap->print_id);
+
+	if (hsdevp && hsdev) {
+		/* deallocate LLI table */
+		for (i = 0; i < SATA_DWC_QCMD_MAX; i++) {
+			dma_free_coherent(ap->host->dev,
+					  SATA_DWC_DMAC_LLI_TBL_SZ,
+					 hsdevp->llit[i], hsdevp->llit_dma[i]);
+		}
+
+		kfree(hsdevp);
+	}
+	ap->private_data = NULL;
+}
+
+/*
+ * Function : sata_dwc_exec_command_by_tag
+ * arguments : ata_port *ap, ata_taskfile *tf, u8 tag, u32 cmd_issued
+ * Return value : None
+ * This function keeps track of individual command tag ids and calls
+ * ata_exec_command in libata
+ */
+static void sata_dwc_exec_command_by_tag(struct ata_port *ap,
+					 struct ata_taskfile *tf,
+					 u8 tag, u32 cmd_issued)
+{
+	unsigned long flags;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s cmd(0x%02x): %s tag=%d\n", __func__, tf->command,
+		ata_get_cmd_descript(tf), tag);
+
+	spin_lock_irqsave(&ap->host->lock, flags);
+	hsdevp->cmd_issued[tag] = cmd_issued;
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+	/*
+	 * Clear SError before executing a new command.
+	 * sata_dwc_scr_write and read can not be used here. Clearing the PM
+	 * managed SError register for the disk needs to be done before the
+	 * task file is loaded.
+	 */
+	clear_serror();
+	ata_sff_exec_command(ap, tf);
+}
+
+static void sata_dwc_bmdma_setup_by_tag(struct ata_queued_cmd *qc, u8 tag)
+{
+	sata_dwc_exec_command_by_tag(qc->ap, &qc->tf, tag,
+				     SATA_DWC_CMD_ISSUED_PEND);
+}
+
+static void sata_dwc_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	u8 tag = qc->tag;
+
+	if (ata_is_ncq(qc->tf.protocol)) {
+		dev_dbg(qc->ap->dev, "%s: ap->link.sactive=0x%08x tag=%d\n",
+			__func__, qc->ap->link.sactive, tag);
+	} else {
+		tag = 0;
+	}
+	sata_dwc_bmdma_setup_by_tag(qc, tag);
+}
+
+static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag)
+{
+	int start_dma;
+	u32 reg, dma_chan;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_QC(qc);
+	struct ata_port *ap = qc->ap;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	int dir = qc->dma_dir;
+	dma_chan = hsdevp->dma_chan[tag];
+
+	if (hsdevp->cmd_issued[tag] != SATA_DWC_CMD_ISSUED_NOT) {
+		start_dma = 1;
+		if (dir == DMA_TO_DEVICE)
+			hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_TX;
+		else
+			hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_RX;
+	} else {
+		dev_err(ap->dev, "%s: Command not pending cmd_issued=%d "
+			"(tag=%d) DMA NOT started\n", __func__,
+			hsdevp->cmd_issued[tag], tag);
+		start_dma = 0;
+	}
+
+	dev_dbg(ap->dev, "%s qc=%p tag: %x cmd: 0x%02x dma_dir: %s "
+		"start_dma? %x\n", __func__, qc, tag, qc->tf.command,
+		ata_get_cmd_descript(qc->dma_dir), start_dma);
+	sata_dwc_tf_dump(&(qc->tf));
+
+	if (start_dma) {
+		reg = core_scr_read(SCR_ERROR);
+		if (reg & SATA_DWC_SERROR_ERR_BITS) {
+			dev_err(ap->dev, "%s: ****** SError=0x%08x ******\n",
+				__func__, reg);
+		}
+
+		if (dir == DMA_TO_DEVICE)
+			out_le32(&hsdev->sata_dwc_regs->dmacr,
+				SATA_DWC_DMACR_TXCHEN);
+		else
+			out_le32(&hsdev->sata_dwc_regs->dmacr,
+				SATA_DWC_DMACR_RXCHEN);
+
+		/* Enable AHB DMA transfer on the specified channel */
+		dma_dwc_xfer_start(dma_chan);
+	}
+}
+
+static void sata_dwc_bmdma_start(struct ata_queued_cmd *qc)
+{
+	u8 tag = qc->tag;
+
+	if (ata_is_ncq(qc->tf.protocol)) {
+		dev_dbg(qc->ap->dev, "%s: ap->link.sactive=0x%08x tag=%d\n",
+			__func__, qc->ap->link.sactive, tag);
+	} else {
+		tag = 0;
+	}
+	dev_dbg(qc->ap->dev, "%s\n", __func__);
+	sata_dwc_bmdma_start_by_tag(qc, tag);
+}
+
+/*
+ * Function : sata_dwc_qc_prep_by_tag
+ * arguments : ata_queued_cmd *qc, u8 tag
+ * Return value : None
+ * qc_prep for a particular queued command based on tag
+ */
+static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
+{
+	struct scatterlist *sg = qc->sg;
+	struct ata_port *ap = qc->ap;
+	u32 dma_chan;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	int err;
+
+	dev_dbg(ap->dev, "%s: port=%d dma dir=%s n_elem=%d\n",
+		__func__, ap->port_no, ata_get_cmd_descript(qc->dma_dir),
+		 qc->n_elem);
+
+	dma_chan = dma_dwc_xfer_setup(sg, qc->n_elem, hsdevp->llit[tag],
+				      hsdevp->llit_dma[tag],
+				      (void *__iomem)(&hsdev->sata_dwc_regs->\
+				      dmadr), qc->dma_dir);
+	if (dma_chan < 0) {
+		dev_err(ap->dev, "%s: dma_dwc_xfer_setup returns err %d\n",
+			__func__, err);
+		return;
+	}
+	hsdevp->dma_chan[tag] = dma_chan;
+}
+
+static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
+{
+	u32 sactive;
+	u8 tag = qc->tag;
+	struct ata_port *ap = qc->ap;
+
+#ifdef DEBUG_NCQ
+	if (qc->tag > 0 || ap->link.sactive > 1)
+		dev_info(ap->dev, "%s ap id=%d cmd(0x%02x)=%s qc tag=%d "
+			 "prot=%s ap active_tag=0x%08x ap sactive=0x%08x\n",
+			 __func__, ap->print_id, qc->tf.command,
+			 ata_get_cmd_descript(&qc->tf),
+			 qc->tag, ata_get_cmd_descript(qc->tf.protocol),
+			 ap->link.active_tag, ap->link.sactive);
+#endif
+
+	if (!ata_is_ncq(qc->tf.protocol))
+		tag = 0;
+	sata_dwc_qc_prep_by_tag(qc, tag);
+
+	if (ata_is_ncq(qc->tf.protocol)) {
+		sactive = core_scr_read(SCR_ACTIVE);
+		sactive |= (0x00000001 << tag);
+		core_scr_write(SCR_ACTIVE, sactive);
+
+		dev_dbg(qc->ap->dev, "%s: tag=%d ap->link.sactive = 0x%08x "
+			"sactive=0x%08x\n", __func__, tag, qc->ap->link.sactive,
+			sactive);
+
+		ap->ops->sff_tf_load(ap, &qc->tf);
+		sata_dwc_exec_command_by_tag(ap, &qc->tf, qc->tag,
+					     SATA_DWC_CMD_ISSUED_PEND);
+	} else {
+		ata_sff_qc_issue(qc);
+	}
+	return 0;
+}
+
+/*
+ * Function : sata_dwc_qc_prep
+ * arguments : ata_queued_cmd *qc
+ * Return value : None
+ * qc_prep for a particular queued command
+ */
+
+static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
+{
+	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))
+		return;
+
+#ifdef DEBUG_NCQ
+	if (qc->tag > 0)
+		dev_info(qc->ap->dev, "%s: qc->tag=%d ap->active_tag=0x%08x\n",
+			 __func__, tag, qc->ap->link.active_tag);
+
+	return ;
+#endif
+}
+
+static void sata_dwc_error_handler(struct ata_port *ap)
+{
+	ap->link.flags |= ATA_LFLAG_NO_HRST;
+	ata_sff_error_handler(ap);
+}
+
+/*
+ * scsi mid-layer and libata interface structures
+ */
+static struct scsi_host_template sata_dwc_sht = {
+	ATA_NCQ_SHT(DRV_NAME),
+	/*
+	 * test-only: Currently this driver doesn't handle NCQ
+	 * correctly. We enable NCQ but set the queue depth to a
+	 * max of 1. This will get fixed in in a future release.
+	 */
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.can_queue		= ATA_DEF_QUEUE,	/* ATA_MAX_QUEUE */
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+};
+
+static struct ata_port_operations sata_dwc_ops = {
+	.inherits		= &ata_sff_port_ops,
+
+	.error_handler		= sata_dwc_error_handler,
+
+	.qc_prep		= sata_dwc_qc_prep,
+	.qc_issue		= sata_dwc_qc_issue,
+
+	.scr_read		= sata_dwc_scr_read,
+	.scr_write		= sata_dwc_scr_write,
+
+	.port_start		= sata_dwc_port_start,
+	.port_stop		= sata_dwc_port_stop,
+
+	.bmdma_setup		= sata_dwc_bmdma_setup,
+	.bmdma_start		= sata_dwc_bmdma_start,
+};
+
+static const struct ata_port_info sata_dwc_port_info[] = {
+	{
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
+		.pio_mask	= 0x1f,	/* pio 0-4 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &sata_dwc_ops,
+	},
+};
+
+static int sata_dwc_probe(struct of_device *ofdev,
+			const struct of_device_id *match)
+{
+	struct sata_dwc_device *hsdev;
+	u32 idr, versionr;
+	char *ver = (char *)&versionr;
+	u8 *base = NULL;
+	int err = 0;
+	int irq, rc;
+	struct ata_host *host;
+	struct ata_port_info pi = sata_dwc_port_info[0];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+
+	/* Allocate DWC SATA device */
+	hsdev = kmalloc(sizeof(*hsdev), GFP_KERNEL);
+	if (hsdev == NULL) {
+		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
+		err = -ENOMEM;
+		goto error_out;
+	}
+	memset(hsdev, 0, sizeof(*hsdev));
+
+	/* Ioremap SATA registers */
+	base = of_iomap(ofdev->dev.of_node, 0);
+	if (!base) {
+		dev_err(&ofdev->dev, "ioremap failed for SATA register"
+			" address\n");
+		err = -ENODEV;
+		goto error_out;
+	}
+	hsdev->reg_base = base;
+	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
+
+	/* Synopsys DWC SATA specific Registers */
+	hsdev->sata_dwc_regs = (void *__iomem)(base + SATA_DWC_REG_OFFSET);
+
+	/* Allocate and fill host */
+	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_DWC_MAX_PORTS);
+	if (!host) {
+		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
+		err = -ENOMEM;
+		goto error_out;
+	}
+
+	host->private_data = hsdev;
+
+	/* Setup port */
+	host->ports[0]->ioaddr.cmd_addr = base;
+	host->ports[0]->ioaddr.scr_addr = base + SATA_DWC_SCR_OFFSET;
+	host_pvt.scr_addr_sstatus = base + SATA_DWC_SCR_OFFSET;
+	sata_dwc_setup_port(&host->ports[0]->ioaddr, (unsigned long)base);
+
+	/* Read the ID and Version Registers */
+	idr = in_le32(&hsdev->sata_dwc_regs->idr);
+	versionr = in_le32(&hsdev->sata_dwc_regs->versionr);
+	dev_notice(&ofdev->dev, "id %d, controller version %c.%c%c\n",
+		   idr, ver[0], ver[1], ver[2]);
+
+	/* Get SATA DMA interrupt number */
+	irq = irq_of_parse_and_map(ofdev->dev.of_node, 1);
+	if (irq == NO_IRQ) {
+		dev_err(&ofdev->dev, "no SATA DMA irq\n");
+		err = -ENODEV;
+		goto error_out;
+	}
+
+	/* Get physical SATA DMA register base address */
+	host_pvt.sata_dma_regs = of_iomap(ofdev->dev.of_node, 1);
+	if (!(host_pvt.sata_dma_regs)) {
+		dev_err(&ofdev->dev, "ioremap failed for AHBDMA register"
+			" address\n");
+		err = -ENODEV;
+		goto error_out;
+	}
+
+	/* Save dev for later use in dev_xxx() routines */
+	host_pvt.dwc_dev = &ofdev->dev;
+
+	/* Initialize AHB DMAC */
+	dma_dwc_init(hsdev, irq);
+
+	/* Enable SATA Interrupts */
+	sata_dwc_enable_interrupts(hsdev);
+
+	/* Get SATA interrupt number */
+	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	if (irq == NO_IRQ) {
+		dev_err(&ofdev->dev, "no SATA DMA irq\n");
+		err = -ENODEV;
+		goto error_out;
+	}
+
+	/*
+	 * Now, register with libATA core, this will also initiate the
+	 * device discovery process, invoking our port_start() handler &
+	 * error_handler() to execute a dummy Softreset EH session
+	 */
+	rc = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
+
+	if (rc != 0)
+		dev_err(&ofdev->dev, "failed to activate host");
+
+	dev_set_drvdata(&ofdev->dev, host);
+	return 0;
+
+error_out:
+	/* Free SATA DMA resources */
+	dma_dwc_exit(hsdev);
+
+	if (base)
+		iounmap(base);
+	return err;
+}
+
+static int sata_dwc_remove(struct of_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct sata_dwc_device *hsdev = host->private_data;
+
+	ata_host_detach(host);
+	dev_set_drvdata(dev, NULL);
+
+	/* Free SATA DMA resources */
+	dma_dwc_exit(hsdev);
+
+	iounmap(hsdev->reg_base);
+	kfree(hsdev);
+	kfree(host);
+	dev_dbg(&ofdev->dev, "done\n");
+	return 0;
+}
+
+static const struct of_device_id sata_dwc_match[] = {
+	{ .compatible = "amcc,sata-460ex", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sata_dwc_match);
+
+static struct of_platform_driver sata_dwc_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = sata_dwc_match,
+	},
+	.probe = sata_dwc_probe,
+	.remove = sata_dwc_remove,
+};
+
+static int __init sata_dwc_init(void)
+{
+	return	of_register_platform_driver(&sata_dwc_driver);
+}
+
+static void __exit sata_dwc_exit(void)
+{
+	of_unregister_platform_driver(&sata_dwc_driver);
+}
+
+module_init(sata_dwc_init);
+module_exit(sata_dwc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mark Miesfeld <mmiesfeld@amcc.com>");
+MODULE_DESCRIPTION("DesignWare Cores SATA controller low lever driver");
+MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 61c89b5..18c986d 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1096,7 +1096,7 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 {
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
-	u32 hstatus, qc_active = 0;
+	u32 hstatus, done_mask = 0;
 	struct ata_queued_cmd *qc;
 	u32 SError;
 
@@ -1116,28 +1116,28 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 	}
 
 	/* Read command completed register */
-	qc_active = ioread32(hcr_base + CC);
+	done_mask = ioread32(hcr_base + CC);
 
 	VPRINTK("Status of all queues :\n");
-	VPRINTK("qc_active/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
-		qc_active,
+	VPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
+		done_mask,
 		ioread32(hcr_base + CA),
 		ioread32(hcr_base + CE),
 		ioread32(hcr_base + CQ),
 		ap->qc_active);
 
-	if (qc_active & ap->qc_active) {
+	if (done_mask & ap->qc_active) {
 		int i;
 		/* clear CC bit, this will also complete the interrupt */
-		iowrite32(qc_active, hcr_base + CC);
+		iowrite32(done_mask, hcr_base + CC);
 
 		DPRINTK("Status of all queues :\n");
-		DPRINTK("qc_active/CC = 0x%x, CA = 0x%x, CE=0x%x\n",
-			qc_active, ioread32(hcr_base + CA),
+		DPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x\n",
+			done_mask, ioread32(hcr_base + CA),
 			ioread32(hcr_base + CE));
 
 		for (i = 0; i < SATA_FSL_QUEUE_DEPTH; i++) {
-			if (qc_active & (1 << i)) {
+			if (done_mask & (1 << i)) {
 				qc = ata_qc_from_tag(ap, i);
 				if (qc) {
 					ata_qc_complete(qc);
@@ -1164,7 +1164,7 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 		/* Spurious Interrupt!! */
 		DPRINTK("spurious interrupt!!, CC = 0x%x\n",
 			ioread32(hcr_base + CC));
-		iowrite32(qc_active, hcr_base + CC);
+		iowrite32(done_mask, hcr_base + CC);
 		return;
 	}
 }
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index a476cd9..9463c71 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2716,34 +2716,35 @@ static void mv_err_intr(struct ata_port *ap)
 static void mv_process_crpb_response(struct ata_port *ap,
 		struct mv_crpb *response, unsigned int tag, int ncq_enabled)
 {
+	u8 ata_status;
+	u16 edma_status = le16_to_cpu(response->flags);
 	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);
 
-	if (qc) {
-		u8 ata_status;
-		u16 edma_status = le16_to_cpu(response->flags);
-		/*
-		 * edma_status from a response queue entry:
-		 *   LSB is from EDMA_ERR_IRQ_CAUSE (non-NCQ only).
-		 *   MSB is saved ATA status from command completion.
-		 */
-		if (!ncq_enabled) {
-			u8 err_cause = edma_status & 0xff & ~EDMA_ERR_DEV;
-			if (err_cause) {
-				/*
-				 * Error will be seen/handled by mv_err_intr().
-				 * So do nothing at all here.
-				 */
-				return;
-			}
-		}
-		ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
-		if (!ac_err_mask(ata_status))
-			ata_qc_complete(qc);
-		/* else: leave it for mv_err_intr() */
-	} else {
+	if (unlikely(!qc)) {
 		ata_port_printk(ap, KERN_ERR, "%s: no qc for tag=%d\n",
 				__func__, tag);
+		return;
+	}
+
+	/*
+	 * edma_status from a response queue entry:
+	 *   LSB is from EDMA_ERR_IRQ_CAUSE (non-NCQ only).
+	 *   MSB is saved ATA status from command completion.
+	 */
+	if (!ncq_enabled) {
+		u8 err_cause = edma_status & 0xff & ~EDMA_ERR_DEV;
+		if (err_cause) {
+			/*
+			 * Error will be seen/handled by
+			 * mv_err_intr().  So do nothing at all here.
+			 */
+			return;
+		}
 	}
+	ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
+	if (!ac_err_mask(ata_status))
+		ata_qc_complete(qc);
+	/* else: leave it for mv_err_intr() */
 }
 
 static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp)
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 2116113..cb89ef8 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1018,7 +1018,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			      NV_ADMA_STAT_CPBERR |
 			      NV_ADMA_STAT_CMD_COMPLETE)) {
 			u32 check_commands = notifier_clears[i];
-			int pos, error = 0;
+			int pos, rc;
 
 			if (status & NV_ADMA_STAT_CPBERR) {
 				/* check all active commands */
@@ -1030,10 +1030,12 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			}
 
 			/* check CPBs for completed commands */
-			while ((pos = ffs(check_commands)) && !error) {
+			while ((pos = ffs(check_commands))) {
 				pos--;
-				error = nv_adma_check_cpb(ap, pos,
+				rc = nv_adma_check_cpb(ap, pos,
 						notifier_error & (1 << pos));
+				if (unlikely(rc))
+					check_commands = 0;
 				check_commands &= ~(1 << pos);
 			}
 		}
@@ -2129,7 +2131,6 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 	struct nv_swncq_port_priv *pp = ap->private_data;
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u32 sactive;
-	int nr_done = 0;
 	u32 done_mask;
 	int i;
 	u8 host_stat;
@@ -2170,22 +2171,21 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 			pp->dhfis_bits &= ~(1 << i);
 			pp->dmafis_bits &= ~(1 << i);
 			pp->sdbfis_bits |= (1 << i);
-			nr_done++;
 		}
 	}
 
 	if (!ap->qc_active) {
 		DPRINTK("over\n");
 		nv_swncq_pp_reinit(ap);
-		return nr_done;
+		return 0;
 	}
 
 	if (pp->qc_active & pp->dhfis_bits)
-		return nr_done;
+		return 0;
 
 	if ((pp->ncq_flags & ncq_saw_backout) ||
 	    (pp->qc_active ^ pp->dhfis_bits))
-		/* if the controller cann't get a device to host register FIS,
+		/* if the controller can't get a device to host register FIS,
 		 * The driver needs to reissue the new command.
 		 */
 		lack_dhfis = 1;
@@ -2202,7 +2202,7 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 	if (lack_dhfis) {
 		qc = ata_qc_from_tag(ap, pp->last_issue_tag);
 		nv_swncq_issue_atacmd(ap, qc);
-		return nr_done;
+		return 0;
 	}
 
 	if (pp->defer_queue.defer_bits) {
@@ -2212,7 +2212,7 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 		nv_swncq_issue_atacmd(ap, qc);
 	}
 
-	return nr_done;
+	return 0;
 }
 
 static inline u32 nv_swncq_tag(struct ata_port *ap)
@@ -2224,7 +2224,7 @@ static inline u32 nv_swncq_tag(struct ata_port *ap)
 	return (tag & 0x1f);
 }
 
-static int nv_swncq_dmafis(struct ata_port *ap)
+static void nv_swncq_dmafis(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc;
 	unsigned int rw;
@@ -2239,7 +2239,7 @@ static int nv_swncq_dmafis(struct ata_port *ap)
 	qc = ata_qc_from_tag(ap, tag);
 
 	if (unlikely(!qc))
-		return 0;
+		return;
 
 	rw = qc->tf.flags & ATA_TFLAG_WRITE;
 
@@ -2254,8 +2254,6 @@ static int nv_swncq_dmafis(struct ata_port *ap)
 		dmactl |= ATA_DMA_WR;
 
 	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	return 1;
 }
 
 static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
@@ -2265,7 +2263,6 @@ static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u32 serror;
 	u8 ata_stat;
-	int rc = 0;
 
 	ata_stat = ap->ops->sff_check_status(ap);
 	nv_swncq_irq_clear(ap, fis);
@@ -2310,8 +2307,7 @@ static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
 			"dhfis 0x%X dmafis 0x%X sactive 0x%X\n",
 			ap->print_id, pp->qc_active, pp->dhfis_bits,
 			pp->dmafis_bits, readl(pp->sactive_block));
-		rc = nv_swncq_sdbfis(ap);
-		if (rc < 0)
+		if (nv_swncq_sdbfis(ap) < 0)
 			goto irq_error;
 	}
 
@@ -2348,7 +2344,7 @@ static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
 		 */
 		pp->dmafis_bits |= (0x1 << nv_swncq_tag(ap));
 		pp->ncq_flags |= ncq_saw_dmas;
-		rc = nv_swncq_dmafis(ap);
+		nv_swncq_dmafis(ap);
 	}
 
 irq_exit:
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 477345d..a0c20d9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1459,6 +1459,7 @@ static void quirk_jmicron_ata(struct pci_dev *pdev)
 	switch (pdev->device) {
 	case PCI_DEVICE_ID_JMICRON_JMB360: /* SATA single port */
 	case PCI_DEVICE_ID_JMICRON_JMB362: /* SATA dual ports */
+	case PCI_DEVICE_ID_JMICRON_JMB364: /* SATA dual ports */
 		/* The controller should be in single function ahci mode */
 		conf1 |= 0x0002A100; /* Set 8, 13, 15, 17 */
 		break;
@@ -1470,6 +1471,7 @@ static void quirk_jmicron_ata(struct pci_dev *pdev)
 		/* Fall through */
 	case PCI_DEVICE_ID_JMICRON_JMB361:
 	case PCI_DEVICE_ID_JMICRON_JMB363:
+	case PCI_DEVICE_ID_JMICRON_JMB369:
 		/* Enable dual function mode, AHCI on fn 0, IDE fn1 */
 		/* Set the class codes correctly and then direct IDE 0 */
 		conf1 |= 0x00C2A1B3; /* Set 0, 1, 4, 5, 7, 8, 13, 15, 17, 22, 23 */
@@ -1496,16 +1498,20 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, qui
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB364, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB369, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB364, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB369, quirk_jmicron_ata);
 
 #endif
 
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index f7dd576..be3d9a7 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -15,11 +15,13 @@
 #ifndef _AHCI_PLATFORM_H
 #define _AHCI_PLATFORM_H
 
+#include <linux/compiler.h>
+
 struct device;
 struct ata_port_info;
 
 struct ahci_platform_data {
-	int (*init)(struct device *dev);
+	int (*init)(struct device *dev, void __iomem *addr);
 	void (*exit)(struct device *dev);
 	const struct ata_port_info *ata_port_info;
 	unsigned int force_port_map;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bedcc1..eb200e6 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2324,9 +2324,11 @@
 #define PCI_DEVICE_ID_JMICRON_JMB361	0x2361
 #define PCI_DEVICE_ID_JMICRON_JMB362	0x2362
 #define PCI_DEVICE_ID_JMICRON_JMB363	0x2363
+#define PCI_DEVICE_ID_JMICRON_JMB364	0x2364
 #define PCI_DEVICE_ID_JMICRON_JMB365	0x2365
 #define PCI_DEVICE_ID_JMICRON_JMB366	0x2366
 #define PCI_DEVICE_ID_JMICRON_JMB368	0x2368
+#define PCI_DEVICE_ID_JMICRON_JMB369	0x2369
 #define PCI_DEVICE_ID_JMICRON_JMB38X_SD	0x2381
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MMC 0x2382
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MS	0x2383
