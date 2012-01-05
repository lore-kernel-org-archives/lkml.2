Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2AEO3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:29:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14433 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2AEO3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:29:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 05 Jan 2012 06:29:38 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 5 Jan 2012 15:29:30 +0100
Subject: Re: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU
 driver
Thread-Topic: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU
 driver
Thread-Index: AczLtnLqHr6ejlptTliYqShMSKHh0g==
Message-ID: <20120105.162930.604365154868332443.hdoyu@nvidia.com>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com><20120105091718.3fb378b2a1d390f9dd63c396@nvidia.com><20120105125326.GT11810@n2100.arm.linux.org.uk>
In-Reply-To: <20120105125326.GT11810@n2100.arm.linux.org.uk>
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

Hi Russell,

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU driver
Date: Thu, 5 Jan 2012 13:53:26 +0100
Message-ID: <20120105125326.GT11810@n2100.arm.linux.org.uk>

> On Thu, Jan 05, 2012 at 09:17:18AM +0200, Hiroshi Doyu wrote:
> > Just for DMA mapping test from MPU side, the following one is used.
>
> This patch is buggy.
>
> > +static void dmaapi_test_map_page(struct device *dev)
> > +{
> > +	struct page *page;
> > +	dma_addr_t dma_addr;
> > +	void *cpu_addr;
> > +
> > +	page = alloc_page(GFP_KERNEL);
> > +	BUG_ON(!page);
> > +
> > +	dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_TO_DEVICE);
> > +	BUG_ON(!dma_addr);
> > +
> > +	cpu_addr = kmap(page);
> > +	BUG_ON(!cpu_addr);
> > +	memset(cpu_addr, 0xa5, PAGE_SIZE);
> > +	kunmap(cpu_addr);
>
> The DMA API works like this:
>
> - The CPU owns the page or buffer and can access it.
> - You map the page or buffer.
> - The device owns the page or buffer; the CPU must explicitly access it.
> - You unmap the page or buffer.
> - The CPU again owns the page/buffer and can access it.
>
> Please respect the DMA API rules.

Right, I do.

> So.  Once dma_map_page() has returned, you must not kmap() or otherwise
> access the data contained in that page until after you have unmapped it.

Ok, the above function order should be as below?

  page = alloc_page(GFP_KERNEL);
      cpu_addr = kmap(page);
      memset(cpu_addr, 0xa5, PAGE_SIZE);
  	dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_TO_DEVICE);
  	    < expect GPU does something >
  	dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
      < CPU can access data here again>
      kunmap(cpu_addr);
  __free_page(page);
