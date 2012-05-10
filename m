Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab2EJEUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 00:20:46 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:51786 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751279Ab2EJEUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 00:20:02 -0400
From: "Thang Q. Nguyen" <tqnguyen@apm.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        "Thang Q. Nguyen" <tqnguyen@apm.com>
Subject: [PATCH 3/5] sata_dwc: Add support ATAPI transfer
Date: Thu, 10 May 2012 11:17:29 +0700
Message-Id: <1336623449-7697-1-git-send-email-tqnguyen@apm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thang Q. Nguyen <tqnguyen@apm.com>
---
 drivers/ata/sata_dwc_460ex.c |   64 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 937aeb3..6175e01 100755
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1035,7 +1035,8 @@ DRVSTILLBUSY:
 
 			if ((host_pvt.dma_interrupt_count % 2) == 0)
 				sata_dwc_dma_xfer_complete(ap, 1);
-		} else if (ata_is_pio(qc->tf.protocol)) {
+		} else if (ata_is_pio(qc->tf.protocol) ||
+			ata_is_nodata(qc->tf.protocol)) {
 			ata_sff_hsm_move(ap, qc, status, 0);
 			handled = 1;
 			goto DONE;
@@ -1235,7 +1236,10 @@ static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
 						& mask;
 	host_pvt.sata_dwc_sactive_issued = (host_pvt.sata_dwc_sactive_issued) \
 						& mask;
-	ata_qc_complete(qc);
+	if (ata_is_atapi(qc->tf.protocol))
+		ata_sff_hsm_move(ap, qc, status, 0);
+	else
+		ata_qc_complete(qc);
 	return 0;
 }
 
@@ -1385,6 +1389,58 @@ static void sata_dwc_port_stop(struct ata_port *ap)
 	ap->private_data = NULL;
 }
 
+/**
+ * sata_dwc_check_atapi_dma - Filter ATAPI cmds which are unsuitable for DMA.
+ * @qc: queued command to check for chipset/DMA compatibility.
+ *
+ * The bmdma engines cannot handle speculative data sizes (bytecount
+ * under/over flow). So only allow DMA for data transfer commands with
+ * known data sizes.
+ */
+static int sata_dwc_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	int pio = 1; /* atapi dma off by default */
+	unsigned int lba;
+
+	if (scmd) {
+		switch (scmd->cmnd[0]) {
+		case WRITE_6:
+		case WRITE_10:
+		case WRITE_12:
+		case READ_6:
+		case READ_10:
+		case READ_12:
+			pio = 0; /* DMA is safe */
+			break;
+		}
+
+		/* -45150 (FFFF4FA2) to -1 (FFFFFFFF) shall use PIO mode */
+		if (scmd->cmnd[0] == WRITE_10) {
+			lba = (scmd->cmnd[2] << 24) |
+				  (scmd->cmnd[3] << 16) |
+				  (scmd->cmnd[4] << 8) |
+				   scmd->cmnd[5];
+			if (lba >= 0xFFFF4FA2)
+				pio = 1;
+		}
+		/*
+		* WORK AROUND: Fix DMA issue when blank CD/DVD disc in the drive
+		* and user use the 'fdisk -l' command. No DMA data returned so
+		* we can not complete the QC.
+		*/
+		else if (scmd->cmnd[0] == READ_10) {
+			lba = (scmd->cmnd[2] << 24) |
+				  (scmd->cmnd[3] << 16) |
+				  (scmd->cmnd[4] << 8) |
+				   scmd->cmnd[5];
+			if (lba < 0x20)
+				pio = 1;
+		}
+	}
+	return pio;
+}
+
 /*
  * Function : sata_dwc_exec_command_by_tag
  * arguments : ata_port *ap, ata_taskfile *tf, u8 tag, u32 cmd_issued
@@ -1572,7 +1628,8 @@ static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
 
 static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
 {
-	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))
+	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO) ||
+		(qc->tf.protocol == ATAPI_PROT_PIO))
 		return;
 
 #ifdef DEBUG_NCQ
@@ -1641,6 +1698,7 @@ static struct ata_port_operations sata_dwc_ops = {
 	.port_start		= sata_dwc_port_start,
 	.port_stop		= sata_dwc_port_stop,
 
+	.check_atapi_dma	= sata_dwc_check_atapi_dma,
 	.bmdma_setup		= sata_dwc_bmdma_setup,
 	.bmdma_start		= sata_dwc_bmdma_start,
 };
-- 
1.7.3.4

