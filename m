Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1BWK3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:29:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62022 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1BWK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:29:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=yFdB0Eg3s2e9MR/2QQs6PkRj0KwxnPXFfo/y9ILI38KSjkZj3xJFELBHaXZ+Gs+Ejw
         +5aYqQdNOHxMtlSI2GF+hDK/zMV8PrdGX919iCf9Oie3L0Rbvj7mwbCNtw/rObNL0jTf
         eHVjkXoU8ZRTJsEw65OyVMHMEf10OGMJ/4IfU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
Date: Wed, 23 Feb 2011 11:28:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <AANLkTi=jp+q9VYNJvko8P4ju_z86Rw5AxWY9O_reFDai@mail.gmail.com> <20110223091437.0fb888a2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110223091437.0fb888a2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <201102231128.51910.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> > on the other side of equation we have 5 drivers less, 1400 LOCs less,
> > no risk of losing bugfixes and features (which is true already w/
> > pata_rdc lacking locking fixes + Power Management and pata_oldpiix
> > lacking parallel scanning feature).
> 
> The parallel scanning feature is somewhat irrelevant on an original PIIX,
> if the hardware even supports it which is somewhat of an unknown. If you
> have a minor boot time performance concern you'd buy a real computer
> instead.
> 
> And the other stuff you actually create a problem rather than solving one
> - the difficulting testing the rare chips makes it harder to fix ata_piix
> bugs and do full testing.

We don't have to insist on merging all PIIX-alikes (like oldPIIX and Radisys)
support to ata_piix, i.e. for RDC it looks much cleaner:

per patch from the original patch series:
 4 files changed, 13 insertions(+), 387 deletions(-)

pata_rdc driver is nearly identical to ata_piix PATA support (modulo bugs in
pata_rdc and SATA stuff in ata_piix)


From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: add RDC support

Add RDC PATA support to ata_piix and remove no longer
needed pata_rdc driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig    |    1 
 drivers/ata/Makefile   |    1 
 drivers/ata/ata_piix.c |   14 +
 drivers/ata/pata_rdc.c |  384 -------------------------------------------------
 4 files changed, 13 insertions(+), 387 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -567,6 +567,7 @@ config PATA_RADISYS
 config PATA_RDC
 	tristate "RDC PATA support"
 	depends on PCI
+	select ATA_PIIX
 	help
 	  This option enables basic support for the later RDC PATA controllers
 	  controllers via the new ATA layer. For the RDC 1010, you need to
Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optid
 obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
 obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
-obj-$(CONFIG_PATA_RDC)		+= pata_rdc.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
 obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1,6 +1,9 @@
 /*
  *    ata_piix.c - Intel PATA/SATA controllers
  *
+ *    This is actually a driver for hardware meeting
+ *    INCITS 370-2004 (1510D): ATA Host Adapter Standards
+ *
  *    Maintained by:  Jeff Garzik <jgarzik@pobox.com>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
@@ -255,6 +258,10 @@ static const struct pci_device_id piix_p
 	/* IT8213 */
 	{ 0x1283, 0x8213, PCI_ANY_ID, PCI_ANY_ID, 0, 0, it8213_pata },
 
