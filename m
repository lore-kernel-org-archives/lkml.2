Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2GQRCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:02:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36564 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2GQRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:02:22 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH] mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()
Date: Wed, 18 Jul 2012 02:01:00 +0900
Message-Id: <1342544460-20095-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 ('mm: compaction: introduce
sync-light migration for use by compaction') change declaration of
migrate_pages() and migrate_huge_pages().
But, it miss changing argument of migrate_huge_pages()
in soft_offline_huge_page(). In this case, we should call with MIGRATE_SYNC.
So change it.

Additionally, there is mismatch between type of argument and function
declaration for migrate_pages(). So fix this simple case, too.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ab1e714..afde561 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1431,8 +1431,8 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	/* Keep page count to indicate a given hugepage is isolated. */
 
 	list_add(&hpage->lru, &pagelist);
-	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
-				true);
+	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, false,
+				MIGRATE_SYNC);
 	if (ret) {
 		struct page *page1, *page2;
 		list_for_each_entry_safe(page1, page2, &pagelist, lru)
@@ -1561,7 +1561,7 @@ int soft_offline_page(struct page *page, int flags)
 					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
-							0, MIGRATE_SYNC);
+							false, MIGRATE_SYNC);
 		if (ret) {
 			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
-- 
1.7.9.5

