Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab2HQSJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab2HQSJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:09:05 -0400
Date: Fri, 17 Aug 2012 20:08:47 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org, oleg@redhat.com,
        pjt@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
        Petr Holasek <pholasek@redhat.com>
Subject: Re: [PATCH 00/19] sched-numa rewrite
Message-ID: <20120817180847.GE10129@redhat.com>
References: <20120731191204.540691987@chello.nl>
 <20120808171714.GM10459@redhat.com>
 <5022B356.9060902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5022B356.9060902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 08, 2012 at 02:43:34PM -0400, Rik van Riel wrote:
> While the sched-numa code is relatively small and clean, the
> current version does not seem to offer a significant
> performance improvement over not having it, and in one of
> the tests performance actually regresses vs. mainline.

sched-numa is small true, but I argue about it being clean. It does
lots of hacks, it has a worse numa hinting page fault implementation,
it has no runtime disable tweak, it has no config option, and it's
very intrusive in the scheduler and MM code and it'd be very hard to
backout if a better solution would emerge in the future.

> On the other hand, the autonuma code is pretty large and
> hard to understand, but it does provide a significant
> speedup on each of the tests.

AutoNUMA code is certainly pretty large, but it is totally self
contained. 90% of it is in isolated files that can be deleted and
won't even get built if CONFIG_AUTONUMA=n. The other common code
changes can be wiped out by following the build errors after dropping
the include files with CONFIG_AUTONUMA=n, shall a better solution
emerge in the future.

I think it's important that whatever is merged, is self contained and
easy to backout in the future. Especially if the not self contained
code is full of hacks like big/small mode or random number generator
generating part of the "input".

I applied the fix for sched-numa rewrite/v2 posted on lkml but I still
lockups when running the autonuma-benchmark on the 8 nodes system, I
never could complete the first numa01 test. I provided stack traces
off list to debug it.

So for now I updated the pdf with only the autonuma23 results for the
8 nodes system. I had to bump the autonuma version to 23 and repeat
all benchmarks because of a one liner s/kalloc/kzalloc/ change needed
to successfully boot autonuma on the 8 node system (that boots with
ram not zeroed out).

http://www.kernel.org/pub/linux/kernel/people/andrea/autonuma/autonuma-vs-sched-numa-rewrite-20120817.pdf

I didn't include the convergence charts for 3.6-rc1 on the 8 nodes
because they're equal to the ones on the 2 nodes and they would only
waste pdf real estate.

>From the numa02_SMT charts I suspect something may not be perfect in
the active load idle balancing of CFS. The imperfection is likely lost
in the noise, and without the convergence charts showing the exact
memory distribution across the nodes it would be hard to notice it.

numa01 on the 8 nodes is quite a pathological case, and it shows the
heavy NUMA false sharing/relation there is when 2 processes crosses 4
nodes each and touches all memory in a loop. The smooth async memory
migration of that pathological case still doesn't hurt despite some
small migration keep going in the background forever (this is why
async migrate providing smooth behavior is quite important). numa01 is
a very different load on 2 nodes vs 8 nodes (on 2 nodes it can coverge
100% and it will stop the memory migrations altogether).

Sometime near the end of the tests (X axis is time) you'll notice some
divergence, that happens because some threads completes sooner (the
threads of the node that had all ram local at startup certainly will
always complete faster than the others). The reason for that
divergence is that it falls into the _SMT case to fill all idle cores.

I also noticed on the 8 node system some repetition of the task
migrations invoked by sched_autonuma_balance() that I intend to
optimize away in future versions (it is only visible after enabling
the debug mode). Fixing it, will save some small amount of CPU. What
happens is that the idle load balancing invoked by the CPU that become
idle after the task migration, sometime grabs the migrated task and
puts it back in its original position, so the migration has to be
repeated at the next invocation of sched_autonuma_balance().
