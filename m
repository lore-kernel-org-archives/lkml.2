Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1AJV2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:28:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46855 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1AJV2B (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 16:28:01 -0500
Date: Mon, 10 Jan 2011 16:26:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/9] mm: add apply_to_page_range_batch()
Message-ID: <20110110212628.GC15016@dumpdata.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
 <8c28c76840fcc7b76c7c8ce4dc28a57241243df7.1292450600.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c28c76840fcc7b76c7c8ce4dc28a57241243df7.1292450600.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip..
>  static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  				     unsigned long addr, unsigned long end,
> -				     pte_fn_t fn, void *data)
> +				     pte_batch_fn_t fn, void *data)
>  {
>  	pte_t *pte;
>  	int err;
> -	pgtable_t token;
>  	spinlock_t *uninitialized_var(ptl);
>  
>  	pte = (mm == &init_mm) ?
> @@ -1940,25 +1939,17 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  	BUG_ON(pmd_huge(*pmd));
>  
>  	arch_enter_lazy_mmu_mode();
> -
> -	token = pmd_pgtable(*pmd);
> -
> -	do {
> -		err = fn(pte++, addr, data);
> -		if (err)
> -			break;
> -	} while (addr += PAGE_SIZE, addr != end);
> -
> +	err = fn(pte, (end - addr) / PAGE_SIZE, addr, data);
>  	arch_leave_lazy_mmu_mode();
>  
>  	if (mm != &init_mm)
> -		pte_unmap_unlock(pte-1, ptl);
> +		pte_unmap_unlock(pte, ptl);

That looks like a bug fix as well? Did this hit us before the change or was
it masked by the fact that the code never go to here?

>  	return err;
>  }
