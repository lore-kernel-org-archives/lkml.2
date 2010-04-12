Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0DLASM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 20:18:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab0DLASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 20:18:10 -0400
Date: Sun, 11 Apr 2010 17:13:26 -0700 (PDT)
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
In-Reply-To: <20100411185508.GA4450@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org> <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic>
 <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
 <20100411185508.GA4450@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Borislav Petkov wrote:
> 
> > Conversely, if you still see the oops (rather than the watchdog), that 
> > means that we actually have pages that are still marked mapped, and that 
> > despite that mapped state have a stale page->mapping pointer. I actually 
> > find that the more likely case, because otherwise the window is _so_ small 
> > that I don't see how you can hit the oops so reliably.
> 
> Ok, did test with the all 5 patches applied. It oopsed with the same
> trace, see below. Except one kernel/sched.c:3555 warning checking
> spinlock count overflowing, nothing else. :(

Ok, that preempt-count thing is a real problem, but should be unrelated to 
your issues.

Anyway, so this all means that we definitely have lost sight of an 
'anon_vma', even if page->mapping still points to it, and even though the 
page is still mapped.

I'll see if I can come up with a patch to do the same kind of validation 
on page->mapping as on the anon-vma chains themselves.

> I tried to see whether the page->mapping pointer is stale, I dunno,
> maybe there could be something in the register dump which could tell us
> what's happening.

Sadly, you cannot tell by the pointer. A stale pointer still is a 
perfectly fine kernel pointer, it's just that we've long since released 
the anon_vma it used to point to, and now it points to some random other 
data structure.

> So, it really looks like at least that list_head in anon_vma is
> bollocks, or even the whole anon_vma. So if this is correct, it is
> highly likely that the anon_vma is already freed material or not
> initialized at all.

Yes, it's pretty certain it is long free'd, and re-allocated to something 
else.

		Linus
