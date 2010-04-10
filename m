Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0DJUjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:39:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab0DJUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:39:47 -0400
Date: Sat, 10 Apr 2010 13:34:55 -0700 (PDT)
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
In-Reply-To: <4BC0DE61.3020001@redhat.com>
Message-ID: <alpine.LFD.2.00.1004101324390.3618@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <4BC0DE61.3020001@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Rik van Riel wrote:

> On 04/10/2010 04:05 PM, Linus Torvalds wrote:
> 
> > And vma_adjust is the one place that does that anon_vma_merge(), which is
> > apart from the actual unmapping sequence the only other place that
> > actually free's anon_vmas. So there are reasons to be very suspicious of
> > that code.
> 
> It frees anon_vma_chain structures, but not actual anon_vmas.

Rik, I think you're ignoring the fact that the anon_vma_chain is also the 
implicit refcount.

So when you don't create the chains, you implicitly end up freeing the 
anon_vma too early. In fact, it might well happen at that 
'anon_vma_merge()': when it does the unlink_anon_vmas(), it may be 
unlinking the last remaining anon_vma ref, and then anon_vma_unlink 
_will_ in fact free the anon_vma.

Even though we have a 'vma->anon_vma' pointer that points to it - because 
the chains weren't set up correctly.

> Walking the anon_vma (from rmap) requires the anon_vma->lock,
> which is taken in anon_vma_merge whenever a chain is unlinked.

None of that matters. If the dang thing got free'd, the lock isn't 
reliable any more.

> A few lines up from that code, we have:
> 
>         if (vma->anon_vma && (insert || importer || start != vma->vm_start))
>                 anon_vma = vma->anon_vma;
> 
> So anon_vma should always be vma->anon_vma.

No. vma->anon_vma is NULL, so the above lines are total no-ops. We're 
trying to _fill_ it. But we're doing it wrong.

So we end up with:

	anon_vma = next->anon-vma
	importer = vma

and we do:

	if (anon_vma_clone(importer, vma)) {
		return -ENOMEM;
	}
	importer->anon_vma = anon_vma;

do you see?

The "anon_vma_clone(importer, vma)" does NOTHING, because it is cloning 
from the wrong source (from 'vma', rather than from 'next', so it leaves 
the vma chains empty.

And then, despite having empty chains, we do that

	importer->anon_vma = anon_vma;

which sets the anon_vma to the (non-NULL) next->anon_vma.

And then, a bit later, we'll do

	anon_vma_merge(vma, next);

which will happily notice that the anon_vma's of both vma and next match 
(because we just _set_ them to match), and then frees the ONLY REMAINING 
CHAIN - the one in next. The one we DID NOT CORRECTLY COPY, because we got 
our sources completely screwed up.
	
> What am I overlooking?

Can you see it now?

> If we import a chain, from vma to importer, importer->anon_vma
> will be equal to vma->anon_vma.

The thing you seem to miss is that we aren't supposed to import the chain 
from 'vma' AT ALL. The anon_vma came from _next_, not from 'vma'!

> I do not see how 'importer' could get a state different from 'vma'.

Stop worrying about 'vma'. Start worrying about 'next'.

			Linus
