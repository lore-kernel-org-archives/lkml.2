Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2KUK0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:26:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab2KUKWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:22:49 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 32/46] mm: numa: Rate limit the amount of memory that is migrated between nodes
Date: Wed, 21 Nov 2012 10:21:38 +0000
Message-Id: <1353493312-8069-33-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: This is very heavily based on similar logic in autonuma. It should
	be signed off by Andrea but because there was no standalone
	patch and it's sufficiently different from what he did that
	the signed-off is omitted. Will be added back if requested.

If a large number of pages are misplaced then the memory bus can be
saturated just migrating pages between nodes. This patch rate-limits
the amount of memory that can be migrating between nodes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 4b876d2..cf0970f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1461,12 +1461,21 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
 }
 
 /*
+ * page migration rate limiting control.
+ * Do not migrate more than @pages_to_migrate in a @migrate_interval_millisecs
+ * window of time. Default here says do not migrate more than 1280M per second.
+ */
+static unsigned int migrate_interval_millisecs __read_mostly = 100;
+static unsigned int ratelimit_pages __read_mostly = 128 << (20 - PAGE_SHIFT);
+
+/*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
  * the page that will be dropped by this function before returning.
  */
 int migrate_misplaced_page(struct page *page, int node)
 {
+	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated = 0;
 	LIST_HEAD(migratepages);
 
@@ -1479,8 +1488,27 @@ int migrate_misplaced_page(struct page *page, int node)
 		goto out;
 	}
 
+	/*
+	 * Rate-limit the amount of data that is being migrated to a node.
+	 * Optimal placement is no good if the memory bus is saturated and
+	 * all the time is being spent migrating!
+	 */
+	spin_lock(&pgdat->balancenuma_migrate_lock);
+	if (time_after(jiffies, pgdat->balancenuma_migrate_next_window)) {
+		pgdat->balancenuma_migrate_nr_pages = 0;
+		pgdat->balancenuma_migrate_next_window = jiffies +
+			msecs_to_jiffies(migrate_interval_millisecs);
+	}
+	if (pgdat->balancenuma_migrate_nr_pages > ratelimit_pages) {
+		spin_unlock(&pgdat->balancenuma_migrate_lock);
+		put_page(page);
+		goto out;
+	}
+	pgdat->balancenuma_migrate_nr_pages++;
+	spin_unlock(&pgdat->balancenuma_migrate_lock);
+
 	/* Avoid migrating to a node that is nearly full */
-	if (migrate_balanced_pgdat(NODE_DATA(node), 1)) {
+	if (migrate_balanced_pgdat(pgdat, 1)) {
 		int page_lru;
 
 		if (isolate_lru_page(page)) {
@@ -1515,6 +1543,7 @@ int migrate_misplaced_page(struct page *page, int node)
 			count_vm_numa_event(NUMA_PAGE_MIGRATE);
 	}
 	BUG_ON(!list_empty(&migratepages));
+
 out:
 	return isolated;
 }
-- 
1.7.9.2

