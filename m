Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2IZMNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:13:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab2IZMNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:13:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>, Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mm: Fix build with CMA && !CONFIG_COMPACTION
Date: Wed, 26 Sep 2012 13:13:06 +0100
Message-Id: <1348661586-22970-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In -next 20120926 "mm: compaction: cache if a pageblock was scanned and
no pages were isolated" adds pageblock skipping operations used when CMA
is enabled but only provides them if CONFIG_COMPACTION is defined, breaking
the build. Fix this by also providing them when only CONFIG_CMA is enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/pageblock-flags.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index eed27f4..8d67f30 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -30,9 +30,9 @@ enum pageblock_bits {
 	PB_migrate,
 	PB_migrate_end = PB_migrate + 3 - 1,
 			/* 3 bits required for migrate types */
-#ifdef CONFIG_COMPACTION
+#if defined(CONFIG_COMPACTION) || defined(CONFIG_CMA)
 	PB_migrate_skip,/* If set the block is skipped by compaction */
-#endif /* CONFIG_COMPACTION */
+#endif /* CONFIG_COMPACTION || CONFIG_CMA */
 	NR_PAGEBLOCK_BITS
 };
 
@@ -68,7 +68,7 @@ unsigned long get_pageblock_flags_group(struct page *page,
 void set_pageblock_flags_group(struct page *page, unsigned long flags,
 					int start_bitidx, int end_bitidx);
 
-#ifdef CONFIG_COMPACTION
+#if defined(CONFIG_COMPACTION) || defined(CONFIG_CMA)
 #define get_pageblock_skip(page) \
 			get_pageblock_flags_group(page, PB_migrate_skip,     \
 							PB_migrate_skip + 1)
@@ -78,7 +78,7 @@ void set_pageblock_flags_group(struct page *page, unsigned long flags,
 #define set_pageblock_skip(page) \
 			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
 							PB_migrate_skip + 1)
-#endif /* CONFIG_COMPACTION */
+#endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
 #define get_pageblock_flags(page) \
 			get_pageblock_flags_group(page, 0, PB_migrate_end)
-- 
1.7.10.4

