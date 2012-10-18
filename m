Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab2JRRH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:07:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2JRRH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:07:56 -0400
Date: Thu, 18 Oct 2012 10:07:35 -0700
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-45e23a2f98bf5ca9552ce50f7ce590f999c2ce0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa/mm:
  Further clean up migrate_misplaced_page()
Git-Commit-ID: 45e23a2f98bf5ca9552ce50f7ce590f999c2ce0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:07:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45e23a2f98bf5ca9552ce50f7ce590f999c2ce0d
Gitweb:     http://git.kernel.org/tip/45e23a2f98bf5ca9552ce50f7ce590f999c2ce0d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 15 Oct 2012 11:10:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Oct 2012 10:04:41 +0200

sched/numa/mm: Further clean up migrate_misplaced_page()

The 'mm' parameter is not used anymore, get rid of it.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-rwqEijuwdsgpooxrce9kniG8@git.kernel.org
---
 include/linux/migrate.h |    4 ++--
 mm/memory.c             |    2 +-
 mm/migrate.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 7544d1a..9a5afea 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -30,7 +30,7 @@ extern int migrate_vmas(struct mm_struct *mm,
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
-extern int migrate_misplaced_page(struct mm_struct *, struct page *, int);
+extern int migrate_misplaced_page(struct page *page, int node);
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
@@ -65,7 +65,7 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 #define fail_migrate_page NULL
 
 static inline
-int migrate_misplaced_page(struct mm_struct *mm, struct page *page, int node)
+int migrate_misplaced_page(struct page *page, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
diff --git a/mm/memory.c b/mm/memory.c
index 8b1ad86..fc48fe8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3486,7 +3486,7 @@ out:
 migrate:
 	pte_unmap_unlock(ptep, ptl);
 
-	if (!migrate_misplaced_page(mm, page, node)) {
+	if (!migrate_misplaced_page(page, node)) {
 		page_nid = node;
 		goto out;
 	}
diff --git a/mm/migrate.c b/mm/migrate.c
index e3cff03..72d1056 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1418,7 +1418,7 @@ int migrate_vmas(struct mm_struct *mm, const nodemask_t *to,
  * Attempt to migrate a misplaced page to the specified destination
  * node.
  */
-int migrate_misplaced_page(struct mm_struct *mm, struct page *page, int node)
+int migrate_misplaced_page(struct page *page, int node)
 {
 	struct address_space *mapping = page_mapping(page);
 	int page_lru = page_is_file_cache(page);
