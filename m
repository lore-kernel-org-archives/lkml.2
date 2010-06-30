Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0F3LbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:31:24 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:33615 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115Ab0F3LbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:31:23 -0400
Date: Wed, 30 Jun 2010 21:30:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100630113054.GL24712@dastard>
References: <20100624030212.676457061@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030212.676457061@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:02:12PM +1000, npiggin@suse.de wrote:
> http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/

Can you put a git tree up somewhere?

> Update to vfs scalability patches:

....

Now that I've had a look at the whole series, I'll make an overall
comment: I suspect that the locking is sufficiently complex that we
can count the number of people that will be able to debug it on one
hand.  This patch set didn't just fall off the locking cliff, it
fell into a bottomless pit...

> Performance:
> Last time I was testing on a 32-node Altix which could be considered as not a
> sweet-spot for Linux performance target (ie. improvements there may not justify
> complexity). So recently I've been testing with a tightly interconnected
> 4-socket Nehalem (4s/32c/64t). Linux needs to perform well on this size of
> system.

Sure, but I have to question how much of this is actually necessary?
A lot of it looks like scalability for scalabilities sake, not
because there is a demonstrated need...

> *** Single-thread microbenchmark (simple syscall loops, lower is better):
> Test                    Difference at 95.0% confidence (50 runs)
> open/close              -6.07% +/- 1.075%
> creat/unlink            27.83% +/- 0.522%
> Open/close is a little faster, which should be due to one less atomic in the
> dput common case. Creat/unlink is significantly slower, which is due to RCU
> freeing inodes.

That's a pretty big ouch. Why does RCU freeing of inodes cause that
much regression? The RCU freeing is out of line, so where does the big
impact come from?

> *** 64 parallel git diff on 64 kernel trees fully cached (avg of 5 runs):
>                 vanilla         vfs
> real            0m4.911s        0m0.183s
> user            0m1.920s        0m1.610s
> sys             4m58.670s       0m5.770s
> After vfs patches, 26x increase in throughput, however parallelism is limited
> by test spawning and exit phases. sys time improvement shows closer to 50x
> improvement. vanilla is bottlenecked on dcache_lock.

So if we cherry pick patches out of the series, what is the bare
minimum set needed to obtain a result in this ballpark? Same for the
other tests?

> *** Reclaim
> I have not done much reclaim testing yet. It should be more scalable and lower
> latency due to significant reduction in lru locks interfering with other
> critical sections in inode/dentry code, and because we have per-zone locks.
> Per-zone LRUs mean that reclaim is targetted to the correct zone, and that
> kswapd will operate on lists of node-local memory objects.

This means we no longer have any global LRUness to inode or dentry
reclaim, which is going to significantly change caching behaviour.
It's also got interesting corner cases like a workload running on a
single node with a dentry/icache working set larger than the VM
wants to hold on a single node.

We went through these sorts of problems with cpusets a few years
back, and the workaround for it was not to limit the slab cache to
the cpuset's nodes. Handling this sort of problem correctly seems
distinctly non-trivial, so I'm really very reluctant to move in this
direction without clear evidence that we have no other
alternative....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
