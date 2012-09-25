Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2IYWtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2IYWth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:49:37 -0400
Date: Tue, 25 Sep 2012 18:49:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Jeff Moyer <jmoyer@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 1/2] Fix a crash when block device is read and block size is
 changed at the same time
In-Reply-To: <5061F3D2.6050502@kernel.dk>
Message-ID: <Pine.LNX.4.64.1209251847340.21075@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
 <1343508252.2626.13184.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
 <x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
 <x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
 <x49ehlzrt01.fsf@segfault.boston.devel.redhat.com>
 <x49sja6ouv4.fsf@segfault.boston.devel.redhat.com> <5061F0E6.5000403@kernel.dk>
 <5061F3D2.6050502@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Sep 2012, Jens Axboe wrote:

> On 2012-09-25 19:59, Jens Axboe wrote:
> > On 2012-09-25 19:49, Jeff Moyer wrote:
> >> Jeff Moyer <jmoyer@redhat.com> writes:
> >>
> >>> Mikulas Patocka <mpatocka@redhat.com> writes:
> >>>
> >>>> Hi Jeff
> >>>>
> >>>> Thanks for testing.
> >>>>
> >>>> It would be interesting ... what happens if you take the patch 3, leave 
> >>>> "struct percpu_rw_semaphore bd_block_size_semaphore" in "struct 
> >>>> block_device", but remove any use of the semaphore from fs/block_dev.c? - 
> >>>> will the performance be like unpatched kernel or like patch 3? It could be 
> >>>> that the change in the alignment affects performance on your CPU too, just 
> >>>> differently than on my CPU.
> >>>
> >>> It turns out to be exactly the same performance as with the 3rd patch
> >>> applied, so I guess it does have something to do with cache alignment.
> >>> Here is the patch (against vanilla) I ended up testing.  Let me know if
> >>> I've botched it somehow.
> >>>
> >>> So, I next up I'll play similar tricks to what you did (padding struct
> >>> block_device in all kernels) to eliminate the differences due to
> >>> structure alignment and provide a clear picture of what the locking
> >>> effects are.
> >>
> >> After trying again with the same padding you used in the struct
> >> bdev_inode, I see no performance differences between any of the
> >> patches.  I tried bumping up the number of threads to saturate the
> >> number of cpus on a single NUMA node on my hardware, but that resulted
> >> in lower IOPS to the device, and hence consumption of less CPU time.
> >> So, I believe my results to be inconclusive.
> >>
> >> After talking with Vivek about the problem, he had mentioned that it
> >> might be worth investigating whether bd_block_size could be protected
> >> using SRCU.  I looked into it, and the one thing I couldn't reconcile is
> >> updating both the bd_block_size and the inode->i_blkbits at the same
> >> time.  It would involve (afaiui) adding fields to both the inode and the
> >> block_device data structures and using rcu_assign_pointer  and
> >> rcu_dereference to modify and access the fields, and both fields would
> >> need to protected by the same struct srcu_struct.  I'm not sure whether
> >> that's a desirable approach.  When I started to implement it, it got
> >> ugly pretty quickly.  What do others think?
> >>
> >> For now, my preference is to get the full patch set in.  I will continue
> >> to investigate the performance impact of the data structure size changes
> >> that I've been seeing.
> >>
> >> So, for the four patches:
> >>
> >> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> >>
> >> Jens, can you have a look at the patch set?  We are seeing problem
> >> reports of this in the wild[1][2].
> > 
> > I'll queue it up for 3.7. I can run my regular testing on the 8-way, it
> > has a nack for showing scaling problems very nicely in aio/dio. As long
> > as we're not adding per-inode cache line dirtying per IO (and the
> > per-cpu rw sem looks OK), then I don't think there's too much to worry
> > about.
> 
> I take that back. The series doesn't apply to my current tree. Not too
> unexpected, since it's some weeks old. But more importantly, please send
> this is a "real" patch series. I don't want to see two implementations
> of rw semaphores. I think it's perfectly fine to first do a regular rw
> sem, then a last patch adding the cache friendly variant from Eric and
> converting to that.
> 
> In other words, get rid of 3/4.
> 
> -- 
> Jens Axboe

Hi Jens

Here I'm resending it as two patches. The first one uses existing 
semaphore, the second converts it to RCU-based percpu semaphore.

Mikulas

---

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
 fs/block_dev.c     |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |    4 +++
 3 files changed, 65 insertions(+), 3 deletions(-)

Index: linux-2.6-copy/include/linux/fs.h
===================================================================
--- linux-2.6-copy.orig/include/linux/fs.h	2012-09-03 15:55:47.000000000 +0200
+++ linux-2.6-copy/include/linux/fs.h	2012-09-26 00:41:07.000000000 +0200
@@ -724,6 +724,8 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+	/* A semaphore that prevents I/O while block size is being changed */
+	struct rw_semaphore	bd_block_size_semaphore;
 };
 
 /*
@@ -2564,6 +2566,8 @@ extern int generic_segment_checks(const 
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
 /* fs/block_dev.c */
+extern ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
Index: linux-2.6-copy/fs/block_dev.c
===================================================================
--- linux-2.6-copy.orig/fs/block_dev.c	2012-09-03 15:55:44.000000000 +0200
+++ linux-2.6-copy/fs/block_dev.c	2012-09-26 00:42:49.000000000 +0200
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
@@ -1578,12 +1614,16 @@ ssize_t blkdev_aio_write(struct kiocb *i
 			 unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	struct blk_plug plug;
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
 
 	blk_start_plug(&plug);
+
+	down_read(&bdev->bd_block_size_semaphore);
+
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
 		ssize_t err;
@@ -1592,11 +1632,29 @@ ssize_t blkdev_aio_write(struct kiocb *i
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
+
+	up_read(&bdev->bd_block_size_semaphore);
+
 	blk_finish_plug(&plug);
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
@@ -1627,9 +1685,9 @@ const struct file_operations def_blk_fop
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
Index: linux-2.6-copy/drivers/char/raw.c
===================================================================
--- linux-2.6-copy.orig/drivers/char/raw.c	2012-09-01 00:14:45.000000000 +0200
+++ linux-2.6-copy/drivers/char/raw.c	2012-09-26 00:41:07.000000000 +0200
@@ -285,7 +285,7 @@ static long raw_ctl_compat_ioctl(struct 
 
 static const struct file_operations raw_fops = {
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.aio_read	= blkdev_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= blkdev_aio_write,
 	.fsync		= blkdev_fsync,
