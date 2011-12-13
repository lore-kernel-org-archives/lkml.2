Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1LMLnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:43:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:59031 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1LMLnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:43:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85148288"
Date: Tue, 13 Dec 2011 19:33:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] writeback fixes for 3.2-rc6
Message-ID: <20111213113303.GA5862@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull 5 writeback fixes, thanks!

- abort write(2) on SIGKILL                                                                                             
- 2 patches to keep system responsive on stalled NFS mount                                                              
- 2 comment fixes                                                                                                     

The following changes since commit 8748dfae379573cdbea4e765b55e608a1764f918:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux (2011-11-28 16:37:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-for-linus

Jan Kara (1):
      fs: Make write(2) interruptible by a fatal signal

Marcos Paulo de Souza (1):
      writeback: Fix issue on make htmldocs

Wu Fengguang (3):
      writeback: comment on the bdi dirty threshold
      writeback: permit through good bdi even when global dirty exceeded
      writeback: set max_pause to lowest value on zero bdi_dirty

 fs/fs-writeback.c   |    5 +++++
 mm/filemap.c        |    6 ++++--
 mm/page-writeback.c |   32 ++++++++++++++++++++++++++++----
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 73c3992..ac86f8b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -156,6 +156,7 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
  * bdi_start_writeback - start writeback
  * @bdi: the backing device to write from
  * @nr_pages: the number of pages to write
+ * @reason: reason why some writeback work was initiated
  *
  * Description:
  *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
@@ -1223,6 +1224,7 @@ static void wait_sb_inodes(struct super_block *sb)
  * writeback_inodes_sb_nr -	writeback dirty inodes from given super_block
  * @sb: the superblock
  * @nr: the number of pages to write
+ * @reason: reason why some writeback work initiated
  *
  * Start writeback on some inodes on this super_block. No guarantees are made
  * on how many (if any) will be written, and this function does not wait
@@ -1251,6 +1253,7 @@ EXPORT_SYMBOL(writeback_inodes_sb_nr);
 /**
  * writeback_inodes_sb	-	writeback dirty inodes from given super_block
  * @sb: the superblock
+ * @reason: reason why some writeback work was initiated
  *
  * Start writeback on some inodes on this super_block. No guarantees are made
  * on how many (if any) will be written, and this function does not wait
@@ -1265,6 +1268,7 @@ EXPORT_SYMBOL(writeback_inodes_sb);
 /**
  * writeback_inodes_sb_if_idle	-	start writeback if none underway
  * @sb: the superblock
+ * @reason: reason why some writeback work was initiated
  *
  * Invoke writeback_inodes_sb if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
@@ -1285,6 +1289,7 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
  * writeback_inodes_sb_if_idle	-	start writeback if none underway
  * @sb: the superblock
  * @nr: the number of pages to write
+ * @reason: reason why some writeback work was initiated
  *
  * Invoke writeback_inodes_sb if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
diff --git a/mm/filemap.c b/mm/filemap.c
index c0018f2..c106d3b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2407,7 +2407,6 @@ static ssize_t generic_perform_write(struct file *file,
 						iov_iter_count(i));
 
 again:
-
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
@@ -2463,7 +2462,10 @@ again:
 		written += copied;
 
 		balance_dirty_pages_ratelimited(mapping);
-
+		if (fatal_signal_pending(current)) {
+			status = -EINTR;
+			break;
+		}
 	} while (iov_iter_count(i));
 
 	return written ? written : status;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7125248..50f0824 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -411,8 +411,13 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
  *
  * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
  * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
- * And the "limit" in the name is not seriously taken as hard limit in
- * balance_dirty_pages().
+ *
+ * Note that balance_dirty_pages() will only seriously take it as a hard limit
+ * when sleeping max_pause per page is not enough to keep the dirty pages under
+ * control. For example, when the device is completely stalled due to some error
+ * conditions, or when there are 1000 dd tasks writing to a slow 10MB/s USB key.
+ * In the other normal situations, it acts more gently by throttling the tasks
+ * more (rather than completely block them) when the bdi dirty pages go high.
  *
  * It allocates high/low dirty limits to fast/slow devices, in order to prevent
  * - starving fast devices
@@ -594,6 +599,13 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
 	 */
 	if (unlikely(bdi_thresh > thresh))
 		bdi_thresh = thresh;
+	/*
+	 * It's very possible that bdi_thresh is close to 0 not because the
+	 * device is slow, but that it has remained inactive for long time.
+	 * Honour such devices a reasonable good (hopefully IO efficient)
+	 * threshold, so that the occasional writes won't be blocked and active
+	 * writes can rampup the threshold quickly.
+	 */
 	bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
 	/*
 	 * scale global setpoint to bdi's:
@@ -977,8 +989,7 @@ static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
 	 *
 	 * 8 serves as the safety ratio.
 	 */
-	if (bdi_dirty)
-		t = min(t, bdi_dirty * HZ / (8 * bw + 1));
+	t = min(t, bdi_dirty * HZ / (8 * bw + 1));
 
 	/*
 	 * The pause time will be settled within range (max_pause/4, max_pause).
@@ -1136,6 +1147,19 @@ pause:
 		if (task_ratelimit)
 			break;
 
+		/*
+		 * In the case of an unresponding NFS server and the NFS dirty
+		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
+		 * to go through, so that tasks on them still remain responsive.
+		 *
+		 * In theory 1 page is enough to keep the comsumer-producer
+		 * pipe going: the flusher cleans 1 page => the task dirties 1
+		 * more page. However bdi_dirty has accounting errors.  So use
+		 * the larger and more IO friendly bdi_stat_error.
+		 */
+		if (bdi_dirty <= bdi_stat_error(bdi))
+			break;
+
 		if (fatal_signal_pending(current))
 			break;
 	}
