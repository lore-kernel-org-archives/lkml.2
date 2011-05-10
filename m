Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1EJKQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:16:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1EJKQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:16:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 May 2011 19:09:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 5/7] memcg : export select victim memcg
Message-Id: <20110510190942.4213fe24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later change will call mem_cgroup_select_victim() from vmscan.c
to do hierarchical reclaim. Need to export an interface and add
release_victim().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 ++
 mm/memcontrol.c            |   13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: mmotm-May6/mm/memcontrol.c
===================================================================
--- mmotm-May6.orig/mm/memcontrol.c
+++ mmotm-May6/mm/memcontrol.c
@@ -1555,6 +1555,11 @@ mem_cgroup_select_victim(struct mem_cgro
 	return ret;
 }
 
+void mem_cgroup_release_victim(struct mem_cgroup *mem)
+{
+	css_put(&mem->css);
+}
+
 #if MAX_NUMNODES > 1
 
 /*
@@ -1699,7 +1704,7 @@ static int mem_cgroup_hierarchical_recla
 				 * no reclaimable pages under this hierarchy
 				 */
 				if (!check_soft || !total) {
-					css_put(&victim->css);
+					mem_cgroup_release_victim(victim);
 					break;
 				}
 				/*
@@ -1710,14 +1715,14 @@ static int mem_cgroup_hierarchical_recla
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
@@ -1730,7 +1735,7 @@ static int mem_cgroup_hierarchical_recla
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 					noswap);
-		css_put(&victim->css);
+		mem_cgroup_release_victim(victim);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
 		 * reclaim more. It's depends on callers. last_scanned_child
Index: mmotm-May6/include/linux/memcontrol.h
===================================================================
--- mmotm-May6.orig/include/linux/memcontrol.h
+++ mmotm-May6/include/linux/memcontrol.h
@@ -122,6 +122,8 @@ struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
+struct mem_cgroup *mem_cgroup_select_victim(struct mem_cgroup *mem);
+void mem_cgroup_release_victim(struct mem_cgroup *mem);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif

