Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2HGS1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:27:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23558 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2HGS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:27:37 -0400
Date: Tue, 7 Aug 2012 14:17:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 07/23] xen/arm: Xen detection and shared_info page
 mapping
Message-ID: <20120807181752.GK15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-7-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:10PM +0100, Stefano Stabellini wrote:
> Check for a "/xen" node in the device tree, if it is present set
> xen_domain_type to XEN_HVM_DOMAIN and continue initialization.
> 
> Map the real shared info page using XENMEM_add_to_physmap with
> XENMAPSPACE_shared_info.
> 
> Changes in v2:
> 
> - replace pr_info with pr_debug.

I second what David mentioned. The other thing is that you are going to
need to rebase this on top of v3.5-rc1, as Olaf's patches have changed
the shared_info_page a bit.

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
> -- 
> 1.7.2.5
