Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1HCArs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:47:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:35149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1HCArn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:47:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="3578335"
Subject: Re: [PATCH] kswapd: avoid unnecessary rebalance after an
 unsuccessful balancing
From: "Alex,Shi" <alex.shi@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "P@draigBrady.com" <P@draigBrady.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrea@cpushare.com" <andrea@cpushare.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "riel@redhat.com" <riel@redhat.com>, "luto@mit.edu" <luto@mit.edu>
In-Reply-To: <20110802102231.GC10436@suse.de>
References: <1311952990-3844-1-git-send-email-alex.shi@intel.com>
	 <20110729154031.GV3010@suse.de> <1312159517.27358.2446.camel@debian>
	 <20110802102231.GC10436@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 08:49:42 +0800
Message-ID: <1312332582.27358.2540.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You're right. I was thinking only of classzone_idx. I see the point now.
> 
> Acked-by: Mel Gorman <mgorman@suse.de>

Thanks for your 'Ack', I want to follow your commit comments and correct
a coding style issue, so I rewrite the patch here.

--------------

In commit 215ddd66, Mel Gorman said kswapd is better to sleep after a
unsuccessful balancing if there is tighter reclaim request pending in
the balancing. But in the following scenario, kswapd do something that
is not matched our expectation. The patch fixes this issue.

1, Read pgdat request A (classzone_idx, order = 3)
2, balance_pgdat()
3,    During pgdat, a new pgdat request B (classzone_idx, order = 5) is
placed
4, balance_pgdat() returns but failed since returned order = 0
5, pgdat of request A assigned to balance_pgdat(), and do balancing
again. While the expectation behavior of kswapd should try to sleep.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eb7bcce..ed8c84c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2792,7 +2792,9 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
 static int kswapd(void *p)
 {
 	unsigned long order, new_order;
+	unsigned balanced_order;
 	int classzone_idx, new_classzone_idx;
+	int balanced_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -2823,7 +2825,9 @@ static int kswapd(void *p)
 	set_freezable();
 
 	order = new_order = 0;
+	balanced_order = 0;
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
+	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
 		int ret;
 
@@ -2832,7 +2836,8 @@ static int kswapd(void *p)
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (classzone_idx >= new_classzone_idx && order == new_order) {
+		if (balanced_classzone_idx >= new_classzone_idx &&
+					balanced_order == new_order) {
 			new_order = pgdat->kswapd_max_order;
 			new_classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order =  0;
@@ -2847,7 +2852,8 @@ static int kswapd(void *p)
 			order = new_order;
 			classzone_idx = new_classzone_idx;
 		} else {
-			kswapd_try_to_sleep(pgdat, order, classzone_idx);
+			kswapd_try_to_sleep(pgdat, balanced_order,
+						balanced_classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
 			new_order = order;
@@ -2866,7 +2872,9 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			order = balance_pgdat(pgdat, order, &classzone_idx);
+			balanced_classzone_idx = classzone_idx;
+			balanced_order = balance_pgdat(pgdat, order,
+						&balanced_classzone_idx);
 		}
 	}
 	return 0;
-- 
1.6.3.3



