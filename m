Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab0EFPI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:08:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56037 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab0EFPI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:08:28 -0400
Date: Thu, 6 May 2010 16:08:09 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH] mm,compaction: Do not schedule work on other CPUs for
	compaction
Message-ID: <20100506150808.GC8704@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migration normally requires a call to migrate_prep() as a preparation
step. This schedules work on all CPUs for pagevecs to be drained. This
makes sense for move_pages and memory hot-remove but is unnecessary
for memory compaction.

To avoid queueing work on multiple CPUs, this patch introduces
migrate_prep_local() which drains just local pagevecs.

This patch can be either merged with mmcompaction-memory-compaction-core.patch
or placed immediately after it to clarify why migrate_prep_local() was
introduced.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/migrate.h |    2 ++
 mm/compaction.c         |    2 +-
 mm/migrate.c            |   11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 05d2292..6dec3ef 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -19,6 +19,7 @@ extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
 
 extern int migrate_prep(void);
+extern int migrate_prep_local(void);
 extern int migrate_vmas(struct mm_struct *mm,
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
@@ -32,6 +33,7 @@ static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, int offlining) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
+static inline int migrate_prep_local(void) { return -ENOSYS; }
 
 static inline int migrate_vmas(struct mm_struct *mm,
 		const nodemask_t *from, const nodemask_t *to,
diff --git a/mm/compaction.c b/mm/compaction.c
index bd13560..94cce51 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -383,7 +383,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
 	cc->free_pfn &= ~(pageblock_nr_pages-1);
 
-	migrate_prep();
+	migrate_prep_local();
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
 		unsigned long nr_migrate, nr_remaining;
diff --git a/mm/migrate.c b/mm/migrate.c
index 053fd39..d99ec15 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -40,7 +40,8 @@
 
 /*
  * migrate_prep() needs to be called before we start compiling a list of pages
- * to be migrated using isolate_lru_page().
+ * to be migrated using isolate_lru_page(). If scheduling work on other CPUs is
+ * undesirable, use migrate_prep_local()
  */
 int migrate_prep(void)
 {
@@ -55,6 +56,14 @@ int migrate_prep(void)
 	return 0;
 }
 
+/* Do the necessary work of migrate_prep but not if it involves other CPUs */
+int migrate_prep_local(void)
+{
+	lru_add_drain();
+
+	return 0;
+}
+
 /*
  * Add isolated pages on the list back to the LRU under page lock
  * to avoid leaking evictable pages back onto unevictable list.
