Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0IQSWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:22:33 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.105]:43044 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754362Ab0IQSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:22:31 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: VFtGMBwVM1kaW9Y4Dr._PtxZ1NkrGxiXgkfqlJYw5jlwyEv
 Q2k6__ay6IXpTMhw_aKo_Z5BlmS0SJvprQh88miP2_GIifT.aEcQKHs_1Ybu
 tLHdt5Qu.utYAS4rUdydqqnKsiuUCQjEven.qT1KSgdoxA4vBcB8u6OxggSU
 2xXffy0NqxafYB9LKRxgtE_C5ab1J3Ng82czf1h5nvxFEEgQMHWG4_Fk.vt0
 13.l_dZ_DEg6PlPpoy7u2GzeSGPNGp886C9.3Zz7YtpN5mgLl0cjB4pE_gh0
 dQnyL14boz2kC7nwB47DuWLGbopqrpJRwpUWkv9ioErXNhP08XCQ-
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
Subject: [PATCH v2 05/11] libfc: Remove host_lock unlock() + lock() from fc_queuecommand()
Date: Fri, 17 Sep 2010 11:22:26 -0700
Message-Id: <1284747746-20938-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
fc_fcp.c:fc_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libfc/fc_fcp.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..140cd94 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1751,8 +1751,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
  * @cmd:   The scsi_cmnd to be executed
  * @done:  The callback function to be called when the scsi_cmnd is complete
  *
- * This is the i/o strategy routine, called by the SCSI layer. This routine
- * is called with the host_lock held.
+ * This is the i/o strategy routine, called by the SCSI layer.
  */
 int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 {
@@ -1772,7 +1771,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		done(sc_cmd);
 		return 0;
 	}
-	spin_unlock_irq(lport->host->host_lock);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*
@@ -1849,7 +1847,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 out:
-	spin_lock_irq(lport->host->host_lock);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
-- 
1.7.2.3

