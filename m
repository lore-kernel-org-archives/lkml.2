Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2LQSNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:13:44 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36560 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2LQSNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:13:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/7] mm: memcg: only evict file pages when we have plenty
Date: Mon, 17 Dec 2012 13:12:31 -0500
Message-Id: <1355767957-4913-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e986850 "mm, vmscan: only evict file pages when we have plenty" makes
a point of not going for anonymous memory while there is still enough
inactive cache around.

The check was added only for global reclaim, but it is just as useful
to reduce swapping in memory cgroup reclaim:

200M-memcg-defconfig-j2

                                 vanilla                   patched
Real time              454.06 (  +0.00%)         453.71 (  -0.08%)
User time              668.57 (  +0.00%)         668.73 (  +0.02%)
System time            128.92 (  +0.00%)         129.53 (  +0.46%)
Swap in               1246.80 (  +0.00%)         814.40 ( -34.65%)
Swap out              1198.90 (  +0.00%)         827.00 ( -30.99%)
Pages allocated   16431288.10 (  +0.00%)    16434035.30 (  +0.02%)
Major faults           681.50 (  +0.00%)         593.70 ( -12.86%)
THP faults             237.20 (  +0.00%)         242.40 (  +2.18%)
THP collapse           241.20 (  +0.00%)         248.50 (  +3.01%)
THP splits             157.30 (  +0.00%)         161.40 (  +2.59%)

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmscan.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7f30961..249ff94 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1688,19 +1688,21 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			fraction[1] = 0;
 			denominator = 1;
 			goto out;
-		} else if (!inactive_file_is_low_global(zone)) {
-			/*
-			 * There is enough inactive page cache, do not
-			 * reclaim anything from the working set right now.
-			 */
-			fraction[0] = 0;
-			fraction[1] = 1;
-			denominator = 1;
-			goto out;
 		}
 	}
 
 	/*
+	 * There is enough inactive page cache, do not reclaim
+	 * anything from the anonymous working set right now.
+	 */
+	if (!inactive_file_is_low(lruvec)) {
+		fraction[0] = 0;
+		fraction[1] = 1;
+		denominator = 1;
+		goto out;
+	}
+
+	/*
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-- 
1.7.11.7

