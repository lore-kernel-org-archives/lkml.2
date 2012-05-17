Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab2EQQor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:44:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47464 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab2EQQop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:44:45 -0400
Message-ID: <1337273053.4281.50.camel@twins>
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Thu, 17 May 2012 18:44:13 +0200
In-Reply-To: <1337272396.4281.48.camel@twins>
References: <20110302175928.022902359@chello.nl>
	 <20110302180259.109909335@chello.nl> <20120517030551.GA11623@linux-sh.org>
	 <20120517093022.GA14666@arm.com>
	 <20120517095124.GN23420@flint.arm.linux.org.uk>
	 <1337254086.4281.26.camel@twins> <20120517160012.GB18593@arm.com>
	 <1337271884.4281.46.camel@twins> <1337272396.4281.48.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 18:33 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-17 at 18:24 +0200, Peter Zijlstra wrote:
> > On Thu, 2012-05-17 at 17:00 +0100, Catalin Marinas wrote:
> > 
> > > BTW, looking at your tlb-unify branch, does tlb_remove_table() call
> > > tlb_flush/tlb_flush_mmu before freeing the tables?  I can only see
> > > tlb_remove_page() doing this. On ARM, even UP, we need the TLB flushing
> > > after clearing the pmd and before freeing the pte page table (and
> > > ideally doing it less often than at every pte_free_tlb() call).
> > 
> > No I don't think it does, so far the only archs using the RCU stuff are
> > ppc,sparc and s390 and none of those needed that (Xen might join them
> > soon though). But I will have to look and consider this more carefully.
> > I 'lost' most of the ppc/sparc/s390 details from memory to say this with
> > any certainty.
> 
> 
> Hmm, no, thinking more that does indeed sounds strange, I'll still have
> to consider it more carefully, but I think you might have found a bug
> there.

So the RCU code can from ppc in commit
267239116987d64850ad2037d8e0f3071dc3b5ce, which has similar behaviour.
Also I suspect the mm_users < 2 test will be incorrect for ARM since
even the one user can be concurrent with your speculation engine.


