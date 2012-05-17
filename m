Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967451Ab2EQQ7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:59:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:42224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab2EQQ7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:59:48 -0400
Message-ID: <1337273959.4281.62.camel@twins>
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
Date: Thu, 17 May 2012 18:59:19 +0200
In-Reply-To: <1337273053.4281.50.camel@twins>
References: <20110302175928.022902359@chello.nl>
	 <20110302180259.109909335@chello.nl> <20120517030551.GA11623@linux-sh.org>
	 <20120517093022.GA14666@arm.com>
	 <20120517095124.GN23420@flint.arm.linux.org.uk>
	 <1337254086.4281.26.camel@twins> <20120517160012.GB18593@arm.com>
	 <1337271884.4281.46.camel@twins> <1337272396.4281.48.camel@twins>
	 <1337273053.4281.50.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 18:44 +0200, Peter Zijlstra wrote:
> 
> So the RCU code can from ppc in commit
> 267239116987d64850ad2037d8e0f3071dc3b5ce, which has similar behaviour.
> Also I suspect the mm_users < 2 test will be incorrect for ARM since
> even the one user can be concurrent with your speculation engine.
> 
> 
Right, last mail, I promise, I've confused myself enough already! :-)

OK, so ppc/sparc are special (forgot all about s390) I think by the time
they are done with unmap_page_range() their hardware hash-tables are
empty and nobody but software page-table walkers will still access the
linux page tables.

So when we do free_pgtables() to clean up the actual page-tables.
Power/Sparc need to RCU free this to allow concurrent software
page-table walkers like gup_fast.

Thus I don't think they need to tlb flush again because their hardware
doesn't actually walk the link page-tables, it walks hash-tables, which
by this time are empty.

Now if x86/Xen were to use this, it would indeed also need to TLB flush
when freeing the page-tables, since its hardware walkers do indeed
traverse these pages and we need to sync against them.

So my first patch in the tlb-unify tree is actually buggy.

Humm,. what to do adding a tlb flush in there might slow down ppc/sparc
unnecessarily.. dave/ben? I guess we need more knobs :-(


Now its quite possible I've utterly confused myself and everybody
reading, apologies for that, I shall rest and purge all from memory and
start over before commenting more.. 
