Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778Ab2EaTsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab2EaTsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:48:10 -0400
Message-ID: <4FC7CAE5.7020306@redhat.com>
Date: Thu, 31 May 2012 15:47:49 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, bhelgaas@google.com,
        benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, gregkh@linuxfoundation.org,
        liuj97@gmail.com
Subject: Re: [PATCH v2 6/7] intel-iommu: Make use of DMA quirks and ACS checks
 in IOMMU groups
References: <20120530201424.31527.33142.stgit@bling.home> <20120530201942.31527.51604.stgit@bling.home>
In-Reply-To: <20120530201942.31527.51604.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 04:19 PM, Alex Williamson wrote:
> Work around broken devices and adhere to ACS support when determining
> IOMMU grouping.
>
> Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> ---
>
>   drivers/iommu/intel-iommu.c |   25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 4a43452..ebf2b31 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4090,6 +4090,14 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
>   	return 0;
>   }
>
> +static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
> +{
> +	pci_dev_put(*from);
> +	*from = to;
> +}
> +
> +#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
> +
>   static int intel_iommu_add_device(struct device *dev)
>   {
>   	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -4112,6 +4120,23 @@ static int intel_iommu_add_device(struct device *dev)
>   	} else
>   		dma_pdev = pci_dev_get(pdev);
>
> +	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
> +
> +	if (dma_pdev->multifunction&&
> +	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> +		swap_pci_ref(&dma_pdev,
> +			     pci_get_slot(dma_pdev->bus,
> +					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
> +					  0)));
> +
> +	while (!pci_is_root_bus(dma_pdev->bus)) {
> +		if (pci_acs_path_enabled(dma_pdev->bus->self,
> +					 NULL, REQ_ACS_FLAGS))
> +			break;
> +
> +		swap_pci_ref(&dma_pdev, pci_dev_get(dma_pdev->bus->self));
> +	}
> +
I'm having deja-vu on this patch....
.... why not just make the above two patches as two functions in drivers/iommu/iommu.c,
one exported for these two modules (and maybe others someday...), e.g., iommu_pdev_put())
which [intel-,amd-]iommu.c call ?

  
>   	group = iommu_group_get(&dma_pdev->dev);
>   	pci_dev_put(dma_pdev);
>   	if (!group) {
>

