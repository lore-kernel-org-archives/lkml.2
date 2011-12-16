Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab1LPTtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:49:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175Ab1LPTs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:57 2011
Message-Id: <20111216194557.585725562@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [22/53] iscsi-target: Fix residual count hanlding + remove iscsi_cmd->residual_count
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7e46cf02687e40197ae07c623e660be2a2720064 upstream.

This patch fixes iscsi-target handling of underflow where residual data is
causing an OOPs by using the incorrect iscsi_cmd_t->data_length initially
assigned in iscsit_allocate_se_cmd().  It resets iscsi_cmd_t->data_length
from se_cmd_t->data_length after transport_generic_allocate_tasks()
has been invoked in iscsit_handle_scsi_cmd() RX context, and converts
iscsi_cmd->residual_count usage to access iscsi_cmd->se_cmd.residual_count
to get the proper residual count set by target-core.

Reported-by: <lists@internyc.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/iscsi/iscsi_target.c      |   10 ++++++----
 drivers/target/iscsi/iscsi_target_core.h |    1 -
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1043,6 +1043,8 @@ done:
 		 */
 		send_check_condition = 1;
 	} else {
+		cmd->data_length = cmd->se_cmd.data_length;
+
 		if (iscsit_decide_list_to_build(cmd, payload_length) < 0)
 			return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
@@ -2512,10 +2514,10 @@ static int iscsit_send_data_in(
 	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
 		if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
 			hdr->flags |= ISCSI_FLAG_DATA_OVERFLOW;
-			hdr->residual_count = cpu_to_be32(cmd->residual_count);
+			hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
 		} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			hdr->flags |= ISCSI_FLAG_DATA_UNDERFLOW;
-			hdr->residual_count = cpu_to_be32(cmd->residual_count);
+			hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
 		}
 	}
 	hton24(hdr->dlength, datain.length);
@@ -3017,10 +3019,10 @@ static int iscsit_send_status(
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
 	if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
 		hdr->flags |= ISCSI_FLAG_CMD_OVERFLOW;
-		hdr->residual_count = cpu_to_be32(cmd->residual_count);
+		hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
 	} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
 		hdr->flags |= ISCSI_FLAG_CMD_UNDERFLOW;
-		hdr->residual_count = cpu_to_be32(cmd->residual_count);
+		hdr->residual_count = cpu_to_be32(cmd->se_cmd.residual_count);
 	}
 	hdr->response		= cmd->iscsi_response;
 	hdr->cmd_status		= cmd->se_cmd.scsi_status;
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -395,7 +395,6 @@ struct iscsi_cmd {
 	u32			pdu_send_order;
 	/* Current struct iscsi_pdu in struct iscsi_cmd->pdu_list */
 	u32			pdu_start;
-	u32			residual_count;
 	/* Next struct iscsi_seq to send in struct iscsi_cmd->seq_list */
 	u32			seq_send_order;
 	/* Number of struct iscsi_seq in struct iscsi_cmd->seq_list */


