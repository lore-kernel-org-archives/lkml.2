Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2AHQB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:01:57 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63423 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2AHQBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:01:55 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <20120105155445.GC27881@csn.ul.ie>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
	<1325499859-2262-8-git-send-email-gilad@benyossef.com>
	<20120105155445.GC27881@csn.ul.ie>
Date: Sun, 8 Jan 2012 18:01:54 +0200
Message-ID: <CAOtvUMezyvi1icpxo6YC5apJU-LZ5ns-RSeaL1q3CYw34AULFQ@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 5:54 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>
> On Mon, Jan 02, 2012 at 12:24:18PM +0200, Gilad Ben-Yossef wrote:


>
> > Tested by running "hackbench 400" on a 4 CPU x86 otherwise
> > idle VM and observing the difference between the number
> > of direct reclaim attempts that end up in drain_all_pages()
> > and those were more then 1/2 of the online CPU had any
> > per-cpu page in them, using the vmstat counters introduced
> > in the next patch in the series and using proc/interrupts.
> >
> > In the test sceanrio, this saved around 500 global IPIs.
> > After trigerring an OOM:
> >
> > $ cat /proc/vmstat
> > ...
> > pcp_global_drain 627
> > pcp_global_ipi_saved 578
> >
>
> This isn't 99% savings as you claim earlier but they are still great.
>

You are right of course, more like 92%. I did  see test runs where the %
was 99% (which is were the 99% number came from) .I never saw it drop
below 90% for the specified  test load.

I modified the description to read 90%+. I guess that is good enough.

> Thanks for doing the stats. Just to be clear, I didn't expect these
> stats to be merged, nor do I want them to. I wanted to be sure the patch
> was really behaving as advertised.
>
> Acked-by: Mel Gorman <mgorman@suse.de>
>
Of course, my pleasure and thanks for the review.
>
>
> > +     for_each_online_cpu(cpu)
> > +             for_each_populated_zone(zone) {
> > +                     pcp = per_cpu_ptr(zone->pageset, cpu);
> > +                     if (pcp->pcp.count)
> > +                             cpumask_set_cpu(cpu, cpus_with_pcps);
> > +                     else
> > +                             cpumask_clear_cpu(cpu, cpus_with_pcps);
> > +             }
> > +     on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
>
> As a heads-up, I'm looking at a candidate CPU hotplug patch that almost
> certainly will collide with this patch. If/when I get it fixed, I'll be
> sure to CC you so we can figure out what order the patches need to go
> in. Ordinarily it wouldn't matter but if this really is a CPU hotplug
> fix, it might also be a -stable candidate so it would need to go in
> before your patches.


No problem. I'm sending v6 right now because of unrelated changes Andrew M.
asked for. I'll be happy to re-base on top of CPU hotplug fixes later.

Thanks,
Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
