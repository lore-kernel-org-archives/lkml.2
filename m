Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1GDOF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:05:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59567 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1GDOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:05:24 -0400
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v4 04/10] zone_reclaim: make isolate_lru_page with filter aware
Date: Mon,  4 Jul 2011 23:04:37 +0900
Message-Id: <f63c5399ed8e577832bcc9cb7dfd92d7a8227f51.1309787991.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1309787991.git.minchan.kim@gmail.com>
References: <cover.1309787991.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1309787991.git.minchan.kim@gmail.com>
References: <cover.1309787991.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __zone_reclaim case, we don't want to shrink mapped page.
Nonetheless, we have isolated mapped page and re-add it into
LRU's head. It's unnecessary CPU overhead and makes LRU churning.

Of course, when we isolate the page, the page might be mapped but
when we try to migrate the page, the page would be not mapped.
So it could be migrated. But race is rare and although it happens,
it's no big deal.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/mmzone.h |    3 +++
 mm/vmscan.c            |   20 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 84819b5..1d1791f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -164,6 +164,9 @@ static inline int is_unevictable_lru(enum lru_list l)
 #define ISOLATE_ACTIVE		((__force fmode_t)0x2)
 /* Isolate clean file */
 #define ISOLATE_CLEAN		((__force fmode_t)0x4)
+/* Isolate unmapped file */
+#define ISOLATE_UNMAPPED	((__force fmode_t)0x8)
+
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 64e78a5..0d9ae67 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1008,6 +1008,9 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
 	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
 		return ret;
 
+	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
+		return ret;
+
 	if (likely(get_page_unless_zero(page))) {
 		/*
 		 * Be careful not to clear PageLRU until after we're
@@ -1431,6 +1434,12 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 		reclaim_mode |= ISOLATE_ACTIVE;
 
 	lru_add_drain();
+
+	if (!sc->may_unmap)
+		reclaim_mode |= ISOLATE_UNMAPPED;
+	if (!sc->may_writepage)
+		reclaim_mode |= ISOLATE_CLEAN;
+
 	spin_lock_irq(&zone->lru_lock);
 
 	if (scanning_global_lru(sc)) {
@@ -1548,19 +1557,26 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
+	isolate_mode_t reclaim_mode = ISOLATE_ACTIVE;
 
 	lru_add_drain();
+
+	if (!sc->may_unmap)
+		reclaim_mode |= ISOLATE_UNMAPPED;
+	if (!sc->may_writepage)
+		reclaim_mode |= ISOLATE_CLEAN;
+
 	spin_lock_irq(&zone->lru_lock);
 	if (scanning_global_lru(sc)) {
 		nr_taken = isolate_pages_global(nr_pages, &l_hold,
 						&pgscanned, sc->order,
-						ISOLATE_ACTIVE, zone,
+						reclaim_mode, zone,
 						1, file);
 		zone->pages_scanned += pgscanned;
 	} else {
 		nr_taken = mem_cgroup_isolate_pages(nr_pages, &l_hold,
 						&pgscanned, sc->order,
-						ISOLATE_ACTIVE, zone,
+						reclaim_mode, zone,
 						sc->mem_cgroup, 1, file);
 		/*
 		 * mem_cgroup_isolate_pages() keeps track of
-- 
1.7.4.1

