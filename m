Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2IRULr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:11:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2IRULp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:11:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<20120628111541.GB17515@quack.suse.cz>
	<Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	<x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	<x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	<1343508252.2626.13184.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
	<1343556630.2626.13257.camel@edumazet-glaptop>
	<1343586962.2626.13266.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
	<x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
	<x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 18 Sep 2012 16:11:26 -0400
In-Reply-To: <Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Tue, 18 Sep 2012 13:04:58 -0400 (EDT)")
Message-ID: <x49ehlzrt01.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> Hi Jeff
>
> Thanks for testing.
>
> It would be interesting ... what happens if you take the patch 3, leave 
> "struct percpu_rw_semaphore bd_block_size_semaphore" in "struct 
> block_device", but remove any use of the semaphore from fs/block_dev.c? - 
> will the performance be like unpatched kernel or like patch 3? It could be 
> that the change in the alignment affects performance on your CPU too, just 
> differently than on my CPU.

It turns out to be exactly the same performance as with the 3rd patch
applied, so I guess it does have something to do with cache alignment.
Here is the patch (against vanilla) I ended up testing.  Let me know if
I've botched it somehow.

So, I next up I'll play similar tricks to what you did (padding struct
block_device in all kernels) to eliminate the differences due to
structure alignment and provide a clear picture of what the locking
effects are.

Thanks!
Jeff


diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 54a3a6d..0bb207e 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -285,7 +285,7 @@ static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
 
 static const struct file_operations raw_fops = {
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.aio_read	= blkdev_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= blkdev_aio_write,
 	.fsync		= blkdev_fsync,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38e721b..c7514b5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -116,6 +116,8 @@ EXPORT_SYMBOL(invalidate_bdev);
 
 int set_blocksize(struct block_device *bdev, int size)
 {
+	struct address_space *mapping;
+
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
 	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
@@ -124,6 +126,16 @@ int set_blocksize(struct block_device *bdev, int size)
 	if (size < bdev_logical_block_size(bdev))
 		return -EINVAL;
 
+	/* Check that the block device is not memory mapped */
+	mapping = bdev->bd_inode->i_mapping;
+	mutex_lock(&mapping->i_mmap_mutex);
+	if (!prio_tree_empty(&mapping->i_mmap) ||
+	    !list_empty(&mapping->i_mmap_nonlinear)) {
+		mutex_unlock(&mapping->i_mmap_mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&mapping->i_mmap_mutex);
+
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_block_size != size) {
 		sync_blockdev(bdev);
@@ -131,6 +143,7 @@ int set_blocksize(struct block_device *bdev, int size)
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
 	}
+
 	return 0;
 }
 
@@ -441,6 +454,12 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
 	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
+
+	if (unlikely(percpu_init_rwsem(&ei->bdev.bd_block_size_semaphore))) {
+		kmem_cache_free(bdev_cachep, ei);
+		return NULL;
+	}
+
 	return &ei->vfs_inode;
 }
 
@@ -449,6 +468,8 @@ static void bdev_i_callback(struct rcu_head *head)
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct bdev_inode *bdi = BDEV_I(inode);
 
+	percpu_free_rwsem(&bdi->bdev.bd_block_size_semaphore);
+
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
@@ -1567,6 +1588,19 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
+ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
+			unsigned long nr_segs, loff_t pos)
+{
+	ssize_t ret;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	percpu_rwsem_ptr p;
+
+	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blkdev_aio_read);
+
 /*
  * Write data to the block device.  Only intended for the block device itself
  * and the raw driver which basically is a fake block device.
@@ -1578,6 +1612,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	struct blk_plug plug;
 	ssize_t ret;
 
@@ -1597,6 +1632,16 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
+int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int ret;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+
+	ret = generic_file_mmap(file, vma);
+
+	return ret;
+}
+
 /*
  * Try to release a page associated with block device when the system
  * is under memory pressure.
@@ -1627,9 +1672,9 @@ const struct file_operations def_blk_fops = {
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..15c481d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/percpu-rwsem.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -724,6 +725,8 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+	/* A semaphore that prevents I/O while block size is being changed */
+	struct percpu_rw_semaphore	bd_block_size_semaphore;
 };
 
 /*
@@ -2564,6 +2567,8 @@ extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
 /* fs/block_dev.c */
+extern ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
