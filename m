Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2LLVom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:44:42 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36200 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab2LLVoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:44:38 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 2/8] mm: vmscan: disregard swappiness shortly before going OOM
Date: Wed, 12 Dec 2012 16:43:34 -0500
Message-Id: <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a reclaim scanner is doing its final scan before giving up and
there is swap space available, pay no attention to swappiness
preference anymore.  Just swap.

Note that this change won't make too big of a difference for general
reclaim: anonymous pages are already force-scanned when there is only
very little file cache left, and there very likely isn't when the
reclaimer enters this final cycle.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3874dcb..6e53446 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1751,7 +1751,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		unsigned long scan;
 
 		scan = get_lru_size(lruvec, lru);
-		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
+		if (sc->priority || noswap) {
 			scan >>= sc->priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
-- 
1.7.11.7

