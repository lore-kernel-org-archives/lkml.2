Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2JRTDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:03:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36991 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2JRTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:03:53 -0400
Date: Thu, 18 Oct 2012 12:03:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Wen Congyang <wency@cn.fujitsu.com>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Jiang Liu <liuj97@gmail.com>, mhocko@suse.cz, bsingharora@gmail.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH] memory cgroup: update root memory cgroup when node is
 onlined
In-Reply-To: <507CF789.6050307@cn.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1210181129180.2137@eggly.anvils>
References: <505187D4.7070404@cn.fujitsu.com> <20120913205935.GK1560@cmpxchg.org> <alpine.LSU.2.00.1209131816070.1908@eggly.anvils> <507CF789.6050307@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Wen Congyang wrote:
> At 09/14/2012 09:36 AM, Hugh Dickins Wrote:
> > 
> > Description to be filled in later: would it be needed for -stable,
> > or is onlining already broken in other ways that you're now fixing up?
> > 
> > Reported-by: Tang Chen <tangchen@cn.fujitsu.com>
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> Hi, all:
> 
> What about the status of this patch?

Sorry I'm being so unresponsive at the moment (or, as usual).

When I sent the fixed version afterwards (minus mistaken VM_BUG_ON,
plus safer mem_cgroup_force_empty_list), I expected you or Konstantin
to respond with a patch to fix it as you preferred (at offline/online);
so this was on hold until we could compare and decide between them.

In the meantime, I assume, we've all come to feel that this way is
simple, and probably the best way for now; or at least good enough,
and we all have better things to do than play with alternatives.

I'll write up the description of the fixed version, and post it for
3.7, including the Acks from Hannes and KAMEZAWA (assuming they carry
forward to the second version) - but probably not today or tomorrow.

But please help me: I still don't know if it's needed for -stable.
We introduced the bug in 3.5, but I see lots of memory hotplug fixes
coming by from you and others, so I do not know if this lruvec->zone
fix is useful by itself in 3.5 and 3.6, or not - please tell me.

Thanks,
Hugh

