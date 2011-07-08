Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1GHFCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab1GHFCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:56 2011
Message-Id: <20110708001656.895821746@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [043/107] mm/memory-failure.c: fix page isolated count mismatch
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Minchan Kim <minchan.kim@gmail.com>

commit 5db8a73a8d7cc6a66afbf25ed7fda338caa8f5f9 upstream.

Pages isolated for migration are accounted with the vmstat counters
NR_ISOLATE_[ANON|FILE].  Callers of migrate_pages() are expected to
increment these counters when pages are isolated from the LRU.  Once the
pages have been migrated, they are put back on the LRU or freed and the
isolated count is decremented.

Memory failure is not properly accounting for pages it isolates causing
the NR_ISOLATED counters to be negative.  On SMP builds, this goes
unnoticed as negative counters are treated as 0 due to expected per-cpu
drift.  On UP builds, the counter is treated by too_many_isolated() as a
large value causing processes to enter D state during page reclaim or
compaction.  This patch accounts for pages isolated by memory failure
correctly.

[mel@csn.ul.ie: rewrote changelog]
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory-failure.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/mm_inline.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1463,7 +1464,8 @@ int soft_offline_page(struct page *page,
 	ret = isolate_lru_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
-
+		inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 								0, true);


