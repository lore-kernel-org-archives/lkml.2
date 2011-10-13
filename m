Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1JMNqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:46:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59496 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab1JMNp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:45:57 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2 4/4] ata_piix: re-oder code and remove prototypes
Date: Thu, 13 Oct 2011 15:44:50 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131544.50339.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: re-oder code and remove prototypes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |  335 ++++++++++++++++++++++---------------------------
 1 file changed, 157 insertions(+), 178 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -161,27 +161,6 @@ struct piix_host_priv {
 	void __iomem *sidpr;
 };
 
-static int piix_init_one(struct pci_dev *pdev,
-			 const struct pci_device_id *ent);
-static void piix_remove_one(struct pci_dev *pdev);
-static int piix_pata_prereset(struct ata_link *link, unsigned long deadline);
-static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
-static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-static int ich_pata_cable_detect(struct ata_port *ap);
-static u8 piix_vmw_bmdma_status(struct ata_port *ap);
-static int piix_sidpr_scr_read(struct ata_link *link,
-			       unsigned int reg, u32 *val);
-static int piix_sidpr_scr_write(struct ata_link *link,
-				unsigned int reg, u32 val);
-static int piix_sidpr_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
-			      unsigned hints);
-static bool piix_irq_check(struct ata_port *ap);
-#ifdef CONFIG_PM
-static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int piix_pci_device_resume(struct pci_dev *pdev);
-#endif
-
 static unsigned int in_module_init = 1;
 
 static const struct pci_device_id piix_pci_tbl[] = {
@@ -312,63 +291,6 @@ static const struct pci_device_id piix_p
 	{ }	/* terminate list */
 };
 
-static struct pci_driver piix_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= piix_pci_tbl,
-	.probe			= piix_init_one,
-	.remove			= piix_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= piix_pci_device_suspend,
-	.resume			= piix_pci_device_resume,
-#endif
-};
-
-static struct scsi_host_template piix_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations piix_sata_ops = {
-	.inherits		= &ata_bmdma32_port_ops,
-	.sff_irq_check		= piix_irq_check,
-};
-
-static struct ata_port_operations piix_pata_ops = {
-	.inherits		= &piix_sata_ops,
-	.cable_detect		= ata_cable_40wire,
-	.set_piomode		= piix_set_piomode,
-	.set_dmamode		= piix_set_dmamode,
-	.prereset		= piix_pata_prereset,
-};
-
-static struct ata_port_operations piix_vmw_ops = {
-	.inherits		= &piix_pata_ops,
-	.bmdma_status		= piix_vmw_bmdma_status,
-};
-
-static struct ata_port_operations ich_pata_ops = {
-	.inherits		= &piix_pata_ops,
-	.cable_detect		= ich_pata_cable_detect,
-	.set_dmamode		= ich_set_dmamode,
-};
-
-static struct device_attribute *piix_sidpr_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
-	NULL
-};
-
-static struct scsi_host_template piix_sidpr_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-	.shost_attrs		= piix_sidpr_shost_attrs,
-};
-
-static struct ata_port_operations piix_sidpr_sata_ops = {
-	.inherits		= &piix_sata_ops,
-	.hardreset		= sata_std_hardreset,
-	.scr_read		= piix_sidpr_scr_read,
-	.scr_write		= piix_sidpr_scr_write,
-	.set_lpm		= piix_sidpr_set_lpm,
-};
-
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -472,106 +394,6 @@ static const struct piix_map_db *piix_ma
 	[tolapai_sata]		= &tolapai_map_db,
 };
 
