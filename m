Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0FYNET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:04:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0FYNEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:04:14 -0400
Message-ID: <4C24A903.4060908@kernel.org>
Date: Fri, 25 Jun 2010 15:02:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org,
       Ashish Kalra <ashish.kalra@freescale.com>,
       Saeed Bishara <saeed@marvell.com>, Mark Lord <liml@rtr.ca>,
       Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 1/2 #upstream] sata_fsl,mv,nv: prepare for NCQ command completion
 update
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C247B54.2050900@garzik.org> <4C247C36.6040007@kernel.org>
In-Reply-To: <4C247C36.6040007@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 13:03:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following changes to prepare for NCQ command completion
update.  Changes made by this patch don't cause any functional
difference.

* sata_fsl_host_intr(): rename the local variable qc_active to
  done_mask as that's what it is.

* mv_process_crpb_response(): restructure if clause for easier update.

* nv_adma_interrupt(): drop unnecessary error variable.

* nv_swncq_sdbfis(): drop unnecessary nr_done and return 0 on success.
  Typo fix.

* nv_swncq_dmafis(): drop unused return value and return void.

* nv_swncq_host_interrupt(): drop unnecessary return value handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ashish Kalra <ashish.kalra@freescale.com>
Cc: Saeed Bishara <saeed@marvell.com>
Cc: Mark Lord <liml@rtr.ca>
Cc: Robert Hancock <hancockr@shaw.ca>
---
So, something like this.  I tested both flavors of sata_nv but don't
have access to sata_mv or sata_fsl, but the conversion is pretty
straight forward and failures should be pretty easy to catch.

Thanks.

 drivers/ata/sata_fsl.c |   20 ++++++++++----------
 drivers/ata/sata_mv.c  |   47 ++++++++++++++++++++++++-----------------------
 drivers/ata/sata_nv.c  |   32 ++++++++++++++------------------
 3 files changed, 48 insertions(+), 51 deletions(-)

