Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0GYIcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:32:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49922 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0GYI3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:29:54 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 11/15] writeback: prevent unnecessary bdi threads wakeups
Date: Sun, 25 Jul 2010 11:29:37 +0300
Message-Id: <1280046581-23623-12-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:47.0241 (UTC) FILETIME=[8A875590:01CB2BD3]
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c |   60 +++++++++++++++++++++++++++++++++++++++++++---------
 mm/backing-dev.c  |   13 ++++++++--
 2 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b9e5ba0..6814502 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -823,10 +823,16 @@ int bdi_writeback_thread(void *data)
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
@@ -862,6 +868,26 @@ void wakeup_flusher_threads(long nr_pages)
 	rcu_read_unlock();
 }
 
+/*
+ * This function is used when the first inode for this bdi is marked dirty. It
+ * wakes-up the corresponding bdi thread which should then take care of the
+ * periodic background write-out of dirty inodes.
+ */
+static void wakeup_bdi_thread(struct backing_dev_info *bdi)
+{
+	spin_lock(&bdi->wb_lock);
+	if (bdi->wb.task)
+		wake_up_process(bdi->wb.task);
+	else
+		/*
+		 * When bdi tasks are inactive for long time, they are killed.
+		 * In this case we have to wake-up the forker thread which
+		 * should create and run the bdi thread.
+		 */
+		wake_up_process(default_backing_dev_info.wb.task);
+	spin_unlock(&bdi->wb_lock);
+}
+
 static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 {
 	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
@@ -914,6 +940,8 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *bdi = NULL;
+	bool wakeup_bdi = false;
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -967,22 +995,32 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
+	if (wakeup_bdi)
+		wakeup_bdi_thread(bdi);
+
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a44caff..7039966 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -439,10 +439,17 @@ static int bdi_forker_thread(void *ptr)
 			break;
 
 		case NO_ACTION:
-			if (dirty_writeback_interval)
-				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
+			if (!wb_has_dirty_io(me) || !dirty_writeback_interval)
+				/*
+				 * There are no dirty data. The only thing we
+				 * should now care about is checking for
+				 * inactive bdi threads and killing them. Thus,
+				 * let's sleep for longer time, save energy and
+				 * be friendly for battery-driven devices.
+				 */
+				schedule_timeout(bdi_longest_inactive());
 			else
-				schedule();
+				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
 			try_to_freeze();
 			/* Back to the main loop */
 			continue;
-- 
1.7.1.1

