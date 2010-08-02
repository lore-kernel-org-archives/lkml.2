Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0HBLHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:07:41 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59786 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246Ab0HBLHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:07:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJxBVkx5Ld2l/2dsb2JhbACgDHK+ZYU5BA
Date: Mon, 2 Aug 2010 19:51:33 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802095133.GA9132@amd>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
 <20100802055834.GB19164@dastard>
 <20100802075537.GC7841@amd>
 <20100802082428.GA23135@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802082428.GA23135@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 04:24:28AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 02, 2010 at 05:55:37PM +1000, Nick Piggin wrote:
> > I hate to say but I would like to see it mature for another release. It
> > should also clash a bit with Al's recent inode work that he'll want to
> > push.
> > 
> > What I can do is send some of the ground work patches this time around,
> > put the tree into linux-next, and put reviewers on notice.
> > 
> > I think it is all conceptually sound, but it will inevitably have some
> > bugs left to shake out, and things to be fixed on the review side. I
> > don't anticipate a problem that could not be fixed in the release cycle,
> > but I think aiming for post 2.6.36 is a bit fairer for vfs guys,
> > honestly. LSF is next week too, so most of them will be busy with travel
> > and such. But I do hope to discuss the vfs-scale patches there.
> 
> What I'm most concerned bit merging everything in one go.  It's a huge
> series and I'd rather see it start going in in batches over multiple
> kernel releases.

One problem is that to win much benefit, several different aspects
must be scaled. If not, then you end up with more locks *and* still
have bouncing global cachelines. And filesystems will go through
multiple releases where locking changes are in flux. This is what
I'm concerned about.

I definitely have tried to keep everything as conceptually seperate
small chunks. But there is a real big-picture aspect that is required
to review it.

For example, you asked for just the locking split-up without any of
the per-hash-locks and per-cpu locks etc. That's fine for review, but
you cannot merge it because then you end up with N bouncing global
locks instead of 1. It also tends to be much uglier than a final
outcome because I have not applied any transformations to improve lock
orderings and reduce trylocking etc.


> Things like the fs_struct spinlock and some other preparatory patches
> should be ver easily to do for 2.6.36.  Scaling the files and vfsmount
> locks should also be easily doable, but we need to sort out the struct
> file growth in the later.  We really can't grow struct file by two
> pointers as that would have devasting effects on various workloads.

Strictly, it is a filesystem corruption bug-fix for the tty layer
and nothing to do with tty scaling patches.

I don't have the patience at the moment to sort through tty layer
crap, but whoever is maintaining that should. I could possibly come
back and look at it some point, but given your half-working patch
as a guide, I think someone who knows the code can fix it.


> What follows after that is the dcache_lock scaling which to seems the
> most immature bit of the series, and the one that showed by far the
> most problems in -RT.  I'm very much dead set against merging that in
> .36.

That's a fair point, I agree with. It needs most review.


>  I'd much rather see the inode_lock scaling or the lockless path
> walk going in before, but I haven't checked how complicated the
> reordering would be.

I would much prefer not to re-order it before either of inode or
dcache scaling patches. It would introduce a lot of churn and
locking is significantly changed.

It probably should be possible, although we would still get path
walk contention on dcache_lock, vfsmount_lock, and requires inode-RCU
(making inodes more expensive without being offset by any benefits of
inode scaling), and requires changes to filesystem dcache and inode
APIs.

I could work on re-ordering it certainly, but only if it is decided
that we definitely don't want dcache-scale or inode-scale patch sets
in the forseeable future. I think we definitely do want them, so I
find it hard to justify a big reordering.


>  The lockless path walk also is only rather
> theoretically useful until we do ACL checks lockless as we're having
> ACLs enabled pretty much everywhere at least in the distros.

True, it needs a last bit of work for permission checking. The 
conceptual idea and the bulk of the code I think is ready to review
though. ACLs should be just more of the same.


> The per-zone shrinkers are another thing that's not directly related,
> I think they need a lot more discussion with the VM folks, and
> integrating with Dave's work in that area.

Well I'm a VM folk :) Conceptually, there is no problems for MM
here. This is really the right way to drive reclaim from the MM
perspective (ie. per-zone). Of course I will work with Dave and
take suggestions on implementation.

It is directly related in that it is required to remove global lock and
global list scanning from vfs reclaim, which is something that we've
known and wanted for a long time.

On one hand, you might say I'm going overboard, but on another hand,
vfs really sucks on NUMA and SMP right now and it's only going to
get worse for "normal" (ie. not HPC) people.

