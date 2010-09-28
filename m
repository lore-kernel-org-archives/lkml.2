Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab0I1CHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:07:24 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:44710 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933632Ab0I1CHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:07:17 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 5X.S3PIVM1kdPHQjkwIB7iesCryCmP2rleD92Q7TWE9WUfa
 wlD7B_Kxzf6llihoSmRFRiBkApXOcl343NZop10j6ZswwnSRo6PrR3fboy.K
 bBKEreSCQ7qfLUuWj7afO_iHIrWyhCBCMXJ_FssmisQmq5dXinyhE.r19s2p
 VB_BdjffcLw.EK3QEuGCoYlV1QbuMmb0Au_hX2I.1_aguAPKx0bmvxUbbJnz
 .2QPvrdeU4KtUfCh8u68vs2pVfNarNUyFNIhHVAK30G9FOLX9v0Vse4vourL
 fhW.rS9xgzSEKh00RFNsh0m2rmJBZgxyi70Tq_eYnHss-
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
Subject: [RFC v4 12/19] qla2xxx: Remove host_lock unlock() + lock() from qla2xxx_queuecommand()
Date: Mon, 27 Sep 2010 19:07:12 -0700
Message-Id: <1285639632-7445-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from qla_os.c:qla2xxx_queuecommand().  This also includes setting the
SHT->unlocked_qcmd=1 for host_lock less qla2xxx qla2xxx_queuecommand operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e4bff6..5654f1b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -204,6 +204,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= qla2x00_change_queue_depth,
 	.change_queue_type	= qla2x00_change_queue_type,
+	.unlocked_qcmd		= 1,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -574,11 +575,9 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		goto qc24_target_busy;
 	}
 
-	spin_unlock_irq(vha->host->host_lock);
-
 	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
 	if (!sp)
-		goto qc24_host_busy_lock;
+		goto qc24_host_busy;
 
 	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
@@ -592,8 +591,7 @@ qc24_host_busy_free_sp:
 	qla2x00_sp_free_dma(sp);
 	mempool_free(sp, ha->srb_mempool);
 
-qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
+qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
-- 
1.7.3

