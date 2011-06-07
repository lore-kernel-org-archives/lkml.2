Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1FGPHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:07:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:58537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1FGPHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:07:11 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Thomas Sattler <tsattler@gmx.de>,
        Ury Stankevich <urykhy@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] mm: memory-failure: Fix isolated page count during memory failure
Date: Tue,  7 Jun 2011 16:07:04 +0100
Message-Id: <1307459225-4481-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307459225-4481-1-git-send-email-mgorman@suse.de>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minchan Kim <minchan.kim@gmail.com>

From: Minchan Kim <minchan.kim@gmail.com>

Pages isolated for migration are accounted with the vmstat counters
NR_ISOLATE_[ANON|FILE]. Callers of migrate_pages() are expected to
increment these counters when pages are isolated from the LRU. Once
the pages have been migrated, they are put back on the LRU or freed
and the isolated count is decremented.

Memory failure is not properly accounting for pages it isolates
causing the NR_ISOLATED counters to be negative. On SMP builds,
this goes unnoticed as negative counters are treated as 0 due to
expected per-cpu drift. On UP builds, the counter is treated by
too_many_isolated() as a large value causing processes to enter D
state during page reclaim or compaction. This patch accounts for
pages isolated by memory failure correctly.

[mgorman@suse.de: Updated changelog]
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/memory-failure.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5c8f7e0..eac0ba5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/mm_inline.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1468,7 +1469,8 @@ int soft_offline_page(struct page *page, int flags)
 	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
-
+		inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 								0, true);
-- 
1.7.3.4

