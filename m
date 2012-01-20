Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2ATJh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2ATJhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:37:25 -0500
Message-ID: <4F19356E.3020708@redhat.com>
Date: Fri, 20 Jan 2012 09:35:42 +0000
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: linux-kernel@vger.kernel.org, "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] block: Invalidate the cache for a parent block-device
References: <Pine.LNX.4.64.1201192057540.17908@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1201192057540.17908@hs20-bc2-1.build.redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 01:58 AM, Mikulas Patocka wrote:
> This definitely doesn't belong to blkdev_issue_flush.
> 
> blkdev_issue_flush is called by filesystems each time they want to 
> synchronize hardware disk cache (for example, when committing a journal).

Ay, that sounds bad.

> The patch may cause serious performance regressions (each time a 
> filesystem commits journal, the patch causes it to walk all buffers in the 
> whole-disk device).
> 
> You should put this code into fsync_bdev (so that it is called only on 
> fsync or BLKFLSBUF) and not to blkdev_issue_flush.

Hmm, I actually thought about that earlier, but decided that
blkdev_issue_flush() was nicer. Looking at it again, I'm not sure why I
thought that.

I'll post a 2nd version soon.

Thanks,
Niels


> Mikulas
> 
>> Executing a BLKFLSBUF-ioctl on a partition flushes the caches for that
>> partition but reading data through the parent device will still return
>> the old cached data.
>>
>> The cache for the block-device is not synced if the block-device is kept
>> open (due to a mounted partition, for example). Only when all users for
>> the disk have exited, the cache for the disk is made consistent again.
>>
>> Calling invalidate_bdev() on the parent block-device in case
>> blkdev_issue_flush() was called for a partition fixes this.
>>
>> The problem can be worked around by forcing the caches to be flushed
>> with either
>>         # blockdev --flushbufs ${dev_disk}
>> or
>>         # echo 3 > /proc/sys/vm/drop_caches
>>
>> CC: Bryn M. Reeves <bmr <at> redhat.com>
>> Signed-off-by: Niels de Vos <ndevos <at> redhat.com>
>> ---
>>  block/blk-flush.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/blk-flush.c b/block/blk-flush.c
>> index 720ad60..e876f8e 100644
>> --- a/block/blk-flush.c
>> +++ b/block/blk-flush.c
>> @@ -448,6 +448,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_
>>
>>         if (!bio_flagged(bio, BIO_UPTODATE))
>>                 ret = -EIO;
>> +       else if (bdev != bdev->bd_contains)
>> +               /* invalidate parent block_device */
>> +               invalidate_bdev(bdev->bd_contains);
>>
>>         bio_put(bio);
>>         return ret;
>> --
>> 1.7.6.5
>>

-- 
Niels de Vos
Software Maintenance Engineer
Support Engineering Group
Red Hat UK, Ltd.
