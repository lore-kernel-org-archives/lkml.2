Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2JKANx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:13:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43518 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758172Ab2JKANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:13:47 -0400
X-Sasl-enc: ISVhWJ7IeM0l8WPvEmWenOEdOTlUmIfKFF5yCzDY1wTx 1349914425
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sasha Levin <levinsasha928@gmail.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 082/133] mm: fix invalidate_complete_page2() lock ordering
Date: Thu, 11 Oct 2012 07:51:48 +0900
Message-Id: <20121010224909.231773540@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/truncate.c
+++ b/mm/truncate.c
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


