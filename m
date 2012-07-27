Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab2G0Jpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:45:32 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:29693 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2G0Jpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:45:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13730930"
Message-ID: <1343382276.6812.126.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 13/24] xen/arm: get privilege status
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Fri, 27 Jul 2012 10:44:36 +0100
In-Reply-To: <1343316846-25860-13-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-13-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 16:33 +0100, Stefano Stabellini wrote:
> Use Xen features to figure out if we are privileged.
> 
> XENFEAT_dom0 was introduced by 23735 in xen-unstable.hg.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c         |    7 +++++++
>  include/xen/interface/features.h |    3 +++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index dc68074..2e013cf 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -2,6 +2,7 @@
>  #include <xen/interface/xen.h>
>  #include <xen/interface/memory.h>
>  #include <xen/platform_pci.h>
> +#include <xen/features.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  #include <linux/module.h>
> @@ -58,6 +59,12 @@ int __init xen_guest_init(void)
>  	}
>  	xen_domain_type = XEN_HVM_DOMAIN;
>  
> +	xen_setup_features();
> +	if (xen_feature(XENFEAT_dom0))
> +		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
> +	else
> +		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);

What happens here on platforms prior to hypervisor changeset 23735?

> +
>  	/* already setup */
>  	if (shared_info_page != 0 && HYPERVISOR_shared_info == shared_info_page)
>  		return 0;
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


