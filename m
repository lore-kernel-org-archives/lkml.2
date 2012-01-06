Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2AFMuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:50:06 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64056 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab2AFMuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:50:00 -0500
Date: Fri, 6 Jan 2012 13:33:39 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jgarzik@pobox.com,
        inux-ide@vger.kernel.org
Subject: [PATCH 6/6] ahci: support the STA2X11 I/O Hub
Message-ID: <78cef636f264afa64de043be2018b5d66290240e.1325852059.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
In-Reply-To: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AHCI controller found in the STA2X11 chip uses BAR number 0
instead of 5. Also, the chip's fixup code sets a special DMA mask
for all of its PCI functions, and the mask must be preserved here.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/ata/ahci.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cf26222..d07bf03 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -52,7 +52,8 @@
 #define DRV_VERSION	"3.0"
 
 enum {
-	AHCI_PCI_BAR		= 5,
+	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
 enum board_ids {
@@ -375,6 +376,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
 
+	/* ST Microelectronics */
+	{ PCI_VDEVICE(STMICRO, 0xCC06), board_ahci },		/* ST ConneXt */
+
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
@@ -622,6 +626,13 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 {
 	int rc;
 
+	/*
+	 * If the device fixup already set the dma_mask to some non-standard
+	 * value, don't extend it here. This happens on STA2X11, for example.
+	 */
+	if (pdev->dma_mask && pdev->dma_mask < DMA_BIT_MASK(32))
+		return 0;
+
 	if (using_dac &&
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
@@ -1026,6 +1037,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
 	int n_ports, i, rc;
+	int ahci_pci_bar = AHCI_PCI_BAR_STANDARD;
 
 	VPRINTK("ENTER\n");
 
@@ -1057,6 +1069,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
+	/* The Connext uses non-standard BAR */
+	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
+		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -1065,7 +1081,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* AHCI controllers often implement SFF compatible interface.
 	 * Grab all PCI BARs just in case.
 	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	rc = pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -1108,7 +1124,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
-	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
@@ -1172,8 +1188,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+		ata_port_pbar_desc(ap, ahci_pci_bar, -1, "abar");
+		ata_port_pbar_desc(ap, ahci_pci_bar,
 				   0x100 + ap->port_no * 0x80, "port");
 
 		/* set enclosure management message type */
-- 
1.7.7.2
