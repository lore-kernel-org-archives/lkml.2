Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0KOAur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:50:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57643 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab0KOAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:50:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20101114182614.BEE5.A69D9226@jp.fujitsu.com>
References: <20101109123246.GA11477@amd> <20101114182614.BEE5.A69D9226@jp.fujitsu.com>
Message-Id: <20101115092452.BEF1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 09:50:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1835,8 +1978,6 @@ static void shrink_zone(int priority, st
> >  			break;
> >  	}
> >  
> > -	sc->nr_reclaimed = nr_reclaimed;
> > -
> >  	/*
> >  	 * Even if we did not try to evict anon pages at all, we want to
> >  	 * rebalance the anon lru active/inactive ratio.
> > @@ -1844,6 +1985,23 @@ static void shrink_zone(int priority, st
> >  	if (inactive_anon_is_low(zone, sc))
> >  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> >  
> > +	/*
> > +	 * Don't shrink slabs when reclaiming memory from
> > +	 * over limit cgroups
> > +	 */
> > +	if (sc->may_reclaim_slab) {
> > +		struct reclaim_state *reclaim_state = current->reclaim_state;
> > +
> > +		shrink_slab(zone, sc->nr_scanned - nr_scanned,
> 
> Doubtful calculation. What mean "sc->nr_scanned - nr_scanned"?
> I think nr_scanned simply keep old slab balancing behavior.

And per-zone reclaim can lead to new issue. On 32bit highmem system,
theorically the system has following memory usage.

ZONE_HIGHMEM: 100% used for page cache
ZONE_NORMAL:  100% used for slab

So, traditional page-cache/slab balancing may not work. I think following
new calculation or somethinhg else is necessary.

	if (zone_reclaimable_pages() > NR_SLAB_RECLAIMABLE) {
		using current calculation
	} else {
		shrink number of "objects >> reclaim-priority" objects
		(as page cache scanning calculation)
	}

However, it can be separate this patch, perhaps.



> 
> 
> > +			lru_pages, global_lru_pages, sc->gfp_mask);
> > +		if (reclaim_state) {
> > +			nr_reclaimed += reclaim_state->reclaimed_slab;
> > +			reclaim_state->reclaimed_slab = 0;
> > +		}
> > +	}
> > +
> > +	sc->nr_reclaimed = nr_reclaimed;
> > +
> >  	throttle_vm_writeout(sc->gfp_mask);
> >  }


