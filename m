Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2DWSPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:15:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48581 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2DWSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:15:03 -0400
Date: Mon, 23 Apr 2012 11:14:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ken Chen <kenchen@google.com>,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: fix s390 BUG by __set_page_dirty_no_writeback on swap
In-Reply-To: <alpine.LSU.2.00.1204231106450.23248@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1204231110090.23248@eggly.anvils>
References: <20120416141423.GD2359@suse.de> <alpine.LSU.2.00.1204161332120.1675@eggly.anvils> <20120417122202.GF2359@suse.de> <alpine.LSU.2.00.1204172023390.1609@eggly.anvils> <20120418152831.GK2359@suse.de> <alpine.LSU.2.00.1204181005500.1811@eggly.anvils>
 <20120423124124.GB3255@suse.de> <alpine.LSU.2.00.1204231106450.23248@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel reports a BUG_ON(slot == NULL) in radix_tree_tag_set() on s390 3.0.13:
called from __set_page_dirty_nobuffers() when page_remove_rmap() tries to
transfer dirty flag from s390 storage key to struct page and radix_tree.

That would be because of reclaim's shrink_page_list() calling add_to_swap()
on this page at the same time: first PageSwapCache is set (causing
page_mapping(page) to appear as &swapper_space), then page->private set,
then tree_lock taken, then page inserted into radix_tree - so there's
an interval before taking the lock when the radix_tree slot is empty.

We could fix this by moving __add_to_swap_cache()'s spin_lock_irq up
before the SetPageSwapCache.  But a better fix is simply to do what's
five years overdue: Ken Chen introduced __set_page_dirty_no_writeback()
(if !PageDirty TestSetPageDirty) for tmpfs to skip all the radix_tree
overhead, and swap is just the same - it ignores the radix_tree tag,
and does not participate in dirty page accounting, so should be using
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
Cc: stable@vger.kernel.org
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.4-git/mm/swap_state.c	2012-03-31 17:42:26.949729938 -0700
+++ linux/mm/swap_state.c	2012-04-17 15:34:05.732086663 -0700
@@ -26,7 +26,7 @@
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 	.migratepage	= migrate_page,
 };
 
