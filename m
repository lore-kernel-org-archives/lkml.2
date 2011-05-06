Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1EFH4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:56:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48598 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1EFH4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:56:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 May 2011 16:50:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, yinghan@google.com
Subject: Re: + memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch added
 to -mm tree
Message-Id: <20110506165006.3df50f77.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201105032314.p43NE1Ae016380@imap1.linux-foundation.org>
References: <201105032314.p43NE1Ae016380@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 May 2011 16:14:01 -0700
akpm@linux-foundation.org wrote:
-----------------------------------------------------
> Subject: memcg-add-stats-to-monitor-soft_limit-reclaim-v2
> From: Ying Han <yinghan@google.com>
> 
> Extend the soft_limit reclaim stats to both global background reclaim and
> global direct reclaim.
> 
> The following stats are renamed and added:
> 
> $cat /dev/cgroup/memory/A/memory.stat
> soft_kswapd_steal 1053626
> soft_kswapd_scan 1053693
> soft_direct_steal 1481810
> soft_direct_scan 1481996
> 
> changelog v2..v1:
> 1. rename the stats on soft_kswapd/direct_steal/scan.
> 2. fix the documentation to match the stat name.
> 

This patch is not based on mmotm and need some tweak and fix.
It may be better to wait for Ying's v3 but this is a quick v3 by me.
==
Subject: memcg-add-stats-to-monitor-soft_limit-reclaim-v3
From: Ying Han <yinghan@google.com>

Extend the soft_limit reclaim stats to both global background reclaim and
global direct reclaim.

The following stats are renamed and added:

$cat /dev/cgroup/memory/A/memory.stat
soft_kswapd_steal 1053626
soft_kswapd_scan 1053693
soft_direct_steal 1481810
soft_direct_scan 1481996

changelog v3..v2:
1. rebased onto mmotm-Apr29.(which includes memcg pgfault counter)
2. fixed missing codes for adding stat strings as "soft_direct_steal" etc..
changelog v2..v1:
1. rename the stats on soft_kswapd/direct_steal/scan.
2. fix the documentation to match the stat name.

Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   16 ++++++--
 mm/memcontrol.c                  |   70 ++++++++++++++++++++++++++++-----------
 2 files changed, 63 insertions(+), 23 deletions(-)

Index: mmotm-Apr29/Documentation/cgroups/memory.txt
===================================================================
--- mmotm-Apr29.orig/Documentation/cgroups/memory.txt
+++ mmotm-Apr29/Documentation/cgroups/memory.txt
@@ -389,8 +389,14 @@ pgpgout		- # of pages paged out (equival
 swap		- # of bytes of swap usage
 pgfault		- # of page faults.
 pgmajfault	- # of major page faults.
-soft_steal	- # of pages reclaimed from global hierarchical reclaim
-soft_scan	- # of pages scanned from global hierarchical reclaim
+soft_kswapd_steal- # of pages reclaimed in global hierarchical reclaim from
+		background reclaim
+soft_kswapd_scan - # of pages scanned in global hierarchical reclaim from
+		background reclaim
+soft_direct_steal- # of pages reclaimed in global hierarchical reclaim from
+		direct reclaim
+soft_direct_scan- # of pages scanned in global hierarchical reclaim from
+		direct reclaim
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
@@ -414,8 +420,10 @@ total_pgpgout		- sum of all children's "
 total_swap		- sum of all children's "swap"
 total_pgfault		- sum of all children's "pgfault"
 total_pgmajfault	- sum of all children's "pgmajfault"
-total_soft_steal	- sum of all children's "soft_steal"
-total_soft_scan		- sum of all children's "soft_scan"
+total_soft_kswapd_steal	- sum of all children's "soft_kswapd_steal"
+total_soft_kswapd_scan	- sum of all children's "soft_kswapd_scan"
+total_soft_direct_steal	- sum of all children's "soft_direct_steal"
+total_soft_direct_scan	- sum of all children's "soft_direct_scan"
 total_inactive_anon	- sum of all children's "inactive_anon"
 total_active_anon	- sum of all children's "active_anon"
 total_inactive_file	- sum of all children's "inactive_file"
Index: mmotm-Apr29/mm/memcontrol.c
===================================================================
--- mmotm-Apr29.orig/mm/memcontrol.c
+++ mmotm-Apr29/mm/memcontrol.c
@@ -96,10 +96,14 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
 	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
 	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
