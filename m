Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2AZLwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2AZLwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:52:34 -0500
Message-ID: <4F213E1A.4060808@redhat.com>
Date: Thu, 26 Jan 2012 11:50:50 +0000
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Bryn M. Reeves" <bmr@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
References: <4F19356E.3020708@redhat.com> <1327315109-7740-1-git-send-email-ndevos@redhat.com> <20120126020344.b3194916.akpm@linux-foundation.org>
In-Reply-To: <20120126020344.b3194916.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 10:03 AM, Andrew Morton wrote:
> I suggest a viro cc on this one.
> 
> On Mon, 23 Jan 2012 10:38:29 +0000 Niels de Vos <ndevos@redhat.com> wrote:
> 
>> Executing an fsync() on a file-descriptor of a partition flushes the
>> caches for that partition by calling blkdev_issue_flush(). However, it
> 
> The changelog is stale.

Hmm, looks like it. I'll update it and send out a corrected patch soon.

>> seems that reading data through the parent device will still return the
>> old cached data.
>>
>> The cache for the block-device is not synced if the block-device is kept
>> open (due to a mounted partition, for example). Only when all users for
>> the disk have exited, the cache for the disk is made consistent again.
>>
>> Calling invalidate_bdev() on the parent block-device in case
>> blkdev_fsync() was called for a partition, fixes this.
>>
>> The problem can be worked around by forcing the caches to be flushed
>> with either
>> 	# blockdev --flushbufs ${dev_disk}
>> or
>> 	# echo 3 > /proc/sys/vm/drop_caches
> 
> Please include your (useful) problem description in the changelog:
> 
> : The problem that was noticed is the following:
> : 1) create two or more partitions on a device
> :    - use fdisk to create /dev/sdb1 and /dev/sdb2
> : 2) format and mount one of the partition
> :    - mkfs -t ext3 /dev/sdb1
> : 3) read through the main device to have something in the cache
> :    - read /dev/sdb with dd or use something like "parted /dev/sdb print"
> : 4) now write something to /dev/sdb2, format the partition for example
> :    - mkfs -t ext3 /dev/sdb2
> : 5) read the blocks where sdb2 starts, through /dev/sdb
> :    - use dd or do again a "parted /dev/sdb print"
> : 
> : Without this patch, calling "blockdev --flushbufs" or dropping the
> : caches, the result in 5) is the same as in 3). Reading the same area
> : through /dev/sdb2 shows the inconsistancy between the two caches.
> : 
> : With this patch, or one of the workarounds, the data read through
> : /dev/sdb and /dev/sdb2 is the same.

I'll include this too.

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
> 
> It doesn't seem terribly logical to do this in blkdev_fsync().  Why not
> do it right there in blkdev_ioctl()'s "case BLKFLSBUF"?

Most userspace tools do not call the blkdev_ioctl(), but only do a
fsync(). Therefore it does not help existing tools if we update that
calling path. I agree it seems more logical to make the change there,
but it is out of scope for the use-cases I have seen until now.

> Bear in mind that invalidate_bdev() isn't a very strong function -
> it won't drop pages which are dirty or under writeback nor pages which
> others have a reference on.  But I can see that this change would be a
> best-effort user-convenience thing.

It is only intended to refresh the read caches. The writeback path
should not be affected.

Thanks for the feedback,
Niels
