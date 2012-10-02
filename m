Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2JBW6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2JBW6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:58:10 -0400
Date: Wed, 3 Oct 2012 00:58:03 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Subject: Re: [PATCH 7/8] mm: thp: Use more portable PMD clearing sequenece in
 zap_huge_pmd().
Message-ID: <20121002225803.GT4763@redhat.com>
References: <20121002.182741.650740858374403508.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002.182741.650740858374403508.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:27:41PM -0400, David Miller wrote:
> 
> Invalidation sequences are handled in various ways on various
> architectures.
> 
> One way, which sparc64 uses, is to let the set_*_at() functions
> accumulate pending flushes into a per-cpu array.  Then the
> flush_tlb_range() et al. calls process the pending TLB flushes.
> 
> In this regime, the __tlb_remove_*tlb_entry() implementations are
> essentially NOPs.
> 
> The canonical PTE zap in mm/memory.c is:
> 
> 			ptent = ptep_get_and_clear_full(mm, addr, pte,
> 							tlb->fullmm);
> 			tlb_remove_tlb_entry(tlb, pte, addr);
> 
> With a subsequent tlb_flush_mmu() if needed.
> 
> Mirror this in the THP PMD zapping using:
> 
> 		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
> 		page = pmd_page(orig_pmd);
> 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> 
> And we properly accomodate TLB flush mechanims like the one described
> above.

Thanks for the explanation.

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
