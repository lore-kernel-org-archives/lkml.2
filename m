Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0DLP4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:56:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab0DLP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:56:08 -0400
Date: Mon, 12 Apr 2010 08:51:21 -0700 (PDT)
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
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <4BC24309.7060004@redhat.com>
Message-ID: <alpine.LFD.2.00.1004120844370.26679@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <4BC24309.7060004@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Rik van Riel wrote:
>
> Another thing I just thought of.
> 
> The anon_vma struct will not be reused for something completely
> different due to the SLAB_DESTROY_BY_RCU flag that the anon_vma_cachep
> is created with.

Rik, we _know_ it got re-used by something totally different. That's 
clearly the problem. The page->mapping pointer does _not_ point to an 
anon_vma any more. That's the problem here.

What we need to figure out is how we have a page on the LRU list that is 
still marked as 'mapped' that has that stale mapping pointer.

I can easily see how the stale mapping pointer happens for a non-mapped 
page. That part is trivial. Here's a simple case:

 - vmscan does that whole "isolate LRU pages", and one of them is a (at 
   that time mapped) anonymous page. It's now not on any LRU lists at all.

 - vmscan ends up waiting for pageout and/or writeback while holding that 
   list of pages.

 - in the meantime, the process that had the page exists or unmaps, 
   unmapping the page and freeing the vma and the anon_vma.

 - vmscan eventually gets to the page, and does that page_referenced() 
   dance. page->mapping points to something that is long long gone (as in 
   "IO access lifetimes", so we're talking something that has been freed 
   literally milliseconds ago, rather than any RCU delays)

So I can see the stale page->mapping pointer happening. That part is even 
trivial. What I don't see is how the page would be still marked 'mapped'. 
Everything that actually free's the vma/anon_vmas should also have 
unmapped the page before that - even if it didn't _free_ the page.

			Linus
