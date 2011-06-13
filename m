Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1FMLTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:19:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab1FMLTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:19:04 -0400
Date: Mon, 13 Jun 2011 13:18:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] vmscan: memcg-aware unevictable page rescue scanner
Message-ID: <20110613111857.GE10563@tiehlicka.suse.cz>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
 <20110613094203.GC10563@tiehlicka.suse.cz>
 <20110613103032.GA12143@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613103032.GA12143@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13-06-11 12:30:32, Johannes Weiner wrote:
> On Mon, Jun 13, 2011 at 11:42:03AM +0200, Michal Hocko wrote:
> > On Wed 01-06-11 08:25:18, Johannes Weiner wrote:
> > > Once the per-memcg lru lists are exclusive, the unevictable page
> > > rescue scanner can no longer work on the global zone lru lists.
> > > 
> > > This converts it to go through all memcgs and scan their respective
> > > unevictable lists instead.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > Just a minor naming thing.
> > 
> > Other than that looks good to me.
> > Reviewed-by: Michal Hocko <mhocko@suse.cz>
> > 
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > [...]
> > > +struct page *mem_cgroup_lru_to_page(struct zone *zone, struct mem_cgroup *mem,
> > > +				    enum lru_list lru)
> > > +{
> > > +	struct mem_cgroup_per_zone *mz;
> > > +	struct page_cgroup *pc;
> > > +
> > > +	mz = mem_cgroup_zoneinfo(mem, zone_to_nid(zone), zone_idx(zone));
> > > +	pc = list_entry(mz->lists[lru].prev, struct page_cgroup, lru);
> > > +	return lookup_cgroup_page(pc);
> > > +}
> > > +
> > [...]
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3233,6 +3233,14 @@ void scan_mapping_unevictable_pages(struct address_space *mapping)
> > >  
> > >  }
> > >  
> > > +static struct page *lru_tailpage(struct zone *zone, struct mem_cgroup *mem,
> > > +				 enum lru_list lru)
> > > +{
> > > +	if (mem)
> > > +		return mem_cgroup_lru_to_page(zone, mem, lru);
> > > +	return lru_to_page(&zone->lru[lru].list);
> > > +}
> > 
> > Wouldn't it better to have those names consistent?
> > mem_cgroup_lru_tailpage vs lru_tailpage?
> 
> It's bad naming alright, but what is the wrapper for both of them
> supposed to be called then?
> 
> Note that this function is only temporary, though, that's why I did
> not spent much time on looking for a better name.
> 
> When the per-memcg lru lists finally become exclusive, this is removed
> and the function converted to work on lruvecs.
> 
> Would you be okay with just adding an /* XXX */ to the function in
> this patch that mentions that it's only temporary?

Sure. No biggie about the naming. It just hit my eyes during reading the
patch because while lru_tailpage is clear about which end of the list is
returned the memcg counterpart is not that clear.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
