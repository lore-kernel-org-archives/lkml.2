Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0DFXcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:32:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757679Ab0DFXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:32:17 -0400
Date: Tue, 6 Apr 2010 16:27:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100406225925.GA3446@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org> <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org> <20100406205123.GC20357@a1.tnic> <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
 <20100406225925.GA3446@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Borislav Petkov wrote:
> 
> Ok, I tried doing all you suggested and here's what came out. Please,
> take this with a grain of salt because I'm almost falling asleep - even
> the coffee is not working anymore so it could be just as well that I've
> made a mistake somewhere (the new OOPS is a #GP, by the way), just
> watch:

Hey ho, yeah.

The reason it's a #GP fault is that it's not a NULL pointer dereference 
any more, but a wild pointer that is not in the legal region of pointers 
on x86-64. That is also why your debugging code didn't catch it: the 
pointer isn't NULL, so you got the #GP fault on the same old instruction:

	  2b:*	49 8b 45 20          	mov    0x20(%r13),%rax     <-- trapping instruction

for all the same old reasons.

But now %r13 has a non-zero value: 0x002e2e2e002e2e0e, which I do _not_ 
recognize as any of the normal poison values.

> and %r13 contains some funny stuff, could be some mangled SLUB debug
> poison or something: R13: 002e2e2e002e2e0e. Maybe this is the reason for
> the #GP.

Correct. You don't get a page fault if the pointer was totally bogus

> But yes, even if the oopsing instruction is
> 
> movq	32(%r13), %rax	# <variable>.same_anon_vma.next, <variable>.same_anon_vma.next
> 
> this is not same_anon_vma.next because we've come to the above
> instruction through the ".L186:" label, before which we have %r13
> already loaded with anon_vma->head.next.

No, you're mis-reading the asm. It's again the first iteration, and the 
code above it is again the end of the loop. And %rax is once more a kernel 
pointer, not the return value of 'page_referenced_one()'. 

So it once more is 'anon_vma->head.next' that is crap, but now it's not 
NULL, it's that very odd 0x002e2e2e002e2e2e pattern (the %r13 has had 0x20 
subtracted from it, so that LSB of "0x0e" is actually _also_ a 0x2e).

What does '0x2e' mean? It's ASCII '.', but that doesn't really mean 
anything either.

			Linus
