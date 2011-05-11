Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab1ELCBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:01:21 -0400
Received: from nm16-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.19]:41722
	"HELO nm16-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755023Ab1ELCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:01:20 -0400
X-Greylist: delayed 25696 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 22:01:20 EDT
X-Yahoo-Newman-Id: 30012.51373.bm@omp1019.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 7uqcBF4VM1ky5YPXKHDWdB.JM3inJtL6Wu9XLtPx07.xdue
 Uj2DEXipBkjyp84dz7PJs5dPOcicUzKu8SD_yGmvCNHmbll0RBvkhFgJcEa8
 YFn72pO.kIwg4Qmp1k_tQuyjeJD0OWm5nN640fmi4Ps5w3Dnzsgko5YC0c.1
 hdwvf6fELkqfXJt.5FrPgZ88BoTgRIXoTVjox_FwLT2SBqrPYRwS.g5GeXIw
 _NY2gwdsBnsR2veNr5iFNfnVIdKbFPKkx5qNLPPnX.dmtohokbyQrK90gE9G
 FWSW1PV1UkSj1gUDCDWjWrQ8yeceZQuG55n3H9O0osYoRLPGJI5DdRC7gtuM
 33pb1rsqauhy7ihcJbMFdPXcqAqS06DEaxpPDvQkRPguTykM-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 4/4] target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
Date: Tue, 10 May 2011 21:35:35 -0700
Message-Id: <1305088535-27486-5-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
References: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
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

