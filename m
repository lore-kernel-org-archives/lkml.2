Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1L3UQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 15:16:43 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64780 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1L3UQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 15:16:41 -0500
MIME-Version: 1.0
X-Originating-IP: [89.138.6.173]
In-Reply-To: <20111230150421.GE15729@suse.de>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<1321960128-15191-6-git-send-email-gilad@benyossef.com>
	<20111223102810.GT3487@suse.de>
	<CAOtvUMd6+ZZVLp-FbbEwbq3UZLRvSRo+_MMYj1aCGT3gBhxMwg@mail.gmail.com>
	<20111230150421.GE15729@suse.de>
Date: Fri, 30 Dec 2011 22:16:40 +0200
Message-ID: <CAOtvUMdRa74aLUufHUSowzvk2mZEGTVT+jXm_vp3OSBLipzW-g@mail.gmail.com>
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

On Fri, Dec 30, 2011 at 5:04 PM, Mel Gorman <mgorman@suse.de> wrote:
>
> On Sun, Dec 25, 2011 at 11:39:59AM +0200, Gilad Ben-Yossef wrote:
>
>
>
> CONFIG_CPUMASK_OFFSTACK is force enabled if CONFIG_MAXSMP on x86. This
> may be the case for some server-orientated distributions. I know
> SLES enables this option for x86-64 at least. Debian does not but
> might in the future. I don't know about RHEL but it should be checked.
> Either way, we cannot depend on CONFIG_CPUMASK_OFFSTACK being disabled
> (it's enabled on my laptop for example due to the .config it is based
> on). That said, breaking the link between MAXSMP and OFFSTACK may be
> an option.
>

Yes, I know and it is enabled for RHEL as well, I believe.
The point is, MAXSMP is enabled in the enterprise distribution in
order to support
the massively multi-core systems. Reducing cross CPU interference is important
to these very systems.

In fact, since CONFIG_CPUMASK_OFFSTACK has a price on its own, the fact
that distros enable it (via MAXSMP) is proof in my eyes that the distros find
massively multi-core systems important :-)

That being said, the patch only has value if it actually reduces cross
CPU IPI and
does not incur a bigger price, otherwise of course it should be dropped.


>
> > For CONFIG_CPUMASK_OFFSTACK=y but when we got to drain_all_pages from
> > the memory
> > hotplug or the memory failure code path (the code other code path that
> > call drain_all_pages),
> > there is  no inherent memory pressure, so we should be OK.
> >
>
> It's the memory failure code path after direct reclaim failed. How
> can you say there is no inherent memory pressure?
>
Bah.. you are right. Memory allocation will cause memory migration to
the remaining active memory areas, so yes, it's a memory pressure.
Point taken. My bad.

>
> > The thing is, if you are at CPUMASK_OFFSTACK=y, you are saying
> > that you optimize for the large number of CPU case, otherwise it doesn't
> > make sense - you can represent 32 CPU in the space it takes to
> > hold the pointer to the cpumask (on 32bit system) etc.
> >
> > If you are at CPUMASK_OFFSTACK=n you (almost) didn't pay anything.
> >
> <snip>


>
> It's the CPUMASK_OFFSTACK=y case I worry about as it is enabled on
> at least one server-orientated distribution and probably more.
>
Sure, because they care about performance (or even just plain working) on
massively multi-core systems. Something this patch set aims to get to work
better.



>
> > I think of it more of as a CPU isolation feature then pure performance.
> > If you have a system with a couple of dozens of CPUs (Tilera, SGI, Cavium
> > or the various virtual NUMA folks) you tend to want to break up the system
> > into sets of CPUs that work of separate tasks.
> >
>
> Even with the CPUs isolated, how often is it the case that many of
> the CPUs have 0 pages on their per-cpu lists? I checked a bunch of
> random machines just there and in every case all CPUs had at least
> one page on their per-cpu list. In other words I believe that in
> many cases the exact same number of IPIs will be used but with the
> additional cost of allocating a cpumask.
>

A common usage scenario with systems with lots of cores is to isolate
a group of cores to run a (almost) totally CPU bound task to each CPU
of the set. Those tasks rarely call into the kernel, they just crunch numbers
and they end up have 0 per-cpu set more often then you think.

But you are right that it is a specific use case. The question is what is the
cost in other use cases.

>
> <snip>


>
> I'm still generally uncomfortable with the allocator allocating memory
> while it is known memory is tight.
>

Got you.

>
> As a way of mitigating that, I would suggest this is done in two
> passes. The first would check if at least 50% of the CPUs have no pages
> on their per-cpu list. Then and only then allocate the per-cpu mask to
> limit the IPIs. Use a separate patch that counts in /proc/vmstat how
> many times the per-cpu mask was allocated as an approximate measure of
> how often this logic really reduces the number of IPI calls in practice
> and report that number with the patch - i.e. this patch reduces the
> number of times IPIs are globally transmitted by X% for some workload.
>
Great idea. I like it - and I guess the 50% could be configurable.
Will do and report.

Gilad
>
> --


>
> Mel Gorman
> SUSE Labs




--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
