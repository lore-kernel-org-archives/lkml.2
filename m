Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1GGNjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:39:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41408 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1GGNjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1107071106100.3911@dhcp-27-109.brq.redhat.com>
References: <CAH9JG2Xp_u-46x8bf2Uq-9FREZyYhcP3E7H+MsSoFVrWpyLrtA@mail.gmail.com>
	<alpine.LFD.2.00.1107071106100.3911@dhcp-27-109.brq.redhat.com>
Date: Thu, 7 Jul 2011 22:39:43 +0900
X-Google-Sender-Auth: Bgy5Ub4vQrdEsLbWtYmKuPH88AQ
Message-ID: <CAH9JG2WXQc5oxOD+B4xm5NbuvhJLc=mpyoTkXNup5spLSh4sMQ@mail.gmail.com>
Subject: Re: ext4: why init the unused block group at batched discard?
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 6:24 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Wed, 6 Jul 2011, Kyungmin Park wrote:
>
>> Hi Lukas,
>>
>> During code review batched discard support at ext4. I wonder why do
>> you init the uninitialized block group during batched discard.
>> As you know uninitialized block group mean that there's no operation
>> at these blocks.
>> So no need to trim it at all.
>
> What you're describing is another flag, namely EXT4_BG_BLOCK_UNINIT,
> which tells us that there was no allocation from that block bitmap since
> the mkfs (as Amir already pointed out). Flag
> EXT4_GROUP_INFO_NEED_INIT_BIT simply states that there is no buddy
> initialized for this group.
>
> That said the code is perfectly fine, and it should not affect even the
> e2fsck which uses EXT4_BG_BLOCK_UNINIT to skip not used block groups
> since we only change it on allocations.
>
> It is true that after the commit
> 78944086663e6c1b03f3d60bf7610128149be5fc ext4: only load buddy bitmap in
> ext4_trim_fs() when it is needed
> we do not longer need to initialize the buddy right away, but wait ontil
> it is really needed. Actually we do not need it at all, because is when
> we are going to load the buddy the ext4_mb_load_buddy() will check for
> the EXT4_GROUP_INFO_NEED_INIT_BIT and will initialize the buddy for us.
>
> Yongqiang pointed out that we might use EXT4_BG_BLOCK_UNINIT to skip
> group as well, but I do not think that it is a good idea, since the
> initial discard at mkfs time might not be done (we just do not know it),
> so any assumption like this are not right. Moreover there are patches
> from Tao Ma which adds the code for skipping groups which has not been
> freed from since the last fitrim call. Search the list for [PATCH 0/4
> RESEND]  ext4 trim bug fixes and improvement.

Thank you for all kind explanations.

Another consideration is that even though batched discard has little
overhead it's not good idea trim it all unused blocks at one time.
since disk used blocks doesn't increased in normal case.
So how about to remember the last allocated block group and trim it
until this block group?

To reduce the trim time. I also consider the divide the block groups
as several trim area e.g., 1 GiB and trim it sequentially.

These are based on the assumption, eMMC has small resource relatively
SSD and no need to trim it at one time.

Thank you,
Kyungmin Park


>
> Thanks for pointing that out. I'll send the patch.
>
> -Lukas
>
>>
>> How do you think?
>>
>> int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>> {
>>         ...
>>
>>         for (group = first_group; group <= last_group; group++) {
>>                 grp = ext4_get_group_info(sb, group);
>>                 /* We only do this if the grp has never been initialized */
>>                 if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>>                         ret = ext4_mb_init_group(sb, group);
>>                         if (ret)
>>                                 break;
>>                 }
>>         ...
>>         }
>>         ...
>> }
>>
>> Thank you,
>> Kyungmin Park
>>
>
