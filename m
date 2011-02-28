Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1B1OTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:19:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1B1OTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:19:54 -0500
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
In-Reply-To: <1298893487.2428.10537.camel@twins>
References: <20110217162327.434629380@chello.nl>
	 <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins>
	 <1298657083.2428.2483.camel@twins>
	 <20110225215123.GA10026@flint.arm.linux.org.uk>
	 <1298893487.2428.10537.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 15:18:47 +0100
Message-ID: <1298902727.2428.10867.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 12:44 +0100, Peter Zijlstra wrote:
>   unmap_region()
>     tlb_gather_mmu()
>     unmap_vmas()
>       for (; vma; vma = vma->vm_next)
>         unmao_page_range()
>           tlb_start_vma() -> flush cache range

So why is this correct? Can't we race with a concurrent access to the
memory region (munmap() vs other thread access race)? While
unmap_region() callers will have removed the vma from the tree so faults
will not be satisfied, TLBs might still be present and allow us to
access the memory and thereby reloading it in the cache.

>           zap_*_range()
>             ptep_get_and_clear_full() -> batch/track external tlbs
>             tlb_remove_tlb_entry() -> batch/track external tlbs
>             tlb_remove_page() -> track range/batch page
>           tlb_end_vma() -> flush tlb range
> 
>  [ for architectures that have hardware page table walkers
>    concurrent faults can still load the page tables ]
> 
>     free_pgtables()
>       while (vma)
>         unlink_*_vma()
>         free_*_range()
>           *_free_tlb()
>     tlb_finish_mmu()
> 
>   free vmas 
