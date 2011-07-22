Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1GVKXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:23:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab1GVKXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:23:35 -0400
Date: Fri, 22 Jul 2011 12:23:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: do not try to drain per-cpu caches without
 pages
Message-ID: <20110722102331.GG4004@tiehlicka.suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
 <113c4affc2f0938b7b22d43c88d2b0a623de9a6b.1311241300.git.mhocko@suse.cz>
 <20110721191250.1c945740.kamezawa.hiroyu@jp.fujitsu.com>
 <20110721113606.GA27855@tiehlicka.suse.cz>
 <20110722084413.9dd4b880.kamezawa.hiroyu@jp.fujitsu.com>
 <20110722091936.GB4004@tiehlicka.suse.cz>
 <20110722182822.a99a2676.kamezawa.hiroyu@jp.fujitsu.com>
 <20110722095815.GF4004@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722095815.GF4004@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-07-11 11:58:15, Michal Hocko wrote:
> On Fri 22-07-11 18:28:22, KAMEZAWA Hiroyuki wrote:
> > On Fri, 22 Jul 2011 11:19:36 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Fri 22-07-11 08:44:13, KAMEZAWA Hiroyuki wrote:
> > > > On Thu, 21 Jul 2011 13:36:06 +0200
> > > > By 2 methods
> > > > 
> > > >  - just check nr_pages. 
> > > 
> > > Not sure I understand which nr_pages you mean. The one that comes from
> > > the charging path or stock->nr_pages?
> > > If you mean the first one then we do not have in the reclaim path where
> > > we call drain_all_stock_async.
> > > 
> > 
> > stock->nr_pages.
> > 
> > > >  - drain "local stock" without calling schedule_work(). It's fast.
> > > 
> > > but there is nothing to be drained locally in the paths where we call
> > > drain_all_stock_async... Or do you mean that drain_all_stock shouldn't
> > > use work queue at all?
> > 
> > I mean calling schedule_work against local cpu is just waste of time.
> > Then, drain it directly and move local cpu's stock->nr_pages to res_counter.
> 
> got it. Thanks for clarification. Will repost the updated version.
---
>From 2f17df54db6661c39a05669d08a9e6257435b898 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 21 Jul 2011 09:38:00 +0200
Subject: [PATCH] memcg: do not try to drain per-cpu caches without pages

drain_all_stock_async tries to optimize a work to be done on the work
queue by excluding any work for the current CPU because it assumes that
the context we are called from already tried to charge from that cache
and it's failed so it must be empty already.
While the assumption is correct we can optimize it even more by checking
the current number of pages in the cache. This will also reduce a work
on other CPUs with an empty stock.
For the current CPU we can simply call drain_local_stock rather than
deferring it to the work queue.

[KAMEZAWA Hiroyuki - use drain_local_stock for current CPU optimization]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f11f198..c012ffe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2159,11 +2159,8 @@ static void drain_all_stock_async(struct mem_cgroup *root_mem)
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *mem;
 
-		if (cpu == curcpu)
-			continue;
-
 		mem = stock->cached;
-		if (!mem)
+		if (!mem || !stock->nr_pages)
 			continue;
 		if (mem != root_mem) {
 			if (!root_mem->use_hierarchy)
@@ -2172,8 +2169,12 @@ static void drain_all_stock_async(struct mem_cgroup *root_mem)
 			if (!css_is_ancestor(&mem->css, &root_mem->css))
 				continue;
 		}
-		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
-			schedule_work_on(cpu, &stock->work);
+		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
+			if (cpu == curcpu)
+				drain_local_stock(&stock->work);
+			else
+				schedule_work_on(cpu, &stock->work);
+		}
 	}
  	put_online_cpus();
 	mutex_unlock(&percpu_charge_mutex);
-- 
1.7.5.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
