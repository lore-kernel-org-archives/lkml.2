Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0IPWgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:36:11 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.105]:42162 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756884Ab0IPWgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:36:08 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: VJ3v5bgVM1l3edtVOpk7fAmQOmRNKt1YnJTrilDf6nIF_p8
 Msx6N1cWQAAAdghzRisK3KNfDePhOghJ5WUKsKg55l.swh9cGpCqi4MAbh.L
 7BlhUxRq0CPrwxGfA1CwWfVaSGfYxlWxQDeC_RtBQLQAJYM1s3HSkvAJvqcI
 89o2CAUM6B.eyq21t1KKIggEuXrEZ9TvfWlrYLMaMeq6_auKbR.E8gtTj1jv
 Kgrmwfl3MOY8pM6v2aaS4kH.glJ7zfLBHsz0QOXyQnU3_LuDb9QpR0ex0St2
 u6.EE5NWqxpKmE4DrlSRgtcmfv8qyJF_zmu.f3hWee0gxOL2ti8NlLw--
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
Subject: [PATCH 5/8] qla4xxx: Remove host_lock unlock() + lock() from qla4xxx_queuecommand()
Date: Thu, 16 Sep 2010 15:36:02 -0700
Message-Id: <1284676562-10835-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from ql4_os.c:qla4xxx_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla4xxx/ql4_os.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 370d40f..cfbe8b5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -511,26 +511,20 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
-	spin_unlock_irq(ha->host->host_lock);
-
 	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
 	if (!srb)
-		goto qc_host_busy_lock;
+		goto qc_host_busy;
 
 	rval = qla4xxx_send_command_to_isp(ha, srb);
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
 	return 0;
 
 qc_host_busy_free_sp:
 	qla4xxx_srb_free_dma(ha, srb);
 	mempool_free(srb, ha->srb_mempool);
 
-qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
-
 qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
-- 
1.7.2.3

