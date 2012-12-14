Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2LNOue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:50:34 -0500
Received: from havoc.gtf.org ([69.61.125.42]:54448 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2LNOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:50:31 -0500
Date: Fri, 14 Dec 2012 09:50:30 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 3.8
Message-ID: <20121214145030.GA15315@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull 72d5f2da2c3717f1be484d97e35d67dde0efb4c0 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

 drivers/ata/ahci_platform.c    |  46 ++---
 drivers/ata/ata_piix.c         | 444 ++++++++++++++++++++---------------------
 drivers/ata/libahci.c          |   2 +-
 drivers/ata/libata-acpi.c      |   4 +
 drivers/ata/libata-core.c      |  31 ++-
 drivers/ata/libata-eh.c        |   1 +
 drivers/ata/libata-scsi.c      |   6 +-
 drivers/ata/pata_arasan_cf.c   |   7 +-
 drivers/ata/pata_cmd64x.c      |   6 +-
 drivers/ata/pata_cs5536.c      |  32 ++-
 drivers/ata/pata_ep93xx.c      |   6 +-
 drivers/ata/pata_imx.c         |   2 +-
 drivers/ata/pata_ixp4xx_cf.c   |  11 +-
 drivers/ata/pata_mpc52xx.c     |  17 +-
 drivers/ata/pata_of_platform.c |   8 +-
 drivers/ata/pata_palmld.c      |   4 +-
 drivers/ata/pata_platform.c    |  24 +--
 drivers/ata/pata_rdc.c         |   3 -
 drivers/ata/sata_dwc_460ex.c   |   1 +
 drivers/ata/sata_highbank.c    |  14 +-
 drivers/ata/sata_inic162x.c    |   2 -
 drivers/ata/sata_promise.c     |  15 +-
 drivers/ata/sata_sil24.c       |   4 -
 drivers/ata/sata_sx4.c         |  14 +-
 include/linux/ata_platform.h   |   2 -
 include/linux/libata.h         |   5 +
 26 files changed, 355 insertions(+), 356 deletions(-)
 mode change 100755 => 100644 drivers/ata/sata_dwc_460ex.c

Aaron Lu (2):
      libata: restore acpi disable functionality
      libata: set dma_mode to 0xff in reset

Bartlomiej Zolnierkiewicz (1):
      ata_piix: re-order code and remove prototypes

Brian Norris (16):
      ahci_platform: enable hotplug unbinding
      ahci_platform: convert to module_platform_driver
      ahci_platform: perform platform exit in host_stop() hook
      libata: implement ata_platform_remove_one()
      ahci_platform: utilize common ata_platform_remove_one()
      pata_ixp4xx_cf: utilize common ata_platform_remove_one()
      pata_mpc52xx: utilize common ata_platform_remove_one()
      pata_of_platform: utilize common ata_platform_remove_one()
      pata_platform: utilize common ata_platform_remove_one()
      pata_platform: remove unused remove function
      pata_palmld: utilize common ata_platform_remove_one()
      sata_highbank: utilize common ata_platform_remove_one()
      pata_octeon_cf: perform host detach, removal on exit
      libata: use pci_get_drvdata() helper
      pata_of_platform: fix compile error
      ahci_platform: make structs static

Christian Gmeiner (1):
      pata_cs5536: add quirk for broken udma

Jeff Garzik (3):
      Revert "libata: check SATA_SETTINGS log with HW Feature Ctrl"
      Revert "pata_octeon_cf: perform host detach, removal on exit"
      sata_dwc_460ex: remove file exec bit (chmod 0755 -> 0644)

Joe Perches (1):
      ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error

Olaf Hering (1):
      ata_piix: reenable MS Virtual PC guests

Sergei Shtylyov (3):
      sata_sx4: pdc20621_{ata|host}_sg() do not need 'tf' parameter
      sata_highbank: use ATA_BUSY
      pata_arasan_cf: declare/use more local variables in arasan_cf_dma_start()

Shane Huang (1):
      libata: check SATA_SETTINGS log with HW Feature Ctrl

Wei Yongjun (6):
      pata_rdc: remove unused variable in rdc_init_one()
      sata_inic162x: remove unused variable in inic_scr_read()
      sata_sil24: remove unused variable from sata_sil24.c
      ARM: ep93xx: convert ata_<foo>_printk() to ata_<foo>_<level>()
      pata_imx: convert ata_dev_printk() to ata_dev_info()
      ahci: convert ata_link_printk() to ata_link_warn()

Xiaotian Feng (1):
      [libata] fix Null pointer dereference on disk error

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index b7078af..1cc467b 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -25,6 +25,8 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
+static void ahci_host_stop(struct ata_host *host);
+
 enum ahci_type {
 	AHCI,		/* standard platform ahci */
 	IMX53_AHCI,	/* ahci on i.mx53 */
@@ -47,6 +49,15 @@ static struct platform_device_id ahci_devtype[] = {
 };
 MODULE_DEVICE_TABLE(platform, ahci_devtype);
 
+static struct ata_port_operations ahci_platform_ops = {
+	.inherits	= &ahci_ops,
+	.host_stop	= ahci_host_stop,
+};
+
+static struct ata_port_operations ahci_platform_retry_srst_ops = {
+	.inherits	= &ahci_pmp_retry_srst_ops,
+	.host_stop	= ahci_host_stop,
+};
 
 static const struct ata_port_info ahci_port_info[] = {
 	/* by features */
@@ -54,20 +65,20 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_platform_ops,
 	},
 	[IMX53_AHCI] = {
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_pmp_retry_srst_ops,
+		.port_ops	= &ahci_platform_retry_srst_ops,
 	},
 	[STRICT_AHCI] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_DELAY_ENGINE),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_platform_ops,
 	},
 };
 
