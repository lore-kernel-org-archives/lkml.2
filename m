Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1LARin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:38:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1LARg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:36:28 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] mm: vmscan: Do not OOM if aborting reclaim to start compaction
Date: Thu,  1 Dec 2011 17:36:14 +0000
Message-Id: <1322760981-28719-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322760981-28719-1-git-send-email-mgorman@suse.de>
References: <1322760981-28719-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When direct reclaim is entered is is possible that reclaim will be
aborted so that compaction can be attempted to satisfy a high-order
allocation.  If this decision is made before any pages are reclaimed,
it is possible for 0 to be returned to the page allocator potentially
triggering an OOM. This has not been observed but it is a possibility
so this patch addresses it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3421746..5f4c789 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2222,6 +2222,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
+	bool should_abort_reclaim;
 
 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2233,7 +2234,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		if (shrink_zones(priority, zonelist, sc))
+		should_abort_reclaim = shrink_zones(priority, zonelist, sc);
+		if (should_abort_reclaim)
 			break;
 
 		/*
@@ -2301,6 +2303,10 @@ out:
 	if (oom_killer_disabled)
 		return 0;
 
+	/* Aborting reclaim to try compaction? don't OOM, then */
+	if (should_abort_reclaim)
+		return 1;
+
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;
-- 
1.7.3.4

