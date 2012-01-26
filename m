Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2AZJ5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:57:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZJ5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:57:49 -0500
Date: Thu, 26 Jan 2012 02:03:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Bryn M. Reeves" <bmr@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
Message-Id: <20120126020344.b3194916.akpm@linux-foundation.org>
In-Reply-To: <1327315109-7740-1-git-send-email-ndevos@redhat.com>
References: <4F19356E.3020708@redhat.com>
	<1327315109-7740-1-git-send-email-ndevos@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suggest a viro cc on this one.

On Mon, 23 Jan 2012 10:38:29 +0000 Niels de Vos <ndevos@redhat.com> wrote:

> Executing an fsync() on a file-descriptor of a partition flushes the
> caches for that partition by calling blkdev_issue_flush(). However, it

The changelog is stale.

> seems that reading data through the parent device will still return the
> old cached data.
> 
> The cache for the block-device is not synced if the block-device is kept
> open (due to a mounted partition, for example). Only when all users for
> the disk have exited, the cache for the disk is made consistent again.
> 
> Calling invalidate_bdev() on the parent block-device in case
> blkdev_fsync() was called for a partition, fixes this.
> 
> The problem can be worked around by forcing the caches to be flushed
> with either
> 	# blockdev --flushbufs ${dev_disk}
> or
> 	# echo 3 > /proc/sys/vm/drop_caches

Please include your (useful) problem description in the changelog:

: The problem that was noticed is the following:
: 1) create two or more partitions on a device
:    - use fdisk to create /dev/sdb1 and /dev/sdb2
: 2) format and mount one of the partition
:    - mkfs -t ext3 /dev/sdb1
: 3) read through the main device to have something in the cache
:    - read /dev/sdb with dd or use something like "parted /dev/sdb print"
: 4) now write something to /dev/sdb2, format the partition for example
:    - mkfs -t ext3 /dev/sdb2
: 5) read the blocks where sdb2 starts, through /dev/sdb
:    - use dd or do again a "parted /dev/sdb print"
: 
: Without this patch, calling "blockdev --flushbufs" or dropping the
: caches, the result in 5) is the same as in 3). Reading the same area
: through /dev/sdb2 shows the inconsistancy between the two caches.
: 
: With this patch, or one of the workarounds, the data read through
: /dev/sdb and /dev/sdb2 is the same.

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

It doesn't seem terribly logical to do this in blkdev_fsync().  Why not
do it right there in blkdev_ioctl()'s "case BLKFLSBUF"?

Bear in mind that invalidate_bdev() isn't a very strong function -
it won't drop pages which are dirty or under writeback nor pages which
others have a reference on.  But I can see that this change would be a
best-effort user-convenience thing.

