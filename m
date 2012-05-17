Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946Ab2EQDIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:08:45 -0400
Received: from linux-sh.org ([111.68.239.195]:53744 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477Ab2EQDIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:08:43 -0400
Date: Thu, 17 May 2012 12:05:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
Message-ID: <20120517030551.GA11623@linux-sh.org>
References: <20110302175928.022902359@chello.nl>
 <20110302180259.109909335@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302180259.109909335@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 06:59:32PM +0100, Peter Zijlstra wrote:
> Might want to optimize the tlb_flush() function to do a full mm flush
> when the range is 'large', IA64 does this too.
> 
> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

The current version in tlb-unify blows up due to a missing
tlb_add_flush() definition. I can see in this thread tlb_track_range()
was factored in, but the __pte_free_tlb()/__pmd_free_tlb() semantics have
changed since then. Adding a dumb tlb_add_flush() that wraps in to
tlb_track_range() seems to do the right thing, but someone more familiar
with LPAE and ARM's double PMDs will have to figure out whether the
tlb_track_range() in asm-generic/tlb.h's pmd/pte_free_tlb() are
sufficient to remove the tlb_add_flush() calls or not.

Here's the dumb build fix for now though:

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index 37dbce9..1de4b21 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -38,6 +38,11 @@ __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp, unsigned long addr);
 
 #include <asm-generic/tlb.h>
 
+static inline void tlb_add_flush(struct mmu_gather *tlb, unsigned long addr)
+{
+	tlb_track_range(tlb, addr, addr + PAGE_SIZE);
+}
+
 static inline void
 __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte, unsigned long addr)
 {
