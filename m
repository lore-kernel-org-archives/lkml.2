Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2JOWEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:04:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab2JOWEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:04:11 -0400
Date: Tue, 16 Oct 2012 00:04:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] memcg: oom: fix totalpages calculation for
 memory.swappiness==0
Message-ID: <20121015220354.GA11682@dhcp22.suse.cz>
References: <20121011085038.GA29295@dhcp22.suse.cz>
 <1349945859-1350-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349945859-1350-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Kosaki correctly pointed out, the glogal reclaim doesn't have this
issue because we _do_ swap on swappinnes==0 so the swap space has
to be considered. So the v2 is just acks + changelog fix.

Changes since v1
- drop a note about global swappiness affected as well from the
  changelog
- stable needs 3.2+ rather than 3.5+ because the fe35004f has been
  backported to stable
---
>From c2ae4849f09dbfda6b61472c6dd1fd8c2fe8ac81 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 10 Oct 2012 15:46:54 +0200
Subject: [PATCH] memcg: oom: fix totalpages calculation for
 memory.swappiness==0

oom_badness takes totalpages argument which says how many pages are
available and it uses it as a base for the score calculation. The value
is calculated by mem_cgroup_get_limit which considers both limit and
total_swap_pages (resp. memsw portion of it).

This is usually correct but since fe35004f (mm: avoid swapping out
with swappiness==0) we do not swap when swappiness is 0 which means
that we cannot really use up all the totalpages pages. This in turn
confuses oom score calculation if the memcg limit is much smaller than
the available swap because the used memory (capped by the limit) is
negligible comparing to totalpages so the resulting score is too small
if adj!=0 (typically task with CAP_SYS_ADMIN or non zero oom_score_adj).
A wrong process might be selected as result.

The problem can be worked around by checking mem_cgroup_swappiness==0
and not considering swap at all in such a case.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: stable [3.2+]
---
 mm/memcontrol.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7acf43b..93a7e36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1452,17 +1452,26 @@ static int mem_cgroup_count_children(struct mem_cgroup *memcg)
 static u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 {
 	u64 limit;
-	u64 memsw;
 
 	limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-	limit += total_swap_pages << PAGE_SHIFT;
 
-	memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
 	/*
-	 * If memsw is finite and limits the amount of swap space available
-	 * to this memcg, return that limit.
+	 * Do not consider swap space if we cannot swap due to swappiness
 	 */
-	return min(limit, memsw);
+	if (mem_cgroup_swappiness(memcg)) {
+		u64 memsw;
+
+		limit += total_swap_pages << PAGE_SHIFT;
+		memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+
+		/*
+		 * If memsw is finite and limits the amount of swap space
+		 * available to this memcg, return that limit.
+		 */
+		limit = min(limit, memsw);
+	}
+
+	return limit;
 }
 
 void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
