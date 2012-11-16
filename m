Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2KPLXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:23:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab2KPLXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:23:38 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 29/43] mm: numa: Rate limit setting of pte_numa if node is saturated
Date: Fri, 16 Nov 2012 11:22:39 +0000
Message-Id: <1353064973-26082-30-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353064973-26082-1-git-send-email-mgorman@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are a large number of NUMA hinting faults and all of them
are resulting in migrations it may indicate that memory is just
bouncing uselessly around. NUMA balancing cost is likely exceeding
any benefit from locality. Rate limit the PTE updates if the node
is migration rate-limited. As noted in the comments, this distorts
the NUMA faulting statistics.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/migrate.h |    6 ++++++
 mm/mempolicy.c          |    9 +++++++++
 mm/migrate.c            |   22 ++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index e5ab5db..08538ac 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -41,6 +41,7 @@ extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
 extern struct page *migrate_misplaced_page(struct page *page, int node);
+extern bool migrate_ratelimited(int node);
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
@@ -79,6 +80,11 @@ struct page *migrate_misplaced_page(struct page *page, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline
+bool migrate_ratelimited(int node)
+{
+	return false;
+}
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ca201e9..7acc97b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -688,6 +688,15 @@ change_prot_numa_range(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (page_mapcount(page) != 1)
 			continue;
 
+		/*
+		 * Do not set pte_numa if migrate ratelimited. This
+		 * loses statistics on the fault but if we are
+		 * unwilling to migrate to this node, we cannot do
+		 * useful work anyway.
+		 */
+		if (migrate_ratelimited(page_to_nid(page)))
+			continue;
+
 		set_pte_at(mm, _address, _pte, pte_mknuma(pteval));
 		nr_pte_updates++;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index dac5a43..1654bb7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1467,10 +1467,32 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
  * page migration rate limiting control.
  * Do not migrate more than @pages_to_migrate in a @migrate_interval_millisecs
  * window of time. Default here says do not migrate more than 1280M per second.
+ * If a node is rate-limited then PTE NUMA updates are also rate-limited. However
+ * as it is faults that reset the window, pte updates will happen unconditionally
+ * if there has not been a fault since @pteupdate_interval_millisecs after the
+ * throttle window closed.
  */
 static unsigned int migrate_interval_millisecs __read_mostly = 100;
+static unsigned int pteupdate_interval_millisecs __read_mostly = 1000;
 static unsigned int ratelimit_pages __read_mostly = 128 << (20 - PAGE_SHIFT);
 
+#ifdef CONFIG_BALANCE_NUMA
+/* Returns true if NUMA migration is currently rate limited */
+bool migrate_ratelimited(int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+
+	if (time_after(jiffies, pgdat->balancenuma_migrate_next_window +
+				msecs_to_jiffies(pteupdate_interval_millisecs)))
+		return false;
+
+	if (pgdat->balancenuma_migrate_nr_pages < ratelimit_pages)
+		return false;
+
+	return true;
+}
+#endif
+
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
-- 
1.7.9.2

