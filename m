Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2AYLo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:44:27 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:22970
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab2AYLoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:44:25 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz1102K1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYCR9R-02-3II-02
X-M-MSG: 
Date: Wed, 25 Jan 2012 12:44:17 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: KyongHo Cho <pullip.cho@samsung.com>
CC: Joerg Roedel <joro@8bytes.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/2] iommu/exynos: Add iommu driver for Exynos
 Platforms
Message-ID: <20120125114417.GE19255@amd.com>
References: <001001ccc625$0afa7ee0$20ef7ca0$%cho@samsung.com>
 <20120123142706.GA6269@8bytes.org>
 <CAHQjnOMyoOH2cFjjGSzMvefZTQGROmQgaA8S0MmxnKGHWyQhyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAHQjnOMyoOH2cFjjGSzMvefZTQGROmQgaA8S0MmxnKGHWyQhyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 03:51:58PM +0900, KyongHo Cho wrote:
> > This isn't really a problem. We allow destroying a domain with devices
> > attached. So this WARN_ON is not necessary.
> >
> BTW, Isn't it a problem when a device driver does not know that its
> iommu domain is destroyed?
> Can we regards that it is the faulty use of iommu API?

Yes we could, but we don't ;) The domain_destroy path has to take care
of this anyway to be robust, so we can also take away the need to unattach
everything from a domain from the iommu-api user.

> > This looks like you are partially re-implementing behavior of generic
> > code because you are mapping multiple sections at once. The generic map
> > code already splits up the address range correctly, so no need to do
> > this in the driver (unless there is some benefit in the hardware, like
> > an IOTLB entry that can cover multiple sections or something similar).
> >
> Yes, I wanted to avoid repeated function call by iommu_map().
> s5p_iommu_map() maps once for the same page size since it is efficient
> and simple.
> That's why this driver initializes domain->pgsize_bitmap with 0xFFFFF000
> even though our IOMMU driver just supports 3 different page sizes
> including 4KB, 64KB and 1MB.

Repeated function calls are not a real performance problem in the
iommu-code in my experience. The overhead is usualle somewhere else.

> Do you think it is better for s5p_iommu_map() to map just one page at once?

In general I think we should not duplicate code. This logic was moved to
the generic part for a reason and iommu drivers should use it unless
there is a very good reason not to do so.

> 
> >> +static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >> +                                            unsigned long iova, size_t size)
> >> +{
> >> +     struct exynos_iommu_domain *priv = domain->priv;
> >> +     struct iommu_client *client;
> >> +     unsigned long flags;
> >> +
> >> +     BUG_ON(priv->pgtable == NULL);
> >> +
> >> +     spin_lock_irqsave(&priv->pgtablelock, flags);
> >> +
> >> +     while (size != 0) {
> >> +             int i, nent, order;
> >> +             unsigned long *pent, *sent;
> >
> > Same with this while-loop. This looks like it re-implements behavior
> > from the generic code.
> >
> If a region to unmap consists of tens of pages
> there is no way to avoid flushing IOTLB repeatedly.
> 
> Out iommu driver doesn't need to flush IOTLB more than once for a
> region to unmap.
> 
> Do you think the driver is better to unmaps just one page at once
> though flushing IOTLB repeatedly?

Is I/O-TLB flushing an expensive operation?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

