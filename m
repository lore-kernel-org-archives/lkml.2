Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2IGPdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:33:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2IGPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:15 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 06/11] target: go through normal processing for zero-length REQUEST_SENSE
Date: Fri,  7 Sep 2012 17:30:37 +0200
Message-Id: <1347031842-2531-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that spc_emulate_request_sense has been taught to process zero-length
REQUEST SENSE correctly, drop the special handling of unit attention
conditions from transport_generic_new_cmd.  However, for now REQUEST SENSE
will be the only command that goes through emulation for zero lengths.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_transport.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8facb74..09d9279 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2301,6 +2301,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 	 * away.
 	 */
 	if (!cmd->data_length &&
+	    cmd->t_task_cdb[0] != REQUEST_SENSE &&
 	    (cmd->se_dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV ||
 	     cmd->t_task_cdb[0] == REPORT_LUNS) {
 		spin_lock_irq(&cmd->t_state_lock);
@@ -2308,13 +2309,6 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 		cmd->transport_state |= CMD_T_ACTIVE;
 		spin_unlock_irq(&cmd->t_state_lock);
 
-		if (cmd->t_task_cdb[0] == REQUEST_SENSE) {
-			u8 ua_asc = 0, ua_ascq = 0;
-
-			core_scsi3_ua_clear_for_request_sense(cmd,
-					&ua_asc, &ua_ascq);
-		}
-
 		INIT_WORK(&cmd->work, target_complete_ok_work);
 		queue_work(target_completion_wq, &cmd->work);
 		return 0;
-- 
1.7.1


