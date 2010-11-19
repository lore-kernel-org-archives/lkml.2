Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab0KSV6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:32 -0500
Received: from kroah.org ([198.145.64.141]:44971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176Ab0KSV61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:27 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:39 2010
Message-Id: <20101119215639.818929376@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [13/82] libahci: fix result_tf handling after an ATA PIO data-in command
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 6ad601955315b010a117306b994f2204fae85fdc upstream.

ATA devices don't send D2H Reg FIS after an successful ATA PIO data-in
command.  The host is supposed to take the TF and E_Status of the
preceding PIO Setup FIS.  Update ahci_qc_fill_rtf() such that it takes
TF + E_Status from PIO Setup FIS after a successful ATA PIO data-in
command.

Without this patch, result_tf for such a command is filled with the
content of the previous D2H Reg FIS which belongs to a previous
command, which can make the command incorrectly seen as failed.

* Patch updated to grab the whole TF + E_Status from PIO Setup FIS
  instead of just E_Status as suggested by Robert Hancock.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mark Lord <kernel@teksavvy.com>
Cc: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.h    |    1 +
 drivers/ata/libahci.c |   18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -72,6 +72,7 @@ enum {
 	AHCI_CMD_RESET		= (1 << 8),
 	AHCI_CMD_CLR_BUSY	= (1 << 10),
 
+	RX_FIS_PIO_SETUP	= 0x20,	/* offset of PIO Setup FIS data */
 	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
 	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
 	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1824,12 +1824,24 @@ static unsigned int ahci_qc_issue(struct
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct ahci_port_priv *pp = qc->ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	u8 *rx_fis = pp->rx_fis;
 
 	if (pp->fbs_enabled)
-		d2h_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+		rx_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+
+	/*
+	 * After a successful execution of an ATA PIO data-in command,
+	 * the device doesn't send D2H Reg FIS to update the TF and
+	 * the host should take TF and E_Status from the preceding PIO
+	 * Setup FIS.
+	 */
+	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
+	    !(qc->flags & ATA_QCFLAG_FAILED)) {
+		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
+		qc->result_tf.command = (rx_fis + RX_FIS_PIO_SETUP)[15];
+	} else
+		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
 
-	ata_tf_from_fis(d2h_fis, &qc->result_tf);
 	return true;
 }
 


