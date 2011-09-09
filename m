Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab1III4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:56:41 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:46689 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab1III4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110901154936.26e35821@notabene.brown>
References: <20110831162211.2a1fe3fb@notabene.brown>
	<20110901033056.GA22050@localhost>
	<20110901154936.26e35821@notabene.brown>
Date: Fri, 9 Sep 2011 16:56:30 +0800
Message-ID: <CAF1ivSaTP27UnU3jf+ETDNV3j7FCekBRTZL8LvDSKj6UVcUJww@mail.gmail.com>
Subject: Re: md related oops triggered in bdev_inode_switch_bdi
From: Lin Ming <mlin@ss.pku.edu.cn>
To: NeilBrown <neilb@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 1:49 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 1 Sep 2011 11:30:56 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
>
>> Hi Neil,
>>
>> > Subject: [PATCH] Avoid dereferencing a 'request_queue' after last close.
>>
>> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
>
> Thanks.
>
>
>>
>> with comments below.
>>
>> > --- a/fs/block_dev.c
>> > +++ b/fs/block_dev.c
>> > @@ -1430,6 +1430,12 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>> >             sync_blockdev(bdev);
>> >             kill_bdev(bdev);
>> >     }
>> > +   if (!bdev->bd_openers)
>> > +           /* ->release can cause the old bdi to disappear,
>> > +            * so must switch it out first
>> > +            */
>> > +           bdev_inode_switch_bdi(bdev->bd_inode,
>> > +                                   &default_backing_dev_info);
>> >     if (bdev->bd_contains == bdev) {
>> >             if (disk->fops->release)
>> >                     ret = disk->fops->release(disk, mode);
>>
>> The bdev_inode_switch_bdi() call can be further moved into the
>> previous if block, like this:
>>
>>         if (!--bdev->bd_openers) {
>>                 WARN_ON_ONCE(bdev->bd_holders);
>>                 sync_blockdev(bdev);
>>                 kill_bdev(bdev);
>> +
>> +               /* ->release can cause the old bdi to disappear,
>> +                * so must switch it out first
>> +                */
>> +               bdev_inode_switch_bdi(bdev->bd_inode,
>> +                                       &default_backing_dev_info);
>>         }
>
> Yes, and obvious improvement now that you have pointed it out - thanks.
>
>
>>
>> Then it's obvious that kill_bdev() will truncate all inode pages
>> and there won't be further interactions with dirty writes.
>>
>> Although there are dozens of disk->fops->release functions, however
>> it's very unlikely they need to access some inode on top of the disk
>> (which is illogical thing).
>>
>> So I don't see any problems. It makes sense to push it to next for
>> broader test ASAP. Will you do it, or me?
>
> I've just push it into my for-next.  If I heard nothing else by mid next week
> I'll push it to Linus

Just FYI,
this patch also fixes below bug which can be reproduced by unplug the
usb disk before umount.

BUG blkdev_queue: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff880106640308-0xffff880106640309. First byte 0x6c instead of 0x6b
INFO: Allocated in blk_alloc_queue_node+0x1f/0x1a9 age=5794 cpu=0 pid=3449
        __slab_alloc+0x503/0x56e
        kmem_cache_alloc_node+0x61/0x18e
        blk_alloc_queue_node+0x1f/0x1a9
        blk_init_queue_node+0x24/0x61
        blk_init_queue+0xc/0xe
        __scsi_alloc_queue+0x21/0x145
        scsi_alloc_queue+0x18/0x64
        scsi_alloc_sdev+0x1bb/0x282
        scsi_probe_and_add_lun+0x13b/0xb6a
        __scsi_scan_target+0xc5/0x60c
        scsi_scan_channel+0x58/0x80
        scsi_scan_host_selected+0xed/0x136
        do_scsi_scan_host+0x6b/0x70
        scsi_scan_host+0x1a0/0x1c5
        usb_stor_scan_thread+0x16d/0x17b
        kthread+0x7d/0x85
INFO: Freed in blk_release_queue+0x60/0x65 age=2267 cpu=1 pid=3484
        __slab_free+0x2c/0x30d
        kmem_cache_free+0xbc/0x127
        blk_release_queue+0x60/0x65
        kobject_release+0x51/0x67
        kref_put+0x43/0x4d
        kobject_put+0x47/0x4b
        blk_put_queue+0x10/0x12
        scsi_device_dev_release_usercontext+0xbf/0x10a
        execute_in_process_context+0x2a/0x61
        scsi_device_dev_release+0x17/0x19
        device_release+0x49/0x7e
        kobject_release+0x51/0x67
        kref_put+0x43/0x4d
        kobject_put+0x47/0x4b
        put_device+0x12/0x14
        scsi_device_put+0x3d/0x42

Thanks,
Lin Ming
