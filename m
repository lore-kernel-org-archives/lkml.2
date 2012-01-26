Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2AZVtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:49:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2AZVtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:49:08 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Niels de Vos <ndevos@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device if fsync() is called for a partition
References: <4F213E1A.4060808@redhat.com>
	<1327584802-14298-1-git-send-email-ndevos@redhat.com>
	<20120126134051.6add3cd2.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 26 Jan 2012 16:49:06 -0500
In-Reply-To: <20120126134051.6add3cd2.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 26 Jan 2012 13:40:51 -0800")
Message-ID: <x491uqmyw19.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 26 Jan 2012 13:33:22 +0000
> Niels de Vos <ndevos@redhat.com> wrote:
>
>> Executing an fsync() on a file-descriptor of a partition flushes the
>> caches for that partition by calling blkdev_fsync(). However, it seems
>> that reading data through the parent device will still return the old
>> cached data.
>> 
>> The problem can be worked around by forcing the caches to be flushed
>> with either
>> 	# blockdev --flushbufs ${dev_disk}
>> or
>> 	# echo 3 > /proc/sys/vm/drop_caches
>> 
>> One of the use-cases that shows this problem:
>> 1) create two or more partitions on a device
>>    - use fdisk to create /dev/sdb1 and /dev/sdb2
>> 2) format and mount one of the partition
>>    - mkfs -t ext3 /dev/sdb1
>> 3) read through the main device to have something in the cache
>>    - read /dev/sdb with dd or use something like "parted /dev/sdb print"
>> 4) now write something to /dev/sdb2, format the partition for example
>>    - mkfs -t ext3 /dev/sdb2
>> 5) read the blocks where sdb2 starts, through /dev/sdb
>>    - use dd or do again a "parted /dev/sdb print"
>> 
>> The cache for the block-device is not synced if the block-device is kept
>> open (due to a mounted partition, for example). Only when all users for
>> the disk have exited, the cache for the disk is made consistent again.
>> 
>> Without this patch, calling "blockdev --flushbufs" or dropping the
>> caches, the result in 5) is the same as in 3). Reading the same area
>> through /dev/sdb2 shows the inconsistancy between the two caches.
>> 
>> ...
>>
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -424,6 +424,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
>>  	if (error == -EOPNOTSUPP)
>>  		error = 0;
>>  
>> +	/* invalidate parent block_device */
>> +	if (!error && bdev != bdev->bd_contains)
>> +		invalidate_bdev(bdev->bd_contains);
>> +
>>  	return error;
>>  }
>>  EXPORT_SYMBOL(blkdev_fsync);
>
> I can't say I'm a huge fan of this.  It just isn't logical to drop
> /dev/sda's pagecache in here.
>
> We're adapting the kernel to the behavior of existing userspace by
> inserting a useful side-effect into a suprising place.  The result is
> pretty darned hacky.
>
> The Right Thing To Do here is to make the kernel behave logically and
> predictably, then modify the userspace tools.

To me, logically the caches should not be separate.  /dev/sda and
/dev/sda1 are the same underlying device, after all, and there shouldn't
be any cache aliases.  Unfortunately, that sounds like a rather large
change to me, with a completely new set of side effects to deal with.

> But if we're modifying the userspace tools then we would just change
> userspace to issue a BLKFLSBUF to /dev/sda and leave the kernel alone.
>
> So hm.  I think I might prefer to leave the issue unfixed rather than
> doing this to the poor old kernel :(

I could certainly understand taking this stance.

Cheers,
Jeff
