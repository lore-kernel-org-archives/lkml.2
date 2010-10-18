Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab0JRPrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:47:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45916 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab0JRPrA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 18 Oct 2010 11:47:00 -0400
Date: Mon, 18 Oct 2010 11:46:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy.Fitzhardinge@citrix.com, Qing He <qing.he@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>
Subject: Re: [PATCH v3 03/10] xen: remap MSIs into pirqs when running as
 initial domain
Message-ID: <20101018154603.GC27373@dumpdata.com>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
 <1286901770-8612-3-git-send-email-Stefano.Stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286901770-8612-3-git-send-email-Stefano.Stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
> +{
> +	int irq = 0;

Lets make the default one -1, as that is the value we
are checking for errors later on.

> +	struct physdev_map_pirq map_irq;
> +	int rc;
> +	int pos;
> +	u32 table_offset, bir;
> +
> +	memset(&map_irq, 0, sizeof(map_irq));
> +	map_irq.domid = DOMID_SELF;
> +	map_irq.type = MAP_PIRQ_TYPE_MSI;
> +	map_irq.index = -1;
> +	map_irq.pirq = -1;
> +	map_irq.bus = dev->bus->number;
> +	map_irq.devfn = dev->devfn;
> +
> +	if (type == PCI_CAP_ID_MSIX) {
> +		pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
> +
> +		pci_read_config_dword(dev, msix_table_offset_reg(pos),
> +					&table_offset);
> +		bir = (u8)(table_offset & PCI_MSIX_FLAGS_BIRMASK);
> +
> +		map_irq.table_base = pci_resource_start(dev, bir);
> +		map_irq.entry_nr = msidesc->msi_attrib.entry_nr;
> +	}
> +
> +	spin_lock(&irq_mapping_update_lock);
> +
> +	irq = find_unbound_irq();
> +
> +	if (irq == -1)
> +		goto out;
> +
> +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
> +	if (rc) {
> +		printk(KERN_WARNING "xen map irq failed %d\n", rc);
> +
> +		dynamic_irq_cleanup(irq);
> +
> +		irq = -1;
> +		goto out;
> +	}
> +	irq_info[irq] = mk_pirq_info(0, map_irq.pirq, 0, map_irq.index);
> +
> +	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> +			handle_level_irq,
> +			(type == PCI_CAP_ID_MSIX) ? "msi-x":"msi");
> +
> +out:
> +	spin_unlock(&irq_mapping_update_lock);
> +	return irq;
> +}
> +#endif
> +
>  int xen_destroy_irq(int irq)
>  {
>  	struct irq_desc *desc;
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 0c58db6..8fa27dc 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -72,8 +72,12 @@ void xen_hvm_evtchn_do_upcall(void);
>   * usual. */
>  int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
>  int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
> +
> +#ifdef CONFIG_PCI_MSI
>  /* Allocate an irq and a pirq to be used with MSIs. */
>  void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
> +int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type);
> +#endif
>  
>  /* De-allocates the above mentioned physical interrupt. */
>  int xen_destroy_irq(int irq);
> -- 
> 1.5.6.5
