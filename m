Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519Ab0GPMwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:52:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54076 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965436Ab0GPMtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:25 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 16/16] writeback: prevent unnecessary bdi threads wakeups
Date: Fri, 16 Jul 2010 15:45:12 +0300
Message-Id: <1279284312-2411-17-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:20.0671 (UTC) FILETIME=[4F4C6AF0:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Finally, we can get rid of unnecessary wake-ups in bdi threads,
which are very bad for battery-driven devices.

There are two type of work bdi threads do:
1. process bdi works from the 'bdi->work_list'
2. periodic write-back

So there are 2 sources of wake-up events for bdi threads:

1. 'bdi_queue_work()' - submits bdi works
2. '__mark_inode_dirty()' - adds dirty I/O to bdi's

The former already has bdi wake-up code. The latter does not,
and this patch adds it.

'__mark_inode_dirty()' is hot-path function, but this patch adds
another 'spin_lock(&bdi->wb_lock)' there. However, it is taken only
in rare cases when the bdi has no dirty inodes. So adding this
spinlock should be fine and should not affect performance.

This patch makes sure bdi threads and the forker thread do not
wake-up if there is nothing to do. The forker thread will nevertheless
wake up at least every 5m. to check whether it has to kill a
bdi thread. This can also be optimized, but is not worth it.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 mm/backing-dev.c  |   18 +++++++++++++-----
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 83662fb..f94f08c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -828,12 +828,17 @@ int bdi_writeback_thread(void *data)
 			continue;
 		}
 
-		if (dirty_writeback_interval) {
-			unsigned long wait_jiffies;
+		if (wb_has_dirty_io(wb) && dirty_writeback_interval) {
+			unsigned long wait;
 
-			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
-			schedule_timeout(wait_jiffies);
+			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
+			schedule_timeout(wait);
 		} else
+			/*
+			 * We have nothing to do, so can go sleep without any
+			 * timeout and save power. When a work is queued or
+			 * something is made dirty - we will be woken up.
+			 */
 			schedule();
 
 		try_to_freeze();
@@ -924,7 +929,9 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
  */
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
+	bool wakeup_bdi;
 	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *uninitialized_var(bdi);
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -948,6 +955,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
+	wakeup_bdi = false;
+
 	spin_lock(&inode_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -978,19 +987,41 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-			struct backing_dev_info *bdi = wb->bdi;
+			bdi = inode_to_bdi(inode);
 
 			WARN(bdi_cap_writeback_dirty(bdi) &&
 			     !test_bit(BDI_registered, &bdi->state),
 			     "bdi-%s not registered\n", bdi->name);
 
+			/*
+			 * If this is the first dirty inode for this bdi, we
+			 * have to wake-up the corresponding bdi thread to make
+			 * sure background write-back happens later.
+			 */
+			if (!wb_has_dirty_io(&bdi->wb) &&
+			    bdi_cap_writeback_dirty(bdi))
+				wakeup_bdi = true;
+
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &wb->b_dirty);
+			list_move(&inode->i_list, &bdi->wb.b_dirty);
 		}
 	}
 out:
 	spin_unlock(&inode_lock);
+
+	if (wakeup_bdi) {
+		bool wakeup_default = false;
+
+		spin_lock(&bdi->wb_lock);
+		if (unlikely(!bdi->wb.task))
+			wakeup_default = true;
+		else
+			wake_up_process(bdi->wb.task);
+		spin_unlock(&bdi->wb_lock);
+
+		if (wakeup_default)
+			wake_up_process(default_backing_dev_info.wb.task);
+	}
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 65cb88a..818f934 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -326,7 +326,7 @@ static unsigned long bdi_longest_inactive(void)
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
-	return max(5UL * 60 * HZ, wait_jiffies);
+	return max(5UL * 60 * HZ, interval);
 }
 
 static int bdi_forker_thread(void *ptr)
@@ -399,10 +399,18 @@ static int bdi_forker_thread(void *ptr)
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

