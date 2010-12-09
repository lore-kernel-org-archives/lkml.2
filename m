Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0LILS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 06:18:28 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47695 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0LILSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 06:18:24 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 5/6] mm: kswapd: Treat zone->all_unreclaimable in sleeping_prematurely similar to balance_pgdat()
Date: Thu,  9 Dec 2010 11:18:19 +0000
Message-Id: <1291893500-12342-6-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After DEF_PRIORITY, balance_pgdat() considers all_unreclaimable zones to
be balanced but sleeping_prematurely does not. This can force kswapd to
stay awake longer than it should. This patch fixes it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc233d8..d7b0a3c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2149,8 +2149,16 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone->all_unreclaimable)
+		/*
+		 * balance_pgdat() skips over all_unreclaimable after
+		 * DEF_PRIORITY. Effectively, it considers them balanced so
+		 * they must be considered balanced here as well if kswapd
+		 * is to sleep
+		 */
+		if (zone->all_unreclaimable) {
+			balanced += zone->present_pages;
 			continue;
+		}
 
 		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
 								0, 0))
-- 
1.7.1

