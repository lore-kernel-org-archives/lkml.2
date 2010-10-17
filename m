Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0JQC5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:57:05 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22680 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757179Ab0JQC5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:57:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAAsAukx5LcB2gWdsb2JhbAChKRYBARYiIsIRhUkE
Date: Sun, 17 Oct 2010 13:57:00 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V4
Message-ID: <20101017025700.GB6482@amd>
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
> actually due to lazy LRU, IIRC. I didn't think RCU overhead was
> noticable there actually.
> 
> Anyway, I've already gone over this couple of months ago when we
> were discussing it. We know it could cause some small regressions,
> if they are small it is considered acceptable and outweighed
> greatly by fastpath speedup. And I have a design to do slab RCU
> which can be used if regressions are large. Linus signed off on
> this, in fact. Why weren't you debating it then?

It goes to the heart of the locking model, and I think it is silly
just to do this and then go and rewrite locking a release or two later
when rcu is introduced. And change it again when you start listening
to the people who want per-zone lrus.

