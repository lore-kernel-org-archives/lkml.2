Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2LMOG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2LMOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 099/241] memcg: oom: fix totalpages calculation for memory.swappiness==0
Date: Thu, 13 Dec 2012 11:57:44 -0200
Message-Id: <1355407206-17100-100-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 9a5a8f19b43430752067ecaee62fc59e11e88fa6 upstream.

oom_badness() takes a totalpages argument which says how many pages are
available and it uses it as a base for the score calculation.  The value
is calculated by mem_cgroup_get_limit which considers both limit and
total_swap_pages (resp.  memsw portion of it).

This is usually correct but since fe35004fbf9e ("mm: avoid swapping out
with swappiness==0") we do not swap when swappiness is 0 which means
that we cannot really use up all the totalpages pages.  This in turn
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 Documentation/cgroups/memory.txt |    4 ++++
 mm/memcontrol.c                  |   21 +++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index dd88540..63838c2 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -464,6 +464,10 @@ Note:
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
 
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f72b5e5..3ddd346 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1457,17 +1457,26 @@ static int mem_cgroup_count_children(struct mem_cgroup *memcg)
 u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
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
 
 static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
-- 
1.7.9.5

