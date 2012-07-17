Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2GQTTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab2GQTTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:19:19 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@vger.kernel.org, dm-devel@redhat.com, lwoodman@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>, kosaki.motohiro@jp.fujitsu.com
Subject: Re: Crash when IO is being submitted and block size is changed
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<20120628111541.GB17515@quack.suse.cz>
	<Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 17 Jul 2012 15:19:01 -0400
In-Reply-To: <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Sun, 15 Jul 2012 20:55:02 -0400 (EDT)")
Message-ID: <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Thu, 28 Jun 2012, Jan Kara wrote:
>
>> On Wed 27-06-12 23:04:09, Mikulas Patocka wrote:
>> > The kernel crashes when IO is being submitted to a block device and block 
>> > size of that device is changed simultaneously.
>>   Nasty ;-)
>> 
>> > To reproduce the crash, apply this patch:
>> > 
>> > --- linux-3.4.3-fast.orig/fs/block_dev.c 2012-06-27 20:24:07.000000000 +0200
>> > +++ linux-3.4.3-fast/fs/block_dev.c 2012-06-27 20:28:34.000000000 +0200
>> > @@ -28,6 +28,7 @@
>> >  #include <linux/log2.h>
>> >  #include <linux/cleancache.h>
>> >  #include <asm/uaccess.h> 
>> > +#include <linux/delay.h>
>> >  #include "internal.h"
>> >  struct bdev_inode {
>> > @@ -203,6 +204,7 @@ blkdev_get_blocks(struct inode *inode, s
>> >  
>> >  	bh->b_bdev = I_BDEV(inode);
>> >  	bh->b_blocknr = iblock;
>> > +	msleep(1000);
>> >  	bh->b_size = max_blocks << inode->i_blkbits;
>> >  	if (max_blocks)
>> >  		set_buffer_mapped(bh);
>> > 
>> > Use some device with 4k blocksize, for example a ramdisk.
>> > Run "dd if=/dev/ram0 of=/dev/null bs=4k count=1 iflag=direct"
>> > While it is sleeping in the msleep function, run "blockdev --setbsz 2048 
>> > /dev/ram0" on the other console.
>> > You get a BUG at fs/direct-io.c:1013 - BUG_ON(this_chunk_bytes == 0);
>> > 
>> > 
>> > One may ask "why would anyone do this - submit I/O and change block size 
>> > simultaneously?" - the problem is that udev and lvm can scan and read all 
>> > block devices anytime - so anytime you change block device size, there may 
>> > be some i/o to that device in flight and the crash may happen. That BUG 
>> > actually happened in production environment because of lvm scanning block 
>> > devices and some other software changing block size at the same time.
>> > 
>>   Yeah, it's nasty and neither solution looks particularly appealing. One
>> idea that came to my mind is: I'm trying to solve some races between direct
>> IO, buffered IO, hole punching etc. by a new mapping interval lock. I'm not
>> sure if it will go anywhere yet but if it does, we can fix the above race
>> by taking the mapping lock for the whole block device around setting block
>> size thus effectivelly disallowing any IO to it.
>> 
>> 								Honza
>> -- 
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
>> 
>
> Hi
>
> This is the patch that fixes this crash: it takes a rw-semaphore around 
> all direct-IO path.
>
> (note that if someone is concerned about performance, the rw-semaphore 
> could be made per-cpu --- take it for read on the current CPU and take it 
> for write on all CPUs).

Here we go again.  :-)  I believe we had at one point tried taking a rw
semaphore around GUP inside of the direct I/O code path to fix the fork
vs. GUP race (that still exists today).  When testing that, the overhead
of the semaphore was *way* too high to be considered an acceptable
solution.  I've CC'd Larry Woodman, Andrea, and Kosaki Motohiro who all
worked on that particular bug.  Hopefully they can give better
quantification of the slowdown than my poor memory.

Cheers,
Jeff


> blockdev: fix a crash when block size is changed and I/O is issued simultaneously
>
> The kernel may crash when block size is changed and I/O is issued
> simultaneously.
>
> Because some subsystems (udev or lvm) may read any block device anytime,
> the bug actually puts any code that changes a block device size in
> jeopardy.
>
> The crash can be reproduced if you place "msleep(1000)" to
> blkdev_get_blocks just before "bh->b_size = max_blocks <<
> inode->i_blkbits;".
> Then, run "dd if=/dev/ram0 of=/dev/null bs=4k count=1 iflag=direct"
> While it is waiting in msleep, run "blockdev --setbsz 2048 /dev/ram0"
> You get a BUG.
>
> The direct and non-direct I/O is written with the assumption that block
> size does not change. It doesn't seem practical to fix these crashes
> one-by-one there may be many crash possibilities when block size changes
> at a certain place and it is impossible to find them all and verify the
> code.
>
> This patch introduces a new rw-lock bd_block_size_semaphore. The lock is
> taken for read during I/O. It is taken for write when changing block
> size. Consequently, block size can't be changed while I/O is being
> submitted.
>
> For asynchronous I/O, the patch only prevents block size change while
> the I/O is being submitted. The block size can change when the I/O is in
> progress or when the I/O is being finished. This is acceptable because
> there are no accesses to block size when asynchronous I/O is being
> finished.
>
> The patch prevents block size changing while the device is mapped with
> mmap.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/char/raw.c |    2 -
>  fs/block_dev.c     |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/fs.h |    4 +++
>  3 files changed, 61 insertions(+), 3 deletions(-)
>
> Index: linux-3.5-rc6-devel/include/linux/fs.h
> ===================================================================
> --- linux-3.5-rc6-devel.orig/include/linux/fs.h	2012-07-16 01:18:45.000000000 +0200
> +++ linux-3.5-rc6-devel/include/linux/fs.h	2012-07-16 01:29:21.000000000 +0200
> @@ -713,6 +713,8 @@ struct block_device {
>  	int			bd_fsfreeze_count;
>  	/* Mutex for freeze */
>  	struct mutex		bd_fsfreeze_mutex;
> +	/* A semaphore that prevents I/O while block size is being changed */
> +	struct rw_semaphore	bd_block_size_semaphore;
>  };
>  
>  /*
> @@ -2414,6 +2416,8 @@ extern int generic_segment_checks(const 
>  		unsigned long *nr_segs, size_t *count, int access_flags);
>  
>  /* fs/block_dev.c */
> +extern ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
> +			       unsigned long nr_segs, loff_t pos);
>  extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				unsigned long nr_segs, loff_t pos);
>  extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
> Index: linux-3.5-rc6-devel/fs/block_dev.c
> ===================================================================
> --- linux-3.5-rc6-devel.orig/fs/block_dev.c	2012-07-16 01:14:33.000000000 +0200
> +++ linux-3.5-rc6-devel/fs/block_dev.c	2012-07-16 01:37:28.000000000 +0200
> @@ -124,6 +124,20 @@ int set_blocksize(struct block_device *b
>  	if (size < bdev_logical_block_size(bdev))
>  		return -EINVAL;
>  
> +	/* Prevent starting I/O or mapping the device */
> +	down_write(&bdev->bd_block_size_semaphore);
> +
> +	/* Check that the block device is not memory mapped */
> +	mapping = bdev->bd_inode->i_mapping;
> +	mutex_lock(&mapping->i_mmap_mutex);
> +	if (!prio_tree_empty(&mapping->i_mmap) ||
> +	    !list_empty(&mapping->i_mmap_nonlinear)) {
> +		mutex_unlock(&mapping->i_mmap_mutex);
> +		up_write(&bdev->bd_block_size_semaphore);
> +		return -EBUSY;
> +	}
> +	mutex_unlock(&mapping->i_mmap_mutex);
> +
>  	/* Don't change the size if it is same as current */
>  	if (bdev->bd_block_size != size) {
>  		sync_blockdev(bdev);
> @@ -131,6 +145,9 @@ int set_blocksize(struct block_device *b
>  		bdev->bd_inode->i_blkbits = blksize_bits(size);
>  		kill_bdev(bdev);
>  	}
> +
> +	up_write(&bdev->bd_block_size_semaphore);
> +
>  	return 0;
>  }
>  
> @@ -472,6 +489,7 @@ static void init_once(void *foo)
>  	inode_init_once(&ei->vfs_inode);
>  	/* Initialize mutex for freeze. */
>  	mutex_init(&bdev->bd_fsfreeze_mutex);
> +	init_rwsem(&bdev->bd_block_size_semaphore);
>  }
>  
>  static inline void __bd_forget(struct inode *inode)
> @@ -1567,6 +1585,22 @@ static long block_ioctl(struct file *fil
>  	return blkdev_ioctl(bdev, mode, cmd, arg);
>  }
>  
> +ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
> +			unsigned long nr_segs, loff_t pos)
> +{
> +	ssize_t ret;
> +	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
> +
> +	down_read(&bdev->bd_block_size_semaphore);
> +
> +	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
> +
> +	up_read(&bdev->bd_block_size_semaphore);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(blkdev_aio_read);
> +
>  /*
>   * Write data to the block device.  Only intended for the block device itself
>   * and the raw driver which basically is a fake block device.
> @@ -1578,10 +1612,13 @@ ssize_t blkdev_aio_write(struct kiocb *i
>  			 unsigned long nr_segs, loff_t pos)
>  {
>  	struct file *file = iocb->ki_filp;
> +	struct block_device *bdev = I_BDEV(file->f_mapping->host);
>  	ssize_t ret;
>  
>  	BUG_ON(iocb->ki_pos != pos);
>  
> +	down_read(&bdev->bd_block_size_semaphore);
> +
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	if (ret > 0 || ret == -EIOCBQUEUED) {
>  		ssize_t err;
> @@ -1590,10 +1627,27 @@ ssize_t blkdev_aio_write(struct kiocb *i
>  		if (err < 0 && ret > 0)
>  			ret = err;
>  	}
> +
> +	up_read(&bdev->bd_block_size_semaphore);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(blkdev_aio_write);
>  
> +int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	int ret;
> +	struct block_device *bdev = I_BDEV(file->f_mapping->host);
> +
> +	down_read(&bdev->bd_block_size_semaphore);
> +
> +	ret = generic_file_mmap(file, vma);
> +
> +	up_read(&bdev->bd_block_size_semaphore);
> +
> +	return ret;
> +}
> +
>  /*
>   * Try to release a page associated with block device when the system
>   * is under memory pressure.
> @@ -1624,9 +1678,9 @@ const struct file_operations def_blk_fop
>  	.llseek		= block_llseek,
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
> -  	.aio_read	= generic_file_aio_read,
> +  	.aio_read	= blkdev_aio_read,
>  	.aio_write	= blkdev_aio_write,
> -	.mmap		= generic_file_mmap,
> +	.mmap		= blkdev_mmap,
>  	.fsync		= blkdev_fsync,
>  	.unlocked_ioctl	= block_ioctl,
>  #ifdef CONFIG_COMPAT
> Index: linux-3.5-rc6-devel/drivers/char/raw.c
> ===================================================================
> --- linux-3.5-rc6-devel.orig/drivers/char/raw.c	2012-07-16 01:29:27.000000000 +0200
> +++ linux-3.5-rc6-devel/drivers/char/raw.c	2012-07-16 01:30:04.000000000 +0200
> @@ -285,7 +285,7 @@ static long raw_ctl_compat_ioctl(struct 
>  
>  static const struct file_operations raw_fops = {
>  	.read		= do_sync_read,
> -	.aio_read	= generic_file_aio_read,
> +	.aio_read	= blkdev_aio_read,
>  	.write		= do_sync_write,
>  	.aio_write	= blkdev_aio_write,
>  	.fsync		= blkdev_fsync,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
