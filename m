Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab1FXOpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:45:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab1FXOpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:45:01 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/4] mm: vmscan: Correct check for kswapd sleeping in sleeping_prematurely
Date: Fri, 24 Jun 2011 15:44:54 +0100
Message-Id: <1308926697-22475-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308926697-22475-1-git-send-email-mgorman@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.
This is expected behaviour.

A problem occurs if the highest zone is small.  balance_pgdat()
only considers unreclaimable zones when priority is DEF_PRIORITY
but sleeping_prematurely considers all zones. It's possible for this
sequence to occur

  1. kswapd wakes up and enters balance_pgdat()
  2. At DEF_PRIORITY, marks highest zone unreclaimable
  3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
  4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
        highest zone, clearing all_unreclaimable. Highest zone
        is still unbalanced
  5. kswapd returns and calls sleeping_prematurely
  6. sleeping_prematurely looks at *all* zones, not just the ones
     being considered by balance_pgdat. The highest small zone
     has all_unreclaimable cleared but but the zone is not
     balanced. all_zones_ok is false so kswapd stays awake

This patch corrects the behaviour of sleeping_prematurely to check
the zones balance_pgdat() checked.

Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ff834e..841e3bf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2323,7 +2323,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
 		return true;
 
 	/* Check the watermark levels */
-	for (i = 0; i < pgdat->nr_zones; i++) {
+	for (i = 0; i <= classzone_idx; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
 		if (!populated_zone(zone))
-- 
1.7.3.4

