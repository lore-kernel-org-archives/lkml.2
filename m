Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1ETDTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:19:41 -0400
Received: from nm13.access.bullet.mail.mud.yahoo.com ([66.94.237.214]:38595
	"HELO nm13.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757335Ab1ETDTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:19:38 -0400
X-Yahoo-Newman-Id: 730810.98554.bm@omp1004.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ULTxr1kVM1nNvGne2lLuEHFHKc.rFZUAl7tuWtKfWqnW6ka
 zTAS.35KCI1HIXuuQ5Zk6WXAs3_kyQ.0sM9BcVZweN6L8ZBuCeuGuGQM_CuD
 eCwjPVVill6Lh299_8._IsJMxnNxbBvruFxlk3sydcwXXbXtmCI7t_mEk0Aj
 5LIB8hKYqP_v9jo5vxqMgcNANO8UcznjQghIS_t.V.Kx_eAEVdU_ZPULj55H
 XhYawRHGYHRInYxAc6qi.dJrpQk3ep_B34AwDDo7X2Ua0gfvJUxeHwkcOheN
 Z3i5JKlb9aeI6Kbh3L8TkAjvxhf1aNjaulnYgoRP6m3BRTXj_ZnL_hVDr1Pk
 dFBrLpcfySmy2nku2PlW91GM-
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
Subject: [PATCH 4/6] target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
Date: Thu, 19 May 2011 20:19:12 -0700
Message-Id: <1305861554-29960-5-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug where task->task_execute_queue=1 was not being
cleared once se_task had been removed from se_device->execute_task_list,
resulting in an OOPs in core_tmr_lun_reset() for the task->task_active=0
case where transport_remove_task_from_execute_queue() was incorrectly
being called.

This patch fixes two cases in transport_get_task_from_execute_queue()
and transport_remove_task_from_execute_queue() to properly clear
task->task_execute_queue=0 once list_del(&task->t_execute_list) has
been called.

It also adds an explict check in transport_remove_task_from_execute_queue()
to dump_stack + return if called with task->task_execute_queue=0.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3eeb3e2..beaf8fa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1194,6 +1194,7 @@ transport_get_task_from_execute_queue(struct se_device *dev)
 		break;
 
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 
 	return task;
@@ -1209,8 +1210,14 @@ void transport_remove_task_from_execute_queue(
 {
 	unsigned long flags;
 
+	if (atomic_read(&task->task_execute_queue) == 0) {
+		dump_stack();
+		return;
+	}
+
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }
-- 
1.7.5.1

