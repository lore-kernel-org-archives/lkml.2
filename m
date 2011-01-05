Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1AEUZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:25:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51274 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1AEUY7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 15:24:59 -0500
Date: Wed, 5 Jan 2011 15:23:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/11] xen: introduce gnttab_map_refs and
 gnttab_unmap_refs
Message-ID: <20110105202355.GB29993@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-9-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292420446-3348-9-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 01:40:44PM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> gnttab_map_refs maps some grant refs and uses the new m2p override to
> set a proper m2p mapping for the granted pages.
> 
> gnttab_unmap_refs unmaps the granted refs and removes th mappings from
> the m2p override.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/xen/grant-table.c |   36 ++++++++++++++++++++++++++++++++++++
>  include/xen/grant_table.h |    5 +++++
>  2 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 6c45318..a5cf820 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -447,6 +447,42 @@ unsigned int gnttab_max_grant_frames(void)
>  }
>  EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
>  
> +int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> +		    struct page **pages, unsigned int count)
> +{
> +	int i, ret;
> +	pte_t val;
> +	pte_t *pte;
> +	unsigned long pfn, mfn;
> +
> +	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
> +
> +	for (i = 0; i < count; i++) {
> +		pfn = mfn_to_pfn(map_ops[i].host_addr >> PAGE_SHIFT);

Shouldn't you be checking the flag to see if this a bus address? You could
also use the PFN_DOWN macro here..
> +		pte = (pte_t *) __va((pfn << PAGE_SHIFT) +
> +				(map_ops[i].host_addr & ~PAGE_MASK));

PFN_PHYS(pfn)? Or better You could use the mfn_to_virt macro here:

		pte = (pte_t *) mfn_to_virt(PFN_DOWN(map_ops[i].ost_addr));
		pte += (map_ops[i].host_addr & _PAGE_MASK);

and squash the __va((pfn ..)

> +		val = *pte;
> +		mfn = (native_pte_val(val) & PTE_PFN_MASK) >> PAGE_SHIFT;

mfn = pte_mfn(pte) ?


> +		m2p_add_override(mfn, pages[i]);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(gnttab_map_refs);
> +
> +int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> +		struct page **pages, unsigned int count)
> +{
> +	int i, ret;
> +
> +	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
> +	for (i = 0; i < count; i++)
> +		m2p_remove_override(pages[i]);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
> +
>  static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  {
>  	struct gnttab_setup_table setup;
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 1821aa1..b1fab6b 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -155,4 +155,9 @@ unsigned int gnttab_max_grant_frames(void);
>  
>  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
>  
> +int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> +		    struct page **pages, unsigned int count);
> +int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> +		      struct page **pages, unsigned int count);
> +
>  #endif /* __ASM_GNTTAB_H__ */
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
