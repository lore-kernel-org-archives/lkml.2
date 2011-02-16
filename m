Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1BPLDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:03:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40487 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1BPLDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DcDxEXwe45nrSadWBOIjEna0hbdXICG8C4w9IgDqHFzyrsN/AotS8cgE42WRmwvFx0
         FhSO7AtKuncro8nhHN5Bf/Ull3nWEEQ8LeBL3oZSXFCXE8ibKjfkOGEIKOCzS5HCRrxn
         VP9tZ6g/GlC0+KSwfV+eyia1gzdtFejbTlLhM=
MIME-Version: 1.0
In-Reply-To: <20110216174031.183180c4@feng-i7>
References: <AANLkTinES_gU=MxbSnidorsKDsMnAwzHVx+yntOLCf=f@mail.gmail.com>
	<AANLkTikvpyTPVnP1cxC4rSLARO3thpscyhmB4=BpFW-G@mail.gmail.com>
	<20110215144641.05318556@feng-i7>
	<20110215111126.GD17313@quack.suse.cz>
	<AANLkTikGdud4FX0TcC-Sf_-_V-i8doZ73m63B=JA4kWp@mail.gmail.com>
	<20110216174031.183180c4@feng-i7>
Date: Wed, 16 Feb 2011 19:03:31 +0800
Message-ID: <AANLkTi=DGtS2MeM98h=qK+A6sqcZdg6cRCpdjqkf5aLn@mail.gmail.com>
Subject: Re: ext2 write performance regression from 2.6.32
From: Kyle liu <op.q.liu@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org, axboe@kernel.dk
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

I test your patch. The performance of sdhc is as you expected.

One thing should be corrected, my sdhc performance drops from 12MB/s
to 3MB/s, not 18MB/s. My fault.

I found 2 problems when I tested with your patch.
1. format command will be hung up around  25s when I format a hard disk.
    this because you will delay 30s first, then write raw device.
[root@p2020ds root]# mkfs.ext2 /dev/sda1
......
32/1193
....... wait around 25s here
then continue write raw device until format complete.
1193/1193

2. Occasionally, the system will be hung up when I format disk. I
didn't investigate further.

For your patch. This condition (wbc->sync_mode != WB_SYNC_ALL) is no
use. wbc->sync_mode can't be used to distinguish format data and file
data.

Thanks.


