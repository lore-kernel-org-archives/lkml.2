Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1LYJkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 04:40:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46514 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1LYJkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 04:40:01 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20111223102810.GT3487@suse.de>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<1321960128-15191-6-git-send-email-gilad@benyossef.com>
	<20111223102810.GT3487@suse.de>
Date: Sun, 25 Dec 2011 11:39:59 +0200
Message-ID: <CAOtvUMd6+ZZVLp-FbbEwbq3UZLRvSRo+_MMYj1aCGT3gBhxMwg@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 12:28 PM, Mel Gorman <mgorman@suse.de> wrote:
>
> On Tue, Nov 22, 2011 at 01:08:48PM +0200, Gilad Ben-Yossef wrote:
> > Calculate a cpumask of CPUs with per-cpu pages in any zone and only send an IPI requesting CPUs to drain these pages to the buddy allocator if they actually have pages when asked to flush.
> >
> > The code path of memory allocation failure for CPUMASK_OFFSTACK=y config was tested using fault injection framework.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Acked-by: Christoph Lameter <cl@linux.com>
> > CC: Chris Metcalf <cmetcalf@tilera.com>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Russell King <linux@arm.linux.org.uk>
> > CC: linux-mm@kvack.org
> > CC: Pekka Enberg <penberg@kernel.org>
> > CC: Matt Mackall <mpm@selenic.com>
> > CC: Sasha Levin <levinsasha928@gmail.com>
> > CC: Rik van Riel <riel@redhat.com>
> > CC: Andi Kleen <andi@firstfloor.org>
> > ---
> >  mm/page_alloc.c |   18 +++++++++++++++++-
> >  1 files changed, 17 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 9dd443d..a3efdf1 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1119,7 +1119,23 @@ void drain_local_pages(void *arg)
> >   */
> >  void drain_all_pages(void)
> >  {
> > -     on_each_cpu(drain_local_pages, NULL, 1);
> > +     int cpu;
> > +     struct zone *zone;
> > +     cpumask_var_t cpus;
> > +     struct per_cpu_pageset *pcp;
> > +
> > +     if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
> > +             for_each_online_cpu(cpu) {
> > +                     for_each_populated_zone(zone) {
> > +                             pcp = per_cpu_ptr(zone->pageset, cpu);
> > +                             if (pcp->pcp.count)
> > +                                     cpumask_set_cpu(cpu, cpus);
> > +             }
> > +     }
> > +             on_each_cpu_mask(cpus, drain_local_pages, NULL, 1);
> > +             free_cpumask_var(cpus);
>
First off, thank you for the review.

>
> The indenting there is very weird but easily fixed.


Hmm... I missed that. Sorry. I will fix it with the next iteration.
>
>
> A greater concern is that we are calling zalloc_cpumask_var() from the
> direct reclaim path when we are already under memory pressure. How often
> is this path hit and how often does the allocation fail?


Yes, this scenario worried me too. In fact, I worried that we might
end in an infinite
loop of direct reclaim => cpumask var allocation => direct reclaim.
Luckily this can't happen.
It did cause me to test the failure allocation case with the fault
injection frame work to make
sure it fails gracefully.

I'll try to explain why I believe we end up succeeding in most cases:

For CONFIG_CPUMASK_OFFSTACK=n - case there is no allocation, so there
is no problem.

For CONFIG_CPUMASK_OFFSTACK=y but when we got to drain_all_pages from
the memory
hotplug or the memory failure code path (the code other code path that
call drain_all_pages),
there is  no inherent memory pressure, so we should be OK.

If we did get to drain_all_pages  from direct reclaim, but the cpumask
slab has an object in the
slab (or partial pages in the case  of slub), then we never hit the
page allocator so all is well, I believe.

So this leaves us with being called from the direct reclaim path, when
the cpumask slab has no
object or partial pages and it needs to hit the page allocator.  If we
hit direct page relcaim, the original
allocation was not atomic , otherwise we would not have  hit direct
page reclaim.  The cpumask allocation
however,  is atomic, so we have broader allocation options -  allocate
high,  allocate outside our cpuset
etc. and  there is a reasonable chance the cpumask allocation can
succeed even if the original allocation
ended up in direct reclaim.

So we end up failing to allocate the cpumask var only if the memory
pressure is really a global system
memory shortage, as opposed to, for example, some user space failure
to page in some heap space
in a cpuset. Even then, we fail gracefully.


> Related to that, calling into the page allocator again for
> zalloc_cpumask_var is not cheap.  Does reducing the number of IPIs
> offset the cost of calling into the allocator again? How often does it
> offset the cost and how often does it end up costing more? I guess that
> would heavily depend on the number of CPUs and how many of them have
> pages in their per-cpu buffer. Basically, sometimes we *might* save but
> it comes at a definite cost of calling into the page allocator again.
>

Good point and I totally agree it depends on the number of CPUs.

The thing is, if you are at CPUMASK_OFFSTACK=y, you are saying
that you optimize for the large number of CPU case, otherwise it doesn't
make sense - you can represent 32 CPU in the space it takes to
hold the pointer to the cpumask (on 32bit system) etc.

If you are at CPUMASK_OFFSTACK=n you (almost) didn't pay anything.

The way I see it, the use cases where you end up profiting from the code
are the same places you also pay. Having lots of CPU is what forced you
to use CPUMASK_OFFSTACK and pay that extra allocation but
then it is exactly when you have lots of CPUs that the code pays off.

>
> The patch looks ok functionally but I'm skeptical that it really helps
> performance.


Thanks! it is good to hear it is not completely off the wall :-)

I think of it more of as a CPU isolation feature then pure performance.
If you have a system with a couple of dozens of CPUs (Tilera, SGI, Cavium
or the various virtual NUMA folks) you tend to want to break up the system
into sets of CPUs that work of separate tasks.

It is very annoying when a memory allocation failure in a task allocated to a
small set of 4 CPUs yanks out all the rest of your 4,092 CPUs working on
something completely different out of their cache warm happy existence into
the cache cold reality of an IPI, or worse yet yanks all those CPUs from the
nirvana of idle C-states saving power just to discover that no, they don't
actually have anything to do. :-)

I do believe the overhead for the cases without a lot of CPUs is quite minimal.

Thanks again for taking your time tor review the patch and for reading
this long
response.

> +     } else
> +             on_each_cpu(drain_local_pages, NULL, 1);
>  }
>
>  #ifdef CONFIG_HIBERNATION

I do have a new version of the patch with the logic of building the
cpumask abstracted away to a service
function but otherwise the same. I'll send that out if you figure the
general approach is worth while.

--
Mel Gorman
SUSE Labs



--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
