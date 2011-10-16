Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1JPUlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 16:41:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1JPUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 16:41:04 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/4] powerpc: remove superfluous PageTail checks on the pte gup_fast
Date: Sun, 16 Oct 2011 22:40:36 +0200
Message-Id: <1318797639-26962-2-git-send-email-aarcange@redhat.com>
In-Reply-To: <1316793432.9084.47.camel@twins>
References: <1316793432.9084.47.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part of gup_fast doesn't seem capable of handling hugetlbfs ptes,
those should be handled by gup_hugepd only, so these checks are
superfluous.

Plus if this wasn't a noop, it would have oopsed because, the insistence
of using the speculative refcounting would trigger a VM_BUG_ON if a tail
page was encountered in the page_cache_get_speculative().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index b9e1c7f..d7efdbf 100644
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
@@ -58,8 +47,6 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 			put_page(page);
 			return 0;
 		}
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		pages[*nr] = page;
 		(*nr)++;
 
-- 
1.7.3.4

