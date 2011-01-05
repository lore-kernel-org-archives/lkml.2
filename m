Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1AEU0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:26:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52434 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1AEU0I (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 15:26:08 -0500
Date: Wed, 5 Jan 2011 15:24:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Derek G. Murray" <Derek.Murray@cl.cam.ac.uk>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 06/11] xen: gntdev: move use of GNTMAP_contains_pte
 next to the map_op
Message-ID: <20110105202425.GD29993@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292420446-3348-6-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 01:40:41PM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> This flag controls the meaning of gnttab_map_grant_ref.host_addr and
> specifies that the field contains a refernce to the pte entry to be
                                      ^^^^^^^^ - reference

> used to perform the mapping. Therefore move the use of this flag to
> the point at which we actually use a reference to the pte instead of
> something else, splitting up the usage of the flag in this way is
> confusing and potentially error prone.
> 
> The other flags are all properties of the mapping itself as opposed to
> properties of the hypercall arguments and therefore it make sense to
> continue to pass them round in map->flags.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
> Cc: Derek G. Murray <Derek.Murray@cl.cam.ac.uk>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/xen/gntdev.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index cf61c7d..b916d6b 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -205,10 +205,12 @@ static int find_grant_ptes(pte_t *pte, pgtable_t token, unsigned long addr, void
>  	BUG_ON(pgnr >= map->count);
>  	pte_maddr  = (u64)pfn_to_mfn(page_to_pfn(token)) << PAGE_SHIFT;
>  	pte_maddr += (unsigned long)pte & ~PAGE_MASK;
> -	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, map->flags,
> +	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr,
> +			  GNTMAP_contains_pte | map->flags,

Ok, but the gnttab_set_map_op will do the exact thing it did before. It still does this:

map->host_addr = addr;

irregardless if you pass in any flag.

>  			  map->grants[pgnr].ref,
>  			  map->grants[pgnr].domid);
> -	gnttab_set_unmap_op(&map->unmap_ops[pgnr], pte_maddr, map->flags,
> +	gnttab_set_unmap_op(&map->unmap_ops[pgnr], pte_maddr,
> +			    GNTMAP_contains_pte | map->flags,
>  			    0 /* handle */);
>  	return 0;
>  }
> @@ -579,7 +581,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
>  	vma->vm_private_data = map;
>  	map->vma = vma;
>  
> -	map->flags = GNTMAP_host_map | GNTMAP_application_map | GNTMAP_contains_pte;
> +	map->flags = GNTMAP_host_map | GNTMAP_application_map;
>  	if (!(vma->vm_flags & VM_WRITE))
>  		map->flags |= GNTMAP_readonly;
>  
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
