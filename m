Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0JONDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:03:07 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:1560 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab0JONDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:03:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKbtt0x5Ld+3/2dsb2JhbAChIHK+DoVJBIUMij4
Date: Sat, 16 Oct 2010 00:03:00 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015130259.GA3207@amd>
References: <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015105943.GE32255@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:59:43PM +1100, Dave Chinner wrote:
> On Fri, Oct 15, 2010 at 05:41:50PM +1100, Nick Piggin wrote:
> > You're worried about mere mortals reviewing and understanding it...
> > I don't really know. If you understand inode locking today, you
> > can understand the inode scaling series quite easily. Ditto for
> > dcache. rcu-walk path walking is trickier, but it is described in
> > detail in documentation and changelog.
> > 
> > And you can understand the high level approach without exactly
> > digesting every detail at once. The inode locking work goes to
> > break up all global locks:
> > 
> > - a single inode object is protected (to the same level as
> >   inode_lock) with i_lock. This makes it really trivial for
> >   filesystems to lock down the object without taking a global
> >   lock.
> 
> Which is unnecessarily wide, and results in i_lock  having to have
> list locks nested inside it, and that leads to the lock
> inversion try-lock mess that several people have complained about.

That's how I've done it. When you objected to it, I pointed out
that I can use RCU _or_ lift out i_lock selectively from some of
the protected members like the lists (and I've pointed this out
in changelogs too).

I haven't quite decided or had time yet to decide which approach
I want to take there, but seeing as it is all confined to core
icache code, it wasn't as urgent (as, say, store-free path walking).
But it was always the intention to continue streamlining things.

 
> My series uses i_lock only to protect i_state and i_ref. It does not
> need to protect any more of the inode than that as other locks
> protect the other list fields. As a result, it's still the inermost
> lock and there are no trylocks in the code at all.

See if you actually understand how my patch series is structured,
and how I want to get a series of reviewable and bisectable,
small easy to understand transitions, then you know I don't
agree with doing it this way.

I am building up locks underneath inode_lock/dcache_lock in
steps until it can be taken out. After that, there is a series
to incrementally fine grain and streamline the locking.

Seeing as you objected strongly to the trylocks, and we discussed
this, it would have been productive for _you_ to build on top of
_my_ patch set and incrementally lift more i_locks away.

So your patch would contain the justification of why it is correct
and easily bisectable.

As far as you insistence of being "innermost lock", I'm baffled.
Firstly, it is not. dcache_lock nests inside it for christ's sake,
and lots of locks nest inside dcache_lock. Secondly, lock ordering
is not defined by some external entity, it is defined by the
code.

We discussed it and I didn't think latencies would be any worse
a problem than they are today. I agreed it may be an issue and
pointed out there are ways forward to fix it.


> > - inode hash rcuified and insertion/removal made per-bucket
> 
> My series goes to per-bucket locks, and can easily be converted to
> rcu lookups in the next series that introduces RCU inode freeing.
> 
> > - inode lru lists and locking made per-zone
> 
> Per-zone is problematic. The second hottest lock on my single node

Can you respond to my other email where I go into detail and try to
address your misconceptions and concerns? And acutally come up with
a real objection.


> 8p VM right now is the inode_lru_lock. A per-zone lock for the LRU
> on such a machine is still a global lock. Even on large NUMA
> machines we'll end up with this as a hot lock, especially as we're
> looking at 12 core CPUs in a few months time and 16c/32t in a year
> or so.
> 
> As it is, the cause of the lock contention I'm seeing is unbound
> direct reclaim parallelism - every CPU on the node running the inode
> cache shrinker at the same time. This behaviour will not change by
> making the locking per-zone, just cause hot nodes to occur.
> 
> One potential solution to this is that only kswapd runs shrinkers to
> limit parallelism, and this would match up with per-node LRU list
> and locking infrastructure.  And to tie that back to another thread,
> you can probably see some of the reasoning behind Christoph's
> suggestions that per-zone shrinkers, LRUs and locking may not be the
> best way to scale cache reclaim.
> 
> IMO, this is definitely a change that needs further discussion and
> is one of the reasons why I haven't pushed any further down this
> path - there's unresolved issues with this approach. It is also a
> completely separable piece of work and does not need to be solved to
> implement to store-free path walking...

I've pushed further down with this path, I re explained it to you
again in my other mail, and I've had reviews from VM guys, including
people at google who actually have similar patches and problems. So
at this point please either catch up or stop handwaving objections.

No, it is not infinitely scalable with respect to multi core nodes,
but that whole issue is a VM wide problem. The right thing to do
with the shrinkers is to get them in line with the rest of the VM
reclaim and subsequent scalability improvements there can be shared
without really any involvement from the vfs.

So that's all I have to say about per-zone lrus/locks unless you
actually have something constructive to say. All I hear is handwaving
and "oh we could do this or that or I don't know if it is the right
way to go and we should get VM guys to look at it". I've had enough
of that, it's not going anywhere.

I'm telling you for the last time, there are people that need per-zone
scanning, and there are people that need per-zone locking.


> > - inode sb list made per-sb, per-cpu
> 
> I've gone as far as per-sb, so it still has a global lock. This is
> enough to move the lock out contention out of the profiles at 8p,
> and does not prevent a different method from being added later.
> It's good enough for an average sized server - holding off
> finegrained lists and locking for a release or two while everything
> else is sorted out because the inode_lru_lock is hotter. Also it's
> not necessary to solve the problem to implement store-free path
> walking.

So that's another deficiency. I very quickly found on large machines
that any such locking like this would quickly cause big problems (and
limit parallelism when testing other improvements) so I fixed it.

And no, I don't want to just wait a release or two, change a bit
more, wait another release or two, change more, that we know all
along needs to be changed.

You're trying to paint my 3 patches to transform counters to per-cpu
as a negative, and yet you want to have the subsystem locking in
flux and in dispute over multiple kernel releases? Come on, are you
joking?

 
> > - inode counters made per-cpu
> 
> I reworked this to make both the nr_inodes and nr_unused counters
> per-cpu and did it in one patch up front instead of spread across
> three separate patches.
> 
> > - inode io lists and locking made per-bdi
> 
> And I've pulled that in done that, too while dropping all the messy
> list manipulation loops as the wrong bdi problem is fixed upstream now.
> 
> Nothing I've done prevents RCU-ising the inode cache, but I've
> discovered some issues that you've missed in moving straight to
> fine-grained per-zone LRU lists and locking. I think the code is
> cleaner (no trylocks or loops to get locks out of order), the series
> is cleaner and it has gone through a couple of rounds of review
> already.  This is why I'd like you to try rebasing your tree on top
> of it to determine if my assertions that there are no inhernet
> problems are correct....

You have it upside down, I think. I've got way more work sitting
here that has been tested and in my opinion has the better set
of steps to transform the locking.

I am looking at your changes and see if any might apply to my tree.