-	MEM_CGROUP_EVENTS_SOFT_STEAL,	/* # of pages reclaimed from */
-					/* soft reclaim               */
-	MEM_CGROUP_EVENTS_SOFT_SCAN,	/* # of pages scanned from */
-					/* soft reclaim               */
+	MEM_CGROUP_EVENTS_SOFT_KSWAPD_STEAL, /* # of pages reclaimed from */
+					/* soft reclaim in background reclaim */
+	MEM_CGROUP_EVENTS_SOFT_KSWAPD_SCAN, /* # of pages scanned from */
+					/* soft reclaim in background reclaim */
+	MEM_CGROUP_EVENTS_SOFT_DIRECT_STEAL, /* # of pages reclaimed from */
+					/* soft reclaim in direct reclaim */
+	MEM_CGROUP_EVENTS_SOFT_DIRECT_SCAN, /* # of pages scanned from */
+					/* soft reclaim in direct reclaim */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 /*
@@ -640,14 +644,30 @@ static void mem_cgroup_charge_statistics
 	preempt_enable();
 }
 
-static void mem_cgroup_soft_steal(struct mem_cgroup *mem, int val)
+static void mem_cgroup_soft_steal(struct mem_cgroup *mem, bool is_kswapd,
+				  int val)
 {
-	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_STEAL], val);
+	if (is_kswapd)
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_KSWAPD_STEAL],
+									val);
+	else
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_DIRECT_STEAL],
+									val);
 }
 
-static void mem_cgroup_soft_scan(struct mem_cgroup *mem, int val)
-{
-	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_SCAN], val);
+static void mem_cgroup_soft_scan(struct mem_cgroup *mem, bool is_kswapd,
+				 int val)
+{
+	if (is_kswapd)
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_KSWAPD_SCAN],
+									val);
+	else
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_DIRECT_SCAN],
+									val);
 }
 
 static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
@@ -1495,6 +1515,7 @@ static int mem_cgroup_hierarchical_recla
 	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
 	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
+	bool is_kswapd = false;
 	unsigned long excess;
 	unsigned long nr_scanned;
 
@@ -1504,6 +1525,9 @@ static int mem_cgroup_hierarchical_recla
 	if (root_mem->memsw_is_minimum)
 		noswap = true;
 
+	if (current_is_kswapd())
+		is_kswapd = true;
+
 	while (1) {
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
@@ -1544,8 +1568,8 @@ static int mem_cgroup_hierarchical_recla
 				noswap, get_swappiness(victim), zone,
 				&nr_scanned);
 			*total_scanned += nr_scanned;
-			mem_cgroup_soft_steal(victim, ret);
-			mem_cgroup_soft_scan(victim, nr_scanned);
+			mem_cgroup_soft_steal(victim, is_kswapd, ret);
+			mem_cgroup_soft_scan(victim, is_kswapd, nr_scanned);
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
@@ -3840,8 +3864,10 @@ enum {
 	MCS_SWAP,
 	MCS_PGFAULT,
 	MCS_PGMAJFAULT,
-	MCS_SOFT_STEAL,
-	MCS_SOFT_SCAN,
+	MCS_SOFT_KSWAPD_STEAL,
+	MCS_SOFT_KSWAPD_SCAN,
+	MCS_SOFT_DIRECT_STEAL,
+	MCS_SOFT_DIRECT_SCAN,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -3866,8 +3892,10 @@ struct {
 	{"swap", "total_swap"},
 	{"pgfault", "total_pgfault"},
 	{"pgmajfault", "total_pgmajfault"},
-	{"soft_steal", "total_soft_steal"},
-	{"soft_scan", "total_soft_scan"},
+	{"soft_kswapd_steal", "total_soft_kswapd_steal"},
+	{"soft_kswapd_scan", "total_soft_kswapd_scan"},
+	{"soft_direct_steal", "total_soft_direct_steal"},
+	{"soft_direct_scan", "total_soft_direct_scan"},
 	{"inactive_anon", "total_inactive_anon"},
 	{"active_anon", "total_active_anon"},
 	{"inactive_file", "total_inactive_file"},
@@ -3896,14 +3924,18 @@ mem_cgroup_get_local_stat(struct mem_cgr
 		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
-	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_STEAL);
-	s->stat[MCS_SOFT_STEAL] += val;
-	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_SCAN);
-	s->stat[MCS_SOFT_SCAN] += val;
 	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_PGFAULT);
 	s->stat[MCS_PGFAULT] += val;
 	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_PGMAJFAULT);
 	s->stat[MCS_PGMAJFAULT] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_KSWAPD_STEAL);
+	s->stat[MCS_SOFT_KSWAPD_STEAL] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_KSWAPD_SCAN);
+	s->stat[MCS_SOFT_KSWAPD_SCAN] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_DIRECT_STEAL);
+	s->stat[MCS_SOFT_DIRECT_STEAL] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_DIRECT_SCAN);
+	s->stat[MCS_SOFT_DIRECT_SCAN] += val;
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);


