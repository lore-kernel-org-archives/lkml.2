Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1KUSgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:36:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1KUSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:36:52 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] mm: compaction: Allow compaction to isolate dirty pages
Date: Mon, 21 Nov 2011 18:36:42 +0000
Message-Id: <1321900608-27687-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1321900608-27687-1-git-send-email-mgorman@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 mm/compaction.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 899d956..237560e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -349,9 +349,6 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 			continue;
 		}
 
-		if (!cc->sync)
-			mode |= ISOLATE_CLEAN;
-
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
-- 
1.7.3.4

