Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0DLOn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:43:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0DLOnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:43:55 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
References: <20100409191425.GB10780@a1.tnic>
	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
	 <20100409204328.GG28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 12 Apr 2010 16:40:07 +0200
Message-ID: <1271083207.4807.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 11:21 -0700, Linus Torvalds wrote:
> 

> Ho humm.
> 
> Maybe I'm crazy, but something started bothering me. And I started 
> wondering: when is the 'page->mapping' of an anonymous page actually 
> cleared?
> 
> The thing is, the mapping of an anonymous page is actually cleared only 
> when the page is _freed_, in "free_hot_cold_page()". 
> 
> Now, let's think about that. And in particular, let's think about how that 
> relates to the freeing of the 'anon_vma' that the page->mapping points to. 
> 
> The way the anon_vma is freed is when the mapping is torn down, and we do 
> roughly:
> 
> 	tlb = tlb_gather_mmu(mm,..)
> 	..
> 	unmap_vmas(&tlb, vma ..
> 	..
> 	free_pgtables()
> 	..
> 	tlb_finish_mmu(tlb, start, end);
> 
> and we actually unmap all the pages in "unmap_vmas()", and then _after_ 
> unmapping all the pages we do the "unlink_anon_vmas(vma);" in 
> "free_pgtables()". Fine so far - the anon_vma stay around until after the 
> page has been happily unmapped.
> 
> But "unmapped all the pages" is _not_ actually the same as "free'd all the 
> pages". The actual _freeing_ of the page happens generally in 
> tlb_finish_mmu(), because we can free the page only after we've flushed 
> any TLB entries.
> 
> So what we have in that tlb_gather structure is a list of _pending_ pages 
> to be freed, while we already actually free'd the anon_vmas earlier!
> 
> Now, the thing is, tlb_gather_mmu() begins a preempt-safe region (because 
> we use a per-cpu variable), but as far as I can tell it is _not_ an 
> RCU-safe region.
> 
> So I think we might actually get a real RCU freeing event while this all
> happens. So now the 'anon_vma' that 'page->mapping' points to has not just 
> been released back to the SLUB caches, the page itself might have been 
> released too.
> 
> I dunno. Does the above sound at all sane? Or am I just raving?
> 
> Something hacky like the above might fix it if I'm not just raving. I 
> really might be missing something here.

Right, so unless you have CONFIG_TREE_PREEMPT_RCU=y, the preempt-disable
== RCU read lock assumption does hold.

But even with your patch it doesn't close all holes because while
zap_pte_range() can remove the last mapcount of the page, the
page_remove_tlb() et al. don't need to be the last use count of the
page.

Concurrent reclaim/gup/whatever could still have a count out on the page
delaying the actual free beyond the tlb gather RCU section.

So the reason page->mapping isn't cleared in page_remove_rmap() isn't
detailed beyond a (possible) race with page_add_anon_rmap() (which I
guess would be reclaim trying to unmap the page and a fault re-instating
it).

This also complicates the whole page_lock_anon_vma() thing, so it would
be nice to be able to remove this race and clear page->mapping in
page_remove_rmap().
