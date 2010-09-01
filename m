Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0IAUei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:34:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43606 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0IAUeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:34:37 -0400
Date: Wed, 1 Sep 2010 21:34:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
	NR_FREE_PAGES when memory is low and kswapd is awake
Message-ID: <20100901203422.GA19519@csn.ul.ie>
References: <20100901083425.971F.A69D9226@jp.fujitsu.com> <20100901072402.GE13677@csn.ul.ie> <20100901163146.9755.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009011512190.16322@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009011512190.16322@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 03:16:59PM -0500, Christoph Lameter wrote:
> On Wed, 1 Sep 2010, KOSAKI Motohiro wrote:
> 
> > > How about the following? It records a delta and checks if delta is negative
> > > and would cause underflow.
> > >
> > > unsigned long zone_nr_free_pages(struct zone *zone)
> > > {
> > >         unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
> > >         long delta = 0;
> > >
> > >         /*
> > >          * While kswapd is awake, it is considered the zone is under some
> > >          * memory pressure. Under pressure, there is a risk that
> > >          * per-cpu-counter-drift will allow the min watermark to be breached
> > >          * potentially causing a live-lock. While kswapd is awake and
> > >          * free pages are low, get a better estimate for free pages
> > >          */
> > >         if (nr_free_pages < zone->percpu_drift_mark &&
> > >                         !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> > >                 int cpu;
> > >
> > >                 for_each_online_cpu(cpu) {
> > >                         struct per_cpu_pageset *pset;
> > >
> > >                         pset = per_cpu_ptr(zone->pageset, cpu);
> > >                         delta += pset->vm_stat_diff[NR_FREE_PAGES];
> > >                 }
> > >         }
> > >
> > >         /* Watch for underflow */
> > >         if (delta < 0 && abs(delta) > nr_free_pages)
> > >                 delta = -nr_free_pages;
> 
> Not sure what the point here is. If the delta is going below zero then
> there was a concurrent operation updating the counters negatively while
> we summed up the counters.

The point is if the negative delta is greater than the current value of
nr_free_pages then nr_free_pages would underflow when delta is applied to it.

> It is then safe to assume a value of zero. We
> cannot really be more accurate than that.
> 
> so
> 
> 	if (delta < 0)
> 		delta = 0;
> 
> would be correct.

Lets say the reading at the start for nr_free_pages is 120 and the delta is
-20, then the estimated true value of nr_free_pages is 100. If we used your
logic, the estimate would be 120. Maybe I'm missing what you're saying.

> See also handling of counter underflow in
> vmstat.h:zone_page_state().

I'm not seeing the relation. zone_nr_free_pages() is trying to
reconcile the reading from zone_page_state() with the contents of
vm_stat_diff[].

> As I have said before: I would rather have the
> counter handling in one place to avoid creating differences in counter
> handling.
> 

And I'd rather not hurt the paths for every counter unnecessarily
without good cause. I can move zone_nr_free_pages() to mm/vmstat.c if
you'd prefer?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