> 
> Thanks
> Wen Congyang
> 
> > ---
> > 
> >  include/linux/mmzone.h |    2 -
> >  mm/memcontrol.c        |   40 ++++++++++++++++++++++++++++++++-------
> >  mm/mmzone.c            |    6 -----
> >  mm/page_alloc.c        |    2 -
> >  4 files changed, 36 insertions(+), 14 deletions(-)
> > 
> > --- 3.6-rc5/include/linux/mmzone.h	2012-08-03 08:31:26.892842267 -0700
> > +++ linux/include/linux/mmzone.h	2012-09-13 17:07:51.893772372 -0700
> > @@ -744,7 +744,7 @@ extern int init_currently_empty_zone(str
> >  				     unsigned long size,
> >  				     enum memmap_context context);
> >  
> > -extern void lruvec_init(struct lruvec *lruvec, struct zone *zone);
> > +extern void lruvec_init(struct lruvec *lruvec);
> >  
> >  static inline struct zone *lruvec_zone(struct lruvec *lruvec)
> >  {
> > --- 3.6-rc5/mm/memcontrol.c	2012-08-03 08:31:27.060842270 -0700
> > +++ linux/mm/memcontrol.c	2012-09-13 17:46:36.870804625 -0700
> > @@ -1061,12 +1061,25 @@ struct lruvec *mem_cgroup_zone_lruvec(st
> >  				      struct mem_cgroup *memcg)
> >  {
> >  	struct mem_cgroup_per_zone *mz;
> > +	struct lruvec *lruvec;
> >  
> > -	if (mem_cgroup_disabled())
> > -		return &zone->lruvec;
> > +	if (mem_cgroup_disabled()) {
> > +		lruvec = &zone->lruvec;
> > +		goto out;
> > +	}
> >  
> >  	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
> > -	return &mz->lruvec;
> > +	lruvec = &mz->lruvec;
> > +out:
> > +	/*
> > +	 * Since a node can be onlined after the mem_cgroup was created,
> > +	 * we have to be prepared to initialize lruvec->zone here.
> > +	 */
> > +	if (unlikely(lruvec->zone != zone)) {
> > +		VM_BUG_ON(lruvec->zone);
> > +		lruvec->zone = zone;
> > +	}
> > +	return lruvec;
> >  }
> >  
> >  /*
> > @@ -1093,9 +1106,12 @@ struct lruvec *mem_cgroup_page_lruvec(st
> >  	struct mem_cgroup_per_zone *mz;
> >  	struct mem_cgroup *memcg;
> >  	struct page_cgroup *pc;
> > +	struct lruvec *lruvec;
> >  
> > -	if (mem_cgroup_disabled())
> > -		return &zone->lruvec;
> > +	if (mem_cgroup_disabled()) {
> > +		lruvec = &zone->lruvec;
> > +		goto out;
> > +	}
> >  
> >  	pc = lookup_page_cgroup(page);
> >  	memcg = pc->mem_cgroup;
> > @@ -1113,7 +1129,17 @@ struct lruvec *mem_cgroup_page_lruvec(st
> >  		pc->mem_cgroup = memcg = root_mem_cgroup;
> >  
> >  	mz = page_cgroup_zoneinfo(memcg, page);
> > -	return &mz->lruvec;
> > +	lruvec = &mz->lruvec;
> > +out:
> > +	/*
> > +	 * Since a node can be onlined after the mem_cgroup was created,
> > +	 * we have to be prepared to initialize lruvec->zone here.
> > +	 */
> > +	if (unlikely(lruvec->zone != zone)) {
> > +		VM_BUG_ON(lruvec->zone);
> > +		lruvec->zone = zone;
> > +	}
> > +	return lruvec;
> >  }
> >  
> >  /**
> > @@ -4742,7 +4768,7 @@ static int alloc_mem_cgroup_per_zone_inf
> >  
> >  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> >  		mz = &pn->zoneinfo[zone];
> > -		lruvec_init(&mz->lruvec, &NODE_DATA(node)->node_zones[zone]);
> > +		lruvec_init(&mz->lruvec);
> >  		mz->usage_in_excess = 0;
> >  		mz->on_tree = false;
> >  		mz->memcg = memcg;
> > --- 3.6-rc5/mm/mmzone.c	2012-08-03 08:31:27.064842271 -0700
> > +++ linux/mm/mmzone.c	2012-09-13 17:06:28.921766001 -0700
> > @@ -87,7 +87,7 @@ int memmap_valid_within(unsigned long pf
> >  }
> >  #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
> >  
> > -void lruvec_init(struct lruvec *lruvec, struct zone *zone)
> > +void lruvec_init(struct lruvec *lruvec)
> >  {
> >  	enum lru_list lru;
> >  
> > @@ -95,8 +95,4 @@ void lruvec_init(struct lruvec *lruvec,
> >  
> >  	for_each_lru(lru)
> >  		INIT_LIST_HEAD(&lruvec->lists[lru]);
> > -
> > -#ifdef CONFIG_MEMCG
> > -	lruvec->zone = zone;
> > -#endif
> >  }
> > --- 3.6-rc5/mm/page_alloc.c	2012-08-22 14:25:39.508279046 -0700
> > +++ linux/mm/page_alloc.c	2012-09-13 17:06:08.265763526 -0700
> > @@ -4456,7 +4456,7 @@ static void __paginginit free_area_init_
> >  		zone->zone_pgdat = pgdat;
> >  
> >  		zone_pcp_init(zone);
> > -		lruvec_init(&zone->lruvec, zone);
> > +		lruvec_init(&zone->lruvec);
> >  		if (!size)
> >  			continue;
> >  
> > 
> 
> 
