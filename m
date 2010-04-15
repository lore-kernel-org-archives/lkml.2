Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0DOUGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:06:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437Ab0DOUGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:06:01 -0400
Date: Thu, 15 Apr 2010 13:01:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH] rmap: add exclusively owned pages to the newest
 anon_vma
In-Reply-To: <20100414175928.5e1bdce2@annuminas.surriel.com>
Message-ID: <alpine.LFD.2.00.1004151256090.15116@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <20100412215027.GA6263@liondog.tnic>
 <alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org> <20100413093827.GA6954@liondog.tnic> <20100414175928.5e1bdce2@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Apr 2010, Rik van Riel wrote:
> -	/*
> -	 * We must use the _oldest_ possible anon_vma for the page mapping!
> -	 *
> -	 * So take the last AVC chain entry in the vma, which is the deepest
> -	 * ancestor, and use the anon_vma from that.
> -	 */
> -	avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
> -	anon_vma = avc->anon_vma;
> +	if (exclusive)
> +		anon_vma = vma->anon_vma;
> +	else {
> +		/*
> +		 * The page may be shared between multiple processes.
> +		 * We must use the _oldest_ possible anon_vma for the
> +		 * page mapping!  That anon_vma is guaranteed to be
> +		 * present in all processes that could share this page.
> +		 *
> +		 * So take the last AVC chain entry in the vma, which is the
> +		 * deepest ancestor, and use the anon_vma from that.
> +		 */
> +		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
> +		anon_vma = avc->anon_vma;
> +	}

I really dislike your coding style.

If we do this conditionally, we're _much_ better off declaring the 
variables we only use inside that conditional block inside the block 
itself. And since we access "vma->anon_vma" in either case, just move that 
case outside the conditional statement, and avoid a pointless 
if/then/else.

IOW, something like this. Totally untested.

		Linus

---
 mm/rmap.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 4bad326..78d4730 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -732,21 +732,25 @@ void page_move_anon_rmap(struct page *page,
  * @address:	the user virtual address mapped
  */
 static void __page_set_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+	struct vm_area_struct *vma, unsigned long address, int exclusive)
 {
-	struct anon_vma_chain *avc;
-	struct anon_vma *anon_vma;
+	struct anon_vma *anon_vma = vma->anon_vma;
 
-	BUG_ON(!vma->anon_vma);
+	BUG_ON(!anon_vma);
 
 	/*
-	 * We must use the _oldest_ possible anon_vma for the page mapping!
+	 * If the page isn't exclusively mapped into this vma,
+	 * we must use the _oldest_ possible anon_vma for the
+	 * page mapping!
 	 *
-	 * So take the last AVC chain entry in the vma, which is the deepest
-	 * ancestor, and use the anon_vma from that.
+	 * So take the last AVC chain entry in the vma, which is
+	 * the deepest ancestor, and use the anon_vma from that.
 	 */
-	avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
-	anon_vma = avc->anon_vma;
+	if (!exclusive) {
+		struct anon_vma_chain *avc;
+		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
+		anon_vma = avc->anon_vma;
+	}
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
@@ -802,7 +806,7 @@ void page_add_anon_rmap(struct page *page,
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (first)
-		__page_set_anon_rmap(page, vma, address);
+		__page_set_anon_rmap(page, vma, address, 0);
 	else
 		__page_check_anon_rmap(page, vma, address);
 }
@@ -824,7 +828,7 @@ void page_add_new_anon_rmap(struct page *page,
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	__inc_zone_page_state(page, NR_ANON_PAGES);
-	__page_set_anon_rmap(page, vma, address);
+	__page_set_anon_rmap(page, vma, address, 1);
 	if (page_evictable(page, vma))
 		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else
