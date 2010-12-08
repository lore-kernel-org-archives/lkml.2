Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0LHMff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:35:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab0LHMfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:35:34 -0500
Message-ID: <4CFF7B5C.5070703@redhat.com>
Date: Wed, 08 Dec 2010 13:34:36 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Anton Blanchard <anton@samba.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Staging: zram: work around oops due to startup ordering snafu
References: <1287174680.10966.6686.camel@nimitz>
In-Reply-To: <1287174680.10966.6686.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 10:31 PM, Dave Hansen wrote:
> After I pulled Linus's latest git, I can no longer initialize my zram
> devices.  Looks like it is caused by this commit:
> 
> commit 7e24cce38a99f373450db67bf576fe73e8168d66
> Author: Anton Blanchard <anton@samba.org>
> Date:   Fri Oct 1 14:19:55 2010 -0700
> 
>>     I'm getting an oops when running mkfs on zram:
>>     
>>     NIP [d0000000030e0340] .zram_inc_stat+0x58/0x84 [zram]
>>     [c00000006d58f720] [d0000000030e091c] .zram_make_request+0xa8/0x6a0 [zram]
>>     [c00000006d58f840] [c00000000035795c] .generic_make_request+0x390/0x434
>>     [c00000006d58f950] [c000000000357b14] .submit_bio+0x114/0x140
>>     [c00000006d58fa20] [c000000000361778] .blkdev_issue_discard+0x1ac/0x250
>>     [c00000006d58fb10] [c000000000361f68] .blkdev_ioctl+0x358/0x7fc
>>     [c00000006d58fbd0] [c0000000001c1c1c] .block_ioctl+0x6c/0x90
>>     [c00000006d58fc70] [c0000000001984c4] .do_vfs_ioctl+0x660/0x6d4
>>     [c00000006d58fd70] [c0000000001985a0] .SyS_ioctl+0x68/0xb0
>>     
>>     Since disksize no longer starts as 0 it looks like we can call
>>     zram_make_request before the device has been initialised. The patch below
>>     fixes the immediate problem but this would go away if we move the
>>     initialisation function elsewhere (as suggested in another thread).
>>     
>>     Signed-off-by: Anton Blanchard <anton@samba.org>
>>     Cc: Nitin Gupta <ngupta@vflare.org>
>>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index c5f84ee..72f1b9c 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -435,6 +435,12 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
>>         int ret = 0;
>>         struct zram *zram = queue->queuedata;
>>  
>> +       if (unlikely(!zram->init_done)) {
>> +               set_bit(BIO_UPTODATE, &bio->bi_flags);
>> +               bio_endio(bio, 0);
>> +               return 0;
>> +       }
>> +
> 
> The issue appears because:
> 
> 1. zram_init_device() is the only code to set zram->init_done=1
> 2. zram_write() is the only caller of zram_init_device()
> 3. zram_make_request() checks for zram->init_done==0 and will never
>    call zram_write() if zram->init_done==0
> 
> I'm not sure how this code ever worked.  Maybe if you pass the disk size
> as a module parameter.  I suspect that Anton's patch was against a
> different version anyway.

Yes. This patch was meant to fix a bug regarding percpu stats, which are
not allocated before the device is initialized. There is no such problem
in upstream code which does not use percpu counter.

That patch should be reverted.

Regards,
Jerome

> 
> I have the feeling that we just need to do something like the attached
> patch (which is just for commenting at this point).  Instead of needing
> multiple file writes, if someone writes to one of the config variables,
> we just reset the disk then and there.
> 
> Another option might be to move the configuration to configfs.  Don't
> allow zram devices to be modified once they are created.  If you want to
> change one, you remove the existing device and create a new one.  That
> would remove any confusion about initialization.  If there's a device
> there, it's initialized, period.
> 
> -- Dave

