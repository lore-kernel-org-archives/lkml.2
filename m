Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1DKIAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:00:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59845 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1DKIAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:00:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/3] mm, mem-hotplug: fix section mismatch. setup_per_zone_inactive_ratio() should be __meminit.
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
Message-Id: <20110411170033.0356.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 17:00:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bce7394a3e (page-allocator: reset wmark_min and inactive ratio of
zone when hotplug happens) introduced invalid section references.
Now, setup_per_zone_inactive_ratio() is marked __init and then it can't
be referenced from memory hotplug code.

Then, this patch marks it as __meminit and also marks caller as __ref.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory_hotplug.c |    4 ++--
 mm/page_alloc.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f0651ae..0419c3d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -400,7 +400,7 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 }
 
 
-int online_pages(unsigned long pfn, unsigned long nr_pages)
+int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
@@ -795,7 +795,7 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 	return offlined;
 }
 
-static int offline_pages(unsigned long start_pfn,
+static int __ref offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
 	unsigned long pfn, nr_pages, expire;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e400779..44fae85 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5072,7 +5072,7 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void calculate_zone_inactive_ratio(struct zone *zone)
+void __meminit calculate_zone_inactive_ratio(struct zone *zone)
 {
 	unsigned int gb, ratio;
 
@@ -5086,7 +5086,7 @@ void calculate_zone_inactive_ratio(struct zone *zone)
 	zone->inactive_ratio = ratio;
 }
 
-static void __init setup_per_zone_inactive_ratio(void)
+static void __meminit setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
-- 
1.7.3.1