在 2011年2月16日 下午5:40，Feng Tang <feng.tang@intel.com> 写道：
>
>> From: Jan Kara <jack@suse.cz>
>> Date: 2011/2/15
>> Subject: Re: ext2 write performance regression from 2.6.32
>> To: Feng Tang <feng.tang@intel.com>
>> 抄送： op.q.liu@gmail.com, linux-kernel@vger.kernel.org, "Wu,
>> Fengguang" <fengguang.wu@intel.com>, Andrew Morton
>> <akpm@linux-foundation.org>, axboe@kernel.dk, jack@suse.cz
>>
>>
>>  Hello,
>>
>> On Tue 15-02-11 14:46:41, Feng Tang wrote:
>> > After some debugging, here is one possible root cause for the dd
>> > performance drop between 2.6.30 and 2.6.32 (33/34/35 as well):
>> > in .30 the dd is a pure sequential operation while in .32 it isn't,
>> > and the change is related to the introduction of per-pdi flush.
>> >
>> > I used a laptop with SDHC controller and run a simple dd of a
>> > double RAM size _file_ to a 1G SDHC card, the drop from .32 to .30
>> > is about 30%, from roughly 10MB/s to 7MB/s
>> >
>> > I'm not very familiar with .30/.32 code, and here is a simple
>> > analysis:
>> >
>> > When dd to a big ext2 file, there are 2 types of metadata will be
>> > updated besides the file data:
>> > 1. The ext2 global info like group descriptors and block bitmaps,
>> > whose buffer_header will be marked dirty in ext2_new_blocks()
>> > 2. The inode of the file under written, marked dirty in
>> > ext2_write/update_inode(), which is called by write_inode() and in
>> > writeback path.
>> >
>> > In 2.6.30, with old pdflush interface, during the dd, the writeback
>> > of the 2 types of metadata will be triggered from wb_timer_fn() and
>> > dirty_balance_pages(), but they are always delayed in
>> > pdflush_operations() as the pdflush_list is empty. So that only the
>> > file data got be written back in a very smooth sequential mode.
>> >
>> > In 2.6.32, the writeback is per-bdi operation, every time the bdi
>> > for the sd card is called for flush, it will check and try to write
>> > back all the dirty pages, including both the metadata and data
>> > pages, so the previously sequential sd block access is periodically
>> > chimed in by the metadata block, which cause the performance drop.
>> > And if I ugly delayed the metadata writeback, the performance will
>> > be restored same as .30.
>>  Umm, interesting. 7 vs 10 MB/s is rather big difference. For
>> non-rotating media like is your SD card, I'd expect much less impact
>> of IO randomness, especially if we write in those 4 MB chunks. But we
>> are probably hit by the erase block size being big and thus FTL has
>> to do a lot of work.
>>
>> What might happen is that flusher thread competes with the process
>> doing writeback from balance_dirty_pages(). There are basically two
>> dirty inodes in the bdi in your test case - the file you write and
>> the device inode. So while one task flushes the file data pages, the
>> other task has no other choice but flush the device inode. But I'd
>> expect this to happen with pdflush as well. Can you send me raw block
>> traces from both kernels so that I can have a look? Thanks.
>>
>>                                                                Honza
>
>
> Hi,
>
> I made out a debug patch which try to delay the pure FS metadata writeback
> (maxim 30 seconds to match current writeback expire time). It works for me
> on 2.6.32, and the dd performance is restored.
>
> Please help to review it, thanks!
>
> btw, I've sent out the block dump info requested by Jan Kara, but didn't see
> it on LKML, so attached them again.
>
> - Feng
>
> From c35548c7d0c3a334d24c26adab277ef62b9825db Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Wed, 16 Feb 2011 17:27:36 +0800
> Subject: [PATCH] writeback: delay the file system metadata writeback in 30 seconds
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  fs/fs-writeback.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 9d5360c..418fd9e 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -635,6 +635,16 @@ static void writeback_inodes_wb(struct bdi_writeback *wb,
>                        continue;
>                }
>
> +               if ((wbc->sync_mode != WB_SYNC_ALL)
> +                       && !inode->i_ino
> +                       && !strcmp(inode->i_sb->s_id, "bdev")) {
> +                       if (inode->dirtied_when + 30 * HZ >  jiffies) {
> +                               list_move(&inode->i_list, &wb->b_dirty);
> +                               continue;
> +                       }
> +               }
> +
> +
>                if (!bdi_cap_writeback_dirty(wb->bdi)) {
>                        redirty_tail(inode);
>                        if (is_blkdev_sb) {
> --
> 1.7.0.4
>
>
>
>>
>> > > ---------- Forwarded message ----------
>> > > From: Kyle liu <op.q.liu@gmail.com>
>> > > Date: 2011/1/28
>> > > Subject: ext2 write performance regression from 2.6.32
>> > > To: linux-kernel@vger.kernel.org
>> > >
>> > >
>> > > Hello,
>> > >
>> > > Since upgrading 2.6.30->2.6.32, ext2 write performance of
>> > > SATA/SD/USB card is very low (except SSD). The issue is also
>> > > exist after 2.6.32, e.g. 2.6.34, 2.6.35. Write performance of
>> > > SATA decreased from 115MB/s to 80MB/s. Write performance of SDHC
>> > > decreased from 12MB/s to 3MB/s.
>> > >
>> > > My test tool is iozone  and dd, test file size is 2*RAM size. CPU
>> > > is PowerPC core e500, SATA disk is WD 10000RPM drives, SDHC is
>> > > Sandisk class 10 card.
>> > >
>> > > What decrease the performance? Because the sequence of block of
>> > > writing is not continuous.
>> > > Here are some debug info below (in function  mmc_blk_issue_rq).
>> > > major means major device number of the device, pos means the
>> > > position of writing, blocks means the block number need writing.
>> > >
>> > > iozone -Rab result -i0 -r64 -n512m -g512m -f /mnt/ff
>> > > dd if=/dev/zero of=/mnt/ff bs=16K count=32768
>> > > ..............
>> > > major=179, pos=270360, blocks=8
>> > > major=179, pos=278736, blocks=8
>> > > major=179, pos=24, blocks=8
>> > > major=179, pos=8216, blocks=24
>> > > major=0, pos=16424, blocks=8
>> > > major=0, pos=196624, blocks=104
>> > > major=179, pos=204920, blocks=16
>> > > major=0, pos=204936, blocks=128
>> > > ..............
>> > > major=179, pos=1048592, blocks=8
>> > > major=179, pos=1074256, blocks=8
>> > > major=179, pos=1090656, blocks=8
>> > > major=179, pos=16, blocks=8
>> > > major=0, pos=884704, blocks=128
>> > > major=0, pos=884832, blocks=128
>> > > major=0, pos=884960, blocks=128
>> > > major=0, pos=885088, blocks=32
>> > > major=179, pos=1082456, blocks=8
>> > > major=179, pos=1098856, blocks=8
>> > > major=179, pos=24, blocks=8
>> > > major=179, pos=8232, blocks=8
>> > > major=179, pos=204920, blocks=8
>> > > major=0, pos=885120, blocks=128
>> > > .............
>> > >
>> > > Some write are from write_boundary_block, these are necessary. But
>> > > others that major is not zero is from
>> > > def_blk_aops->blkdev_writepage. Before 2.6.32, there is no case
>> > > happened like this. And why, I have already mount filesystem.
>> > > What are the usage of these data?
>> > >
>> > > Temporarily, I mask all these write operations in do_writepage()
>> > > below, /* no need to write device if the operation is not used to
>> > > format device */ if (imajor(mapping->host) && (wbc->sync_mode ==
>> > > WB_SYNC_NONE)) return 0;
>> > >
>> > > test record below (same behavior to 2.6.30):
>> > > ............
>> > > major=0, pos=23488, blocks=128
>> > > major=0, pos=23616, blocks=128
>> > > major=0, pos=23744, blocks=128
>> > > major=0, pos=23872, blocks=128
>> > > major=0, pos=24000, blocks=128
>> > > major=0, pos=24128, blocks=128
>> > > major=0, pos=24256, blocks=128
>> > > major=0, pos=24384, blocks=128
>> > > major=0, pos=24512, blocks=128
>> > > major=0, pos=24640, blocks=128
>> > > major=179, pos=24768, blocks=8--from write_boundary_block()
>> > > major=0, pos=24784, blocks=128
>> > > major=0, pos=24912, blocks=128
>> > > major=0, pos=25040, blocks=128
>> > > major=0, pos=29136, blocks=128
>> > > major=0, pos=29264, blocks=128
>> > > major=0, pos=29392, blocks=128
>> > > major=0, pos=29520, blocks=128
>> > > ..............
>> > >
>> > > Until now it works fine (except format disk). Data integrity is
>> > > fine. Who can tell me what is the usage of the redundant data.
>> > > I'm not familiar with filesystem.
>> > >
>> > > Thanks.
>> > >
>> > > Best Regards
>> > > Eiji
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe
>> > > linux-kernel" in the body of a message to
>> > > majordomo@vger.kernel.org More majordomo info at
>> > > http://vger.kernel.org/majordomo-info.html Please read the FAQ
>> > > at  http://www.tux.org/lkml/
>> --
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
