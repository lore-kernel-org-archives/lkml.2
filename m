Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab1GKNBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:01:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab1GKNBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:01:18 -0400
From: Mel Gorman <mgorman@suse.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/3] mm: vmscan: Do use use PF_SWAPWRITE from zone_reclaim
Date: Mon, 11 Jul 2011 14:01:12 +0100
Message-Id: <1310389274-13995-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310389274-13995-1-git-send-email-mgorman@suse.de>
References: <1310389274-13995-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zone reclaim is similar to direct reclaim in a number of respects.
PF_SWAPWRITE is used by kswapd to avoid a write-congestion check
but it's set also set for zone_reclaim which is inappropriate.
Setting it potentially allows zone_reclaim users to cause large IO
stalls which is worse than remote memory accesses.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4f49535..ebef213 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3063,7 +3063,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * and we also need to be able to write out pages for RECLAIM_WRITE
 	 * and RECLAIM_SWAP.
 	 */
-	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	p->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
@@ -3116,7 +3116,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	}
 
 	p->reclaim_state = NULL;
-	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	current->flags &= ~PF_MEMALLOC;
 	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
-- 
1.7.3.4

