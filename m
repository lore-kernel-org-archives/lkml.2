Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2AEOqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:46:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35424 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2AEOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:46:46 -0500
Date: Thu, 5 Jan 2012 14:46:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU
	driver
Message-ID: <20120105144631.GV11810@n2100.arm.linux.org.uk>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com> <20120105091718.3fb378b2a1d390f9dd63c396@nvidia.com> <20120105125326.GT11810@n2100.arm.linux.org.uk> <20120105.162930.604365154868332443.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105.162930.604365154868332443.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:29:30PM +0100, Hiroshi Doyu wrote:
> Ok, the above function order should be as below?
> 
>   page = alloc_page(GFP_KERNEL);
>       cpu_addr = kmap(page);
>       memset(cpu_addr, 0xa5, PAGE_SIZE);
>   	dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_TO_DEVICE);
>   	    < expect GPU does something >
>   	dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
>       < CPU can access data here again>
>       kunmap(cpu_addr);
>   __free_page(page);

That should work, but it's not particularly nice to wrap kmap around
the DMA API.

Bear in mind that alloc_page(GFP_KERNEL) will always give you a lowmem
page.  So, you might as well do:

	page = alloc_page(GFP_KERNEL);
	cpu_addr = page_address(page);
	memset()
	dma_addr = dma_map_single(dev, cpu_addr, PAGE_SIZE, DMA_TO_DEVICE);
		< GPU access >
	dma_unmap_single(dev, dma_ddr, PAGE_SIZE, DMA_TO_DEVICE);
	< CPU access >
	__free_page(page);

and this doesn't raise any issues with kmap vs DMA API.
