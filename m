Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0DJAIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:08:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab0DJAIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:08:35 -0400
Date: Fri, 9 Apr 2010 17:03:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <4BBFBC07.3010509@redhat.com>
Message-ID: <alpine.LFD.2.00.1004091657090.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic>
 <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <4BBFBC07.3010509@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Rik van Riel wrote:
> 
> The trick is in the fact that anon_vma_merge is only called
> when vma->anon_vma == vma1->anon_vma.

Sure sure. I still think it's _way_ too complex. See my previous email 
where I suggested one single simple additional rule that I think makes 
things _much_ simpler.

> If the top anon_vmas are different, then anon_vma_merge will
> not be called.

Right. The case of different anon_vma's is the trivial one. I don't worry 
about that.

> That leaves just the split & create cases, which will be
> passed to anon_vma_merge when they are merged.
> 
> In case of split, they will have identical anon_vma chains.

And yes, split is fundamentally simple. Split guarantees that the chains 
look identical.

But:

> In case of create + merge, one of the two VMAs will have
> the whole anon_vma chain, while the other one has just
> the top anon_vma.

THIS is where I think you simplified a lot and said "and magic happens".

The thing is, in the case of create, we create a different chain. That 
simple fact just makes merging fundamentally complicated.  And we now have 
two different chains, and both of those can split, so those differences 
can "spread out". And you need to guarantee that "merge" really works. It 
didn't work in your original code, and quite frankly, I do _not_ think 
it's entirely obvious that it works in Johannes' code either.

Don't get me wrong: _maybe_ Johannes' code works fine. I just don't think 
it's obvious at all. And if it doesn't work fine, now you're just 
spreading the differences even further.

This is why I suggest that we limit the "re-use an existing vma for a new 
case" to the singleton case, which means that now you _never_ have 
differences at all. There's no spreading on splitting. Merging is trivial. 

Now, admittedly, I'm really hopped up on cough medication, so the feeling 
of this solving all the problems in the universe may not be entirely 
accurate. But it feels so _right_.

I hope if feels right when I'm off my meds too.

			Linus
