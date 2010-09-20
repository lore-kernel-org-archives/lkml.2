Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0ITCkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 22:40:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:36721 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0ITCki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 22:40:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=P2V+kGAp8QPVVXxaMGvEJotOAfEfRPCmC2Y89XTVaSXE+Tv4D06cJj2FKY45q1WwT
	PpS3dX3Sz379eNwIdg0iQ==
Date: Sun, 19 Sep 2010 19:40:22 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: further fix swapin race condition
In-Reply-To: <alpine.LSU.2.00.1009191924110.2779@sister.anvils>
Message-ID: <alpine.LSU.2.00.1009191938110.3025@sister.anvils>
References: <20100903153958.GC16761@random.random> <alpine.LSU.2.00.1009051926330.12092@sister.anvils> <alpine.LSU.2.00.1009151534060.5630@tigran.mtv.corp.google.com> <20100915234237.GR5981@random.random> <alpine.DEB.2.00.1009151703060.7332@tigran.mtv.corp.google.com>
 <20100916210349.GU5981@random.random> <alpine.LSU.2.00.1009161905190.2517@tigran.mtv.corp.google.com> <20100918131907.GI18596@random.random> <alpine.LSU.2.00.1009191924110.2779@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4969c1192d15afa3389e7ae3302096ff684ba655 "mm: fix swapin race condition"
is now agreed to be incomplete.  There's a race, not very much less likely
than the original race envisaged, in which it is further necessary to check
that the swapcache page's swap has not changed.

Here's the reasoning: cast in terms of reuse_swap_page(), but probably could
be reformulated to rely on try_to_free_swap() instead, or on swapoff+swapon.

A, faults into do_swap_page(): does page1 = lookup_swap_cache(swap1)
and comes through the lock_page(page1).

B, a racing thread of the same process, faults on the same address:
does page1 = lookup_swap_cache(swap1) and now waits in lock_page(page1),
but for whatever reason is unlucky not to get the lock any time soon.

A carries on through do_swap_page(), a write fault, but cannot reuse
the swap page1 (another reference to swap1).  Unlocks the page1 (but B
doesn't get it yet), does COW in do_wp_page(), page2 now in that pte.

C, perhaps the parent of A+B, comes in and write faults the same swap
page1 into its mm, reuse_swap_page() succeeds this time, swap1 is freed.

kswapd comes in after some time (B still unlucky) and swaps out some
pages from A+B and C: it allocates the original swap1 to page2 in A+B,
and some other swap2 to the original page1 now in C.  But does not
immediately free page1 (actually it couldn't: B holds a reference),
leaving it in swap cache for now.

B at last gets the lock on page1, hooray!  Is PageSwapCache(page1)?
Yes.  Is pte_same(*page_table, orig_pte)?  Yes, because page2 has
now been given the swap1 which page1 used to have.  So B proceeds
to insert page1 into A+B's page_table, though its content now
belongs to C, quite different from what A wrote there.

B ought to have checked that page1's swap was still swap1.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org
---

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- 2.6.36-rc4/mm/memory.c	2010-09-12 17:34:03.000000000 -0700
+++ linux/mm/memory.c	2010-09-19 18:23:43.000000000 -0700
@@ -2680,10 +2680,12 @@ static int do_swap_page(struct mm_struct
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
