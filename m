Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0DLU2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:28:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab0DLU2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:28:38 -0400
Date: Mon, 12 Apr 2010 13:23:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick
 the _oldest_ anonvma
In-Reply-To: <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com>
 <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Apr 2010 12:44:29 -0700
Subject: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick the _oldest_ anonvma

Otherwise we might be mapping in a page in a new mapping, but that page
(through the swapcache) would later be mapped into an old mapping too.
The page->mapping must be the case that works for everybody, not just
the mapping that happened to page it in first.

This can be improved in certain cases: if we know the page is private to
just this particular mapping (for example, it's a new page, or it is the
only swapcache entry), we could pick the top (most specific) anon_vma.

But that's a future optimization. Make it _work_ reliably first.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/rmap.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index ee97d38..4bad326 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -734,9 +734,20 @@ void page_move_anon_rmap(struct page *page,
 static void __page_set_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma_chain *avc;
+	struct anon_vma *anon_vma;
+
+	BUG_ON(!vma->anon_vma);
+
+	/*
+	 * We must use the _oldest_ possible anon_vma for the page mapping!
+	 *
+	 * So take the last AVC chain entry in the vma, which is the deepest
+	 * ancestor, and use the anon_vma from that.
+	 */
+	avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
+	anon_vma = avc->anon_vma;
 
-	BUG_ON(!anon_vma);
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
 	page->index = linear_page_index(vma, address);
-- 
1.7.1.rc1.dirty

