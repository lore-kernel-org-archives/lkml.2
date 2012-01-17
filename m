Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2AQIO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:14:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52374 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2AQIOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:14:24 -0500
From: Minchan Kim <minchan@kernel.org>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org,
        Rik van Riel <riel@redhat.com>, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 2/3] vmscan hook
Date: Tue, 17 Jan 2012 17:13:57 +0900
Message-Id: <1326788038-29141-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1326788038-29141-1-git-send-email-minchan@kernel.org>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch insert memory pressure notify point into vmscan.c
Most problem in system slowness is swap-in. swap-in is a synchronous
opeartion so that it affects heavily system response.

This patch alert it when reclaimer start to reclaim inactive anon list.
It seems rather earlier but not bad than too late.

Other alert point is when there is few cache pages
In this implementation, if it is (cache < free pages),
memory pressure notify happens. It has to need more testing and tuning
or other hueristic. Any suggesion are welcome.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2880396..cfa2e2d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -43,6 +43,7 @@
 #include <linux/sysctl.h>
 #include <linux/oom.h>
 #include <linux/prefetch.h>
+#include <linux/low_mem_notify.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2082,16 +2083,43 @@ static void shrink_mem_cgroup_zone(int priority, struct mem_cgroup_zone *mz,
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
+
 	enum lru_list lru;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
+#ifdef CONFIG_LOW_MEM_NOTIFY
+	bool low_mem = false;
+	unsigned long free, file;
+#endif
 
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
 	get_scan_count(mz, sc, nr, priority);
+#ifdef CONFIG_LOW_MEM_NOTIFY
+	/* We want to avoid swapout */
+	if (nr[LRU_INACTIVE_ANON])
+		low_mem = true;
+	/*
+	 * We want to avoid dropping page cache excessively
+	 * in no swap system
+	 */
+	if (nr_swap_pages <= 0) {
+		free = zone_page_state(mz->zone, NR_FREE_PAGES);
+		file = zone_page_state(mz->zone, NR_ACTIVE_FILE) +
+			zone_page_state(mz->zone, NR_INACTIVE_FILE);
+		/*
+		 * If we have very few page cache pages,
+		 * notify to user
+		 */
+		if (file < free)
+			low_mem = true;
+	}
 
+	if (low_mem)
+		low_memory_pressure();
+#endif
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-- 
1.7.7.5

