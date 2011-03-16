Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1CPUar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab1CPUal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:30:41 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] Fix over-zealous flush_disk when changing device size.
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
	<20110304111624.4be27aaf@notabene.brown>
	<1299259506.2118.24.camel@grinch>
	<20110306174755.49404c8e@notabene.brown>
	<1299471771.2228.11.camel@grinch>
	<1299516418.15258.4.camel@mulgrave.site>
	<20110308094412.1c45b277@notabene.brown>
	<1299538572.15955.90.camel@mulgrave.site>
	<20110308110453.0047307d@notabene.brown>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 16 Mar 2011 16:30:22 -0400
In-Reply-To: <20110308110453.0047307d@notabene.brown> (NeilBrown's message of
	"Tue, 8 Mar 2011 11:04:53 +1100")
Message-ID: <x49pqpq95b5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

>> Synchronous notification of errors.  If we don't try to write everything
>> back immediately after the size change, we don't see dirty pages in
>> zapped regions until the writeout/page cache management takes it into
>> its head to try to clean the pages.
>> 
>
> So if you just want synchronous errors, I think you want:
>     fsync_bdev()
>
> which calls sync_filesystem() if it can find a filesystem, else
> sync_blockdev();  (sync_filesystem itself calls sync_blockdev too).

... which deadlocks md.  ;-)  writeback_inodes_sb_nr is waiting for the
flusher thread to write back the dirty data.  The flusher thread is
stuck in md_write_start, here:

        wait_event(mddev->sb_wait,
                   !test_bit(MD_CHANGE_PENDING, &mddev->flags));

This is after reverting your change, and replacing the flush_disk call
in check_disk_size_change with a call to fsync_bdev.  I'm not familiar
enough with md to really suggest a way forward.  Neil?

Cheers,
Jeff

md127: detected capacity change from 267386880 to 401080320
INFO: task md127_raid5:2255 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
md127_raid5     D ffff88011d010690  5416  2255      2 0x00000080
 ffff88010fcc7990 0000000000000046 ffff880100000000 ffffffff812070c9
 0000000000014d00 ffff88011d010100 ffff88011d010690 ffff88010fcc7fd8
 ffff88011d010698 0000000000014d00 ffff88010fcc6010 0000000000014d00
Call Trace:
 [<ffffffff812070c9>] ? cpumask_next_and+0x29/0x50
 [<ffffffff81493df5>] schedule_timeout+0x265/0x2d0
 [<ffffffff8104b341>] ? enqueue_task+0x61/0x80
 [<ffffffff81493a25>] wait_for_common+0x115/0x180
 [<ffffffff81057850>] ? default_wake_function+0x0/0x10
 [<ffffffff81493b38>] wait_for_completion+0x18/0x20
 [<ffffffff8115cce2>] writeback_inodes_sb_nr+0x72/0xa0
 [<ffffffff8115cfad>] writeback_inodes_sb+0x4d/0x60
 [<ffffffff81162499>] __sync_filesystem+0x49/0x90
 [<ffffffff81162592>] sync_filesystem+0x32/0x60
 [<ffffffff8116bc59>] fsync_bdev+0x29/0x70
 [<ffffffff8116bcea>] check_disk_size_change+0x4a/0xb0
 [<ffffffff81208e27>] ? kobject_put+0x27/0x60
 [<ffffffff8116bdaf>] revalidate_disk+0x5f/0x90
 [<ffffffffa031155a>] raid5_finish_reshape+0x9a/0x1e0 [raid456]
 [<ffffffff8138a933>] reap_sync_thread+0x63/0x130
 [<ffffffff8138c8a6>] md_check_recovery+0x1f6/0x6f0
 [<ffffffffa03150ab>] raid5d+0x3b/0x610 [raid456]
 [<ffffffff810804c9>] ? prepare_to_wait+0x59/0x90
 [<ffffffff81387ee9>] md_thread+0x119/0x150
 [<ffffffff810801d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81387dd0>] ? md_thread+0x0/0x150
 [<ffffffff8107fb56>] kthread+0x96/0xa0
 [<ffffffff8100cc04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fac0>] ? kthread+0x0/0xa0
 [<ffffffff8100cc00>] ? kernel_thread_helper+0x0/0x10
