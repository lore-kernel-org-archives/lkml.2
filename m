Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab2HFQXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:23:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:5864 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab2HFQXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:23:05 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="33714898"
Message-ID: <501FEF65.1000304@citrix.com>
Date: Mon, 6 Aug 2012 17:23:01 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <linaro-dev@lists.linaro.org>, <Ian.Campbell@citrix.com>,
        <arnd@arndb.de>, <konrad.wilk@oracle.com>, <catalin.marinas@arm.com>,
        <tim@xen.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v2 07/23] xen/arm: Xen detection and shared_info
 page mapping
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com> <1344263246-28036-7-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1344263246-28036-7-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/12 15:27, Stefano Stabellini wrote:
> Check for a "/xen" node in the device tree, if it is present set
> xen_domain_type to XEN_HVM_DOMAIN and continue initialization.
> 
> Map the real shared info page using XENMEM_add_to_physmap with
> XENMAPSPACE_shared_info.
> 
> Changes in v2:
> 
> - replace pr_info with pr_debug.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index d27c2a6..102d823 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -5,6 +5,9 @@
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_address.h>
>  
>  struct start_info _xen_start_info;
>  struct start_info *xen_start_info = &_xen_start_info;
> @@ -33,3 +36,52 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  	return -ENOSYS;
>  }
>  EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
> +
> +/*
> + * == Xen Device Tree format ==
> + * - /xen node;
> + * - compatible "arm,xen";
> + * - one interrupt for Xen event notifications;
> + * - one memory region to map the grant_table.
> + */

These needs to be documented in Documentation/devicetree/bindings/ and
should be sent to the devicetree-discuss mailing list for review.

The node should be called 'hypervisor' I think.

The first word of the compatible string is the vendor/organization that
defined the binding so should be "xen" here.  This does give a odd
looking "xen,xen" but we'll have to live with that.

I'd suggest that the DT provided by the hypervisor or tools give the
hypercall ABI version in the compatible string as well.  e.g.,

hypervisor {
    compatible = "xen,xen-4.3", "xen,xen"
};

I missed the Xen patch that adds this node for dom0.  Can you point me
to it?

David

> +static int __init xen_guest_init(void)
> +{
> +	struct xen_add_to_physmap xatp;
> +	static struct shared_info *shared_info_page = 0;
> +	struct device_node *node;
> +
> +	node = of_find_compatible_node(NULL, NULL, "arm,xen");
> +	if (!node) {
> +		pr_debug("No Xen support\n");
> +		return 0;
> +	}
> +	xen_domain_type = XEN_HVM_DOMAIN;
> +
> +	if (!shared_info_page)
> +		shared_info_page = (struct shared_info *)
> +			get_zeroed_page(GFP_KERNEL);
> +	if (!shared_info_page) {
> +		pr_err("not enough memory\n");
> +		return -ENOMEM;
> +	}
> +	xatp.domid = DOMID_SELF;
> +	xatp.idx = 0;
> +	xatp.space = XENMAPSPACE_shared_info;
> +	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
> +	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
> +		BUG();
> +
> +	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> +
> +	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
> +	 * page, we use it in the event channel upcall and in some pvclock
> +	 * related functions. We don't need the vcpu_info placement
> +	 * optimizations because we don't use any pv_mmu or pv_irq op on
> +	 * HVM.
> +	 * The shared info contains exactly 1 CPU (the boot CPU). The guest
> +	 * is required to use VCPUOP_register_vcpu_info to place vcpu info
> +	 * for secondary CPUs as they are brought up. */
> +	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> +	return 0;
> +}
> +core_initcall(xen_guest_init);

