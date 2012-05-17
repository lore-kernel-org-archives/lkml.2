Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342Ab2EQRMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:12:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab2EQRMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:12:12 -0400
Message-ID: <1337274691.4281.63.camel@twins>
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
Date: Thu, 17 May 2012 19:11:31 +0200
In-Reply-To: <20120517170134.GC18593@arm.com>
References: <20110302175928.022902359@chello.nl>
	 <20110302180259.109909335@chello.nl> <20120517030551.GA11623@linux-sh.org>
	 <20120517093022.GA14666@arm.com>
	 <20120517095124.GN23420@flint.arm.linux.org.uk>
	 <1337254086.4281.26.camel@twins> <20120517160012.GB18593@arm.com>
	 <1337271884.4281.46.camel@twins> <1337272396.4281.48.camel@twins>
	 <1337273053.4281.50.camel@twins> <20120517170134.GC18593@arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 18:01 +0100, Catalin Marinas wrote:
> > So the RCU code can from ppc in commit
> > 267239116987d64850ad2037d8e0f3071dc3b5ce, which has similar behaviour.
> > Also I suspect the mm_users < 2 test will be incorrect for ARM since
> > even the one user can be concurrent with your speculation engine.
> 
> That's correct. 

(I'm not sending this... really :-)

---
commit cd94154cc6a28dd9dc271042c1a59c08d26da886
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Wed Apr 11 14:28:07 2012 +0200

    [S390] fix tlb flushing for page table pages
    
    Git commit 36409f6353fc2d7b6516e631415f938eadd92ffa "use generic RCU
    page-table freeing code" introduced a tlb flushing bug. Partially revert
    the above git commit and go back to s390 specific page table flush code.
    
    For s390 the TLB can contain three types of entries, "normal" TLB
    page-table entries, TLB combined region-and-segment-table (CRST) entries
    and real-space entries. Linux does not use real-space entries which
    leaves normal TLB entries and CRST entries. The CRST entries are
    intermediate steps in the page-table translation called translation paths.
    For example a 4K page access in a three-level page table setup will
    create two CRST TLB entries and one page-table TLB entry. The advantage
    of that approach is that a page access next to the previous one can reuse
    the CRST entries and needs just a single read from memory to create the
    page-table TLB entry. The disadvantage is that the TLB flushing rules are
    more complicated, before any page-table may be freed the TLB needs to be
    flushed.
    
    In short: the generic RCU page-table freeing code is incorrect for the
    CRST entries, in particular the check for mm_users < 2 is troublesome.
    
    This is applicable to 3.0+ kernels.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

