Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0DIX0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:26:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab0DIX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:26:49 -0400
Date: Fri, 9 Apr 2010 16:22:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <20100409204328.GG28964@cmpxchg.org>
Message-ID: <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic>
 <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Johannes Weiner wrote:
> +	/*
> +	 * 1. case: vma and next are split parts of one root vma.
> +	 * Their anon_vma_chain is equal and we can drop that of next.
> +	 *
> +	 * 2. case: one vma was instantiated as mergeable with the
> +	 * other one and inherited the other one's primary anon_vma as
> +	 * the singleton in its chain.
> +	 *
> +	 * If next came after vma, vma's chain is already an unstrict
> +	 * superset of next's and we can treat it like case 1.
> +	 *
> +	 * If vma has the singleton chain, we have to copy next's
> +	 * unique anon_vmas over.
> +	 */

This comment makes my head hurt. In fact, the whole anon_vma thing hurts 
my head.

Can we have some better high-level documentation on what happens for all 
the cases.

 - split (mprotect, or munmap in the middle):

	anon_vma_clone: the two vma's will have the same anon_vma, and the 
	anon_vma chains will be equivalent. 

 - merge (mprotect that creates a mergeable state):

	anon_vma_merge: we're supposed to have a anon_vma_chain that is 
	a superset of the two chains of the merged entries.

 - fork:

	anon_vma_fork: each new vma will have a _new_ anon_vma as it's 
	primary one, and will link to the old primary trough the 
	anon_vma_chain. It's doing this with a anon_vma_clone() followed 
	by adding an entra entry to the new anon_vma, and setting 
	vma->anon_vma to the new one.

 - create/mmap:

	anon_vma_prepare: find a mergeable anon_vma and use that as a 
	singleton, because the other entries on the anon_vma chain won't 
	matter, since they cannot be associated with any pages associated 
	with the newly created vma..

Correct?

Quite frankly, just looking at that, I can't see how we get to your rules. 
At least not trivially. Especially with multiple merges, I don't see 
how "singleton" is such a special case.

		Linus
