Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2GSOi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:38:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab2GSOg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:36:56 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: "Linux-MM <linux-mm"@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 16/34] mm: compaction: Allow compaction to isolate dirty pages
Date: Thu, 19 Jul 2012 15:36:26 +0100
Message-Id: <1342708604-26540-17-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342708604-26540-1-git-send-email-mgorman@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a77ebd333cd810d7b680d544be88c875131c2bd3 upstream.

Stable note: Not tracked in Bugzilla. A fix aimed at preserving page aging
	information by reducing LRU list churning had the side-effect of
	reducing THP allocation success rates. This was part of a series
	to restore the success rates while preserving the reclaim fix.

Commit [39deaf85: mm: compaction: make isolate_lru_page() filter-aware]
noted that compaction does not migrate dirty or writeback pages and
that is was meaningless to pick the page and re-add it to the LRU list.

What was missed during review is that asynchronous migration moves
dirty pages if their ->migratepage callback is migrate_page() because
these can be moved without blocking. This potentially impacted
hugepage allocation success rates by a factor depending on how many
dirty pages are in the system.

This patch partially reverts 39deaf85 to allow migration to isolate
dirty pages again. This increases how much compaction disrupts the
LRU but that is addressed later in the series.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 61e68a5..afdc416 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -371,9 +371,6 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 			continue;
 		}
 
-		if (!cc->sync)
-			mode |= ISOLATE_CLEAN;
-
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
-- 
1.7.9.2

