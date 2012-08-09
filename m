Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab2HIVnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2HIVnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:43:42 -0400
Date: Thu, 9 Aug 2012 23:43:28 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/19] mm, mpol: Create special PROT_NONE infrastructure
Message-ID: <20120809214328.GH10459@redhat.com>
References: <20120731191204.540691987@chello.nl>
 <20120731192808.647625186@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731192808.647625186@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:12:09PM +0200, Peter Zijlstra wrote:
> +static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
> +{
> +	/*
> +	 * If we have the normal vma->vm_page_prot protections we're not a
> +	 * 'special' PROT_NONE page.
> +	 *
> +	 * This means we cannot get 'special' PROT_NONE faults from genuine
> +	 * PROT_NONE maps, nor from PROT_WRITE file maps that do dirty
> +	 * tracking.
> +	 *
> +	 * Neither case is really interesting for our current use though so we
> +	 * don't care.
> +	 */
> +	if (pte_same(pte, pte_modify(pte, vma->vm_page_prot)))
> +		return false;
> +
> +	return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
> +}
> @@ -3453,6 +3518,9 @@ int handle_pte_fault(struct mm_struct *m
>  					pte, pmd, flags, entry);
>  	}
>  
> +	if (pte_prot_none(vma, entry))
> +		return do_prot_none(mm, vma, address, pte, pmd, flags, entry);
> +
>  	ptl = pte_lockptr(mm, pmd);
>  	spin_lock(ptl);
>  	if (unlikely(!pte_same(*pte, entry)))

I recommend calling it pte_numa, not pte_prot_none(), given you return
true only when it's not the real prot none.

Also I'd leave the details fully hidden in arch code, there's no need
to expose those to common code and force all archs to use the
PROT_NONE bitflag to implement numa hinting page faults. If an arch
wants to avoid touching the vma cacheline to avoid wasting time
computing the vma->vma_page_prot vs pteval, it can use a bitflag
different than protnone like AutoNUMA is currently doing. No reason to
force the use of PROT_NONE at the common code level.

My current implementation of the numa hinting page fault follows:

	spin_lock(ptl);
	if (unlikely(!pte_same(*pte, entry)))
		goto unlock;
	entry = pte_numa_fixup(mm, vma, address, entry, pte);

static inline pte_t pte_numa_fixup(struct mm_struct *mm,
				   struct vm_area_struct *vma,
				   unsigned long addr, pte_t pte, pte_t *ptep)
{
	if (pte_numa(pte))
		pte = __pte_numa_fixup(mm, vma, addr, pte, ptep);
	return pte;
}

I can easily change my entry point a bit to call it before taking the
spinlocks like you're doing to accomodate for your sync migration needs.

But I think it's better implemented like above, by just passing the
vma along until it reaches pte_numa(pte, vma) should be enough.
