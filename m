Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0IRTBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:47 -0400
Received: from kroah.org ([198.145.64.141]:51087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0IRTBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:11 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.235690210@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Lord <mlord@pobox.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [005/123] sata_mv: fix broken DSM/TRIM support (v2)
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sata_mv-fix-broken-dsm-trim-support-v2.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <kernel@teksavvy.com>

commit 44b733809a5aba7f6b15a548d31a56d25bf3851c upstream.

Fix DSM/TRIM commands in sata_mv (v2).
These need to be issued using old-school "BM DMA",
rather than via the EDMA host queue.

Since the chips don't have proper BM DMA status,
we need to be more careful with setting the ATA_DMA_INTR bit,
since DSM/TRIM often has a long delay between "DMA complete"
and "command complete".

GEN_I chips don't have BM DMA, so no TRIM for them.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_mv.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1879,19 +1879,25 @@ static void mv_bmdma_start(struct ata_qu
  *	LOCKING:
  *	Inherited from caller.
  */
-static void mv_bmdma_stop(struct ata_queued_cmd *qc)
+static void mv_bmdma_stop_ap(struct ata_port *ap)
 {
-	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = mv_ap_base(ap);
 	u32 cmd;
 
 	/* clear start/stop bit */
 	cmd = readl(port_mmio + BMDMA_CMD);
-	cmd &= ~ATA_DMA_START;
-	writelfl(cmd, port_mmio + BMDMA_CMD);
+	if (cmd & ATA_DMA_START) {
+		cmd &= ~ATA_DMA_START;
+		writelfl(cmd, port_mmio + BMDMA_CMD);
 
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_dma_pause(ap);
+		/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+		ata_sff_dma_pause(ap);
+	}
+}
+
+static void mv_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	mv_bmdma_stop_ap(qc->ap);
 }
 
 /**
@@ -1915,8 +1921,21 @@ static u8 mv_bmdma_status(struct ata_por
 	reg = readl(port_mmio + BMDMA_STATUS);
 	if (reg & ATA_DMA_ACTIVE)
 		status = ATA_DMA_ACTIVE;
-	else
+	else if (reg & ATA_DMA_ERR)
 		status = (reg & ATA_DMA_ERR) | ATA_DMA_INTR;
+	else {
+		/*
+		 * Just because DMA_ACTIVE is 0 (DMA completed),
+		 * this does _not_ mean the device is "done".
+		 * So we should not yet be signalling ATA_DMA_INTR
+		 * in some cases.  Eg. DSM/TRIM, and perhaps others.
+		 */
+		mv_bmdma_stop_ap(ap);
+		if (ioread8(ap->ioaddr.altstatus_addr) & ATA_BUSY)
+			status = 0;
+		else
+			status = ATA_DMA_INTR;
+	}
 	return status;
 }
 
@@ -1976,6 +1995,9 @@ static void mv_qc_prep(struct ata_queued
 
 	switch (tf->protocol) {
 	case ATA_PROT_DMA:
+		if (tf->command == ATA_CMD_DSM)
+			return;
+		/* fall-thru */
 	case ATA_PROT_NCQ:
 		break;	/* continue below */
 	case ATA_PROT_PIO:
@@ -2075,6 +2097,8 @@ static void mv_qc_prep_iie(struct ata_qu
 	if ((tf->protocol != ATA_PROT_DMA) &&
 	    (tf->protocol != ATA_PROT_NCQ))
 		return;
+	if (tf->command == ATA_CMD_DSM)
+		return;  /* use bmdma for this */
 
 	/* Fill in Gen IIE command request block */
 	if (!(tf->flags & ATA_TFLAG_WRITE))
@@ -2270,6 +2294,12 @@ static unsigned int mv_qc_issue(struct a
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
+		if (qc->tf.command == ATA_CMD_DSM) {
+			if (!ap->ops->bmdma_setup)  /* no bmdma on GEN_I */
+				return AC_ERR_OTHER;
+			break;  /* use bmdma for this */
+		}
+		/* fall thru */
 	case ATA_PROT_NCQ:
 		mv_start_edma(ap, port_mmio, pp, qc->tf.protocol);
 		pp->req_idx = (pp->req_idx + 1) & MV_MAX_Q_DEPTH_MASK;


