Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0GUJdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:33:45 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25453 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0GUJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:32:07 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads wakeups
Date: Wed, 21 Jul 2010 12:31:46 +0300
Message-Id: <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 21 Jul 2010 09:31:49.0814 (UTC) FILETIME=[8BB3E560:01CB28B7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Finally, we can get rid of unnecessary wake-ups in bdi threads, which are very
bad for battery-driven devices.

There are two types of activities bdi threads do:
1. process bdi works from the 'bdi->work_list'
2. periodic write-back

So there are 2 sources of wake-up events for bdi threads:

1. 'bdi_queue_work()' - submits bdi works
2. '__mark_inode_dirty()' - adds dirty I/O to bdi's

The former already has bdi wake-up code. The latter does not, and this patch
adds it.

'__mark_inode_dirty()' is hot-path function, but this patch adds another
'spin_lock(&bdi->wb_lock)' there. However, it is taken only in rare cases when
the bdi has no dirty inodes. So adding this spinlock should be fine and should
not affect performance.

This patch makes sure bdi threads and the forker thread do not wake-up if there
is nothing to do. The forker thread will nevertheless wake up at least every
5 min. to check whether it has to kill a bdi thread. This can also be optimized,
but is not worth it.

This patch also tidies up the warning about unregistered bid, and turns it from
an ugly crocodile to a simple 'WARN()' statement.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   45 ++++++++++++++++++++++++++++++++++-----------
 mm/backing-dev.c  |   16 ++++++++++++----
 2 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9055809..50d9ceb 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -829,10 +829,16 @@ int bdi_writeback_thread(void *data)
 			continue;
 		}
 
-		if (dirty_writeback_interval)
+		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
 			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-		else
+		else {
+			/*
+			 * We have nothing to do, so can go sleep without any
+			 * timeout and save power. When a work is queued or
+			 * something is made dirty - we will be woken up.
+			 */
 			schedule();
+		}
 
 		try_to_freeze();
 	}
@@ -920,6 +926,8 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *bdi = NULL;
+	bool wakeup_bdi = false;
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -973,22 +981,37 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-			struct backing_dev_info *bdi = wb->bdi;
-
-			if (bdi_cap_writeback_dirty(bdi) &&
-			    !test_bit(BDI_registered, &bdi->state)) {
-				WARN_ON(1);
-				printk(KERN_ERR "bdi-%s not registered\n",
-								bdi->name);
+			bdi = inode_to_bdi(inode);
+
+			if (bdi_cap_writeback_dirty(bdi)) {
+				WARN(!test_bit(BDI_registered, &bdi->state),
+				     "bdi-%s not registered\n", bdi->name);
+
+				/*
+				 * If this is the first dirty inode for this
+				 * bdi, we have to wake-up the corresponding
+				 * bdi thread to make sure background
+				 * write-back happens later.
+				 */
+				if (!wb_has_dirty_io(&bdi->wb))
+					wakeup_bdi = true;
 			}
 
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &wb->b_dirty);
+			list_move(&inode->i_list, &bdi->wb.b_dirty);
 		}
 	}
 out:
 	spin_unlock(&inode_lock);
+
+	if (wakeup_bdi) {
+		spin_lock(&bdi->wb_lock);
+		if (!bdi->wb.task)
+			wake_up_process(default_backing_dev_info.wb.task);
+		else
+			wake_up_process(bdi->wb.task);
+		spin_unlock(&bdi->wb_lock);
+	}
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 3975440..01e6608 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -411,10 +411,18 @@ static int bdi_forker_thread(void *ptr)
 			unsigned long wait;
 
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
-			if (wait)
-				schedule_timeout(wait);
-			else
-				schedule();
+			if (!wb_has_dirty_io(me) || !wait) {
+				/*
+				 * There are no dirty data. The only thing we
+				 * should now care is checking for inactive bdi
+				 * threads and killing them. Thus, let's sleep
+				 * for longer time to avoid unnecessary
+				 * wake-ups, save energy and be friendly for
+				 * battery-driven devices.
+				 */
+				wait = bdi_longest_inactive();
+			}
+			schedule_timeout(wait);
 			try_to_freeze();
 			continue;
 		}
-- 
1.7.1.1

