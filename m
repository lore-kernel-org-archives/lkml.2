Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0DBJNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:13:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33804 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0DBJNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:13:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100401151639.a030fb10.akpm@linux-foundation.org>
References: <20100331145602.03A7.A69D9226@jp.fujitsu.com> <20100401151639.a030fb10.akpm@linux-foundation.org>
Message-Id: <20100402180812.646D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Apr 2010 18:13:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yeah, I don't want ignore .33-stable too. if I can't find the root cause
> > in 2-3 days, I'll revert guilty patch anyway.
> > 
> 
> It's a good idea to avoid fixing a bug one-way-in-stable,
> other-way-in-mainline.  Because then we have new code in both trees
> which is different.  And the -stable guys sensibly like to see code get
> a bit of a shakedown in mainline before backporting it.
> 
> So it would be better to merge the "simple" patch into mainline, tagged
> for -stable backporting.  Then we can later implement the larger fix in
> mainline, perhaps starting by reverting the "simple" fix.

.....ok. I don't have to prevent your code maintainship. although I still 
think we need to fix the issue completely.


===================================================================
>From 52358cbccdfe94e0381974cd6e937bcc6b1c608b Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 2 Apr 2010 17:13:48 +0900
Subject: [PATCH] Revert "vmscan: get_scan_ratio() cleanup"

Shaohua Li reported his tmpfs streaming I/O test can lead to make oom.
The test uses a 6G tmpfs in a system with 3G memory. In the tmpfs,
there are 6 copies of kernel source and the test does kbuild for each
copy. His investigation shows the test has a lot of rotated anon
pages and quite few file pages, so get_scan_ratio calculates percent[0]
(i.e. scanning percent for anon)  to be zero. Actually the percent[0]
shoule be a big value, but our calculation round it to zero.

Although before commit 84b18490, we have the same sick too. but the old
logic can rescue percent[0]==0 case only when priority==0. It had hided
the real issue. I didn't think merely streaming io can makes percent[0]==0
&& priority==0 situation. but I was wrong.

So, definitely we have to fix such tmpfs streaming io issue. but anyway
I revert the regression commit at first.

This reverts commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26.

Reported-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79c8098..cb3947e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1535,13 +1535,6 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		percent[0] = 0;
-		percent[1] = 100;
-		return;
-	}
-
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1639,20 +1632,22 @@ static void shrink_zone(int priority, struct zone *zone,
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	int noswap = 0;
 
-	get_scan_ratio(zone, sc, percent);
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		noswap = 1;
+		percent[0] = 0;
+		percent[1] = 100;
+	} else
+		get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
-		if (percent[file] == 0) {
-			nr[l] = 0;
-			continue;
-		}
-
 		scan = zone_nr_lru_pages(zone, sc, l);
-		if (priority) {
+		if (priority || noswap) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-- 
1.6.5.2





