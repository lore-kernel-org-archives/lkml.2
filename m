Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab2EXVtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:49:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996Ab2EXVtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:49:49 -0400
Message-ID: <1337896168.4714.39.camel@ul30vt>
Subject: Re: [PATCH v2 03/13] iommu: IOMMU groups for VT-d and AMD-Vi
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Date: Thu, 24 May 2012 15:49:28 -0600
In-Reply-To: <4FBEA18F.1040607@redhat.com>
References: <20120522043607.5871.11340.stgit@bling.home>
	 <20120522050454.5871.67086.stgit@bling.home> <4FBEA18F.1040607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:01 -0400, Don Dutile wrote:
> On 05/22/2012 01:04 AM, Alex Williamson wrote:
> > Add back group support for AMD&  Intel.  amd_iommu already tracks
> > devices and has init and uninit routines to manage groups.
> > intel-iommu does this on the fly, so we make use of the notifier
> > support built into iommu groups to create and remove groups.
> >
> > Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> > ---
> >
> >   drivers/iommu/amd_iommu.c   |   28 +++++++++++++++++++++++++-
> >   drivers/iommu/intel-iommu.c |   46 +++++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 73 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> > index 32c00cd..b7e5ddf 100644
> > --- a/drivers/iommu/amd_iommu.c
> > +++ b/drivers/iommu/amd_iommu.c
> > @@ -256,9 +256,11 @@ static bool check_device(struct device *dev)
> >
> >   static int iommu_init_device(struct device *dev)
> >   {
> > -	struct pci_dev *pdev = to_pci_dev(dev);
> > +	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
> >   	struct iommu_dev_data *dev_data;
> > +	struct iommu_group *group;
> >   	u16 alias;
> > +	int ret;
> >
> >   	if (dev->archdata.iommu)
> >   		return 0;
> > @@ -279,8 +281,30 @@ static int iommu_init_device(struct device *dev)
> >   			return -ENOTSUPP;
> >   		}
> >   		dev_data->alias_data = alias_data;
> > +
> > +		dma_pdev = pci_get_bus_and_slot(alias>>  8, alias&  0xff);
> > +	} else
> > +		dma_pdev = pdev;
> > +
> > +	if (!pdev->is_virtfn&&  PCI_FUNC(pdev->devfn)&&  iommu_group_mf&&
> > +	    pdev->hdr_type == PCI_HEADER_TYPE_NORMAL)
> > +		dma_pdev = pci_get_slot(pdev->bus,
> > +					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
> > +
> > +	group = iommu_group_get(&dma_pdev->dev);
> > +	if (!group) {
> > +		group = iommu_group_alloc();
> > +		if (IS_ERR(group))
> > +			return PTR_ERR(group);
> >   	}
> >
> > +	ret = iommu_group_add_device(group, dev);
> > +
> > +	iommu_group_put(group);
> > +
> do you want to do a put if there is a failure in the iommu_group_add_device()?

Yes, this was intentional.  iommu_group_alloc() adds a reference to the
group it returns so that it doesn't disappear while we're working on it
(documented in iommu.c).  iommu_group_get() also gets a reference.  So
this put will free the group if it was new or just drop the reference if
existing.  Thanks,

Alex

> > +	if (ret)
> > +		return ret;
> > +
> >   	if (pci_iommuv2_capable(pdev)) {
> >   		struct amd_iommu *iommu;
> >
> > @@ -309,6 +333,8 @@ static void iommu_ignore_device(struct device *dev)
> >
> >   static void iommu_uninit_device(struct device *dev)
> >   {
> > +	iommu_group_remove_device(dev);
> > +
> >   	/*
> >   	 * Nothing to do here - we keep dev_data around for unplugged devices
> >   	 * and reuse it when the device is re-plugged - not doing so would
> > diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> > index d4a0ff7..e63b33b 100644
> > --- a/drivers/iommu/intel-iommu.c
> > +++ b/drivers/iommu/intel-iommu.c
> > @@ -4087,6 +4087,50 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
> >   	return 0;
> >   }
> >
> > +static int intel_iommu_add_device(struct device *dev)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +	struct pci_dev *bridge, *dma_pdev = pdev;
> > +	struct iommu_group *group;
> > +	int ret;
> > +
> > +	if (!device_to_iommu(pci_domain_nr(pdev->bus),
> > +			     pdev->bus->number, pdev->devfn))
> > +		return -ENODEV;
> > +
> > +	bridge = pci_find_upstream_pcie_bridge(pdev);
> > +	if (bridge) {
> > +		if (pci_is_pcie(bridge))
> > +			dma_pdev = pci_get_domain_bus_and_slot(
> > +						pci_domain_nr(pdev->bus),
> > +						bridge->subordinate->number, 0);
> > +		else
> > +			dma_pdev = bridge;
> > +	}
> > +
> > +	if (!pdev->is_virtfn&&  PCI_FUNC(pdev->devfn)&&  iommu_group_mf&&
> > +	    pdev->hdr_type == PCI_HEADER_TYPE_NORMAL)
> > +		dma_pdev = pci_get_slot(pdev->bus,
> > +					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
> > +
> > +	group = iommu_group_get(&dma_pdev->dev);
> > +	if (!group) {
> > +		group = iommu_group_alloc();
> > +		if (IS_ERR(group))
> > +			return PTR_ERR(group);
> > +	}
> > +
> > +	ret = iommu_group_add_device(group, dev);
> > +
> ditto.
> > +	iommu_group_put(group);
> > +	return ret;
> > +}
> > +
> > +static void intel_iommu_remove_device(struct device *dev)
> > +{
> > +	iommu_group_remove_device(dev);
> > +}
> > +
> >   static struct iommu_ops intel_iommu_ops = {
> >   	.domain_init	= intel_iommu_domain_init,
> >   	.domain_destroy = intel_iommu_domain_destroy,
> > @@ -4096,6 +4140,8 @@ static struct iommu_ops intel_iommu_ops = {
> >   	.unmap		= intel_iommu_unmap,
> >   	.iova_to_phys	= intel_iommu_iova_to_phys,
> >   	.domain_has_cap = intel_iommu_domain_has_cap,
> > +	.add_device	= intel_iommu_add_device,
> > +	.remove_device	= intel_iommu_remove_device,
> >   	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
> >   };
> >
> >
> 



