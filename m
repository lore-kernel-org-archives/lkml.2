Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0DNWAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab0DNWAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:00:52 -0400
Date: Wed, 14 Apr 2010 17:59:28 -0400
From: Rik van Riel <riel@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH] rmap: add exclusively owned pages to the newest anon_vma
Message-ID: <20100414175928.5e1bdce2@annuminas.surriel.com>
In-Reply-To: <20100413093827.GA6954@liondog.tnic>
References: <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
	<alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
	<20100411185508.GA4450@liondog.tnic>
	<alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
	<alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
	<20100412072056.GA2432@liondog.tnic>
	<alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
	<alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
	<20100412215027.GA6263@liondog.tnic>
	<alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org>
	<20100413093827.GA6954@liondog.tnic>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent anon_vma fixes cause many anonymous pages to end up
in the parent process anon_vma, even when the page is exclusively
owned by the current process.

Adding exclusively owned anonymous pages to the top anon_vma
reduces rmap scanning overhead, especially in workloads with
forking servers.

This patch adds a parameter to __page_set_anon_rmap that can
be used to indicate whether or not the added page is exclusively
owned by the current process.

Pages added through page_add_new_anon_rmap are exclusively
owned by the current process, and can be added to the top
anon_vma.

Pages added through page_add_anon_rmap can be either shared
or exclusively owned, so we do the conservative thing and
add it to the oldest anon_vma.

A next step would be to add the exclusive parameter to
page_add_anon_rmap, to be used from functions where we do
know for sure whether a page is exclusively owned.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
Borislav, I audited the code before making this change, but would
still appreciate your testing of this patch :)

Linus, once this patch survives Borislav's testing, I'll start
looking at the next step. I'd like to do things one step at a
time so I won't cause another regression...

 mm/rmap.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 4bad326..12ac0f1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -730,23 +730,31 @@ void page_move_anon_rmap(struct page *page,
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @exclusive:  the page is exclusively owned by the current process
  */
 static void __page_set_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+	struct vm_area_struct *vma, unsigned long address, int exclusive)
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
 
 	BUG_ON(!vma->anon_vma);
 
-	/*
-	 * We must use the _oldest_ possible anon_vma for the page mapping!
-	 *
-	 * So take the last AVC chain entry in the vma, which is the deepest
-	 * ancestor, and use the anon_vma from that.
-	 */
-	avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
-	anon_vma = avc->anon_vma;
+	if (exclusive)
+		anon_vma = vma->anon_vma;
+	else {
+		/*
+		 * The page may be shared between multiple processes.
+		 * We must use the _oldest_ possible anon_vma for the
+		 * page mapping!  That anon_vma is guaranteed to be
+		 * present in all processes that could share this page.
+		 *
+		 * So take the last AVC chain entry in the vma, which is the
+		 * deepest ancestor, and use the anon_vma from that.
+		 */
+		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
+		anon_vma = avc->anon_vma;
+	}
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
@@ -802,7 +810,7 @@ void page_add_anon_rmap(struct page *page,
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (first)
-		__page_set_anon_rmap(page, vma, address);
+		__page_set_anon_rmap(page, vma, address, 0);
 	else
 		__page_check_anon_rmap(page, vma, address);
 }
@@ -824,7 +832,7 @@ void page_add_new_anon_rmap(struct page *page,
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	__inc_zone_page_state(page, NR_ANON_PAGES);
-	__page_set_anon_rmap(page, vma, address);
+	__page_set_anon_rmap(page, vma, address, 1);
 	if (page_evictable(page, vma))
 		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else

