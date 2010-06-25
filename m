Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0FYNEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:04:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0FYNE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:04:28 -0400
Message-ID: <4C24A926.10104@kernel.org>
Date: Fri, 25 Jun 2010 15:03:34 +0200
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
Subject: [PATCH 2/2 #upstream] libata: always use ata_qc_complete_multiple()
 for NCQ command completions
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C247B54.2050900@garzik.org> <4C247C36.6040007@kernel.org> <4C24A903.4060908@kernel.org>
In-Reply-To: <4C24A903.4060908@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 13:03:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sata_fsl, mv and nv call ata_qc_complete() multiple times
from their interrupt handlers to indicate completion of NCQ commands.
This limits the visibility the libata core layer has into how commands
are being executed and completed, which is necessary to support IRQ
expecting in generic way.  libata already has an interface to complete
multiple commands at once - ata_qc_complete_multiple() which ahci and
sata_sil24 already use.

This patch updates the three drivers to use ata_qc_complete_multiple()
too and updates comments on ata_qc_complete[_multiple]() regarding
their usages with NCQ completions.  This change not only provides
better visibility into command execution to the core layer but also
simplifies low level drivers.

* sata_fsl: It already builds done_mask.  Conversion is straight
  forward.

* sata_mv: mv_process_crpb_response() no longer checks for illegal
  completions, it just returns whether the tag is completed or not.
  mv_process_crpb_entries() builds done_mask from it and passes it to
  ata_qc_complete_multiple() which will check for illegal completions.

* sata_nv adma: Similar to sata_mv.  nv_adma_check_cpb() now just
  returns the tag status and nv_adma_interrupt() builds done_mask from
  it and passes it to ata_qc_complete_multiple().

* sata_nv swncq: It already builds done_mask.  Drop unnecessary
  illegal transition checks and call ata_qc_complete_multiple().

In the long run, it might be a good idea to make ata_qc_complete()
whine if called when multiple NCQ commands are in flight.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ashish Kalra <ashish.kalra@freescale.com>
Cc: Saeed Bishara <saeed@marvell.com>
Cc: Mark Lord <liml@rtr.ca>
Cc: Robert Hancock <hancockr@shaw.ca>
---
 drivers/ata/libata-core.c |   13 ++++++++--
 drivers/ata/sata_fsl.c    |    8 +-----
 drivers/ata/sata_mv.c     |   25 +++++++++-----------
 drivers/ata/sata_nv.c     |   57 ++++++++++------------------------------------
 4 files changed, 38 insertions(+), 65 deletions(-)

Index: ata/drivers/ata/libata-core.c
===================================================================
--- ata.orig/drivers/ata/libata-core.c
+++ ata/drivers/ata/libata-core.c
@@ -4962,8 +4962,13 @@ static void ata_verify_xfer(struct ata_q
  *	ata_qc_complete - Complete an active ATA command
  *	@qc: Command to complete
  *
- *	Indicate to the mid and upper layers that an ATA
- *	command has completed, with either an ok or not-ok status.
+ *	Indicate to the mid and upper layers that an ATA command has
+ *	completed, with either an ok or not-ok status.
+ *
+ *	Refrain from calling this function multiple times when
+ *	successfully completing multiple NCQ commands.
+ *	ata_qc_complete_multiple() should be used instead, which will
+ *	properly update IRQ expect state.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -5056,6 +5061,10 @@ void ata_qc_complete(struct ata_queued_c
  *	requests normally.  ap->qc_active and @qc_active is compared
  *	and commands are completed accordingly.
  *
+ *	Always use this function when completing multiple NCQ commands
+ *	from IRQ handlers instead of calling ata_qc_complete()
+ *	multiple times to keep IRQ expect status properly in sync.
+ *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  *
Index: ata/drivers/ata/sata_fsl.c
===================================================================
--- ata.orig/drivers/ata/sata_fsl.c
+++ ata/drivers/ata/sata_fsl.c
@@ -1137,17 +1137,13 @@ static void sata_fsl_host_intr(struct at
 			ioread32(hcr_base + CE));

 		for (i = 0; i < SATA_FSL_QUEUE_DEPTH; i++) {
-			if (done_mask & (1 << i)) {
-				qc = ata_qc_from_tag(ap, i);
-				if (qc) {
-					ata_qc_complete(qc);
-				}
+			if (done_mask & (1 << i))
 				DPRINTK
 				    ("completing ncq cmd,tag=%d,CC=0x%x,CA=0x%x\n",
 				     i, ioread32(hcr_base + CC),
 				     ioread32(hcr_base + CA));
-			}
 		}
+		ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
 		return;

 	} else if ((ap->qc_active & (1 << ATA_TAG_INTERNAL))) {
Index: ata/drivers/ata/sata_mv.c
===================================================================
--- ata.orig/drivers/ata/sata_mv.c
+++ ata/drivers/ata/sata_mv.c
@@ -2713,18 +2713,11 @@ static void mv_err_intr(struct ata_port
 	}
 }

-static void mv_process_crpb_response(struct ata_port *ap,
+static bool mv_process_crpb_response(struct ata_port *ap,
 		struct mv_crpb *response, unsigned int tag, int ncq_enabled)
 {
 	u8 ata_status;
 	u16 edma_status = le16_to_cpu(response->flags);
-	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);
-
-	if (unlikely(!qc)) {
-		ata_port_printk(ap, KERN_ERR, "%s: no qc for tag=%d\n",
-				__func__, tag);
-		return;
-	}

 	/*
 	 * edma_status from a response queue entry:
@@ -2738,13 +2731,14 @@ static void mv_process_crpb_response(str
 			 * Error will be seen/handled by
 			 * mv_err_intr().  So do nothing at all here.
 			 */
-			return;
+			return false;
 		}
 	}
 	ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
 	if (!ac_err_mask(ata_status))
-		ata_qc_complete(qc);
+		return true;
 	/* else: leave it for mv_err_intr() */
+	return false;
 }

 static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp)
