Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2DZU6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:58:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43449 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab2DZU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:58:23 -0400
Date: Thu, 26 Apr 2012 16:52:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
Message-ID: <20120426205241.GB30926@phenom.dumpdata.com>
References: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120417130340.GA25593@phenom.dumpdata.com>
 <alpine.DEB.2.00.1204171457360.26786@kaball-desktop>
 <20120417144318.GA28477@phenom.dumpdata.com>
 <alpine.DEB.2.00.1204241153380.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204241153380.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:55:43AM +0100, Stefano Stabellini wrote:
> This patch is a significant performance improvement for the
> m2p_override: about 6% using the gntdev device.
> 
> Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
> __flush_tlb_single if kmap_op != NULL.  Batching all the calls together
> is a great performance benefit because it means issuing one hypercall
> total rather than two hypercall per page.
> If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
> going to be batched together, otherwise they are issued one at a time.
> 
> Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
> m2p_add/remove_override calls forces paravirt_lazy_mode to
> PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.
> 
> However it is not safe to call arch_enter_lazy_mmu_mode if we are in
> interrupt context or if we are already in PARAVIRT_LAZY_MMU mode, so
> check for both conditions before doing so.
> 
> Changes in v4:
> - rebased on 3.4-rc4: all the m2p_override users call gnttab_unmap_refs
> and gnttab_map_refs;
> - check whether we are in interrupt context and the lazy_mode we are in
> before calling arch_enter/leave_lazy_mmu_mode.
> 
> Changes in v3:
> - do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
> can be called in interrupt context.
> 

The only thing that I would do differently is to use a bool for lazy. But
I can do myself.

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index e570c6f..a18a3e8 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -38,6 +38,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
> +#include <linux/hardirq.h>
>  
>  #include <xen/xen.h>
>  #include <xen/interface/xen.h>
> @@ -826,7 +827,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  		    struct gnttab_map_grant_ref *kmap_ops,
>  		    struct page **pages, unsigned int count)
>  {
> -	int i, ret;
> +	int i, ret, lazy = 0;
>  	pte_t *pte;
>  	unsigned long mfn;
>  
> @@ -837,6 +838,11 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> +	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +		arch_enter_lazy_mmu_mode();
> +		lazy = 1;
> +	}
> +
>  	for (i = 0; i < count; i++) {
>  		/* Do not add to override if the map failed. */
>  		if (map_ops[i].status)
> @@ -855,6 +861,9 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  			return ret;
>  	}
>  
> +	if (lazy)
> +		arch_leave_lazy_mmu_mode();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gnttab_map_refs);
> @@ -862,7 +871,7 @@ EXPORT_SYMBOL_GPL(gnttab_map_refs);
>  int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>  		      struct page **pages, unsigned int count, bool clear_pte)
>  {
> -	int i, ret;
> +	int i, ret, lazy = 0;
>  
>  	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
>  	if (ret)
> @@ -871,12 +880,20 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> +	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +		arch_enter_lazy_mmu_mode();
> +		lazy = 1;
> +	}
> +
>  	for (i = 0; i < count; i++) {
>  		ret = m2p_remove_override(pages[i], clear_pte);
>  		if (ret)
>  			return ret;
>  	}
>  
> +	if (lazy)
> +		arch_leave_lazy_mmu_mode();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
