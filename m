Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2LFVLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:11:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2LFVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:11:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6918"; a="12203995"
From: Laura Abbott <lauraa@codeaurora.org>
To: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH v3] mm: Use aligned zone start for pfn_to_bitidx calculation
Date: Thu,  6 Dec 2012 13:11:41 -0800
Message-Id: <1354828301-27849-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current calculation in pfn_to_bitidx assumes that
(pfn - zone->zone_start_pfn) >> pageblock_order will return the
same bit for all pfn in a pageblock. If zone_start_pfn is not
aligned to pageblock_nr_pages, this may not always be correct.

Consider the following with pageblock order = 10, zone start 2MB:

pfn     | pfn - zone start | (pfn - zone start) >> page block order
----------------------------------------------------------------
0x26000 | 0x25e00	   |  0x97
0x26100 | 0x25f00	   |  0x97
0x26200 | 0x26000	   |  0x98
0x26300 | 0x26100	   |  0x98

This means that calling {get,set}_pageblock_migratetype on a single
page will not set the migratetype for the full block. Fix this by
rounding down zone_start_pfn when doing the bitidx calculation.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 92dd060..b6a2510 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5422,7 +5422,7 @@ static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - zone->zone_start_pfn;
+	pfn = pfn - round_down(zone->zone_start_pfn, pageblock_nr_pages);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

