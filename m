Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1HJXu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:50:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59920 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1HJXuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:50:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Aug 2011 08:43:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v5 3/6]  memg: vmscan pass nodemask
Message-Id: <20110811084304.12d8da03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110810111958.GB15007@tiehlicka.suse.cz>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809191018.af81c55d.kamezawa.hiroyu@jp.fujitsu.com>
	<20110810111958.GB15007@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 13:19:58 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 09-08-11 19:10:18, KAMEZAWA Hiroyuki wrote:
> > 
> > pass memcg's nodemask to try_to_free_pages().
> > 
> > try_to_free_pages can take nodemask as its argument but memcg
> > doesn't pass it. Considering memcg can be used with cpuset on
> > big NUMA, memcg should pass nodemask if available.
> > 
> > Now, memcg maintain nodemask with periodic updates. pass it.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Changelog:
> >  - fixed bugs to pass nodemask.
> 
> Yes, looks good now.
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 
Thanks.

> > Index: mmotm-Aug3/mm/vmscan.c
> > ===================================================================
> > --- mmotm-Aug3.orig/mm/vmscan.c
> > +++ mmotm-Aug3/mm/vmscan.c
> > @@ -2354,7 +2354,7 @@ unsigned long try_to_free_mem_cgroup_pag
> >  		.order = 0,
> >  		.mem_cgroup = mem_cont,
> >  		.memcg_record = rec,
> > -		.nodemask = NULL, /* we don't care the placement */
> > +		.nodemask = NULL,
> >  		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> >  				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
> >  	};
> 
> We can remove the whole nodemask initialization.
> 

Ok, here
==

pass memcg's nodemask to try_to_free_pages().

try_to_free_pages can take nodemask as its argument but memcg
doesn't pass it. Considering memcg can be used with cpuset on
big NUMA, memcg should pass nodemask if available.

Now, memcg maintain nodemask with periodic updates. pass it.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Changelog:
 - removed unnecessary initialization of sc.nodemask.
Changelog:
 - fixed bugs to pass nodemask.
---
 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    8 ++++++--
 mm/vmscan.c                |    3 +--
 3 files changed, 8 insertions(+), 5 deletions(-)

Index: mmotm-Aug3/include/linux/memcontrol.h
===================================================================
--- mmotm-Aug3.orig/include/linux/memcontrol.h
+++ mmotm-Aug3/include/linux/memcontrol.h
@@ -118,7 +118,7 @@ extern void mem_cgroup_end_migration(str
  */
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
-int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
+int mem_cgroup_select_victim_node(struct mem_cgroup *memcg, nodemask_t **mask);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 					int nid, int zid, unsigned int lrumask);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
Index: mmotm-Aug3/mm/memcontrol.c
===================================================================
--- mmotm-Aug3.orig/mm/memcontrol.c
+++ mmotm-Aug3/mm/memcontrol.c
@@ -1615,10 +1615,11 @@ static void mem_cgroup_may_update_nodema
  *
  * Now, we use round-robin. Better algorithm is welcomed.
  */
-int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem, nodemask_t **mask)
 {
 	int node;
 
+	*mask = NULL;
 	mem_cgroup_may_update_nodemask(mem);
 	node = mem->last_scanned_node;
 
@@ -1633,6 +1634,8 @@ int mem_cgroup_select_victim_node(struct
 	 */
 	if (unlikely(node == MAX_NUMNODES))
 		node = numa_node_id();
+	else
+		*mask = &mem->scan_nodes;
 
 	mem->last_scanned_node = node;
 	return node;
@@ -1680,8 +1683,9 @@ static void mem_cgroup_numascan_init(str
 }
 
 #else
-int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem, nodemask_t **mask)
 {
+	*mask = NULL;
 	return 0;
 }
 
Index: mmotm-Aug3/mm/vmscan.c
===================================================================
--- mmotm-Aug3.orig/mm/vmscan.c
+++ mmotm-Aug3/mm/vmscan.c
@@ -2354,7 +2354,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.memcg_record = rec,
-		.nodemask = NULL, /* we don't care the placement */
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 	};
@@ -2368,7 +2367,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	 * take care of from where we get pages. So the node where we start the
 	 * scan does not need to be the current node.
 	 */
-	nid = mem_cgroup_select_victim_node(mem_cont);
+	nid = mem_cgroup_select_victim_node(mem_cont, &sc.nodemask);
 
 	zonelist = NODE_DATA(nid)->node_zonelists;
 


