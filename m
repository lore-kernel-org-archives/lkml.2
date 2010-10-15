Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0JOK7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:59:49 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:44605 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754443Ab0JOK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:59:47 -0400
Date: Fri, 15 Oct 2010 21:59:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015105943.GE32255@dastard>
References: <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015064150.GB7511@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 05:41:50PM +1100, Nick Piggin wrote:
> You're worried about mere mortals reviewing and understanding it...
> I don't really know. If you understand inode locking today, you
> can understand the inode scaling series quite easily. Ditto for
> dcache. rcu-walk path walking is trickier, but it is described in
> detail in documentation and changelog.
> 
> And you can understand the high level approach without exactly
> digesting every detail at once. The inode locking work goes to
> break up all global locks:
> 
> - a single inode object is protected (to the same level as
>   inode_lock) with i_lock. This makes it really trivial for
>   filesystems to lock down the object without taking a global
>   lock.

Which is unnecessarily wide, and results in i_lock  having to have
list locks nested inside it, and that leads to the lock
inversion try-lock mess that several people have complained about.

My series uses i_lock only to protect i_state and i_ref. It does not
need to protect any more of the inode than that as other locks
protect the other list fields. As a result, it's still the inermost
lock and there are no trylocks in the code at all.

> - inode hash rcuified and insertion/removal made per-bucket

My series goes to per-bucket locks, and can easily be converted to
rcu lookups in the next series that introduces RCU inode freeing.

> - inode lru lists and locking made per-zone

Per-zone is problematic. The second hottest lock on my single node
8p VM right now is the inode_lru_lock. A per-zone lock for the LRU
on such a machine is still a global lock. Even on large NUMA
machines we'll end up with this as a hot lock, especially as we're
looking at 12 core CPUs in a few months time and 16c/32t in a year
or so.

As it is, the cause of the lock contention I'm seeing is unbound
direct reclaim parallelism - every CPU on the node running the inode
cache shrinker at the same time. This behaviour will not change by
making the locking per-zone, just cause hot nodes to occur.

One potential solution to this is that only kswapd runs shrinkers to
limit parallelism, and this would match up with per-node LRU list
and locking infrastructure.  And to tie that back to another thread,
you can probably see some of the reasoning behind Christoph's
suggestions that per-zone shrinkers, LRUs and locking may not be the
best way to scale cache reclaim.

IMO, this is definitely a change that needs further discussion and
is one of the reasons why I haven't pushed any further down this
path - there's unresolved issues with this approach. It is also a
completely separable piece of work and does not need to be solved to
implement to store-free path walking...

> - inode sb list made per-sb, per-cpu

I've gone as far as per-sb, so it still has a global lock. This is
enough to move the lock out contention out of the profiles at 8p,
and does not prevent a different method from being added later.
It's good enough for an average sized server - holding off
finegrained lists and locking for a release or two while everything
else is sorted out because the inode_lru_lock is hotter. Also it's
not necessary to solve the problem to implement store-free path
walking.

> - inode counters made per-cpu

I reworked this to make both the nr_inodes and nr_unused counters
per-cpu and did it in one patch up front instead of spread across
three separate patches.

> - inode io lists and locking made per-bdi

And I've pulled that in done that, too while dropping all the messy
list manipulation loops as the wrong bdi problem is fixed upstream now.

Nothing I've done prevents RCU-ising the inode cache, but I've
discovered some issues that you've missed in moving straight to
fine-grained per-zone LRU lists and locking. I think the code is
cleaner (no trylocks or loops to get locks out of order), the series
is cleaner and it has gone through a couple of rounds of review
already.  This is why I'd like you to try rebasing your tree on top
of it to determine if my assertions that there are no inhernet
problems are correct....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
