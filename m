Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1HIQzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:55:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41683 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1HIQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:55:23 -0400
Date: Tue, 9 Aug 2011 12:55:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xen: off by one error in xen/setup.c
Message-ID: <20110809165512.GA6935@dumpdata.com>
References: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
 <1312278325-4246-2-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312278325-4246-2-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E416679.0133,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 11:45:23AM +0200, Igor Mammedov wrote:
> Do not try to initialize pfn beyond of available address space.

Actually, thinking about this I don't think this is right.

We want to initialize the P2M space _at_ the xen_max_p2m_pfn. With
your patch we would only initialize it up to xen_max_p2m_pfn-1 - so
the last PFN would not be set to INVALID_P2M_ENTRY.

> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/xen/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 60aeeb5..2221b05 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -69,7 +69,7 @@ static void __init xen_add_extra_mem(unsigned long pages)
>  
>  	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
>  
> -	for (pfn = PFN_DOWN(extra_start); pfn <= xen_max_p2m_pfn; pfn++)
> +	for (pfn = PFN_DOWN(extra_start); pfn < xen_max_p2m_pfn; ++pfn)
>  		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
>  }
>  
> -- 
> 1.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
