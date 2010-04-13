Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0DMKWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:22:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0DMKWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:22:52 -0400
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
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 12:22:23 +0200
Message-ID: <1271154143.4807.1022.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 11:23 +1000, Benjamin Herrenschmidt wrote:
> >  static inline void arch_leave_lazy_mmu_mode(void)
> >  {
> > -     struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
> > +     struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
> > +
> > +     if (batch->active) {
> > +             if (batch->index)
> > +                     __flush_tlb_pending(batch);
> > +             batch->active = 0;
> > +     }
> 
> Can index be > 0 if active == 0 ? I though not, which means you don't
> need to add a test on active, do you ?

True I guess, but like this we avoid a write, doesn't really matter I
suspect.

> I'm also pondering whether we should just stick something in the
> task/thread struct and avoid that whole per-cpu manipulation including
> the stuff in process.c in fact.

Can do, I can add batching similar to the generic code to the
thread_info thingy.

> Heh, maybe it's time to introduce thread vars ? :-) 

Heh, that seems like a real good way to waste a lot of memory fast ;-)