@@ -2753,6 +2747,7 @@ static void mv_process_crpb_entries(stru
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	u32 in_index;
 	bool work_done = false;
+	u32 done_mask = 0;
 	int ncq_enabled = (pp->pp_flags & MV_PP_FLAG_NCQ_EN);

 	/* Get the hardware queue position index */
@@ -2773,15 +2768,19 @@ static void mv_process_crpb_entries(stru
 			/* Gen II/IIE: get command tag from CRPB entry */
 			tag = le16_to_cpu(response->id) & 0x1f;
 		}
-		mv_process_crpb_response(ap, response, tag, ncq_enabled);
+		if (mv_process_crpb_response(ap, response, tag, ncq_enabled))
+			done_mask |= 1 << tag;
 		work_done = true;
 	}

-	/* Update the software queue position index in hardware */
-	if (work_done)
+	if (work_done) {
+		ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
+
+		/* Update the software queue position index in hardware */
 		writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
 			 (pp->resp_idx << EDMA_RSP_Q_PTR_SHIFT),
 			 port_mmio + EDMA_RSP_Q_OUT_PTR);
+	}
 }

 static void mv_port_intr(struct ata_port *ap, u32 port_cause)
Index: ata/drivers/ata/sata_nv.c
===================================================================
--- ata.orig/drivers/ata/sata_nv.c
+++ ata/drivers/ata/sata_nv.c
@@ -873,29 +873,11 @@ static int nv_adma_check_cpb(struct ata_
 			ata_port_freeze(ap);
 		else
 			ata_port_abort(ap);
-		return 1;
+		return -1;
 	}

-	if (likely(flags & NV_CPB_RESP_DONE)) {
-		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, cpb_num);
-		VPRINTK("CPB flags done, flags=0x%x\n", flags);
-		if (likely(qc)) {
-			DPRINTK("Completing qc from tag %d\n", cpb_num);
-			ata_qc_complete(qc);
-		} else {
-			struct ata_eh_info *ehi = &ap->link.eh_info;
-			/* Notifier bits set without a command may indicate the drive
-			   is misbehaving. Raise host state machine violation on this
-			   condition. */
-			ata_port_printk(ap, KERN_ERR,
-					"notifier for tag %d with no cmd?\n",
-					cpb_num);
-			ehi->err_mask |= AC_ERR_HSM;
-			ehi->action |= ATA_EH_RESET;
-			ata_port_freeze(ap);
-			return 1;
-		}
-	}
+	if (likely(flags & NV_CPB_RESP_DONE))
+		return 1;
 	return 0;
 }

@@ -1018,6 +1000,7 @@ static irqreturn_t nv_adma_interrupt(int
 			      NV_ADMA_STAT_CPBERR |
 			      NV_ADMA_STAT_CMD_COMPLETE)) {
 			u32 check_commands = notifier_clears[i];
+			u32 done_mask = 0;
 			int pos, rc;

 			if (status & NV_ADMA_STAT_CPBERR) {
@@ -1034,10 +1017,13 @@ static irqreturn_t nv_adma_interrupt(int
 				pos--;
 				rc = nv_adma_check_cpb(ap, pos,
 						notifier_error & (1 << pos));
-				if (unlikely(rc))
+				if (rc > 0)
+					done_mask |= 1 << pos;
+				else if (unlikely(rc < 0))
 					check_commands = 0;
 				check_commands &= ~(1 << pos);
 			}
+			ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
 		}
 	}

@@ -2132,7 +2118,6 @@ static int nv_swncq_sdbfis(struct ata_po
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u32 sactive;
 	u32 done_mask;
-	int i;
 	u8 host_stat;
 	u8 lack_dhfis = 0;

@@ -2152,27 +2137,11 @@ static int nv_swncq_sdbfis(struct ata_po
 	sactive = readl(pp->sactive_block);
 	done_mask = pp->qc_active ^ sactive;

-	if (unlikely(done_mask & sactive)) {
-		ata_ehi_clear_desc(ehi);
-		ata_ehi_push_desc(ehi, "illegal SWNCQ:qc_active transition"
-				  "(%08x->%08x)", pp->qc_active, sactive);
-		ehi->err_mask |= AC_ERR_HSM;
-		ehi->action |= ATA_EH_RESET;
-		return -EINVAL;
-	}
-	for (i = 0; i < ATA_MAX_QUEUE; i++) {
-		if (!(done_mask & (1 << i)))
-			continue;
-
-		qc = ata_qc_from_tag(ap, i);
-		if (qc) {
-			ata_qc_complete(qc);
-			pp->qc_active &= ~(1 << i);
-			pp->dhfis_bits &= ~(1 << i);
-			pp->dmafis_bits &= ~(1 << i);
-			pp->sdbfis_bits |= (1 << i);
-		}
-	}
+	pp->qc_active &= ~done_mask;
+	pp->dhfis_bits &= ~done_mask;
+	pp->dmafis_bits &= ~done_mask;
+	pp->sdbfis_bits |= done_mask;
+	ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);

 	if (!ap->qc_active) {
 		DPRINTK("over\n");
