Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2HHA4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:56:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54962 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2HHA4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:56:16 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-5d-5021b92e07c1
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] compaction: fix deferring compaction mistake
Date: Wed,  8 Aug 2012 09:57:44 +0900
Message-Id: <1344387464-10037-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] fixed bad deferring policy but made mistake about checking
compact_order_failed in __compact_pgdat so it can't update
compact_order_failed with new order. It ends up preventing working
of deffering policy rightly. This patch fixes it.

[1] aff62249, vmscan: only defer compaction for failed order and higher

Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index e78cb96..b6984e2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -861,7 +861,7 @@ static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 		if (cc->order > 0) {
 			int ok = zone_watermark_ok(zone, cc->order,
 						low_wmark_pages(zone), 0, 0);
-			if (ok && cc->order > zone->compact_order_failed)
+			if (ok && cc->order >= zone->compact_order_failed)
 				zone->compact_order_failed = cc->order + 1;
 			/* Currently async compaction is never deferred. */
 			else if (!ok && cc->sync)
-- 
1.7.9.5

