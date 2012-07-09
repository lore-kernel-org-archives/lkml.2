Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2GIOt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:49:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51695 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2GIOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:49:54 -0400
Date: Mon, 9 Jul 2012 10:41:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, tim@xen.org,
        Ian.Campbell@citrix.com
Subject: Re: [Xen-devel] [PATCH WIP 3/6] xen/arm: get privilege status
Message-ID: <20120709144129.GB12102@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1340381685-22529-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340381685-22529-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 05:14:42PM +0100, Stefano Stabellini wrote:
> Use Xen features to figure out if we are privileged.

Is there a corresponding Xen c/s for the XNEFEAT_dom0?

Why can't the existing SIF_PRIVILIGED call work? Isn't that
somethign that the hypervisor sets for the guest?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c         |    9 ++++++++-
>  include/xen/interface/features.h |    3 +++
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index e1c2e4d..ddacecf 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -3,6 +3,7 @@
>  #include <xen/interface/memory.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> +#include <xen/features.h>
>  
>  #include <linux/module.h>
>  
> @@ -11,7 +12,7 @@
>  
>  #include <asm/pgtable.h>
>  
> -struct start_info _xen_start_info = { .flags = (SIF_INITDOMAIN|SIF_PRIVILEGED) };
> +struct start_info _xen_start_info;
>  struct start_info *xen_start_info = &_xen_start_info;
>  EXPORT_SYMBOL_GPL(xen_start_info);
>  
> @@ -133,6 +134,12 @@ static void __init xen_hvm_init_shared_info(void)
>  	struct xen_add_to_physmap xatp;
>  	static struct shared_info *shared_info_page = 0;
>  
> +	xen_setup_features();
> +	if (xen_feature(XENFEAT_dom0))
> +		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
> +	else
> +		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
> +
>  	/* already setup */
>  	if (shared_info_page != 0 && HYPERVISOR_shared_info == shared_info_page)
>  		return;
> diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
> index b6ca39a..131a6cc 100644
> --- a/include/xen/interface/features.h
> +++ b/include/xen/interface/features.h
> @@ -50,6 +50,9 @@
>  /* x86: pirq can be used by HVM guests */
>  #define XENFEAT_hvm_pirqs           10
>  
> +/* operation as Dom0 is supported */
> +#define XENFEAT_dom0                      11
> +
>  #define XENFEAT_NR_SUBMAPS 1
>  
>  #endif /* __XEN_PUBLIC_FEATURES_H__ */
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
