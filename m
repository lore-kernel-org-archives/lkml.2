Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1F1ItQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:49:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58948 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab1F1Isw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:48:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jun 2011 17:41:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [FIX][PATCH 2/3] memcg: fix numa scan information update to be
 triggered by memory event
Message-Id: <20110628174150.6b32e51c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 646ca5cd1e1ab0633892b86a1bbb6cf600d79d58 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 28 Jun 2011 17:09:25 +0900
Subject: [PATCH 2/3] Fix numa scan information update to be triggered by memory event

commit 889976 adds an numa node round-robin for memcg. But the information
is updated once per 10sec.

This patch changes the update trigger from jiffies to memcg's event count.
After this patch, numa scan information will be updated when we see
1024 events of pagein/pageout under a memcg.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog:
  - simplified
  - removed mutex
  - removed 3% check. To use heuristics, we cannot avoid magic value.
    So, removed heuristics.
---
 mm/memcontrol.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c624312..3e7d5e6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -108,10 +108,12 @@ enum mem_cgroup_events_index {
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
 	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
 #define THRESHOLDS_EVENTS_TARGET (128)
 #define SOFTLIMIT_EVENTS_TARGET (1024)
+#define NUMAINFO_EVENTS_TARGET	(1024)
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
@@ -237,7 +239,8 @@ struct mem_cgroup {
 	int last_scanned_node;
 #if MAX_NUMNODES > 1
 	nodemask_t	scan_nodes;
-	unsigned long   next_scan_node_update;
+	atomic_t	numainfo_events;
+	atomic_t	numainfo_updating;
 #endif
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
@@ -680,6 +683,9 @@ static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
 	case MEM_CGROUP_TARGET_SOFTLIMIT:
 		next = val + SOFTLIMIT_EVENTS_TARGET;
 		break;
+	case MEM_CGROUP_TARGET_NUMAINFO:
+		next = val + NUMAINFO_EVENTS_TARGET;
+		break;
 	default:
 		return;
 	}
@@ -703,6 +709,14 @@ static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
 			__mem_cgroup_target_update(mem,
 				MEM_CGROUP_TARGET_SOFTLIMIT);
 		}
+#if MAX_NUMNODES > 1
+		if (unlikely(__memcg_event_check(mem,
+			MEM_CGROUP_TARGET_NUMAINFO))) {
+			atomic_inc(&mem->numainfo_events);
+			__mem_cgroup_target_update(mem,
+				MEM_CGROUP_TARGET_NUMAINFO);
+		}
+#endif
 	}
 }
 
@@ -1582,11 +1596,15 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *mem,
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 {
 	int nid;
-
-	if (time_after(mem->next_scan_node_update, jiffies))
+	/*
+	 * numainfo_events > 0 means there was at least NUMAINFO_EVENTS_TARGET
+	 * pagein/pageout changes since the last update.
+	 */
+	if (!atomic_read(&mem->numainfo_events))
+		return;
+	if (atomic_inc_return(&mem->numainfo_updating) > 1)
 		return;
 
-	mem->next_scan_node_update = jiffies + 10*HZ;
 	/* make a nodemask where this memcg uses memory from */
 	mem->scan_nodes = node_states[N_HIGH_MEMORY];
 
@@ -1595,6 +1613,9 @@ static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 		if (!test_mem_cgroup_node_reclaimable(mem, nid, false))
 			node_clear(nid, mem->scan_nodes);
 	}
+
+	atomic_set(&mem->numainfo_events, 0);
+	atomic_set(&mem->numainfo_updating, 0);
 }
 
 /*
-- 
1.7.4.1


