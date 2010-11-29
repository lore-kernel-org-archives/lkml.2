Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0K2RE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:04:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27299 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0K2REY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 29 Nov 2010 12:04:24 -0500
Date: Mon, 29 Nov 2010 12:03:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: fix MSI setup and teardown for PV on HVM guests
Message-ID: <20101129170351.GA20952@dumpdata.com>
References: <alpine.DEB.2.00.1011251904370.2373@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011251904370.2373@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 02:59:10PM +0000, Stefano Stabellini wrote:
> xen: fix MSI setup and teardown for PV on HVM guests
> 
> When remapping MSIs into pirqs for PV on HVM guests, qemu is responsible
> for doing the actual mapping and unmapping.

Is this QEMU version dependent? 
> We only give qemu the desired pirq number when we ask to do the mapping
> the first time, after that we should be reading back the pirq number
> from qemu every time we want to re-enable the MSI.

What about IRQ migration from CPU to CPU?
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index d7b5109..ff81d67 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -98,8 +98,26 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  	struct msi_msg msg;
>  
>  	list_for_each_entry(msidesc, &dev->msi_list, list) {
> +		__read_msi_msg(msidesc, &msg);
> +		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
> +			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
> +		if (xen_irq_from_pirq(pirq) >= 0 &&
> +			msg.data == (MSI_DATA_TRIGGER_EDGE |
> +					     MSI_DATA_LEVEL_ASSERT |
> +						 (3 << 8) |
> +						 MSI_DATA_VECTOR(0))) {

A similar construct is used in xen_msi_compose_msg function. Could you
make this an #define?
> +			xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
> +					"msi-x" : "msi", &irq, &pirq, XEN_ALLOC_IRQ);
> +			if (irq < 0 || pirq < 0)

The pirq value won't be touched at all, since you are passing in XEN_ALLOC_IRQ.
Is there any sense in checking the pirq value here?

> +				goto error;
> +			ret = set_irq_msi(irq, msidesc);
> +			if (ret < 0)
> +				goto error_while;
> +			printk(KERN_DEBUG "xen: msi already setup: pirq=%d\n", pirq);

While that is technically correct, would it make sense to add a comment
about setting the IRQ value since the printk "xen: msi-->irq=%d" is not going
to be reached?
> +			return 0;
> +		}
>  		xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
> -				"msi-x" : "msi", &irq, &pirq);
> +				"msi-x" : "msi", &irq, &pirq, (XEN_ALLOC_IRQ | XEN_ALLOC_PIRQ));
>  		if (irq < 0 || pirq < 0)
>  			goto error;
>  		printk(KERN_DEBUG "xen: msi --> irq=%d, pirq=%d\n", irq, pirq);
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 6e5dd92..5de6a6c 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -668,17 +668,21 @@ out:
>  #include <linux/msi.h>
>  #include "../pci/msi.h"
>  
> -void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
> +void xen_allocate_pirq_msi(char *name, int *irq, int *pirq, int alloc)
>  {
>  	spin_lock(&irq_mapping_update_lock);
>  
> -	*irq = find_unbound_irq();
> -	if (*irq == -1)
> -		goto out;
> +	if (alloc & XEN_ALLOC_IRQ) {
> +		*irq = find_unbound_irq();
> +		if (*irq == -1)
> +			goto out;
> +	}
>  
> -	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
> -	if (*pirq == -1)
> -		goto out;
> +	if (alloc & XEN_ALLOC_PIRQ) {
> +		*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
> +		if (*pirq == -1)
> +			goto out;
> +	}
>  
>  	set_irq_chip_and_handler_name(*irq, &xen_pirq_chip,
>  				      handle_level_irq, name);
> @@ -766,6 +770,7 @@ int xen_destroy_irq(int irq)
>  			printk(KERN_WARNING "unmap irq failed %d\n", rc);
>  			goto out;
>  		}
> +		pirq_to_irq[info->u.pirq.pirq] = -1;
>  	}
>  	irq_info[irq] = mk_unbound_info();
>  
> @@ -786,6 +791,11 @@ int xen_gsi_from_irq(unsigned irq)
>  	return gsi_from_irq(irq);
>  }
>  
> +int xen_irq_from_pirq(unsigned pirq)
> +{
> +	return pirq_to_irq[pirq];
> +}
> +
>  int bind_evtchn_to_irq(unsigned int evtchn)
>  {
>  	int irq;
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 646dd17..00f53dd 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -76,7 +76,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
>  
>  #ifdef CONFIG_PCI_MSI
>  /* Allocate an irq and a pirq to be used with MSIs. */
> -void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
> +#define XEN_ALLOC_PIRQ (1 << 0)
> +#define XEN_ALLOC_IRQ  (1 << 1)
> +void xen_allocate_pirq_msi(char *name, int *irq, int *pirq, int alloc_mask);
>  int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type);
>  #endif
>  
> @@ -89,4 +91,7 @@ int xen_vector_from_irq(unsigned pirq);
>  /* Return gsi allocated to pirq */
>  int xen_gsi_from_irq(unsigned pirq);
>  
> +/* Return irq from pirq */
> +int xen_irq_from_pirq(unsigned pirq);
> +
>  #endif	/* _XEN_EVENTS_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
