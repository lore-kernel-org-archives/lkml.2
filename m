Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1HaFML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 01:12:11 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43032 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1HaFMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 01:12:08 -0400
From: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Subject: [PATCH 1/1] fs-writeback: Using spin_lock to check for work_list empty
Date: Wed, 31 Aug 2011 10:41:49 +0530
Message-Id: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bdi_writeback_thread function does not use spin_lock to
see if the work_list is empty.

If the list is not empty, and if an interrupt happens before we
set the current->state to TASK_RUNNING then we could be stuck in
a schedule() due to kernel preemption.

This patch acquires and releases the wb_lock to avoid this scenario.

Signed-off-by: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
---
 fs/fs-writeback.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 04cf3b9..e333898 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -936,11 +936,14 @@ int bdi_writeback_thread(void *data)
 		if (pages_written)
 			wb->last_active = jiffies;
 
+		spin_lock_bh(&bdi->wb_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
 			__set_current_state(TASK_RUNNING);
+			spin_unlock_bh(&bdi->wb_lock);
 			continue;
 		}
+		spin_unlock_bh(&bdi->wb_lock);
 
 		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
 			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-- 
1.7.4.1

