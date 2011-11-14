Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab1HaPmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:42:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38973 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1HaPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:42:15 -0400
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH] vmscan: Do reclaim stall in case of mlocked page.
Date: Tue, 15 Nov 2011 00:37:23 +0900
Message-Id: <1321285043-3470-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] made avoid unnecessary reclaim stall when second shrink_page_list(ie, synchronous
shrink_page_list) try to reclaim page_list which has not-dirty pages.
But it seems rather awkawrd on unevictable page.
The unevictable page in shrink_page_list would be moved into unevictable lru from page_list.
So it would be not on page_list when shrink_page_list returns.
Nevertheless it skips reclaim stall.

This patch fixes it so that it can do reclaim stall in case of mixing mlocked pages
and writeback pages on page_list.

[1] 7d3579e,vmscan: narrow the scenarios in whcih lumpy reclaim uses synchrounous reclaim

CC: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <jweiner@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2300342..23878de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -987,7 +987,6 @@ cull_mlocked:
 			try_to_free_swap(page);
 		unlock_page(page);
 		putback_lru_page(page);
-		reset_reclaim_mode(sc);
 		continue;
 
 activate_locked:
-- 
1.7.6

