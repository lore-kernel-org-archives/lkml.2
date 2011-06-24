Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1FXNng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:43:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1FXNnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:43:23 -0400
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
Subject: [PATCH 2/4] mm: vmscan: Do not apply pressure to slab if we are not applying pressure to zone
Date: Fri, 24 Jun 2011 14:43:16 +0100
Message-Id: <1308922998-15529-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308922998-15529-1-git-send-email-mgorman@suse.de>
References: <1308922998-15529-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.
This is expected behaviour.

When kswapd applies pressure to zones during node balancing, it checks
if the zone is above a high+balance_gap threshold. If it is, it does
not apply pressure but it unconditionally shrinks slab on a global
basis which is excessive. In the event kswapd is being kept awake due to
a high small unreclaimable zone, it skips zone shrinking but still
calls shrink_slab().

Once pressure has been applied, the check for zone being unreclaimable
is being made before the check is made if all_unreclaimable should be
set. This miss of unreclaimable can cause has_under_min_watermark_zone
to be set due to an unreclaimable zone preventing kswapd backing off
on congestion_wait().

Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 841e3bf..38665ec 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2509,16 +2509,16 @@ loop_again:
 					high_wmark_pages(zone) + balance_gap,
 					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
-			reclaim_state->reclaimed_slab = 0;
-			nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
-			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
-			total_scanned += sc.nr_scanned;
 
-			if (zone->all_unreclaimable)
-				continue;
-			if (nr_slab == 0 &&
-			    !zone_reclaimable(zone))
-				zone->all_unreclaimable = 1;
+				reclaim_state->reclaimed_slab = 0;
+				nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
+				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
+				total_scanned += sc.nr_scanned;
+
+				if (nr_slab == 0 && !zone_reclaimable(zone))
+					zone->all_unreclaimable = 1;
+			}
+
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -2528,6 +2528,9 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
+			if (zone->all_unreclaimable)
+				continue;
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
-- 
1.7.3.4

