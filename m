Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab0KWHV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:21:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49779 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0KWHV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:21:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20101116074717.GB3460@amd>
References: <20101115092452.BEF1.A69D9226@jp.fujitsu.com> <20101116074717.GB3460@amd>
Message-Id: <20101123162027.7BB0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:21:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the delay. Recently I have no time at all ;)


> On Mon, Nov 15, 2010 at 09:50:36AM +0900, KOSAKI Motohiro wrote:
> > > > @@ -1835,8 +1978,6 @@ static void shrink_zone(int priority, st
> > > >  			break;
> > > >  	}
> > > >  
> > > > -	sc->nr_reclaimed = nr_reclaimed;
> > > > -
> > > >  	/*
> > > >  	 * Even if we did not try to evict anon pages at all, we want to
> > > >  	 * rebalance the anon lru active/inactive ratio.
> > > > @@ -1844,6 +1985,23 @@ static void shrink_zone(int priority, st
> > > >  	if (inactive_anon_is_low(zone, sc))
> > > >  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> > > >  
> > > > +	/*
> > > > +	 * Don't shrink slabs when reclaiming memory from
> > > > +	 * over limit cgroups
> > > > +	 */
> > > > +	if (sc->may_reclaim_slab) {
> > > > +		struct reclaim_state *reclaim_state = current->reclaim_state;
> > > > +
> > > > +		shrink_slab(zone, sc->nr_scanned - nr_scanned,
> > > 
> > > Doubtful calculation. What mean "sc->nr_scanned - nr_scanned"?
> > > I think nr_scanned simply keep old slab balancing behavior.
> > 
> > And per-zone reclaim can lead to new issue. On 32bit highmem system,
> > theorically the system has following memory usage.
> > 
> > ZONE_HIGHMEM: 100% used for page cache
> > ZONE_NORMAL:  100% used for slab
> > 
> > So, traditional page-cache/slab balancing may not work. I think following
> 
> Yes, in theory you are right. I guess in theory the same hole exists
> if we have 0% page cache reclaimable globally, but this may be slightly
> more likely to hit.

I'm not worry about so much "0% page cache reclaimable globally" case
because I doubt it can be happen in real.


> > new calculation or somethinhg else is necessary.
> > 
> > 	if (zone_reclaimable_pages() > NR_SLAB_RECLAIMABLE) {
> > 		using current calculation
> > 	} else {
> > 		shrink number of "objects >> reclaim-priority" objects
> > 		(as page cache scanning calculation)
> > 	}
> > 
> > However, it can be separate this patch, perhaps.
> 
> I agree. In fact, perhaps the new calculation would work well in all
> cases anyway, so maybe we should move away from making slab reclaim a
> slave to pagecache reclaim.
> 
> Can we approach that in subsequent patches?

OK!



