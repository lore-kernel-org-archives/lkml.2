Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab0DLQGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:06:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab0DLQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:06:38 -0400
Date: Mon, 12 Apr 2010 09:02:03 -0700 (PDT)
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
In-Reply-To: <20100412072056.GA2432@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
 <20100412072056.GA2432@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Apr 2010, Borislav Petkov wrote:
> > 
> > If the warnings do happen, they are not going to be printing out any 
> > hugely informative data apart from the fact that the bad case happened at 
> > all. But If they do trigger, I can try to improve on them - it's just not 
> > worth trying to make them any more interesting if they never trigger.
> 
> Haa, I think you're gonna want to improve them :)
> 
> 	WARN_ONCE(1, "page->mapping does not exist in vma chain");
> 
> triggered on the first resume showing a rather messy 4 WARN_ONCEs. Had I
> more cores, there maybe would've been more of them :) Maybe need locking
> if clean output is of interest (see below).

Goodie.

I can't trigger this on my machine (not that I tried very hard - but I did 
do some swapping loads etc by limiting my memory to just 1GB etc). So I'm 
pretty sure my verification code is "correct", and verifies things that 
should be right.

And the fact that it triggers under the exact load that you use to then 
trigger the bug is a damn good thing.  That means that we are finally on 
the right track, and we have somethign that correlates well with the 
actual bug.

> So, anyway, if I can read this correctly, there is a page->mapping
> anon_vma which is _not_ in the anon_vmas chain of the vma
> (avc->same_vma).

Yes, and that is supposed to be a no-no. The page is clearly associated 
with the vma in question (since we are unmapping it through that vma), but 
the vma list of 'anon_vma's doesn't actually have the one that 
'page->mapping' points to.

And that, in turn, means that we've lost sight of the 'page->mapping' 
anon_vma, and THAT in turn means that it could well have been free'd as 
being no longer referenced.

And if it was free'd, it could be re-allocated as something else (after 
the RCU grace period), and that directly explains your oops.

> By the way, I completely understand when you say that your head hurts
> from looking at this :).

Well, I have to say that I'm happy I've spent the time on it, because this 
way I got to learn all the new rules. It's just that I really wish I 
wouldn't have _had_ to.

Anyway, I'll have to think way more about this to see if I can come up 
with a debugging patch that shows more details about what actually caused 
this to happen in the first place. But we definitely have a smoking gun.

		Linus
