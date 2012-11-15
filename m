Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab2KOEZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:25:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:49662 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993171Ab2KOEMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 10/57] target: Fix incorrect usage of nested IRQ spinlocks in ABORT_TASK path
Date: Wed, 14 Nov 2012 20:11:18 -0800
Message-Id: <20121115040933.850020370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Hodgson <steve@purestorage.com>

commit ab74b3d62f05192bf8fb8f169e7999d1183b2e08 upstream.

This patch changes core_tmr_abort_task() to use spin_lock -> spin_unlock
around se_cmd->t_state_lock while spin_lock_irqsave is held via
se_sess->sess_cmd_lock.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_tmr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


