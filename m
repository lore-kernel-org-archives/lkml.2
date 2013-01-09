Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab3AIVlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:41:55 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:37124 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933162Ab3AIVlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:41:53 -0500
X-Remote-IP: 213.191.128.133
Date: Wed, 09 Jan 2013 22:41:48 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <50EDE41C.7090107@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] mm: wait for congestion to clear on all zones
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130109 #9040464, check: 20130109 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 41231 [Jan 10 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zlatko Calusic <zlatko.calusic@iskon.hr>

Currently we take a short nap (HZ/10) and wait for congestion to clear
before taking another pass with lower priority in balance_pgdat(). But
we do that only for the highest zone that we encounter is unbalanced
and congested.

This patch changes that to wait on all congested zones in a single
pass in the hope that it will save us some scanning that way. Also we
take a nap as soon as congested zone is encountered and sc.priority <
DEF_PRIORITY - 2 (aka kswapd in trouble).

Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
---
The patch is against the mm tree. Make sure that
mm-avoid-calling-pgdat_balanced-needlessly.patch is applied first (not
yet in the mmotm tree). Tested on half a dozen systems with different
workloads for the last few days, working really well!

 mm/vmscan.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 002ade6..1c5d38a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2565,7 +2565,6 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 							int *classzone_idx)
 {
 	bool pgdat_is_balanced = false;
-	struct zone *unbalanced_zone;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 	unsigned long total_scanned;
@@ -2596,9 +2595,6 @@ loop_again:
 
 	do {
 		unsigned long lru_pages = 0;
-		int has_under_min_watermark_zone = 0;
-
-		unbalanced_zone = NULL;
 
 		/*
 		 * Scan in the highmem->dma direction for the highest
@@ -2739,15 +2735,20 @@ loop_again:
 			}
 
 			if (!zone_balanced(zone, testorder, 0, end_zone)) {
-				unbalanced_zone = zone;
-				/*
-				 * We are still under min water mark.  This
-				 * means that we have a GFP_ATOMIC allocation
-				 * failure risk. Hurry up!
-				 */
+			    if (total_scanned && sc.priority < DEF_PRIORITY - 2) {
+				/* OK, kswapd is getting into trouble. */
 				if (!zone_watermark_ok_safe(zone, order,
 					    min_wmark_pages(zone), end_zone, 0))
-					has_under_min_watermark_zone = 1;
+				    /*
+				     * We are still under min water mark.
+				     * This means that we have a GFP_ATOMIC
+				     * allocation failure risk. Hurry up!
+				     */
+				    count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
+				else
+				    /* Take a nap if a zone is congested. */
+				    wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
+			    }
 			} else {
 				/*
 				 * If a zone reaches its high watermark,
@@ -2758,7 +2759,6 @@ loop_again:
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
 			}
-
 		}
 
 		/*
@@ -2776,17 +2776,6 @@ loop_again:
 		}
 
 		/*
-		 * OK, kswapd is getting into trouble.  Take a nap, then take
-		 * another pass across the zones.
-		 */
-		if (total_scanned && (sc.priority < DEF_PRIORITY - 2)) {
-			if (has_under_min_watermark_zone)
-				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
-			else if (unbalanced_zone)
-				wait_iff_congested(unbalanced_zone, BLK_RW_ASYNC, HZ/10);
-		}
-
-		/*
 		 * We do this so kswapd doesn't build up large priorities for
 		 * example when it is freeing in parallel with allocators. It
 		 * matches the direct reclaim path behaviour in terms of impact
-- 
1.8.1

-- 
Zlatko
