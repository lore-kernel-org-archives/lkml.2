Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab1DXP5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 11:57:52 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44028 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab1DXP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 11:57:50 -0400
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Apr 2011 11:57:50 EDT
Date: Sun, 24 Apr 2011 11:39:04 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata bug fixes
Message-ID: <20110424153904.GA15211@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Several minor AHCI fixes

2) pata_at91 fixes

3) ahci, ata_piix PCI IDs

4) CD-ROM quirk

5) Export some necessary Enclosure Management (EM) details from AHCI

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    8 +++++-
 drivers/ata/ahci.h        |    4 +++
 drivers/ata/ata_piix.c    |    8 ++++++
 drivers/ata/libahci.c     |   60 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-core.c |    3 +-
 drivers/ata/libata-eh.c   |    6 +++-
 drivers/ata/pata_at91.c   |   22 ++++++++++++++--
 include/linux/libata.h    |    3 +-
 8 files changed, 103 insertions(+), 11 deletions(-)

Hannes Reinecke (1):
      ahci: EM supported message type sysfs attribute

Igor Plyatov (2):
      ata: pata_at91.c bugfix for high master clock
      ata: pata_at91.c bugfix for initial_timing initialisation

Jeff Mahoney (1):
      libata: Pioneer DVR-216D can't do SETXFER

Jian Peng (1):
      libata: ahci_start_engine compliant to AHCI spec

Maxime Bizon (1):
      ahci: don't enable port irq before handler is registered

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Panther Point DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Panther Point DeviceIDs

Tejun Heo (2):
      libata: Kill unused ATA_DFLAG_{H|D}IPM flags
      libata: Implement ATA_FLAG_NO_DIPM and apply it to mcp65

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 39d829c..71afe03 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -150,7 +150,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP |
 				 AHCI_HFLAG_YES_NCQ),
-		.flags		= AHCI_FLAG_COMMON,
+		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NO_DIPM,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
@@ -261,6 +261,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1e02), board_ahci }, /* Panther Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1e03), board_ahci }, /* Panther Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1e04), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e05), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 3986500..12c5282 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -229,6 +229,10 @@ enum {
 	EM_CTL_ALHD		= (1 << 26), /* Activity LED */
 	EM_CTL_XMT		= (1 << 25), /* Transmit Only */
 	EM_CTL_SMB		= (1 << 24), /* Single Message Buffer */
+	EM_CTL_SGPIO		= (1 << 19), /* SGPIO messages supported */
+	EM_CTL_SES		= (1 << 18), /* SES-2 messages supported */
+	EM_CTL_SAFTE		= (1 << 17), /* SAF-TE messages supported */
+	EM_CTL_LED		= (1 << 16), /* LED messages supported */
 
 	/* em message type */
 	EM_MSG_TYPE_LED		= (1 << 0), /* LED */
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 0bc3fd6..6f6e771 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -309,6 +309,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (PBG) */
 	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 26d4523..ff9d832 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -109,6 +109,8 @@ static ssize_t ahci_read_em_buffer(struct device *dev,
 static ssize_t ahci_store_em_buffer(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t size);
+static ssize_t ahci_show_em_supported(struct device *dev,
+				      struct device_attribute *attr, char *buf);
 
 static DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
 static DEVICE_ATTR(ahci_host_cap2, S_IRUGO, ahci_show_host_cap2, NULL);
@@ -116,6 +118,7 @@ static DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
 static DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
 static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
 		   ahci_read_em_buffer, ahci_store_em_buffer);
+static DEVICE_ATTR(em_message_supported, S_IRUGO, ahci_show_em_supported, NULL);
 
 struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
@@ -126,6 +129,7 @@ struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_ahci_host_version,
 	&dev_attr_ahci_port_cmd,
 	&dev_attr_em_buffer,
+	&dev_attr_em_message_supported,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ahci_shost_attrs);
@@ -343,6 +347,24 @@ static ssize_t ahci_store_em_buffer(struct device *dev,
 	return size;
 }
 
+static ssize_t ahci_show_em_supported(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 em_ctl;
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+
+	return sprintf(buf, "%s%s%s%s\n",
+		       em_ctl & EM_CTL_LED ? "led " : "",
+		       em_ctl & EM_CTL_SAFTE ? "saf-te " : "",
+		       em_ctl & EM_CTL_SES ? "ses-2 " : "",
+		       em_ctl & EM_CTL_SGPIO ? "sgpio " : "");
+}
+
 /**
  *	ahci_save_initial_config - Save and fixup initial config values
  *	@dev: target AHCI device
@@ -539,6 +561,27 @@ void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	u8 status;
+
+	status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+	/*
+	 * At end of section 10.1 of AHCI spec (rev 1.3), it states
+	 * Software shall not set PxCMD.ST to 1 until it is determined
+	 * that a functoinal device is present on the port as determined by
+	 * PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
+	 *
+	 * Even though most AHCI host controllers work without this check,
+	 * specific controller will fail under this condition
+	 */
+	if (status & (ATA_BUSY | ATA_DRQ))
+		return;
+	else {
+		ahci_scr_read(&ap->link, SCR_STATUS, &tmp);
+
+		if ((tmp & 0xf) != 0x3)
+			return;
+	}
 
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
@@ -1897,7 +1940,17 @@ static void ahci_pmp_attach(struct ata_port *ap)
 	ahci_enable_fbs(ap);
 
 	pp->intr_mask |= PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+	 * We must not change the port interrupt mask register if the
