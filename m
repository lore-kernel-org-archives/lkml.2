Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0LERa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:30:26 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60513 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab0LERaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UU2QKEZMw1bPf7XYJIYhGQqqcSHNp6HpC9Cl9qdZxuXlJE2hefJoP2Rcu/tI4PYePz
         +uZzU3VB4BTlimwxPIsuh+91OcUrf0ePvi9RrBsX081qpn+xPzEt88xtzDUyx9L3xdbd
         Njo3+bZ0r4B6e1pwpnUGKDhtlswxcP7CpELU0=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH v4 5/7] add profile information for invalidated page reclaim
Date: Mon,  6 Dec 2010 02:29:13 +0900
Message-Id: <dff7a42e5877b23a3cc3355743da4b7ef37299f8.1291568905.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds profile information about invalidated page reclaim.
It's just for profiling for test so it would be discard when the series
are merged.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
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
index 0f23998..2f21e6e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -317,6 +317,7 @@ static void lru_deactivate(struct page *page, struct zone *zone)
 		 * is _really_ small and  it's non-critical problem.
 		 */
 		SetPageReclaim(page);
+		__count_vm_event(PGRECLAIM);
 	} else {
 		/*
 		 * The page's writeback ends up during pagevec
@@ -328,6 +329,8 @@ static void lru_deactivate(struct page *page, struct zone *zone)
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
+
+	__count_vm_event(PGINVALIDATE);
 	update_page_reclaim_stat(zone, page, file, 0);
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3555636..ef6102d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -818,6 +818,9 @@ static const char * const vmstat_text[] = {
 	"pgactivate",
 	"pgdeactivate",
 
+	"pginvalidate",
+	"pgreclaim",
+
 	"pgfault",
 	"pgmajfault",
 
-- 
1.7.0.4

