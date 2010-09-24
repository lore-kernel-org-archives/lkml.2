Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0IXQ2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:18 -0400
Received: from kroah.org ([198.145.64.141]:46137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab0IXQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.072199467@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [25/80] mm: further fix swapin race condition
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 31c4a3d3a0f84a5847665f8aa0552d188389f791 upstream.

Commit 4969c1192d15 ("mm: fix swapin race condition") is now agreed to
be incomplete.  There's a race, not very much less likely than the
original race envisaged, in which it is further necessary to check that
the swapcache page's swap has not changed.

Here's the reasoning: cast in terms of reuse_swap_page(), but probably
could be reformulated to rely on try_to_free_swap() instead, or on
swapoff+swapon.

A, faults into do_swap_page(): does page1 = lookup_swap_cache(swap1) and
comes through the lock_page(page1).

B, a racing thread of the same process, faults on the same address: does
page1 = lookup_swap_cache(swap1) and now waits in lock_page(page1), but
for whatever reason is unlucky not to get the lock any time soon.

A carries on through do_swap_page(), a write fault, but cannot reuse the
swap page1 (another reference to swap1).  Unlocks the page1 (but B
doesn't get it yet), does COW in do_wp_page(), page2 now in that pte.

C, perhaps the parent of A+B, comes in and write faults the same swap
page1 into its mm, reuse_swap_page() succeeds this time, swap1 is freed.

kswapd comes in after some time (B still unlucky) and swaps out some
pages from A+B and C: it allocates the original swap1 to page2 in A+B,
and some other swap2 to the original page1 now in C.  But does not
immediately free page1 (actually it couldn't: B holds a reference),
leaving it in swap cache for now.

B at last gets the lock on page1, hooray! Is PageSwapCache(page1)? Yes.
Is pte_same(*page_table, orig_pte)? Yes, because page2 has now been
given the swap1 which page1 used to have.  So B proceeds to insert page1
into A+B's page_table, though its content now belongs to C, quite
different from what A wrote there.

B ought to have checked that page1's swap was still swap1.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2682,10 +2682,12 @@ static int do_swap_page(struct mm_struct
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
 	/*
-	 * Make sure try_to_free_swap didn't release the swapcache
-	 * from under us. The page pin isn't enough to prevent that.
+	 * Make sure try_to_free_swap or reuse_swap_page or swapoff did not
+	 * release the swapcache from under us.  The page pin, and pte_same
+	 * test below, are not enough to exclude that.  Even if it is still
+	 * swapcache, we need to check that the page's swap has not changed.
 	 */
-	if (unlikely(!PageSwapCache(page)))
+	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
 	if (ksm_might_need_to_copy(page, vma, address)) {


