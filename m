Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2AXLge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:36:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6965 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2AXLgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:36:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jan 2012 03:36:31 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 24 Jan 2012 12:36:14 +0100
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Topic: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Index: AczajGl7+S73WsefSYSZNeCrWnaaWw==
Message-ID: <20120124.133614.1646093482547685131.hdoyu@nvidia.com>
References: <20120123154310.GC6269@8bytes.org><20120124.115701.2179509760878976509.hdoyu@nvidia.com><20120124110444.GB19255@amd.com>
In-Reply-To: <20120124110444.GB19255@amd.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Date: Tue, 24 Jan 2012 12:04:44 +0100
Message-ID: <20120124110444.GB19255@amd.com>

> > > Hmm, this looks like there is a 1-1 mapping between hardware SMMU
> > > devices and domains. This is not consistent with IOMMU-API semantics
> > > where a domain can contain devices behind different SMMUs. Please fix
> > > that.
> > 
> > I'm a bit confused with the concept of "domain". I thought that
> > "domain" is equivalent to a "virtual address space". Usually a IOMMU
> > device provides a virtual address space for multiple client
> > devices. IOW, a IOMMU device provides a virtual address space, which
> > can be shared with multiple client devices.
> > 
> > Actually Tegra SMMU case, a single IOMMU device has 4 different
> > virtual address speace("smmu_as"). Each "smmu_as" has its own virtual
> > address space. "smmu_as[i]" has mutiple "smmu_client" devices.
> > 
> >   smmu_as[i] == domain[i]
> > 
> > I don't understand why "a domain can contain devices behind different
> > SMMUs" because those client devices belong to different virtual
> > address spaces, and they should belong to different "domains".
> > 
> > Could you please explain a bit more about "domain"?
> 
> A domain is, as you said, a virtual address space for IO devices. But
> the important point is, an arbitrary number of devices can be part of a
> domain. This also means that the devices can be behind different
> hardware SMMUs. In this case your driver needs to program the page-table
> pointer into more than one SMMU to give devices behind different SMMUs
> the same address space.

Thank you for explaining.

Does the above mean that a buffer can be shared with different devices
which belong to different IOMMU devices(virtual address spaces)?

For example, assuming the following:

- We have "struct iommu_domain *domain1".
- "domain1" has iommu device "iommu_dev1" and "iommu_dev2".
- "iommu_dev1" has "client_dev1" and "client_dev2".
- "iommu_dev2" has "client_dev3" and "client_dev4".

"iommu_map(domain1, iova, pa, ...)" will create the following mapping
___at once___:

- (iova)-(pa) mapping in iommu_dev1(iommmu_dev1's virtual address space)
- (iova)-(pa) mapping in iommu_dev2(iommmu_dev2's virtual address space)

Is the above correct?

It seems that the same (iova) is used for different virtual address
spaces. What kind of case is this beneficial most in?
