Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2ISDwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:52:22 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64400 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2ISDwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:52:20 -0400
Date: Tue, 18 Sep 2012 20:51:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mm: fix invalidate_complete_page2 lock ordering
Message-ID: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fuzzing with trinity, lockdep protested "possible irq lock inversion
dependency detected" when isolate_lru_page() reenabled interrupts while
still holding the supposedly irq-safe tree_lock:

invalidate_inode_pages2
  invalidate_complete_page2
    spin_lock_irq(&mapping->tree_lock)
    clear_page_mlock
      isolate_lru_page
        spin_unlock_irq(&zone->lru_lock)

isolate_lru_page() is correct to enable interrupts unconditionally:
invalidate_complete_page2() is incorrect to call clear_page_mlock()
while holding tree_lock, which is supposed to nest inside lru_lock.

Both truncate_complete_page() and invalidate_complete_page() call
clear_page_mlock() before taking tree_lock to remove page from
radix_tree.  I guess invalidate_complete_page2() preferred to test
PageDirty (again) under tree_lock before committing to the munlock;
but since the page has already been unmapped, its state is already
somewhat inconsistent, and no worse if clear_page_mlock() moved up.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Deciphered-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: stable@vger.kernel.org
---
 mm/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.6-rc6.orig/mm/truncate.c	2012-09-18 15:38:08.000000000 -0700
+++ 3.6-rc6/mm/truncate.c	2012-09-18 15:42:17.066731792 -0700
@@ -394,11 +394,12 @@ invalidate_complete_page2(struct address
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
+	clear_page_mlock(page);
+
 	spin_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
 		goto failed;
 
-	clear_page_mlock(page);
 	BUG_ON(page_has_private(page));
 	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
