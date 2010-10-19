Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab0JSKmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:42:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:14162 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab0JSKmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:42:01 -0400
X-IronPort-AV: E=Sophos;i="4.57,349,1283731200"; 
   d="scan'208";a="2408908"
Date: Tue, 19 Oct 2010 11:41:36 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH v3 02/10] xen: remap GSIs as pirqs when running as initial
 domain
In-Reply-To: <20101018154139.GB27373@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1010191116480.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop> <1286901770-8612-2-git-send-email-Stefano.Stabellini@eu.citrix.com> <20101018154139.GB27373@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 12, 2010 at 05:42:42PM +0100, Stefano Stabellini wrote:
> > From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > Implement xen_register_gsi to setup the correct triggering and polarity
> > properties of a gsi.
> > Implement xen_register_pirq to register a particular gsi as pirq and
> > receive interrupts as events.
> > Call xen_setup_pirqs to register all the legacy ISA irqs as pirqs.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/include/asm/xen/pci.h  |    7 ++
> >  arch/x86/pci/xen.c              |  132 +++++++++++++++++++++++++++++++++++++++
> >  drivers/xen/events.c            |   13 ++++
> >  include/xen/interface/physdev.h |   10 +++
> >  4 files changed, 162 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
> > index f89a42a..2329b3e 100644
> > --- a/arch/x86/include/asm/xen/pci.h
> > +++ b/arch/x86/include/asm/xen/pci.h
> > @@ -13,6 +13,13 @@ static inline int pci_xen_hvm_init(void)
> >  	return -1;
> >  }
> >  #endif
> > +#if defined(CONFIG_XEN_DOM0)
> > +void __init xen_setup_pirqs(void);
> > +#else
> > +static inline void __init xen_setup_pirqs(void)
> > +{
> > +}
> > +#endif
> >  
> >  #if defined(CONFIG_PCI_MSI)
> >  #if defined(CONFIG_PCI_XEN)
> > diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> > index fb20d05..5d87774 100644
> > --- a/arch/x86/pci/xen.c
> > +++ b/arch/x86/pci/xen.c
> > @@ -262,3 +262,135 @@ int __init pci_xen_hvm_init(void)
> >  #endif
> >  	return 0;
> >  }
> > +
> > +#ifdef CONFIG_XEN_DOM0
> > +static int xen_register_pirq(u32 gsi, int triggering)
> > +{
> > +	int rc, irq;
> > +	struct physdev_map_pirq map_irq;
> > +	int shareable = 0;
> > +	char *name;
> > +
> > +	if (!xen_pv_domain())
> > +		return -1;
> > +
> > +	if (triggering == ACPI_EDGE_SENSITIVE) {
> > +		shareable = 0;
> > +		name = "ioapic-edge";
> > +	} else {
> > +		shareable = 1;
> > +		name = "ioapic-level";
> > +	}
> > +
> > +	irq = xen_allocate_pirq(gsi, shareable, name);
> > +
> > +	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
> > +
> > +	if (irq < 0)
> > +		goto out;
> > +
> > +	map_irq.domid = DOMID_SELF;
> > +	map_irq.type = MAP_PIRQ_TYPE_GSI;
> > +	map_irq.index = gsi;
> > +	map_irq.pirq = irq;
> > +
> > +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
> > +	if (rc) {
> > +		printk(KERN_WARNING "xen map irq failed %d\n", rc);
> > +		return -1;
> > +	}
> > +
> > +out:
> > +	return irq;
> > +}
> > +
> > +static int xen_register_gsi(u32 gsi, int triggering, int polarity)
> > +{
> > +	int rc, irq;
> > +	struct physdev_setup_gsi setup_gsi;
> > +
> > +	if (!xen_pv_domain())
> > +		return -1;
> > +
> > +	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
> > +			gsi, triggering, polarity);
> > +
> > +	irq = xen_register_pirq(gsi, triggering);
> > +
> > +	setup_gsi.gsi = gsi;
> > +	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
> > +	setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
> > +
> > +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
> > +	if (rc == -EEXIST)
> > +		printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
> > +	else if (rc) {
> > +		printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
> > +				gsi, rc);
> > +	}
> > +
> > +	return irq;
> > +}
> > +
> > +static __init void xen_setup_acpi_sci(void)
> > +{
> > +	int rc;
> > +	int trigger, polarity;
> > +	int gsi = acpi_sci_override_gsi;
> > +
> > +	if (!gsi)
> > +		return;
> 
> Should this be 'if (gsi >= 0)' ? I haven't seen any machine
> with the GSI at IRQ 0, but perhaps it would be possible?
> 

The test is correct as it is because it is meant to check if the
acpi_sci_override_gsi has been set correctly and by default is 0.
A similar test is done in
arch/x86/kernel/acpi/boot.c:acpi_parse_madt_ioapic_entries.


> > +
> > +	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
> > +	if (rc)
> > +		return;
> 
> We don't want to report the error? Say a printk?
> 

good idea, I'll add one.

> > +	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
> > +	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> > +	
> > +	printk("xen: sci override: global_irq=%d trigger=%d polarity=%d\n",
> > +			gsi, trigger, polarity);
> > +
> > +	gsi = xen_register_gsi(gsi, trigger, polarity);
> > +	printk("xen: acpi sci %d\n", gsi);
> 
> KERN_INFO ?

ok

> > +
> > +	return;
> > +}
> > +
> > +static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
> > +				 int trigger, int polarity)
> > +{
> > +	return xen_register_gsi(gsi, trigger, polarity);
> > +}
> > +
> > +static int __init pci_xen_initial_domain(void)
> > +{
> > +	xen_setup_acpi_sci();
> > +	__acpi_register_gsi = acpi_register_gsi_xen;
> > +
> > +	return 0;
> > +}
> > +
> > +void __init xen_setup_pirqs(void)
> > +{
> > +	int irq;
> > +
> > +	pci_xen_initial_domain();
> > +
> > +	if (0 == nr_ioapics) {
> 
> This function is only called for the Dom0 case, so under
> what conditions would we have a machine with zero IO APICs?
> 
> And do we actually support machines with no IO APICs?
> (would Xen run under such ancient hardware?)
 
I don't know about real hardware but during the development of the PV on
HVM series I was able to boot a PV on HVM guest using the nr_ioapics==0
code path successfully several times.
And you never know what the future may bring :)

