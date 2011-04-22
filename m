Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1DVBe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:34:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56195 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1DVBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:34:26 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] mm: Check if any page in a pageblock is reserved before marking it MIGRATE_RESERVE
Date: Thu, 21 Apr 2011 18:34:03 -0700
Message-Id: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
though it only had a few free pages. This in turn caused no contiguous memory
to be reserved and frequent kswapd wakeups that emptied the caches to get more
contiguous memory.

CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>

[This patch was submitted and acked a little over a year ago
(see: http://lkml.org/lkml/2010/4/6/172 ), but never seemingly
made it upstream. Resending for comments. -jstultz]

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 mm/page_alloc.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed87f3b..209d9bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3288,6 +3288,20 @@ static inline unsigned long wait_table_bits(unsigned long size)
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
 
 /*
+ * Check if a pageblock contains reserved pages
+ */
+static int pageblock_is_reserved(unsigned long start_pfn)
+{
+	unsigned long end_pfn = start_pfn + pageblock_nr_pages;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++)
+		if (PageReserved(pfn_to_page(pfn)))
+			return 1;
+	return 0;
+}
+
+/*
  * Mark a number of pageblocks as MIGRATE_RESERVE. The number
  * of blocks reserved is based on min_wmark_pages(zone). The memory within
  * the reserve will tend to store contiguous free pages. Setting min_free_kbytes
@@ -3326,7 +3340,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 			continue;
 
 		/* Blocks with reserved pages will never free, skip them. */
-		if (PageReserved(page))
+		if (pageblock_is_reserved(pfn))
 			continue;
 
 		block_migratetype = get_pageblock_migratetype(page);
-- 
1.7.3.2.146.gca209

