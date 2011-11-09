Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165Ab1KJEJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:09:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936057Ab1KJDoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:00 2011
Message-Id: <20111109213200.120966532@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:45 -0800
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
Subject: [178/264] powerpc: remove superfluous PageTail checks on the pte gup_fast
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 2839bdc1bfc0af76a2f0f11eca011590520a04fa upstream.

This part of gup_fast doesn't seem capable of handling hugetlbfs ptes,
those should be handled by gup_hugepd only, so these checks are
superfluous.

Plus if this wasn't a noop, it would have oopsed because, the insistence
of using the speculative refcounting would trigger a VM_BUG_ON if a tail
page was encountered in the page_cache_get_speculative().

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
 arch/powerpc/mm/gup.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -16,17 +16,6 @@
 
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
-
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -58,8 +47,6 @@ static noinline int gup_pte_range(pmd_t
 			put_page(page);
 			return 0;
 		}
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		pages[*nr] = page;
 		(*nr)++;
 


