Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1B1PEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:04:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:43306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1B1PE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:04:27 -0500
Subject: Re: [PATCH 06/17] arm: mmu_gather rework
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck,Tony" <tony.luck@intel.com>, PaulMundt <lethal@linux-sh.org>,
        Chris Metcalf <cmetcalf@tilera.com>
In-Reply-To: <20110228145750.GA4911@flint.arm.linux.org.uk>
References: <20110217162327.434629380@chello.nl>
	 <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins>
	 <1298657083.2428.2483.camel@twins>
	 <20110225215123.GA10026@flint.arm.linux.org.uk>
	 <1298893487.2428.10537.camel@twins> <1298902727.2428.10867.camel@twins>
	 <20110228145750.GA4911@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 16:05:48 +0100
Message-ID: <1298905548.5226.848.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 14:57 +0000, Russell King wrote:
> On Mon, Feb 28, 2011 at 03:18:47PM +0100, Peter Zijlstra wrote:
> > On Mon, 2011-02-28 at 12:44 +0100, Peter Zijlstra wrote:
> > >   unmap_region()
> > >     tlb_gather_mmu()
> > >     unmap_vmas()
> > >       for (; vma; vma = vma->vm_next)
> > >         unmao_page_range()
> > >           tlb_start_vma() -> flush cache range
> > 
> > So why is this correct? Can't we race with a concurrent access to the
> > memory region (munmap() vs other thread access race)? While
> > unmap_region() callers will have removed the vma from the tree so faults
> > will not be satisfied, TLBs might still be present and allow us to
> > access the memory and thereby reloading it in the cache.
> 
> It is my understanding that code sections between tlb_gather_mmu() and
> tlb_finish_mmu() are non-preemptible - that was the case once upon a
> time when this stuff first appeared.  

It is still so, but that doesn't help with SMP. The case mentioned above
has two threads running, one doing munmap() and the other is poking at
the memory being unmapped.

Afaict, even when its all non-preemptible, the remote cpu can
re-populate the cache you just flushed through existing TLB entries.

> If that's changed then that change has introduced an unnoticed bug.

I've got such a patch-set pending, but I cannot see how that would
change the semantics other than that the above race becomes possible on
a single CPU.



