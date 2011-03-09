Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1CIPUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:20:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:38503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab1CIPUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:20:12 -0500
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
In-Reply-To: <AANLkTimbRS++SCcKGrUcL5xKsCO+1ygkg+83x7F+2S4i@mail.gmail.com>
References: <20110302175928.022902359@chello.nl>
	 <20110302180259.109909335@chello.nl>
	 <AANLkTimbRS++SCcKGrUcL5xKsCO+1ygkg+83x7F+2S4i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 16:19:24 +0100
Message-ID: <1299683964.2308.3075.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 15:16 +0000, Catalin Marinas wrote:
> Hi Peter,
> 
> On 2 March 2011 17:59, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > --- linux-2.6.orig/arch/arm/include/asm/tlb.h
> > +++ linux-2.6/arch/arm/include/asm/tlb.h
> [...]
> > +__pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte, unsigned long addr)
> >  {
> >        pgtable_page_dtor(pte);
> > -       tlb_add_flush(tlb, addr);
> >        tlb_remove_page(tlb, pte);
> >  }
> 
> I think we still need a tlb_track_range() call here. On the path to
> pte_free_tlb() (for example shift_arg_pages ... free_pte_range) there
> doesn't seem to be any code setting the tlb->start/end range. Did I
> miss anything?

Patch 3 included:

-#define pte_free_tlb(tlb, ptep, address)                       \
-       do {                                                    \
-               tlb->need_flush = 1;                            \
-               __pte_free_tlb(tlb, ptep, address);             \
+#define pte_free_tlb(tlb, ptep, address)                                       \
+       do {                                                                    \
+               tlb->need_flush = 1;                                            \
+               tlb_track_range(tlb, address, pmd_addr_end(address, TASK_SIZE));\
+               __pte_free_tlb(tlb, ptep, address);                             \
        } while (0)

Also, I posted a new version of this series here:

  https://lkml.org/lkml/2011/3/7/308
