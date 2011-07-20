Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1GTCxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 22:53:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:42320 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab1GTCxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 22:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,232,1309762800"; 
   d="scan'208";a="30025147"
Subject: [PATCH]vmscan: add block plug for page reclaim
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 10:53:33 +0800
Message-ID: <1311130413.15392.326.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

per-task block plug can reduce block queue lock contention and increase request
merge. Currently page reclaim doesn't support it. I originally thought page
reclaim doesn't need it, because kswapd thread count is limited and file cache
write is done at flusher mostly.
When I test a workload with heavy swap in a 4-node machine, each CPU is doing
direct page reclaim and swap. This causes block queue lock contention. In my
test, without below patch, the CPU utilization is about 2% ~ 7%. With the
patch, the CPU utilization is about 1% ~ 3%. Disk throughput isn't changed.
This should improve normal kswapd write and file cache write too (increase
request merge for example), but might not be so obvious as I explain above.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ed24b9..8ec04b2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1933,12 +1933,14 @@ static void shrink_zone(int priority, struct zone *zone,
 	enum lru_list l;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	struct blk_plug plug;
 
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
 	get_scan_count(zone, sc, nr, priority);
 
+	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -1962,6 +1964,7 @@ restart:
 		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
+	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
 
 	/*


