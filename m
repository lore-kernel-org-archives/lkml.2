Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2JAQ0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:26:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2JAQ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:26:42 -0400
From: Jan Kara <jack@suse.cz>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mel Gorman <mgorman@suse.de>, linux-s390@vger.kernel.org
Subject: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on s390
Date: Mon,  1 Oct 2012 18:26:36 +0200
Message-Id: <1349108796-32161-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On s390 any write to a page (even from kernel itself) sets architecture
specific page dirty bit. Thus when a page is written to via standard write, HW
dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
finds the dirty bit and calls set_page_dirty().

Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
filesystems. The bug we observed in practice is that buffers from the page get
freed, so when the page gets later marked as dirty and writeback writes it, XFS
crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
from xfs_count_page_state().

Similar problem can also happen when zero_user_segment() call from
xfs_vm_writepage() (or block_write_full_page() for that matter) set the
hardware dirty bit during writeback, later buffers get freed, and then page
unmapped.

Fix the issue by ignoring s390 HW dirty bit for page cache pages in
page_mkclean() and page_remove_rmap(). This is safe because when a page gets
marked as writeable in PTE it is also marked dirty in do_wp_page() or
do_page_fault(). When the dirty bit is cleared by clear_page_dirty_for_io(),
the page gets writeprotected in page_mkclean(). So pagecache page is writeable
if and only if it is dirty.

CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Mel Gorman <mgorman@suse.de>
CC: linux-s390@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/rmap.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0f3b7cd..6ce8ddb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -973,7 +973,15 @@ int page_mkclean(struct page *page)
 		struct address_space *mapping = page_mapping(page);
 		if (mapping) {
 			ret = page_mkclean_file(mapping, page);
-			if (page_test_and_clear_dirty(page_to_pfn(page), 1))
+			/*
+			 * We ignore dirty bit for pagecache pages. It is safe
+			 * as page is marked dirty iff it is writeable (page is
+			 * marked as dirty when it is made writeable and
+			 * clear_page_dirty_for_io() writeprotects the page
+			 * again).
+			 */
+			if (PageSwapCache(page) &&
+			    page_test_and_clear_dirty(page_to_pfn(page), 1))
 				ret = 1;
 		}
 	}
@@ -1183,8 +1191,12 @@ void page_remove_rmap(struct page *page)
 	 * this if the page is anon, so about to be freed; but perhaps
 	 * not if it's in swapcache - there might be another pte slot
 	 * containing the swap entry, but page not yet written to swap.
+	 * For pagecache pages, we don't care about dirty bit in storage
+	 * key because the page is writeable iff it is dirty (page is marked
+	 * as dirty when it is made writeable and clear_page_dirty_for_io()
+	 * writeprotects the page again).
 	 */
-	if ((!anon || PageSwapCache(page)) &&
+	if (PageSwapCache(page) &&
 	    page_test_and_clear_dirty(page_to_pfn(page), 1))
 		set_page_dirty(page);
 	/*
-- 
1.7.1

