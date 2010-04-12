Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab0DLTVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:21:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809Ab0DLTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:21:52 -0400
Date: Mon, 12 Apr 2010 12:17:07 -0700 (PDT)
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
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100412190002.GA8595@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com>
 <20100412190002.GA8595@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Apr 2010, Borislav Petkov wrote:
> 
> But I'll give the patch a run anyway in an hour or so anyway.

Thanks. I suspect you will find that even if there is no actual disk IO 
swapping going on during any of the normal loads, the shrink_all_memory() 
thing in your hibernation event will cause swap to happen. Or at least 
swap-cache entries to be done.

Oh, and I've decided that my rcu_read_lock() patch for the tlb_gather() 
thing for unmapping is bogus. Exactly because the critical issue isn't 
when the page is free'd (and page->mapping is cleared), but when the page 
is unmapped (and page_mapped() clears).

And that is done correctly even with the delayed frees in tlb_gather. So 
addign the rcu_read_lock/rcu_read_unlock around it all doesn't actually 
matter or help.

So the patches that I think fix real bugs are

 - the anon_vma_prepare() fix to only share anon_vma's if they are 
   singletons.

 - the vma_adjust() fix to copy the right anon_vma chains

 - the anon_vma_clone() fix to traverse the avc's in reverse order, so 
   that the resulting cloned chain is the same as the original chain

   You got this patch as part of the "verify_vma()" patch, but the only 
   part of that patch that matters is the one-liner that changes a 
   "for_each_list_entry" to use the "_reverse()" version..

 - and that last patch to pick the right anon_vma when mapping a page 
   (which could still be improved: the "insert new page" case does _not_ 
   have to take the oldest anon_vma, and Rik is correct that if we have an 
   exclusive swap cache entry we could also take the top one)

I think I'll re-post all four patches with real commit messages, to get 
ack's for them. I'd like to finally get the much delayed -rc4 out the 
door.

Oh, and if that "pick the right anon_vma" patch doesn't fix it, I suspect 
we'll have to revert the whole anon_vma changes for 2.6.34. It's getting 
pretty late in the -rc series to fix this bug. I'm _hoping_ that I really 
nailed it this time, and that we're ok, but if Borislav reports it still 
happening, and people not having any other ideas, I think I'll just have 
to do an -rc4 with it all reverted, and then we can try again for 35 if 
somebody figures out the bug.

Hmm? I'd hate to revert it all now because of the hours I've put in 
looking at the code (to the point that I feel I understand it), but at the 
same time, if it was somebody else who was chasing this bug and not being 
able to fix it, I'd tell them "revert it, it's too late". Amount of effort 
spent doesn't matter if the bug still happens ;^(

		Linus
