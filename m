Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab2IEPJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:09:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54127 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2IEPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:09:38 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org
Subject: [PATCH 3.6 1/3] target: move transport_get_sense_data
Date: Wed,  5 Sep 2012 17:09:13 +0200
Message-Id: <1346857755-10224-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
References: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will be calling it from transport_complete_cmd, avoid forward
declarations.  No semantic change.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_transport.c |  110 ++++++++++++++++----------------
 1 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4de3186..9f5ff8d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -567,6 +567,61 @@ static void target_complete_failure_work(struct work_struct *work)
 	transport_generic_request_failure(cmd);
 }
 
+/*
+ * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
+ */
+static int transport_get_sense_data(struct se_cmd *cmd)
+{
+	unsigned char *buffer = cmd->sense_buffer, *sense_buffer = NULL;
+	struct se_device *dev = cmd->se_dev;
+	unsigned long flags;
+	u32 offset = 0;
+
+	WARN_ON(!cmd->se_lun);
+
+	if (!dev)
+		return 0;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		return 0;
+	}
+
+	if (!(cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
+		goto out;
+
+	if (!dev->transport->get_sense_buffer) {
+		pr_err("dev->transport->get_sense_buffer is NULL\n");
+		goto out;
+	}
+
+	sense_buffer = dev->transport->get_sense_buffer(cmd);
+	if (!sense_buffer) {
+		pr_err("ITT 0x%08x cmd %p: Unable to locate"
+			" sense buffer for task with sense\n",
+			cmd->se_tfo->get_task_tag(cmd), cmd);
+		goto out;
+	}
+
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
+	offset = cmd->se_tfo->set_fabric_sense_len(cmd, TRANSPORT_SENSE_BUFFER);
+
+	memcpy(&buffer[offset], sense_buffer, TRANSPORT_SENSE_BUFFER);
+
+	/* Automatically padded */
+	cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER + offset;
+
+	pr_debug("HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x and sense\n",
+		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
+	return 0;
+
+out:
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	return -1;
+}
+
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1816,61 +1871,6 @@ execute:
 EXPORT_SYMBOL(target_execute_cmd);
 
 /*
- * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
- */
-static int transport_get_sense_data(struct se_cmd *cmd)
-{
-	unsigned char *buffer = cmd->sense_buffer, *sense_buffer = NULL;
-	struct se_device *dev = cmd->se_dev;
-	unsigned long flags;
-	u32 offset = 0;
-
-	WARN_ON(!cmd->se_lun);
-
-	if (!dev)
-		return 0;
-
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		return 0;
-	}
-
-	if (!(cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
-		goto out;
-
-	if (!dev->transport->get_sense_buffer) {
-		pr_err("dev->transport->get_sense_buffer is NULL\n");
-		goto out;
-	}
-
-	sense_buffer = dev->transport->get_sense_buffer(cmd);
-	if (!sense_buffer) {
-		pr_err("ITT 0x%08x cmd %p: Unable to locate"
-			" sense buffer for task with sense\n",
-			cmd->se_tfo->get_task_tag(cmd), cmd);
-		goto out;
-	}
-
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
-	offset = cmd->se_tfo->set_fabric_sense_len(cmd, TRANSPORT_SENSE_BUFFER);
-
-	memcpy(&buffer[offset], sense_buffer, TRANSPORT_SENSE_BUFFER);
-
-	/* Automatically padded */
-	cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER + offset;
-
-	pr_debug("HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x and sense\n",
-		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
-	return 0;
-
-out:
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-	return -1;
-}
-
-/*
  * Process all commands up to the last received ORDERED task attribute which
  * requires another blocking boundary
  */
-- 
1.7.1


