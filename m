Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1KSTzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1KSTzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:55:06 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Revert "mm: compaction: make isolate_lru_page() filter-aware"
Date: Sat, 19 Nov 2011 20:54:18 +0100
Message-Id: <1321732460-14155-7-git-send-email-aarcange@redhat.com>
In-Reply-To: <1321635524-8586-1-git-send-email-mgorman@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit
39deaf8585152f1a35c1676d3d7dc6ae0fb65967.

PageDirty is non blocking for compaction (unlike for
mm/vmscan.c:may_writepage) so async compaction should include it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/compaction.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9a7fbf5..83bf33f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -261,7 +261,6 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -350,7 +349,8 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		}
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, mode, 0) != 0)
+		if (__isolate_lru_page(page,
+				ISOLATE_ACTIVE|ISOLATE_INACTIVE, 0) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
