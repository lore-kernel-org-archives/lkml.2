Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab0KPDDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:03:00 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:37672 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754636Ab0KPDC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:02:59 -0500
Date: Tue, 16 Nov 2010 14:02:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101116030242.GI22876@dastard>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
 <20101115042059.GB3320@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101115042059.GB3320@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 03:21:00PM +1100, Nick Piggin wrote:
> On Mon, Nov 15, 2010 at 12:00:27PM +1100, Dave Chinner wrote:
> > On Fri, Nov 12, 2010 at 12:24:21PM +1100, Nick Piggin wrote:
> > > On Wed, Nov 10, 2010 at 9:05 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> > > > On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
> > > >> On Tue, Nov 9, 2010 at 8:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >> >
> > > >> > You can see problems using this fancy thing :
> > > >> >
> > > >> > - Need to use slab ctor() to not overwrite some sensitive fields of
> > > >> > reused inodes.
> > > >> >  (spinlock, next pointer)
> > > >>
> > > >> Yes, the downside of using SLAB_DESTROY_BY_RCU is that you really
> > > >> cannot initialize some fields in the allocation path, because they may
> > > >> end up being still used while allocating a new (well, re-used) entry.
> > > >>
> > > >> However, I think that in the long run we pretty much _have_ to do that
> > > >> anyway, because the "free each inode separately with RCU" is a real
> > > >> overhead (Nick reports 10-20% cost). So it just makes my skin crawl to
> > > >> go that way.
> > > >
> > > > This is a creat/unlink loop on a tmpfs filesystem. Any real filesystem
> > > > is going to be *much* heavier in creat/unlink (so that 10-20% cost would
> > > > look more like a few %), and any real workload is going to have much
> > > > less intensive pattern.
> > > 
> > > So to get some more precise numbers, on a new kernel, and on a nehalem
> > > class CPU, creat/unlink busy loop on ramfs (worst possible case for inode
> > > RCU), then inode RCU costs 12% more time.
> > > 
> > > If we go to ext4 over ramdisk, it's 4.2% slower. Btrfs is 4.3% slower, XFS
> > > is about 4.9% slower.
> > 
> > That is actually significant because in the current XFS performance
> > using delayed logging for pure metadata operations is not that far
> > off ramdisk results.  Indeed, the simple test:
> > 
> >         while (i++ < 1000 * 1000) {
> >                 int fd = open("foo", O_CREAT|O_RDWR, 777);
> >                 unlink("foo");
> >                 close(fd);
> >         }
> > 
> > Running 8 instances of the above on XFS, each in their own
> > directory, on a single sata drive with delayed logging enabled with
> > my current working XFS tree (includes SLAB_DESTROY_BY_RCU inode
> > cache and XFS inode cache, and numerous other XFS scalability
> > enhancements) currently runs at ~250k files/s. It took ~33s for 8 of
> > those loops above to complete in parallel, and was 100% CPU bound...
> 
> David,
> 
> This is 30K inodes per second per CPU, versus nearly 800K per second
> number that I measured the 12% slowdown with. About 25x slower.

Hi Nick, the ramfs (800k/12%) numbers are not the context I was
responding to - you're comparing apples to oranges. I was responding to
the "XFS [on a ramdisk] is about 4.9% slower" result.

> How you
> are trying to FUD this as doing anything but confirming my hypothesis, I
> don't know and honestly I don't want to know so don't try to tell me.

Hardly FUD. I thought it important to point out that your
filesystem-on-ramdisk numbers are not theoretical at all - we can
acheive the same level of performance on a single SATA drive for
this workload on XFS. Therefore, the 5% difference in performance
you've measured on a ramdisk will definitely be visible in the real
world and we need to consider it in that context, not as a
"theoretical concern".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
