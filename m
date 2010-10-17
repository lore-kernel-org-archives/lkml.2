Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0JQGKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 02:10:48 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:58626 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935Ab0JQGKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 02:10:47 -0400
Date: Sun, 17 Oct 2010 17:10:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V4
Message-ID: <20101017061042.GK32255@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <20101016175515.GA6868@amd>
 <20101017024759.GI32255@dastard>
 <20101017025533.GA6482@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017025533.GA6482@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 01:55:33PM +1100, Nick Piggin wrote:
> On Sun, Oct 17, 2010 at 01:47:59PM +1100, Dave Chinner wrote:
> > On Sun, Oct 17, 2010 at 04:55:15AM +1100, Nick Piggin wrote:
> > > On Sat, Oct 16, 2010 at 07:13:54PM +1100, Dave Chinner wrote:
> > > > This patch set is just the basic inode_lock breakup patches plus a
> > > > few more simple changes to the inode code. It stops short of
> > > > introducing RCU inode freeing because those changes are not
> > > > completely baked yet.
> > > 
> > > It also doesn't contain per-zone locking and lrus, or scalability of
> > > superblock list locking.
> > 
> > Sure - that's all explained in the description of what the series
> > actually contains later on. 
> > 
> > > And while the rcu-walk path walking is not fully baked, it has been
> > > reviewed by Linus and is in pretty good shape. So I prefer to utilise
> > > RCU locking here too, seeing as we know it will go in.
> > 
> > I deliberately left out the RCU changes as we know that the version
> > that is in your tree causes siginificant performance regressions for
> > single threaded and some parallel workloads on small (<=8p)
> > machines.
> 
> The worst-case microbenchmark is not a "significant performance
> regression". It is a worst case demonstration. With the parallel
> workloads, are you referring to your postmark xfs workload? It was
> actually due to lazy LRU, IIRC.

Actually, I wasn't refering to the regressions I reported from
fs_mark runs on XFS - I was refering to your "worse case
demonstration" numbers and the comments made during the discussion
that followed.  It wasn't clear to me what the plan was to use
SLAB_DESTROY_BY_RCU or not and the commit messages didn't help,
so I left it out because I was not about to bite off more than I
could chew for .37.

As it is, the lazy LRU code doesn't appear to cause any fs_mark
performance regressions in the testing I've done of my series on
either ext4 or XFS. Hence I don't think that was the cause of any of
the performance problems I originally measured using fs_mark.

And you are right that it wasn't RCU overhead, because....

> I didn't think RCU overhead was noticable there actually.

.... I later noticed you never converted the XFS inode cache to use
RCU inode freeing. Which means that none of the RCU tree walks
are actually protected by RCU when XFS is used with your tree.
Maybe that was causing problems.

But if it's not RCU freeing (or lack thereof) or lazy LRU, it's one
of the other scalability patches that I left out of my series that
was causing the problem.

> Anyway, I've already gone over this couple of months ago when we
> were discussing it. We know it could cause some small regressions,
> if they are small it is considered acceptable and outweighed
> greatly by fastpath speedup. And I have a design to do slab RCU
> which can be used if regressions are large. Linus signed off on
> this, in fact. Why weren't you debating it then?

I try not to debate stuff I don't understand or have no information
about. That discussion is where I first learnt about the existence
of SLAB_DESTROY_BY_RCU. Clueless is not a great position to start
from in a discussion with Linus...

Anyway, that is ancient history. Now I've got patches to convert the
XFS inode cache to use RCU freeing via SLAB_DESTROY_BY_RCU thanks to
what I learnt from that discussion.  The patches don't show any
performance degradation at up to 16p in the benchmarking I've done
so far when combined with the the inode-scale series and the .37 XFS
queue. Hence I think XFS will be ready to go for RCU freed inodes in
.38 regardless of whether the VFS gets there or not.

And as a result of XFS being able to implement this functionality
independently of the VFS, I'm completely ambivialent as to how the
VFS goes about implementing RCU inode freeing. If the VFS
maintainers want to go straight to using SLAB_DESTROY_BY_RCU to
minimise the worst case overhead, then that's what I'll to do...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
