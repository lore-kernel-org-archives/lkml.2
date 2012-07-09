Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2GIOxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:53:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36547 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2GIOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:53:31 -0400
Date: Mon, 9 Jul 2012 10:45:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, tim@xen.org,
        Ian.Campbell@citrix.com
Subject: Re: [Xen-devel] [PATCH WIP 2/6] xen/arm: Introduce xen_guest_init
Message-ID: <20120709144505.GD12102@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1340381685-22529-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340381685-22529-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 05:14:41PM +0100, Stefano Stabellini wrote:
> We used to rely on a core_initcall to initialize Xen on ARM, however
> core_initcalls are actually called after early consoles are initialized.
> That means that hvc_xen.c is going to be initialized before Xen.
> 
> Given the lack of a better alternative, just call a new Xen
> initialization function (xen_guest_init) from xen_cons_init.
> 
> xen_guest_init has to be arch independant, so write both an ARM and an
> x86 implementation. The x86 implementation is currently empty because we
> can be sure that xen_hvm_guest_init is called early enough.
> 
> Probably we can get rid of this as soon as we have better DT support.

What is DT?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c  |   12 ++++++++----
>  arch/x86/xen/enlighten.c  |    8 ++++++++
>  drivers/tty/hvc/hvc_xen.c |    3 +++
>  include/xen/xen.h         |    2 ++
>  4 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 7d76962..e1c2e4d 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -127,12 +127,16 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
>  
> -void __ref xen_hvm_init_shared_info(void)
> +static void __init xen_hvm_init_shared_info(void)
>  {
>  	int cpu;
>  	struct xen_add_to_physmap xatp;
>  	static struct shared_info *shared_info_page = 0;
>  
> +	/* already setup */
> +	if (shared_info_page != 0 && HYPERVISOR_shared_info == shared_info_page)
> +		return;
> +
>  	if (!shared_info_page)
>  		shared_info_page = (struct shared_info *)
>  			get_zeroed_page(GFP_KERNEL);
> @@ -161,11 +165,11 @@ void __ref xen_hvm_init_shared_info(void)
>  		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
>  	}
>  }
> +core_initcall(xen_hvm_init_shared_info);
>  
> -static int __init xen_hvm_guest_init(void)
> +int __init xen_guest_init(void)
>  {
>  	xen_hvm_init_shared_info();
>  	return 0;

Don't you want to do:
	return xen_hvm_init_shared_info();

why do we need to return int?
>  }
> -
> -core_initcall(xen_hvm_guest_init);
> +EXPORT_SYMBOL(xen_guest_init);
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 1f92865..0bad7b5 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1420,4 +1420,12 @@ const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
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
> +EXPORT_SYMBOL(xen_guest_init);

_GPL please.


>  #endif
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 3ae96a9..52a98ff 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -578,6 +578,9 @@ static int xen_cons_init(void)
>  	if (!xen_domain())
>  		return 0;
>  
> +	/* retrieve xen infos  */
> +	xen_guest_init();

So shouldn't this be:
	if (xen_guest_init())
		return .. something?

> +
>  	if (xen_initial_domain())
>  		ops = &dom0_hvc_ops;
>  	else {
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
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
