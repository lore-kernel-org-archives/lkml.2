Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2BTRXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:23:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2BTRXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:23:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.129.86 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 18/22] mm: handle lruvec relocks in compaction
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:23:43 +0400
Message-ID: <20120220172343.22196.39552.stgit@zurg>
In-Reply-To: <20120220171138.22196.65847.stgit@zurg>
References: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for lru_lock splitting in memory compaction code.

* disable irqs in acct_isolated() for __mod_zone_page_state(),
  lru_lock isn't required there.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/compaction.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a976b28..1e89165 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -224,8 +224,10 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
 	list_for_each_entry(page, &cc->migratepages, lru)
 		count[!!page_is_file_cache(page)]++;
 
+	local_irq_disable();
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
+	local_irq_enable();
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */
@@ -262,7 +264,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec = NULL;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -294,25 +296,24 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 
 	/* Time to isolate some pages for migration */
 	cond_resched();
-	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
-		bool locked = true;
 
 		/* give a chance to irqs before checking need_resched() */
 		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
-			spin_unlock_irq(&zone->lru_lock);
-			locked = false;
+			if (lruvec)
+				unlock_lruvec_irq(lruvec);
+			lruvec = NULL;
 		}
-		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
-			if (locked)
-				spin_unlock_irq(&zone->lru_lock);
+		if (need_resched() ||
+		    (lruvec && spin_is_contended(&zone->lru_lock))) {
+			if (lruvec)
+				unlock_lruvec_irq(lruvec);
+			lruvec = NULL;
 			cond_resched();
-			spin_lock_irq(&zone->lru_lock);
 			if (fatal_signal_pending(current))
 				break;
-		} else if (!locked)
-			spin_lock_irq(&zone->lru_lock);
+		}
 
 		/*
 		 * migrate_pfn does not necessarily start aligned to a
@@ -359,7 +360,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 			continue;
 		}
 
-		if (!PageLRU(page))
+		if (!catch_page_lruvec(&lruvec, page))
 			continue;
 
 		/*
@@ -382,7 +383,6 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
-		lruvec = page_lruvec(page);
 		del_page_from_lru_list(lruvec, page, page_lru(page));
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
@@ -395,9 +395,11 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		}
 	}
 
+	if (lruvec)
+		unlock_lruvec_irq(lruvec);
+
 	acct_isolated(zone, cc);
 
-	spin_unlock_irq(&zone->lru_lock);
 	cc->migrate_pfn = low_pfn;
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);

