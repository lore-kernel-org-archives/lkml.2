Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2KUTWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:22:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34419 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2KUTWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:22:02 -0500
Subject: [PATCH] [3.7-rc] fix incorrect NR_FREE_PAGES accounting (appears like memory leak)
To: mgorman@suse.de
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2012 14:21:51 -0500
Message-Id: <20121121192151.3FFE0A9A@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112119-7606-0000-0000-00000590F7AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This needs to make it in before 3.7 is released.

--

There have been some 3.7-rc reports of vm issues, including some
kswapd bugs and, more importantly, some memory "leaks":

	http://www.spinics.net/lists/linux-mm/msg46187.html
	https://bugzilla.kernel.org/show_bug.cgi?id=50181

The post-3.6 commit 1fb3f8ca took split_free_page() and reused
it for the compaction code.  It does something curious with
capture_free_page() (previously known as split_free_page()):

int capture_free_page(struct page *page, int alloc_order,
...
        __mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));

-       /* Split into individual pages */
-       set_page_refcounted(page);
-       split_page(page, order);
+       if (alloc_order != order)
+               expand(zone, page, alloc_order, order,
+                       &zone->free_area[order], migratetype);

Note that expand() puts the pages _back_ in the allocator, but it
does not bump NR_FREE_PAGES.  We "return" 'alloc_order' worth of
pages, but we accounted for removing 'order' in the
__mod_zone_page_state() call.  For the old split_page()-style use
(order==alloc_order) the bug will not trigger.  But, when called
from the compaction code where we occasionally get a larger page
out of the buddy allocator than we need, we will run in to this.

This patch simply changes the NR_FREE_PAGES manipulation to the
correct 'alloc_order' instead of 'order'.

I've been able to repeatedly trigger this in my testing
environment.  The amount "leaked" very closely tracks the
imbalance I see in buddy pages vs. NR_FREE_PAGES.  I have
confirmed that this patch fixes the imbalance

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
---

 linux-2.6.git-dave/mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~leak-fix-20121120-2 mm/page_alloc.c
--- linux-2.6.git/mm/page_alloc.c~leak-fix-20121120-2	2012-11-21 14:14:52.053714749 -0500
+++ linux-2.6.git-dave/mm/page_alloc.c	2012-11-21 14:14:52.069714883 -0500
@@ -1405,7 +1405,7 @@ int capture_free_page(struct page *page,
 
 	mt = get_pageblock_migratetype(page);
 	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_freepage_state(zone, -(1UL << order), mt);
+		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
 
 	if (alloc_order != order)
 		expand(zone, page, alloc_order, order,
_

