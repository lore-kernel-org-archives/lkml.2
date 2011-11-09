Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936105Ab1KJDom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:44:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936088Ab1KJDoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:00 2011
Message-Id: <20111109213200.214831077@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [179/264] powerpc: get_hugepte() dont put_page() the wrong page
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 405e44f2e312dd5dd63e5a9f459bffcbcd4368ef upstream.

"page" may have changed to point to the next hugepage after the loop
completed, The references have been taken on the head page, so the
put_page must happen there too.

This is a longstanding issue pre-thp inclusion.

It's totally unclear how these page_cache_add_speculative and
pte_val(pte) != pte_val(*ptep) checks are necessary across all the
powerpc gup_fast code, when x86 doesn't need any of that: there's no way
the page can be freed with irq disabled so we're guaranteed the
atomic_inc will happen on a page with page_count > 0 (so not needing the
speculative check).

The pte check is also meaningless on x86: no need to rollback on x86 if
the pte changed, because the pte can still change a CPU tick after the
check succeeded and it won't be rolled back in that case.  The important
thing is we got a reference on a valid page that was mapped there a CPU
tick ago.  So not knowing the soft tlb refill code of ppc64 in great
detail I'm not removing the "speculative" page_count increase and the
pte checks across all the code, but unless there's a strong reason for
it they should be later cleaned up too.

If a pte can change from huge to non-huge (like it could happen with
THP) passing a pte_t *ptep to gup_hugepte() would also require to repeat
the is_hugepd in gup_hugepte(), but that shouldn't happen with hugetlbfs
only so I'm not altering that.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -429,7 +429,7 @@ static noinline int gup_hugepte(pte_t *p
 	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 		/* Could be optimized better */
 		while (*nr) {
-			put_page(page);
+			put_page(head);
 			(*nr)--;
 		}
 	}


