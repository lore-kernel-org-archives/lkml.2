Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0DFDKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:10:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:14143 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0DFDJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:09:58 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       TAO HU <tghk48@motorola.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chang Qing-A21550 <Qing.Chang@motorola.com>,
       linux-arm-kernel@lists.infradead.org,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] mm: Check if any page in a pageblock is reserved before marking it MIGRATE_RESERVE
Date: Mon,  5 Apr 2010 20:09:16 -0700
Message-Id: <1270523356-1728-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20100405101424.GA21207@csn.ul.ie>
References: <20100405101424.GA21207@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
though it only had a few free pages. This in turn caused no contiguous memory
to be reserved and frequent kswapd wakeups that emptied the caches to get more
contiguous memory.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 mm/page_alloc.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb7df1d..46ade16 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2860,6 +2860,20 @@ static inline unsigned long wait_table_bits(unsigned long size)
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
+		if (!pfn_valid_within(pfn) || PageReserved(pfn_to_page(pfn)))
+			return 1;
+	return 0;
+}
+
+/*
  * Mark a number of pageblocks as MIGRATE_RESERVE. The number
  * of blocks reserved is based on min_wmark_pages(zone). The memory within
  * the reserve will tend to store contiguous free pages. Setting min_free_kbytes
@@ -2898,7 +2912,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 			continue;
 
 		/* Blocks with reserved pages will never free, skip them. */
-		if (PageReserved(page))
+		if (pageblock_is_reserved(pfn))
 			continue;
 
 		block_migratetype = get_pageblock_migratetype(page);
-- 
1.6.5.1

