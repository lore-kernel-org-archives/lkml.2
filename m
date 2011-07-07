Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1GGOlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:41:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab1GGOlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:41:37 -0400
Date: Thu, 7 Jul 2011 16:41:23 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Kyungmin Park <kmpark@infradead.org>
cc: Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
Subject: Re: ext4: why init the unused block group at batched discard?
In-Reply-To: <CAH9JG2WXQc5oxOD+B4xm5NbuvhJLc=mpyoTkXNup5spLSh4sMQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1107071637420.3911@dhcp-27-109.brq.redhat.com>
References: <CAH9JG2Xp_u-46x8bf2Uq-9FREZyYhcP3E7H+MsSoFVrWpyLrtA@mail.gmail.com> <alpine.LFD.2.00.1107071106100.3911@dhcp-27-109.brq.redhat.com> <CAH9JG2WXQc5oxOD+B4xm5NbuvhJLc=mpyoTkXNup5spLSh4sMQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1292085973-1310049686=:3911"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1292085973-1310049686=:3911
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 7 Jul 2011, Kyungmin Park wrote:

> On Thu, Jul 7, 2011 at 6:24 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Wed, 6 Jul 2011, Kyungmin Park wrote:
> >
> >> Hi Lukas,
> >>
> >> During code review batched discard support at ext4. I wonder why do
> >> you init the uninitialized block group during batched discard.
> >> As you know uninitialized block group mean that there's no operation
> >> at these blocks.
> >> So no need to trim it at all.
> >
> > What you're describing is another flag, namely EXT4_BG_BLOCK_UNINIT,
> > which tells us that there was no allocation from that block bitmap since
> > the mkfs (as Amir already pointed out). Flag
> > EXT4_GROUP_INFO_NEED_INIT_BIT simply states that there is no buddy
> > initialized for this group.
> >
> > That said the code is perfectly fine, and it should not affect even the
> > e2fsck which uses EXT4_BG_BLOCK_UNINIT to skip not used block groups
> > since we only change it on allocations.
> >
> > It is true that after the commit
> > 78944086663e6c1b03f3d60bf7610128149be5fc ext4: only load buddy bitmap in
> > ext4_trim_fs() when it is needed
> > we do not longer need to initialize the buddy right away, but wait ontil
> > it is really needed. Actually we do not need it at all, because is when
> > we are going to load the buddy the ext4_mb_load_buddy() will check for
> > the EXT4_GROUP_INFO_NEED_INIT_BIT and will initialize the buddy for us.
> >
> > Yongqiang pointed out that we might use EXT4_BG_BLOCK_UNINIT to skip
> > group as well, but I do not think that it is a good idea, since the
> > initial discard at mkfs time might not be done (we just do not know it),
> > so any assumption like this are not right. Moreover there are patches
> > from Tao Ma which adds the code for skipping groups which has not been
> > freed from since the last fitrim call. Search the list for [PATCH 0/4
> > RESEND]  ext4 trim bug fixes and improvement.
> 
> Thank you for all kind explanations.
> 
> Another consideration is that even though batched discard has little
> overhead it's not good idea trim it all unused blocks at one time.
> since disk used blocks doesn't increased in normal case.
> So how about to remember the last allocated block group and trim it
> until this block group?

Yes, this problem is addressed by patches from Tao as mentioned above,
however it is still waiting for merge.

> 
> To reduce the trim time. I also consider the divide the block groups
> as several trim area e.g., 1 GiB and trim it sequentially.

I am not sure what do you mean. In ext4 allocation groups has a lot
smaller sizes (128M for 4k block size) than 1G. Also you can specify
that you do want to discard just a part of the filesystem, but you
probably did notice that in review, right ?

Thanks!
-Lukas

> 
> These are based on the assumption, eMMC has small resource relatively
> SSD and no need to trim it at one time.
> 
> Thank you,
> Kyungmin Park
> 
--8323328-1292085973-1310049686=:3911--
