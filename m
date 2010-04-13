Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0DMBMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:12:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416Ab0DMBMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:12:38 -0400
Date: Mon, 12 Apr 2010 18:08:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH 4/4] anonvma: when setting up page->mapping, we need to
 pick the _oldest_ anonvma
In-Reply-To: <20100413004117.GD20163@cmpxchg.org>
Message-ID: <alpine.LFD.2.00.1004121806510.3647@i5.linux-foundation.org>
References: <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic>
 <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org> <20100413004117.GD20163@cmpxchg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Apr 2010, Johannes Weiner wrote:
> 
> Would you mind pasting that nice description of the error case from your
> other email into that changelog?  I skimmed over the description but when
> I read this patch several hours later, I had to go back to that previous
> email to fully make sense of it.

It now looks like this..

		Linus
---
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Apr 2010 12:44:29 -0700
Subject: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick the _oldest_ anonvma

Otherwise we might be mapping in a page in a new mapping, but that page
(through the swapcache) would later be mapped into an old mapping too.
The page->mapping must be the case that works for everybody, not just
the mapping that happened to page it in first.

Here's the scenario:

 - page gets allocated/mapped by process A. Let's call the anon_vma we
   associate the page with 'A' to keep it easy to track.

 - Process A forks, creating process B. The anon_vma in B is 'B', and has
   a chain that looks like 'B' -> 'A'. Everything is fine.

 - Swapping happens. The page (with mapping pointing to 'A') gets swapped
   out (perhaps not to disk - it's enough to assume that it's just not
   mapped any more, and lives entirely in the swap-cache)

 - Process B pages it in, which goes like this:

        do_swap_page ->
          page = lookup_swap_cache(entry);
         ...
          set_pte_at(mm, address, page_table, pte);
          page_add_anon_rmap(page, vma, address);

   And think about what happens here!

   In particular, what happens is that this will now be the "first"
   mapping of that page, so page_add_anon_rmap() used to do

        if (first)
                __page_set_anon_rmap(page, vma, address);

   and notice what anon_vma it will use? It will use the anon_vma for
   process B!

   What happens then? Trivial: process 'A' also pages it in (nothing
   happens, it's not the first mapping), and then process 'B' execve's
   or exits or unmaps, making anon_vma B go away.

   End result: process A has a page that points to anon_vma B, but
   anon_vma B does not exist any more.  This can go on forever.  Forget
   about RCU grace periods, forget about locking, forget anything like
   that.  The bug is simply that page->mapping points to an anon_vma
   that was correct at one point, but was _not_ the one that was shared
   by all users of that possible mapping.

Changing it to always use the deepest anon_vma in the anonvma chain gets
us to the safest model.

This can be improved in certain cases: if we know the page is private to
just this particular mapping (for example, it's a new page, or it is the
only swapcache entry), we could pick the top (most specific) anon_vma.

But that's a future optimization. Make it _work_ reliably first.

Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Borislav Petkov <bp@alien8.de> [ "What do you know, I think you fixed it!" ]
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

