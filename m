Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0KVPoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:44:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48779 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0KVPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:43:59 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] mm: migration: Cleanup migrate_pages API by matching types for offlining and sync
Date: Mon, 22 Nov 2010 15:43:53 +0000
Message-Id: <1290440635-30071-6-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of the boolean sync parameter, the API looks a
little inconsistent as offlining is still an int. Convert offlining to a
bool for the sake of being tidy.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/migrate.h |    8 ++++----
 mm/compaction.c         |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    6 ++++--
 mm/migrate.c            |    8 ++++----
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index fa31902..e39aeec 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -13,10 +13,10 @@ extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x,
-			unsigned long private, int offlining,
+			unsigned long private, bool offlining,
 			bool sync);
 extern int migrate_huge_pages(struct list_head *l, new_page_t x,
-			unsigned long private, int offlining,
+			unsigned long private, bool offlining,
 			bool sync);
 
 extern int fail_migrate_page(struct address_space *,
@@ -35,10 +35,10 @@ extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
-		unsigned long private, int offlining,
+		unsigned long private, bool offlining,
 		bool sync) { return -ENOSYS; }
 static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
-		unsigned long private, int offlining,
+		unsigned long private, bool offlining,
 		bool sync) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
diff --git a/mm/compaction.c b/mm/compaction.c
index 03bd8f9..b6e589d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -457,7 +457,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 
 		nr_migrate = cc->nr_migratepages;
 		migrate_pages(&cc->migratepages, compaction_alloc,
-				(unsigned long)cc, 0,
+				(unsigned long)cc, false,
 				cc->sync);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 221178b..6178c80 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -717,7 +717,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		}
 		/* this function returns # of failed pages */
 		ret = migrate_pages(&source, hotremove_migrate_alloc, 0,
-								1, true);
+								true, true);
 		if (ret)
 			putback_lru_pages(&source);
 	}
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8b1a490..9beb008 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -935,7 +935,8 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
 		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_node_page, dest, 0, true);
+		err = migrate_pages(&pagelist, new_node_page, dest,
+								false, true);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
@@ -1155,7 +1156,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		if (!list_empty(&pagelist)) {
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma, 0, true);
+						(unsigned long)vma,
+						false, true);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
diff --git a/mm/migrate.c b/mm/migrate.c
index 678a84a..2eb2243 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -612,7 +612,7 @@ static int move_to_new_page(struct page *newpage, struct page *page,
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, int offlining, bool sync)
+			struct page *page, int force, bool offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -808,7 +808,7 @@ move_newpage:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, int offlining, bool sync)
+				int force, bool offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -890,7 +890,7 @@ out:
  * Return: Number of pages not migrated or error code.
  */
 int migrate_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining,
+		new_page_t get_new_page, unsigned long private, bool offlining,
 		bool sync)
 {
 	int retry = 1;
@@ -941,7 +941,7 @@ out:
 }
 
 int migrate_huge_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining,
+		new_page_t get_new_page, unsigned long private, bool offlining,
 		bool sync)
 {
 	int retry = 1;
-- 
1.7.1

