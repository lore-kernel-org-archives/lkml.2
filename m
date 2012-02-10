Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2BJRcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:32:48 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12028 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2BJRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:32:44 -0500
Date: Fri, 10 Feb 2012 18:32:18 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv21 03/16] mm: compaction: introduce map_pages()
In-reply-to: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1328895151-5196-4-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit creates a map_pages() function which map pages freed
using split_free_pages().  This merely moves some code from
isolate_freepages() so that it can be reused in other places.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/compaction.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 62902b6..9bbcc53 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -127,6 +127,16 @@ static bool suitable_migration_target(struct page *page)
 	return false;
 }
 
+static void map_pages(struct list_head *list)
+{
+	struct page *page;
+
+	list_for_each_entry(page, list, lru) {
+		arch_alloc_page(page, 0);
+		kernel_map_pages(page, 1, 1);
+	}
+}
+
 /*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
@@ -206,10 +216,7 @@ static void isolate_freepages(struct zone *zone,
 	}
 
 	/* split_free_page does not map the pages */
-	list_for_each_entry(page, freelist, lru) {
-		arch_alloc_page(page, 0);
-		kernel_map_pages(page, 1, 1);
-	}
+	map_pages(freelist);
 
 	cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
-- 
1.7.1.569.g6f426

