Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2DXWfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:36 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2DXWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:30 -0400
Message-Id: <20120424223244.622090882@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ken Chen <kenchen@google.com>
Subject: [ 31/62] mm: fix s390 BUG by __set_page_dirty_no_writeback on swap
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit aca50bd3b4c4bb5528a1878158ba7abce41de534 upstream.

Mel reports a BUG_ON(slot == NULL) in radix_tree_tag_set() on s390
3.0.13: called from __set_page_dirty_nobuffers() when page_remove_rmap()
tries to transfer dirty flag from s390 storage key to struct page and
radix_tree.

That would be because of reclaim's shrink_page_list() calling
add_to_swap() on this page at the same time: first PageSwapCache is set
(causing page_mapping(page) to appear as &swapper_space), then
page->private set, then tree_lock taken, then page inserted into
radix_tree - so there's an interval before taking the lock when the
radix_tree slot is empty.

We could fix this by moving __add_to_swap_cache()'s spin_lock_irq up
before the SetPageSwapCache.  But a better fix is simply to do what's
five years overdue: Ken Chen introduced __set_page_dirty_no_writeback()
(if !PageDirty TestSetPageDirty) for tmpfs to skip all the radix_tree
overhead, and swap is just the same - it ignores the radix_tree tag, and
does not participate in dirty page accounting, so should be using
__set_page_dirty_no_writeback() too.

s390 testing now confirms that this does indeed fix the problem.

Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -26,7 +26,7 @@
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 	.migratepage	= migrate_page,
 };
 