+	 * port is marked frozen, the value in pp->intr_mask will be
+	 * restored later when the port is thawed.
+	 *
+	 * Note that during initialization, the port is marked as
+	 * frozen since the irq handler is not yet registered.
+	 */
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_pmp_detach(struct ata_port *ap)
@@ -1913,7 +1966,10 @@ static void ahci_pmp_detach(struct ata_port *ap)
 	writel(cmd, port_mmio + PORT_CMD);
 
 	pp->intr_mask &= ~PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/* see comment above in ahci_pmp_attach() */
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 int ahci_port_resume(struct ata_port *ap)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 423c0a6..76c3c15 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4139,6 +4139,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	 */
 	{ "PIONEER DVD-RW  DVRTD08",	"1.00",	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-212D",	"1.28", ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVR-216D",	"1.08", ATA_HORKAGE_NOSETXFER },
 
 	/* End Marker */
 	{ }
@@ -5480,7 +5481,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	if (!ap)
 		return NULL;
 
-	ap->pflags |= ATA_PFLAG_INITIALIZING;
+	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
 	ap->host = host;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 88cd22f..f26f2fe 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3316,6 +3316,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
 	enum ata_lpm_policy old_policy = link->lpm_policy;
+	bool no_dipm = ap->flags & ATA_FLAG_NO_DIPM;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
@@ -3332,7 +3333,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	 */
 	ata_for_each_dev(dev, link, ENABLED) {
 		bool hipm = ata_id_has_hipm(dev->id);
-		bool dipm = ata_id_has_dipm(dev->id);
+		bool dipm = ata_id_has_dipm(dev->id) && !no_dipm;
 
 		/* find the first enabled and LPM enabled devices */
 		if (!link_dev)
@@ -3389,7 +3390,8 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 
 	/* host config updated, enable DIPM if transitioning to MIN_POWER */
 	ata_for_each_dev(dev, link, ENABLED) {
-		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
+		if (policy == ATA_LPM_MIN_POWER && !no_dipm &&
+		    ata_id_has_dipm(dev->id)) {
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 0da0dcc..a5fdbdc 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -33,11 +33,12 @@
 
 
 #define DRV_NAME "pata_at91"
-#define DRV_VERSION "0.1"
+#define DRV_VERSION "0.2"
 
 #define CF_IDE_OFFSET	    0x00c00000
 #define CF_ALT_IDE_OFFSET   0x00e00000
 #define CF_IDE_RES_SIZE     0x08
+#define NCS_RD_PULSE_LIMIT  0x3f /* maximal value for pulse bitfields */
 
 struct at91_ide_info {
 	unsigned long mode;
@@ -49,8 +50,18 @@ struct at91_ide_info {
 	void __iomem *alt_addr;
 };
 
-static const struct ata_timing initial_timing =
-	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
+static const struct ata_timing initial_timing = {
+	.mode		= XFER_PIO_0,
+	.setup		= 70,
+	.act8b		= 290,
+	.rec8b		= 240,
+	.cyc8b		= 600,
+	.active		= 165,
+	.recover	= 150,
+	.dmack_hold	= 0,
+	.cycle		= 600,
+	.udma		= 0
+};
 
 static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 {
@@ -109,6 +120,11 @@ static void set_smc_timing(struct device *dev,
 	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
 	ncs_read_setup = 1;
 	ncs_read_pulse = read_cycle - 2;
+	if (ncs_read_pulse > NCS_RD_PULSE_LIMIT) {
+		ncs_read_pulse = NCS_RD_PULSE_LIMIT;
+		dev_warn(dev, "ncs_read_pulse limited to maximal value %lu\n",
+			ncs_read_pulse);
+	}
 
 	/* Write timings same as read timings */
 	write_cycle = read_cycle;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7f675aa..04f32a3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -137,8 +137,6 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
-	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
-	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
@@ -198,6 +196,7 @@ enum {
 					      * management */
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
+	ATA_FLAG_NO_DIPM	= (1 << 23), /* host not happy with DIPM */
 
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 
