Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0IAHdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:33:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39842 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0IAHdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:33:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100901072402.GE13677@csn.ul.ie>
References: <20100901083425.971F.A69D9226@jp.fujitsu.com> <20100901072402.GE13677@csn.ul.ie>
Message-Id: <20100901163146.9755.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Sep 2010 16:33:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 01, 2010 at 08:37:41AM +0900, KOSAKI Motohiro wrote:
> > > +#ifdef CONFIG_SMP
> > > +/* Called when a more accurate view of NR_FREE_PAGES is needed */
> > > +unsigned long zone_nr_free_pages(struct zone *zone)
> > > +{
> > > +	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
> > > +
> > > +	/*
> > > +	 * While kswapd is awake, it is considered the zone is under some
> > > +	 * memory pressure. Under pressure, there is a risk that
> > > +	 * per-cpu-counter-drift will allow the min watermark to be breached
> > > +	 * potentially causing a live-lock. While kswapd is awake and
> > > +	 * free pages are low, get a better estimate for free pages
> > > +	 */
> > > +	if (nr_free_pages < zone->percpu_drift_mark &&
> > > +			!waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> > > +		int cpu;
> > > +
> > > +		for_each_online_cpu(cpu) {
> > > +			struct per_cpu_pageset *pset;
> > > +
> > > +			pset = per_cpu_ptr(zone->pageset, cpu);
> > > +			nr_free_pages += pset->vm_stat_diff[NR_FREE_PAGES];
> > 
> > If my understanding is correct, we have no lock when reading pset->vm_stat_diff.
> > It mean nr_free_pages can reach negative value at very rarely race. boundary
> > check is necessary?
> > 
> 
> True, well spotted.
> 
> How about the following? It records a delta and checks if delta is negative
> and would cause underflow.
> 
> unsigned long zone_nr_free_pages(struct zone *zone)
> {
>         unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
>         long delta = 0;
> 
>         /*
>          * While kswapd is awake, it is considered the zone is under some
>          * memory pressure. Under pressure, there is a risk that
>          * per-cpu-counter-drift will allow the min watermark to be breached
>          * potentially causing a live-lock. While kswapd is awake and
>          * free pages are low, get a better estimate for free pages
>          */
>         if (nr_free_pages < zone->percpu_drift_mark &&
>                         !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
>                 int cpu;
> 
>                 for_each_online_cpu(cpu) {
>                         struct per_cpu_pageset *pset;
> 
>                         pset = per_cpu_ptr(zone->pageset, cpu);
>                         delta += pset->vm_stat_diff[NR_FREE_PAGES];
>                 }
>         }
> 
>         /* Watch for underflow */
>         if (delta < 0 && abs(delta) > nr_free_pages)
>                 delta = -nr_free_pages;
> 
>         return nr_free_pages + delta;
> }

Looks good to me :)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks.




