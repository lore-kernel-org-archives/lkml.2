Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2I1OnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:43:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29497 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2I1OnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:43:22 -0400
Date: Fri, 28 Sep 2012 10:45:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] iommu/amd: Add IOAPIC remapping routines
Message-ID: <20120928144513.GG7483@localhost.localdomain>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-10-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348835046-3262-10-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:23:59PM +0200, Joerg Roedel wrote:
> Add the routine to setup interrupt remapping for ioapic
> interrupts. Also add a routine to change the affinity of an
> irq and to free an irq allocation for interrupt remapping.
> The last two functions will also be used for MSI interrupts.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu.c |  126 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 126 insertions(+)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index bd277924..3df01b2 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -4000,4 +4000,130 @@ static void free_irte(u16 devid, int index)
>  	iommu_completion_wait(iommu);
>  }
>  
> +static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
> +			      unsigned int destination, int vector,
> +			      struct io_apic_irq_attr *attr)
> +{
> +	struct irq_remap_table *table;
> +	struct irq_2_iommu *irte_info;
> +	struct irq_cfg *cfg;
> +	union irte irte;
> +	int ioapic_id;
> +	int index;
> +	int devid;
> +	int ret;
> +
> +	cfg = irq_get_chip_data(irq);
> +	if (!cfg)
> +		return -EINVAL;
> +
> +	irte_info = &cfg->irq_2_iommu;
> +	ioapic_id = mpc_ioapic_id(attr->ioapic);
> +	devid     = get_ioapic_devid(ioapic_id);
> +
> +	if (devid < 0)
> +		return devid;
> +
> +	table = get_irq_table(devid, true);
> +	if (table == NULL)
> +		return -ENOMEM;
> +
> +	index = attr->ioapic_pin;
> +
> +	/* Setup IRQ remapping info */
> +	irte_info->sub_handle = devid;
> +	irte_info->irte_index = index;
> +	irte_info->iommu      = (void *)cfg;
> +
> +	/* Setup IRTE for IOMMU */
> +	irte.val		= 0;
> +	irte.fields.vector      = vector;
> +	irte.fields.int_type    = apic->irq_delivery_mode;
> +	irte.fields.destination = destination;
> +	irte.fields.dm          = apic->irq_dest_mode;
> +	irte.fields.valid       = 1;
> +
> +	ret = modify_irte(devid, index, irte);
> +	if (ret)
> +		return ret;
> +
> +	/* Setup IOAPIC entry */
> +	memset(entry, 0, sizeof(*entry));
> +
> +	entry->vector        = index;
> +	entry->mask          = 0;
> +	entry->trigger       = attr->trigger;
> +	entry->polarity      = attr->polarity;
> +
> +	/*
> +	 * Mask level triggered irqs.
> +	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.

so how come it is not set?

> +	 */
> +	if (attr->trigger)
> +		entry->mask = 1;
> +
> +	return 0;
> +}
> +
> +static int set_affinity(struct irq_data *data, const struct cpumask *mask,
> +			bool force)
> +{
> +	struct irq_2_iommu *irte_info;
> +	unsigned int dest, irq;
> +	struct irq_cfg *cfg;
> +	union irte irte;
> +	int err;
> +
> +	if (!config_enabled(CONFIG_SMP))
> +		return -1;

-1? -ENOx something?
> +
> +	cfg       = data->chip_data;
> +	irq       = data->irq;
> +	irte_info = &cfg->irq_2_iommu;
> +
> +	if (!cpumask_intersects(mask, cpu_online_mask))
> +		return -EINVAL;
> +
> +	if (get_irte(irte_info->sub_handle, irte_info->irte_index, &irte))
> +		return -EBUSY;
> +
> +	if (assign_irq_vector(irq, cfg, mask))
> +		return -EBUSY;
> +
> +	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
> +	if (err) {
> +		if (assign_irq_vector(irq, cfg, data->affinity))
> +			pr_err("AMD-Vi: Failed to recover vector for irq %d\n", irq);

If we do OK with the assignment of the vector, should we just continue
on instead of returning error?

> +		return err;
> +	}
> +
> +	irte.fields.vector      = cfg->vector;
> +	irte.fields.destination = dest;
> +
> +	modify_irte(irte_info->sub_handle, irte_info->irte_index, irte);
> +
> +	if (cfg->move_in_progress)
> +		send_cleanup_vector(cfg);
> +
> +	cpumask_copy(data->affinity, mask);
> +
> +	return 0;
> +}
> +
> +static int free_irq(int irq)
> +{
> +	struct irq_2_iommu *irte_info;
> +	struct irq_cfg *cfg;
> +
> +	cfg = irq_get_chip_data(irq);
> +	if (!cfg)
> +		return -EINVAL;
> +
> +	irte_info = &cfg->irq_2_iommu;
> +
> +	free_irte(irte_info->sub_handle, irte_info->irte_index);
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
