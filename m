Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0F3OdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:33:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab0F3OdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:33:17 -0400
Date: Wed, 30 Jun 2010 22:40:49 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100630124049.GH21358@laptop>
References: <20100624030212.676457061@suse.de>
 <20100630113054.GL24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630113054.GL24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 09:30:54PM +1000, Dave Chinner wrote:
> On Thu, Jun 24, 2010 at 01:02:12PM +1000, npiggin@suse.de wrote:
> > http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/
> 
> Can you put a git tree up somewhere?

I suppose I should. I'll try to set one up.

 
> > Update to vfs scalability patches:
> 
> ....
> 
> Now that I've had a look at the whole series, I'll make an overall
> comment: I suspect that the locking is sufficiently complex that we
> can count the number of people that will be able to debug it on one
> hand.

As opposed to everyone who understood it beforehand? :)


>  This patch set didn't just fall off the locking cliff, it
> fell into a bottomless pit...

I actually think it's simpler in ways. It has more locks, but a
lot of those protect small, well defined data.

Filesystems have required surprisingly minimal changes (except
autofs4, but that's fairly special case).


> > Performance:
> > Last time I was testing on a 32-node Altix which could be considered as not a
> > sweet-spot for Linux performance target (ie. improvements there may not justify
> > complexity). So recently I've been testing with a tightly interconnected
> > 4-socket Nehalem (4s/32c/64t). Linux needs to perform well on this size of
> > system.
> 
> Sure, but I have to question how much of this is actually necessary?
> A lot of it looks like scalability for scalabilities sake, not
> because there is a demonstrated need...

People are complaining about vfs scalability already (at least Intel,
Google, IBM, and networking people). By the time people start shouting,
it's too late because it will take years to get the patches merged. I'm
not counting -rt people who have a bad time with global vfs locks.

You saw the "batched dput+iput" hacks that google posted a couple of
years ago. Those were in the days of 4 core Core2 CPUs, long before 16
thread Nehalems that will scale well to 4/8 sockets at low cost.

At the high end, vaguely extrapolating from my numbers, a big POWER7 may
do under 100 open/close operations per second per hw thread. A big UV
probably under 10 per core.

But actually it's not all for scalability. I have some follow on patches
(that require RCU inodes, among other things) that actually improve
single threaded performance significnatly. git diff workload IIRC was
several % improved from speeding up stat(2).


> > *** Single-thread microbenchmark (simple syscall loops, lower is better):
> > Test                    Difference at 95.0% confidence (50 runs)
> > open/close              -6.07% +/- 1.075%
> > creat/unlink            27.83% +/- 0.522%
> > Open/close is a little faster, which should be due to one less atomic in the
> > dput common case. Creat/unlink is significantly slower, which is due to RCU
> > freeing inodes.
> 
> That's a pretty big ouch. Why does RCU freeing of inodes cause that
> much regression? The RCU freeing is out of line, so where does the big
> impact come from?

That comes mostly from inability to reuse the cache-hot inode structure,
and the cost to go over the deferred RCU list and free them after they
get cache cold.

 
> > *** 64 parallel git diff on 64 kernel trees fully cached (avg of 5 runs):
> >                 vanilla         vfs
> > real            0m4.911s        0m0.183s
> > user            0m1.920s        0m1.610s
> > sys             4m58.670s       0m5.770s
> > After vfs patches, 26x increase in throughput, however parallelism is limited
> > by test spawning and exit phases. sys time improvement shows closer to 50x
> > improvement. vanilla is bottlenecked on dcache_lock.
> 
> So if we cherry pick patches out of the series, what is the bare
> minimum set needed to obtain a result in this ballpark? Same for the
> other tests?

Well it's very hard to just scale up bits and pieces because the
dcache_lock is currently basically global (except for d_flags and
some cases of d_count manipulations).

Start chipping away at bits and pieces of it as people hit bottlenecks
and I think it will end in a bigger mess than we have now.

I don't think this should be done lightly, but I think it is going to
be required soon.


> > *** Reclaim
> > I have not done much reclaim testing yet. It should be more scalable and lower
> > latency due to significant reduction in lru locks interfering with other
> > critical sections in inode/dentry code, and because we have per-zone locks.
> > Per-zone LRUs mean that reclaim is targetted to the correct zone, and that
> > kswapd will operate on lists of node-local memory objects.
> 
> This means we no longer have any global LRUness to inode or dentry
> reclaim, which is going to significantly change caching behaviour.
> It's also got interesting corner cases like a workload running on a
> single node with a dentry/icache working set larger than the VM
> wants to hold on a single node.
> 
> We went through these sorts of problems with cpusets a few years
> back, and the workaround for it was not to limit the slab cache to
> the cpuset's nodes. Handling this sort of problem correctly seems
> distinctly non-trivial, so I'm really very reluctant to move in this
> direction without clear evidence that we have no other
> alternative....

As I explained in the other mail, that's not actaully how the
per-zone reclaim works.

Thanks,
Nick
