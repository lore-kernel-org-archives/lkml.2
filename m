Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0IVJuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:50:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39439 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0IVJui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:50:38 -0400
To: Neil Brown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk
In-reply-to: <20100921113101.3bde59bd@notabene> (message from Neil Brown on
	Tue, 21 Sep 2010 11:31:01 +1000)
Subject: Re: [PATCH 0/7 v3] overlay filesystem prototype
References: <20100920180404.939991832@szeredi.hu> <20100921113101.3bde59bd@notabene>
Message-Id: <E1OyLyA-00033R-D0@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Sep 2010 11:50:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Neil Brown wrote:
> On Mon, 20 Sep 2010 20:04:04 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Here's an updated patch series.
> > 
> > For now I reverted Neil's revalidation patch.  Not requiring strict
> > read-only would make sense for just trying it out and experimenting.
> > But for real uses, I'm not sure...
> 
> :-)
> 
> I think you significantly reduce the value by insisting on read-only but as
> this is purely a theoretical perspective at the moment (I have no concrete
> use-case) I won't push it.

I'm not insisting on read-only.  I think there's value to enabling
external modification in special circumstances, but not by default.

I also think it might not be a good idea to waste CPU cycles and brain
cycles on implementing (an always imperfect) revalidation.  A similar
mechanism is "mount -oremount mountpoint", which simply throws out all
unused dentries, effectively forcing a revalidation of the whole
filesystem.  Less selective than ->d_revalidate(), but it shouldn't be
a big issue since the underlying filesystem dentries remain cached.

> I had another patch I was working on which caused overlayfs to keep negative
> dentries in upperdentry or lowerdentry rather than just setting them to
> NULL.  This would allow revalidation to notice objects appearing in the
> underlying filesystem.  I guess you won't want that now .... I think it made
> some of the code a bit neater, but I never finished it so I cannot be sure of
> the overall effect.
> 
> I'm curious as to why upperdentry is now called __upperdentry - it isn't
> clear from a quick reading..

(I need to add more comments to the code...)

The underscores are meant to imply that unlinke ->lowerdentry it's not
qute safe to access directly.  See discussion about memory barriers:

  http://lkml.org/lkml/2010/9/19/142

It's not as clear as one might like.  To sum up:

  - an smp_read_barrier_depends() is needed on SMP Alpha, but not on
    other archs

  - an ACCESS_ONCE() is needed on some theoretical compiler that does
    weird optimizations, but apparently not on current versions of gcc

The VFS lives happily without either, locklessly accessing
dentry->d_inode.

Thanks,
Miklos
