Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0IPWgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:36:25 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.205]:45387 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756957Ab0IPWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:36:22 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 42PVPBgVM1k8nPpihjjdB6WC00A4da8XgKap3JmhDdK5HsF
 YxmlRoiSn.sjyWACL5ihq9a8N29mhKOIsJ3dXaqoynPmYxfGZVk2BKsz18Zw
 d6p1O6sYCCzGWv_NbMysFeL4eSa_rR5F9OrDP2ML40EpSJ6x_e2Mv5LFtc2C
 GWm8QpMsh.zHK50LhNxyv1GDitDXc_Lk1TM9P97h6A8T._6Fyhl4fADfwSxJ
 HZNpgjzAPdQflNWo4lHUMAMpjmF72XH.Syf2JTsHoCg4IaKRP7gQzHpPbviN
 KgQI._idkhHy9KDejqIHs.tadl6I0aObJfTHHh8.Y660CR5u4ATKAkM.G60p
 0D7sMBY5zLpbeNp_O7w--
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
Subject: [PATCH 7/8] tcm_loop: Remove host_lock unlock() + lock() from tcm_loop_queuecommand()
Date: Thu, 16 Sep 2010 15:36:18 -0700
Message-Id: <1284676578-10873-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from tcm_loop_fabric_scsi.c:tcm_loop_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index b95ed03..a0a1a55 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -324,8 +324,6 @@ static int tcm_loop_queuecommand(
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
-
-	spin_unlock_irq(host->host_lock);
 	/*
 	 * Locate the tcm_loop_hba_t pointer 
 	 */
@@ -345,7 +343,6 @@ static int tcm_loop_queuecommand(
 	 */
 	se_cmd = tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc);
 	if (!(se_cmd)) {
-		spin_lock_irq(host->host_lock);
 		sc->result = host_byte(DID_ERROR);
 		(*done)(sc);
 		return 0;
@@ -354,10 +351,6 @@ static int tcm_loop_queuecommand(
 	 * Queue up the newly allocated to be processed in TCM thread context.
 	*/
 	se_cmd->transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
-	/*
-	 * Reaquire the the struct scsi_host->host_lock before returning
-	 */
-	spin_lock_irq(host->host_lock);
 	return 0;
 }
 
-- 
1.7.2.3

