Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab1ETDTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:19:37 -0400
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:20313
	"HELO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757335Ab1ETDTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:19:34 -0400
X-Yahoo-Newman-Id: 952925.50609.bm@omp1009.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: oZmJldEVM1mJ9l_oltkBXV7LXK8txtiNrBJt26xQct3WUO8
 m2jjZlR90ASkjZvd43Nzf2GNNUyb7vzAAIElWZwiYMSpRAL6JgqFzRvsaf7Y
 ZEOm1PA_kx3LSIHhWkBv0EN_HZkWiOutpzjMZIHauEsQZLTV8pzfW9UWFflx
 8nGTpn0t5YnCsvkGYoiKcRi19G3e.FpekjzwA8AJJ1qjAXgi7.NGaRJ684VI
 48FaSN4re6rVyOFFRYRc5Vij73_s3it7nAwk_EzB3A1x9Q4VrSRAVYJkiecR
 ZJWuoIXlvyziQ_JdZBVC7D2CRsMvH21toMSrflK6nsyx29hWYTdLx8UfZGjf
 n8WmSoguqhQVvPOBFHPTQ1Sk-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3/6] target: Fix bug with task_sg chained transport_free_dev_tasks release
Date: Thu, 19 May 2011 20:19:11 -0700
Message-Id: <1305861554-29960-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug in the target core release path for HW
operation where transport_free_dev_tasks() was incorrectly being called
from transport_lun_remove_cmd() while releasing a se_cmd reference and
calling struct target_core_fabric_ops->queue_data_in().

This would result in a OOPs with HW target mode when the release of
se_task->task_sg[] would happen before pci_unmap_sg() can be called in
HW target mode fabric module code.  This patch addresses the issue by
moving transport_free_dev_tasks() from transport_lun_remove_cmd() into
transport_generic_free_cmd(), and adding TRANSPORT_FREE_CMD_INTR and
transport_generic_free_cmd_intr() to allow se_cmd descriptor release
to happen fromfrom within transport_processing_thread() process context
when release of se_cmd is not possible from HW interrupt context.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   13 ++++++++++++-
 include/target/target_core_base.h      |    1 +
 include/target/target_core_transport.h |    1 +
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fefe10a..3eeb3e2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -762,7 +762,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 	transport_all_task_dev_remove_state(cmd);
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
-	transport_free_dev_tasks(cmd);
 
 check_lun:
 	spin_lock_irqsave(&lun->lun_cmd_lock, flags);
@@ -2058,6 +2057,13 @@ int transport_generic_handle_tmr(
 }
 EXPORT_SYMBOL(transport_generic_handle_tmr);
 
+void transport_generic_free_cmd_intr(
+	struct se_cmd *cmd)
+{
+	transport_add_cmd_to_queue(cmd, TRANSPORT_FREE_CMD_INTR);
+}
+EXPORT_SYMBOL(transport_generic_free_cmd_intr);
+
 static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 {
 	struct se_task *task, *task_tmp;
@@ -5301,6 +5307,8 @@ void transport_generic_free_cmd(
 		if (wait_for_tasks && cmd->transport_wait_for_tasks)
 			cmd->transport_wait_for_tasks(cmd, 0, 0);
 
+		transport_free_dev_tasks(cmd);
+
 		transport_generic_remove(cmd, release_to_pool,
 				session_reinstatement);
 	}
@@ -6136,6 +6144,9 @@ get_cmd:
 		case TRANSPORT_REMOVE:
 			transport_generic_remove(cmd, 1, 0);
 			break;
+		case TRANSPORT_FREE_CMD_INTR:
+			transport_generic_free_cmd(cmd, 0, 1, 0);
+			break;
 		case TRANSPORT_PROCESS_TMR:
 			transport_generic_do_tmr(cmd);
 			break;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1d3b5b2..561ac99 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -98,6 +98,7 @@ enum transport_state_table {
 	TRANSPORT_REMOVE	= 14,
 	TRANSPORT_FREE		= 15,
 	TRANSPORT_NEW_CMD_MAP	= 16,
+	TRANSPORT_FREE_CMD_INTR = 17,
 };
 
 /* Used for struct se_cmd->se_cmd_flags */
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 59aa464..24a1c6c 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -172,6 +172,7 @@ extern int transport_generic_handle_cdb_map(struct se_cmd *);
 extern int transport_generic_handle_data(struct se_cmd *);
 extern void transport_new_cmd_failure(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
+extern void transport_generic_free_cmd_intr(struct se_cmd *);
 extern void __transport_stop_task_timer(struct se_task *, unsigned long *);
 extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
 extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *, u32,
-- 
1.7.5.1

