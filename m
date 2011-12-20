Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1LTKsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:48:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:16254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab1LTKsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:48:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="88442874"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Date: Tue, 20 Dec 2011 18:47:22 +0800
Subject: RE: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Thread-Topic: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Thread-Index: Acy8u746aXLTiGjsR8aCXu7ZvAWHAACRJ11Q
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E28904877E3@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

Do you have any comments for this patch?

Thanks,
-Xudong


> -----Original Message-----
> From: Hao, Xudong
> Sent: Saturday, December 17, 2011 9:07 PM
> To: 'iommu@lists.linux-foundation.org'; 'dwmw2@infradead.org'
> Cc: 'linux-kernel@vger.kernel.org'; 'kvm@vger.kernel.org'; Zhang, Xiantao
> Subject: [PATCH] intel-iommu: Add device info into list before doing context
> mapping
> 
> This patch add device info into list before do context mapping. Because device
> info will be used by iommu_enable_dev_iotlb function, in this function,
> pci_enable_ats would not be called without this patch, so ATS did not enable
> while a PCI device which has ATS capability is assigned to a guest.
> 
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> ---
>  drivers/iommu/intel-iommu.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c index
> c0c7820..f0b5d38 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2264,12 +2264,6 @@ static int domain_add_dev_info(struct
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
> @@ -2282,6 +2276,14 @@ static int domain_add_dev_info(struct
> dmar_domain *domain,
>  	pdev->dev.archdata.iommu = info;
>  	spin_unlock_irqrestore(&device_domain_lock, flags);
> 
> +	ret = domain_context_mapping(domain, pdev, translation);
> +	if (ret) {
> +		list_del(&info->link);
> +		list_del(&info->global);
> +		free_devinfo_mem(info);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
