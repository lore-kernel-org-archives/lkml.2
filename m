Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab2I1OrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:47:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23695 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2I1OrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:47:24 -0400
Date: Fri, 28 Sep 2012 10:49:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] iommu/amd: Implement MSI routines for interrupt
 remapping
Message-ID: <20120928144933.GH7483@localhost.localdomain>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-11-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348835046-3262-11-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:24:00PM +0200, Joerg Roedel wrote:
> Add routines to setup interrupt remapping for MSI
> interrupts.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu.c |   74 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index 3df01b2..84efecd 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -4126,4 +4126,78 @@ static int free_irq(int irq)
>  	return 0;
>  }
>  
> +static void compose_msi_msg(struct pci_dev *pdev,
> +			    unsigned int irq, unsigned int dest,
> +			    struct msi_msg *msg, u8 hpet_id)
> +{
> +	struct irq_2_iommu *irte_info;
> +	struct irq_cfg *cfg;
> +	union irte irte;
> +
> +	cfg = irq_get_chip_data(irq);
> +	if (!cfg)
> +		return;
> +
> +	irte_info = &cfg->irq_2_iommu;
> +
> +	irte.val		= 0;
> +	irte.fields.vector	= cfg->vector;
> +	irte.fields.int_type    = apic->irq_delivery_mode;
> +	irte.fields.destination	= dest;
> +	irte.fields.dm		= apic->irq_dest_mode;
> +	irte.fields.valid	= 1;
> +
> +	modify_irte(irte_info->sub_handle, irte_info->irte_index, irte);
> +
> +	msg->address_hi = MSI_ADDR_BASE_HI;
> +	msg->address_lo = MSI_ADDR_BASE_LO;
> +	msg->data       = irte_info->irte_index;
> +}
> +
> +static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
> +{
> +	struct irq_cfg *cfg;
> +	int index;
> +	u16 devid;
> +
> +	if (!pdev)
> +		return -EINVAL;
> +
> +	cfg = irq_get_chip_data(irq);
> +	if (!cfg)
> +		return -EINVAL;
> +
> +	devid = get_device_id(&pdev->dev);
> +	index = alloc_irq_index(cfg, devid, nvec);
> +
> +	return index < 0 ? MAX_IRQS_PER_TABLE : index;
> +}
> +
> +static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
> +			 int index, int offset)
> +{
> +	struct irq_2_iommu *irte_info;
> +	struct irq_cfg *cfg;
> +	u16 devid;
> +
> +	if (!pdev)
> +		return -EINVAL;
> +
> +	cfg = irq_get_chip_data(irq);
> +	if (!cfg)
> +		return -EINVAL;
> +
> +	if (index >= MAX_IRQS_PER_TABLE)
> +		return 0;

Hmm? Not an error code?

> +
> +	devid		= get_device_id(&pdev->dev);
> +	irte_info	= &cfg->irq_2_iommu;
> +
> +	irte_info->sub_handle = devid;
> +	irte_info->irte_index = index + offset;
> +	irte_info->iommu      = (void *)cfg;
> +
> +	return 0;
> +}
> +
>  #endif
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
