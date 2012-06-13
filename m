Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2FMTqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:46:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20215 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2FMTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:46:48 -0400
Date: Wed, 13 Jun 2012 15:39:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xen: mark local pages as FOREIGN in the m2p_override
Message-ID: <20120613193926.GA21706@phenom.dumpdata.com>
References: <1337795840-10061-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337795840-10061-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 06:57:20PM +0100, Stefano Stabellini wrote:
> When the frontend and the backend reside on the same domain, even if we
> add pages to the m2p_override, these pages will never be returned by
> mfn_to_pfn because the check "get_phys_to_machine(pfn) != mfn" will
> always fail, so the pfn of the frontend will be returned instead
> (resulting in a deadlock because the frontend pages are already locked).

If I recall you were suppose to attach the stack trace here
and also explain a bit about how the lock happens (like a call-tree).

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
>  arch/x86/xen/p2m.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 1b267e7..00a0385 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -686,6 +686,7 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>  	unsigned long uninitialized_var(address);
>  	unsigned level;
>  	pte_t *ptep = NULL;
> +	int ret = 0;
>  
>  	pfn = page_to_pfn(page);
>  	if (!PageHighMem(page)) {
> @@ -721,6 +722,24 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
>  
> +	/* p2m(m2p(mfn)) == mfn: the mfn is already present somewhere in
> +	 * this domain. Set the FOREIGN_FRAME_BIT in the p2m for the other
> +	 * pfn so that the following mfn_to_pfn(mfn) calls will return the
> +	 * pfn from the m2p_override (the backend pfn) instead.
> +	 * We need to do this because the pages shared by the frontend
> +	 * (xen-blkfront) can be already locked (lock_page, called by
> +	 * do_read_cache_page); when the userspace backend tries to use them
> +	 * with direct_IO, mfn_to_pfn returns the pfn of the frontend, so
> +	 * do_blockdev_direct_IO is going to try to lock the same pages
> +	 * again resulting in a deadlock.
> +	 * As a side effect get_user_pages_fast might not be safe on the
> +	 * frontend pages while they are being shared with the backend,
> +	 * because mfn_to_pfn (that ends up being called by GUPF) will
> +	 * return the backend pfn rather than the frontend pfn. */
> +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> +	if (ret == 0 && get_phys_to_machine(pfn) == mfn)
> +		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(m2p_add_override);
> @@ -732,6 +751,7 @@ int m2p_remove_override(struct page *page, bool clear_pte)
>  	unsigned long uninitialized_var(address);
>  	unsigned level;
>  	pte_t *ptep = NULL;
> +	int ret = 0;
>  
>  	pfn = page_to_pfn(page);
>  	mfn = get_phys_to_machine(pfn);
> @@ -801,6 +821,22 @@ int m2p_remove_override(struct page *page, bool clear_pte)
>  	} else
>  		set_phys_to_machine(pfn, page->index);
>  
> +	/* p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
> +	 * somewhere in this domain, even before being added to the
> +	 * m2p_override (see comment above in m2p_add_override).
> +	 * If there are no other entries in the m2p_override corresponding
> +	 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
> +	 * the original pfn (the one shared by the frontend): the backend
> +	 * cannot do any IO on this page anymore because it has been
> +	 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
> +	 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
> +	 * pfn again. */
> +	mfn &= ~FOREIGN_FRAME_BIT;
> +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> +	if (ret == 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
> +			m2p_find_override(mfn) == NULL)
> +		set_phys_to_machine(pfn, mfn);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(m2p_remove_override);
> -- 
> 1.7.2.5
