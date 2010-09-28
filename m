Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab0I1CHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:07:05 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:32655 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933005Ab0I1CG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:06:59 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ZkQriIAVM1kjutPmxoIumr_u82cr7mw1PvkjtUf5n4_aigs
 AnhvKZVAdf_wwg3pc5f7U6kBkcQ_5TtN_k5yv98yILALywwpIFcclIAueVfH
 4zmd5Of_Q12hl_PhkiYWJLfwq5jj7jCjTrbSgwY1f8YixJ3KjYOq0WYutrok
 DDKPDG7xqSJUXvGs8r.dbYtjMGR_vdpC4bcAlHSVgjDFo9QLQnTYJPrCSb2x
 ANejkDqBfWPemO6RAUlxY7VClpdDa0kfA83_uvDEZxyqxLSabOJzak4tC2Jk
 zyGrZ7IYOVtX__powk6SkPO8xSxzfCDPrOvw1lCHXLjE-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v4 10/19] lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
Date: Mon, 27 Sep 2010 19:06:52 -0700
Message-Id: <1285639612-7405-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from lpfc_scsi.c:lpfc_queuecommand().  This also includes setting the
SHT->unlocked_qcmd=1 for host_lock less lpfc lpfc_queuecommand() operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2e51aa6..69fe31e 100644
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
@@ -3723,6 +3721,7 @@ struct scsi_host_template lpfc_template = {
 	.slave_destroy		= lpfc_slave_destroy,
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
+	.unlocked_qcmd		= 1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -3746,6 +3745,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.slave_destroy		= lpfc_slave_destroy,
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
+	.unlocked_qcmd		= 1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
-- 
1.7.3

