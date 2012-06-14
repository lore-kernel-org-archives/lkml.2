Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab2FNQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:16:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42409 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2FNQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:16:25 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH] mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator again
Date: Thu, 14 Jun 2012 12:16:10 -0400
Message-Id: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
another miuse still exist.

This patch fixes it.

Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5716b00..4e7059d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1157,8 +1157,10 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 		to_drain = pcp->batch;
 	else
 		to_drain = pcp->count;
-	free_pcppages_bulk(zone, to_drain, pcp);
-	pcp->count -= to_drain;
+	if (to_drain > 0) {
+		free_pcppages_bulk(zone, to_drain, pcp);
+		pcp->count -= to_drain;
+	}
 	local_irq_restore(flags);
 }
 #endif
@@ -3914,7 +3916,8 @@ static int __zone_pcp_update(void *data)
 		pcp = &pset->pcp;
 
 		local_irq_save(flags);
-		free_pcppages_bulk(zone, pcp->count, pcp);
+		if (pcp->count > 0)
+			free_pcppages_bulk(zone, pcp->count, pcp);
 		setup_pageset(pset, batch);
 		local_irq_restore(flags);
 	}
-- 
1.7.1

