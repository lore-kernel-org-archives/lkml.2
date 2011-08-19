Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1HSHtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:49:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1HSHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:49:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=UZtOmGoQeY6zpS1xklai4tS8f/KfbWMxJQdGhG5GKTAXX84SwDWvZPgYDZqhrn+Ux
	n5RxovtDb8EDOm2j+S8YA==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 9/9] mm: make sure tail page counts are stable before splitting THP pages
Date: Fri, 19 Aug 2011 00:48:31 -0700
Message-Id: <1313740111-27446-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described in the page_cache_get_speculative() comment
in pagemap.h, the count of all pages coming out of the allocator
must be considered unstable unless an RCU grace period has passed
since the pages were allocated.

This is an issue for THP because __split_huge_page_refcount()
depends on tail page counts being stable.

By setting a cookie on THP pages when they are allocated, we are able
to ensure the tail page counts are stable before splitting such pages.
In the typical case, the THP page should be old enough by the time we
try to split it, so that we won't have to wait.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/huge_memory.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 81532f2..46c0c0b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -657,15 +657,23 @@ static inline struct page *alloc_hugepage_vma(int defrag,
 					      unsigned long haddr, int nd,
 					      gfp_t extra_gfp)
 {
-	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag, extra_gfp),
+	struct page *page;
+	page = alloc_pages_vma(alloc_hugepage_gfpmask(defrag, extra_gfp),
 			       HPAGE_PMD_ORDER, vma, haddr, nd);
+	if (page)
+		page_get_gp_cookie(page);
+	return page;
 }
 
 #ifndef CONFIG_NUMA
 static inline struct page *alloc_hugepage(int defrag)
 {
-	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
+	struct page *page;
+	page = alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
 			   HPAGE_PMD_ORDER);
+	if (page)
+		page_get_gp_cookie(page);
+	return page;
 }
 #endif
 
@@ -1209,7 +1217,7 @@ static void __split_huge_page_refcount(struct page *page)
 		BUG_ON(page_mapcount(page_tail));
 		page_tail->_mapcount = page->_mapcount;
 
-		BUG_ON(page_tail->mapping);
+		BUG_ON(page_tail->mapping);  /* see page_clear_gp_cookie() */
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = ++head_index;
@@ -1387,9 +1395,11 @@ static void __split_huge_page(struct page *page,
 int split_huge_page(struct page *page)
 {
 	struct anon_vma *anon_vma;
-	int ret = 1;
+	int ret;
 
+retry:
 	BUG_ON(!PageAnon(page));
+	ret = 1;
 	anon_vma = page_lock_anon_vma(page);
 	if (!anon_vma)
 		goto out;
@@ -1397,6 +1407,21 @@ int split_huge_page(struct page *page)
 	if (!PageCompound(page))
 		goto out_unlock;
 
+	/*
+	 * Make sure the tail page counts are stable before splitting the page.
+	 * See the page_cache_get_speculative() comment in pagemap.h.
+	 */
+	if (!page_gp_cookie_elapsed(page)) {
+		page_unlock_anon_vma(anon_vma);
+		synchronize_rcu();
+		goto retry;
+	}
+
+	/*
+	 * Make sure page_tail->mapping is cleared before we split up the page.
+	 */
+	page_clear_gp_cookie(page);
+
 	BUG_ON(!PageSwapBacked(page));
 	__split_huge_page(page, anon_vma);
 	count_vm_event(THP_SPLIT);
-- 
1.7.3.1