INFO: task flush-9:127:2288 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
flush-9:127     D ffff88011cee30a0  4664  2288      2 0x00000080
 ffff88011b0af6a0 0000000000000046 0000000000000000 0000000000000000
 0000000000014d00 ffff88011cee2b10 ffff88011cee30a0 ffff88011b0affd8
 ffff88011cee30a8 0000000000014d00 ffff88011b0ae010 0000000000014d00
Call Trace:
 [<ffffffff8138bbb5>] md_write_start+0xa5/0x1c0
 [<ffffffff810801d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0316435>] make_request+0x45/0x6c0 [raid456]
 [<ffffffff811fbfcb>] ? blkiocg_update_dispatch_stats+0x8b/0xd0
 [<ffffffff81385ca3>] md_make_request+0xd3/0x210
 [<ffffffff811ee9da>] generic_make_request+0x2ea/0x5d0
 [<ffffffff810e9cde>] ? mempool_alloc+0x5e/0x140
 [<ffffffff811eed41>] submit_bio+0x81/0x110
 [<ffffffff811699c6>] ? bio_alloc_bioset+0x56/0xf0
 [<ffffffff81163ef6>] submit_bh+0xe6/0x140
 [<ffffffff81165ad0>] __block_write_full_page+0x200/0x390
 [<ffffffff811655a0>] ? end_buffer_async_write+0x0/0x1a0
 [<ffffffff8116667e>] block_write_full_page_endio+0xde/0x110
 [<ffffffffa037d3b0>] ? buffer_unmapped+0x0/0x20 [ext3]
 [<ffffffff811666c0>] block_write_full_page+0x10/0x20
 [<ffffffffa037de6d>] ext3_writeback_writepage+0x11d/0x170 [ext3]
 [<ffffffff810f0152>] __writepage+0x12/0x40
 [<ffffffff810f12b4>] write_cache_pages+0x1a4/0x490
 [<ffffffff810f0140>] ? __writepage+0x0/0x40
 [<ffffffff810f15bf>] generic_writepages+0x1f/0x30
 [<ffffffff810f15f5>] do_writepages+0x25/0x30
 [<ffffffff8115d5f0>] writeback_single_inode+0x90/0x220
 [<ffffffff8115d9b6>] writeback_sb_inodes+0xc6/0x170
 [<ffffffff8115dd3f>] wb_writeback+0x17f/0x430
 [<ffffffff8106e217>] ? lock_timer_base+0x37/0x70
 [<ffffffff8115e08d>] wb_do_writeback+0x9d/0x270
 [<ffffffff8106e330>] ? process_timeout+0x0/0x10
 [<ffffffff8115e302>] bdi_writeback_thread+0xa2/0x280
 [<ffffffff8115e260>] ? bdi_writeback_thread+0x0/0x280
 [<ffffffff8115e260>] ? bdi_writeback_thread+0x0/0x280
 [<ffffffff8107fb56>] kthread+0x96/0xa0
 [<ffffffff8100cc04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fac0>] ? kthread+0x0/0xa0
 [<ffffffff8100cc00>] ? kernel_thread_helper+0x0/0x10
INFO: task updatedb:2342 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
updatedb        D ffff88011bd77af0  5136  2342   2323 0x00000080
 ffff88011c877cb8 0000000000000086 0000000000000000 ffff88011c1829a8
 0000000000014d00 ffff88011bd77560 ffff88011bd77af0 ffff88011c877fd8
 ffff88011bd77af8 0000000000014d00 ffff88011c876010 0000000000014d00
Call Trace:
 [<ffffffff81165130>] ? sync_buffer+0x0/0x50
 [<ffffffff8149382b>] io_schedule+0x6b/0xb0
 [<ffffffff8116516b>] sync_buffer+0x3b/0x50
 [<ffffffff81494057>] __wait_on_bit+0x57/0x80
 [<ffffffff811699c6>] ? bio_alloc_bioset+0x56/0xf0
 [<ffffffff81165130>] ? sync_buffer+0x0/0x50
 [<ffffffff814940f3>] out_of_line_wait_on_bit+0x73/0x90
 [<ffffffff81080210>] ? wake_bit_function+0x0/0x40
 [<ffffffff81165126>] __wait_on_buffer+0x26/0x30
 [<ffffffffa038006c>] ext3_bread+0x5c/0x80 [ext3]
 [<ffffffffa037ba63>] ext3_readdir+0x1f3/0x600 [ext3]
 [<ffffffff8114a650>] ? filldir+0x0/0xe0
 [<ffffffff8114a650>] ? filldir+0x0/0xe0
 [<ffffffff8114a7e0>] vfs_readdir+0xb0/0xd0
 [<ffffffff8114a964>] sys_getdents+0x84/0xf0
 [<ffffffff8100bdd2>] system_call_fastpath+0x16/0x1b


