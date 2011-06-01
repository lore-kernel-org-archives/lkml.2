Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162561Ab1FAIVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:21:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:44636 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162552Ab1FAIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:21:35 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:33 2011
Message-Id: <20110601081133.168565620@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:43 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [073/165] [SCSI] target: Fix bug with task_sg chained
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 transport_free_dev_tasks release
Content-Length: 3527
Lines: 92

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f436677262a5b524ac87675014c6d4e8ee153029 upstream.

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
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |   13 ++++++++++++-
 include/target/target_core_base.h      |    1 +
 include/target/target_core_transport.h |    1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -762,7 +762,6 @@ static void transport_lun_remove_cmd(str
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
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -98,6 +98,7 @@ enum transport_state_table {
 	TRANSPORT_REMOVE	= 14,
 	TRANSPORT_FREE		= 15,
 	TRANSPORT_NEW_CMD_MAP	= 16,
+	TRANSPORT_FREE_CMD_INTR = 17,
 };
 
 /* Used for struct se_cmd->se_cmd_flags */
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -172,6 +172,7 @@ extern int transport_generic_handle_cdb_
 extern int transport_generic_handle_data(struct se_cmd *);
 extern void transport_new_cmd_failure(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
+extern void transport_generic_free_cmd_intr(struct se_cmd *);
 extern void __transport_stop_task_timer(struct se_task *, unsigned long *);
 extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
 extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *, u32,


