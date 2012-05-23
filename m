Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2EWO1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:27:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25696 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2EWO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:27:37 -0400
Date: Wed, 23 May 2012 10:20:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: mark local pages as FOREIGN in the m2p_override
Message-ID: <20120523142057.GA7598@phenom.dumpdata.com>
References: <1336994587-10203-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336994587-10203-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:23:07PM +0100, Stefano Stabellini wrote:
> When the frontend and the backend reside on the same domain, even if we
> add pages to the m2p_override, these pages will never be returned by
> mfn_to_pfn because the check "get_phys_to_machine(pfn) != mfn" will
> always fail, so the pfn of the frontend will be returned instead
> (resulting in a deadlock because the frontend pages are already locked).
> 
> However m2p_add_override can easily find out whether another pfn
> corresponding to the mfn exists in the m2p, and can set the FOREIGN bit
> in the p2m, making sure that mfn_to_pfn returns the pfn of the backend.
> 
> This allows the backend to perform direct_IO on these pages, but as a
> side effect prevents the frontend from using get_user_pages_fast on
> them while they are being shared with the backend.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/p2m.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 7ece122..c62ae5c 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -687,6 +687,7 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>  	unsigned long uninitialized_var(address);
>  	unsigned level;
>  	pte_t *ptep = NULL;
> +	int ret = 0;
>  
>  	pfn = page_to_pfn(page);
>  	if (!PageHighMem(page)) {
> @@ -722,6 +723,16 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
>  
> +	/* p2m(m2p(mfn)) == mfn: the mfn is already present somewhere in
> +	 * this domain. Set the FOREIGN_FRAME_BIT in the p2m for the other

<nods> In other words, the MFN is local. And you want it to be forced
to be !local - foreign right.

> +	 * pfn so that the following mfn_to_pfn(mfn) calls will return the

.. the other pfn being. So we want to override p2m(m2p(mfn)) == mfn[frontend]
so that it becomes p2m(m2p(mfn)) == mfn[backend]? (nods)

What happens if multiple m2p_add_override are called on the same page?
This would be possible if the xen-blkfront is setup shared for the same
disk, right?

Won't we loose the old frontend PFN -> backend MFN information then as
we would overwrite the old P2M relationship?


> +	 * pfn from the m2p_override (the backend pfn) instead.

Can you explain in the comment why we want to do that. I think
I know, but I am not going to remember it in a month.


> +	 * As a side effect GUPF might not be safe on the frontend pages
> +	 * while they are being shared with the backend. */

How is it not safe?

> +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> +	if (ret >= 0 && get_phys_to_machine(pfn) == mfn)

if (ret == 0)

[get_user only provides -EFAULT or 0]

> +		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(m2p_add_override);
> @@ -733,6 +744,7 @@ int m2p_remove_override(struct page *page, bool clear_pte)
>  	unsigned long uninitialized_var(address);
>  	unsigned level;
>  	pte_t *ptep = NULL;
> +	int ret = 0;
>  
>  	pfn = page_to_pfn(page);
>  	mfn = get_phys_to_machine(pfn);
> @@ -802,6 +814,12 @@ int m2p_remove_override(struct page *page, bool clear_pte)
>  	} else
>  		set_phys_to_machine(pfn, page->index);
>  

You also need a comment here.

> +	mfn &= ~FOREIGN_FRAME_BIT;
> +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> +	if (ret >= 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&

ret == 0
> +			m2p_find_override(mfn) == NULL)
> +		set_phys_to_machine(pfn, mfn);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(m2p_remove_override);
> -- 
> 1.7.2.5
