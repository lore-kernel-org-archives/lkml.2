Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2CVFaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:30:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38381 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab2CVFah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:30:37 -0400
X-Greylist: delayed 1097 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2012 01:30:36 EDT
Date: Thu, 22 Mar 2012 01:12:18 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 3.4
Message-ID: <20120322051218.GA4861@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This is my first attempt using signed tags.  Any pull req format
critique welcome.

The summary of this pull request is included in the signed tag message,
but not duplicated into the email.

	Jeff


Please pull b8cec3c253a2a001e463c43260fb75fb3223a04d from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git for-linus


to receive the following updates:

 drivers/ata/ahci.c           |   10 ++-
 drivers/ata/ahci.h           |    6 ++
 drivers/ata/ahci_platform.c  |   11 +++
 drivers/ata/ata_piix.c       |    8 ++
 drivers/ata/libahci.c        |    5 ++
 drivers/ata/pata_arasan_cf.c |   12 +--
 drivers/ata/pata_cmd64x.c    |  147 +++++++++++++++++++++++++++++++++---------
 drivers/ata/pata_legacy.c    |    3 +-
 drivers/ata/pata_mpc52xx.c   |   44 ++++--------
 drivers/ata/sata_fsl.c       |  111 ++++++++++++++++++++++++++++++-
 10 files changed, 281 insertions(+), 76 deletions(-)

Brian Norris (3):
      ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
      ahci: move AHCI_HFLAGS() macro to ahci.h
      ahci_platform: add STRICT_AHCI platform type

Julia Lawall (1):
      drivers/ata/pata_mpc52xx.c: clean up error handling code

Qiang Liu (1):
      sata_fsl: add support for interrupt coalsecing feature

Sergei Shtylyov (5):
      pata_legacy: correctly mask recovery field for HT6560B
      pata_cmd64x: turn string of *if* statements into *switch*
      pata_cmd64x: use interrupt status from MRDMODE register
      pata_cmd64x: implement sff_irq_clear() method
      pata_cmd64x: implement sff_irq_check() method

Seth Heasley (2):
      ahci: AHCI-mode SATA patch for Intel Lynx Point DeviceIDs
      ata_piix: IDE-mode SATA patch for Intel Lynx Point DeviceIDs

Viresh Kumar (1):
      ata/pata_arasan_cf: Add Hibernation support

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d07bf03..79a1e9d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -103,8 +103,6 @@ static struct ata_port_operations ahci_p5wdh_ops = {
 	.hardreset		= ahci_p5wdh_hardreset,
 };
 
-#define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
-
 static const struct ata_port_info ahci_port_info[] = {
 	/* by features */
 	[board_ahci] =
@@ -261,6 +259,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e0e), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c02), board_ahci }, /* Lynx Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c03), board_ahci }, /* Lynx Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c04), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c05), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c06), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c07), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c0e), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c0f), board_ahci }, /* Lynx Point RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b175000..c2594dd 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -195,6 +195,9 @@ enum {
 	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
 
 	/* hpriv->flags bits */
+
+#define AHCI_HFLAGS(flags)		.private_data	= (void *)(flags)
+
 	AHCI_HFLAG_NO_NCQ		= (1 << 0),
 	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
 	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
@@ -210,6 +213,9 @@ enum {
 	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
 	AHCI_HFLAG_NO_FPDMA_AA		= (1 << 13), /* no FPDMA AA */
 	AHCI_HFLAG_YES_FBS		= (1 << 14), /* force FBS cap on */
+	AHCI_HFLAG_DELAY_ENGINE		= (1 << 15), /* do not start engine on
+						        port start (wait until
+						        error-handling stage) */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 48be4e1..0c86c77 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -26,6 +26,7 @@
 enum ahci_type {
 	AHCI,		/* standard platform ahci */
 	IMX53_AHCI,	/* ahci on i.mx53 */
+	STRICT_AHCI,	/* delayed DMA engine start */
 };
 
 static struct platform_device_id ahci_devtype[] = {
@@ -36,6 +37,9 @@ static struct platform_device_id ahci_devtype[] = {
 		.name = "imx53-ahci",
 		.driver_data = IMX53_AHCI,
 	}, {
+		.name = "strict-ahci",
+		.driver_data = STRICT_AHCI,
+	}, {
 		/* sentinel */
 	}
 };
@@ -56,6 +60,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_pmp_retry_srst_ops,
 	},
