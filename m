Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1BYVxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:53:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51250 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab1BYVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:53:36 -0500
Date: Fri, 25 Feb 2011 21:51:24 +0000
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
        "Luck,Tony" <tony.luck@intel.com>, PaulMundt <lethal@linux-sh.org>
Subject: Re: [PATCH 06/17] arm: mmu_gather rework
Message-ID: <20110225215123.GA10026@flint.arm.linux.org.uk>
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
	"Luck,Tony" <tony.luck@intel.com>, PaulMundt <lethal@linux-sh.org>
References: <20110217162327.434629380@chello.nl> <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins> <1298657083.2428.2483.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298657083.2428.2483.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 07:04:43PM +0100, Peter Zijlstra wrote:
> I'm not quite sure why you chose to add range tracking on
> pte_free_tlb(), the only affected code path seems to be unmap_region()
> where you'll use a flush_tlb_range(), but its buggy, the pte_free_tlb()
> range is much larger than 1 page, and if you do it there you also need
> it for all the other p??_free_tlb() functions.

My reasoning is to do with the way the LPAE stuff works.  For the
explaination below, I'm going to assume a 2 level page table system
for simplicity.

The first thing to realise is that if we have L2 entries, then we'll
have unmapped them first using the usual tlb shootdown interfaces.

However, when we're freeing the page tables themselves, we should
already have removed the L2 entries, so all we have are the L1 entries.
In most 'normal' processors, these aren't cached in any way.

Howver, with LPAE, these are cached.  I'm told that any TLB flush for an
address which is covered by the L1 entry will cause that cached entry to
be invalidated.

So really this is about getting rid of cached L1 entries, and not the
usual TLB lookaside entries that you'd come to expect.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
