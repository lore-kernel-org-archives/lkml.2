Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2K0HIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:08:04 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42253 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2K0HIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:08:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121127120528.637099aa@notabene.brown>
References: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
	<20121127120528.637099aa@notabene.brown>
Date: Tue, 27 Nov 2012 08:08:00 +0100
Message-ID: <CAPVoSvRssJSzjg1wZ8g9-05Y50xVkVcQqsnZ92Ru6mWZgGrfKg@mail.gmail.com>
Subject: Re: Hang in md-raid1 with 3.7-rcX
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 2:05 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 24 Nov 2012 10:18:44 +0100 Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
>
>> After my system got stuck with 3.7.0-rc2 as reported in
>> http://marc.info/?l=linux-kernel&m=135142236520624 LOCKDEP seem to
>> blame XFS, because it found 2 possible deadlocks. But after these
>> locking issues where fixed, my system got stuck again with 3.7.0-rc6
>> as reported in http://marc.info/?l=linux-kernel&m=135344072325490
>> Dave Chinner thinks its an issue within md, that it gets stuck and
>> that will then prevent any further xfs activity, and that I should
>> report it to the raid mailing list.
>>
>> The issue seems to be that multiple processes (kswapd0, xfsaild/md4
>> and flush-9:4) get stuck in md_super_wait() like this:
>> [<ffffffff816b1224>] schedule+0x24/0x60
>> [<ffffffff814f9dad>] md_super_wait+0x4d/0x80
>> [<ffffffff8105ca30>] ? __init_waitqueue_head+0x60/0x60
>> [<ffffffff81500753>] bitmap_unplug+0x173/0x180
>> [<ffffffff810b6acf>] ? write_cache_pages+0x12f/0x420
>> [<ffffffff810b6700>] ? set_page_dirty_lock+0x60/0x60
>> [<ffffffff814e8eb8>] raid1_unplug+0x98/0x110
>> [<ffffffff81278a6d>] blk_flush_plug_list+0xad/0x240
>> [<ffffffff81278c13>] blk_finish_plug+0x13/0x50
>>
>> The full hung-tasks stack traces and the output from SysRq+W can be
>> found at http://marc.info/?l=linux-kernel&m=135344072325490 or in the
>> LKML thread 'Hang in XFS reclaim on 3.7.0-rc3'.
>
> Yes, it does look like an md bug....
> Can you test to see if this fixes it?

Patch applied, I will try to get it stuck again.
I don't have a reliable reproducers, but if the problem persists I
will definitly report back here.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 636bae0..a0f7309 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>         struct r1conf *conf = mddev->private;
>         struct bio *bio;
>
> -       if (from_schedule) {
> +       if (from_schedule || current->bio_list) {
>                 spin_lock_irq(&conf->device_lock);
>                 bio_list_merge(&conf->pending_bio_list, &plug->pending);
>                 conf->pending_count += plug->pending_cnt;
>
>>
>> I tried to understand how this could happen, but I don't see anything
>> wrong. Only that md_super_wait() looks like an open coded version of
>> __wait_event() and could be replaced by using it.
>
> yeah.  md_super_wait was much more complex back when we had to support
> barrier operations.  When they were removed it was simplified a lot and as
> you say it could be simplifier further.  Patches welcome.

I guessed it predated that particular helper.

If you ask for a patch, I have one question:
md_super_wait() looks like __wait_event(), but there also is a
wait_event() helper.
Would it be better to switch to wait_event()? It would add an
additional check for atomic_read(&mddev->pending_writes)==0 before
"allocating" and initialising the wait_queue_t, which I think would be
a correct optimization.

>> http://marc.info/?l=linux-raid&m=135283030027665 looks like the same
>> issue, but using ext4 instead of xfs.
>
> yes, sure does.
>
>>
>> My setup wrt. md is two normal sata disks on a normal ahci controller
>> (AMD SB850 southbridge).
>> Both disks are divided into 4 partitions and each one assembled into a
>> separate raid1.
>> One (md5) is used for swap, the others hold xfs filesystems for /boot/
>> (md4), / (md6) and /home/ (md7).
>>
>> I will try to provide any information you ask, but I can't reproduce
>> the hang on demand so gathering more information about that state is
>> not so easy, but I will try.
>
> I'm fairly confident the above patch will fixes it, and in any case it fixes
> a real bug.  So if you could just run with it and confirm in a week or so
> that the problem hasn't recurred, that might have to do.

I only had 2 or 3 hangs since 3.7-rc1, but suspect forcing the system
to swap (which lies on an raid1) plays a part of it.
As the system as 12GB of RAM it normally doesn't need to swap and I
see no problem. I will try theses workloads again and hope if the
problem persists I can trigger it again in the next few days...

Thanks for the patch,

Torsten

> Thanks,
> NeilBrown
>