+	[STRICT_AHCI] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_DELAY_ENGINE),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static struct scsi_host_template ahci_platform_sht = {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index fdf27b9..68013f9 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -321,6 +321,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x1e08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Panther Point) */
 	{ 0x8086, 0x1e09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index a72bfd0..f9eaa82 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -737,6 +737,7 @@ static void ahci_power_down(struct ata_port *ap)
 
 static void ahci_start_port(struct ata_port *ap)
 {
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ata_link *link;
 	struct ahci_em_priv *emp;
@@ -746,6 +747,10 @@ static void ahci_start_port(struct ata_port *ap)
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
+	/* enable DMA */
+	if (!(hpriv->flags & AHCI_HFLAG_DELAY_ENGINE))
+		ahci_start_engine(ap);
+
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 048589f..fc2db2a 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -925,11 +925,10 @@ static int arasan_cf_suspend(struct device *dev)
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
 
-	if (acdev->dma_chan) {
+	if (acdev->dma_chan)
 		acdev->dma_chan->device->device_control(acdev->dma_chan,
 				DMA_TERMINATE_ALL, 0);
-		dma_release_channel(acdev->dma_chan);
-	}
+
 	cf_exit(acdev);
 	return ata_host_suspend(host, PMSG_SUSPEND);
 }
@@ -945,10 +944,7 @@ static int arasan_cf_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops arasan_cf_pm_ops = {
-	.suspend	= arasan_cf_suspend,
-	.resume		= arasan_cf_resume,
-};
+static SIMPLE_DEV_PM_OPS(arasan_cf_pm_ops, arasan_cf_suspend, arasan_cf_resume);
 #endif
 
 static struct platform_driver arasan_cf_driver = {
@@ -958,7 +954,7 @@ static struct platform_driver arasan_cf_driver = {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
-		.pm		= &arasan_cf_pm_ops,
+		.pm	= &arasan_cf_pm_ops,
 #endif
 	},
 };
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index e1fb39a..1c17cd1 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -3,6 +3,7 @@
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
+ *			  (C) 2012 MontaVista Software, LLC <source@mvista.com>
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
@@ -32,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.5"
+#define DRV_VERSION "0.2.18"
 
 /*
  * CMD64x specific registers definition.
@@ -229,28 +230,85 @@ static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	cmd648_dma_stop	-	DMA stop callback
- *	@qc: Command in progress
+ *	cmd64x_sff_irq_check	-	check IDE interrupt
+ *	@ap: ATA interface
  *
- *	DMA has completed.
+ *	Check IDE interrupt in CFR/ARTTIM23 registers.
  */
 
-static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
+static bool cmd64x_sff_irq_check(struct ata_port *ap)
 {
-	struct ata_port *ap = qc->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 dma_intr;
-	int dma_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
-	int dma_reg = ap->port_no ? ARTTIM23 : CFR;
+	int irq_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
+	int irq_reg  = ap->port_no ? ARTTIM23 : CFR;
+	u8 irq_stat;
 
-	ata_bmdma_stop(qc);
+	/* NOTE: reading the register should clear the interrupt */
+	pci_read_config_byte(pdev, irq_reg, &irq_stat);
+
+	return irq_stat & irq_mask;
+}
+
+/**
+ *	cmd64x_sff_irq_clear	-	clear IDE interrupt
+ *	@ap: ATA interface
+ *
+ *	Clear IDE interrupt in CFR/ARTTIM23 and DMA status registers.
+ */
+
+static void cmd64x_sff_irq_clear(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int irq_reg = ap->port_no ? ARTTIM23 : CFR;
+	u8 irq_stat;
+
+	ata_bmdma_irq_clear(ap);
 
-	pci_read_config_byte(pdev, dma_reg, &dma_intr);
-	pci_write_config_byte(pdev, dma_reg, dma_intr | dma_mask);
+	/* Reading the register should be enough to clear the interrupt */
+	pci_read_config_byte(pdev, irq_reg, &irq_stat);
 }
 
 /**
- *	cmd646r1_dma_stop	-	DMA stop callback
+ *	cmd648_sff_irq_check	-	check IDE interrupt
+ *	@ap: ATA interface
+ *
+ *	Check IDE interrupt in MRDMODE register.
+ */
+
+static bool cmd648_sff_irq_check(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long base = pci_resource_start(pdev, 4);
+	int irq_mask = ap->port_no ? MRDMODE_INTR_CH1 : MRDMODE_INTR_CH0;
+	u8 mrdmode = inb(base + 1);
+
+	return mrdmode & irq_mask;
+}
+
+/**
+ *	cmd648_sff_irq_clear	-	clear IDE interrupt
+ *	@ap: ATA interface
+ *
+ *	Clear IDE interrupt in MRDMODE and DMA status registers.
+ */
+
+static void cmd648_sff_irq_clear(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long base = pci_resource_start(pdev, 4);
+	int irq_mask = ap->port_no ? MRDMODE_INTR_CH1 : MRDMODE_INTR_CH0;
+	u8 mrdmode;
+
+	ata_bmdma_irq_clear(ap);
+
+	/* Clear this port's interrupt bit (leaving the other port alone) */
+	mrdmode  = inb(base + 1);
+	mrdmode &= ~(MRDMODE_INTR_CH0 | MRDMODE_INTR_CH1);
+	outb(mrdmode | irq_mask, base + 1);
+}
+
+/**
+ *	cmd646r1_bmdma_stop	-	DMA stop callback
  *	@qc: Command in progress
  *
  *	Stub for now while investigating the r1 quirk in the old driver.
@@ -273,18 +331,30 @@ static const struct ata_port_operations cmd64x_base_ops = {
 
 static struct ata_port_operations cmd64x_port_ops = {
 	.inherits	= &cmd64x_base_ops,
+	.sff_irq_check	= cmd64x_sff_irq_check,
+	.sff_irq_clear	= cmd64x_sff_irq_clear,
 	.cable_detect	= ata_cable_40wire,
 };
 
 static struct ata_port_operations cmd646r1_port_ops = {
 	.inherits	= &cmd64x_base_ops,
+	.sff_irq_check	= cmd64x_sff_irq_check,
+	.sff_irq_clear	= cmd64x_sff_irq_clear,
 	.bmdma_stop	= cmd646r1_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
 };
 
+static struct ata_port_operations cmd646r3_port_ops = {
+	.inherits	= &cmd64x_base_ops,
+	.sff_irq_check	= cmd648_sff_irq_check,
+	.sff_irq_clear	= cmd648_sff_irq_clear,
+	.cable_detect	= ata_cable_40wire,
+};
+
 static struct ata_port_operations cmd648_port_ops = {
 	.inherits	= &cmd64x_base_ops,
-	.bmdma_stop	= cmd648_bmdma_stop,
+	.sff_irq_check	= cmd648_sff_irq_check,
+	.sff_irq_clear	= cmd648_sff_irq_clear,
 	.cable_detect	= cmd648_cable_detect,
 };
 
@@ -306,7 +376,7 @@ static void cmd64x_fixup(struct pci_dev *pdev)
 
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static const struct ata_port_info cmd_info[6] = {
+	static const struct ata_port_info cmd_info[7] = {
 		{	/* CMD 643 - no UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = ATA_PIO4,
@@ -319,12 +389,18 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.mwdma_mask = ATA_MWDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
-		{	/* CMD 646 with working UDMA */
+		{	/* CMD 646U with broken UDMA */
+			.flags = ATA_FLAG_SLAVE_POSS,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.port_ops = &cmd646r3_port_ops
+		},
+		{	/* CMD 646U2 with working UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = ATA_PIO4,
 			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA2,
-			.port_ops = &cmd64x_port_ops
+			.port_ops = &cmd646r3_port_ops
 		},
 		{	/* CMD 646 rev 1  */
 			.flags = ATA_FLAG_SLAVE_POSS,
@@ -368,21 +444,30 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (id->driver_data == 0)	/* 643 */
 		ata_pci_bmdma_clear_simplex(pdev);
 
-	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
-		/* Does UDMA work ? */
-		if (pdev->revision > 4) {
-			ppi[0] = &cmd_info[2];
-			ppi[1] = &cmd_info[2];
-		}
-		/* Early rev with other problems ? */
-		else if (pdev->revision == 1) {
+	if (pdev->device == PCI_DEVICE_ID_CMD_646)
+		switch (pdev->revision) {
+		/* UDMA works since rev 5 */
+		default:
 			ppi[0] = &cmd_info[3];
 			ppi[1] = &cmd_info[3];
-		}
-		/* revs 1,2 have no CNTRL_CH0 */
-		if (pdev->revision < 3)
+			break;
+		/* Interrupts in MRDMODE since rev 3 */
+		case 3:
+		case 4:
+			ppi[0] = &cmd_info[2];
+			ppi[1] = &cmd_info[2];
+			break;
+		/* Rev 1 with other problems? */
+		case 1:
+			ppi[0] = &cmd_info[4];
+			ppi[1] = &cmd_info[4];
+			/* FALL THRU */
+		/* Early revs have no CNTRL_CH0 */
+		case 2:
+		case 0:
 			cntrl_ch0_ok = 0;
-	}
+			break;
+		}
 
 	cmd64x_fixup(pdev);
 
@@ -423,8 +508,8 @@ static int cmd64x_reinit_one(struct pci_dev *pdev)
 static const struct pci_device_id cmd64x[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_643), 0 },
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_646), 1 },
-	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_648), 4 },
-	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_649), 5 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_648), 5 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_649), 6 },
 
 	{ },
 };
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 35aca7d..4fe9d21 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -401,8 +401,7 @@ static void ht6560b_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
 	active = clamp_val(t.active, 2, 15);
