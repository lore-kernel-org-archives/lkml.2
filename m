Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2GSOhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:37:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2GSOhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:37:00 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: "Linux-MM <linux-mm"@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 21/34] kswapd: assign new_order and new_classzone_idx after wakeup in sleeping
Date: Thu, 19 Jul 2012 15:36:31 +0100
Message-Id: <1342708604-26540-22-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342708604-26540-1-git-send-email-mgorman@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alex,Shi" <alex.shi@intel.com>

commit d2ebd0f6b89567eb93ead4e2ca0cbe03021f344b upstream.

Stable note: Fixes https://bugzilla.redhat.com/show_bug.cgi?id=712019. This
	patch reduces kswapd CPU usage.

There 2 places to read pgdat in kswapd.  One is return from a successful
balance, another is waked up from kswapd sleeping.  The new_order and
new_classzone_idx represent the balance input order and classzone_idx.

But current new_order and new_classzone_idx are not assigned after
kswapd_try_to_sleep(), that will cause a bug in the following scenario.

1: after a successful balance, kswapd goes to sleep, and new_order = 0;
   new_classzone_idx = __MAX_NR_ZONES - 1;

2: kswapd waked up with order = 3 and classzone_idx = ZONE_NORMAL

3: in the balance_pgdat() running, a new balance wakeup happened with
   order = 5, and classzone_idx = ZONE_NORMAL

4: the first wakeup(order = 3) finished successufly, return order = 3
   but, the new_order is still 0, so, this balancing will be treated as a
   failed balance.  And then the second tighter balancing will be missed.

So, to avoid the above problem, the new_order and new_classzone_idx need
to be assigned for later successful comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: Pádraig Brady <P@draigBrady.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf85e4d..b8c1fc0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2905,6 +2905,8 @@ static int kswapd(void *p)
 						balanced_classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
+			new_order = order;
+			new_classzone_idx = classzone_idx;
 			pgdat->kswapd_max_order = 0;
 			pgdat->classzone_idx = pgdat->nr_zones - 1;
 		}
-- 
1.7.9.2