@@ -75,7 +86,7 @@ static struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT("ahci_platform"),
 };
 
-static int __init ahci_probe(struct platform_device *pdev)
+static int __devinit ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
@@ -218,15 +229,12 @@ free_clk:
 	return rc;
 }
 
-static int __devexit ahci_remove(struct platform_device *pdev)
+static void ahci_host_stop(struct ata_host *host)
 {
-	struct device *dev = &pdev->dev;
+	struct device *dev = host->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
-	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 
-	ata_host_detach(host);
-
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
 
@@ -234,8 +242,6 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
 	}
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -317,7 +323,7 @@ disable_unprepare_clk:
 }
 #endif
 
-SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
+static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
 
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,spear-ahci", },
@@ -326,7 +332,8 @@ static const struct of_device_id ahci_of_match[] = {
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
 static struct platform_driver ahci_driver = {
-	.remove = __devexit_p(ahci_remove),
+	.probe = ahci_probe,
+	.remove = ata_platform_remove_one,
 	.driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
@@ -335,18 +342,7 @@ static struct platform_driver ahci_driver = {
 	},
 	.id_table	= ahci_devtype,
 };
-
-static int __init ahci_init(void)
-{
-	return platform_driver_probe(&ahci_driver, ahci_probe);
-}
-module_init(ahci_init);
-
-static void __exit ahci_exit(void)
-{
-	platform_driver_unregister(&ahci_driver);
-}
-module_exit(ahci_exit);
+module_platform_driver(ahci_driver);
 
 MODULE_DESCRIPTION("AHCI SATA platform driver");
 MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ef773e1..acffcf0 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -164,28 +164,6 @@ struct piix_host_priv {
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
-static int piix_port_start(struct ata_port *ap);
-#ifdef CONFIG_PM
-static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int piix_pci_device_resume(struct pci_dev *pdev);
-#endif
-
 static unsigned int in_module_init = 1;
 
 static const struct pci_device_id piix_pci_tbl[] = {
@@ -342,64 +320,6 @@ static const struct pci_device_id piix_pci_tbl[] = {
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
-	.port_start		= piix_port_start,
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
@@ -504,147 +424,6 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8_sata_snb]		= &ich8_map_db,
 };
 
-static struct ata_port_info piix_port_info[] = {
-	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.port_ops	= &piix_pata_ops,
-	},
-
-	[piix_pata_33] =	/* PIIX4 at 33MHz */
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &piix_pata_ops,
-	},
-
-	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
-		.udma_mask	= ATA_UDMA4,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich_pata_100] =
-	{
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich_pata_100_nomwdma1] =
-	{
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2_ONLY,
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &ich_pata_ops,
-	},
-
-	[ich5_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich6_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich6m_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich8_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich8_2port_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[tolapai_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[ich8m_apple_sata] =
-	{
-		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-	[piix_pata_vmw] =
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.udma_mask	= ATA_UDMA2,
-		.port_ops	= &piix_vmw_ops,
-	},
-
-	/*
-	 * some Sandybridge chipsets have broken 32 mode up to now,
-	 * see https://bugzilla.kernel.org/show_bug.cgi?id=40592
-	 */
-	[ich8_sata_snb] =
-	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &piix_sata_ops,
-	},
-
-};
-
 static struct pci_bits piix_enable_bits[] = {
 	{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
 	{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
@@ -1261,6 +1040,193 @@ static u8 piix_vmw_bmdma_status(struct ata_port *ap)
 	return ata_bmdma_status(ap) & ~ATA_DMA_ERR;
 }
 
+static struct scsi_host_template piix_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations piix_sata_ops = {
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_irq_check		= piix_irq_check,
+	.port_start		= piix_port_start,
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
+	[piix_pata_mwdma] =	/* PIIX3 MWDMA only */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.port_ops	= &piix_pata_ops,
+	},
+
+	[piix_pata_33] =	/* PIIX4 at 33MHz */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &piix_pata_ops,
+	},
+
+	[ich_pata_33] =		/* ICH0 - ICH at 33Mhz*/
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_66] =		/* ICH controllers up to 66MHz */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
+		.udma_mask	= ATA_UDMA4,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_100] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_100_nomwdma1] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich5_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich6_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich6m_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8_2port_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[tolapai_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8m_apple_sata] =
+	{
+		.flags		= PIIX_SATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[piix_pata_vmw] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &piix_vmw_ops,
+	},
+
+	/*
+	 * some Sandybridge chipsets have broken 32 mode up to now,
+	 * see https://bugzilla.kernel.org/show_bug.cgi?id=40592
+	 */
+	[ich8_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+};
+
 #define AHCI_PCI_BAR 5
 #define AHCI_GLOBAL_CTL 0x04
 #define AHCI_ENABLE (1 << 31)
