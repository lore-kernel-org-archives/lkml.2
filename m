Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1C1JlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:41:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:51945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1C1JlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:41:02 -0400
X-Mailbox-Line: From mhocko@suse.cz Mon Mar 28 11:39:57 2011
Message-Id: <20110328093957.602747084@suse.cz>
User-Agent: quilt/0.48-1
Date: Mon, 28 Mar 2011 11:40:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 3/3] Do not shrink isolated groups from the global reclaim
References: <20110328093957.089007035@suse.cz>
Content-Disposition: inline; filename=memcg-do_not_reclaim_isolated_groups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages charged for isolated mem cgroups are not placed on the global LRU
lists so they are protected from the reclaim in general. This is still not
enough as they still can get reclaimed during the soft hierarchical reclaim

balance_pgdat
	mem_cgroup_soft_limit_reclaim
		mem_cgroup_hierarchical_reclaim
			mem_cgroup_shrink_node_zone

Let's prevent from soft reclaim if the group isolated and let's defer its
balancing to try_to_free_mem_cgroup_pages called from charging paths. This
will make allocations for the group more oom-prone probably but the group
wanted to be isolated so we should give it as much of isolation as it gets
and let the proper memory usage to the group user.

Signed-off-by: Michal Hocko <mhocko@suse.cz>

---
 vmscan.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: linux-2.6.38-rc8/mm/vmscan.c
===================================================================
--- linux-2.6.38-rc8.orig/mm/vmscan.c	2011-03-28 11:24:20.000000000 +0200
+++ linux-2.6.38-rc8/mm/vmscan.c	2011-03-28 11:24:38.000000000 +0200
@@ -2170,14 +2170,16 @@ unsigned long mem_cgroup_shrink_node_zon
 						      sc.may_writepage,
 						      sc.gfp_mask);
 
-	/*
-	 * NOTE: Although we can get the priority field, using it
-	 * here is not a good idea, since it limits the pages we can scan.
-	 * if we don't reclaim here, the shrink_zone from balance_pgdat
-	 * will pick up pages from other mem cgroup's as well. We hack
-	 * the priority and make it zero.
-	 */
-	shrink_zone(0, zone, &sc);
+	if (!is_mem_cgroup_isolated(mem)) {
+		/*
+		 * NOTE: Although we can get the priority field, using it
+		 * here is not a good idea, since it limits the pages we can scan.
+		 * if we don't reclaim here, the shrink_zone from balance_pgdat
+		 * will pick up pages from other mem cgroup's as well. We hack
+		 * the priority and make it zero.
+		 */
+		shrink_zone(0, zone, &sc);
+	}
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 


