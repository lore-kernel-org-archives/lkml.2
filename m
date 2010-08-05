Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab0HEGNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:13:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37281 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0HEGNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:13:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/7] vmscan: synchronous lumpy reclaim don't call congestion_wait()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
Message-Id: <20100805151229.31BD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:13:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

congestion_wait() mean "waiting quueue congestion is cleared".
That said, if the system have plenty dirty pages and flusher thread push
new request to IO queue conteniously, IO queue are not cleared
congestion status for long time. thus, congestion_wait(HZ/10) become
almostly equivalent schedule_timeout(HZ/10).

However, synchronous lumpy reclaim donesn't need this
congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) are
using wait_on_page_writeback() and it provide sufficient waiting.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cf51d62..1cdc3db 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1341,7 +1341,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
 		/*
 		 * The attempt at page out may have made some
 		 * of the pages active, mark them inactive again.
-- 
1.6.5.2



