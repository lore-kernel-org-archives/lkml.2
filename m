Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0JODNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:13:49 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:35291 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755523Ab0JODNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:13:47 -0400
Date: Fri, 15 Oct 2010 14:13:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015031343.GG4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015001443.GA3146@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 11:14:43AM +1100, Nick Piggin wrote:
> On Thu, Oct 14, 2010 at 10:41:59AM -0400, Christoph Hellwig wrote:
> > On Thu, Oct 14, 2010 at 08:06:09PM +1100, Nick Piggin wrote:
> > > Shrinker and zone reclaim is definitely needed. It is needed for NUMA
> > > scalability and locality of reclaim, and also for container and directed
> > > dentry/inode reclaim. Google have a very similar patch and they've said
> > > this is needed (and I already know it is needed for scalability on
> > > large NUMA -- SGI were complaining about this nearly 5 years ago IIRC).
> > > So that is _definitely_ going to be needed.
> > 
> > I'm sitll not sold on the per-zone shrinkers.  For one per-zone is
> > a really weird concept.  per-node might make a lot more sense, but
> > what we really need for doing things usefully is per-sb.  If that's
> > not scalable we might have to for sb x zone.
> 
> Well I don't know what it means that you're "not sold" on them, and
> then come up with ridiculous things like per-node might make a lot
> more sense, or per-sb; and that per-zone is a really weird concept.
>
> Per-zone is the right way to drive reclaim, and it will allow locality
> to work properly, as well as zone reclaim and zone targetted shortages
> and policies, and it will also give good scalability. People need it for
> all these reasons.

I don't have enough information to be able to say what is the
correct way to improve the shrinkers, but I do have plenty of
information on how the current unbound reclaim parallelism is an
utter PITA to handle. Indeed, it was partially responsible for the
recent kernel.org outage. Hence I really don't like anything that
potentially increases reclaim parallelism until there's been
discussion and work towards fixing these problems first.

Beisdes, IMO, we don't need to rework shrinkers, add zone-based
reclaim, use per-cpu inode lists, etc. to enable store-free path
walking.  You've shown it can be done, and that's great - it shows
us the impact of making those changes, but they need to be analysed
separately and treated on own their merits, not lumped with core
locking changes necessary for store-free path walking.

We know what you think, but you have to let everyone else form their
own opinions and then be convinced by code or discussion that your
way is the right way to do it. This requires your tree to be broken
down into it's component pieces so that us mere mortals can
understand and test the impact of each separate set of changes has
on the system.  It makes it easier to review, identify regressions,
etc but it should not prevent us from reaching the end goal.

> But you missed my point about that. My point is that we _know_ that
> store free path walks are going to be merged, it is one of the more
> desirable pieces of the series. So we _know_ RCU inodes are needed, so
> we can happily use RCU work earlier in the series to make locking
> better in the icache.

We've still got to do all the lock splitting work so we can update
everything without contention. It doesn't matter if that is done
before or after adding RCU - the end result _should_ be the same.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
