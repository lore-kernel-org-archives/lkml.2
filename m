Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2GCOqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:46:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab2GCOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:55 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 6/8] vfs: Make sys_sync writeout also block device inodes
Date: Tue,  3 Jul 2012 16:45:32 +0200
Message-Id: <1341326734-29881-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case block device does not have filesystem mounted on it, sys_sync will just
ignore it and doesn't writeout its dirty pages. This is because writeback code
avoids writing inodes from superblock without backing device and
blockdev_superblock is such a superblock.  Since it's unexpected that sync
doesn't writeout dirty data for block devices be nice to users and change the
behavior to do so. So now we iterate over all block devices on blockdev_super
instead of iterating over all superblocks when syncing block devices.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 867bf78..ea6e818 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -85,10 +85,14 @@ static void sync_fs_one_sb(struct super_block *sb, void *arg)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
 
-static void sync_blkdev_one_sb(struct super_block *sb, void *arg)
+static void flush_one_bdev(struct block_device *bdev, void *arg)
 {
-	if (!(sb->s_flags & MS_RDONLY))
-		__sync_blockdev(sb->s_bdev, *(int *)arg);
+	__sync_blockdev(bdev, 0);
+}
+
+static void sync_one_bdev(struct block_device *bdev, void *arg)
+{
+	sync_blockdev(bdev);
 }
 
 /*
@@ -102,10 +106,10 @@ SYSCALL_DEFINE0(sync)
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
 	iterate_supers(writeback_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_supers(sync_blkdev_one_sb, &nowait);
+	iterate_bdevs(flush_one_bdev, NULL);
 	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &wait);
-	iterate_supers(sync_blkdev_one_sb, &wait);
+	iterate_bdevs(sync_one_bdev, NULL);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
 	return 0;
@@ -121,10 +125,10 @@ static void do_sync_work(struct work_struct *work)
 	 */
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_supers(sync_blkdev_one_sb, &nowait);
+	iterate_bdevs(flush_one_bdev, NULL);
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_supers(sync_blkdev_one_sb, &nowait);
+	iterate_bdevs(flush_one_bdev, NULL);
 	printk("Emergency Sync complete\n");
 	kfree(work);
 }
-- 
1.7.1