@@ -1585,12 +1551,31 @@ static void piix_ignore_devices_quirk(struct ata_host *host)
 		},
 		{ }	/* terminate list */
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(ignore_hyperv);
+	static const struct dmi_system_id allow_virtual_pc[] = {
+		{
+			/* In MS Virtual PC guests the DMI ident is nearly
+			 * identical to a Hyper-V guest. One difference is the
+			 * product version which is used here to identify
+			 * a Virtual PC guest. This entry allows ata_piix to
+			 * drive the emulated hardware.
+			 */
+			.ident = "MS Virtual PC 2007",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR,
+						"Microsoft Corporation"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+				DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
+			},
+		},
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *ignore = dmi_first_match(ignore_hyperv);
+	const struct dmi_system_id *allow = dmi_first_match(allow_virtual_pc);
 
-	if (dmi && prefer_ms_hyperv) {
+	if (ignore && !allow && prefer_ms_hyperv) {
 		host->flags |= ATA_HOST_IGNORE_ATA;
 		dev_info(host->dev, "%s detected, ATA device ignore set\n",
-			dmi->ident);
+			ignore->ident);
 	}
 #endif
 }
@@ -1727,6 +1712,17 @@ static void piix_remove_one(struct pci_dev *pdev)
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
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 4201e53..320712a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1384,7 +1384,7 @@ int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int *class,
 	if (rc == -EIO) {
 		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
 		if (irq_sts & PORT_IRQ_BAD_PMP) {
-			ata_link_printk(link, KERN_WARNING,
+			ata_link_warn(link,
 					"applying PMP SRST workaround "
 					"and retrying\n");
 			rc = ahci_do_softreset(link, class, 0, deadline,
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 5b0ba3f..ef01ac0 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -76,6 +76,9 @@ acpi_handle ata_dev_acpi_handle(struct ata_device *dev)
 	acpi_integer adr;
 	struct ata_port *ap = dev->link->ap;
 
+	if (dev->flags & ATA_DFLAG_ACPI_DISABLED)
+		return NULL;
+
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
 			adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
@@ -945,6 +948,7 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 		return rc;
 	}
 
+	dev->flags |= ATA_DFLAG_ACPI_DISABLED;
 	ata_dev_warn(dev, "ACPI: failed the second time, disabled\n");
 
 	/* We can safely continue if no _GTF command has been executed
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f46fbd3..9e8b99a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -67,6 +67,7 @@
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
 #include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -2560,6 +2561,7 @@ int ata_bus_probe(struct ata_port *ap)
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
@@ -6286,8 +6288,7 @@ void ata_host_detach(struct ata_host *host)
  */
 void ata_pci_remove_one(struct pci_dev *pdev)
 {
-	struct device *dev = &pdev->dev;
-	struct ata_host *host = dev_get_drvdata(dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
 
 	ata_host_detach(host);
 }
@@ -6356,7 +6357,7 @@ int ata_pci_device_do_resume(struct pci_dev *pdev)
 
 int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
 	int rc = 0;
 
 	rc = ata_host_suspend(host, mesg);
@@ -6370,7 +6371,7 @@ int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 
 int ata_pci_device_resume(struct pci_dev *pdev)
 {
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
@@ -6382,6 +6383,26 @@ int ata_pci_device_resume(struct pci_dev *pdev)
 
 #endif /* CONFIG_PCI */
 
+/**
+ *	ata_platform_remove_one - Platform layer callback for device removal
+ *	@pdev: Platform device that was removed
+ *
+ *	Platform layer indicates to libata via this hook that hot-unplug or
+ *	module unload event has occurred.  Detach all ports.  Resource
+ *	release is handled via devres.
+ *
+ *	LOCKING:
+ *	Inherited from platform layer (may sleep).
+ */
+int ata_platform_remove_one(struct platform_device *pdev)
+{
+	struct ata_host *host = platform_get_drvdata(pdev);
+
+	ata_host_detach(host);
+
+	return 0;
+}
+
 static int __init ata_parse_force_one(char **cur,
 				      struct ata_force_ent *force_ent,
 				      const char **reason)
@@ -6877,6 +6898,8 @@ EXPORT_SYMBOL_GPL(ata_pci_device_resume);
 #endif /* CONFIG_PM */
 #endif /* CONFIG_PCI */
 
+EXPORT_SYMBOL_GPL(ata_platform_remove_one);
+
 EXPORT_SYMBOL_GPL(__ata_ehi_push_desc);
 EXPORT_SYMBOL_GPL(ata_ehi_push_desc);
 EXPORT_SYMBOL_GPL(ata_ehi_clear_desc);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e60437c..bf039b0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2657,6 +2657,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a6df6a3..7c337e7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -309,7 +309,8 @@ ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
 
-	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+	if (atadev && ap->ops->sw_activity_show &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
 	return -EINVAL;
 }
@@ -324,7 +325,8 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 	enum sw_activity val;
 	int rc;
 
-	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+	if (atadev && ap->ops->sw_activity_store &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
 		val = simple_strtoul(buf, NULL, 0);
 		switch (val) {
 		case OFF: case BLINK_ON: case BLINK_OFF:
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 371fd2c..9764e80 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -674,13 +674,16 @@ void arasan_cf_error_handler(struct ata_port *ap)
 
 static void arasan_cf_dma_start(struct arasan_cf_dev *acdev)
 {
+	struct ata_queued_cmd *qc = acdev->qc;
+	struct ata_port *ap = qc->ap;
+	struct ata_taskfile *tf = &qc->tf;
 	u32 xfer_ctr = readl(acdev->vbase + XFER_CTR) & ~XFER_DIR_MASK;
-	u32 write = acdev->qc->tf.flags & ATA_TFLAG_WRITE;
+	u32 write = tf->flags & ATA_TFLAG_WRITE;
 
 	xfer_ctr |= write ? XFER_WRITE : XFER_READ;
 	writel(xfer_ctr, acdev->vbase + XFER_CTR);
 
-	acdev->qc->ap->ops->sff_exec_command(acdev->qc->ap, &acdev->qc->tf);
+	ap->ops->sff_exec_command(ap, tf);
 	ata_sff_queue_work(&acdev->work);
 }
 
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 7ba0141..2949cfc 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -474,14 +474,14 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* check for enabled ports */
 	pci_read_config_byte(pdev, CNTRL, &reg);
 	if (!port_ok)
-		dev_printk(KERN_NOTICE, &pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
+		dev_notice(&pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
 	if (port_ok && cntrl_ch0_ok && !(reg & CNTRL_CH0)) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Primary port is disabled\n");
+		dev_notice(&pdev->dev, "Primary port is disabled\n");
 		ppi[0] = &ata_dummy_port_info;
 
 	}
 	if (port_ok && !(reg & CNTRL_CH1)) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Secondary port is disabled\n");
+		dev_notice(&pdev->dev, "Secondary port is disabled\n");
 		ppi[1] = &ata_dummy_port_info;
 	}
 
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index dec1b6c..0448860 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/libata.h>
 #include <scsi/scsi_host.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86_32
 #include <asm/msr.h>
@@ -80,6 +81,21 @@ enum {
 	IDE_ETC_UDMA_MASK	= 0xc0,
 };
 
+/* Some Bachmann OT200 devices have a non working UDMA support due a
+ * missing resistor.
+ */
+static const struct dmi_system_id udma_quirk_dmi_table[] = {
+	{
+		.ident = "Bachmann electronic OT200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Bachmann electronic"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OT200"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1")
+		},
+	},
+	{ }
+};
+
 static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
@@ -242,9 +258,23 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &cs5536_port_ops,
 	};
 
-	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+	static const struct ata_port_info no_udma_info = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO4,
+		.port_ops = &cs5536_port_ops,
+	};
+
+
+	const struct ata_port_info *ppi[2];
 	u32 cfg;
 
+	if (dmi_check_system(udma_quirk_dmi_table))
+		ppi[0] = &no_udma_info;
+	else
+		ppi[0] = &info;
+
+	ppi[1] = &ata_dummy_port_info;
+
 	if (use_msr)
 		printk(KERN_ERR DRV_NAME ": Using MSR regs instead of PCI\n");
 
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index e056406..3982cef 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -822,8 +822,7 @@ static int ep93xx_pata_softreset(struct ata_link *al, unsigned int *classes,
 	rc = ep93xx_pata_bus_softreset(ap, devmask, deadline);
 	/* if link is ocuppied, -ENODEV too is an error */
 	if (rc && (rc != -ENODEV || sata_scr_valid(al))) {
-		ata_link_printk(al, KERN_ERR, "SRST failed (errno=%d)\n",
-				rc);
+		ata_link_err(al, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
@@ -857,8 +856,7 @@ static void ep93xx_pata_drain_fifo(struct ata_queued_cmd *qc)
 
 	/* Can become DEBUG later */
 	if (count)
-		ata_port_printk(ap, KERN_DEBUG,
-				"drained %d bytes to clear DRQ.\n", count);
+		ata_port_dbg(ap, "drained %d bytes to clear DRQ.\n", count);
 
 }
 
diff --git a/drivers/ata/pata_imx.c b/drivers/ata/pata_imx.c
index 87bb05b..7d40b52 100644
--- a/drivers/ata/pata_imx.c
+++ b/drivers/ata/pata_imx.c
@@ -60,7 +60,7 @@ static int pata_imx_set_mode(struct ata_link *link, struct ata_device **unused)
 			val &= ~PATA_IMX_ATA_CTRL_IORDY_EN;
 		__raw_writel(val, priv->host_regs + PATA_IMX_ATA_CONTROL);
 
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 	}
 	return 0;
 }
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index badb178..0566e67 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -187,22 +187,13 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	return ata_host_activate(host, irq, ata_sff_interrupt, 0, &ixp4xx_sht);
 }
 
-static __devexit int ixp4xx_pata_remove(struct platform_device *dev)
-{
-	struct ata_host *host = platform_get_drvdata(dev);
-
-	ata_host_detach(host);
-
-	return 0;
-}
-
 static struct platform_driver ixp4xx_pata_platform_driver = {
 	.driver	 = {
 		.name   = DRV_NAME,
 		.owner  = THIS_MODULE,
 	},
 	.probe		= ixp4xx_pata_probe,
-	.remove		= __devexit_p(ixp4xx_pata_remove),
+	.remove		= ata_platform_remove_one,
 };
 
 module_platform_driver(ixp4xx_pata_platform_driver);
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index d2c102f..ec67f54 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -663,18 +663,6 @@ mpc52xx_ata_init_one(struct device *dev, struct mpc52xx_ata_priv *priv,
 				 &mpc52xx_ata_sht);
 }
 
-static struct mpc52xx_ata_priv *
-mpc52xx_ata_remove_one(struct device *dev)
-{
-	struct ata_host *host = dev_get_drvdata(dev);
-	struct mpc52xx_ata_priv *priv = host->private_data;
-
-	ata_host_detach(host);
-
-	return priv;
-}
-
-
 /* ======================================================================== */
 /* OF Platform driver                                                       */
 /* ======================================================================== */
@@ -815,11 +803,12 @@ mpc52xx_ata_probe(struct platform_device *op)
 static int
 mpc52xx_ata_remove(struct platform_device *op)
 {
-	struct mpc52xx_ata_priv *priv;
+	struct ata_host *host = platform_get_drvdata(op);
+	struct mpc52xx_ata_priv *priv = host->private_data;
 	int task_irq;
 
 	/* Deregister the ATA interface */
-	priv = mpc52xx_ata_remove_one(&op->dev);
+	ata_platform_remove_one(op);
 
 	/* Clean up DMA */
 	task_irq = bcom_get_task_irq(priv->dmatsk);
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 1654dc2..e5b234c 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -14,6 +14,7 @@
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/ata_platform.h>
+#include <linux/libata.h>
 
 static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 {
@@ -76,11 +77,6 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 				     reg_shift, pio_mask);
 }
 
-static int __devexit pata_of_platform_remove(struct platform_device *ofdev)
-{
-	return __pata_platform_remove(&ofdev->dev);
-}
-
 static struct of_device_id pata_of_platform_match[] = {
 	{ .compatible = "ata-generic", },
 	{ .compatible = "electra-ide", },
@@ -95,7 +91,7 @@ static struct platform_driver pata_of_platform_driver = {
 		.of_match_table = pata_of_platform_match,
 	},
 	.probe		= pata_of_platform_probe,
-	.remove		= __devexit_p(pata_of_platform_remove),
+	.remove		= ata_platform_remove_one,
 };
 
 module_platform_driver(pata_of_platform_driver);
diff --git a/drivers/ata/pata_palmld.c b/drivers/ata/pata_palmld.c
index 5ff31b6..f9f79fc 100644
--- a/drivers/ata/pata_palmld.c
+++ b/drivers/ata/pata_palmld.c
@@ -111,9 +111,7 @@ err1:
 
 static __devexit int palmld_pata_remove(struct platform_device *dev)
 {
-	struct ata_host *host = platform_get_drvdata(dev);
-
-	ata_host_detach(host);
+	ata_platform_remove_one(dev);
 
 	/* power down the HDD */
 	gpio_set_value(GPIO_NR_PALMLD_IDE_PWEN, 0);
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index f1848ae..f4372d0 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -178,23 +178,6 @@ int __devinit __pata_platform_probe(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(__pata_platform_probe);
 
-/**
- *	__pata_platform_remove		-	unplug a platform interface
- *	@dev: device
- *
- *	A platform bus ATA device has been unplugged. Perform the needed
- *	cleanup. Also called on module unload for any active devices.
- */
-int __pata_platform_remove(struct device *dev)
-{
-	struct ata_host *host = dev_get_drvdata(dev);
-
-	ata_host_detach(host);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__pata_platform_remove);
-
 static int __devinit pata_platform_probe(struct platform_device *pdev)
 {
 	struct resource *io_res;
@@ -242,14 +225,9 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 				     pio_mask);
 }
 
-static int __devexit pata_platform_remove(struct platform_device *pdev)
-{
-	return __pata_platform_remove(&pdev->dev);
-}
-
 static struct platform_driver pata_platform_driver = {
 	.probe		= pata_platform_probe,
-	.remove		= __devexit_p(pata_platform_remove),
+	.remove		= ata_platform_remove_one,
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 32a3499..e71f998 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -327,7 +327,6 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
-	unsigned long port_flags;
 	struct ata_host *host;
 	struct rdc_host_priv *hpriv;
 	int rc;
@@ -337,8 +336,6 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 	port_info[0] = rdc_port_info;
 	port_info[1] = rdc_port_info;
 
-	port_flags = port_info[0].flags;
-
 	/* enable device and prepare host */
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
old mode 100755
new mode 100644
index 937aeb3..2e39173
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -43,6 +43,7 @@
 /* These two are defined in "libata.h" */
 #undef	DRV_NAME
 #undef	DRV_VERSION
+
 #define DRV_NAME        "sata-dwc"
 #define DRV_VERSION     "1.3"
 
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 400bf1c..dc7d78e 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -213,7 +213,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(link->device, &tf);
-	tf.command = 0x80;
+	tf.command = ATA_BUSY;
 	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 	do {
@@ -368,16 +368,6 @@ err0:
 	return rc;
 }
 
-static int __devexit ahci_highbank_remove(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct ata_host *host = dev_get_drvdata(dev);
-
-	ata_host_detach(host);
-
-	return 0;
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int ahci_highbank_suspend(struct device *dev)
 {
@@ -432,7 +422,7 @@ SIMPLE_DEV_PM_OPS(ahci_highbank_pm_ops,
 		  ahci_highbank_suspend, ahci_highbank_resume);
 
 static struct platform_driver ahci_highbank_driver = {
-        .remove = __devexit_p(ahci_highbank_remove),
+	.remove = ata_platform_remove_one,
         .driver = {
                 .name = "highbank-ahci",
                 .owner = THIS_MODULE,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index dc35f4d..1e6827c 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -273,12 +273,10 @@ static void inic_reset_port(void __iomem *port_base)
 static int inic_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val)
 {
 	void __iomem *scr_addr = inic_port_base(link->ap) + PORT_SCR;
-	void __iomem *addr;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
 		return -EINVAL;
 
-	addr = scr_addr + scr_map[sc_reg] * 4;
 	*val = readl(scr_addr + scr_map[sc_reg] * 4);
 
 	/* this controller has stuck DIAG.N, ignore it */
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 489c817..fb0dd87 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -147,6 +147,10 @@ struct pdc_port_priv {
 	dma_addr_t		pkt_dma;
 };
 
+struct pdc_host_priv {
+	spinlock_t hard_reset_lock;
+};
+
 static int pdc_sata_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int pdc_sata_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -801,9 +805,10 @@ static void pdc_hard_reset_port(struct ata_port *ap)
 	void __iomem *host_mmio = ap->host->iomap[PDC_MMIO_BAR];
 	void __iomem *pcictl_b1_mmio = host_mmio + PDC_PCI_CTL + 1;
 	unsigned int ata_no = pdc_ata_port_to_ata_no(ap);
+	struct pdc_host_priv *hpriv = ap->host->private_data;
 	u8 tmp;
 
-	spin_lock(&ap->host->lock);
+	spin_lock(&hpriv->hard_reset_lock);
 
 	tmp = readb(pcictl_b1_mmio);
 	tmp &= ~(0x10 << ata_no);
@@ -814,7 +819,7 @@ static void pdc_hard_reset_port(struct ata_port *ap)
 	writeb(tmp, pcictl_b1_mmio);
 	readb(pcictl_b1_mmio); /* flush */
 
-	spin_unlock(&ap->host->lock);
+	spin_unlock(&hpriv->hard_reset_lock);
 }
 
 static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
@@ -1182,6 +1187,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 	const struct ata_port_info *pi = &pdc_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[PDC_MAX_PORTS];
 	struct ata_host *host;
+	struct pdc_host_priv *hpriv;
 	void __iomem *host_mmio;
 	int n_ports, i, rc;
 	int is_sataii_tx4;
@@ -1218,6 +1224,11 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "failed to allocate host\n");
 		return -ENOMEM;
 	}
+	hpriv = devm_kzalloc(&pdev->dev, sizeof *hpriv, GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+	spin_lock_init(&hpriv->hard_reset_lock);
+	host->private_data = hpriv;
 	host->iomap = pcim_iomap_table(pdev);
 
 	is_sataii_tx4 = pdc_is_sataii_tx4(pi->flags);
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index a5f2a56..59f0d63 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -506,8 +506,6 @@ static int sil24_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val)
 	void __iomem *scr_addr = sil24_port_base(link->ap) + PORT_SCONTROL;
 
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
-		void __iomem *addr;
-		addr = scr_addr + sil24_scr_map[sc_reg] * 4;
 		*val = readl(scr_addr + sil24_scr_map[sc_reg] * 4);
 		return 0;
 	}
@@ -519,8 +517,6 @@ static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val)
 	void __iomem *scr_addr = sil24_port_base(link->ap) + PORT_SCONTROL;
 
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
-		void __iomem *addr;
-		addr = scr_addr + sil24_scr_map[sc_reg] * 4;
 		writel(val, scr_addr + sil24_scr_map[sc_reg] * 4);
 		return 0;
 	}
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 1226055..7b7127a 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -315,9 +315,8 @@ static int pdc_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
-				   unsigned int portno,
-					   unsigned int total_len)
+static inline void pdc20621_ata_sg(u8 *buf, unsigned int portno,
+				   unsigned int total_len)
 {
 	u32 addr;
 	unsigned int dw = PDC_DIMM_APKT_PRD >> 2;
@@ -337,9 +336,8 @@ static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 		buf32[dw], buf32[dw + 1]);
 }
 
