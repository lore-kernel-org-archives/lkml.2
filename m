Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0LSVWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:22:46 -0500
Received: from nm7-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.228]:29300 "HELO
	nm7-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932479Ab0LSVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:44 -0500
X-Yahoo-Newman-Id: 852828.32477.bm@omp1067.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: gf_47qsVM1nlDH40ena0t81djqogN36AzwRLIHGt5mrRciF
 xEQ91bPRFjkNtYP8c.iw9F8YAEiGqKjmtk4k1QCuBQMV_koQf9i1q80A_YX2
 JcTfSDZLVb0K.pQiH8oXAJaoelL0a3YQ1i5we1sUFPQMqGg.jnveJIuXIIY3
 PAN0LJlFAf1b.oe.rO7kOBQ4RAl0jW7In8GHhTaOJ8O2TUN8XFD2wPJtIIpv
 0MplfyXfPqREskSKuanBe3a0ORIfSbLXlAYPUlUCNAuAgu48gaFUN2jBV_W9
 F5GUEvJLS7VUNuGDCxnMW1o3LoeoPpMllYfEMM8EeeTVarwp46txwCxQU5LJ
 YjlLvcXYc2_zcdYR1wsgaNfWXI8voyarTwduKGsLuekSunG_7fZop0PVbDuK
 nqAJdDmmkCFLdtc6.SoYRWaEhCHyKJKtOyRJ.0fBIuCnNJjoElJ.UP2YBVg-
 -
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 06/12] lpfc: Convert to host_lock less w/ interrupts disabled externally
Date: Sun, 19 Dec 2010 13:22:01 -0800
Message-Id: <1292793727-31957-7-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts lpfc to run in host_lock less mode with the new
IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
dispatch.  It also drops the legacy host_lock unlock optimization around
lpfc_sli_handle_fast_ring_event().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 581837b..62a62e9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2886,7 +2886,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_queuecommand - scsi_host_template queuecommand entry point
+ * lpfc_queuecommand_irq_disable - scsi_host_template queuecommand entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  * @done: Pointer to done routine.
  *
@@ -2899,7 +2899,8 @@ void lpfc_poll_timeout(unsigned long ptr)
  *   SCSI_MLQUEUE_HOST_BUSY - Block all devices served by this host temporarily.
  **/
 static int
-lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
+lpfc_queuecommand_irq_disable(struct scsi_cmnd *cmnd,
+			void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
@@ -3038,11 +3039,9 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_unlock(shost->host_lock);
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
-		spin_lock(shost->host_lock);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
@@ -3060,7 +3059,7 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	return 0;
 }
 
-static DEF_SCSI_QCMD(lpfc_queuecommand)
+static IRQ_DISABLE_SCSI_QCMD(lpfc_queuecommand)
 
 /**
  * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
-- 
1.7.3.4

