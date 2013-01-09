Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3AIGVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:21:22 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44917 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3AIGVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:21:19 -0500
X-AuditID: 9c930179-b7c7fae00000255c-af-50ed0c5c3808
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/2] mm: forcely swapout when we are out of page cache
Date: Wed,  9 Jan 2013 15:21:14 +0900
Message-Id: <1357712474-27595-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357712474-27595-1-git-send-email-minchan@kernel.org>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If laptop_mode is enable, VM try to avoid I/O for saving the power.
But if there isn't reclaimable memory without I/O, we should do I/O
for preventing unnecessary OOM kill although we sacrifices power.

One of example is that we are out of page cache. Remained one is
only anonymous pages, for swapping out, we needs may_writepage = 1.

Reported-by: Luigi Semenzato <semenzato@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 439cc47..624c816 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1728,6 +1728,12 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		free = zone_page_state(zone, NR_FREE_PAGES);
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
+			/*
+			 * From now on, we have to swap out
+			 * for peventing OOM kill although
+			 * we sacrifice power consumption.
+			 */
+			sc->may_writepage = 1;
 			goto out;
 		}
 	}
-- 
1.7.9.5

