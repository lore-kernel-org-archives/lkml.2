Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1ABIHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:07:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:34462 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1ABHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mark Lord <kernel@teksavvy.com>,
        Mark Lord <mlord@pobox.com>, Jeff Garzik <jgarzik@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 033/260] sata_mv: fix broken DSM/TRIM support (v2)
Date: Sun,  2 Jan 2011 02:15:29 -0500
Message-Id: <1293952756-15010-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:42.0272 (UTC) FILETIME=[90710200:01CBAA4D]
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/sata_mv.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 71cc0d4..39af57a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1886,19 +1886,25 @@ static void mv_bmdma_start(struct ata_queued_cmd *qc)
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
+
+		/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+		ata_sff_dma_pause(ap);
+	}
+}
 
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_dma_pause(ap);
+static void mv_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	mv_bmdma_stop_ap(qc->ap);
 }
 
 /**
@@ -1922,8 +1928,21 @@ static u8 mv_bmdma_status(struct ata_port *ap)
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
 
@@ -1983,6 +2002,9 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 
 	switch (tf->protocol) {
 	case ATA_PROT_DMA:
+		if (tf->command == ATA_CMD_DSM)
+			return;
+		/* fall-thru */
 	case ATA_PROT_NCQ:
 		break;	/* continue below */
 	case ATA_PROT_PIO:
@@ -2082,6 +2104,8 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	if ((tf->protocol != ATA_PROT_DMA) &&
 	    (tf->protocol != ATA_PROT_NCQ))
 		return;
+	if (tf->command == ATA_CMD_DSM)
+		return;  /* use bmdma for this */
 
 	/* Fill in Gen IIE command request block */
 	if (!(tf->flags & ATA_TFLAG_WRITE))
@@ -2277,6 +2301,12 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 
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
-- 
1.7.3.3

