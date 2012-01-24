Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2AXJ5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:57:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16827 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2AXJ5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:57:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Jan 2012 01:57:06 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>
Date: Tue, 24 Jan 2012 10:57:01 +0100
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Topic: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Index: AczafoYDTxriQDtxTEWMiwSioesdMQ==
Message-ID: <20120124.115701.2179509760878976509.hdoyu@nvidia.com>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com><1325747509-29665-3-git-send-email-hdoyu@nvidia.com><20120123154310.GC6269@8bytes.org>
In-Reply-To: <20120123154310.GC6269@8bytes.org>
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

Hi Joerg,

From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Date: Mon, 23 Jan 2012 16:43:10 +0100
Message-ID: <20120123154310.GC6269@8bytes.org>

> Hi,
> 
> please see my comments inline. When you fix these issues I think the
> driver is ready for merging.
>
> On Thu, Jan 05, 2012 at 09:11:49AM +0200, Hiroshi DOYU wrote:
> > +static int smmu_iommu_map(struct iommu_domain *domain, unsigned long iova,
> > +			  phys_addr_t pa, size_t bytes, int prot)
> > +{
> > +	struct smmu_as *as = domain->priv;
> > +	unsigned long pfn = __phys_to_pfn(pa);
> > +	unsigned long flags;
> > +
> > +	dev_dbg(as->smmu->dev, "[%d] %08lx:%08x\n", as->asid, iova, pa);
> > +
> > +	if (!pfn_valid(pfn))
> > +		return -ENOMEM;
> > +
> > +	spin_lock_irqsave(&as->lock, flags);
> > +	__smmu_iommu_map_pfn(as, iova, pfn);
> > +	spin_unlock_irqrestore(&as->lock, flags);
> > +	return 0;
> 
> Why do you completly ignore the size parameter in this function (and
> in the unmap part below)?
> According to the page-sizes you export to the generic layer size can be
> 4k or 4M. You need to take care of that in this function.

I'll drop 4MB support here once. I'll make another patch for 4MB page
support later.

> > +static void smmu_iommu_domain_destroy(struct iommu_domain *domain)
> > +{
> > +	struct smmu_as *as = domain->priv;
> > +	struct smmu_device *smmu = as->smmu;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&as->lock, flags);
> > +
> > +	if (as->pdir_page) {
> > +		spin_lock(&smmu->lock);
> > +		smmu_write(smmu, SMMU_PTB_ASID_CUR(as->asid), SMMU_PTB_ASID);
> > +		smmu_write(smmu, SMMU_PTB_DATA_RESET_VAL, SMMU_PTB_DATA);
> > +		FLUSH_SMMU_REGS(smmu);
> > +		spin_unlock(&smmu->lock);
> > +
> > +		free_pdir(as);
> > +	}
> > +
> > +	if (!list_empty(&as->client)) {
> > +		struct smmu_client *c;
> > +
> > +		list_for_each_entry(c, &as->client, list)
> > +			dev_err(smmu->dev,
> > +				"%s is still attached\n", dev_name(c->dev));
> 
> This is not an error. Just detach the devices when they are still
> attached to the domain.

Ok

> > +	}
> > +
> > +	spin_unlock_irqrestore(&as->lock, flags);
> > +
> > +	domain->priv = NULL;
> > +	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
> > +}
> > +
> > +static int smmu_iommu_attach_dev(struct iommu_domain *domain,
> > +				 struct device *dev)
> > +{
> > +	struct smmu_as *as = domain->priv;
> > +	struct smmu_device *smmu = as->smmu;
> 
> Hmm, this looks like there is a 1-1 mapping between hardware SMMU
> devices and domains. This is not consistent with IOMMU-API semantics
> where a domain can contain devices behind different SMMUs. Please fix
> that.

I'm a bit confused with the concept of "domain". I thought that
"domain" is equivalent to a "virtual address space". Usually a IOMMU
device provides a virtual address space for multiple client
devices. IOW, a IOMMU device provides a virtual address space, which
can be shared with multiple client devices.

Actually Tegra SMMU case, a single IOMMU device has 4 different
virtual address speace("smmu_as"). Each "smmu_as" has its own virtual
address space. "smmu_as[i]" has mutiple "smmu_client" devices.

  smmu_as[i] == domain[i]

I don't understand why "a domain can contain devices behind different
SMMUs" because those client devices belong to different virtual
address spaces, and they should belong to different "domains".

Could you please explain a bit more about "domain"?


> 
> 
> Thanks,
> 
> 	Joerg
> 
