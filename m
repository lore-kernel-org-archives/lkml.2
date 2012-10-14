Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2JNPGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:06:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46312 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab2JNOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:34 -0400
Message-Id: <20121014143549.160935001@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Sasha Levin <levinsasha928@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, Ying Han <yinghan@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 114/147] mm: fix invalidate_complete_page2() lock ordering
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit ec4d9f626d5908b6052c2973f37992f1db52e967 upstream.

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
invalidate_complete_page2() is incorrect to call clear_page_mlock() while
holding tree_lock, which is supposed to nest inside lru_lock.

Both truncate_complete_page() and invalidate_complete_page() call
clear_page_mlock() before taking tree_lock to remove page from radix_tree.
 I guess invalidate_complete_page2() preferred to test PageDirty (again)
under tree_lock before committing to the munlock; but since the page has
already been unmapped, its state is already somewhat inconsistent, and no
worse if clear_page_mlock() moved up.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Deciphered-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 75801ac..f38055c 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -394,11 +394,12 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
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


