Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1HJXiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:38:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52327 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1HJXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:38:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Aug 2011 08:30:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v5 1/6]  memg: better numa scanning
Message-Id: <20110811083043.a3b2ba65.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110810100042.GA15007@tiehlicka.suse.cz>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809190824.99347a0f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110810100042.GA15007@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 12:00:42 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 09-08-11 19:08:24, KAMEZAWA Hiroyuki wrote:
> > 
> > Making memcg numa's scanning information update by schedule_work().
> > 
> > Now, memcg's numa information is updated under a thread doing
> > memory reclaim. It's not very heavy weight now. But upcoming updates
> > around numa scanning will add more works. This patch makes
> > the update be done by schedule_work() and reduce latency caused
> > by this updates.
> 
> I am not sure whether this pays off. Anyway, I think it would be better
> to place this patch somewhere at the end of the series so that we can
> measure its impact separately.
> 

I'll consider reordering when I come back from vacation.

> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Otherwise looks good to me.
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 

Thanks.

> Just a minor nit bellow.
> 
> > ---
> >  mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++------------
> >  1 file changed, 30 insertions(+), 12 deletions(-)
> > 
> > Index: mmotm-Aug3/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-Aug3.orig/mm/memcontrol.c
> > +++ mmotm-Aug3/mm/memcontrol.c
> > @@ -285,6 +285,7 @@ struct mem_cgroup {
> >  	nodemask_t	scan_nodes;
> >  	atomic_t	numainfo_events;
> >  	atomic_t	numainfo_updating;
> > +	struct work_struct	numainfo_update_work;
> >  #endif
> >  	/*
> >  	 * Should the accounting and control be hierarchical, per subtree?
> > @@ -1567,6 +1568,23 @@ static bool test_mem_cgroup_node_reclaim
> >  }
> >  #if MAX_NUMNODES > 1
> >  
> > +static void mem_cgroup_numainfo_update_work(struct work_struct *work)
> > +{
> > +	struct mem_cgroup *memcg;
> > +	int nid;
> > +
> > +	memcg = container_of(work, struct mem_cgroup, numainfo_update_work);
> > +
> > +	memcg->scan_nodes = node_states[N_HIGH_MEMORY];
> > +	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
> > +		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
> > +			node_clear(nid, memcg->scan_nodes);
> > +	}
> > +	atomic_set(&memcg->numainfo_updating, 0);
> > +	css_put(&memcg->css);
> > +}
> > +
> > +
> >  /*
> >   * Always updating the nodemask is not very good - even if we have an empty
> >   * list or the wrong list here, we can start from some node and traverse all
> > @@ -1575,7 +1593,6 @@ static bool test_mem_cgroup_node_reclaim
> >   */
> 
> Would be good to update the function comment as well (we still have 10s
> period there).
> 

ok.

Thanks,
-Kame


