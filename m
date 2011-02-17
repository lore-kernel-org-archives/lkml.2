Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1BQFvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:51:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:59515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1BQFvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:51:11 -0500
Date: Thu, 17 Feb 2011 16:50:57 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix over-zealous flush_disk when changing device size.
Message-ID: <20110217165057.5c50e566@notabene.brown>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew (and others)
 I wonder if you would review the following for me and comment.

Thanks,
NeilBrown



>From e7f75c2a757108cdd83ce8c808a16bf27686c95f Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 17 Feb 2011 16:37:30 +1100
Subject: [PATCH] Fix over-zealous flush_disk when changing device size.

There are two cases when we call flush_disk.
In one, the device has disappeared (check_disk_change) so any
data will hold becomes irrelevant.
In the oter, the device has changed size (check_disk_size_change)
so data we hold may be irrelevant.

In both cases it makes sense to discard any 'clean' buffers,
so they will be read back from the device if needed.

In the former case it makes sense to discard 'dirty' buffers
as there will never be anywhere safe to write the data.  In the
second case it *does*not* make sense to discard dirty buffers
as that will lead to file system corruption when you simply enlarge
the containing devices.

flush_disk calls __invalidate_devices.
__invalidate_device calls both invalidate_inodes and invalidate_bdev.

invalidate_inodes *does* discard I_DIRTY inodes and this does lead
to fs corruption.

invalidate_bev *does*not* discard dirty pages, but I don't really care
about that at present.

So this patch adds a flag to __invalidate_device (calling it
__invalidate_device2) to indicate whether dirty buffers should be
killed, and this is passed to invalidate_inodes which can choose to
skip dirty inodes.

flusk_disk then passes true from check_disk_change and false from
check_disk_size_change.

dm avoids tripping over this problem by calling i_size_write directly
rathher than using check_disk_size_change.

md does use check_disk_size_change and so is affected.

This regression was introduced by commit 608aeef17a
which causes check_disk_size_change to call
flush_disk.

Cc: stable@kernel.org
Cc: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/block_dev.c     |   12 ++++++------
 fs/inode.c         |    6 +++++-
 fs/internal.h      |    2 +-
 include/linux/fs.h |    6 +++++-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 333a7bb..1575034 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -927,9 +927,9 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
  * when a disk has been changed -- either by a media change or online
  * resize.
  */
-static void flush_disk(struct block_device *bdev)
+static void flush_disk(struct block_device *bdev, bool kill_dirty)
 {
-	if (__invalidate_device(bdev)) {
+	if (__invalidate_device2(bdev, kill_dirty)) {
 		char name[BDEVNAME_SIZE] = "";
 
 		if (bdev->bd_disk)
@@ -966,7 +966,7 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
 		       "%s: detected capacity change from %lld to %lld\n",
 		       name, bdev_size, disk_size);
 		i_size_write(bdev->bd_inode, disk_size);
-		flush_disk(bdev);
+		flush_disk(bdev, false);
 	}
 }
 EXPORT_SYMBOL(check_disk_size_change);
@@ -1019,7 +1019,7 @@ int check_disk_change(struct block_device *bdev)
 	if (!(events & DISK_EVENT_MEDIA_CHANGE))
 		return 0;
 
-	flush_disk(bdev);
+	flush_disk(bdev, true);
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
 	return 1;
@@ -1601,7 +1601,7 @@ fail:
 }
 EXPORT_SYMBOL(lookup_bdev);
 
-int __invalidate_device(struct block_device *bdev)
+int __invalidate_device2(struct block_device *bdev, bool kill_dirty)
 {
 	struct super_block *sb = get_super(bdev);
 	int res = 0;
@@ -1614,7 +1614,7 @@ int __invalidate_device(struct block_device *bdev)
 		 * hold).
 		 */
 		shrink_dcache_sb(sb);
-		res = invalidate_inodes(sb);
+		res = invalidate_inodes(sb, kill_dirty);
 		drop_super(sb);
 	}
 	invalidate_bdev(bdev);
diff --git a/fs/inode.c b/fs/inode.c
index da85e56..8352e06 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -544,7 +544,7 @@ void evict_inodes(struct super_block *sb)
  * Attempts to free all inodes for a given superblock.  If there were any
  * busy inodes return a non-zero value, else zero.
  */
-int invalidate_inodes(struct super_block *sb)
+int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 {
 	int busy = 0;
 	struct inode *inode, *next;
@@ -556,6 +556,10 @@ int invalidate_inodes(struct super_block *sb)
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE))
 			continue;
+		if (inode->i_state & I_DIRTY && !kill_dirty) {
+			busy = 1;
+			continue;
+		}
 		if (atomic_read(&inode->i_count)) {
 			busy = 1;
 			continue;
diff --git a/fs/internal.h b/fs/internal.h
index 0663568..9b976b5 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -112,4 +112,4 @@ extern void release_open_intent(struct nameidata *);
  */
 extern int get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
-extern int invalidate_inodes(struct super_block *);
+extern int invalidate_inodes(struct super_block *, bool);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bd32159..f8e2323 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2139,7 +2139,11 @@ extern void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
-extern int __invalidate_device(struct block_device *);
+extern int __invalidate_device2(struct block_device *, bool);
+static inline int __invalidate_device(struct block_device *b)
+{
+	return __invalidate_device2(b, true);
+}
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
-- 
1.7.1

