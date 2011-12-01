Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1LARg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:36:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1LARg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:36:27 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] mm: vmscan: Check if we isolated a compound page during lumpy scan
Date: Thu,  1 Dec 2011 17:36:13 +0000
Message-Id: <1322760981-28719-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322760981-28719-1-git-send-email-mgorman@suse.de>
References: <1322760981-28719-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

Properly take into account if we isolated a compound page during the
lumpy scan in reclaim and skip over the tail pages when encountered.
This corrects the values given to the tracepoint for number of lumpy
pages isolated and will avoid breaking the loop early if compound
pages smaller than the requested allocation size are requested.

[mgorman@suse.de: Updated changelog]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a1893c0..3421746 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1183,13 +1183,16 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
+				unsigned int isolated_pages;
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-				nr_taken += hpage_nr_pages(page);
-				nr_lumpy_taken++;
+				isolated_pages = hpage_nr_pages(page);
+				nr_taken += isolated_pages;
+				nr_lumpy_taken += isolated_pages;
 				if (PageDirty(cursor_page))
-					nr_lumpy_dirty++;
+					nr_lumpy_dirty += isolated_pages;
 				scan++;
+				pfn += isolated_pages-1;
 			} else {
 				/*
 				 * Check if the page is freed already.
-- 
1.7.3.4