diff --git a/block/genhd.c b/block/genhd.c
index cbf1112..6a5b772 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1355,7 +1355,7 @@ int invalidate_partition(struct gendisk *disk, int partno)
 	struct block_device *bdev = bdget_disk(disk, partno);
 	if (bdev) {
 		fsync_bdev(bdev);
-		res = __invalidate_device(bdev, true);
+		res = __invalidate_device(bdev);
 		bdput(bdev);
 	}
 	return res;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 77fc76f..b9ba04f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3281,7 +3281,7 @@ static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 			struct block_device *bdev = opened_bdev[cnt];
 			if (!bdev || ITYPE(drive_state[cnt].fd_device) != type)
 				continue;
-			__invalidate_device(bdev, true);
+			__invalidate_device(bdev);
 		}
 		mutex_unlock(&open_lock);
 	} else {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8892870..5aae241 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -934,9 +934,9 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
  * when a disk has been changed -- either by a media change or online
  * resize.
  */
-static void flush_disk(struct block_device *bdev, bool kill_dirty)
+static void flush_disk(struct block_device *bdev)
 {
-	if (__invalidate_device(bdev, kill_dirty)) {
+	if (__invalidate_device(bdev)) {
 		char name[BDEVNAME_SIZE] = "";
 
 		if (bdev->bd_disk)
@@ -973,7 +973,7 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
 		       "%s: detected capacity change from %lld to %lld\n",
 		       name, bdev_size, disk_size);
 		i_size_write(bdev->bd_inode, disk_size);
-		flush_disk(bdev, false);
+		fsync_bdev(bdev);
 	}
 }
 EXPORT_SYMBOL(check_disk_size_change);
@@ -1026,7 +1026,7 @@ int check_disk_change(struct block_device *bdev)
 	if (!(events & DISK_EVENT_MEDIA_CHANGE))
 		return 0;
 
-	flush_disk(bdev, true);
+	flush_disk(bdev);
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
 	return 1;
@@ -1607,7 +1607,7 @@ fail:
 }
 EXPORT_SYMBOL(lookup_bdev);
 
-int __invalidate_device(struct block_device *bdev, bool kill_dirty)
+int __invalidate_device(struct block_device *bdev)
 {
 	struct super_block *sb = get_super(bdev);
 	int res = 0;
@@ -1620,7 +1620,7 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 		 * hold).
 		 */
 		shrink_dcache_sb(sb);
-		res = invalidate_inodes(sb, kill_dirty);
+		res = invalidate_inodes(sb);
 		drop_super(sb);
 	}
 	invalidate_bdev(bdev);
diff --git a/fs/inode.c b/fs/inode.c
index 0647d80..9c2b795 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -548,14 +548,11 @@ void evict_inodes(struct super_block *sb)
 /**
  * invalidate_inodes	- attempt to free all inodes on a superblock
  * @sb:		superblock to operate on
- * @kill_dirty: flag to guide handling of dirty inodes
  *
  * Attempts to free all inodes for a given superblock.  If there were any
  * busy inodes return a non-zero value, else zero.
- * If @kill_dirty is set, discard dirty inodes too, otherwise treat
- * them as busy.
  */
-int invalidate_inodes(struct super_block *sb, bool kill_dirty)
+int invalidate_inodes(struct super_block *sb)
 {
 	int busy = 0;
 	struct inode *inode, *next;
@@ -567,10 +564,6 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE))
 			continue;
-		if (inode->i_state & I_DIRTY && !kill_dirty) {
-			busy = 1;
-			continue;
-		}
 		if (atomic_read(&inode->i_count)) {
 			busy = 1;
 			continue;
diff --git a/fs/internal.h b/fs/internal.h
index f3d15de..bee95ea 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -125,4 +125,4 @@ extern long do_handle_open(int mountdirfd,
  */
 extern int get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
-extern int invalidate_inodes(struct super_block *, bool);
+extern int invalidate_inodes(struct super_block *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 13df14e..ff9a159 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2155,7 +2155,7 @@ extern void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
-extern int __invalidate_device(struct block_device *, bool);
+extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
