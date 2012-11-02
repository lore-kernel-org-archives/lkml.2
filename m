Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab2KBXhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:37:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45032 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301Ab2KBXhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:37:35 -0400
Date: Fri, 2 Nov 2012 16:37:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wen Congyang <wency@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Jiang Liu <liuj97@gmail.com>, bsingharora@gmail.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        paul.gortmaker@windriver.com, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH] memcg: fix hotplugged memory zone oops
In-Reply-To: <20121102105420.GB24073@dhcp22.suse.cz>
Message-ID: <alpine.LNX.2.00.1211021631260.11106@eggly.anvils>
References: <505187D4.7070404@cn.fujitsu.com> <20120913205935.GK1560@cmpxchg.org> <alpine.LSU.2.00.1209131816070.1908@eggly.anvils> <507CF789.6050307@cn.fujitsu.com> <alpine.LSU.2.00.1210181129180.2137@eggly.anvils> <20121018220306.GA1739@cmpxchg.org>
 <alpine.LNX.2.00.1211011822190.20048@eggly.anvils> <20121102102159.GA24073@dhcp22.suse.cz> <20121102105420.GB24073@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Michal Hocko wrote:
> On Fri 02-11-12 11:21:59, Michal Hocko wrote:
> > On Thu 01-11-12 18:28:02, Hugh Dickins wrote:
> [...]
> 
> And I forgot to mention that the following hunk will clash with
> "memcg: Simplify mem_cgroup_force_empty_list error handling" which is in
> linux-next already (via Tejun's tree). 

Oh, via Tejun's tree.  Right, when I checked mmotm there was no problem.

> Would it be easier to split the patch into the real fix and the hunk
> bellow? That one doesn't have to go into stable anyway and we would save
> some merging conflicts. The updated fix on top of -mm tree is bellow for
> your convinience.

I'd prefer to leave it as one patch, so even the "future proof" part
of the fix goes into 3.7 and stable.  But your point is that you have
already seen the future, and it forks in a slightly different direction!

Well, I don't want to be obstructive, but it doesn't look difficult
to resolve.  Perhaps if I hold off on splitting them, and see if akpm
barks at me or not :)

Hugh

> > >  /**
> > > @@ -3688,17 +3712,17 @@ unsigned long mem_cgroup_soft_limit_recl
> > >  static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
> > >  				int node, int zid, enum lru_list lru)
> > >  {
> > > -	struct mem_cgroup_per_zone *mz;
> > > +	struct lruvec *lruvec;
> > >  	unsigned long flags, loop;
> > >  	struct list_head *list;
> > >  	struct page *busy;
> > >  	struct zone *zone;
> > >  
> > >  	zone = &NODE_DATA(node)->node_zones[zid];
> > > -	mz = mem_cgroup_zoneinfo(memcg, node, zid);
> > > -	list = &mz->lruvec.lists[lru];
> > > +	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> > > +	list = &lruvec->lists[lru];
> > >  
> > > -	loop = mz->lru_size[lru];
> > > +	loop = mem_cgroup_get_lru_size(lruvec, lru);
> > >  	/* give some margin against EBUSY etc...*/
> > >  	loop += 256;
> > >  	busy = NULL;
