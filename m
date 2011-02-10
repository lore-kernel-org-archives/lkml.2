Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1BJRAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:00:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab1BJRAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:00:16 -0500
Subject: Re: [PATCH][RFC] Intel IOMMU: get_domain_for_dev() leaks a bit of
 mem if dmar_find_matched_drhd_unit() fails.
From: Alex Williamson <alex.williamson@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <alpine.LNX.2.00.1102062102390.13593@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062102390.13593@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 09:59:34 -0700
Message-ID: <1297357174.2963.4.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-06 at 21:11 +0100, Jesper Juhl wrote:
> I believe that there's a small memory leak in 
> drivers/pci/intel-iommu.c:get_domain_for_dev().
> 
> If the call to alloc_domain() succeeds but the subsequent call to 
> dmar_find_matched_drhd_unit() fails, then the current code will return 
> NULL without calling domain_exit(domain) which will leak the memory that 
> alloc_domain() allocated.
> 
> The easy fix for that is to simply move the call to alloc_domain() below 
> the call to dmar_find_matched_drhd_unit() since the latter does not depend 
> on the former.
> 
> I also made the change of moving the assignment to local variable 'iommu' 
> below both calls since there is no point in doing that work if either of 
> those those calls fail.
> 
> I also changed the 'return NULL' in the dmar_find_matched_drhd_unit() 
> failure case to a 'goto error' since I figured that if rechecking 
> 'find_domain(pdev)' makes sense after a alloc_domain() failure then it 
> would also make sense after a dmar_find_matched_drhd_unit() failure.

I don't think this change buys us anything.  The goto error here seems
to be a hope that another cpu may have beat us and succeeded at
something we failed.  In the case of matching the pci device to a drhd,
this should be deterministic (unless maybe we're racing a hot added
drhd).  The rest seems fine to me.  Thanks,

Alex

> Patch is only compile tested and I'm not very familliar with this code at 
> all, so please review carefully before applying and please feel free to 
> provide feedback if this patch is somehow not making sense.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  intel-iommu.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 4789f8e..dfbdb08 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1820,19 +1820,18 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
>  		}
>  	}
>  
> -	domain = alloc_domain();
> -	if (!domain)
> -		goto error;
> -
>  	/* Allocate new domain for the device */
>  	drhd = dmar_find_matched_drhd_unit(pdev);
>  	if (!drhd) {
>  		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
>  			pci_name(pdev));
> -		return NULL;
> +		goto error;
>  	}
> -	iommu = drhd->iommu;
> +	domain = alloc_domain();
> +	if (!domain)
> +		goto error;
>  
> +	iommu = drhd->iommu;
>  	ret = iommu_attach_domain(domain, iommu);
>  	if (ret) {
>  		domain_exit(domain);
> 
> 



