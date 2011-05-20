Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab1ETDvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:51:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58316 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab1ETDvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:51:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 May 2011 12:44:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 4/8] memcg: export release victim
Message-Id: <20110520124430.6f463803.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later change will call mem_cgroup_select_victim() from vmscan.c
Need to export an interface and add release_victim().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 ++
 mm/memcontrol.c            |   13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: mmotm-May11/mm/memcontrol.c
===================================================================
--- mmotm-May11.orig/mm/memcontrol.c
+++ mmotm-May11/mm/memcontrol.c
@@ -1487,7 +1487,7 @@ u64 mem_cgroup_get_limit(struct mem_cgro
  * of the cgroup list, since we track last_scanned_child) of @mem and use
  * that to reclaim free pages from.
  */
-static struct mem_cgroup *
+struct mem_cgroup *
 mem_cgroup_select_victim(struct mem_cgroup *root_mem)
 {
 	struct mem_cgroup *ret = NULL;
@@ -1519,6 +1519,11 @@ mem_cgroup_select_victim(struct mem_cgro
 	return ret;
 }
 
+void mem_cgroup_release_victim(struct mem_cgroup *mem)
+{
+	css_put(&mem->css);
+}
+
 #if MAX_NUMNODES > 1
 
 /*
@@ -1663,7 +1668,7 @@ static int mem_cgroup_hierarchical_recla
 				 * no reclaimable pages under this hierarchy
 				 */
 				if (!check_soft || !total) {
-					css_put(&victim->css);
+					mem_cgroup_release_victim(victim);
 					break;
 				}
 				/*
@@ -1674,14 +1679,14 @@ static int mem_cgroup_hierarchical_recla
 				 */
 				if (total >= (excess >> 2) ||
 					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS)) {
-					css_put(&victim->css);
+					mem_cgroup_release_victim(victim);
 					break;
 				}
 			}
 		}
 		if (!mem_cgroup_local_usage(victim)) {
 			/* this cgroup's local usage == 0 */
-			css_put(&victim->css);
+			mem_cgroup_release_victim(victim);
 			continue;
 		}
 		/* we use swappiness of local cgroup */
@@ -1694,7 +1699,7 @@ static int mem_cgroup_hierarchical_recla
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 					noswap);
-		css_put(&victim->css);
+		mem_cgroup_release_victim(victim);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
 		 * reclaim more. It's depends on callers. last_scanned_child
Index: mmotm-May11/include/linux/memcontrol.h
===================================================================
--- mmotm-May11.orig/include/linux/memcontrol.h
+++ mmotm-May11/include/linux/memcontrol.h
@@ -122,6 +122,8 @@ struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
+struct mem_cgroup *mem_cgroup_select_victim(struct mem_cgroup *mem);
+void mem_cgroup_release_victim(struct mem_cgroup *mem);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif

