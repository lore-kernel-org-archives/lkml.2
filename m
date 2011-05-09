Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1EIQoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:44:25 -0400
Received: from nm12-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.11]:23031
	"HELO nm12-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753684Ab1EIQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:44:21 -0400
X-Yahoo-Newman-Id: 283345.34228.bm@omp1024.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: b2xsy6AVM1lyPcWBhB_bdXyU9LN2ScR3ZAV5Atyu9cWWe7f
 spG5stRegLrSF7mOhgyvbYEUE5XaLGtWxC.oHYFsFfTM5.SoiMKqphSAIbWY
 C5xOR3DK3J1pnY4kOcKIZCPezqQdKBzBn4RFenkt3D0hUBt1BIls81xo0fPF
 jOiOOGhXNiSWUPfYiRzv8cDm4j6J63xHQSBgHxPxdiw.3P8JOeBJI7753rGk
 pSSRINqxcUiQVALZUFH6jUHjnqvr1zRaEx0fIiD27uj7HcpmS2qyTo_QoOpp
 5B_NV6RVaBXzhztyDBUWTeGo6WPXW.C8M0j3ZK1..TGKQqBvG7nJYw3RCH8b
 WRjtCo2_RTChjDbYl6CmUB8_RVLTgTlfcv71.02wZsH.WeNXbmRBWrVIPmLl
 jQv0SMZmS6tiTKKAW0QU_KqFRBOkr99hjf9TE9ao0iZmlrQdKfp2zok37nJF
 ivsPO0ZCLpc3oLUEchCpP
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
Date: Mon,  9 May 2011 09:44:16 -0700
Message-Id: <1304959456-21647-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

This is one more (and hopefully the last) critical target bugfix that needs
to be sent to Linus for .39.  Also please CC stable@kernel.org to ensure
this bugfix makes it into .38.x along with the previous three part series here:

[PATCH 0/3] target: Bugfixes for .39-rc7
http://marc.info/?l=linux-scsi&m=130479565027757&w=2

The original three part for-39 series together with this patch are available
directly here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-rc-fixes


Please review and merge.

Thanks,

--nab

---------------------------------------------------------------------------

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

