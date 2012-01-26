Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2AZVky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:40:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2AZVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:40:52 -0500
Date: Thu, 26 Jan 2012 13:40:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
Message-Id: <20120126134051.6add3cd2.akpm@linux-foundation.org>
In-Reply-To: <1327584802-14298-1-git-send-email-ndevos@redhat.com>
References: <4F213E1A.4060808@redhat.com>
	<1327584802-14298-1-git-send-email-ndevos@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 13:33:22 +0000
Niels de Vos <ndevos@redhat.com> wrote:

> Executing an fsync() on a file-descriptor of a partition flushes the
> caches for that partition by calling blkdev_fsync(). However, it seems
> that reading data through the parent device will still return the old
> cached data.
> 
> The problem can be worked around by forcing the caches to be flushed
> with either
> 	# blockdev --flushbufs ${dev_disk}
> or
> 	# echo 3 > /proc/sys/vm/drop_caches
> 
> One of the use-cases that shows this problem:
> 1) create two or more partitions on a device
>    - use fdisk to create /dev/sdb1 and /dev/sdb2
> 2) format and mount one of the partition
>    - mkfs -t ext3 /dev/sdb1
> 3) read through the main device to have something in the cache
>    - read /dev/sdb with dd or use something like "parted /dev/sdb print"
> 4) now write something to /dev/sdb2, format the partition for example
>    - mkfs -t ext3 /dev/sdb2
> 5) read the blocks where sdb2 starts, through /dev/sdb
>    - use dd or do again a "parted /dev/sdb print"
> 
> The cache for the block-device is not synced if the block-device is kept
> open (due to a mounted partition, for example). Only when all users for
> the disk have exited, the cache for the disk is made consistent again.
> 
> Without this patch, calling "blockdev --flushbufs" or dropping the
> caches, the result in 5) is the same as in 3). Reading the same area
> through /dev/sdb2 shows the inconsistancy between the two caches.
> 
> ...
>
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -424,6 +424,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
>  	if (error == -EOPNOTSUPP)
>  		error = 0;
>  
> +	/* invalidate parent block_device */
> +	if (!error && bdev != bdev->bd_contains)
> +		invalidate_bdev(bdev->bd_contains);
> +
>  	return error;
>  }
>  EXPORT_SYMBOL(blkdev_fsync);

I can't say I'm a huge fan of this.  It just isn't logical to drop
/dev/sda's pagecache in here.

We're adapting the kernel to the behavior of existing userspace by
inserting a useful side-effect into a suprising place.  The result is
pretty darned hacky.

The Right Thing To Do here is to make the kernel behave logically and
predictably, then modify the userspace tools.  But if we're modifying
the userspace tools then we would just change userspace to issue a
BLKFLSBUF to /dev/sda and leave the kernel alone.

So hm.  I think I might prefer to leave the issue unfixed rather than
doing this to the poor old kernel :(

