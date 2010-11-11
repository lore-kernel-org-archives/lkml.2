Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0KKKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:25:28 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:20261 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754372Ab0KKKZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:25:27 -0500
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: p9Zv5hUVM1l5utNxfQ75fcxFKHkt.6l5pLjaJYBoAjh77lL
 WWaPET5ejWxtl.C_FuqD_drJYNedeIjFQcmxC8jtc2cNCz.I.eMXDquaMzyf
 7MOgpZINSXIcSZlUatqhVoS4qT_oGMPYLcrL.lrWK4Ug0gQxN9cK3do54zLg
 dTZPDh5kKUPwUVmAxeTthyrLV7qqjgb6BWp_AkLVJziL55k5W12sCbNcAaxi
 yn3aJCafa2cG.VMFcmmmh_I1xvkANmv42NvxuNG4Vxh9rqFwHA0GYKNhKGda
 bt7BaYqyjh30MJehklGMJ0vdQZnJSYikTf9CW6BsCEebrKa95DWZsU6AfvH8
 OZEOHM3f_EIuJego7O4hj_g.shA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jeff@garzik.org>,
        James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] tcm_loop: Drop legacy host_lock usage in SHT->queuecommand() caller
Date: Thu, 11 Nov 2010 02:25:23 -0800
Message-Id: <1289471123-29097-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Following the the great host lock push-down in 3039f3ffcc5, this patch drops
the historical optimization (and most certain deadlock) of:

	 spin_unlock_irq(host_lock); do_some_lld_work(); spin_lock_irq(host_lock)

from within tcm_loop_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 80f2940..8175681 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -311,7 +311,6 @@ static int tcm_loop_queuecommand(
 {
 	struct se_cmd *se_cmd;
 	struct se_portal_group *se_tpg;
-	struct Scsi_Host *host = sc->device->host;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 
@@ -321,8 +320,6 @@ static int tcm_loop_queuecommand(
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
-
-	spin_unlock_irq(host->host_lock);
 	/*
 	 * Locate the tcm_loop_hba_t pointer 
 	 */
@@ -342,7 +339,6 @@ static int tcm_loop_queuecommand(
 	 */
 	se_cmd = tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc);
 	if (!(se_cmd)) {
-		spin_lock_irq(host->host_lock);
 		sc->result = host_byte(DID_ERROR);
 		(*done)(sc);
 		return 0;
@@ -351,10 +347,6 @@ static int tcm_loop_queuecommand(
 	 * Queue up the newly allocated to be processed in TCM thread context.
 	*/
 	transport_generic_handle_cdb_map(se_cmd);
-	/*
-	 * Reaquire the the struct scsi_host->host_lock before returning
-	 */
-	spin_lock_irq(host->host_lock);
 	return 0;
 }
 
-- 
1.5.6.5

