Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1B1O7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:59:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53603 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab1B1O7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:59:41 -0500
Date: Mon, 28 Feb 2011 14:57:50 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH 06/17] arm: mmu_gather rework
Message-ID: <20110228145750.GA4911@flint.arm.linux.org.uk>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	akpm@linux-foundation.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Miller <davem@davemloft.net>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	"Luck,Tony" <tony.luck@intel.com>, PaulMundt <lethal@linux-sh.org>,
	Chris Metcalf <cmetcalf@tilera.com>
References: <20110217162327.434629380@chello.nl> <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins> <1298657083.2428.2483.camel@twins> <20110225215123.GA10026@flint.arm.linux.org.uk> <1298893487.2428.10537.camel@twins> <1298902727.2428.10867.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298902727.2428.10867.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 03:18:47PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-02-28 at 12:44 +0100, Peter Zijlstra wrote:
> >   unmap_region()
> >     tlb_gather_mmu()
> >     unmap_vmas()
> >       for (; vma; vma = vma->vm_next)
> >         unmao_page_range()
> >           tlb_start_vma() -> flush cache range
> 
> So why is this correct? Can't we race with a concurrent access to the
> memory region (munmap() vs other thread access race)? While
> unmap_region() callers will have removed the vma from the tree so faults
> will not be satisfied, TLBs might still be present and allow us to
> access the memory and thereby reloading it in the cache.

It is my understanding that code sections between tlb_gather_mmu() and
tlb_finish_mmu() are non-preemptible - that was the case once upon a
time when this stuff first appeared.  If that's changed then that
change has introduced an unnoticed bug.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
