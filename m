Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1HRAZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:25:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39563 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1HRAZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:25:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 09:17:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v5 4/6]  memg: calculate numa weight for vmscan
Message-Id: <20110818091750.79eea4f5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110817143418.GC7482@tiehlicka.suse.cz>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809191100.6c4c3285.kamezawa.hiroyu@jp.fujitsu.com>
	<20110817143418.GC7482@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 16:34:18 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> Sorry it took so long but I was quite busy recently.
> 
> On Tue 09-08-11 19:11:00, KAMEZAWA Hiroyuki wrote:
> > caclculate node scan weight.
> > 
> > Now, memory cgroup selects a scan target node in round-robin.
> > It's not very good...there is not scheduling based on page usages.
> > 
> > This patch is for calculating each node's weight for scanning.
> > If weight of a node is high, the node is worth to be scanned.
> > 
> > The weight is now calucauted on following concept.
> > 
> >    - make use of swappiness.
> >    - If inactive-file is enough, ignore active-file
> >    - If file is enough (w.r.t swappiness), ignore anon
> >    - make use of recent_scan/rotated reclaim stats.
> 
> The concept looks good (see the specific comments bellow). I would
> appreciate if the description was more descriptive (especially in the
> reclaim statistics part with the reasoning why it is better).
>  
> > Then, a node contains many inactive file pages will be a 1st victim.
> > Node selection logic based on this weight will be in the next patch.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 105 insertions(+), 5 deletions(-)
> > 
> > Index: mmotm-Aug3/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-Aug3.orig/mm/memcontrol.c
> > +++ mmotm-Aug3/mm/memcontrol.c
> [...]
> > @@ -1568,18 +1570,108 @@ static bool test_mem_cgroup_node_reclaim
> >  }
> >  #if MAX_NUMNODES > 1
> >  
> > +static unsigned long
> > +__mem_cgroup_calc_numascan_weight(struct mem_cgroup * memcg,
> > +				int nid,
> > +				unsigned long anon_prio,
> > +				unsigned long file_prio,
> > +				int lru_mask)
> > +{
> > +	u64 file, anon;
> > +	unsigned long weight, mask;
> 
> mask is not used anywhere.
> 
I'll remove this.


> > +	unsigned long rotated[2], scanned[2];
> > +	int zid;
> > +
> > +	scanned[0] = 0;
> > +	scanned[1] = 0;
> > +	rotated[0] = 0;
> > +	rotated[1] = 0;
> > +
> > +	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
> > +		struct mem_cgroup_per_zone *mz;
> > +
> > +		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
> > +		scanned[0] += mz->reclaim_stat.recent_scanned[0];
> > +		scanned[1] += mz->reclaim_stat.recent_scanned[1];
> > +		rotated[0] += mz->reclaim_stat.recent_rotated[0];
> > +		rotated[1] += mz->reclaim_stat.recent_rotated[1];
> > +	}
> > +	file = mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask & LRU_ALL_FILE);
> > +
> > +	if (total_swap_pages)
> 
> What about ((lru_mask & LRU_ALL_ANON) && total_swap_pages)?

Ok. will add that.

> Why should we go down the mem_cgroup_node_nr_lru_pages if are not getting anything?
> 



> > +		anon = mem_cgroup_node_nr_lru_pages(memcg,
> > +					nid, mask & LRU_ALL_ANON);
> 
> btw. s/mask/lru_mask/
> 
yes...

> > +	else
> > +		anon = 0;
> 
> Can be initialized during declaration (makes patch smaller).
> 
Sure.

> > +	if (!(file + anon))
> > +		node_clear(nid, memcg->scan_nodes);
> 
> In that case we can return with 0 right away.
> 
yes.



> > +
> > +	/* 'scanned - rotated/scanned' means ratio of finding not active. */
> > +	anon = anon * (scanned[0] - rotated[0]) / (scanned[0] + 1);
> > +	file = file * (scanned[1] - rotated[1]) / (scanned[1] + 1);
> 
> OK, makes sense. We should not reclaim from nodes that are known to be
> hard to reclaim from. We, however, have to be careful to not exclude the
> node from reclaiming completely.
> 
> > +
> > +	weight = (anon * anon_prio + file * file_prio) / 200;
> 
> Shouldn't we rather normalize the weight to the node size? This way we
> are punishing bigger nodes, aren't we.
> 

Here, the routine is for reclaiming memory in a memcg in smooth way.
And not for balancing zone. It will be kswapd+memcg(softlimit) work.
The size of node in this memcg is represented by file + anon.


> > +	return weight;
> > +}
> > +
> > +/*
> > + * Calculate each NUMA node's scan weight. scan weight is determined by
> > + * amount of pages and recent scan ratio, swappiness.
> > + */
> > +static unsigned long
> > +mem_cgroup_calc_numascan_weight(struct mem_cgroup *memcg)
> > +{
> > +	unsigned long weight, total_weight;
> > +	u64 anon_prio, file_prio, nr_anon, nr_file;
> > +	int lru_mask;
> > +	int nid;
> > +
> > +	anon_prio = mem_cgroup_swappiness(memcg) + 1;
> > +	file_prio = 200 - anon_prio + 1;
> 
> What is +1 good for. I do not see that anon_prio would be used as a
> denominator.
> 

weight = (anon * anon_prio + file * file_prio) / 200;

Just for avoiding the influence of anon never be 0 (by wrong value
set to swappiness by user.)


> > +
> > +	lru_mask = BIT(LRU_INACTIVE_FILE);
> > +	if (mem_cgroup_inactive_file_is_low(memcg))
> > +		lru_mask |= BIT(LRU_ACTIVE_FILE);
> > +	/*
> > +	 * In vmscan.c, we'll scan anonymous pages with regard to memcg/zone's
> > +	 * amounts of file/anon pages and swappiness and reclaim_stat. Here,
> > +	 * we try to find good node to be scanned. If the memcg contains enough
> > +	 * file caches, we'll ignore anon's weight.
> > +	 * (Note) scanning anon-only node tends to be waste of time.
> > +	 */
> > +
> > +	nr_file = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
> > +	nr_anon = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
> > +
> > +	/* If file cache is small w.r.t swappiness, check anon page's weight */
> > +	if (nr_file * file_prio >= nr_anon * anon_prio)
> > +		lru_mask |= BIT(LRU_INACTIVE_ANON);
> 
> Why we do not care about active anon (e.g. if inactive anon is low)?
> 
This condition is wrong...

	if (nr_file * file_prio <= nr_anon * anon_prio)
		lru_mask |= BIT(LRU_INACTIVE_ANON);

I was worried about LRU_ACTIVE_ANON. I considered
  - We can't handle ACTIVE_ANON and INACTIVE_ANON in the same weight.
    But I don't want to add more magic numbers.
  - vmscan.c:shrink_zone() scans ACTIVE_ANON whenever/only when
    inactive_anon_is_low()==true. SWAP_CLUSTER_MAX per priority.
    It's specially handled.

So, I thought involing the number of ACTIVE_ANON to the weight is difficult
and ignored ACTIVE_ANON, here. Do you have idea ?



> > +
> > +	total_weight = 0;
> 
> Can be initialized during declaration.
> 

will fix.

Thanks,
-Kame

