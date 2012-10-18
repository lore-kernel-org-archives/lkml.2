Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2JRNU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:20:58 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13770 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2JRNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:20:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,607,1344211200"; 
   d="scan'208";a="15255304"
Date: Thu, 18 Oct 2012 14:20:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH 2/6] xen: arm: enable balloon driver
In-Reply-To: <1350473532-15863-2-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.02.1210181420200.2689@kaball.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com> <1350473532-15863-2-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Ian Campbell wrote:
> The code is no in a state where can just enable it.
> 
> Drop the *_xenballloned_pages duplicates since these are now supplied
> by the balloon code.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  arch/arm/xen/enlighten.c |   23 +++++------------------
>  drivers/xen/Makefile     |    4 ++--
>  2 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 59bcb96..ba5cc13 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -8,6 +8,7 @@
>  #include <xen/features.h>
>  #include <xen/platform_pci.h>
>  #include <xen/xenbus.h>
> +#include <xen/page.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  #include <linux/interrupt.h>
> @@ -29,6 +30,10 @@ struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
>  
>  DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
>  
> +/* These are unused until we support booting "pre-ballooned" */
> +unsigned long xen_released_pages;
> +struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
> +
>  /* TODO: to be removed */
>  __read_mostly int xen_have_vector_callback;
>  EXPORT_SYMBOL_GPL(xen_have_vector_callback);
> @@ -148,21 +153,3 @@ static int __init xen_init_events(void)
>  	return 0;
>  }
>  postcore_initcall(xen_init_events);
> -
> -/* XXX: only until balloon is properly working */
> -int alloc_xenballooned_pages(int nr_pages, struct page **pages, bool highmem)
> -{
> -	*pages = alloc_pages(highmem ? GFP_HIGHUSER : GFP_KERNEL,
> -			get_order(nr_pages));
> -	if (*pages == NULL)
> -		return -ENOMEM;
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(alloc_xenballooned_pages);
> -
> -void free_xenballooned_pages(int nr_pages, struct page **pages)
> -{
> -	kfree(*pages);
> -	*pages = NULL;
> -}
> -EXPORT_SYMBOL_GPL(free_xenballooned_pages);
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 0e863703..909bb56 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,8 +1,8 @@
>  ifneq ($(CONFIG_ARM),y)
> -obj-y	+= manage.o balloon.o
> +obj-y	+= manage.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif
> -obj-y	+= grant-table.o features.o events.o
> +obj-y	+= grant-table.o features.o events.o balloon.o
>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
> -- 
> 1.7.2.5
> 
