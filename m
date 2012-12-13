Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2LMOSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:18:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45131 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab2LMOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Milburn <dmilburn@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 228/241] sata_svw: check DMA start bit before reset
Date: Thu, 13 Dec 2012 11:59:53 -0200
Message-Id: <1355407206-17100-229-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/ata/sata_svw.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index c646118..833607f 100644
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
-- 
1.7.9.5

