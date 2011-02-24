Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1BXGbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:31:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1BXGbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:31:23 -0500
Date: Thu, 24 Feb 2011 17:31:09 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Patterson <andrew.patterson@hp.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PULL REQUEST] md and related patches for 2.6.38
Message-ID: <20110224173109.3251700c@notabene.brown>
In-Reply-To: <AANLkTinm95OYw2Sj0DuABTiG6eWzePcfAZyxOE0c4GsT@mail.gmail.com>
References: <20110224165328.46c1169b@notabene.brown>
	<AANLkTinm95OYw2Sj0DuABTiG6eWzePcfAZyxOE0c4GsT@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 22:01:49 -0800 Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> On Wed, Feb 23, 2011 at 9:53 PM, NeilBrown <neilb@suse.de> wrote:
> >
> >  The most noteworthy is :
> >       Fix over-zealous flush_disk when changing device size.
> >
> >  which I include below in full.
> 
> Gah.
> 
> Why did you do that butt-ugly "__invalidate_device2()"?
> 
> There are something like three users of that existing
> __invalidate_device() function, it would have made for a smaller and
> cleaner patch to just fix them all, rather than change the calling
> convention, create that ugly "2" function, and add the wrapper
> function.
> 
> It's _doubly_ crazy, because that's exactly what you did to
> "invalidate_inodes()", so it has this crazy mix of "change one
> function" and "try to maintain another function unchanged".
> 
> Why?

Seemed like a good idea at the time?
invalidate_inodes had precisely one caller so that seemed safe.
__invalidate_device had more - but I agree that two is not very many.

Revised patch - as below - can now be pull from the same place:
    git://neil.brown.name/md for-linus

Thanks,
NeilBrown

>From 93b270f76e7ef3b81001576860c2701931cdc78b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 24 Feb 2011 17:25:47 +1100
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

This regression was introduced by commit 608aeef17a which causes
check_disk_size_change to call flush_disk, so it is suitable for any
kernel since 2.6.27.

Cc: stable@kernel.org
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 block/genhd.c          |    2 +-
 drivers/block/floppy.c |    2 +-
 fs/block_dev.c         |   12 ++++++------
 fs/inode.c             |    9 ++++++++-
 fs/internal.h          |    2 +-
 include/linux/fs.h     |    2 +-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6a5b772..cbf1112 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1355,7 +1355,7 @@ int invalidate_partition(struct gendisk *disk, int partno)
 	struct block_device *bdev = bdget_disk(disk, partno);
 	if (bdev) {
 		fsync_bdev(bdev);
-		res = __invalidate_device(bdev);
+		res = __invalidate_device(bdev, true);
 		bdput(bdev);
 	}
 	return res;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b9ba04f..77fc76f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3281,7 +3281,7 @@ static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 			struct block_device *bdev = opened_bdev[cnt];
 			if (!bdev || ITYPE(drive_state[cnt].fd_device) != type)
 				continue;
-			__invalidate_device(bdev);
+			__invalidate_device(bdev, true);
 		}
 		mutex_unlock(&open_lock);
 	} else {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 333a7bb..5e23152 100644
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
+	if (__invalidate_device(bdev, kill_dirty)) {
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
+int __invalidate_device(struct block_device *bdev, bool kill_dirty)
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
index da85e56..c50d7fe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -540,11 +540,14 @@ void evict_inodes(struct super_block *sb)
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
@@ -556,6 +559,10 @@ int invalidate_inodes(struct super_block *sb)
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
index 32b38cd..683f4c5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2139,7 +2139,7 @@ extern void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
-extern int __invalidate_device(struct block_device *);
+extern int __invalidate_device(struct block_device *, bool);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
-- 
1.7.1

