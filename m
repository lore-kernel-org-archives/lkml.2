Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2BKHyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 02:54:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62748 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2BKHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 02:54:21 -0500
Subject: [PATCH] mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 11 Feb 2012 11:54:15 +0400
Message-ID: <20120211075415.31460.21642.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2a11c8ea20bf850 there is generic grep-friendly method for
checking config options in C expressions.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/migrate.h |    2 --
 mm/mprotect.c           |    2 +-
 mm/rmap.c               |    7 ++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 05ed282..855c337 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -8,7 +8,6 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
-#define PAGE_MIGRATION 1
 
 extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
@@ -32,7 +31,6 @@ extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
 #else
-#define PAGE_MIGRATION 0
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 5a688a2..5220093 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -60,7 +60,7 @@ static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				ptent = pte_mkwrite(ptent);
 
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
-		} else if (PAGE_MIGRATION && !pte_file(oldpte)) {
+		} else if (IS_ENABLED(CONFIG_MIGRATION) && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
diff --git a/mm/rmap.c b/mm/rmap.c
index c8454e0..78cc46b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1282,7 +1282,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			}
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
-		} else if (PAGE_MIGRATION) {
+		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
 			/*
 			 * Store the pfn of the page in a special migration
 			 * pte. do_swap_page() will wait until the migration
@@ -1293,7 +1293,8 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
-	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
+	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
+		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1499,7 +1500,7 @@ static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 		 * locking requirements of exec(), migration skips
 		 * temporary VMAs until after exec() completes.
 		 */
-		if (PAGE_MIGRATION && (flags & TTU_MIGRATION) &&
+		if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
 				is_vma_temporary_stack(vma))
 			continue;
 

