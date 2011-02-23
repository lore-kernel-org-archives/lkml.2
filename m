Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1BWKRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:17:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58947 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1BWKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=KswAgniSeYqbyuhIkrpfVZaMU6ajya3V+FinR65q1EG3zk3H9THp1mBtAxfLiEhheA
         E8xPU6BCodlcQZHR8rQjEBUiKTR86DE/DFrWFUN2/sKG3oG/4eJXq9ZvnvVhkVEshbdD
         2OcyeluyZu+yAPznLDO9KL9dXeaS7jg2bA38Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
Date: Wed, 23 Feb 2011 11:17:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <AANLkTi=jp+q9VYNJvko8P4ju_z86Rw5AxWY9O_reFDai@mail.gmail.com> <AANLkTikNjMZitsq-XxKMs9hN4Q238tATMpkOwQ_xLk89@mail.gmail.com>
In-Reply-To: <AANLkTikNjMZitsq-XxKMs9hN4Q238tATMpkOwQ_xLk89@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201102231117.04068.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> On Wed, Feb 23, 2011 at 9:45 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> 
> > As for increased memory usage -- we are talking here only about 10-20k
> > more.  If it really is a problem maybe ata_piix can be redesigned into
> > ata_generic-style manner so with the help of existing config options
> > we can keep code size / memory usage on a existing level.
> 
> s/ata_generic/pata_legacy/ of course -- what I have in mind is making
> Intel specific code depended on ATA_PIIX and adding new config option
> ATA_PIIXALIKE for generic code which would be selected by existing
> PATA_[EFAR,IT8213, OLDPIIX,RADISYS,RDC] options.

*Draft* patch against my current "piixalike" tree to just show the idea
and implement the final conversion stage (after optional code in ata_piix
gets tested and we are ready to remove separate drivers).

CONFIG_PATA_EFAR=y only:

before:
   text    data     bss     dec     hex filename
   1578    1008       8    2594     a22 drivers/ata/pata_efar.o

after:
   text    data     bss     dec     hex filename
   2778    1152       8    3938     f62 drivers/ata/ata_piix.o

