Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0KOEVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:21:11 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:49063 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859Ab0KOEVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:21:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMxD4Ex5LdSF/2dsb2JhbACiT3K7GYVKBJBS
Date: Mon, 15 Nov 2010 15:21:00 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101115042059.GB3320@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101115010027.GC22876@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 12:00:27PM +1100, Dave Chinner wrote:
> On Fri, Nov 12, 2010 at 12:24:21PM +1100, Nick Piggin wrote:
> > On Wed, Nov 10, 2010 at 9:05 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> > > On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
> > >> On Tue, Nov 9, 2010 at 8:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >> >
> > >> > You can see problems using this fancy thing :
> > >> >
> > >> > - Need to use slab ctor() to not overwrite some sensitive fields of
> > >> > reused inodes.
> > >> >  (spinlock, next pointer)
> > >>
> > >> Yes, the downside of using SLAB_DESTROY_BY_RCU is that you really
> > >> cannot initialize some fields in the allocation path, because they may
> > >> end up being still used while allocating a new (well, re-used) entry.
> > >>
> > >> However, I think that in the long run we pretty much _have_ to do that
> > >> anyway, because the "free each inode separately with RCU" is a real
> > >> overhead (Nick reports 10-20% cost). So it just makes my skin crawl to
> > >> go that way.
> > >
> > > This is a creat/unlink loop on a tmpfs filesystem. Any real filesystem
> > > is going to be *much* heavier in creat/unlink (so that 10-20% cost would
> > > look more like a few %), and any real workload is going to have much
> > > less intensive pattern.
> > 
> > So to get some more precise numbers, on a new kernel, and on a nehalem
> > class CPU, creat/unlink busy loop on ramfs (worst possible case for inode
> > RCU), then inode RCU costs 12% more time.
> > 
> > If we go to ext4 over ramdisk, it's 4.2% slower. Btrfs is 4.3% slower, XFS
> > is about 4.9% slower.
> 
> That is actually significant because in the current XFS performance
> using delayed logging for pure metadata operations is not that far
> off ramdisk results.  Indeed, the simple test:
> 
>         while (i++ < 1000 * 1000) {
>                 int fd = open("foo", O_CREAT|O_RDWR, 777);
>                 unlink("foo");
>                 close(fd);
>         }
> 
> Running 8 instances of the above on XFS, each in their own
> directory, on a single sata drive with delayed logging enabled with
> my current working XFS tree (includes SLAB_DESTROY_BY_RCU inode
> cache and XFS inode cache, and numerous other XFS scalability
> enhancements) currently runs at ~250k files/s. It took ~33s for 8 of
> those loops above to complete in parallel, and was 100% CPU bound...

David,

This is 30K inodes per second per CPU, versus nearly 800K per second
number that I measured the 12% slowdown with. About 25x slower. How you
are trying to FUD this as doing anything but confirming my hypothesis, I
don't know and honestly I don't want to know so don't try to tell me.

That you are still at this campaign of negative and destructive crap
baffles me. All the effort you've put into negativity and obstruction,
you could have gone and got some *actual* numbers. But no, you're
obviously more interested in FUD.

I don't know what is funnier, that I keep responding to you, or that you
keep expecting me to reply when you ignore all _my_ comments about your
patches and ignore all the reasons I have given to want to merge things
my way (eg. my response to SLAB_DESTROY_BY_RCU patch where you ignored
all my feedback, and you ignore this entire thread about how and why I
want to approach rcu-walk in the way I do).

But that's it. I have explained my position, offered reasonable answers
to all questions and objections, shown good numbers, and given
strategies that regressions can be solved with. That's all I need to do.

I acknowledge the very small potential for regressions with inode-RCU
for a very small number of users. I also weigh that against complexity
and reviewability, and against the very large speedups for very many
users that rcu-walk can give. And also offered approaches for ways that
future work can resolve any regressions. You ignored all that.

You show me no respect or cortesy and seem to take me as a big joke. So
at this point I'm not interested in your handwaving or opinions. Is that
clear? Until you 1) treat me the way you expect to be treated, and 2)
actaully have something constructive, do do not cc me. I do not care.

