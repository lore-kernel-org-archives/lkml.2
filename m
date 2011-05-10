Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1EJKLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:11:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47832 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab1EJKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:11:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 May 2011 19:04:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 1/7] memcg: check margin to limit  for async reclaim
Message-Id: <20110510190433.74dba748.kamezawa.hiroyu@jp.fujitsu.com>
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

Now, the kernel supports transparent hugepage and it's used at each page fault
if configured. Then, if the THP allocation hits limit of memcg, it needs to
reclaim memory of HPAGE_SIZE. This tends to require much larger scan than
SWAP_CLUSTER_MAX and increases latency. In other allocations, page scanning
at hitting limit causes latency to some extent.

This patch adds a logic to keep usage margin to the limit in asynchronous way.
When the usage over some threshould (determined automatically), asynchronous
memory reclaim runs and shrink memory to limit - MEMCG_ASYNC_STOP_MARGIN.

By this, there will be no difference in total amount of usage of cpu to
scan the LRU but we'll have a chance to make use of wait time of applications
for freeing memory. For example, when an application read a file or socket,
to fill the newly alloated memory, it needs wait. Async reclaim can make use
of that time and give a chance to reduce latency by background works.

This patch only includes required hooks to trigger async reclaim. Core logics
will be in the following patches.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

Index: mmotm-May6/mm/memcontrol.c
===================================================================
--- mmotm-May6.orig/mm/memcontrol.c
+++ mmotm-May6/mm/memcontrol.c
@@ -115,10 +115,12 @@ enum mem_cgroup_events_index {
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
 	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_TARGET_ASYNC,
 	MEM_CGROUP_NTARGETS,
 };
 #define THRESHOLDS_EVENTS_TARGET (128)
 #define SOFTLIMIT_EVENTS_TARGET (1024)
+#define ASYNC_EVENTS_TARGET	(512)	/* assume x86-64's hpagesize */
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
@@ -211,6 +213,31 @@ static void mem_cgroup_threshold(struct 
 static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
 
 /*
+ * For example, with transparent hugepages, memory reclaim scan at hitting
+ * limit can very long as to reclaim HPAGE_SIZE of memory. This increases
+ * latency of page fault and may cause fallback. At usual page allocation,
+ * we'll see some (shorter) latency, too. To reduce latency, it's appreciated
+ * to free memory in background to make margin to the limit. This consumes
+ * cpu but we'll have a chance to make use of wait time of applications
+ * (read disk etc..) by asynchronous reclaim.
+ *
+ * This async reclaim tries to reclaim HPAGE_SIZE * 2 of pages when margin
+ * to the limit is smaller than HPAGE_SIZE * 2. This will be enabled
+ * automatically when the limit is set and it's greater than the threshold.
+ */
+#if HPAGE_SIZE != PAGE_SIZE
+#define MEMCG_ASYNC_LIMIT_THRESH      (HPAGE_SIZE * 64)
+#define MEMCG_ASYNC_START_MARGIN      (HPAGE_SIZE * 2)
+#define MEMCG_ASYNC_STOP_MARGIN	      (HPAGE_SIZE * 4)
+#else /* make the margin as 4M bytes */
+#define MEMCG_ASYNC_LIMIT_THRESH      (128 * 1024 * 1024)
+#define MEMCG_ASYNC_START_MARGIN      (4 * 1024 * 1024)
+#define MEMCG_ASYNC_STOP_MARGIN       (8 * 1024 * 1024)
+#endif
+
+static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem);
+
+/*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
@@ -259,6 +286,7 @@ struct mem_cgroup {
 
 	/* set when res.limit == memsw.limit */
 	bool		memsw_is_minimum;
+	bool		need_async_reclaim;
 
 	/* protect arrays of thresholds */
 	struct mutex thresholds_lock;
@@ -722,6 +750,9 @@ static void __mem_cgroup_target_update(s
 	case MEM_CGROUP_TARGET_SOFTLIMIT:
 		next = val + SOFTLIMIT_EVENTS_TARGET;
 		break;
+	case MEM_CGROUP_TARGET_ASYNC:
+		next = val + ASYNC_EVENTS_TARGET;
+		break;
 	default:
 		return;
 	}
@@ -745,6 +776,11 @@ static void memcg_check_events(struct me
 			__mem_cgroup_target_update(mem,
 				MEM_CGROUP_TARGET_SOFTLIMIT);
 		}
+		if (__memcg_event_check(mem, MEM_CGROUP_TARGET_ASYNC)) {
+			mem_cgroup_may_async_reclaim(mem);
+			__mem_cgroup_target_update(mem,
+				MEM_CGROUP_TARGET_ASYNC);
+		}
 	}
 }
 
@@ -3376,6 +3412,11 @@ static int mem_cgroup_resize_limit(struc
 				memcg->memsw_is_minimum = true;
 			else
 				memcg->memsw_is_minimum = false;
+
+			if (val >= MEMCG_ASYNC_LIMIT_THRESH)
+				memcg->need_async_reclaim = true;
+			else
+				memcg->need_async_reclaim = false;
 		}
 		mutex_unlock(&set_limit_mutex);
 
@@ -3553,6 +3594,15 @@ unsigned long mem_cgroup_soft_limit_recl
 	return nr_reclaimed;
 }
 
+static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem)
+{
+	if (!mem->need_async_reclaim)
+		return;
+	if (res_counter_margin(&mem->res) <= MEMCG_ASYNC_START_MARGIN) {
+		/* Fill here */
+	}
+}
+
 /*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.