-	recover = clamp_val(t.recover, 2, 16);
-	recover &= 0x15;
+	recover = clamp_val(t.recover, 2, 16) & 0x0F;
 
 	inb(0x3E6);
 	inb(0x3E6);
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 00748ae..d2c102f 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -687,11 +687,11 @@ mpc52xx_ata_probe(struct platform_device *op)
 	int ata_irq = 0;
 	struct mpc52xx_ata __iomem *ata_regs;
 	struct mpc52xx_ata_priv *priv = NULL;
-	int rv, ret, task_irq = 0;
+	int rv, task_irq;
 	int mwdma_mask = 0, udma_mask = 0;
 	const __be32 *prop;
 	int proplen;
-	struct bcom_task *dmatsk = NULL;
+	struct bcom_task *dmatsk;
 
 	/* Get ipb frequency */
 	ipb_freq = mpc5xxx_get_bus_frequency(op->dev.of_node);
@@ -717,8 +717,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	ata_regs = devm_ioremap(&op->dev, res_mem.start, sizeof(*ata_regs));
 	if (!ata_regs) {
 		dev_err(&op->dev, "error mapping device registers\n");
-		rv = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	/*
@@ -753,7 +752,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	if (!priv) {
 		dev_err(&op->dev, "error allocating private structure\n");
 		rv = -ENOMEM;
-		goto err;
+		goto err1;
 	}
 
 	priv->ipb_period = 1000000000 / (ipb_freq / 1000);
@@ -776,15 +775,15 @@ mpc52xx_ata_probe(struct platform_device *op)
 	if (!dmatsk) {
 		dev_err(&op->dev, "bestcomm initialization failed\n");
 		rv = -ENOMEM;
-		goto err;
+		goto err1;
 	}
 
 	task_irq = bcom_get_task_irq(dmatsk);
-	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, 0,
+	rv = devm_request_irq(&op->dev, task_irq, &mpc52xx_ata_task_irq, 0,
 				"ATA task", priv);
-	if (ret) {
+	if (rv) {
 		dev_err(&op->dev, "error requesting DMA IRQ\n");
-		goto err;
+		goto err2;
 	}
 	priv->dmatsk = dmatsk;
 
@@ -792,7 +791,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	rv = mpc52xx_ata_hw_init(priv);
 	if (rv) {
 		dev_err(&op->dev, "error initializing hardware\n");
-		goto err;
+		goto err2;
 	}
 
 	/* Register ourselves to libata */
@@ -800,23 +799,16 @@ mpc52xx_ata_probe(struct platform_device *op)
 				  mwdma_mask, udma_mask);
 	if (rv) {
 		dev_err(&op->dev, "error registering with ATA layer\n");
-		goto err;
+		goto err2;
 	}
 
 	return 0;
 
