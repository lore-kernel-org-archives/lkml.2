Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2HAOrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:47:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31818 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2HAOrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:47:37 -0400
Date: Wed, 1 Aug 2012 10:38:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 12/24] xen/arm: Introduce xen_guest_init
Message-ID: <20120801143822.GJ7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-12-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-12-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:33:54PM +0100, Stefano Stabellini wrote:
> We used to rely on a core_initcall to initialize Xen on ARM, however
> core_initcalls are actually called after early consoles are initialized.
> That means that hvc_xen.c is going to be initialized before Xen.
> 
> Given the lack of a better alternative, just call a new Xen
> initialization function (xen_guest_init) from xen_cons_init.
> 
> xen_guest_init has to be arch independent, so write both an ARM and an
> x86 implementation. The x86 implementation is currently empty because we
> can be sure that xen_hvm_guest_init is called early enough.

Should the arm version then not be anymore on the core_initcall then?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c  |    7 ++++++-
>  arch/x86/xen/enlighten.c  |    8 ++++++++
>  drivers/tty/hvc/hvc_xen.c |    7 ++++++-
>  include/xen/xen.h         |    2 ++
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 8c923af..dc68074 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -44,7 +44,7 @@ EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
>   * - one interrupt for Xen event notifications;
>   * - one memory region to map the grant_table.
>   */
> -static int __init xen_guest_init(void)
> +int __init xen_guest_init(void)
>  {
>  	int cpu;
>  	struct xen_add_to_physmap xatp;
> @@ -58,6 +58,10 @@ static int __init xen_guest_init(void)
>  	}
>  	xen_domain_type = XEN_HVM_DOMAIN;
>  
> +	/* already setup */
> +	if (shared_info_page != 0 && HYPERVISOR_shared_info == shared_info_page)
> +		return 0;
> +
>  	if (!shared_info_page)
>  		shared_info_page = (struct shared_info *)
>  			get_zeroed_page(GFP_KERNEL);
> @@ -88,4 +92,5 @@ static int __init xen_guest_init(void)
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(xen_guest_init);

Why the export symbols?

>  core_initcall(xen_guest_init);
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index ff962d4..6131d43 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1567,4 +1567,12 @@ const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
>  	.init_platform		= xen_hvm_guest_init,
>  };
>  EXPORT_SYMBOL(x86_hyper_xen_hvm);
> +
> +int __init xen_guest_init(void)
> +{
> +	/* do nothing: rely on x86_hyper_xen_hvm for the initialization */
> +	return 0;
> +	
> +}
> +EXPORT_SYMBOL_GPL(xen_guest_init);
>  #endif
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index dc07f56..3c04fb8 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -577,6 +577,12 @@ static void __exit xen_hvc_fini(void)
>  static int xen_cons_init(void)
>  {
>  	const struct hv_ops *ops;
> +	int r;
> +
> +	/* retrieve xen infos  */
> +	r = xen_guest_init();
> +	if (r < 0)
> +		return r;
>  
>  	if (!xen_domain())
>  		return 0;
> @@ -584,7 +590,6 @@ static int xen_cons_init(void)
>  	if (xen_initial_domain())
>  		ops = &dom0_hvc_ops;
>  	else {
> -		int r;
>  		ops = &domU_hvc_ops;
>  
>  		if (xen_hvm_domain())
> diff --git a/include/xen/xen.h b/include/xen/xen.h
> index 2c0d3a5..792a4d2 100644
> --- a/include/xen/xen.h
> +++ b/include/xen/xen.h
> @@ -9,8 +9,10 @@ enum xen_domain_type {
>  
>  #ifdef CONFIG_XEN
>  extern enum xen_domain_type xen_domain_type;
> +int xen_guest_init(void);
>  #else
>  #define xen_domain_type		XEN_NATIVE
> +static inline int xen_guest_init(void) { return 0; }
>  #endif
>  
>  #define xen_domain()		(xen_domain_type != XEN_NATIVE)
> -- 
> 1.7.2.5
