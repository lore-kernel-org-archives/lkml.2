Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2AZOqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:46:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3110 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2AZOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:46:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jan 2012 06:45:58 -0800
Date: Thu, 26 Jan 2012 16:45:56 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>
Subject: Re: [PATCH 1/2] ARM: IOMMU: Tegra20: Add iommu_ops for GART driver
Message-ID: <20120126164556.75e2d38d09821fc1e0ff05d6@nvidia.com>
In-Reply-To: <20120126115813.GF6269@8bytes.org>
References: <20120123150048.GB6269@8bytes.org>
	<20120125.094020.983282777619146490.hdoyu@nvidia.com>
	<20120126115813.GF6269@8bytes.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 12:58:13 +0100
"joro@8bytes.org" <joro@8bytes.org> wrote:

> On Wed, Jan 25, 2012 at 08:40:20AM +0100, Hiroshi Doyu wrote:
> > From: Hiroshi DOYU <hdoyu@nvidia.com>
> > Date: Wed, 16 Nov 2011 17:36:37 +0200
> > Subject: [PATCH 1/2] ARM: IOMMU: Tegra20: Add iommu_ops for GART driver
> > 
> > Tegra 20 IOMMU H/W, GART (Graphics Address Relocation Table). This
> > patch implements struct iommu_ops for GART for the upper IOMMU API.
> > 
> > This H/W module supports only single virtual address space(domain),
> > and manages a single level 1-to-1 mapping H/W translation page table.
> 
> Thanks. Applied with a few minor changes and fixes. Please see below.

All fixes are valid. Thanks.

> > +config TEGRA_IOMMU_GART
> > +	bool "Tegra GART IOMMU Support"
> > +	depends on ARCH_TEGRA_2x_SOC
> > +	default y
> 
> I removed 'default y'. New drivers shouldn't be selected by default.
> 
> > +static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
> > +			  phys_addr_t pa, size_t bytes, int prot)
> > +{
> > +	struct gart_device *gart = domain->priv;
> > +	unsigned long flags;
> > +	unsigned long pfn;
> > +
> > +	if (!gart_iova_range_valid(gart, iova, bytes))
> > +		return -EINVAL;
> > +
> > +	spin_lock_irqsave(&gart->pte_lock, flags);
> > +	pfn = __phys_to_pfn(pa);
> > +	if (!pfn_valid(pfn)) {
> > +		dev_err(gart->dev, "Invalid page: %08x\n", pa);
> > +		spin_unlock(&gart->pte_lock);
> 
> Changed this to spin_unlock_irqrestore().
> 
> > +		return -EINVAL;
> > +	}
> > +	gart_set_pte(gart, iova, GART_PTE(pfn));
> > +	FLUSH_GART_REGS(gart);
> > +	spin_unlock_irqrestore(&gart->pte_lock, flags);
> > +	return 0;
> > +}
> > +
> > +static size_t gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> > +			       size_t bytes)
> > +{
> > +	struct gart_device *gart = domain->priv;
> > +	unsigned long flags;
> > +
> > +	if (!gart_iova_range_valid(gart, iova, bytes))
> > +		return -EINVAL;
> 
> Return 0 here instead of -EINVAL. Size_t is unsigned and the unmap path
> returns 0 on failure.
> 
