Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1ABHgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:36:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:36906 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1ABHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 146/260] mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
Date: Sun,  2 Jan 2011 02:17:22 -0500
Message-Id: <1293952756-15010-147-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:50.0165 (UTC) FILETIME=[DCABEE50:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>

commit 9ee493ce0a60bf42c0f8fd0b0fe91df5704a1cbf upstream.

When under significant memory pressure, a process enters direct reclaim
and immediately afterwards tries to allocate a page.  If it fails and no
further progress is made, it's possible the system will go OOM.  However,
on systems with large amounts of memory, it's possible that a significant
number of pages are on per-cpu lists and inaccessible to the calling
process.  This leads to a process entering direct reclaim more often than
it should increasing the pressure on the system and compounding the
problem.

This patch notes that if direct reclaim is making progress but allocations
are still failing that the system is already under heavy pressure.  In
this case, it drains the per-cpu lists and tries the allocation a second
time before continuing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/page_alloc.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 35268ac..a2af9bc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1703,6 +1703,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
 	struct task_struct *p = current;
+	bool drained = false;
 
 	cond_resched();
 
@@ -1721,14 +1722,25 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	cond_resched();
 
-	if (order != 0)
-		drain_all_pages();
+	if (unlikely(!(*did_some_progress)))
+		return NULL;
 
-	if (likely(*did_some_progress))
-		page = get_page_from_freelist(gfp_mask, nodemask, order,
+retry:
+	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
 					migratetype);
+
+	/*
+	 * If an allocation failed after direct reclaim, it could be because
+	 * pages are pinned on the per-cpu lists. Drain them and try again
+	 */
+	if (!page && !drained) {
+		drain_all_pages();
+		drained = true;
+		goto retry;
+	}
+
 	return page;
 }
 
-- 
1.7.3.3

