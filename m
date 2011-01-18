Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1ARCnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:43:02 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39503 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1ARCnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:43:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 18 Jan 2011 11:36:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 1/4] memcg: modify accounting function for supporting THP
 better
Message-Id: <20110118113657.9bed0165.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_charge_statisics() was designed for charging a page but
now, we have transparent hugepage. To fix problems (in following patch)
it's required to change the function to get the number of pages
as its arguments.

The new function gets following as argument.
  - type of page rather than 'pc'
  - size of page which is accounted.

Changelog:
 - use usual variable names for args.
 - removed unnecessary variable.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -600,23 +600,22 @@ static void mem_cgroup_swap_statistics(s
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
-					 struct page_cgroup *pc,
-					 bool charge)
+					 bool file, int nr_pages)
 {
-	int val = (charge) ? 1 : -1;
-
 	preempt_disable();
 
-	if (PageCgroupCache(pc))
-		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], val);
+	if (file)
+		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
 	else
-		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], val);
+		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
 
-	if (charge)
+	/* pagein of a big page is an event. So, ignore page size */
+	if (nr_pages > 0)
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
 	else
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
-	__this_cpu_inc(mem->stat->count[MEM_CGROUP_EVENTS]);
+
+	__this_cpu_add(mem->stat->count[MEM_CGROUP_EVENTS], nr_pages);
 
 	preempt_enable();
 }
@@ -2115,7 +2114,7 @@ static void ____mem_cgroup_commit_charge
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, pc, true);
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), 1);
 }
 
 static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
@@ -2186,14 +2185,14 @@ static void __mem_cgroup_move_account(st
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, pc, false);
+	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -1);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
 		mem_cgroup_cancel_charge(from, PAGE_SIZE);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, pc, true);
+	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), 1);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2597,7 +2596,7 @@ __mem_cgroup_uncharge_common(struct page
 	}
 
 	for (i = 0; i < count; i++)
-		mem_cgroup_charge_statistics(mem, pc + i, false);
+		mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -1);
 
 	ClearPageCgroupUsed(pc);
 	/*

