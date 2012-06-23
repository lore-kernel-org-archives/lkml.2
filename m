Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2FWGRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:17:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2FWGRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:17:53 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 4/6] memcg: move recent_rotated and recent_scanned informations
Date: Sat, 23 Jun 2012 14:17:39 +0800
Message-Id: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Move recent_rotated and recent_scanned prints next to inactive_anon,
ative_anon, inactive_file, active_file, and unevictable prints to
save developers' time. Since they have to go a long way(when cat memory.stat)
to find recent_rotated and recent_scanned prints which has relationship
with the memory cgroup we care. These prints are behind total_* which
not just focus on the memory cgroup we care currently.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e81328..c821e36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4080,6 +4080,31 @@ static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
 		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
 			   mem_cgroup_nr_lru_pages(memcg, BIT(i)) * PAGE_SIZE);
 
+#ifdef CONFIG_DEBUG_VM
+	{
+		int nid, zid;
+		struct mem_cgroup_per_zone *mz;
+		struct zone_reclaim_stat *rstat;
+		unsigned long recent_rotated[2] = {0, 0};
+		unsigned long recent_scanned[2] = {0, 0};
+
+		for_each_online_node(nid)
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+				rstat = &mz->lruvec.reclaim_stat;
+
+				recent_rotated[0] += rstat->recent_rotated[0];
+				recent_rotated[1] += rstat->recent_rotated[1];
+				recent_scanned[0] += rstat->recent_scanned[0];
+				recent_scanned[1] += rstat->recent_scanned[1];
+			}
+		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
+		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
+		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
+		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[1]);
+	}
+#endif
+
 	/* Hierarchical information */
 	{
 		unsigned long long limit, memsw_limit;
@@ -4117,31 +4142,6 @@ static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
 		seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i], val);
 	}
 
-#ifdef CONFIG_DEBUG_VM
-	{
-		int nid, zid;
-		struct mem_cgroup_per_zone *mz;
-		struct zone_reclaim_stat *rstat;
-		unsigned long recent_rotated[2] = {0, 0};
-		unsigned long recent_scanned[2] = {0, 0};
-
-		for_each_online_node(nid)
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
-				rstat = &mz->lruvec.reclaim_stat;
-
-				recent_rotated[0] += rstat->recent_rotated[0];
-				recent_rotated[1] += rstat->recent_rotated[1];
-				recent_scanned[0] += rstat->recent_scanned[0];
-				recent_scanned[1] += rstat->recent_scanned[1];
-			}
-		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
-		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
-		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
-		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[1]);
-	}
-#endif
-
 	return 0;
 }
 
-- 
1.7.9.5