Index: ata/drivers/ata/sata_fsl.c
===================================================================
--- ata.orig/drivers/ata/sata_fsl.c
+++ ata/drivers/ata/sata_fsl.c
@@ -1096,7 +1096,7 @@ static void sata_fsl_host_intr(struct at
 {
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
-	u32 hstatus, qc_active = 0;
+	u32 hstatus, done_mask = 0;
 	struct ata_queued_cmd *qc;
 	u32 SError;

@@ -1116,28 +1116,28 @@ static void sata_fsl_host_intr(struct at
 	}

 	/* Read command completed register */
-	qc_active = ioread32(hcr_base + CC);
+	done_mask = ioread32(hcr_base + CC);

 	VPRINTK("Status of all queues :\n");
-	VPRINTK("qc_active/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
-		qc_active,
+	VPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
+		done_mask,
 		ioread32(hcr_base + CA),
 		ioread32(hcr_base + CE),
 		ioread32(hcr_base + CQ),
 		ap->qc_active);

-	if (qc_active & ap->qc_active) {
+	if (done_mask & ap->qc_active) {
 		int i;
 		/* clear CC bit, this will also complete the interrupt */
-		iowrite32(qc_active, hcr_base + CC);
+		iowrite32(done_mask, hcr_base + CC);

 		DPRINTK("Status of all queues :\n");
-		DPRINTK("qc_active/CC = 0x%x, CA = 0x%x, CE=0x%x\n",
-			qc_active, ioread32(hcr_base + CA),
+		DPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x\n",
+			done_mask, ioread32(hcr_base + CA),
 			ioread32(hcr_base + CE));

 		for (i = 0; i < SATA_FSL_QUEUE_DEPTH; i++) {
-			if (qc_active & (1 << i)) {
+			if (done_mask & (1 << i)) {
 				qc = ata_qc_from_tag(ap, i);
 				if (qc) {
 					ata_qc_complete(qc);
@@ -1164,7 +1164,7 @@ static void sata_fsl_host_intr(struct at
 		/* Spurious Interrupt!! */
 		DPRINTK("spurious interrupt!!, CC = 0x%x\n",
 			ioread32(hcr_base + CC));
-		iowrite32(qc_active, hcr_base + CC);
+		iowrite32(done_mask, hcr_base + CC);
 		return;
 	}
 }
Index: ata/drivers/ata/sata_mv.c
===================================================================
--- ata.orig/drivers/ata/sata_mv.c
+++ ata/drivers/ata/sata_mv.c
@@ -2716,34 +2716,35 @@ static void mv_err_intr(struct ata_port
 static void mv_process_crpb_response(struct ata_port *ap,
 		struct mv_crpb *response, unsigned int tag, int ncq_enabled)
 {
+	u8 ata_status;
+	u16 edma_status = le16_to_cpu(response->flags);
 	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);

-	if (qc) {
-		u8 ata_status;
-		u16 edma_status = le16_to_cpu(response->flags);
-		/*
-		 * edma_status from a response queue entry:
-		 *   LSB is from EDMA_ERR_IRQ_CAUSE (non-NCQ only).
-		 *   MSB is saved ATA status from command completion.
-		 */
-		if (!ncq_enabled) {
-			u8 err_cause = edma_status & 0xff & ~EDMA_ERR_DEV;
-			if (err_cause) {
-				/*
-				 * Error will be seen/handled by mv_err_intr().
-				 * So do nothing at all here.
-				 */
-				return;
-			}
-		}
-		ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
-		if (!ac_err_mask(ata_status))
-			ata_qc_complete(qc);
-		/* else: leave it for mv_err_intr() */
-	} else {
+	if (unlikely(!qc)) {
 		ata_port_printk(ap, KERN_ERR, "%s: no qc for tag=%d\n",
 				__func__, tag);
+		return;
+	}
+
+	/*
+	 * edma_status from a response queue entry:
+	 *   LSB is from EDMA_ERR_IRQ_CAUSE (non-NCQ only).
+	 *   MSB is saved ATA status from command completion.
+	 */
+	if (!ncq_enabled) {
+		u8 err_cause = edma_status & 0xff & ~EDMA_ERR_DEV;
+		if (err_cause) {
+			/*
+			 * Error will be seen/handled by
+			 * mv_err_intr().  So do nothing at all here.
+			 */
+			return;
+		}
 	}
+	ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
+	if (!ac_err_mask(ata_status))
+		ata_qc_complete(qc);
+	/* else: leave it for mv_err_intr() */
 }

 static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp)
Index: ata/drivers/ata/sata_nv.c
===================================================================
--- ata.orig/drivers/ata/sata_nv.c
+++ ata/drivers/ata/sata_nv.c
@@ -1018,7 +1018,7 @@ static irqreturn_t nv_adma_interrupt(int
 			      NV_ADMA_STAT_CPBERR |
 			      NV_ADMA_STAT_CMD_COMPLETE)) {
 			u32 check_commands = notifier_clears[i];
-			int pos, error = 0;
+			int pos, rc;

 			if (status & NV_ADMA_STAT_CPBERR) {
 				/* check all active commands */
@@ -1030,10 +1030,12 @@ static irqreturn_t nv_adma_interrupt(int
 			}

 			/* check CPBs for completed commands */
-			while ((pos = ffs(check_commands)) && !error) {
+			while ((pos = ffs(check_commands))) {
 				pos--;
-				error = nv_adma_check_cpb(ap, pos,
+				rc = nv_adma_check_cpb(ap, pos,
 						notifier_error & (1 << pos));
+				if (unlikely(rc))
+					check_commands = 0;
 				check_commands &= ~(1 << pos);
 			}
 		}
@@ -2129,7 +2131,6 @@ static int nv_swncq_sdbfis(struct ata_po
 	struct nv_swncq_port_priv *pp = ap->private_data;
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u32 sactive;
-	int nr_done = 0;
 	u32 done_mask;
 	int i;
 	u8 host_stat;
@@ -2170,22 +2171,21 @@ static int nv_swncq_sdbfis(struct ata_po
 			pp->dhfis_bits &= ~(1 << i);
 			pp->dmafis_bits &= ~(1 << i);
 			pp->sdbfis_bits |= (1 << i);
-			nr_done++;
 		}
 	}

 	if (!ap->qc_active) {
 		DPRINTK("over\n");
 		nv_swncq_pp_reinit(ap);
-		return nr_done;
+		return 0;
 	}

 	if (pp->qc_active & pp->dhfis_bits)
-		return nr_done;
+		return 0;

 	if ((pp->ncq_flags & ncq_saw_backout) ||
 	    (pp->qc_active ^ pp->dhfis_bits))
-		/* if the controller cann't get a device to host register FIS,
+		/* if the controller can't get a device to host register FIS,
 		 * The driver needs to reissue the new command.
 		 */
 		lack_dhfis = 1;
@@ -2202,7 +2202,7 @@ static int nv_swncq_sdbfis(struct ata_po
 	if (lack_dhfis) {
 		qc = ata_qc_from_tag(ap, pp->last_issue_tag);
 		nv_swncq_issue_atacmd(ap, qc);
-		return nr_done;
+		return 0;
 	}

 	if (pp->defer_queue.defer_bits) {
@@ -2212,7 +2212,7 @@ static int nv_swncq_sdbfis(struct ata_po
 		nv_swncq_issue_atacmd(ap, qc);
 	}

-	return nr_done;
+	return 0;
 }

 static inline u32 nv_swncq_tag(struct ata_port *ap)
@@ -2224,7 +2224,7 @@ static inline u32 nv_swncq_tag(struct at
 	return (tag & 0x1f);
 }

-static int nv_swncq_dmafis(struct ata_port *ap)
+static void nv_swncq_dmafis(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc;
 	unsigned int rw;
@@ -2239,7 +2239,7 @@ static int nv_swncq_dmafis(struct ata_po
 	qc = ata_qc_from_tag(ap, tag);

 	if (unlikely(!qc))
-		return 0;
+		return;

 	rw = qc->tf.flags & ATA_TFLAG_WRITE;

@@ -2254,8 +2254,6 @@ static int nv_swncq_dmafis(struct ata_po
 		dmactl |= ATA_DMA_WR;

 	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	return 1;
 }

 static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
@@ -2265,7 +2263,6 @@ static void nv_swncq_host_interrupt(stru
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u32 serror;
 	u8 ata_stat;
-	int rc = 0;

 	ata_stat = ap->ops->sff_check_status(ap);
 	nv_swncq_irq_clear(ap, fis);
@@ -2310,8 +2307,7 @@ static void nv_swncq_host_interrupt(stru
 			"dhfis 0x%X dmafis 0x%X sactive 0x%X\n",
 			ap->print_id, pp->qc_active, pp->dhfis_bits,
 			pp->dmafis_bits, readl(pp->sactive_block));
-		rc = nv_swncq_sdbfis(ap);
-		if (rc < 0)
+		if (nv_swncq_sdbfis(ap) < 0)
 			goto irq_error;
 	}

@@ -2348,7 +2344,7 @@ static void nv_swncq_host_interrupt(stru
 		 */
 		pp->dmafis_bits |= (0x1 << nv_swncq_tag(ap));
 		pp->ncq_flags |= ncq_saw_dmas;
-		rc = nv_swncq_dmafis(ap);
+		nv_swncq_dmafis(ap);
 	}

 irq_exit:
