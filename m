Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1IZNzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab1IZNzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:55:19 -0400
Date: Mon, 26 Sep 2011 09:55:07 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH -mm] limit direct reclaim for higher order allocations
Message-ID: <20110926095507.34a2c48c@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When suffering from memory fragmentation due to unfreeable pages,
THP page faults will repeatedly try to compact memory.  Due to
the unfreeable pages, compaction fails.

Needless to say, at that point page reclaim also fails to create
free contiguous 2MB areas.  However, that doesn't stop the current
code from trying, over and over again, and freeing a minimum of
4MB (2UL << sc->order pages) at every single invocation.

This resulted in my 12GB system having 2-3GB free memory, a
corresponding amount of used swap and very sluggish response times.

This can be avoided by having the direct reclaim code not reclaim
from zones that already have plenty of free memory available for
compaction.

If compaction still fails due to unmovable memory, doing additional
reclaim will only hurt the system, not help.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
I believe Mel has another idea in mind on how to fix this issue. 
I believe it will be good to compare both approaches side by side...

 mm/vmscan.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b7719ec..56811a1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2083,6 +2083,22 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
+			if (COMPACTION_BUILD) {
+				/*
+				 * If we already have plenty of memory free
+				 * for compaction, don't free any more.
+				 */
+				unsigned long balance_gap;
+				balance_gap = min(low_wmark_pages(zone),
+					(zone->present_pages +
+					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+					KSWAPD_ZONE_BALANCE_GAP_RATIO);
+				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
+					zone_watermark_ok_safe(zone, 0,
+					high_wmark_pages(zone) + balance_gap +
+					(2UL << sc->order), 0, 0))
+					continue;
+			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and
