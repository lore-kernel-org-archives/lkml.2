Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0HAJMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 05:12:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36838 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0HAJMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 05:12:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Andy Whitcroft <apw@shadowen.org>, Rik van Riel <riel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
In-Reply-To: <20100801085134.GA15577@localhost>
References: <20100801085134.GA15577@localhost>
Message-Id: <20100801180751.4B0E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  1 Aug 2010 18:12:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rebased onto Wu's patch

----------------------------------------------
>From 35772ad03e202c1c9a2252de3a9d3715e30d180f Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sun, 1 Aug 2010 17:23:41 +0900
Subject: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()

congestion_wait() mean "waiting for number of requests in IO queue is
under congestion threshold".
That said, if the system have plenty dirty pages, flusher thread push
new request to IO queue conteniously. So, IO queue are not cleared
congestion status for a long time. thus, congestion_wait(HZ/10) is
almostly equivalent schedule_timeout(HZ/10).

If the system 512MB memory, DEF_PRIORITY mean 128kB scan and It takes 4096
shrink_page_list() calls to scan 128kB (i.e. 128kB/32=4096) memory.
4096 times 0.1sec stall makes crazy insane long stall. That shouldn't.

In the other hand, this synchronous lumpy reclaim donesn't need this
congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) cause to
call wait_on_page_writeback() and it provide sufficient waiting.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

---
 mm/vmscan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 972c8f0..c5e673e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1339,8 +1339,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
-
 		/*
 		 * The attempt at page out may have made some
 		 * of the pages active, mark them inactive again.
-- 
1.6.5.2



