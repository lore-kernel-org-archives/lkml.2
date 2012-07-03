Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2GCOsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:48:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab2GCOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:54 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/8] vfs: Reorder operations during sys_sync
Date: Tue,  3 Jul 2012 16:45:30 +0200
Message-Id: <1341326734-29881-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of operations during sync from

for_each_sb {
        writeback_inodes_sb();
        sync_fs(nowait);
        __sync_blockdev(nowait);
}
for_each_sb {
        sync_inodes_sb();
        sync_fs(wait);
        __sync_blockdev(wait);
}

to

for_each_sb
        writeback_inodes_sb();
for_each_sb
        sync_fs(nowait);
for_each_sb
        __sync_blockdev(nowait);
for_each_sb
        sync_inodes_sb();
for_each_sb
        sync_fs(wait);
for_each_sb
        __sync_blockdev(wait);

This is a preparation for the following patches in this series.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 66acd2b..867bf78 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -67,18 +67,28 @@ int sync_filesystem(struct super_block *sb)
 }
 EXPORT_SYMBOL_GPL(sync_filesystem);
 
-static void sync_one_sb(struct super_block *sb, void *arg)
+static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 {
 	if (!(sb->s_flags & MS_RDONLY))
-		__sync_filesystem(sb, *(int *)arg);
+		sync_inodes_sb(sb);
 }
-/*
- * Sync all the data for all the filesystems (called by sys_sync() and
- * emergency sync)
- */
-static void sync_filesystems(int wait)
+
+static void writeback_inodes_one_sb(struct super_block *sb, void *arg)
+{
+	if (!(sb->s_flags & MS_RDONLY))
+		writeback_inodes_sb(sb);
+}
+
+static void sync_fs_one_sb(struct super_block *sb, void *arg)
 {
-	iterate_supers(sync_one_sb, &wait);
+	if (!(sb->s_flags & MS_RDONLY) && sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, *(int *)arg);
+}
+
+static void sync_blkdev_one_sb(struct super_block *sb, void *arg)
+{
+	if (!(sb->s_flags & MS_RDONLY))
+		__sync_blockdev(sb->s_bdev, *(int *)arg);
 }
 
 /*
@@ -87,9 +97,15 @@ static void sync_filesystems(int wait)
  */
 SYSCALL_DEFINE0(sync)
 {
+	int nowait = 0, wait = 1;
+
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
-	sync_filesystems(0);
-	sync_filesystems(1);
+	iterate_supers(writeback_inodes_one_sb, NULL);
+	iterate_supers(sync_fs_one_sb, &nowait);
+	iterate_supers(sync_blkdev_one_sb, &nowait);
+	iterate_supers(sync_inodes_one_sb, NULL);
+	iterate_supers(sync_fs_one_sb, &wait);
+	iterate_supers(sync_blkdev_one_sb, &wait);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
 	return 0;
@@ -97,12 +113,18 @@ SYSCALL_DEFINE0(sync)
 
 static void do_sync_work(struct work_struct *work)
 {
+	int nowait = 0;
+
 	/*
 	 * Sync twice to reduce the possibility we skipped some inodes / pages
 	 * because they were temporarily locked
 	 */
-	sync_filesystems(0);
-	sync_filesystems(0);
+	iterate_supers(sync_inodes_one_sb, &nowait);
+	iterate_supers(sync_fs_one_sb, &nowait);
+	iterate_supers(sync_blkdev_one_sb, &nowait);
+	iterate_supers(sync_inodes_one_sb, &nowait);
+	iterate_supers(sync_fs_one_sb, &nowait);
+	iterate_supers(sync_blkdev_one_sb, &nowait);
 	printk("Emergency Sync complete\n");
 	kfree(work);
 }
-- 
1.7.1

