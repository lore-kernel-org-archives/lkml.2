Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2CWCyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:54:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:17891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2CWCyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:54:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="122266564"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2] intel-iommu: Add device info into list before doing
 context mapping
Thread-Topic: [PATCH v2] intel-iommu: Add device info into list before doing
 context mapping
Thread-Index: AczAiGvqkE33aB24TxWfj60400kzKxIF6llw
Date: Fri, 23 Mar 2012 02:54:43 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FCF3733@SHSMSX102.ccr.corp.intel.com>
References: <BC00F5384FCFC9499AF06F92E8B78A9E28907BAB30@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <BC00F5384FCFC9499AF06F92E8B78A9E28907BAB30@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

Any other comments for this patch? Or can you check-in it in your iommu tree?

Thanks,
-Xudong

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Hao, Xudong
> Sent: Thursday, December 22, 2011 5:18 PM
> To: Chris Wright
> Cc: dwmw2@infradead.org; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org; Zhang, Xiantao; kvm@vger.kernel.org
> Subject: [PATCH v2] intel-iommu: Add device info into list before doing context
> mapping
> 
> Add device info into list before do context mapping, because device info will be
> used by iommu_enable_dev_iotlb function, in this function, pci_enable_ats
> would not be called without this patch.
> 
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> Acked-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  drivers/iommu/intel-iommu.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c index
> bdc447f..ccf347f 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2267,12 +2267,6 @@ static int domain_add_dev_info(struct
> dmar_domain *domain,
>  	if (!info)
>  		return -ENOMEM;
> 
> -	ret = domain_context_mapping(domain, pdev, translation);
> -	if (ret) {
> -		free_devinfo_mem(info);
> -		return ret;
> -	}
> -
>  	info->segment = pci_domain_nr(pdev->bus);
>  	info->bus = pdev->bus->number;
>  	info->devfn = pdev->devfn;
> @@ -2285,6 +2279,17 @@ static int domain_add_dev_info(struct
> dmar_domain *domain,
>  	pdev->dev.archdata.iommu = info;
>  	spin_unlock_irqrestore(&device_domain_lock, flags);
> 
> +	ret = domain_context_mapping(domain, pdev, translation);
> +	if (ret) {
> +		spin_lock_irqsave(&device_domain_lock, flags);
> +		list_del(&info->link);
> +		list_del(&info->global);
> +		pdev->dev.archdata.iommu = NULL;
> +		spin_unlock_irqrestore(&device_domain_lock, flags);
> +		free_devinfo_mem(info);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> 
> --
> 1.6.0.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
