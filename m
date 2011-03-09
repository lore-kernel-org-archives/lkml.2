Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1CIPtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:49:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:57763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1CIPtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:49:09 -0500
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
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
In-Reply-To: <1299685150.2308.3097.camel@twins>
References: <20110302175928.022902359@chello.nl>
	 <20110302180259.109909335@chello.nl>
	 <AANLkTimbRS++SCcKGrUcL5xKsCO+1ygkg+83x7F+2S4i@mail.gmail.com>
	 <1299683964.2308.3075.camel@twins>
	 <1299684963.19820.344.camel@e102109-lin.cambridge.arm.com>
	 <1299685150.2308.3097.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 16:48:09 +0100
Message-ID: <1299685689.2308.3113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 16:39 +0100, Peter Zijlstra wrote:
> 
> Ok, will try and sort that out. 

We could do something like the below and use the end passed down, which
because it goes top down should be clipped at the appropriate size, just
means touching all the p??_free_tlb() implementations ;-)

Will do on the next iteration ;-)

---

diff --git a/mm/memory.c b/mm/memory.c
index 5823698..833bd90 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -222,11 +222,11 @@ void pmd_clear_bad(pmd_t *pmd)
  * has been handled earlier when unmapping all the memory regions.
  */
 static void free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
-			   unsigned long addr)
+			   unsigned long addr, unsigned long end)
 {
 	pgtable_t token = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
-	pte_free_tlb(tlb, token, addr);
+	pte_free_tlb(tlb, token, addr, end);
 	tlb->mm->nr_ptes--;
 }
 
@@ -244,7 +244,7 @@ static inline void free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		free_pte_range(tlb, pmd, addr);
+		free_pte_range(tlb, pmd, addr, next);
 	} while (pmd++, addr = next, addr != end);
 
 	start &= PUD_MASK;
@@ -260,7 +260,7 @@ static inline void free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
 
 	pmd = pmd_offset(pud, start);
 	pud_clear(pud);
-	pmd_free_tlb(tlb, pmd, start);
+	pmd_free_tlb(tlb, pmd, start, end);
 }
 
 static inline void free_pud_range(struct mmu_gather *tlb, pgd_t *pgd,
@@ -293,7 +293,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, pgd_t *pgd,
 
 	pud = pud_offset(pgd, start);
 	pgd_clear(pgd);
-	pud_free_tlb(tlb, pud, start);
+	pud_free_tlb(tlb, pud, start, end);
 }
 
 /*



