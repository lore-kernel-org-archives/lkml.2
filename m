Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab2DKXv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:51:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:39414 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061Ab2DKXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:51:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/5] Revert "mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)"
Date: Wed, 11 Apr 2012 19:50:53 -0400
Message-Id: <1334188257-3449-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ce1744f4ed20ca873360e54502f8a71564ef7cc6.

Using IS_ENABLED() within C (vs. within CPP #if statements) requires
us to actually define every possible bool/tristate Kconfig option
twice (__enabled_* and __enabled_*_MODULE variants).

That means we end up with about 16k lines of __enabled_ in autoconf.h,
instead of only less than 1k, and we'll be processing that extra 15k
lines for each and every C file. [x86_64 defconfig]

Kill off the C users of IS_ENABLED so we can shrink autoconf.h

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/migrate.h |    2 ++
 mm/mprotect.c           |    2 +-
 mm/rmap.c               |    7 +++----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 855c337..05ed282 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -8,6 +8,7 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
+#define PAGE_MIGRATION 1
 
 extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
@@ -31,6 +32,7 @@ extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
 #else
+#define PAGE_MIGRATION 0
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
diff --git a/mm/mprotect.c b/mm/mprotect.c
index a409926..142ef4a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -60,7 +60,7 @@ static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				ptent = pte_mkwrite(ptent);
 
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
-		} else if (IS_ENABLED(CONFIG_MIGRATION) && !pte_file(oldpte)) {
+		} else if (PAGE_MIGRATION && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
diff --git a/mm/rmap.c b/mm/rmap.c
index 36d01a2..4720d3d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1298,7 +1298,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			}
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
-		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
+		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
 			 * pte. do_swap_page() will wait until the migration
@@ -1309,8 +1309,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
-	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
+	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1516,7 +1515,7 @@ static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 		 * locking requirements of exec(), migration skips
 		 * temporary VMAs until after exec() completes.
 		 */
-		if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
+		if (PAGE_MIGRATION && (flags & TTU_MIGRATION) &&
 				is_vma_temporary_stack(vma))
 			continue;
 
-- 
1.7.9.1