-static struct ata_port_info piix_port_info[] = {
-	[piix_pata_mwdma] = {	/* PIIX3 MWDMA only */
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
-		.port_ops	= &piix_pata_ops,
-	},
-	[piix_pata_33] = {	/* PIIX4 at 33MHz */
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &piix_pata_ops,
-	},
-	[ich_pata_33] = {	/* ICH0 - ICH at 33Mhz*/
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &ich_pata_ops,
-	},
-	[ich_pata_66] = {	/* ICH controllers up to 66MHz */
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
-		.udma_mask	= ATA_UDMA4,
-		.port_ops	= &ich_pata_ops,
-	},
-	[ich_pata_100] = {
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &ich_pata_ops,
-	},
-	[ich_pata_100_nomwdma1] = {
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2_ONLY,
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &ich_pata_ops,
-	},
-	[ich5_sata] = {
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[ich6_sata] = {
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[ich6m_sata] = {
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[ich8_sata] = {
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[ich8_2port_sata] = {
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[tolapai_sata] = {
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[ich8m_apple_sata] = {
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-	[piix_pata_vmw] = {
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &piix_vmw_ops,
-	},
-};
-
 static struct pci_bits piix_enable_bits[] = {
 	{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
 	{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
@@ -1169,6 +991,152 @@ static u8 piix_vmw_bmdma_status(struct a
 	return ata_bmdma_status(ap) & ~ATA_DMA_ERR;
 }
 
+static struct scsi_host_template piix_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations piix_sata_ops = {
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_irq_check		= piix_irq_check,
+};
+
+static struct ata_port_operations piix_pata_ops = {
+	.inherits		= &piix_sata_ops,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.prereset		= piix_pata_prereset,
+};
+
+static struct ata_port_operations piix_vmw_ops = {
+	.inherits		= &piix_pata_ops,
+	.bmdma_status		= piix_vmw_bmdma_status,
+};
+
+static struct ata_port_operations ich_pata_ops = {
+	.inherits		= &piix_pata_ops,
+	.cable_detect		= ich_pata_cable_detect,
+	.set_dmamode		= ich_set_dmamode,
+};
+
+static struct device_attribute *piix_sidpr_shost_attrs[] = {
+	&dev_attr_link_power_management_policy,
+	NULL
+};
+
+static struct scsi_host_template piix_sidpr_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+	.shost_attrs		= piix_sidpr_shost_attrs,
+};
+
+static struct ata_port_operations piix_sidpr_sata_ops = {
+	.inherits		= &piix_sata_ops,
+	.hardreset		= sata_std_hardreset,
+	.scr_read		= piix_sidpr_scr_read,
+	.scr_write		= piix_sidpr_scr_write,
+	.set_lpm		= piix_sidpr_set_lpm,
+};
+
+static struct ata_port_info piix_port_info[] = {
+	[piix_pata_mwdma] = {	/* PIIX3 MWDMA only */
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
+		.port_ops	= &piix_pata_ops,
+	},
+	[piix_pata_33] = {	/* PIIX4 at 33MHz */
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &piix_pata_ops,
+	},
+	[ich_pata_33] = {	/* ICH0 - ICH at 33Mhz*/
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &ich_pata_ops,
+	},
+	[ich_pata_66] = {	/* ICH controllers up to 66MHz */
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
+		.udma_mask	= ATA_UDMA4,
+		.port_ops	= &ich_pata_ops,
+	},
+	[ich_pata_100] = {
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+	[ich_pata_100_nomwdma1] = {
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+	[ich5_sata] = {
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[ich6_sata] = {
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[ich6m_sata] = {
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[ich8_sata] = {
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[ich8_2port_sata] = {
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[tolapai_sata] = {
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[ich8m_apple_sata] = {
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+	[piix_pata_vmw] = {
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &piix_vmw_ops,
+	},
+};
+
 #define AHCI_PCI_BAR 5
 #define AHCI_GLOBAL_CTL 0x04
 #define AHCI_ENABLE (1 << 31)
@@ -1602,6 +1570,17 @@ static void piix_remove_one(struct pci_d
 	ata_pci_remove_one(pdev);
 }
 
+static struct pci_driver piix_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= piix_pci_tbl,
+	.probe			= piix_init_one,
+	.remove			= piix_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= piix_pci_device_suspend,
+	.resume			= piix_pci_device_resume,
+#endif
+};
+
 static int __init piix_init(void)
 {
 	int rc;
