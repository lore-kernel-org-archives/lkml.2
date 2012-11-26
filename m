Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab2KZRQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:16:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48347 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275Ab2KZRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 256/270] mm: fix XFS oops due to dirty pages without buffers on s390
Date: Mon, 26 Nov 2012 14:59:06 -0200
Message-Id: <1353949160-26803-257-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit ef5d437f71afdf4afdbab99213add99f4b1318fd upstream.

On s390 any write to a page (even from kernel itself) sets architecture
specific page dirty bit.  Thus when a page is written to via buffered
write, HW dirty bit gets set and when we later map and unmap the page,
page_remove_rmap() finds the dirty bit and calls set_page_dirty().

Dirtying of a page which shouldn't be dirty can cause all sorts of
problems to filesystems.  The bug we observed in practice is that
buffers from the page get freed, so when the page gets later marked as
dirty and writeback writes it, XFS crashes due to an assertion
BUG_ON(!PagePrivate(page)) in page_buffers() called from
xfs_count_page_state().

Similar problem can also happen when zero_user_segment() call from
xfs_vm_writepage() (or block_write_full_page() for that matter) set the
hardware dirty bit during writeback, later buffers get freed, and then
page unmapped.

Fix the issue by ignoring s390 HW dirty bit for page cache pages of
mappings with mapping_cap_account_dirty().  This is safe because for
such mappings when a page gets marked as writeable in PTE it is also
marked dirty in do_wp_page() or do_page_fault().  When the dirty bit is
cleared by clear_page_dirty_for_io(), the page gets writeprotected in
page_mkclean().  So pagecache page is writeable if and only if it is
dirty.

Thanks to Hugh Dickins for pointing out mapping has to have
mapping_cap_account_dirty() for things to work and proposing a cleaned
up variant of the patch.

The patch has survived about two hours of running fsx-linux on tmpfs
while heavily swapping and several days of running on out build machines
where the original problem was triggered.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/rmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0f3b7cd..aa95e59 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -56,6 +56,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/hugetlb.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlbflush.h>
 
@@ -971,11 +972,8 @@ int page_mkclean(struct page *page)
 
 	if (page_mapped(page)) {
 		struct address_space *mapping = page_mapping(page);
-		if (mapping) {
+		if (mapping)
 			ret = page_mkclean_file(mapping, page);
-			if (page_test_and_clear_dirty(page_to_pfn(page), 1))
-				ret = 1;
-		}
 	}
 
 	return ret;
@@ -1161,6 +1159,7 @@ void page_add_file_rmap(struct page *page)
  */
 void page_remove_rmap(struct page *page)
 {
+	struct address_space *mapping = page_mapping(page);
 	bool anon = PageAnon(page);
 	bool locked;
 	unsigned long flags;
@@ -1183,8 +1182,19 @@ void page_remove_rmap(struct page *page)
 	 * this if the page is anon, so about to be freed; but perhaps
 	 * not if it's in swapcache - there might be another pte slot
 	 * containing the swap entry, but page not yet written to swap.
+	 *
+	 * And we can skip it on file pages, so long as the filesystem
+	 * participates in dirty tracking; but need to catch shm and tmpfs
+	 * and ramfs pages which have been modified since creation by read
+	 * fault.
+	 *
+	 * Note that mapping must be decided above, before decrementing
+	 * mapcount (which luckily provides a barrier): once page is unmapped,
+	 * it could be truncated and page->mapping reset to NULL at any moment.
+	 * Note also that we are relying on page_mapping(page) to set mapping
+	 * to &swapper_space when PageSwapCache(page).
 	 */
-	if ((!anon || PageSwapCache(page)) &&
+	if (mapping && !mapping_cap_account_dirty(mapping) &&
 	    page_test_and_clear_dirty(page_to_pfn(page), 1))
 		set_page_dirty(page);
 	/*
-- 
1.7.9.5

