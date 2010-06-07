Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0FGUID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:08:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54694 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0FGUIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:08:00 -0400
Date: Mon, 7 Jun 2010 16:07:59 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100607200759.GA7637@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing major...  Note we added an ID to an existing, ATA-related PCI
quirk.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libahci.c    |   21 +++------------------
 drivers/ata/sata_sil24.c |   12 ++++++------
 drivers/ata/sata_via.c   |   18 ++++++++++++++++--
 drivers/pci/quirks.c     |    5 ++++-
 include/linux/pci_ids.h  |    1 +
 5 files changed, 30 insertions(+), 27 deletions(-)

Colin Tuckley (1):
      sata_sil24: fix kernel panic on ARM caused by unaligned access in sata_sil24

Tejun Heo (3):
      sata_via: explain the magic fix
      ahci: add pci quirk for JMB362
      ahci: redo stopping DMA engines on empty ports

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 1984a6e..261f86d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -541,29 +541,11 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return -EINVAL;
 }
 
-static int ahci_is_device_present(void __iomem *port_mmio)
-{
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xff;
-
-	/* Make sure PxTFD.STS.BSY and PxTFD.STS.DRQ are 0 */
-	if (status & (ATA_BUSY | ATA_DRQ))
-		return 0;
-
-	/* Make sure PxSSTS.DET is 3h */
-	status = readl(port_mmio + PORT_SCR_STAT) & 0xf;
-	if (status != 3)
-		return 0;
-	return 1;
-}
-
 void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
 
-	if (!ahci_is_device_present(port_mmio))
-		return;
-
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
 	tmp |= PORT_CMD_START;
@@ -1892,6 +1874,9 @@ static void ahci_error_handler(struct ata_port *ap)
 	}
 
 	sata_pmp_error_handler(ap);
+
+	if (!ata_dev_enabled(ap->link.device))
+		ahci_stop_engine(ap);
 }
 
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index e925051..70b58fe 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -539,12 +539,12 @@ static void sil24_config_port(struct ata_port *ap)
 		writel(PORT_CS_IRQ_WOC, port + PORT_CTRL_CLR);
 
 	/* zero error counters. */
-	writel(0x8000, port + PORT_DECODE_ERR_THRESH);
-	writel(0x8000, port + PORT_CRC_ERR_THRESH);
-	writel(0x8000, port + PORT_HSHK_ERR_THRESH);
-	writel(0x0000, port + PORT_DECODE_ERR_CNT);
-	writel(0x0000, port + PORT_CRC_ERR_CNT);
-	writel(0x0000, port + PORT_HSHK_ERR_CNT);
+	writew(0x8000, port + PORT_DECODE_ERR_THRESH);
+	writew(0x8000, port + PORT_CRC_ERR_THRESH);
+	writew(0x8000, port + PORT_HSHK_ERR_THRESH);
+	writew(0x0000, port + PORT_DECODE_ERR_CNT);
+	writew(0x0000, port + PORT_CRC_ERR_CNT);
+	writew(0x0000, port + PORT_HSHK_ERR_CNT);
 
 	/* always use 64bit activation */
 	writel(PORT_CS_32BIT_ACTV, port + PORT_CTRL_CLR);
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 0ecd0f6..4730c42 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -578,10 +578,24 @@ static void svia_configure(struct pci_dev *pdev)
 
 	/*
 	 * vt6421 has problems talking to some drives.  The following
-	 * is the magic fix from Joseph Chan <JosephChan@via.com.tw>.
-	 * Please add proper documentation if possible.
+	 * is the fix from Joseph Chan <JosephChan@via.com.tw>.
+	 *
+	 * When host issues HOLD, device may send up to 20DW of data
+	 * before acknowledging it with HOLDA and the host should be
+	 * able to buffer them in FIFO.  Unfortunately, some WD drives
+	 * send upto 40DW before acknowledging HOLD and, in the
+	 * default configuration, this ends up overflowing vt6421's
+	 * FIFO, making the controller abort the transaction with
+	 * R_ERR.
+	 *
+	 * Rx52[2] is the internal 128DW FIFO Flow control watermark
+	 * adjusting mechanism enable bit and the default value 0
+	 * means host will issue HOLD to device when the left FIFO
+	 * size goes below 32DW.  Setting it to 1 makes the watermark
+	 * 64DW.
 	 *
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=15173
+	 * http://article.gmane.org/gmane.linux.ide/46352
 	 */
 	if (pdev->device == 0x3249) {
 		pci_read_config_byte(pdev, 0x52, &tmp8);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index b7512cf..477345d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1457,7 +1457,8 @@ static void quirk_jmicron_ata(struct pci_dev *pdev)
 	conf5 &= ~(1 << 24);  /* Clear bit 24 */
 
 	switch (pdev->device) {
-	case PCI_DEVICE_ID_JMICRON_JMB360:
+	case PCI_DEVICE_ID_JMICRON_JMB360: /* SATA single port */
+	case PCI_DEVICE_ID_JMICRON_JMB362: /* SATA dual ports */
 		/* The controller should be in single function ahci mode */
 		conf1 |= 0x0002A100; /* Set 8, 13, 15, 17 */
 		break;
@@ -1493,12 +1494,14 @@ static void quirk_jmicron_ata(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f149dd1..4eb4679 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2321,6 +2321,7 @@
 #define PCI_VENDOR_ID_JMICRON		0x197B
 #define PCI_DEVICE_ID_JMICRON_JMB360	0x2360
 #define PCI_DEVICE_ID_JMICRON_JMB361	0x2361
+#define PCI_DEVICE_ID_JMICRON_JMB362	0x2362
 #define PCI_DEVICE_ID_JMICRON_JMB363	0x2363
 #define PCI_DEVICE_ID_JMICRON_JMB365	0x2365
 #define PCI_DEVICE_ID_JMICRON_JMB366	0x2366