+	/* RDC is ICH like */
+	{ 0x17F3, 0x1011, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ 0x17F3, 0x1012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
@@ -671,6 +678,7 @@ MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("pata_efar");
 MODULE_ALIAS("pata_it8213");
+MODULE_ALIAS("pata_rdc");
 
 struct ich_laptop {
 	u16 device;
@@ -1676,7 +1684,8 @@ static int __devinit piix_init_one(struc
 	 * because some ACPI implementations mess up cable related
 	 * bits on _STM.  Reported on kernel bz#11879.
 	 */
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL)
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL ||
+	    pdev->vendor == PCI_VENDOR_ID_RDC)
 		pci_read_config_dword(pdev, PIIX_IOCFG, &hpriv->saved_iocfg);
 
 	/* ICH6R may be driven by either ata_piix or ahci driver
@@ -1741,7 +1750,8 @@ static void piix_remove_one(struct pci_d
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct piix_host_priv *hpriv = host->private_data;
 
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL)
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL ||
+	    pdev->vendor == PCI_VENDOR_ID_RDC)
 		pci_write_config_dword(pdev, PIIX_IOCFG, hpriv->saved_iocfg);
 
 	ata_pci_remove_one(pdev);
Index: b/drivers/ata/pata_rdc.c
===================================================================
--- a/drivers/ata/pata_rdc.c
+++ /dev/null
@@ -1,384 +0,0 @@
-/*
- *  pata_rdc		-	Driver for later RDC PATA controllers
- *
- *  This is actually a driver for hardware meeting
- *  INCITS 370-2004 (1510D): ATA Host Adapter Standards
- *
- *  Based on ata_piix.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2, or (at your option)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; see the file COPYING.  If not, write to
- *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/gfp.h>
-#include <scsi/scsi_host.h>
-#include <linux/libata.h>
-#include <linux/dmi.h>
-
-#define DRV_NAME	"pata_rdc"
-#define DRV_VERSION	"0.01"
-
-struct rdc_host_priv {
-	u32 saved_iocfg;
-};
-
-/**
- *	rdc_pata_cable_detect - Probe host controller cable detect info
- *	@ap: Port for which cable detect info is desired
- *
- *	Read 80c cable indicator from ATA PCI device's PCI config
- *	register.  This register is normally set by firmware (BIOS).
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static int rdc_pata_cable_detect(struct ata_port *ap)
-{
-	struct rdc_host_priv *hpriv = ap->host->private_data;
-	u8 mask;
-
-	/* check BIOS cable detect results */
-	mask = 0x30 << (2 * ap->port_no);
-	if ((hpriv->saved_iocfg & mask) == 0)
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-/**
- *	rdc_pata_prereset - prereset for PATA host controller
- *	@link: Target link
- *	@deadline: deadline jiffies for the operation
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-static int rdc_pata_prereset(struct ata_link *link, unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	static const struct pci_bits rdc_enable_bits[] = {
-		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
-		{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
-	};
-
-	if (!pci_test_config_bits(pdev, &rdc_enable_bits[ap->port_no]))
-		return -ENOENT;
-	return ata_sff_prereset(link, deadline);
-}
-
-static DEFINE_SPINLOCK(rdc_lock);
-
-static void rdc_set_timings(struct ata_port *ap, struct ata_device *adev,
-			    u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	unsigned int is_slave	= (adev->devno != 0);
-	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
-	unsigned int slave_port	= 0x44;
-	u16 master_data;
-	u8 slave_data;
-	u8 udma_enable;
-	int control = 0;
-
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	if (pio >= 2 || use_mwdma)
-		control |= 1;	/* TIME1 enable */
-	if (ata_pio_need_iordy(adev) || use_mwdma)
-		control |= 2;	/* IE enable */
-	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE enable */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	spin_lock_irqsave(&rdc_lock, flags);
-
-	/* PIO configuration clears DTE unconditionally.  It will be
-	 * programmed in set_dmamode which is guaranteed to be called
-	 * after set_piomode if any DMA mode is available.
-	 */
-	pci_read_config_word(dev, master_port, &master_data);
-	if (is_slave) {
-		/* clear TIME1|IE1|PPE1|DTE1 */
-		master_data &= 0xff0f;
-		/* Enable SITRE (separate slave timing register) */
-		master_data |= 0x4000;
-		/* enable PPE1, IE1 and TIME1 as needed */
-		master_data |= (control << 4);
-		pci_read_config_byte(dev, slave_port, &slave_data);
-		slave_data &= (ap->port_no ? 0x0f : 0xf0);
-		/* Load the timing nibble for this slave */
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
-						<< (ap->port_no ? 4 : 0);
-	} else {
-		/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
-		master_data &= 0xccf0;
-		/* Enable PPE, IE and TIME as appropriate */
-		master_data |= control;
-		/* load ISP and RCT */
-		master_data |=
-			(timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	}
-	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
-		pci_write_config_byte(dev, slave_port, slave_data);
-
-	/* Ensure the UDMA bit is off - it will be turned back on if
-	   UDMA is selected */
-
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
-	pci_write_config_byte(dev, 0x48, udma_enable);
-
-	spin_unlock_irqrestore(&rdc_lock, flags);
-}
-
-/**
- *	rdc_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Drive in question
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	rdc_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	rdc_set_dmamode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Drive in question
- *
- *	Set UDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	u8 speed		= adev->dma_mode;
-	int devid		= adev->devno + 2 * ap->port_no;
-	u8 udma_enable		= 0;
-
-	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = speed - XFER_UDMA_0;
-		u16 udma_timing;
-		u16 ideconf;
-		int u_clock, u_speed;
-
-		spin_lock_irqsave(&rdc_lock, flags);
-
-		pci_read_config_byte(dev, 0x48, &udma_enable);
-
-		/*
-		 * UDMA is handled by a combination of clock switching and
-		 * selection of dividers
-		 *
-		 * Handy rule: Odd modes are UDMATIMx 01, even are 02
-		 *	       except UDMA0 which is 00
-		 */
-		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
-			u_clock = 0x1000;	/* 100Mhz */
-		else if (udma > 2)
-			u_clock = 1;		/* 66Mhz */
-		else
-			u_clock = 0;		/* 33Mhz */
-
-		udma_enable |= (1 << devid);
-
-		/* Load the CT/RP selection */
-		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= u_speed << (4 * devid);
-		pci_write_config_word(dev, 0x4A, udma_timing);
-
-		/* Select a 33/66/100Mhz clock */
-		pci_read_config_word(dev, 0x54, &ideconf);
-		ideconf &= ~(0x1001 << devid);
-		ideconf |= u_clock << devid;
-		pci_write_config_word(dev, 0x54, ideconf);
-
-		pci_write_config_byte(dev, 0x48, udma_enable);
-
-		spin_unlock_irqrestore(&rdc_lock, flags);
-	} else {
-		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		rdc_set_timings(ap, adev, pio, 1);
-	}
-}
-
-static struct ata_port_operations rdc_pata_ops = {
-	.inherits		= &ata_bmdma32_port_ops,
-	.cable_detect		= rdc_pata_cable_detect,
-	.set_piomode		= rdc_set_piomode,
-	.set_dmamode		= rdc_set_dmamode,
-	.prereset		= rdc_pata_prereset,
-};
-
-static struct ata_port_info rdc_port_info = {
-
-	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= ATA_PIO4,
-	.mwdma_mask	= ATA_MWDMA12_ONLY,
-	.udma_mask	= ATA_UDMA5,
-	.port_ops	= &rdc_pata_ops,
-};
-
-static struct scsi_host_template rdc_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-/**
- *	rdc_init_one - Register PIIX ATA PCI device with kernel services
- *	@pdev: PCI device to register
- *	@ent: Entry in rdc_pci_tbl matching with @pdev
- *
- *	Called from kernel PCI layer.  We probe for combined mode (sigh),
- *	and then hand over control to libata, for it to do the rest.
- *
- *	LOCKING:
- *	Inherited from PCI layer (may sleep).
- *
- *	RETURNS:
- *	Zero on success, or -ERRNO value.
- */
-
-static int __devinit rdc_init_one(struct pci_dev *pdev,
-				   const struct pci_device_id *ent)
-{
-	static int printed_version;
-	struct device *dev = &pdev->dev;
-	struct ata_port_info port_info[2];
-	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
-	unsigned long port_flags;
-	struct ata_host *host;
-	struct rdc_host_priv *hpriv;
-	int rc;
-
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
-
-	port_info[0] = rdc_port_info;
-	port_info[1] = rdc_port_info;
-
-	port_flags = port_info[0].flags;
-
-	/* enable device and prepare host */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
-
-	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
-	if (!hpriv)
-		return -ENOMEM;
-
-	/* Save IOCFG, this will be used for cable detection, quirk
-	 * detection and restoration on detach.
-	 */
-	pci_read_config_dword(pdev, 0x54, &hpriv->saved_iocfg);
-
-	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
-	if (rc)
-		return rc;
-	host->private_data = hpriv;
-
-	pci_intx(pdev, 1);
-
-	host->flags |= ATA_HOST_PARALLEL_SCAN;
-
-	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, &rdc_sht);
-}
-
-static void rdc_remove_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	struct rdc_host_priv *hpriv = host->private_data;
-
-	pci_write_config_dword(pdev, 0x54, hpriv->saved_iocfg);
-
-	ata_pci_remove_one(pdev);
-}
-
-static const struct pci_device_id rdc_pci_tbl[] = {
-	{ PCI_DEVICE(0x17F3, 0x1011), },
-	{ PCI_DEVICE(0x17F3, 0x1012), },
-	{ }	/* terminate list */
-};
-
-static struct pci_driver rdc_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= rdc_pci_tbl,
-	.probe			= rdc_init_one,
-	.remove			= rdc_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
-#endif
-};
-
-
-static int __init rdc_init(void)
-{
-	return pci_register_driver(&rdc_pci_driver);
-}
-
-static void __exit rdc_exit(void)
-{
-	pci_unregister_driver(&rdc_pci_driver);
-}
-
-module_init(rdc_init);
-module_exit(rdc_exit);
-
-MODULE_AUTHOR("Alan Cox (based on ata_piix)");
-MODULE_DESCRIPTION("SCSI low-level driver for RDC PATA controllers");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, rdc_pci_tbl);
-MODULE_VERSION(DRV_VERSION);
