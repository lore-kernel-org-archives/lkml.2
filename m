Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2JRNLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:11:49 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17972 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2JRNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:11:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,607,1344211200"; 
   d="scan'208";a="15255027"
Date: Thu, 18 Oct 2012 14:11:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH 1/6] xen: balloon: allow PVMMU interfaces to be compiled
 out
In-Reply-To: <1350473532-15863-1-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.02.1210181410430.2689@kaball.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com> <1350473532-15863-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Ian Campbell wrote:
> The ARM platform has no concept of PVMMU and therefor no
> HYPERVISOR_update_va_mapping et al. Allow this code to be compiled out
> when not required.
> 
> In some similar situations (e.g. P2M) we have defined dummy functions
> to avoid this, however I think we can/should draw the line at dummying
> out actual hypercalls.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

It is OK for me


>  arch/x86/xen/Kconfig  |    1 +
>  drivers/xen/Kconfig   |    3 +++
>  drivers/xen/balloon.c |    4 ++++
>  3 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index 9323b8c..6d101a1 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -6,6 +6,7 @@ config XEN
>  	bool "Xen guest support"
>  	select PARAVIRT
>  	select PARAVIRT_CLOCK
> +	select XEN_HAVE_PVMMU
>  	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
>  	depends on X86_CMPXCHG && X86_TSC
>  	help
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index d4dffcd..9c00652 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -204,4 +204,7 @@ config XEN_MCE_LOG
>  	  Allow kernel fetching MCE error from Xen platform and
>  	  converting it into Linux mcelog format for mcelog tools
>  
> +config XEN_HAVE_PVMMU
> +       bool
> +
>  endmenu
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index db3aa34..92449a0 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -360,6 +360,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  		if (!xen_feature(XENFEAT_auto_translated_physmap))
>  			set_phys_to_machine(pfn, frame_list[i]);
>  
> +#ifdef CONFIG_XEN_HAVE_PVMMU
>  		/* Link back into the page tables if not highmem. */
>  		if (xen_pv_domain() && !PageHighMem(page) &&
>  		    !xen_feature(XENFEAT_auto_translated_physmap)) {
> @@ -371,6 +372,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  				0);
>  			BUG_ON(ret);
>  		}
> +#endif
>  
>  		/* Relinquish the page back to the allocator. */
>  		ClearPageReserved(page);
> @@ -419,6 +421,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  
>  		scrub_page(page);
>  
> +#ifdef CONFIG_XEN_HAVE_PVMMU
>  		if (xen_pv_domain() && !PageHighMem(page)) {
>  			if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>  				ret = HYPERVISOR_update_va_mapping(
> @@ -427,6 +430,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  				BUG_ON(ret);
>  			}
>  		}
> +#endif
>  	}
>  
>  	/* Ensure that ballooned highmem pages don't have kmaps. */
> -- 
> 1.7.2.5
> 
