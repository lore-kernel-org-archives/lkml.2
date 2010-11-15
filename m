Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab0KOBAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:00:34 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:35907 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756180Ab0KOBAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:00:33 -0500
Date: Mon, 15 Nov 2010 12:00:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101115010027.GC22876@dastard>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 12:24:21PM +1100, Nick Piggin wrote:
> On Wed, Nov 10, 2010 at 9:05 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> > On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
> >> On Tue, Nov 9, 2010 at 8:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> >
> >> > You can see problems using this fancy thing :
> >> >
> >> > - Need to use slab ctor() to not overwrite some sensitive fields of
> >> > reused inodes.
> >> >  (spinlock, next pointer)
> >>
> >> Yes, the downside of using SLAB_DESTROY_BY_RCU is that you really
> >> cannot initialize some fields in the allocation path, because they may
> >> end up being still used while allocating a new (well, re-used) entry.
> >>
> >> However, I think that in the long run we pretty much _have_ to do that
> >> anyway, because the "free each inode separately with RCU" is a real
> >> overhead (Nick reports 10-20% cost). So it just makes my skin crawl to
> >> go that way.
> >
> > This is a creat/unlink loop on a tmpfs filesystem. Any real filesystem
> > is going to be *much* heavier in creat/unlink (so that 10-20% cost would
> > look more like a few %), and any real workload is going to have much
> > less intensive pattern.
> 
> So to get some more precise numbers, on a new kernel, and on a nehalem
> class CPU, creat/unlink busy loop on ramfs (worst possible case for inode
> RCU), then inode RCU costs 12% more time.
> 
> If we go to ext4 over ramdisk, it's 4.2% slower. Btrfs is 4.3% slower, XFS
> is about 4.9% slower.

That is actually significant because in the current XFS performance
using delayed logging for pure metadata operations is not that far
off ramdisk results.  Indeed, the simple test:

        while (i++ < 1000 * 1000) {
                int fd = open("foo", O_CREAT|O_RDWR, 777);
                unlink("foo");
                close(fd);
        }

Running 8 instances of the above on XFS, each in their own
directory, on a single sata drive with delayed logging enabled with
my current working XFS tree (includes SLAB_DESTROY_BY_RCU inode
cache and XFS inode cache, and numerous other XFS scalability
enhancements) currently runs at ~250k files/s. It took ~33s for 8 of
those loops above to complete in parallel, and was 100% CPU bound...

> Remember, this is on a ramdisk that's _hitting the CPU's L3 if not L2_
> cache. A real disk, even a fast SSD, is going to do IO far slower.

The amount of IO done during the above test?  A single log write -
one IO. Hence it isn't going to be any faster on a RAM disk, an SSD, a
large RAID array, etc because it is CPU bound, not IO bound. IOWs,
that 5% difference in CPU usage is significant for XFS regardless of
the storage....

> And also remember that real workloads will not approach creat/unlink busy
> loop behaviour of creating and destroying 800K files/s.

Perhaps not a local workload, but I expect to see things like
fileservers getting hit with these sorts of loads (i.e. hundreds of
thousands of create/unlinks a second). Especially as XFS now has
the journal scalability to make this possible...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
