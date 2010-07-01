Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0GAIUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:20:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:35055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0GAIUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:20:30 -0400
Date: Thu, 1 Jul 2010 18:20:26 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100701082026.GG22976@laptop>
References: <20100624030212.676457061@suse.de>
 <20100630113054.GL24712@dastard>
 <20100630124049.GH21358@laptop>
 <20100701035657.GU24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701035657.GU24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 01:56:57PM +1000, Dave Chinner wrote:
> On Wed, Jun 30, 2010 at 10:40:49PM +1000, Nick Piggin wrote:
> > On Wed, Jun 30, 2010 at 09:30:54PM +1000, Dave Chinner wrote:
> > > On Thu, Jun 24, 2010 at 01:02:12PM +1000, npiggin@suse.de wrote:
> > > > Performance:
> > > > Last time I was testing on a 32-node Altix which could be considered as not a
> > > > sweet-spot for Linux performance target (ie. improvements there may not justify
> > > > complexity). So recently I've been testing with a tightly interconnected
> > > > 4-socket Nehalem (4s/32c/64t). Linux needs to perform well on this size of
> > > > system.
> > > 
> > > Sure, but I have to question how much of this is actually necessary?
> > > A lot of it looks like scalability for scalabilities sake, not
> > > because there is a demonstrated need...
> > 
> > People are complaining about vfs scalability already (at least Intel,
> > Google, IBM, and networking people). By the time people start shouting,
> > it's too late because it will take years to get the patches merged. I'm
> > not counting -rt people who have a bad time with global vfs locks.
> 
> I'm not denying it that we need to do work here - I'm questioning
> the "change everything at once" approach this patch set takes.
> You've started from the assumption that everything the dcache_lock
> and inode_lock protect are a problem and goes from there.
> 
> However, if we move some things out fom under the dcache lock, then
> the pressure on the lock goes down and the remaining operations may
> not hinder scalability. That's what I'm trying to understand, and
> why I'm suggesting that you need to break this down into smaller,
> more easily verifable, benchamrked patch sets. IMO, I have no way of
> verifying if any of these patches are necessary or not, and I need
> to understand that as part of reviewing them...

I can see where you're coming from, and I tried to do that, but it
got pretty hard and messy. Also, it was pretty difficult to lift
dcache and inode lock out of many paths unless *everything* else
was protected by other locks. It is also hard not to introduce more
atomic operations and slow down single thread performance.

It's not so much the lock hold times as the cacheline bouncing that
hurts most. So when adding or removing a dentry for example, we
manipulate hash, lru, inode alias, parent, and the fields in the
dentry itself. If you have to take the dcache_lock for any of those
manipulations, you incur the global cacheline bounce for that operation.

Honestly, I like the way the locking turned out. In dcache.c, inode.c
and fs-writeback.c it is complex, but it always has been. For
filesystems I would say it is simpler.

Need to stabilize a dentry? Take dentry->d_lock. This freezes all its
fields, its refcount, pins it in (or out of) data structures, and
pins its immediate parent and children, and inode we point to. Same
for inodes.

The rest of the data structures (hash, lru, io lists, inode alias lists
etc) that they may belong to, are protected by individual, narrow locks.

 
> > > > *** 64 parallel git diff on 64 kernel trees fully cached (avg of 5 runs):
> > > >                 vanilla         vfs
> > > > real            0m4.911s        0m0.183s
> > > > user            0m1.920s        0m1.610s
> > > > sys             4m58.670s       0m5.770s
> > > > After vfs patches, 26x increase in throughput, however parallelism is limited
> > > > by test spawning and exit phases. sys time improvement shows closer to 50x
> > > > improvement. vanilla is bottlenecked on dcache_lock.
> > > 
> > > So if we cherry pick patches out of the series, what is the bare
> > > minimum set needed to obtain a result in this ballpark? Same for the
> > > other tests?
> > 
> > Well it's very hard to just scale up bits and pieces because the
> > dcache_lock is currently basically global (except for d_flags and
> > some cases of d_count manipulations).
> > 
> > Start chipping away at bits and pieces of it as people hit bottlenecks
> > and I think it will end in a bigger mess than we have now.
> 
> I'm not suggesting that we should do this randomly. A more
> structured approach that demonstrates the improvement as groups of
> changes are made will help us evaluate the changes more effectively.
> It may be that we need every single change in the patch series, but
> there is no way we can verify that with the information that has
> been provided.

I didn't say randomly, but piece-wise, reducing locks bit by bit as
problems are quantified. Doing that means that all the code has to go
*far more* locking-scheme transitions and it's harder to come to a clean
overall end result.

