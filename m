Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0DLQcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:32:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab0DLQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:32:19 -0400
Date: Mon, 12 Apr 2010 09:26:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
 <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Apr 2010, Linus Torvalds wrote:
> 
> Yes, and that is supposed to be a no-no. The page is clearly associated 
> with the vma in question (since we are unmapping it through that vma), but 
> the vma list of 'anon_vma's doesn't actually have the one that 
> 'page->mapping' points to.
> 
> And that, in turn, means that we've lost sight of the 'page->mapping' 
> anon_vma, and THAT in turn means that it could well have been free'd as 
> being no longer referenced.
> 
> And if it was free'd, it could be re-allocated as something else (after 
> the RCU grace period), and that directly explains your oops.

I have a new theory. And this new theory is completely different from all 
the other things we've been looking at.

The new theory is really simple: 'page->mapping' has been re-set to the 
wrong mapping. 

Now, there is one case where we reset page->mapping _intentionally_, 
namely in the COW-breaking case of having the last user 
("page_move_anon_rmap"). And that looks fine, and happens under normal 
loads all the time. We _want_ to do it there.

But there is a _much_ more subtle case that involved swapping.

So guys, here's my fairly simple theory on what happens:

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

In particular, what happens is that this will now be the "first" mapping 
of that page, so page_add_anon_rmap() will do

	if (first)
		__page_set_anon_rmap(page, vma, address);

and notice what anon_vma it will use? It will use the anon_vma for process 
B!

So now page->mapping actually points to anon_vma 'B', not 'A' like it used 
to.

What happens then? Trivial: process 'A' also pages it in (nothing happens, 
it's not the first mapping), and then process 'B' execve's or exits or 
unmaps, making anon_vma B go away.

End result: process A has a page that points to anon_vma B, but anon_vma B 
does not exist any more. This can go on forever. Forget about RCU grace 
periods, forget about locking, forget anything like that. The bug is 
simply that page->mapping points to an anon_vma that was correct at one 
point, but was _not_ the one that was shared by all users of that possible 
mapping.

The patch below is my largely mindless try at fixing this. It's untested. 
I'm not entirely sure that it actually works. But it makes some amount of 
conceptual sense. No?

			Linus

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
