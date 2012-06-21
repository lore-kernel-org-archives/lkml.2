Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab2FUITP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:19:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42657 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab2FUITL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:19:11 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE2D87D.2090500@jp.fujitsu.com>
Date: Thu, 21 Jun 2012 17:17:01 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] memcg: clean up force_empty_list() return value check
References: <4FDF17A3.9060202@jp.fujitsu.com> <4FDF1830.1000504@jp.fujitsu.com> <20120619165815.5ce24be7.akpm@linux-foundation.org> <4FE2D747.20506@jp.fujitsu.com>
In-Reply-To: <4FE2D747.20506@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're right and I think this will be much cleaner.
==

 From 9b6224616282d74838b393485eb7c9215f546ec9 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 21 Jun 2012 17:28:55 +0900
Subject: [PATCH 2/2] memcg: make mem_cgroup_force_empty_list() as boolean function

Now, mem_cgroup_force_empty_list() just returns 0 or -EBUSY and
-EBUSY is just indicating 'you need to retry.'.
This patch makes mem_cgroup_force_empty_list() as boolean function and
make the logic simpler.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
  mm/memcontrol.c |   13 +++----------
  1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 90a2ad4..767440c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3797,7 +3797,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
   * This routine traverse page_cgroup in given list and drop them all.
   * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
   */
-static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
+static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  				int node, int zid, enum lru_list lru)
  {
  	struct mem_cgroup_per_zone *mz;
@@ -3805,7 +3805,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  	struct list_head *list;
  	struct page *busy;
  	struct zone *zone;
-	int ret = 0;
  
  	zone = &NODE_DATA(node)->node_zones[zid];
  	mz = mem_cgroup_zoneinfo(memcg, node, zid);
@@ -3819,7 +3818,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  		struct page_cgroup *pc;
  		struct page *page;
  
-		ret = 0;
  		spin_lock_irqsave(&zone->lru_lock, flags);
  		if (list_empty(list)) {
  			spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -3836,19 +3834,14 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  
  		pc = lookup_page_cgroup(page);
  
-		ret = mem_cgroup_move_parent(page, pc, memcg);
-
-		if (ret == -EBUSY || ret == -EINVAL) {
+		if (mem_cgroup_move_parent(page, pc, memcg)) {
  			/* found lock contention or "pc" is obsolete. */
  			busy = page;
  			cond_resched();
  		} else
  			busy = NULL;
  	}
-
-	if (!ret && !list_empty(list))
-		return -EBUSY;
-	return ret;
+	return !list_empty(list);
  }
  
  /*
-- 
1.7.4.1


