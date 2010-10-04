Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0JDT0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:26:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0JDT0N (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 15:26:13 -0400
Date: Mon, 4 Oct 2010 15:24:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2 01/10] xen: remap GSIs as pirqs when
 running as initial domain
Message-ID: <20101004192426.GA10291@dumpdata.com>
References: <alpine.DEB.2.00.1009301536300.2864@kaball-desktop>
 <1286191730-3188-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286191730-3188-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 12:28:41PM +0100, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Implement xen_register_gsi to setup the correct triggering and polarity
> properties of a gsi.
> Implement xen_register_pirq to register a particular gsi as pirq and
> receive interrupts as events.
> Call xen_setup_pirqs to register all the legacy ISA irqs as pirqs.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/pci/xen.c              |  144 ++++++++++++++++++++++++++++++++++++++-
>  drivers/xen/events.c            |   13 ++++
>  include/xen/events.h            |    2 +
>  include/xen/interface/physdev.h |   10 +++
>  4 files changed, 168 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 6fbc81a..cb8d5be 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -18,6 +18,108 @@
>  #include <xen/events.h>
>  #include <asm/xen/pci.h>
>  
> +static int xen_register_pirq(u32 gsi, int triggering)
> +{
> +	int rc, irq;
> +	struct physdev_map_pirq map_irq;
> +	int shareable = 0;
> +	char *name;
> +
> +	if (!xen_pv_domain())
> +		return -1;
> +
> +	if (triggering == ACPI_EDGE_SENSITIVE) {
> +		shareable = 0;
> +		name = "ioapic-edge";
> +	} else {
> +		shareable = 1;
> +		name = "ioapic-level";
> +	}
> +
> +	irq = xen_allocate_pirq(gsi, shareable, name);
> +
> +	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
> +
> +	if (irq < 0)
> +		goto out;
> +
> +	map_irq.domid = DOMID_SELF;
> +	map_irq.type = MAP_PIRQ_TYPE_GSI;
> +	map_irq.index = gsi;
> +	map_irq.pirq = irq;
> +
> +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
> +	if (rc) {
> +		printk(KERN_WARNING "xen map irq failed %d\n", rc);
> +		return -1;
> +	}
> +
> +out:
> +	return irq;
> +}
> +
> +static int xen_register_gsi(u32 gsi, int triggering, int polarity)
> +{
> +	int rc, irq;
> +	struct physdev_setup_gsi setup_gsi;
> +
> +	if (!xen_pv_domain())
> +		return -1;
> +
> +	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
> +			gsi, triggering, polarity);
> +
> +	irq = xen_register_pirq(gsi, triggering);
> +
> +	setup_gsi.gsi = gsi;
> +	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
> +	setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
> +
> +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
> +	if (rc == -EEXIST)
> +		printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
> +	else if (rc) {
> +		printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
> +				gsi, rc);
> +	}
> +
> +	return irq;
> +}
> +
> +#ifdef CONFIG_ACPI
> +static __init void xen_setup_acpi_sci(void)
> +{
> +	int rc;
> +	int trigger, polarity;
> +	int gsi = acpi_sci_override_gsi;
> +
> +	if (!gsi)
> +		return;
> +
> +	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
> +	if (rc)
> +		return;
> +	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
> +	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +	
> +	printk("xen: sci override: global_irq=%d trigger=%d polarity=%d\n",
> +			gsi, trigger, polarity);
> +
> +	gsi = xen_register_gsi(gsi,	trigger, polarity);

What happend here? Tabs-gone-wild?
> +	/*
> +	 * stash over-ride to indicate we've been here
> +	 * and for later update of acpi_gbl_FADT
> +	 */

I think that comment is obsolete. We are not stashing anything?
> +	printk("xen: acpi sci %d\n", gsi);
> +
> +	return;
> +}
> +#else
> +static __init void xen_setup_acpi_sci(void)
> +{
> +}
> +#endif
> +
>  int xen_hvm_register_pirq(u32 gsi, int triggering)
>  {
>  	int rc, irq;
> @@ -211,10 +313,15 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
>  	return xen_hvm_register_pirq(gsi, trigger);
>  }
>  
> +static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
> +				 int trigger, int polarity)
> +{
> +	return xen_register_gsi(gsi, trigger, polarity);
> +}
>  
>  int __init pci_xen_init(void)
>  {
> -	if (!xen_pv_domain() || xen_initial_domain())
> + 	if (!xen_pv_domain() || xen_initial_domain())

What changed? They look exactly the same?

>  		return -ENODEV;
>  
>  	printk(KERN_INFO "PCI: setting up Xen PCI frontend stub\n");
> @@ -242,6 +349,41 @@ int __init pci_xen_init(void)
>  	return 0;
>  }
>  
> +static int __init pci_xen_initial_domain(void)
> +{
> +	xen_setup_acpi_sci();
> +	__acpi_register_gsi = acpi_register_gsi_xen;
> +
> +	return 0;
> +}
> +
> +void __init xen_setup_pirqs(void)
> +{
> +	int irq;
> +#ifndef CONFIG_SMP
> +	int nr_ioapics = 1;
> +#endif

Should this be defined in a header instead? Was this nr_ioapics==1
meant to fall in the '0 == nr_ioapics' to setup the first sixteen
irqs?

Is CONFIG_X86_IO_APIC more appropiate than CONFIG_SMP?
> +
> +	pci_xen_initial_domain();
> +
> +	if (0 == nr_ioapics) {
> +		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
> +			xen_allocate_pirq(irq, 0, "xt-pic");
> +		return;
> +	}
> +
> +	/* Pre-allocate legacy irqs */
> +	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
> +		int trigger, polarity;
> +
> +		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
> +			continue;
> +
> +		xen_register_pirq(irq,
> +			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
> +	}
> +}
> +
>  int __init pci_xen_hvm_init(void)
>  {
>  	if (!xen_feature(XENFEAT_hvm_pirqs))
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index a31677e..27e4b70 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -676,6 +676,8 @@ out:
>  int xen_destroy_irq(int irq)
>  {
>  	struct irq_desc *desc;
> +	struct physdev_unmap_pirq unmap_irq;
> +	struct irq_info *info = info_for_irq(irq);
>  	int rc = -ENOENT;
>  
>  	spin_lock(&irq_mapping_update_lock);
> @@ -684,6 +686,15 @@ int xen_destroy_irq(int irq)
>  	if (!desc)
>  		goto out;
>  
> +	if (xen_initial_domain()) {
> +		unmap_irq.pirq = info->u.pirq.gsi;
> +		unmap_irq.domid = DOMID_SELF;
> +		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
> +		if (rc) {
> +			printk(KERN_WARNING "unmap irq failed %d\n", rc);
> +			goto out;
> +		}
> +	}
>  	irq_info[irq] = mk_unbound_info();
>  
>  	dynamic_irq_cleanup(irq);
> @@ -1410,5 +1421,7 @@ void __init xen_init_IRQ(void)
>  		pci_xen_hvm_init();
>  	} else {
>  		irq_ctx_init(smp_processor_id());
> +		if (xen_initial_domain())
> +			xen_setup_pirqs();
>  	}
>  }
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 5e67be7..9853fce 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -84,4 +84,6 @@ int xen_vector_from_irq(unsigned pirq);
>  /* Return gsi allocated to pirq */
>  int xen_gsi_from_irq(unsigned pirq);
>  
> +void xen_setup_pirqs(void);
> +
>  #endif	/* _XEN_EVENTS_H */
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 69a72b9..a85d76c 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -151,6 +151,16 @@ struct physdev_op {
>  	} u;
>  };
>  
> +#define PHYSDEVOP_setup_gsi    21
> +struct physdev_setup_gsi {
> +    int gsi;
> +    /* IN */
> +    uint8_t triggering;
> +    /* IN */
> +    uint8_t polarity;
> +    /* IN */
> +};
> +
>  #define PHYSDEVOP_get_nr_pirqs    22
>  struct physdev_nr_pirqs {
>      /* OUT */
> -- 
> 1.5.6.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
