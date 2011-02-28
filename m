Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1B1M02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:26:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:49771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1B1M0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:26:25 -0500
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
In-Reply-To: <20110228120651.GA25657@flint.arm.linux.org.uk>
References: <20110217162327.434629380@chello.nl>
	 <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins>
	 <1298657083.2428.2483.camel@twins>
	 <20110225215123.GA10026@flint.arm.linux.org.uk>
	 <1298893487.2428.10537.camel@twins>
	 <20110228115907.GB492@flint.arm.linux.org.uk>
	 <20110228120651.GA25657@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 13:25:42 +0100
Message-ID: <1298895942.2428.10639.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 12:06 +0000, Russell King wrote:
> 
> As I think I mentioned, the TLB shootdown interface either needs rewriting
> from scratch as its currently a broken design, or it needs tlb_gather_mmu()
> to take a proper mode argument, rather than this useless 'fullmm' argument
> which only gives half the story.
> 
> The fact is that the interface has three modes, and distinguishing between
> them requires a certain amount of black magic.  Explicitly, the !fullmm
> case has two modes, and it requires implementations to remember whether
> tlb_start_vma() has been called before tlb_finish_mm() or not.
> 
> Maybe this will help you understand the ARM implementation - this doesn't
> change the functionality, but may make things clearer.

I've actually implemented that, but it didn't really help much.

Mostly because you want your TLB flush to be after freeing the
page-tables, not before it.

So I want to avoid having to flush at tlb_end_vma() _and_ at
tlb_finish_mmu(), and doing that needs a flush_tlb_range() that doesn't
need a vma.

ARM also does the whole IPI thing on TLB flush, so a gup_fast()
implementation for arm would also need that TLB flush after page-table
tear-down, not on tlb_end_vma().

And once you want a single TLB invalidate, it doesn't matter if you want
to track ranges for p*_free_tlb() too.
