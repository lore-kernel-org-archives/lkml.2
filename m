Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab2IEPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:10:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34973 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2IEPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:09:42 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org
Subject: [PATCH 3.6 2/3] target: simplify code around transport_get_sense_data
Date: Wed,  5 Sep 2012 17:09:14 +0200
Message-Id: <1346857755-10224-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
References: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/target/target_core_transport.c |   51 +++++++++-----------------------
 1 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9f5ff8d..ea01807 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -570,7 +570,7 @@ static void target_complete_failure_work(struct work_struct *work)
 /*
  * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
  */
-static int transport_get_sense_data(struct se_cmd *cmd)
+static void transport_get_sense_data(struct se_cmd *cmd)
 {
 	unsigned char *buffer = cmd->sense_buffer, *sense_buffer = NULL;
 	struct se_device *dev = cmd->se_dev;
@@ -580,30 +580,15 @@ static int transport_get_sense_data(struct se_cmd *cmd)
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
@@ -615,11 +600,6 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 
 	pr_debug("HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x and sense\n",
 		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
-	return 0;
-
-out:
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-	return -1;
 }
 
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
@@ -1985,7 +1965,7 @@ static void transport_handle_queue_full(
 static void target_complete_ok_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-	int reason = 0, ret;
+	int ret;
 
 	/*
 	 * Check if we need to move delayed/dormant tasks from cmds on the
@@ -2006,19 +1986,16 @@ static void target_complete_ok_work(struct work_struct *work)
 	 * the struct se_cmd in question.
 	 */
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
-		if (transport_get_sense_data(cmd) < 0)
-			reason = TCM_NON_EXISTENT_LUN;
-
-		if (cmd->scsi_status) {
-			ret = transport_send_check_condition_and_sense(
-					cmd, reason, 1);
-			if (ret == -EAGAIN || ret == -ENOMEM)
-				goto queue_full;
+		WARN_ON(!cmd->scsi_status);
+		transport_get_sense_data(cmd);
+		ret = transport_send_check_condition_and_sense(
+					cmd, 0, 1);
+		if (ret == -EAGAIN || ret == -ENOMEM)
+			goto queue_full;
 
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
-- 
1.7.1


