Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2GCOqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:46:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab2GCOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:55 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes
Date: Tue,  3 Jul 2012 16:45:34 +0200
Message-Id: <1341326734-29881-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wakeup_flusher_threads(0) will queue work doing complete writeback for each
flusher thread. Thus there is not much point in submitting another work doing
full inode WB_SYNC_NONE writeback by writeback_inodes_sb().

After this change it does not make sense to call nonblocking ->sync_fs and
block device flush before calling sync_inodes_sb() because
wakeup_flusher_threads() is completely asynchronous and thus these functions
would be called in parallel with inode writeback running which will effectively
void any work they do. So we move sync_inodes_sb() call before these two
functions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 6d177d1..eb8722d 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -73,12 +73,6 @@ static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 		sync_inodes_sb(sb);
 }
 
-static void writeback_inodes_one_sb(struct super_block *sb, void *arg)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		writeback_inodes_sb(sb);
-}
-
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
 {
 	if (!(sb->s_flags & MS_RDONLY) && sb->s_op->sync_fs)
@@ -96,17 +90,22 @@ static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
 }
 
 /*
- * sync everything.  Start out by waking pdflush, because that writes back
- * all queues in parallel.
+ * Sync everything. We start by waking flusher threads so that most of
+ * writeback runs on all devices in parallel. Then we sync all inodes reliably
+ * which effectively also waits for all flusher threads to finish doing
+ * writeback. At this point all data is on disk so metadata should be stable
+ * and we tell filesystems to sync their metadata via ->sync_fs() calls.
+ * Finally, we writeout all block devices because some filesystems (e.g. ext2)
+ * just write metadata (such as inodes or bitmaps) to block device page cache
+ * and do not sync it on their own in ->sync_fs().
  */
 SYSCALL_DEFINE0(sync)
 {
 	int nowait = 0, wait = 1;
 
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
-	iterate_supers(writeback_inodes_one_sb, NULL);
-	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_inodes_one_sb, NULL);
+	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &wait);
 	iterate_bdevs(fdatawrite_one_bdev, NULL);
 	iterate_bdevs(fdatawait_one_bdev, NULL);
-- 
1.7.1

