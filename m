Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2LMOD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab2LMODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 043/241] target: Fix incorrect usage of nested IRQ spinlocks in ABORT_TASK path
Date: Thu, 13 Dec 2012 11:56:48 -0200
Message-Id: <1355407206-17100-44-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Hodgson <steve@purestorage.com>

commit ab74b3d62f05192bf8fb8f169e7999d1183b2e08 upstream.

This patch changes core_tmr_abort_task() to use spin_lock -> spin_unlock
around se_cmd->t_state_lock while spin_lock_irqsave is held via
se_sess->sess_cmd_lock.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_tmr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 84caf1b..eac70676 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -140,15 +140,15 @@ void core_tmr_abort_task(
 		printk("ABORT_TASK: Found referenced %s task_tag: %u\n",
 			se_cmd->se_tfo->get_fabric_name(), ref_tag);
 
-		spin_lock_irq(&se_cmd->t_state_lock);
+		spin_lock(&se_cmd->t_state_lock);
 		if (se_cmd->transport_state & CMD_T_COMPLETE) {
 			printk("ABORT_TASK: ref_tag: %u already complete, skipping\n", ref_tag);
-			spin_unlock_irq(&se_cmd->t_state_lock);
+			spin_unlock(&se_cmd->t_state_lock);
 			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 			goto out;
 		}
 		se_cmd->transport_state |= CMD_T_ABORTED;
-		spin_unlock_irq(&se_cmd->t_state_lock);
+		spin_unlock(&se_cmd->t_state_lock);
 
 		list_del_init(&se_cmd->se_cmd_list);
 		kref_get(&se_cmd->cmd_kref);
-- 
1.7.9.5

