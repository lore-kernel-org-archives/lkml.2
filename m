Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0LHAqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:53 -0500
Received: from kroah.org ([198.145.64.141]:45959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0LHAqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:51 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:26 2010
Message-Id: <20101208004426.883981899@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Peer Chen <pchen@nvidia.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Subject: [025/127] ata_generic: implement ATA_GEN_* flags and force enable DMA on MBP 7,1
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 1529c69adce1e95f7ae72f0441590c226bbac7fc upstream.

IDE mode of MCP89 on MBP 7,1 doesn't set DMA enable bits in the BMDMA
status register.  Make the following changes to work around the problem.

* Instead of using hard coded 1 in id->driver_data as class code
  match, use ATA_GEN_CLASS_MATCH and carry the matched id in
  host->private_data.

* Instead of matching PCI_VENDOR_ID_CENATEK, use ATA_GEN_FORCE_DMA
  flag in id instead.

* Add ATA_GEN_FORCE_DMA to the id entry of MBP 7,1.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peer Chen <pchen@nvidia.com>
Reported-by: Anders Østhus <grapz666@gmail.com>
Reported-by: Andreas Graf <andreas_graf@csgraf.de>
Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
Reported-by: Damien Cassou <damien.cassou@gmail.com>
Reported-by: tixetsal@juno.com
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ata/ata_generic.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -32,6 +32,11 @@
  *	A generic parallel ATA driver using libata
  */
 
+enum {
+	ATA_GEN_CLASS_MATCH		= (1 << 0),
+	ATA_GEN_FORCE_DMA		= (1 << 1),
+};
+
 /**
  *	generic_set_mode	-	mode setting
  *	@link: link to set up
@@ -46,13 +51,17 @@
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
+	const struct pci_device_id *id = ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	/* Bits 5 and 6 indicate if DMA is active on master/slave */
-	if (ap->ioaddr.bmdma_addr)
+	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+		dma_enabled = 0xff;
+	} else if (ap->ioaddr.bmdma_addr) {
+		/* Bits 5 and 6 indicate if DMA is active on master/slave */
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
 		dma_enabled = 0xFF;
@@ -126,7 +135,7 @@ static int ata_generic_init_one(struct p
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/* Don't use the generic entry unless instructed to do so */
-	if (id->driver_data == 1 && all_generic_ide == 0)
+	if ((id->driver_data & ATA_GEN_CLASS_MATCH) && all_generic_ide == 0)
 		return -ENODEV;
 
 	/* Devices that need care */
@@ -155,7 +164,7 @@ static int ata_generic_init_one(struct p
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &generic_sht, (void *)id);
 }
 
 static struct pci_device_id ata_generic[] = {
@@ -167,18 +176,21 @@ static struct pci_device_id ata_generic[
 	{ PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
-	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE),
+	  .driver_data = ATA_GEN_FORCE_DMA },
 	/*
 	 * For some reason, MCP89 on MacBook 7,1 doesn't work with
 	 * ahci, use ata_generic instead.
 	 */
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA,
-	  PCI_VENDOR_ID_APPLE, 0xcb89, },
+	  PCI_VENDOR_ID_APPLE, 0xcb89,
+	  .driver_data = ATA_GEN_FORCE_DMA },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
 	/* Must come last. If you add entries adjust this table appropriately */
-	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 1},
+	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL),
+	  .driver_data = ATA_GEN_CLASS_MATCH },
 	{ 0, },
 };
 