- err:
-	devm_release_mem_region(&op->dev, res_mem.start, sizeof(*ata_regs));
-	if (ata_irq)
-		irq_dispose_mapping(ata_irq);
-	if (task_irq)
-		irq_dispose_mapping(task_irq);
-	if (dmatsk)
-		bcom_ata_release(dmatsk);
-	if (ata_regs)
-		devm_iounmap(&op->dev, ata_regs);
-	if (priv)
-		devm_kfree(&op->dev, priv);
+ err2:
+	irq_dispose_mapping(task_irq);
+	bcom_ata_release(dmatsk);
+ err1:
+	irq_dispose_mapping(ata_irq);
 	return rv;
 }
 
@@ -835,12 +827,6 @@ mpc52xx_ata_remove(struct platform_device *op)
 	bcom_ata_release(priv->dmatsk);
 	irq_dispose_mapping(priv->ata_irq);
 
-	/* Clear up IO allocations */
-	devm_iounmap(&op->dev, priv->ata_regs);
-	devm_release_mem_region(&op->dev, priv->ata_regs_pa,
-				sizeof(*priv->ata_regs));
-	devm_kfree(&op->dev, priv);
-
 	return 0;
 }
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 0120b0d..d6577b9 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -6,7 +6,7 @@
  * Author: Ashish Kalra <ashish.kalra@freescale.com>
  * Li Yang <leoli@freescale.com>
  *
