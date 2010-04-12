Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0DLXzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:55:00 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:36771 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0DLXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:54:59 -0400
Date: Tue, 13 Apr 2010 01:54:31 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH 1/4] Simplify and comment on anon_vma re-use for anon_vma_prepare()
Message-ID: <20100412235431.GA20163@cmpxchg.org>
References: <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Apr 12, 2010 at 01:22:33PM -0700, Linus Torvalds wrote:
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 10 Apr 2010 10:36:19 -0700
> Subject: [PATCH 1/4] Simplify and comment on anon_vma re-use for anon_vma_prepare()
> 
> This changes the anon_vma reuse case to require that we only reuse
> simple anon_vma's - ie the case when the vma only has a single anon_vma
> associated with it.
> 
> This means that a reuse of an anon_vma from an adjacent vma will always
> guarantee that both vma's are associated not onyl with the same
> anon_vma, they will also have the same anon_vma chain (of just a single
> entry in this case).
> 
> And since anon_vma re-use was the only case where the same anon_vma
> might be associated with different chains of anon_vma's, we now have the
> case that every vma that shares the same vma will always also have the

                                           ^^^ That should be anon_vma?

> same chain.  That makes it much easier to think about merging vma's that
> share the same anon_vma's: you can always just drop the other anon_vma
> chain in anon_vma_merge() since you know that they are always identical.

I like to think of 'incomplete' and 'complete' versions of the same
chain and that this new rule of yours simplifies things by limiting
reuse to the cases where the incomplete and the complete version
end up identical.  I can live with your wording, though :)

> This also splits up the function to validate the anon_vma re-use, and
> adds a lot of commentary about the possible races.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

That said, I still don't like that the vma comparisons differ depending
on whether we reuse an anon_vma or merge vmas.  In my happy-place, the
same vma comparison function is predicate for both cases, so I actually
liked that aspect of the old code, but I also see that code reuse is a
PITA in that file...  Ah well, that can still be cleaned up later.
