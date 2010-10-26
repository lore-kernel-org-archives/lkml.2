Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0JZNLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:11:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41047 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0JZNLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:11:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 2/2] mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20101026221017.B7DF.A69D9226@jp.fujitsu.com>
References: <20101026221017.B7DF.A69D9226@jp.fujitsu.com>
Message-Id: <20101026221213.B7E2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Oct 2010 22:11:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, cpu hotplug updates pcp->stat_threashold, but memory
hotplug doesn't. there is no reason.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <cl@linux.com>
---
 include/linux/vmstat.h |    5 ++++-
 mm/page_alloc.c        |    2 ++
 mm/vmstat.c            |    5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index eaaea37..1997988 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -254,6 +254,7 @@ extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
+void refresh_zone_stat_thresholds(void);
 #else /* CONFIG_SMP */
 
 /*
@@ -299,6 +300,8 @@ static inline void __dec_zone_page_state(struct page *page,
 #define mod_zone_page_state __mod_zone_page_state
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
-#endif
+static inline void refresh_zone_stat_thresholds(void) { }
+
+#endif /* CONFIG_SMP */
 
 #endif /* _LINUX_VMSTAT_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 14ee899..410df70 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -51,6 +51,7 @@
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <linux/compaction.h>
+#include <linux/vmstat.h>
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
 
@@ -5014,6 +5015,7 @@ int __meminit init_per_zone_wmark_min(void)
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
 	setup_per_zone_wmarks();
+	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();
 	return 0;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index cd2e42b..b6b7fed 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -133,7 +133,7 @@ static int calculate_threshold(struct zone *zone)
 /*
  * Refresh the thresholds for each zone.
  */
-static void refresh_zone_stat_thresholds(void)
+void refresh_zone_stat_thresholds(void)
 {
 	struct zone *zone;
 	int cpu;
@@ -371,7 +371,7 @@ void refresh_cpu_vm_stats(int cpu)
 			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
-#endif
+#endif /* CONFIG_SMP */
 
 #ifdef CONFIG_NUMA
 /*
@@ -1059,7 +1059,6 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_SMP
 	int cpu;
 
-	refresh_zone_stat_thresholds();
 	register_cpu_notifier(&vmstat_notifier);
 
 	for_each_online_cpu(cpu)
-- 
1.6.5.2



