Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1LUCGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:06:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:29258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab1LUCGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:06:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87926663"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Chris Wright <chrisw@sous-sol.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 21 Dec 2011 10:04:28 +0800
Subject: RE: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Thread-Topic: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Thread-Index: Acy/MYdqm31h7YU2TzOuSwADWM3XXgAUriGw
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E28904879BF@shsmsx502.ccr.corp.intel.com>
References: <BC00F5384FCFC9499AF06F92E8B78A9E2890486DD3@shsmsx502.ccr.corp.intel.com>
 <20111220160730.GD30205@sequoia.sous-sol.org>
In-Reply-To: <20111220160730.GD30205@sequoia.sous-sol.org>
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

Yes, Chris, thanks your comments.
How about this one?

---
 drivers/iommu/intel-iommu.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a004c39..0fc5efd 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2264,12 +2264,6 @@ static int domain_add_dev_info(struct dmar_domain *domain,
    if (!info)
        return -ENOMEM;

-   ret = domain_context_mapping(domain, pdev, translation);
-   if (ret) {
-       free_devinfo_mem(info);
-       return ret;
-   }
-
    info->segment = pci_domain_nr(pdev->bus);
    info->bus = pdev->bus->number;
    info->devfn = pdev->devfn;
@@ -2282,6 +2276,16 @@ static int domain_add_dev_info(struct dmar_domain *domain,
    pdev->dev.archdata.iommu = info;
    spin_unlock_irqrestore(&device_domain_lock, flags);

+   ret = domain_context_mapping(domain, pdev, translation);
+   if (ret) {
+       spin_lock_irqsave(&device_domain_lock, flags);
+       list_del(&info->link);
+       list_del(&info->global);
+       spin_unlock_irqrestore(&device_domain_lock, flags);
+       free_devinfo_mem(info);
+       return ret;
+   }
+
    return 0;
 }

> -----Original Message-----
> From: Chris Wright [mailto:chrisw@sous-sol.org]
> Sent: Wednesday, December 21, 2011 12:08 AM
> To: Hao, Xudong
> Cc: iommu@lists.linux-foundation.org; dwmw2@infradead.org; Zhang, Xiantao;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH] intel-iommu: Add device info into list before doing context
> mapping
> 
> * Hao, Xudong (xudong.hao@intel.com) wrote:
> > @@ -2282,6 +2276,14 @@ static int domain_add_dev_info(struct
> dmar_domain *domain,
> >  	pdev->dev.archdata.iommu = info;
> >  	spin_unlock_irqrestore(&device_domain_lock, flags);
> >
> > +	ret = domain_context_mapping(domain, pdev, translation);
> > +	if (ret) {
> > +		list_del(&info->link);
> > +		list_del(&info->global);
> 
> At the very least, this is not correct locking.
> 
> > +		free_devinfo_mem(info);
> > +		return ret;
> > +	}
> > +