-static inline void pdc20621_host_sg(struct ata_taskfile *tf, u8 *buf,
-				    unsigned int portno,
-					    unsigned int total_len)
+static inline void pdc20621_host_sg(u8 *buf, unsigned int portno,
+				    unsigned int total_len)
 {
 	u32 addr;
 	unsigned int dw = PDC_DIMM_HPKT_PRD >> 2;
@@ -486,10 +484,10 @@ static void pdc20621_dma_prep(struct ata_queued_cmd *qc)
 	/*
 	 * Build ATA, host DMA packets
 	 */
-	pdc20621_host_sg(&qc->tf, &pp->dimm_buf[0], portno, total_len);
+	pdc20621_host_sg(&pp->dimm_buf[0], portno, total_len);
 	pdc20621_host_pkt(&qc->tf, &pp->dimm_buf[0], portno);
 
-	pdc20621_ata_sg(&qc->tf, &pp->dimm_buf[0], portno, total_len);
+	pdc20621_ata_sg(&pp->dimm_buf[0], portno, total_len);
 	i = pdc20621_ata_pkt(&qc->tf, qc->dev->devno, &pp->dimm_buf[0], portno);
 
 	if (qc->tf.flags & ATA_TFLAG_LBA48)
diff --git a/include/linux/ata_platform.h b/include/linux/ata_platform.h
index b856a2a..fe99896 100644
--- a/include/linux/ata_platform.h
+++ b/include/linux/ata_platform.h
@@ -22,8 +22,6 @@ extern int __devinit __pata_platform_probe(struct device *dev,
 					   unsigned int ioport_shift,
 					   int __pio_mask);
 
-extern int __devexit __pata_platform_remove(struct device *dev);
-
 /*
  * Marvell SATA private data
  */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 77eeeda..83ba0ab 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -163,6 +163,7 @@ enum {
 
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
 	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
+	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -1114,6 +1115,10 @@ extern int ata_pci_device_resume(struct pci_dev *pdev);
 #endif /* CONFIG_PM */
 #endif /* CONFIG_PCI */
 
+struct platform_device;
+
+extern int ata_platform_remove_one(struct platform_device *pdev);
+
 /*
  * ACPI - drivers/ata/libata-acpi.c
  */
