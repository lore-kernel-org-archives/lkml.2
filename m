Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2JLI6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:58:01 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:48737 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2JLI57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:57:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344211200"; 
   d="scan'208";a="15120992"
Message-ID: <1350032276.14806.53.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 3/7]: PVH:  mmu related changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 09:57:56 +0100
In-Reply-To: <20121011145817.0d744c99@mantra.us.oracle.com>
References: <20121011145817.0d744c99@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 22:58 +0100, Mukesh Rathor wrote:
> @@ -2177,8 +2210,19 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
> 
>  void __init xen_init_mmu_ops(void)
>  {
> -       x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
>         x86_init.paging.pagetable_init = xen_pagetable_init;
> +
> +       if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +               pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> +
> +               /* For PCI devices to map iomem. */
> +               if (xen_initial_domain()) {
> +                       pv_mmu_ops.set_pte = native_set_pte;
> +                       pv_mmu_ops.set_pte_at = native_set_pte_at;

What do these end up being for the !xen_initial_domain case? I'd have
expected native_FOO.

> +int xen_unmap_domain_mfn_range(struct vm_area_struct *vma)
> +{
> +       int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +       struct page **pages = vma ? vma->vm_private_data : NULL;

I thought we agreed to keep uses of vm_private_data in the privcmd
driver?

I think you should just add pages and nr as direct parameters to this
function, which is symmetric with the map call.

> +
> +       if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
> +               return 0;
> +
> +       while (numpgs--) {
> +
> +               /* the mmu has already cleaned up the process mmu resources at
> +                * this point (lookup_address will return NULL). */
> +               unsigned long pfn = page_to_pfn(pages[numpgs]);
> +
> +               pvh_rem_xen_p2m(pfn, 1);
> +       }
> +       /* We don't need to flush tlbs because as part of pvh_rem_xen_p2m(),
> +        * the hypervisor will do tlb flushes after removing the p2m entries
> +        * from the EPT/NPT */
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
[...]
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index ef63895..63d9ee8 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -178,7 +178,7 @@ static int mmap_mfn_range(void *data, void *state)
>                                         msg->va & PAGE_MASK,
>                                         msg->mfn, msg->npages,
>                                         vma->vm_page_prot,
> -                                       st->domain);
> +                                       st->domain, NULL);

Might it be useful to BUG_ON(!pages) in pvh_remap_gmfn_range?

Ian.