- * Copyright (c) 2006-2007, 2011 Freescale Semiconductor, Inc.
+ * Copyright (c) 2006-2007, 2011-2012 Freescale Semiconductor, Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -26,6 +26,15 @@
 #include <asm/io.h>
 #include <linux/of_platform.h>
 
+static unsigned int intr_coalescing_count;
+module_param(intr_coalescing_count, int, S_IRUGO);
+MODULE_PARM_DESC(intr_coalescing_count,
+				 "INT coalescing count threshold (1..31)");
+
+static unsigned int intr_coalescing_ticks;
+module_param(intr_coalescing_ticks, int, S_IRUGO);
+MODULE_PARM_DESC(intr_coalescing_ticks,
+				 "INT coalescing timer threshold in AHB ticks");
 /* Controller information */
 enum {
 	SATA_FSL_QUEUE_DEPTH	= 16,
@@ -83,6 +92,16 @@ enum {
 };
 
 /*
+ * Interrupt Coalescing Control Register bitdefs  */
+enum {
+	ICC_MIN_INT_COUNT_THRESHOLD	= 1,
+	ICC_MAX_INT_COUNT_THRESHOLD	= ((1 << 5) - 1),
+	ICC_MIN_INT_TICKS_THRESHOLD	= 0,
+	ICC_MAX_INT_TICKS_THRESHOLD	= ((1 << 19) - 1),
+	ICC_SAFE_INT_TICKS		= 1,
+};
+
+/*
 * Host Controller command register set - per port
 */
 enum {
@@ -263,8 +282,65 @@ struct sata_fsl_host_priv {
 	void __iomem *csr_base;
 	int irq;
 	int data_snoop;
+	struct device_attribute intr_coalescing;
 };
 
+static void fsl_sata_set_irq_coalescing(struct ata_host *host,
+		unsigned int count, unsigned int ticks)
+{
+	struct sata_fsl_host_priv *host_priv = host->private_data;
+	void __iomem *hcr_base = host_priv->hcr_base;
+
+	if (count > ICC_MAX_INT_COUNT_THRESHOLD)
+		count = ICC_MAX_INT_COUNT_THRESHOLD;
+	else if (count < ICC_MIN_INT_COUNT_THRESHOLD)
+		count = ICC_MIN_INT_COUNT_THRESHOLD;
+
+	if (ticks > ICC_MAX_INT_TICKS_THRESHOLD)
+		ticks = ICC_MAX_INT_TICKS_THRESHOLD;
+	else if ((ICC_MIN_INT_TICKS_THRESHOLD == ticks) &&
+			(count > ICC_MIN_INT_COUNT_THRESHOLD))
+		ticks = ICC_SAFE_INT_TICKS;
+
+	spin_lock(&host->lock);
+	iowrite32((count << 24 | ticks), hcr_base + ICC);
+
+	intr_coalescing_count = count;
+	intr_coalescing_ticks = ticks;
+	spin_unlock(&host->lock);
+
+	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
+			intr_coalescing_count, intr_coalescing_ticks);
+	DPRINTK("ICC register status: (hcr base: 0x%x) = 0x%x\n",
+			hcr_base, ioread32(hcr_base + ICC));
+}
+
+static ssize_t fsl_sata_intr_coalescing_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d	%d\n",
+			intr_coalescing_count, intr_coalescing_ticks);
+}
+
+static ssize_t fsl_sata_intr_coalescing_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned int coalescing_count,	coalescing_ticks;
+
+	if (sscanf(buf, "%d%d",
+				&coalescing_count,
+				&coalescing_ticks) != 2) {
+		printk(KERN_ERR "fsl-sata: wrong parameter format.\n");
+		return -EINVAL;
+	}
+
+	fsl_sata_set_irq_coalescing(dev_get_drvdata(dev),
+			coalescing_count, coalescing_ticks);
+
+	return strlen(buf);
+}
+
 static inline unsigned int sata_fsl_tag(unsigned int tag,
 					void __iomem *hcr_base)
 {
@@ -346,10 +422,10 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 			(unsigned long long)sg_addr, sg_len);
 
 		/* warn if each s/g element is not dword aligned */
