Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1EKSzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:55:37 -0400
Received: from nm7-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.116]:34290
	"HELO nm7-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754226Ab1EKSzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:55:33 -0400
X-Yahoo-Newman-Id: 699773.89979.bm@omp1019.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: MkFxV4wVM1kT9sV5q7bmHpvvY3sDRuauAo4G53_1fSgMf.H
 NHdXmAW21ETkUtOSZuLYSSNGmM0Hq.XPFrGrvequ99kQ70Hso47d39.ktU7k
 f31_qECjr_.lHfUIFxJIbu2XTZ1Ne83KRJy0i97pOQtpqV6l8IdDcgJhZMYa
 yHk4AZwqxYxvr29Mu9bF_Acq_XJkb3qV1t7DRKX2CoiGqr_TJBaRnI.fYwbn
 UKx.56aa_vUV0TyDay6vHmPGubAtmBYWB5qTxRSYS0nI2XAnNZOWKd2KlDIc
 l.0jC0I5PEYlMP9hXDoBY9wNiC7.KMMOq7G4w4_y_n0_t9I23HYdXoLzm0PI
 b2HC14QTqRbr75_Ur6KqzHWT_X3SCGAzqlM22RIx7OjBX7Q--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 3/4] target: Fix bug with task_sg chained transport_free_dev_tasks release
Date: Tue, 10 May 2011 21:35:34 -0700
Message-Id: <1305088535-27486-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
References: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
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

