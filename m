Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2L1UBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:01:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54859 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160Ab2L1TQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:47 -0500
Message-Id: <20121228190333.797385171@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Milburn <dmilburn@redhat.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 018/173] sata_svw: check DMA start bit before reset
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Milburn <dmilburn@redhat.com>

commit b03e66a6be91f8389fcd902ab6c1563db1c9c06b upstream.

If kdump is triggered with pending IO, controller may not respond causing
kdump to fail.

http://marc.info/?l=linux-ide&m=133032255424658&w=2

During error recovery ata_do_dev_read_id never completes due hang
in mmio_insw.

ata_do_dev_read_id
 ata_sff_data_xfer
  ioread16_rep
   mmio_insw

if DMA start bit is cleared before reset, PIO command is successful
and kdump succeeds.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/sata_svw.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 44a4256..08608de 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -142,6 +142,39 @@ static int k2_sata_scr_write(struct ata_link *link,
 	return 0;
 }
 
+static int k2_sata_softreset(struct ata_link *link,
+			     unsigned int *class, unsigned long deadline)
+{
+	u8 dmactl;
+	void __iomem *mmio = link->ap->ioaddr.bmdma_addr;
+
+	dmactl = readb(mmio + ATA_DMA_CMD);
+
+	/* Clear the start bit */
+	if (dmactl & ATA_DMA_START) {
+		dmactl &= ~ATA_DMA_START;
+		writeb(dmactl, mmio + ATA_DMA_CMD);
+	}
+
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static int k2_sata_hardreset(struct ata_link *link,
+			     unsigned int *class, unsigned long deadline)
+{
+	u8 dmactl;
+	void __iomem *mmio = link->ap->ioaddr.bmdma_addr;
+
+	dmactl = readb(mmio + ATA_DMA_CMD);
+
+	/* Clear the start bit */
+	if (dmactl & ATA_DMA_START) {
+		dmactl &= ~ATA_DMA_START;
+		writeb(dmactl, mmio + ATA_DMA_CMD);
+	}
+
+	return sata_sff_hardreset(link, class, deadline);
+}
 
 static void k2_sata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 {
@@ -346,6 +379,8 @@ static struct scsi_host_template k2_sata_sht = {
 
 static struct ata_port_operations k2_sata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.softreset              = k2_sata_softreset,
+	.hardreset              = k2_sata_hardreset,
 	.sff_tf_load		= k2_sata_tf_load,
 	.sff_tf_read		= k2_sata_tf_read,
 	.sff_check_status	= k2_stat_check_status,


