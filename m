Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0IPWf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:35:59 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:36285 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755765Ab0IPWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:35:57 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ywfP1zEVM1kpUu5cCIislWmq8xPD3MwOZpElnngvdy6AE63
 P92Ag14UIDJCwnB9UOYSCAvuYnH7YwWnlqhTq8sVCGrFZ.G0Haq0b7IZZq1t
 EjjoPnn9tSOttRB7pLSL01Z8T32IHQiJ_WREn.Qe5ImKYIu8MNQ2_t9CW21W
 pdy4GBwurx62EqLI.HKdc_klkzubTcuMyXnKHEiMdxJ1IrY23aPBlHjUL4gH
 NS9vp3FQNkl4eGeY8yb_SumLAW0vdmyLK8lvz26ZuivaskD9eQA99arHSn0N
 v3ha636710NBYc9hIbJOWM9xkdKuNrb4l3x06yGrOXTCaFDfdQ1eAQWBCarv
 ls3oOxjfX3Lp25oN6Ag--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 4/8] lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
Date: Thu, 16 Sep 2010 15:35:54 -0700
Message-Id: <1284676554-10816-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from lpfc_scsi.c:lpfc_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2e51aa6..4b085f6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3023,11 +3023,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
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
-- 
1.7.2.3

