Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0LJPqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:46:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55802 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab0LJPq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:46:27 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 4/6] mm: kswapd: Reset kswapd_max_order and classzone_idx after reading
Date: Fri, 10 Dec 2010 15:46:23 +0000
Message-Id: <1291995985-5913-5-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kswapd wakes up, it reads its order and classzone from pgdat and
calls balance_pgdat. While its awake, it potentially reclaimes at a high
order and a low classzone index. This might have been a once-off that
was not required by subsequent callers. However, because the pgdat
values were not reset, they remain artifically high while
balance_pgdat() is running and potentially kswapd enters a second
unnecessary reclaim cycle. Reset the pgdat order and classzone index
after reading.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4d968b0..e1be4e8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2646,6 +2646,8 @@ static int kswapd(void *p)
 			kswapd_try_to_sleep(pgdat, order);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
+			pgdat->kswapd_max_order = 0;
+			pgdat->classzone_idx = MAX_NR_ZONES - 1;
 		}
 
 		ret = try_to_freeze();
-- 
1.7.1