-		if (sg_addr & 0x03)
+		if (unlikely(sg_addr & 0x03))
 			ata_port_err(qc->ap, "s/g addr unaligned : 0x%llx\n",
 				     (unsigned long long)sg_addr);
-		if (sg_len & 0x03)
+		if (unlikely(sg_len & 0x03))
 			ata_port_err(qc->ap, "s/g len unaligned : 0x%x\n",
 				     sg_len);
 
@@ -1245,6 +1321,13 @@ static int sata_fsl_init_controller(struct ata_host *host)
 	iowrite32(0x00000FFFF, hcr_base + CE);
 	iowrite32(0x00000FFFF, hcr_base + DE);
 
+ 	/*
+	 * reset the number of command complete bits which will cause the
+	 * interrupt to be signaled
+	 */
+	fsl_sata_set_irq_coalescing(host, intr_coalescing_count,
+			intr_coalescing_ticks);
+
 	/*
 	 * host controller will be brought on-line, during xx_port_start()
 	 * callback, that should also initiate the OOB, COMINIT sequence
@@ -1309,7 +1392,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	void __iomem *csr_base = NULL;
 	struct sata_fsl_host_priv *host_priv = NULL;
 	int irq;
-	struct ata_host *host;
+	struct ata_host *host = NULL;
 	u32 temp;
 
 	struct ata_port_info pi = sata_fsl_port_info[0];
@@ -1356,6 +1439,10 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 
 	/* allocate host structure */
 	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_FSL_MAX_PORTS);
+	if (!host) {
+		retval = -ENOMEM;
+		goto error_exit_with_cleanup;
+	}
 
 	/* host->iomap is not used currently */
 	host->private_data = host_priv;
@@ -1373,10 +1460,24 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 
 	dev_set_drvdata(&ofdev->dev, host);
 
+	host_priv->intr_coalescing.show = fsl_sata_intr_coalescing_show;
+	host_priv->intr_coalescing.store = fsl_sata_intr_coalescing_store;
+	sysfs_attr_init(&host_priv->intr_coalescing.attr);
+	host_priv->intr_coalescing.attr.name = "intr_coalescing";
+	host_priv->intr_coalescing.attr.mode = S_IRUGO | S_IWUSR;
+	retval = device_create_file(host->dev, &host_priv->intr_coalescing);
+	if (retval)
+		goto error_exit_with_cleanup;
+
 	return 0;
 
 error_exit_with_cleanup:
 
+	if (host) {
+		dev_set_drvdata(&ofdev->dev, NULL);
+		ata_host_detach(host);
+	}
+
 	if (hcr_base)
 		iounmap(hcr_base);
 	if (host_priv)
@@ -1390,6 +1491,8 @@ static int sata_fsl_remove(struct platform_device *ofdev)
 	struct ata_host *host = dev_get_drvdata(&ofdev->dev);
 	struct sata_fsl_host_priv *host_priv = host->private_data;
 
+	device_remove_file(&ofdev->dev, &host_priv->intr_coalescing);
+
 	ata_host_detach(host);
 
 	dev_set_drvdata(&ofdev->dev, NULL);