so it pretty much solves code size / memory usage issue
(I'm counting in my other patch https://lkml.org/lkml/2011/2/9/150)..

---
 drivers/ata/Kconfig            |  102 +++---
 drivers/ata/Makefile           |    7 
 drivers/ata/ata_piix.c         |  652 ++++++++++++++++++-----------------------
 drivers/ata/ata_piix_efar.h    |   28 +
 drivers/ata/ata_piix_it8213.h  |   28 +
 drivers/ata/ata_piix_oldpiix.h |   49 +++
 6 files changed, 454 insertions(+), 412 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -167,9 +167,19 @@ if ATA_BMDMA
 
 comment "SATA SFF controllers with BMDMA"
 
+config ATA_PIIXALIKE
+	tristate "Intel PIIX-alikes PATA/SATA support"
+	depends on PCI
+	default y
+	help
+	  This option enables support needed for all Intel PIIX-alike
+	  Serial ATA and PATA host controllers.
+
+	  If unsure, say Y.
+
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on PCI
+	depends on ATA_PIIXALIKE
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
@@ -177,6 +187,51 @@ config ATA_PIIX
 
 	  If unsure, say N.
 
+config PATA_EFAR
+	bool "EFAR SLC90E66 support"
+	depends on ATA_PIIXALIKE
+	help
+	  This option enables support for the EFAR SLC90E66
+	  IDE controller found on some older machines.
+
+	  If unsure, say N.
+
+config PATA_IT8213
+	bool "IT8213 PATA support (Experimental)"
+	depends on ATA_PIIXALIKE && EXPERIMENTAL
+	help
+	  This option enables support for the ITE 821 PATA
+          controllers via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_OLDPIIX
+	bool "Intel PATA old PIIX support"
+	depends on ATA_PIIXALIKE
+	help
+	  This option enables support for early PIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_RADISYS
+	bool "RADISYS 82600 PATA support (Experimental)"
+	depends on ATA_PIIXALIKE && EXPERIMENTAL
+	help
+	  This option enables support for the RADISYS 82600
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_RDC
+	bool "RDC PATA support"
+	depends on ATA_PIIXALIKE
+	help
+	  This option enables basic support for the later RDC PATA controllers
+	  controllers via the new ATA layer. For the RDC 1010, you need to
+	  enable the IT821X driver instead.
+
+	  If unsure, say N.
+
 config SATA_DWC
 	tristate "DesignWare Cores SATA support"
 	depends on 460EX
@@ -372,15 +427,6 @@ config PATA_CYPRESS
 
 	  If unsure, say N.
 
-config PATA_EFAR
-	tristate "EFAR SLC90E66 support"
-	depends on PCI
-	help
-	  This option enables support for the EFAR SLC90E66
-	  IDE controller found on some older machines.
-
-	  If unsure, say N.
-
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on PCI
@@ -433,15 +479,6 @@ config PATA_ICSIDE
 	  interface card.  This is not required for ICS partition support.
 	  If you are unsure, say N to this.
 
-config PATA_IT8213
-	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the ITE 821 PATA
-          controllers via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
 	depends on PCI
@@ -518,14 +555,6 @@ config PATA_NS87415
 
 	  If unsure, say N.
 
-config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support"
-	depends on PCI
-	help
-	  This option enables support for early PIIX PATA support.
-
-	  If unsure, say N.
-
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -553,25 +582,6 @@ config PATA_PDC_OLD
 
 	  If unsure, say N.
 
-config PATA_RADISYS
-	tristate "RADISYS 82600 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the RADISYS 82600
-	  PATA controllers via the new ATA layer
-
-	  If unsure, say N.
-
-config PATA_RDC
-	tristate "RDC PATA support"
-	depends on PCI
-	help
-	  This option enables basic support for the later RDC PATA controllers
-	  controllers via the new ATA layer. For the RDC 1010, you need to
-	  enable the IT821X driver instead.
-
-	  If unsure, say N.
-
 config PATA_SC1200
 	tristate "SC1200 PATA support"
 	depends on PCI
Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
 
 # SFF SATA w/ BMDMA
-obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
+obj-$(CONFIG_ATA_PIIXALIKE)	+= ata_piix.o
 obj-$(CONFIG_SATA_MV)		+= sata_mv.o
 obj-$(CONFIG_SATA_NV)		+= sata_nv.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
@@ -40,13 +40,11 @@ obj-$(CONFIG_PATA_CS5530)	+= pata_cs5530
 obj-$(CONFIG_PATA_CS5535)	+= pata_cs5535.o
 obj-$(CONFIG_PATA_CS5536)	+= pata_cs5536.o
 obj-$(CONFIG_PATA_CYPRESS)	+= pata_cypress.o
-obj-$(CONFIG_PATA_EFAR)		+= pata_efar.o
 obj-$(CONFIG_PATA_HPT366)	+= pata_hpt366.o
 obj-$(CONFIG_PATA_HPT37X)	+= pata_hpt37x.o
 obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x2n.o
 obj-$(CONFIG_PATA_HPT3X3)	+= pata_hpt3x3.o
 obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
-obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
 obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
@@ -55,12 +53,9 @@ obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
-obj-$(CONFIG_PATA_OLDPIIX)	+= pata_oldpiix.o
 obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
 obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
-obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
-obj-$(CONFIG_PATA_RDC)		+= pata_rdc.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
 obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -169,6 +169,7 @@ enum piix_controller_ids {
 	it8213_pata,
 	oldpiix_pata,
 	radisys_pata,
+	rdc_pata,
 	ich5_sata,
 	ich6_sata,
 	ich6m_sata,
@@ -191,33 +192,10 @@ struct piix_host_priv {
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
-static int efar_pata_cable_detect(struct ata_port *ap);
-static int it8213_pata_cable_detect(struct ata_port *ap);
-static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc);
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
+#ifdef CONFIG_ATA_PIIX
 	/* Intel PIIX3 for the 430HX etc */
 	{ 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
 	/* VMware ICH4 */
@@ -261,23 +239,29 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100_nomwdma1 },
 	/* ICH8 Mobile PATA Controller */
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-
+#endif
+#ifdef CONFIG_PATA_EFAR
 	/* EFAR */
 	{ 0x1055, 0x9130, PCI_ANY_ID, PCI_ANY_ID, 0, 0, efar_pata },
-
+#endif
+#ifdef CONFIG_PATA_IT8213
 	/* IT8213 */
 	{ 0x1283, 0x8213, PCI_ANY_ID, PCI_ANY_ID, 0, 0, it8213_pata },
-
+#endif
+#ifdef CONFIG_PATA_RDC
 	/* RDC is ICH like */
-	{ 0x17F3, 0x1011, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-	{ 0x17F3, 0x1012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-
+	{ 0x17F3, 0x1011, PCI_ANY_ID, PCI_ANY_ID, 0, 0, rdc_pata },
+	{ 0x17F3, 0x1012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, rdc_pata },
+#endif
+#ifdef CONFIG_PATA_OLDPIIX
 	/* PIIXb (a.k.a. oldpiix) */
 	{ 0x8086, 0x1230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, oldpiix_pata },
-
+#endif
+#ifdef CONFIG_PATA_RADISYS
 	/* Radisys R82600 */
 	{ 0x1331, 0x8201, PCI_ANY_ID, PCI_ANY_ID, 0, 0, radisys_pata },
-
+#endif
+#ifdef CONFIG_ATA_PIIX
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
@@ -359,98 +343,10 @@ static const struct pci_device_id piix_p
 	/* SATA Controller IDE (PBG) */
 	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
-};
-
-static struct pci_driver piix_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= piix_pci_tbl,
-	.probe			= piix_init_one,
-	.remove			= piix_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= piix_pci_device_suspend,
-	.resume			= piix_pci_device_resume,
 #endif
 };
 
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
-static struct ata_port_operations efar_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.set_piomode		= piix_set_piomode,
-	.set_dmamode		= piix_set_dmamode,
-	.prereset		= piix_pata_prereset,
-	.cable_detect		= efar_pata_cable_detect,
-};
-
-static struct ata_port_operations it8213_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.set_piomode		= piix_set_piomode,
-	.set_dmamode		= ich_set_dmamode,
-	.prereset		= piix_pata_prereset,
-	.cable_detect		= it8213_pata_cable_detect,
-};
-
-static struct ata_port_operations oldpiix_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.qc_issue		= oldpiix_qc_issue,
-	.cable_detect		= ata_cable_40wire,
-	.set_piomode		= piix_set_piomode,
-	.set_dmamode		= piix_set_dmamode,
-	.prereset		= piix_pata_prereset,
-};
-
-static struct ata_port_operations radisys_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.qc_issue		= oldpiix_qc_issue,
-	.cable_detect		= ata_cable_unknown,
-	.set_piomode		= piix_set_piomode,
-	.set_dmamode		= piix_set_dmamode,
-};
-
+#ifdef CONFIG_ATA_PIIX
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -553,169 +449,7 @@ static const struct piix_map_db *piix_ma
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 };
-
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
-	[efar_pata] =
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA4,
-		.port_ops	= &efar_pata_ops,
-	},
-
-	[it8213_pata] =
-	{
-		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &it8213_pata_ops,
-	},
-
-	[oldpiix_pata] =
-	{
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_NO_SITRE,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.port_ops	= &oldpiix_pata_ops,
-	},
-
-	[radisys_pata] =
-	{
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_NO_SITRE |
-				  PIIX_FLAG_RADISYS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA24_ONLY,
-		.port_ops	= &radisys_pata_ops,
-	},
-};
+#endif
 
 static struct pci_bits piix_enable_bits[] = {
 	{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
@@ -728,6 +462,7 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
+#if defined(CONFIG_ATA_PIIX) || defined(CONFIG_PATA_RDC)
 struct ich_laptop {
 	u16 device;
 	u16 subvendor;
@@ -787,49 +522,12 @@ static int ich_pata_cable_detect(struct
 	}
 
 	/* check BIOS cable detect results */
-	mask = ap->port_no == 0 ? PIIX_80C_PRI : PIIX_80C_SEC;
-	if ((hpriv->saved_iocfg & mask) == 0)
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-/**
- *	efar_pata_cable_detect	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Perform cable detection for the EFAR ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int efar_pata_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-
-	pci_read_config_byte(pdev, 0x47, &tmp);
-	if (tmp & (2 >> ap->port_no))
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-/**
- *	it8213_pata_cable_detect	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Perform cable detection for the 8213 ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int it8213_pata_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-
-	pci_read_config_byte(pdev, 0x42, &tmp);
-	if (tmp & 2)	/* The initial docs are incorrect */
+	mask = ap->port_no == 0 ? PIIX_80C_PRI : PIIX_80C_SEC;
+	if ((hpriv->saved_iocfg & mask) == 0)
 		return ATA_CBL_PATA40;
 	return ATA_CBL_PATA80;
 }
+#endif
 
 /**
  *	piix_pata_prereset - prereset for PATA host controller
@@ -839,7 +537,8 @@ static int it8213_pata_cable_detect(stru
  *	LOCKING:
  *	None (inherited from caller).
  */
-static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
+static int __maybe_unused piix_pata_prereset(struct ata_link *link,
+					     unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -987,7 +686,8 @@ static void piix_set_timings(struct ata_
  *	None (inherited from caller).
  */
 
-static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void __maybe_unused piix_set_piomode(struct ata_port *ap,
+					    struct ata_device *adev)
 {
 	piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
 }
@@ -1092,7 +792,8 @@ static void do_pata_set_dmamode(struct a
  *	None (inherited from caller).
  */
 
-static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+static void __maybe_unused piix_set_dmamode(struct ata_port *ap,
+					    struct ata_device *adev)
 {
 	do_pata_set_dmamode(ap, adev, 0);
 }
@@ -1108,39 +809,13 @@ static void piix_set_dmamode(struct ata_
  *	None (inherited from caller).
  */
 
-static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+static void __maybe_unused ich_set_dmamode(struct ata_port *ap,
+					   struct ata_device *adev)
 {
 	do_pata_set_dmamode(ap, adev, 1);
 }
 
-/**
- *	oldpiix_qc_issue	-	command issue
- *	@qc: command pending
- *
- *	Called when the libata layer is about to issue a command. We wrap
- *	this interface so that we can load the correct ATA timings if
- *	necessary. Our logic also clears TIME0/TIME1 for the other device so
- *	that, even if we get this wrong, cycles to the other device will
- *	be made PIO0.
- */
-
-static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ata_device *adev = qc->dev;
-
-	if (adev != ap->private_data) {
-		/* UDMA timing is not shared */
-		if (adev->dma_mode < XFER_UDMA_0) {
-			if (adev->dma_mode)
-				piix_set_dmamode(ap, adev);
-			else if (adev->pio_mode)
-				piix_set_piomode(ap, adev);
-		}
-	}
-	return ata_bmdma_qc_issue(qc);
-}
-
+#ifdef CONFIG_ATA_PIIX
 /*
  * Serial ATA Index/Data Pair Superset Registers access
  *
@@ -1732,8 +1407,253 @@ static bool piix_broken_system_poweroff(
 
 	return false;
 }
+#else
+#define piix_pci_device_suspend ata_pci_device_suspend
+#define piix_pci_device_resume ata_pci_device_resume
+static inline bool piix_broken_system_poweroff(struct pci_dev *d) { return 0; }
+#endif
+
+static struct scsi_host_template piix_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+#ifdef CONFIG_ATA_PIIX
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
+static struct ata_port_operations ich_pata_ops = {
+	.inherits		= &piix_pata_ops,
+	.cable_detect		= ich_pata_cable_detect,
+	.set_dmamode		= ich_set_dmamode,
+};
+
+static struct ata_port_operations piix_vmw_ops = {
+	.inherits		= &piix_pata_ops,
+	.bmdma_status		= piix_vmw_bmdma_status,
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
+#endif
+
+#include "ata_piix_efar.h"
+#include "ata_piix_it8213.h"
+#include "ata_piix_oldpiix.h" /* covers Radisys */
+#ifdef CONFIG_PATA_RDC
+static struct ata_port_operations rdc_pata_ops = {
+	.inherits		= &ata_bmdma32_port_ops,
+	.cable_detect		= ich_pata_cable_detect,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= ich_set_dmamode,
+	.prereset		= piix_pata_prereset,
+};
+#endif
+
+static struct ata_port_info piix_port_info[] = {
+#ifdef CONFIG_ATA_PIIX
+	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
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
+	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask 	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
+		.udma_mask	= ATA_UDMA2,
+		.port_ops	= &ich_pata_ops,
+	},
+
+	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask 	= ATA_PIO4,
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
+#endif
+#ifdef CONFIG_PATA_EFAR
+	[efar_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA4,
+		.port_ops	= &efar_pata_ops,
+	},
+#endif
+#ifdef CONFIG_PATA_IT8213
+	[it8213_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &it8213_pata_ops,
+	},
+#endif
+#ifdef CONFIG_PATA_OLDPIIX
+	[oldpiix_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_NO_SITRE,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.port_ops	= &oldpiix_pata_ops,
+	},
+#endif
+#ifdef CONFIG_PATA_RADISYS
+	[radisys_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_NO_SITRE |
+				  PIIX_FLAG_RADISYS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA24_ONLY,
+		.port_ops	= &radisys_pata_ops,
+	},
+#endif
+#ifdef CONFIG_PATA_RDC
+	[rdc_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &rdc_pata_ops,
+	},
+#endif
+};
 
-static int all_piixalikes;	/* claim all PIIX-alike devices */
+static int all_piixalikes = 1;	/* claim all PIIX-alike devices */
 
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
@@ -1810,7 +1730,7 @@ static int __devinit piix_init_one(struc
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL ||
 	    pdev->vendor == PCI_VENDOR_ID_RDC)
 		pci_read_config_dword(pdev, PIIX_IOCFG, &hpriv->saved_iocfg);
-
+#ifdef CONFIG_ATA_PIIX
 	/* ICH6R may be driven by either ata_piix or ahci driver
 	 * regardless of BIOS configuration.  Make sure AHCI mode is
 	 * off.
@@ -1825,12 +1745,12 @@ static int __devinit piix_init_one(struc
 	if (port_flags & ATA_FLAG_SATA)
 		hpriv->map = piix_init_sata_map(pdev, port_info,
 					piix_map_db_table[idx]);
-
+#endif
 	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	host->private_data = hpriv;
-
+#ifdef CONFIG_ATA_PIIX
 	/* initialize controller */
 	if (port_flags & ATA_FLAG_SATA) {
 		piix_init_pcs(host, piix_map_db_table[idx]);
@@ -1862,6 +1782,7 @@ static int __devinit piix_init_one(struc
 		host->ports[1]->mwdma_mask = 0;
 		host->ports[1]->udma_mask = 0;
 	}
+#endif
 	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
 	pci_set_master(pdev);
@@ -1880,6 +1801,17 @@ static void piix_remove_one(struct pci_d
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
Index: b/drivers/ata/ata_piix_efar.h
===================================================================
--- /dev/null
+++ b/drivers/ata/ata_piix_efar.h
@@ -0,0 +1,28 @@
+#ifdef CONFIG_PATA_EFAR
+/**
+ *	efar_pata_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the EFAR ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int efar_pata_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	pci_read_config_byte(pdev, 0x47, &tmp);
+	if (tmp & (2 >> ap->port_no))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+static struct ata_port_operations efar_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.prereset		= piix_pata_prereset,
+	.cable_detect		= efar_pata_cable_detect,
+};
+#endif
Index: b/drivers/ata/ata_piix_it8213.h
===================================================================
--- /dev/null
+++ b/drivers/ata/ata_piix_it8213.h
@@ -0,0 +1,28 @@
+#ifdef CONFIG_PATA_IT8213
+/**
+ *	it8213_pata_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the 8213 ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int it8213_pata_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	pci_read_config_byte(pdev, 0x42, &tmp);
+	if (tmp & 2)	/* The initial docs are incorrect */
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+static struct ata_port_operations it8213_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= ich_set_dmamode,
+	.prereset		= piix_pata_prereset,
+	.cable_detect		= it8213_pata_cable_detect,
+};
+#endif
Index: b/drivers/ata/ata_piix_oldpiix.h
===================================================================
--- /dev/null
+++ b/drivers/ata/ata_piix_oldpiix.h
@@ -0,0 +1,49 @@
+#if defined(CONFIG_PATA_OLDPIIX) || defined(CONFIG_PATA_RADISYS)
+/**
+ *	oldpiix_qc_issue	-	command issue
+ *	@qc: command pending
+ *
+ *	Called when the libata layer is about to issue a command. We wrap
+ *	this interface so that we can load the correct ATA timings if
+ *	necessary. Our logic also clears TIME0/TIME1 for the other device so
+ *	that, even if we get this wrong, cycles to the other device will
+ *	be made PIO0.
+ */
+
+static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_device *adev = qc->dev;
+
+	if (adev != ap->private_data) {
+		/* UDMA timing is not shared */
+		if (adev->dma_mode < XFER_UDMA_0) {
+			if (adev->dma_mode)
+				piix_set_dmamode(ap, adev);
+			else if (adev->pio_mode)
+				piix_set_piomode(ap, adev);
+		}
+	}
+	return ata_bmdma_qc_issue(qc);
+}
+#endif
+
+#ifdef CONFIG_PATA_OLDPIIX
+static struct ata_port_operations oldpiix_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.qc_issue		= oldpiix_qc_issue,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.prereset		= piix_pata_prereset,
+};
+#endif
+#ifdef CONFIG_PATA_RADISYS
+static struct ata_port_operations radisys_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.qc_issue		= oldpiix_qc_issue,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+};
+#endif
