Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2LBSoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:44:04 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45147 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2LBSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:44:00 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 01/52] mm/compaction: Move migration fail/success stats to migrate.c
Date: Sun,  2 Dec 2012 19:42:53 +0100
Message-Id: <1354473824-19229-2-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

The compact_pages_moved and compact_pagemigrate_failed events
are convenient for determining if compaction is active and to
what degree migration is succeeding but it's at the wrong level.
Other users of migration may also want to know if migration is
working properly and this will be particularly true for any
automated NUMA migration. This patch moves the counters down to
migration with the new events called pgmigrate_success and
pgmigrate_fail. The compact_blocks_moved counter is removed
because while it was useful for debugging initially, it's
worthless now as no meaningful conclusions can be drawn from its
value.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Alex Shi <lkml.alex@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/vm_event_item.h | 4 +++-
 mm/compaction.c               | 4 ----
 mm/migrate.c                  | 6 ++++++
 mm/vmstat.c                   | 7 ++++---
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 3d31145..8aa7cb9 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -38,8 +38,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+#ifdef CONFIG_MIGRATION
+		PGMIGRATE_SUCCESS, PGMIGRATE_FAIL,
+#endif
 #ifdef CONFIG_COMPACTION
-		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
 #endif
 #ifdef CONFIG_HUGETLB_PAGE
diff --git a/mm/compaction.c b/mm/compaction.c
index 9eef558..00ad883 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -994,10 +994,6 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
 
-		count_vm_event(COMPACTBLOCKS);
-		count_vm_events(COMPACTPAGES, nr_migrate - nr_remaining);
-		if (nr_remaining)
-			count_vm_events(COMPACTPAGEFAILED, nr_remaining);
 		trace_mm_compaction_migratepages(nr_migrate - nr_remaining,
 						nr_remaining);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..04687f6 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -962,6 +962,7 @@ int migrate_pages(struct list_head *from,
 {
 	int retry = 1;
 	int nr_failed = 0;
+	int nr_succeeded = 0;
 	int pass = 0;
 	struct page *page;
 	struct page *page2;
@@ -988,6 +989,7 @@ int migrate_pages(struct list_head *from,
 				retry++;
 				break;
 			case 0:
+				nr_succeeded++;
 				break;
 			default:
 				/* Permanent failure */
@@ -998,6 +1000,10 @@ int migrate_pages(struct list_head *from,
 	}
 	rc = 0;
 out:
+	if (nr_succeeded)
+		count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
+	if (nr_failed)
+		count_vm_events(PGMIGRATE_FAIL, nr_failed);
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c737057..89a7fd6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -774,10 +774,11 @@ const char * const vmstat_text[] = {
 
 	"pgrotated",
 
+#ifdef CONFIG_MIGRATION
+	"pgmigrate_success",
+	"pgmigrate_fail",
+#endif
 #ifdef CONFIG_COMPACTION
-	"compact_blocks_moved",
-	"compact_pages_moved",
-	"compact_pagemigrate_failed",
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
-- 
1.7.11.7

