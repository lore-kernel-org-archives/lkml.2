Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936330Ab2C3Vrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:47:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965957Ab2C3VUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:42 -0400
Message-Id: <20120330194839.939657249@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 078/175] ib_srpt: Fix srpt_handle_cmd send_ioctx->ioctx_kref leak on exception
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 187e70a554e0f0717a65998bc9199945cbbd4692 upstream.

This patch addresses a bug in srpt_handle_cmd() failure handling where
send_ioctx->kref is being leaked with the local extra reference after init,
causing the expected kref_put() in srpt_handle_send_comp() to not be the final
call to invoke srpt_put_send_ioctx_kref() -> transport_generic_free_cmd() and
perform se_cmd descriptor memory release.

It also fixes a SCF_SCSI_RESERVATION_CONFLICT handling bug where this code
is incorrectly falling through to transport_handle_cdb_direct() after
invoking srpt_queue_status() to send SAM_STAT_RESERVATION_CONFLICT status.

Note this patch is for >= v3.3 mainline code, and current lio-core.git
code has already been converted to target_submit_cmd() + se_cmd->cmd_kref usage,
and internal ioctx->kref usage has been removed.  I'm including this patch
now into target-pending/for-next with a CC' for v3.3 stable.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1750,6 +1750,7 @@ static int srpt_handle_cmd(struct srpt_r
 		       srp_cmd->tag);
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
+		kref_put(&send_ioctx->kref, srpt_put_send_ioctx_kref);
 		goto send_sense;
 	}
 
@@ -1757,15 +1758,19 @@ static int srpt_handle_cmd(struct srpt_r
 	cmd->data_direction = dir;
 	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_cmd->lun,
 				       sizeof(srp_cmd->lun));
-	if (transport_lookup_cmd_lun(cmd, unpacked_lun) < 0)
+	if (transport_lookup_cmd_lun(cmd, unpacked_lun) < 0) {
+		kref_put(&send_ioctx->kref, srpt_put_send_ioctx_kref);
 		goto send_sense;
+	}
 	ret = transport_generic_allocate_tasks(cmd, srp_cmd->cdb);
-	if (cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
-		srpt_queue_status(cmd);
-	else if (cmd->se_cmd_flags & SCF_SCSI_CDB_EXCEPTION)
-		goto send_sense;
-	else
-		WARN_ON_ONCE(ret);
+	if (ret < 0) {
+		kref_put(&send_ioctx->kref, srpt_put_send_ioctx_kref);
+		if (cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT) {
+			srpt_queue_status(cmd);
+			return 0;
+		} else
+			goto send_sense;
+	}
 
 	transport_handle_cdb_direct(cmd);
 	return 0;


