Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2GCOqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:46:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab2GCOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:55 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 7/8] vfs: Remove unnecessary flushing of block devices
Date: Tue,  3 Jul 2012 16:45:33 +0200
Message-Id: <1341326734-29881-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to write block devices twice. The reason why we first did
flush and then proper sync is that
  for_each_bdev() {
    write_bdev()
    wait_for_completion()
  }
is much slower than
  for_each_bdev()
    write_bdev()
  for_each_bdev()
    wait_for_completion()
when there is bigger amount of data. But as is seen in the above, there's no real
need to scan pages and submit them twice. We just need to separate the submission
and waiting part. This patch does that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index ea6e818..6d177d1 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -85,14 +85,14 @@ static void sync_fs_one_sb(struct super_block *sb, void *arg)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
 
-static void flush_one_bdev(struct block_device *bdev, void *arg)
+static void fdatawrite_one_bdev(struct block_device *bdev, void *arg)
 {
-	__sync_blockdev(bdev, 0);
+	filemap_fdatawrite(bdev->bd_inode->i_mapping);
 }
 
-static void sync_one_bdev(struct block_device *bdev, void *arg)
+static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
 {
-	sync_blockdev(bdev);
+	filemap_fdatawait(bdev->bd_inode->i_mapping);
 }
 
 /*
@@ -106,10 +106,10 @@ SYSCALL_DEFINE0(sync)
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
 	iterate_supers(writeback_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(flush_one_bdev, NULL);
 	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &wait);
-	iterate_bdevs(sync_one_bdev, NULL);
+	iterate_bdevs(fdatawrite_one_bdev, NULL);
+	iterate_bdevs(fdatawait_one_bdev, NULL);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
 	return 0;
@@ -125,10 +125,10 @@ static void do_sync_work(struct work_struct *work)
 	 */
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(flush_one_bdev, NULL);
+	iterate_bdevs(fdatawrite_one_bdev, NULL);
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(flush_one_bdev, NULL);
+	iterate_bdevs(fdatawrite_one_bdev, NULL);
 	printk("Emergency Sync complete\n");
 	kfree(work);
 }
-- 
1.7.1

