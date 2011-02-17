Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1BQPJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:09:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51124 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1BQPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dQFowhWhByUEbC9vDn+ut6lZheifTqY+GuugIoFRA5knGqr6nq4KqSqGHDNThf5ooE
         DBMC8v0NFciHrZM9XspaXEOvGeYOuQWVosppl8XTegu8TxXm1697HsJcfQ7sEeHNsQQh
         EWLg0oC0xA2DSnpDLwODNv3C53yeh4eGbzDJE=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v5 4/4] add profile information for invalidated page
Date: Fri, 18 Feb 2011 00:08:22 +0900
Message-Id: <7563767d6b6e841a8ac5f8315ee166e0f039723c.1297940291.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1297940291.git.minchan.kim@gmail.com>
References: <cover.1297940291.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1297940291.git.minchan.kim@gmail.com>
References: <cover.1297940291.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds profile information about invalidated page reclaim.
It's just for profiling for test so it is never for merging.

Acked-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/vmstat.h |    4 ++--
 mm/swap.c              |    3 +++
 mm/vmstat.c            |    3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 833e676..c38ad95 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -30,8 +30,8 @@
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
-		PGFREE, PGACTIVATE, PGDEACTIVATE,
-		PGFAULT, PGMAJFAULT,
+		PGFREE, PGACTIVATE, PGDEACTIVATE, PGINVALIDATE,
+		PGRECLAIM, PGFAULT, PGMAJFAULT,
 		FOR_ALL_ZONES(PGREFILL),
 		FOR_ALL_ZONES(PGSTEAL),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
diff --git a/mm/swap.c b/mm/swap.c
index 0a33714..980c17b 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -397,6 +397,7 @@ static void lru_deactivate(struct page *page, struct zone *zone)
 		 * is _really_ small and  it's non-critical problem.
 		 */
 		SetPageReclaim(page);
+		__count_vm_event(PGRECLAIM);
 	} else {
 		/*
 		 * The page's writeback ends up during pagevec
@@ -409,6 +410,8 @@ static void lru_deactivate(struct page *page, struct zone *zone)
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
+
+	__count_vm_event(PGINVALIDATE);
 	update_page_reclaim_stat(zone, page, file, 0);
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 0c3b504..cbe032b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -896,6 +896,9 @@ static const char * const vmstat_text[] = {
 	"pgactivate",
 	"pgdeactivate",
 
+	"pginvalidate",
+	"pgreclaim",
+
 	"pgfault",
 	"pgmajfault",
 
-- 
1.7.1

