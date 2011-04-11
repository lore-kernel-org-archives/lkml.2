Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1DKIAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:00:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59875 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1DKIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:00:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/3] mm, mem-hotplug: recalculate lowmem_reserve when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <20110411165957.0352.A69D9226@jp.fujitsu.com>
References: <20110411165957.0352.A69D9226@jp.fujitsu.com>
Message-Id: <20110411170103.035A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 17:00:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, memory hotplug call setup_per_zone_wmarks() and
calculate_zone_inactive_ratio(), but don't call setup_per_zone_lowmem_reserve().

It mean number of reserved pages aren't updated even if memory hot plug
occur. This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/mm.h  |    2 +-
 mm/memory_hotplug.c |    9 +++++----
 mm/page_alloc.c     |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 628b31c..84f1e31 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1357,7 +1357,7 @@ extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
-extern void calculate_zone_inactive_ratio(struct zone *zone);
+extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0419c3d..ba7019e9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -459,8 +459,9 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 		zone_pcp_update(zone);
 
 	mutex_unlock(&zonelists_mutex);
-	setup_per_zone_wmarks();
-	calculate_zone_inactive_ratio(zone);
+
+	init_per_zone_wmark_min();
+
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
@@ -893,8 +894,8 @@ repeat:
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
 
-	setup_per_zone_wmarks();
-	calculate_zone_inactive_ratio(zone);
+	init_per_zone_wmark_min();
+
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
 		kswapd_stop(node);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 44fae85..ef90a87 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5072,7 +5072,7 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void __meminit calculate_zone_inactive_ratio(struct zone *zone)
+static void __meminit calculate_zone_inactive_ratio(struct zone *zone)
 {
 	unsigned int gb, ratio;
 
@@ -5118,7 +5118,7 @@ static void __meminit setup_per_zone_inactive_ratio(void)
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-static int __init init_per_zone_wmark_min(void)
+int __meminit init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
 
-- 
1.7.3.1



