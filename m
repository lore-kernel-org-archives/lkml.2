Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2HaSma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2HaSm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:42:28 -0400
Date: Fri, 31 Aug 2012 14:42:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 2/4] blockdev: fix a crash when block size is changed and
 I/O is issued simultaneously
In-Reply-To: <Pine.LNX.4.64.1208311440350.2212@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1208311441210.2212@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> 
 <20120628111541.GB17515@quack.suse.cz>  <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
  <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> 
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> 
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> 
 <1343508252.2626.13184.camel@edumazet-glaptop> 
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> 
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311440350.2212@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blockdev: fix a crash when block size is changed and I/O is issued simultaneously

The kernel may crash when block size is changed and I/O is issued
simultaneously.

Because some subsystems (udev or lvm) may read any block device anytime,
the bug actually puts any code that changes a block device size in
jeopardy.

The crash can be reproduced if you place "msleep(1000)" to
blkdev_get_blocks just before "bh->b_size = max_blocks <<
inode->i_blkbits;".
Then, run "dd if=/dev/ram0 of=/dev/null bs=4k count=1 iflag=direct"
While it is waiting in msleep, run "blockdev --setbsz 2048 /dev/ram0"
You get a BUG.

The direct and non-direct I/O is written with the assumption that block
size does not change. It doesn't seem practical to fix these crashes
one-by-one there may be many crash possibilities when block size changes
at a certain place and it is impossible to find them all and verify the
code.

This patch introduces a new rw-lock bd_block_size_semaphore. The lock is
taken for read during I/O. It is taken for write when changing block
size. Consequently, block size can't be changed while I/O is being
submitted.

For asynchronous I/O, the patch only prevents block size change while
the I/O is being submitted. The block size can change when the I/O is in
progress or when the I/O is being finished. This is acceptable because
there are no accesses to block size when asynchronous I/O is being
finished.

The patch prevents block size changing while the device is mapped with
mmap.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/char/raw.c |    2 -
 fs/block_dev.c     |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |    2 +
 3 files changed, 61 insertions(+), 3 deletions(-)

Index: linux-3.5-fast/fs/block_dev.c
===================================================================
--- linux-3.5-fast.orig/fs/block_dev.c	2012-08-02 23:05:30.000000000 +0200
+++ linux-3.5-fast/fs/block_dev.c	2012-08-02 23:05:39.000000000 +0200
@@ -116,6 +116,8 @@ EXPORT_SYMBOL(invalidate_bdev);
 
 int set_blocksize(struct block_device *bdev, int size)
 {
+	struct address_space *mapping;
+
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
 	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
@@ -124,6 +126,20 @@ int set_blocksize(struct block_device *b
 	if (size < bdev_logical_block_size(bdev))
 		return -EINVAL;
 
+	/* Prevent starting I/O or mapping the device */
+	down_write(&bdev->bd_block_size_semaphore);
+
+	/* Check that the block device is not memory mapped */
+	mapping = bdev->bd_inode->i_mapping;
+	mutex_lock(&mapping->i_mmap_mutex);
+	if (!prio_tree_empty(&mapping->i_mmap) ||
+	    !list_empty(&mapping->i_mmap_nonlinear)) {
+		mutex_unlock(&mapping->i_mmap_mutex);
+		up_write(&bdev->bd_block_size_semaphore);
+		return -EBUSY;
+	}
+	mutex_unlock(&mapping->i_mmap_mutex);
+
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_block_size != size) {
 		sync_blockdev(bdev);
@@ -131,6 +147,9 @@ int set_blocksize(struct block_device *b
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
 	}
+
+	up_write(&bdev->bd_block_size_semaphore);
+
 	return 0;
 }
 
@@ -472,6 +491,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
+	init_rwsem(&bdev->bd_block_size_semaphore);
 }
 
 static inline void __bd_forget(struct inode *inode)
@@ -1567,6 +1587,22 @@ static long block_ioctl(struct file *fil
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
+ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
+			unsigned long nr_segs, loff_t pos)
+{
+	ssize_t ret;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+
+	down_read(&bdev->bd_block_size_semaphore);
+
+	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
+
+	up_read(&bdev->bd_block_size_semaphore);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blkdev_aio_read);
+
 /*
  * Write data to the block device.  Only intended for the block device itself
  * and the raw driver which basically is a fake block device.
@@ -1578,10 +1614,13 @@ ssize_t blkdev_aio_write(struct kiocb *i
 			 unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
 
+	down_read(&bdev->bd_block_size_semaphore);
+
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
 		ssize_t err;
@@ -1590,10 +1629,27 @@ ssize_t blkdev_aio_write(struct kiocb *i
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
+
+	up_read(&bdev->bd_block_size_semaphore);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
+int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int ret;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+
+	down_read(&bdev->bd_block_size_semaphore);
+
+	ret = generic_file_mmap(file, vma);
+
+	up_read(&bdev->bd_block_size_semaphore);
+
+	return ret;
+}
+
 /*
  * Try to release a page associated with block device when the system
  * is under memory pressure.
@@ -1624,9 +1680,9 @@ const struct file_operations def_blk_fop
 	.llseek		= block_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-  	.aio_read	= generic_file_aio_read,
+  	.aio_read	= blkdev_aio_read,
 	.aio_write	= blkdev_aio_write,
-	.mmap		= generic_file_mmap,
+	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT
Index: linux-3.5-fast/drivers/char/raw.c
===================================================================
--- linux-3.5-fast.orig/drivers/char/raw.c	2012-08-02 23:05:11.000000000 +0200
+++ linux-3.5-fast/drivers/char/raw.c	2012-08-02 23:05:39.000000000 +0200
@@ -285,7 +285,7 @@ static long raw_ctl_compat_ioctl(struct
 
 static const struct file_operations raw_fops = {
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.aio_read	= blkdev_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= blkdev_aio_write,
 	.fsync		= blkdev_fsync,
Index: linux-3.5-fast/include/linux/fs.h
===================================================================
--- linux-3.5-fast.orig/include/linux/fs.h	2012-08-02 23:05:38.000000000 +0200
+++ linux-3.5-fast/include/linux/fs.h	2012-08-02 23:05:39.000000000 +0200
@@ -2416,6 +2416,8 @@ extern int generic_segment_checks(const
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
 /* fs/block_dev.c */
+extern ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,

