Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab0KPHrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:47:21 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:44004 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758980Ab0KPHrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:47:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADrG4Ux5Ldur/2dsb2JhbACiWnK+ZoVLBA
Date: Tue, 16 Nov 2010 18:47:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Message-ID: <20101116074717.GB3460@amd>
References: <20101109123246.GA11477@amd>
 <20101114182614.BEE5.A69D9226@jp.fujitsu.com>
 <20101115092452.BEF1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115092452.BEF1.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:50:36AM +0900, KOSAKI Motohiro wrote:
> > > @@ -1835,8 +1978,6 @@ static void shrink_zone(int priority, st
> > >  			break;
> > >  	}
> > >  
> > > -	sc->nr_reclaimed = nr_reclaimed;
> > > -
> > >  	/*
> > >  	 * Even if we did not try to evict anon pages at all, we want to
> > >  	 * rebalance the anon lru active/inactive ratio.
> > > @@ -1844,6 +1985,23 @@ static void shrink_zone(int priority, st
> > >  	if (inactive_anon_is_low(zone, sc))
> > >  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> > >  
> > > +	/*
> > > +	 * Don't shrink slabs when reclaiming memory from
> > > +	 * over limit cgroups
> > > +	 */
> > > +	if (sc->may_reclaim_slab) {
> > > +		struct reclaim_state *reclaim_state = current->reclaim_state;
> > > +
> > > +		shrink_slab(zone, sc->nr_scanned - nr_scanned,
> > 
> > Doubtful calculation. What mean "sc->nr_scanned - nr_scanned"?
> > I think nr_scanned simply keep old slab balancing behavior.
> 
> And per-zone reclaim can lead to new issue. On 32bit highmem system,
> theorically the system has following memory usage.
> 
> ZONE_HIGHMEM: 100% used for page cache
> ZONE_NORMAL:  100% used for slab
> 
> So, traditional page-cache/slab balancing may not work. I think following

Yes, in theory you are right. I guess in theory the same hole exists
if we have 0% page cache reclaimable globally, but this may be slightly
more likely to hit.


> new calculation or somethinhg else is necessary.
> 
> 	if (zone_reclaimable_pages() > NR_SLAB_RECLAIMABLE) {
> 		using current calculation
> 	} else {
> 		shrink number of "objects >> reclaim-priority" objects
> 		(as page cache scanning calculation)
> 	}
> 
> However, it can be separate this patch, perhaps.

I agree. In fact, perhaps the new calculation would work well in all
cases anyway, so maybe we should move away from making slab reclaim a
slave to pagecache reclaim.

Can we approach that in subsequent patches?

Thanks,
Nick

