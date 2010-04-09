Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0DIQk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:40:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527Ab0DIQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:40:23 -0400
Date: Fri, 9 Apr 2010 09:35:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100409092111.GA998@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org> <20100408101925.FB9F.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org> <20100408054707.GA9299@a1.tnic> <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <20100408210035.GA25834@a1.tnic> <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Borislav Petkov wrote:
> 
> So I went and reapplied the three patches (3rd is the object_err export
> for SLUB debugging) on a new branch of today's git - same results, the
> same processes crap up in the WARN(!vma->anon_vma) check so it should be
> something else we're missing.
> 
> More code staring later...

Can you try with _just_ my patch? Or add a 

	vma->anon_vma = merge_vma->anon_vma;

to Rik's "merge_vma" case in anon_vma_prepare().

Because I'm starign at Rik's patch, and one thing strikes me: it does that 
"anon_vma_clone()" in anon_vma_prepare(), and maybe I'm blind, but I don't 
see where that actually sets vma->anon_vma.

As far as I can tell, anon_vma_clone() was designed purely for the fork() 
case, which has done

	*new = *vma;

which will set new->anon_vma to the same vma. But Rik's patch never does 
that for the anon_vma_prepare() case.

And maybe we should do it in anon_vma_clone() itself, just to make it 
impossible to mistakenly leave it out, the way I think Rik's patch did.

Anyway, I'm still groggy from allt he flu medication, so take everything I 
say with a grain of salt.

In fact, the more I look at this, the less I think I like Rik's patch in 
the first place. I think the real bug that Rik tried to fix is that 
apparently anon_vma_merge() doesn't necessarily merge everything right. 
>From Rik's bug-explanation, step 5:

>> 5) vma_adjust calls anon_vma_merge, causing the anon_vma
>>    chain of one of the VMAs to get nuked - with bad luck,
>>    this is the original one, leaving just the new anon_vma
>>   attached to the VMA

and I think that _this_ is the real bug to begin with. The real fix should 
be in vma_adjust/anon_vma_merge, not in how we set up the anon_vma in the 
first place. I do _not_ think we should require that we always merged 
things at mmap() time, because we may _never_ be able to merge perfectly 
(ie start out with to disjoing mmaps, and fill in the middle).

			Linus
