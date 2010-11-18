Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0KRMv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:51:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46524 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab0KRMv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:51:28 -0500
Date: Thu, 18 Nov 2010 12:51:12 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 16 of 66] special pmd_trans_* functions
Message-ID: <20101118125112.GM8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <522a9ff792e43eb0ec6a.1288798071@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <522a9ff792e43eb0ec6a.1288798071@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:27:51PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> These returns 0 at compile time when the config option is disabled, to allow
> gcc to eliminate the transparent hugepage function calls at compile time
> without additional #ifdefs (only the export of those functions have to be
> visible to gcc but they won't be required at link time and huge_memory.o can be
> not built at all).
> 
> _PAGE_BIT_UNUSED1 is never used for pmd, only on pte.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---
> 
> diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
> --- a/arch/x86/include/asm/pgtable_64.h
> +++ b/arch/x86/include/asm/pgtable_64.h
> @@ -168,6 +168,19 @@ extern void cleanup_highmap(void);
>  #define	kc_offset_to_vaddr(o) ((o) | ~__VIRTUAL_MASK)
>  
>  #define __HAVE_ARCH_PTE_SAME
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static inline int pmd_trans_splitting(pmd_t pmd)
> +{
> +	return pmd_val(pmd) & _PAGE_SPLITTING;
> +}
> +
> +static inline int pmd_trans_huge(pmd_t pmd)
> +{
> +	return pmd_val(pmd) & _PAGE_PSE;
> +}
> +#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> +
>  #endif /* !__ASSEMBLY__ */
>  
>  #endif /* _ASM_X86_PGTABLE_64_H */
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -22,6 +22,7 @@
>  #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
>  #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
>  #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_UNUSED1
> +#define _PAGE_BIT_SPLITTING	_PAGE_BIT_UNUSED1 /* only valid on a PSE pmd */
>  #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
>  
>  /* If _PAGE_BIT_PRESENT is clear, we use these: */
> @@ -45,6 +46,7 @@
>  #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
>  #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
>  #define _PAGE_CPA_TEST	(_AT(pteval_t, 1) << _PAGE_BIT_CPA_TEST)
> +#define _PAGE_SPLITTING	(_AT(pteval_t, 1) << _PAGE_BIT_SPLITTING)
>  #define __HAVE_ARCH_PTE_SPECIAL
>  
>  #ifdef CONFIG_KMEMCHECK
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -348,6 +348,11 @@ extern void untrack_pfn_vma(struct vm_ar
>  				unsigned long size);
>  #endif
>  
> +#ifndef CONFIG_TRANSPARENT_HUGEPAGE
> +#define pmd_trans_huge(pmd) 0
> +#define pmd_trans_splitting(pmd) 0
> +#endif
> +

Usually it is insisted upon that this looks like

static inline int pmd_trans_huge(pmd) {
	return 0;
}

I understand it's to avoid any possibility of side-effets though to have type
checking and I am 99% certain the compiler still does the right thing. Still,
with no obvious side-effects here;

Acked-by: Mel Gorman <mel@csn.ul.ie>

>  #endif /* !__ASSEMBLY__ */
>  
>  #endif /* _ASM_GENERIC_PGTABLE_H */
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
