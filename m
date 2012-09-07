Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2IGPbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2IGPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:35 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 11/11] target: go through normal processing for all zero-length commands
Date: Fri,  7 Sep 2012 17:30:42 +0200
Message-Id: <1347031842-2531-12-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yay, all users of transport_kmap_data_sg now check for a zero-length
request and/or a too-small parameter list length.  We can thus go through
the normal emulation path even for such commands.

This means that out-of-bounds reads and writes are now reported correctly
even if they transfer 0 blocks.  Other errors are also reported correctly.

Testcase: sg_raw /dev/sdb 28 00 80 00 00 00 00 00 00 00
    should fail with ILLEGAL REQUEST / LBA OUT OF RANGE sense
    does not fail without the patch
    (still wrong with the patch, but better: the ASC is INVALID FIELD IN CDB)

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_transport.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 09d9279..c071d0b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2295,24 +2295,6 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 		if (ret < 0)
 			goto out_fail;
 	}
-	/*
-	 * If this command doesn't have any payload and we don't have to call
-	 * into the fabric for data transfers, go ahead and complete it right
-	 * away.
-	 */
-	if (!cmd->data_length &&
-	    cmd->t_task_cdb[0] != REQUEST_SENSE &&
-	    (cmd->se_dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV ||
-	     cmd->t_task_cdb[0] == REPORT_LUNS) {
-		spin_lock_irq(&cmd->t_state_lock);
-		cmd->t_state = TRANSPORT_COMPLETE;
-		cmd->transport_state |= CMD_T_ACTIVE;
-		spin_unlock_irq(&cmd->t_state_lock);
-
-		INIT_WORK(&cmd->work, target_complete_ok_work);
-		queue_work(target_completion_wq, &cmd->work);
-		return 0;
-	}
 
 	atomic_inc(&cmd->t_fe_count);
 
-- 
1.7.1
