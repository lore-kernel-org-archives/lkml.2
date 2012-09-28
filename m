Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031779Ab2I1UBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:01:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab2I1Szt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 043/262] target: simplify code around transport_get_sense_data
Date: Fri, 28 Sep 2012 11:49:32 -0700
Message-Id: <20120928183003.049761868@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 27a2709912ac19c755d34c79fe11994b0bf8082b upstream.

The error conditions in transport_get_sense_data are superfluous
and complicate the code unnecessarily:

* SCF_TRANSPORT_TASK_SENSE is checked in the caller;

* it's simply part of the invariants of dev->transport->get_sense_buffer
  that it must be there if transport_complete ever returns 1, and that
  it must not return NULL.  Besides, the entire callback will disappear
  with the next patch.

* similarly in the caller we can expect that sense data is only sent
  for non-zero cmd->scsi_status.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   49 ++++++++-------------------------
 1 file changed, 13 insertions(+), 36 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2261,7 +2261,7 @@ out:
 /*
  * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
  */
-static int transport_get_sense_data(struct se_cmd *cmd)
+static void transport_get_sense_data(struct se_cmd *cmd)
 {
 	unsigned char *buffer = cmd->sense_buffer, *sense_buffer = NULL;
 	struct se_device *dev = cmd->se_dev;
@@ -2271,30 +2271,15 @@ static int transport_get_sense_data(stru
 	WARN_ON(!cmd->se_lun);
 
 	if (!dev)
-		return 0;
+		return;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		return 0;
-	}
-
-	if (!(cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
-		goto out;
-
-	if (!dev->transport->get_sense_buffer) {
-		pr_err("dev->transport->get_sense_buffer is NULL\n");
-		goto out;
+		return;
 	}
 
 	sense_buffer = dev->transport->get_sense_buffer(cmd);
-	if (!sense_buffer) {
-		pr_err("ITT 0x%08x cmd %p: Unable to locate"
-			" sense buffer for task with sense\n",
-			cmd->se_tfo->get_task_tag(cmd), cmd);
-		goto out;
-	}
-
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	offset = cmd->se_tfo->set_fabric_sense_len(cmd, TRANSPORT_SENSE_BUFFER);
@@ -2306,11 +2291,6 @@ static int transport_get_sense_data(stru
 
 	pr_debug("HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x and sense\n",
 		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
-	return 0;
-
-out:
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-	return -1;
 }
 
 static inline long long transport_dev_end_lba(struct se_device *dev)
@@ -3171,7 +3151,7 @@ static void transport_handle_queue_full(
 static void target_complete_ok_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-	int reason = 0, ret;
+	int ret;
 
 	/*
 	 * Check if we need to move delayed/dormant tasks from cmds on the
@@ -3192,19 +3172,16 @@ static void target_complete_ok_work(stru
 	 * the struct se_cmd in question.
 	 */
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
-		if (transport_get_sense_data(cmd) < 0)
-			reason = TCM_NON_EXISTENT_LUN;
+		WARN_ON(!cmd->scsi_status);
+		transport_get_sense_data(cmd);
+		ret = transport_send_check_condition_and_sense(
+					cmd, 0, 1);
+		if (ret == -EAGAIN || ret == -ENOMEM)
+			goto queue_full;
 
-		if (cmd->scsi_status) {
-			ret = transport_send_check_condition_and_sense(
-					cmd, reason, 1);
-			if (ret == -EAGAIN || ret == -ENOMEM)
-				goto queue_full;
-
-			transport_lun_remove_cmd(cmd);
-			transport_cmd_check_stop_to_fabric(cmd);
-			return;
-		}
+		transport_lun_remove_cmd(cmd);
+		transport_cmd_check_stop_to_fabric(cmd);
+		return;
 	}
 	/*
 	 * Check for a callback, used by amongst other things


