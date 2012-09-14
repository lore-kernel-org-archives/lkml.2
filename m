Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2INNTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:19:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31807 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2INNTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:19:08 -0400
Date: Fri, 14 Sep 2012 09:08:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        tim@xen.org, Ian.Campbell@citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/24] xen/arm: Xen detection and shared_info page
 mapping
Message-ID: <20120914130807.GK25249@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-7-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347621207-11294-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:13:09PM +0100, Stefano Stabellini wrote:
> Check for a node in the device tree compatible with "xen,xen", if it is
> present set xen_domain_type to XEN_HVM_DOMAIN and continue
> initialization.
> 
> Map the real shared info page using XENMEM_add_to_physmap with
> XENMAPSPACE_shared_info.
> 
> Changes in v4:
> 
> - simpler parsing of Xen version in the compatible DT node.
> 
> Changes in v3:
> 
> - use the "xen,xen" notation rather than "arm,xen";
> - add an additional check on the presence of the Xen version.
> 
> Changes in v2:
> 
> - replace pr_info with pr_debug.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 61 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index c535540..6a0217d 100644
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
> @@ -33,3 +36,61 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  	return -ENOSYS;
>  }
>  EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
> +
> +/*
> + * see Documentation/devicetree/bindings/arm/xen.txt for the
> + * documentation of the Xen Device Tree format.
> + */
> +static int __init xen_guest_init(void)
> +{
> +	struct xen_add_to_physmap xatp;
> +	static struct shared_info *shared_info_page = 0;
> +	struct device_node *node;
> +	int len;
> +	const char *s = NULL;
> +	const char *version = NULL;
> +	const char *xen_prefix = "xen,xen-";
> +
> +	node = of_find_compatible_node(NULL, NULL, "xen,xen");
> +	if (!node) {
> +		pr_debug("No Xen support\n");
> +		return 0;
> +	}
> +	s = of_get_property(node, "compatible", &len);
> +	if (strlen(xen_prefix) + 3  < len &&
> +			!strncmp(xen_prefix, s, strlen(xen_prefix)))

If we have version '4.3.1' won't this trip us over?

Or if we only have 'major' and 'minor', then won't '4.11' trip us
over too?


> +		version = s + strlen(xen_prefix);
> +	if (version == NULL) {
> +		pr_debug("Xen version not found\n");
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
