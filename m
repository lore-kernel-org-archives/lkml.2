Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab0DJUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab0DJUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:25:27 -0400
Message-ID: <4BC0DE61.3020001@redhat.com>
Date: Sat, 10 Apr 2010 16:24:01 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2010 04:05 PM, Linus Torvalds wrote:

> And vma_adjust is the one place that does that anon_vma_merge(), which is
> apart from the actual unmapping sequence the only other place that
> actually free's anon_vmas. So there are reasons to be very suspicious of
> that code.

It frees anon_vma_chain structures, but not actual anon_vmas.

Walking the anon_vma (from rmap) requires the anon_vma->lock,
which is taken in anon_vma_merge whenever a chain is unlinked.

> And I think that code can actually lose an anon_vma chain. It's totally
> screwing up the "import anonvma" case: when it does
>
>                          if (anon_vma_clone(importer, vma)) {
>                                  return -ENOMEM;
>                          }
>                          importer->anon_vma = anon_vma;
>
> we can actually have "importer == vma", but "anon_vma = next->anon_vma".

A few lines up from that code, we have:

         if (vma->anon_vma && (insert || importer || start != 
vma->vm_start))
                 anon_vma = vma->anon_vma;

So anon_vma should always be vma->anon_vma.

If we have already imported an anon_vma, we will not
do so twice, because of the !importer->anon_vma check.

What am I overlooking?

> In which case we actually end up with an _empty_ chain (because importer
> didn't have a chain to begin with!) but "importer->anon_vma" points to an
> anon_vma.

If we import a chain, from vma to importer, importer->anon_vma
will be equal to vma->anon_vma.

I do not see how 'importer' could get a state different from 'vma'.

> Also, the conditional nesting makes no sense (the whole anon_vma_clone()
> only makes sense if importer is set, and it is only ever set _inside_ the
> earlier if-statement, so the whole code should be moved inside there), nor
> does some of the comments.

No argument there, vma_adjust is very hard to read and it took
me a few days to convince myself that my changes kept things
equivalent to how they were before.

