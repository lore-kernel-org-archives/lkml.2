Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2JIPiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:38:10 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:4841 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2JIPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:38:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344211200"; 
   d="scan'208";a="15043731"
Date: Tue, 9 Oct 2012 16:37:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 5/9] ARM: Xen: fix initial build problems:
In-Reply-To: <1349796183-30648-6-git-send-email-arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1210091630170.29539@kaball.uk.xensource.com>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-6-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch and sorry for the build breakage!

On Tue, 9 Oct 2012, Arnd Bergmann wrote:
> * The XEN_BALLOON code requires the balloon infrastructure that is not
>   getting built on ARM.
> 
> * The tmem hypercall is not available on ARM
> 
> * ARMv6 does not support cmpxchg on 16-bit words that are used in the
> 
> * sys-hypervisor.c needs to include linux/err.h in order to use the
>   IS_ERR/PTR_ERR/ERR_PTR family of functions.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: xen-devel@lists.xensource.com
> ---
>  arch/arm/Kconfig             |    1 +
>  drivers/xen/Kconfig          |    2 ++
>  drivers/xen/sys-hypervisor.c |    1 +
>  3 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 6d2f7f5..85eaac3 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1846,6 +1846,7 @@ config XEN_DOM0
>  config XEN
>  	bool "Xen guest support on ARM (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL && ARM && OF
> +	depends on !CPU_V6
>  	help
>  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.

Considering that we rely on the virtualization extensions, this one can
be:

    depends on CPU_V7

The rest looks fine. I can submit a second patch to change !CPU_V6 into
CPU_V7 later, if you prefer.


> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index d4dffcd..126d8ce 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -3,6 +3,7 @@ menu "Xen driver support"
>  
>  config XEN_BALLOON
>  	bool "Xen memory balloon driver"
> +	depends on !ARM
>  	default y
>  	help
>  	  The balloon driver allows the Xen domain to request more memory from
> @@ -145,6 +146,7 @@ config SWIOTLB_XEN
>  
>  config XEN_TMEM
>  	bool
> +	depends on !ARM
>  	default y if (CLEANCACHE || FRONTSWAP)
>  	help
>  	  Shim to interface in-kernel Transcendent Memory hooks
>
> diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
> index 5e5ad7e..66a0a14 100644
> --- a/drivers/xen/sys-hypervisor.c
> +++ b/drivers/xen/sys-hypervisor.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/kobject.h>
> +#include <linux/err.h>
>  
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> -- 
> 1.7.10
> 
