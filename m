Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0IPWfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:35:37 -0400
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:42605 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756815Ab0IPWfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:35:36 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: hu2CZBkVM1nrcQl0NsIVGk3TEuzOHK6gaM6auBorGvE9oZ4
 gqPEQ_jmvvjr1itpCmIIeoIdnWq169bWGo5NHpMIOylstKFnZbUdHl8ZhbOM
 DGOTV9sHdkQGUa4Ld1z4g0Impbf3RpPyhkq_UHQgxQ5AfGLSvyaHyiFAeFcL
 FzlDsXUx5S3ewm4672jJiZ7vQ8z6XejDMpiD0oekgEQJsDEqgTBxaql5y_nJ
 562iFGLAA02MKYQQ4RXuAjqgem3Dppx8RbzcbqYjtSthiSxWnC814kk0UNmv
 gdS6M3Ojc5FgAhscgNC6oZCyMubxeCycAWffcpLfheYexCpLV2w--
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
Subject: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
Date: Thu, 16 Sep 2010 15:35:29 -0700
Message-Id: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts scsi_dispatch_cmd() to only hold struct Scsi_Host->host_lock
for scsi_cmd_get_serial(), and drops the lock because the call into
the LLD with host->hostt->queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..06e5b3a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -745,6 +745,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	 * TODO: kill serial or move to blk layer
 	 */
 	scsi_cmd_get_serial(host, cmd); 
+	spin_unlock_irqrestore(host->host_lock, flags);
 
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
@@ -753,7 +754,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
-- 
1.7.2.3

