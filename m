Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717Ab1CEBPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:15:10 -0500
Received: from kroah.org ([198.145.64.141]:50228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760310Ab1CEBAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.128325892@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Moyer <jmoyer@redhat.com>,
        Andrew Patterson <andrew.patterson@hp.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [26/73] Fix over-zealous flush_disk when changing device size.
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 93b270f76e7ef3b81001576860c2701931cdc78b upstream.

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

This regression was introduced by commit 608aeef17a which causes
check_disk_size_change to call flush_disk, so it is suitable for any
kernel since 2.6.27.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/genhd.c          |    2 +-
 drivers/block/floppy.c |    2 +-
 fs/block_dev.c         |   12 ++++++------
 fs/inode.c             |    9 ++++++++-
 fs/internal.h          |    2 +-
 include/linux/fs.h     |    2 +-
 6 files changed, 18 insertions(+), 11 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1285,7 +1285,7 @@ int invalidate_partition(struct gendisk
 	struct block_device *bdev = bdget_disk(disk, partno);
 	if (bdev) {
 		fsync_bdev(bdev);
-		res = __invalidate_device(bdev);
+		res = __invalidate_device(bdev, true);
 		bdput(bdev);
 	}
 	return res;
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3276,7 +3276,7 @@ static int set_geometry(unsigned int cmd
 			struct block_device *bdev = opened_bdev[cnt];
 			if (!bdev || ITYPE(drive_state[cnt].fd_device) != type)
 				continue;
-			__invalidate_device(bdev);
+			__invalidate_device(bdev, true);
 		}
 		mutex_unlock(&open_lock);
 	} else {
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1217,9 +1217,9 @@ EXPORT_SYMBOL(open_by_devnum);
  * when a disk has been changed -- either by a media change or online
  * resize.
  */
-static void flush_disk(struct block_device *bdev)
+static void flush_disk(struct block_device *bdev, bool kill_dirty)
 {
-	if (__invalidate_device(bdev)) {
+	if (__invalidate_device(bdev, kill_dirty)) {
 		char name[BDEVNAME_SIZE] = "";
 
 		if (bdev->bd_disk)
@@ -1256,7 +1256,7 @@ void check_disk_size_change(struct gendi
 		       "%s: detected capacity change from %lld to %lld\n",
 		       name, bdev_size, disk_size);
 		i_size_write(bdev->bd_inode, disk_size);
-		flush_disk(bdev);
+		flush_disk(bdev, false);
 	}
 }
 EXPORT_SYMBOL(check_disk_size_change);
@@ -1308,7 +1308,7 @@ int check_disk_change(struct block_devic
 	if (!bdops->media_changed(bdev->bd_disk))
 		return 0;
 
-	flush_disk(bdev);
+	flush_disk(bdev, true);
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
 	return 1;
@@ -1776,7 +1776,7 @@ void close_bdev_exclusive(struct block_d
 
 EXPORT_SYMBOL(close_bdev_exclusive);
 
-int __invalidate_device(struct block_device *bdev)
+int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 {
 	struct super_block *sb = get_super(bdev);
 	int res = 0;
@@ -1789,7 +1789,7 @@ int __invalidate_device(struct block_dev
 		 * hold).
 		 */
 		shrink_dcache_sb(sb);
-		res = invalidate_inodes(sb);
+		res = invalidate_inodes(sb, kill_dirty);
 		drop_super(sb);
 	}
 	invalidate_bdev(bdev);
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -532,11 +532,14 @@ void evict_inodes(struct super_block *sb
 /**
  * invalidate_inodes	- attempt to free all inodes on a superblock
  * @sb:		superblock to operate on
+ * @kill_dirty: flag to guide handling of dirty inodes
  *
  * Attempts to free all inodes for a given superblock.  If there were any
  * busy inodes return a non-zero value, else zero.
+ * If @kill_dirty is set, discard dirty inodes too, otherwise treat
+ * them as busy.
  */
-int invalidate_inodes(struct super_block *sb)
+int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 {
 	int busy = 0;
 	struct inode *inode, *next;
@@ -548,6 +551,10 @@ int invalidate_inodes(struct super_block
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
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -107,4 +107,4 @@ extern void release_open_intent(struct n
  */
 extern int get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
-extern int invalidate_inodes(struct super_block *);
+extern int invalidate_inodes(struct super_block *, bool);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2118,7 +2118,7 @@ extern void check_disk_size_change(struc
 				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
-extern int __invalidate_device(struct block_device *);
+extern int __invalidate_device(struct block_device *, bool);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,


