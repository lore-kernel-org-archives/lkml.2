Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab1FPEBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:01:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52668 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1FPEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:01:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 12:54:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 5/7] Fix not good check of mem_cgroup_local_usage()
Message-Id: <20110616125443.23584d78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fcfc6ee9847b0b2571cd6e9847572d7c70e1e2b2 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 16 Jun 2011 09:23:54 +0900
Subject: [PATCH 5/7] Fix not good check of mem_cgroup_local_usage()

Now, mem_cgroup_local_usage(memcg) is used as hint for scanning memory
cgroup hierarchy. If it returns true, the memcg has some reclaimable memory.

But this function doesn't take care of
  - unevictable pages
  - anon pages on swapless system.

This patch fixes the function to use LRU information.
For NUMA, for avoid scanning, numa scan bitmap is used. If it's
empty, some more precise check will be done.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   43 +++++++++++++++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 10 deletions(-)

Index: mmotm-0615/mm/memcontrol.c
===================================================================
--- mmotm-0615.orig/mm/memcontrol.c
+++ mmotm-0615/mm/memcontrol.c
@@ -632,15 +632,6 @@ static long mem_cgroup_read_stat(struct 
 	return val;
 }
 
-static long mem_cgroup_local_usage(struct mem_cgroup *mem)
-{
-	long ret;
-
-	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
-	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
-	return ret;
-}
-
 static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
 					 bool charge)
 {
@@ -1713,6 +1704,23 @@ static void mem_cgroup_numascan_init(str
 	mutex_init(&mem->numascan_mutex);
 }
 
+static bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
+{
+	if (!nodes_empty(mem->scan_nodes))
+		return true;
+	/* slow path */
+	if (mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_FILE))
+		return true;
+	if (mem_cgroup_get_local_zonestat(mem, LRU_ACTIVE_FILE))
+		return true;
+	if (noswap || !total_swap_pages)
+		return false;
+	if (mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON))
+		return true;
+	if (mem_cgroup_get_local_zonestat(mem, LRU_ACTIVE_ANON))
+		return true;
+	return false;
+}
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
@@ -1722,6 +1730,21 @@ static void mem_cgroup_numascan_init(str
 {
 	return 0;
 }
+
+static bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
+{
+	if (mem_cgroup_get_zonestat_node(mem, 0, LRU_INACTIVE_FILE))
+		return true;
+	if (mem_cgroup_get_zonestat_node(mem, 0, LRU_ACTIVE_FILE))
+		return true;
+	if (noswap || !total_swap_pages)
+		return false;
+	if (mem_cgroup_get_zonestat_node(mem, 0, LRU_INACTIVE_ANON))
+		return true;
+	if (mem_cgroup_get_zonestat_node(mem, 0, LRU_ACTIVE_ANON))
+		return true;
+	return false;
+}
 #endif
 
 
@@ -1811,7 +1834,7 @@ again:
 
 	while (visit--) {
 		victim = mem_cgroup_select_victim(root_mem);
-		if (!mem_cgroup_local_usage(victim)) {
+		if (!mem_cgroup_reclaimable(victim, noswap)) {
 			/* this cgroup's local usage == 0 */
 			css_put(&victim->css);
 			continue;

