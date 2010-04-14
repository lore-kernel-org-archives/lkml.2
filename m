Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0DOHdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:33:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab0DOH3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:37 -0400
Subject: Re: [PATCH 07/13] powerpc: Preemptible mmu_gather
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1271121817.13059.19.camel@pasglop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.901224587@chello.nl>  <1271121817.13059.19.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 15:34:36 +0200
Message-ID: <1271252076.32749.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 11:23 +1000, Benjamin Herrenschmidt wrote:
> > +      * A comment here about on why we have RCU freed page tables might be
> > +      * interesting, also explaining why we don't need any sort of grace
> > +      * period for mm_users == 1, and have some home brewn smp_call_func()
> > +      * for single frees.
> 
> iirc, we are synchronizing with CPUs walking page tables in their hash
> or TLB miss code, which is lockless. The mm_users test is a -little- bit
> dubious indeed. It may have to be mm_users < 2 && mm ==
> current->active_mm, ie, we know for sure nobody else is currently
> walking those page tables ... 
> 
> Tho even than is fishy nowadays. We -can- walk page tables on behave of
> another process. In fact, we do it in the Cell SPU code for faulting
> page table entries as a result of SPEs taking faults for example. So I'm
> starting to suspect that this mm_users optimisation is bogus.
> 
> We -do- want to optimize out the case where there is no user left
> though, ie, the MM is dead. IE. The typical exit case.

Can't you fix that by having the SPE code take a reference on these
mm_structs they're playing with?

Poking at one without a ref seems fishy anyway.

