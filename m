Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694Ab0HEGP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:15:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37434 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0HEGP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:15:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 6/7] vmscan: remove PF_SWAPWRITE from __zone_reclaim()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
Message-Id: <20100805151448.31C9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:15:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When zone_reclaim() was merged at first, It always order-0
allocation with PF_SWAPWRITE flag. (probably they are both
unintional).

Former was fixed commit bd2f6199cf (vmscan: respect higher
order in zone_reclaim()). However it expose latter mistake
because !order-0 reclaim often cause dirty pages isolation
and large latency.

Now, we have good opportunity to fix latter too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f21dbeb..e043e97 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2663,7 +2663,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * and we also need to be able to write out pages for RECLAIM_WRITE
 	 * and RECLAIM_SWAP.
 	 */
-	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	p->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
@@ -2716,7 +2716,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	}
 
 	p->reclaim_state = NULL;
-	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	current->flags &= ~PF_MEMALLOC;
 	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
-- 
1.6.5.2



