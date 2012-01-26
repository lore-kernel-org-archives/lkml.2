Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2AZWNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:13:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2AZWNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:13:32 -0500
Date: Thu, 26 Jan 2012 17:13:29 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Niels de Vos <ndevos@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
In-Reply-To: <20120126134051.6add3cd2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1201261651090.28710@hs20-bc2-1.build.redhat.com>
References: <4F213E1A.4060808@redhat.com> <1327584802-14298-1-git-send-email-ndevos@redhat.com>
 <20120126134051.6add3cd2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jan 2012, Andrew Morton wrote:

> On Thu, 26 Jan 2012 13:33:22 +0000
> Niels de Vos <ndevos@redhat.com> wrote:
> 
> > Executing an fsync() on a file-descriptor of a partition flushes the
> > caches for that partition by calling blkdev_fsync(). However, it seems
> > that reading data through the parent device will still return the old
> > cached data.
> > 
> > The problem can be worked around by forcing the caches to be flushed
> > with either
> > 	# blockdev --flushbufs ${dev_disk}
> > or
> > 	# echo 3 > /proc/sys/vm/drop_caches
> > 
> > One of the use-cases that shows this problem:
> > 1) create two or more partitions on a device
> >    - use fdisk to create /dev/sdb1 and /dev/sdb2
> > 2) format and mount one of the partition
> >    - mkfs -t ext3 /dev/sdb1
> > 3) read through the main device to have something in the cache
> >    - read /dev/sdb with dd or use something like "parted /dev/sdb print"
> > 4) now write something to /dev/sdb2, format the partition for example
> >    - mkfs -t ext3 /dev/sdb2
> > 5) read the blocks where sdb2 starts, through /dev/sdb
> >    - use dd or do again a "parted /dev/sdb print"
> > 
> > The cache for the block-device is not synced if the block-device is kept
> > open (due to a mounted partition, for example). Only when all users for
> > the disk have exited, the cache for the disk is made consistent again.
> > 
> > Without this patch, calling "blockdev --flushbufs" or dropping the
> > caches, the result in 5) is the same as in 3). Reading the same area
> > through /dev/sdb2 shows the inconsistancy between the two caches.
> > 
> > ...
> >
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -424,6 +424,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
> >  	if (error == -EOPNOTSUPP)
> >  		error = 0;
> >  
> > +	/* invalidate parent block_device */
> > +	if (!error && bdev != bdev->bd_contains)
> > +		invalidate_bdev(bdev->bd_contains);
> > +
> >  	return error;
> >  }
> >  EXPORT_SYMBOL(blkdev_fsync);
> 
> I can't say I'm a huge fan of this.  It just isn't logical to drop
> /dev/sda's pagecache in here.
> 
> We're adapting the kernel to the behavior of existing userspace by
> inserting a useful side-effect into a suprising place.  The result is
> pretty darned hacky.
> 
> The Right Thing To Do here is to make the kernel behave logically and
> predictably, then modify the userspace tools.  But if we're modifying
> the userspace tools then we would just change userspace to issue a
> BLKFLSBUF to /dev/sda and leave the kernel alone.

And how should userspace find out if the device is a partition and what is 
the master device? For example, if I tell you that you have a block 
device with major 259 and minor 2, how will you find out:
1) is it a partition or not?
2) what is the whole-disk device?

Do you think that userspace should recursively scan /sys/block to find out 
disk-partition relationships?

> So hm.  I think I might prefer to leave the issue unfixed rather than
> doing this to the poor old kernel :(

The major problem here is that "invalidate_bdev" is unreliable. 
"invalidate_bdev" skips blocks that are beign read or written. udev may 
open and read any block device anytime. Consequently, "invalidate_bdev" 
may skip to invalidate any block device anytime (if it happens to be 
racing with udev).

But this problem is irrelevant w.r.t the patch - the patch makes it 
neither better nor worse. If someone executes "blockdev --flushbufs" or 
ioctl BLKFLSBUF, it may not flush all buffers.

If you want to make the kernel behave predictably, you should fix 
"invalidate_bdev" so that it invalidates the whole device, even if someone 
is readint it.

Mikulas
