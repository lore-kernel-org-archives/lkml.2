Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab1CDHvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:51:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47926 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1CDHvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:51:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Mar 2011 16:44:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH] memcg: fix event counter breakage with THP.
Message-Id: <20110304164450.4cf80ef1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memcg: Fix event counter, event leak with THP

With THP, event counter is updated by the size of large page because
event counter is for catching the change in usage.
This is now used for threshold notifier and soft limit.

Current event counter cathces the event by mask, as

   !(counter & mask)

Before THP, counter is always updated by 1, this never misses target.
But now, this can miss.

This patch makes the trigger for event as

  counter > target.

target is updated when the event happens.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   59 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 14 deletions(-)

Index: mmotm-0303/mm/memcontrol.c
===================================================================
--- mmotm-0303.orig/mm/memcontrol.c
+++ mmotm-0303/mm/memcontrol.c
@@ -73,15 +73,6 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
-/*
- * Per memcg event counter is incremented at every pagein/pageout. This counter
- * is used for trigger some periodic events. This is straightforward and better
- * than using jiffies etc. to handle periodic memcg event.
- *
- * These values will be used as !((event) & ((1 <<(thresh)) - 1))
- */
-#define THRESHOLDS_EVENTS_THRESH (7) /* once in 128 */
-#define SOFTLIMIT_EVENTS_THRESH (10) /* once in 1024 */
 
 /*
  * Statistics for memory cgroup.
@@ -105,10 +96,24 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. With THP,
+ * it will be incremated by the number of pages. This counter is used for
+ * for trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ */
+enum mem_cgroup_events_target {
+        MEM_CGROUP_TARGET_THRESH,
+        MEM_CGROUP_TARGET_SOFTLIMIT,
+        MEM_CGROUP_NTARGETS,
+};
+#define THRESHOLDS_EVENTS_TARGET (128)
+#define SOFTLIMIT_EVENTS_TARGET (1024)
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
+        unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
 /*
@@ -634,13 +639,34 @@ static unsigned long mem_cgroup_get_loca
 	return total;
 }
 
-static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
+static bool __memcg_event_check(struct mem_cgroup *mem, int target)
 {
-	unsigned long val;
+	unsigned long val, next;
 
 	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = this_cpu_read(mem->stat->targets[target]);
+        /* from time_after() in jiffies.h */
+	return ((long)next - (long)val < 0);
+}
 
-	return !(val & ((1 << event_mask_shift) - 1));
+static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
+{
+        unsigned long val, next;
+
+	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+
+        switch (target) {
+        case MEM_CGROUP_TARGET_THRESH:
+		next = val + THRESHOLDS_EVENTS_TARGET;
+            	break;
+        case MEM_CGROUP_TARGET_SOFTLIMIT:
+		next = val + SOFTLIMIT_EVENTS_TARGET;
+            	break;
+	default:
+		return;
+        }
+
+        this_cpu_write(mem->stat->targets[target], next);
 }
 
 /*
@@ -650,10 +676,15 @@ static bool __memcg_event_check(struct m
 static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
 {
 	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(__memcg_event_check(mem, THRESHOLDS_EVENTS_THRESH))) {
+	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(mem);
-		if (unlikely(__memcg_event_check(mem, SOFTLIMIT_EVENTS_THRESH)))
+                __mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
+		if (unlikely(__memcg_event_check(mem,
+			MEM_CGROUP_TARGET_SOFTLIMIT))){
 			mem_cgroup_update_tree(mem, page);
+			__mem_cgroup_target_update(mem,
+				MEM_CGROUP_TARGET_SOFTLIMIT);
+		}
 	}
 }
 

