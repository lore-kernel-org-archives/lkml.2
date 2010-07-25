Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0GYIaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:30:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:33041 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0GYIak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:30:40 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 02/15] writeback: fix possible race when creating bdi threads
Date: Sun, 25 Jul 2010 11:29:28 +0300
Message-Id: <1280046581-23623-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:44.0648 (UTC) FILETIME=[88FBAC80:01CB2BD3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch fixes a very unlikely race condition on the bdi forker thread error
path: when bdi thread creation fails, 'bdi->wb.task' may contain the error code
for a short period of time. If at the same time someone submits a work to this
bdi, we can end up with an oops 'bdi_queue_work()' while executing
'wake_up_process(wb->task)'.

This patch fixes the issue by introducing a temporary variable 'task' and
storing the possible error code there, so that 'wb->task' would never take
erroneous values.

Note, this race is very unlikely and I never hit it, so it is theoretical, but
nevertheless worth fixing.

This patch also merges 2 comments which were previously separate.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/backing-dev.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4e9ed2a..327e36d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -331,8 +331,8 @@ static int bdi_forker_thread(void *ptr)
 	set_user_nice(current, 0);
 
 	for (;;) {
+		struct task_struct *task;
 		struct backing_dev_info *bdi, *tmp;
-		struct bdi_writeback *wb;
 
 		/*
 		 * Temporary measure, we want to make sure we don't see
@@ -383,29 +383,23 @@ static int bdi_forker_thread(void *ptr)
 		list_del_init(&bdi->bdi_list);
 		spin_unlock_bh(&bdi_lock);
 
-		wb = &bdi->wb;
-		wb->task = kthread_run(bdi_writeback_thread, wb, "flush-%s",
-					dev_name(bdi->dev));
-		/*
-		 * If thread creation fails, then readd the bdi to
-		 * the pending list and force writeout of the bdi
-		 * from this forker thread. That will free some memory
-		 * and we can try again.
-		 */
-		if (IS_ERR(wb->task)) {
-			wb->task = NULL;
-
+		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
+				   dev_name(bdi->dev));
+		if (IS_ERR(task)) {
 			/*
-			 * Add this 'bdi' to the back, so we get
-			 * a chance to flush other bdi's to free
-			 * memory.
+			 * If thread creation fails, then readd the bdi back to
+			 * the list and force writeout of the bdi from this
+			 * forker thread. That will free some memory and we can
+			 * try again. Add it to the tail so we get a chance to
+			 * flush other bdi's to free memory.
 			 */
 			spin_lock_bh(&bdi_lock);
 			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
 			spin_unlock_bh(&bdi_lock);
 
 			bdi_flush_io(bdi);
-		}
+		} else
+			bdi->wb.task = task;
 	}
 
 	return 0;
-- 
1.7.1.1

