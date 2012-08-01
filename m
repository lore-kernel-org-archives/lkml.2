Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2HAOuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:50:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41642 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2HAOuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:50:16 -0400
Date: Wed, 1 Aug 2012 10:40:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 14/24] xen/arm: initialize grant_table on ARM
Message-ID: <20120801144059.GL7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-14-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-14-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:33:56PM +0100, Stefano Stabellini wrote:
> Initialize the grant table mapping at the address specified at index 0
> in the DT under the /xen node.

Is it always index 0? If so, should it have a #define for the
other index values?

> After the grant table is initialized, call xenbus_probe (if not dom0).
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c  |   13 +++++++++++++
>  drivers/xen/grant-table.c |    2 +-
>  2 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 2e013cf..854af1e 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -1,8 +1,12 @@
>  #include <xen/xen.h>
>  #include <xen/interface/xen.h>
>  #include <xen/interface/memory.h>
> +#include <xen/interface/hvm/params.h>
>  #include <xen/platform_pci.h>
>  #include <xen/features.h>
> +#include <xen/grant_table.h>
> +#include <xen/hvm.h>
> +#include <xen/xenbus.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  #include <linux/module.h>
> @@ -51,12 +55,16 @@ int __init xen_guest_init(void)
>  	struct xen_add_to_physmap xatp;
>  	static struct shared_info *shared_info_page = 0;
>  	struct device_node *node;
> +	struct resource res;
>  
>  	node = of_find_compatible_node(NULL, NULL, "arm,xen");
>  	if (!node) {
>  		pr_info("No Xen support\n");
>  		return 0;
>  	}
> +	if (of_address_to_resource(node, 0, &res))
> +		return -EINVAL;
> +	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
>  	xen_domain_type = XEN_HVM_DOMAIN;
>  
>  	xen_setup_features();
> @@ -97,6 +105,11 @@ int __init xen_guest_init(void)
>  		per_cpu(xen_vcpu, cpu) =
>  			&HYPERVISOR_shared_info->vcpu_info[cpu];
>  	}
> +
> +	gnttab_init();
> +	if (!xen_initial_domain())
> +		xenbus_probe(NULL);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(xen_guest_init);
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 1d0d95e..fd2137a 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -62,7 +62,7 @@
>  
>  static grant_ref_t **gnttab_list;
>  static unsigned int nr_grant_frames;
> -static unsigned int boot_max_nr_grant_frames;
> +static unsigned int boot_max_nr_grant_frames = 1;

Is this going to impact x86 version?

>  static int gnttab_free_count;
>  static grant_ref_t gnttab_free_head;
>  static DEFINE_SPINLOCK(gnttab_list_lock);
> -- 
> 1.7.2.5
