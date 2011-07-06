Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1GFIav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:30:51 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:46776 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1GFIas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:30:48 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110705213243.GA3647@dumpdata.com>
References: <20110703232508.GB4440@Xye>
	 <1309769388.634.51.camel@zakaz.uk.xensource.com>
	 <20110704221646.GB4490@Xye> <20110705141323.GG2972@dumpdata.com>
	 <20110705142731.GA4463@Xye> <20110705144846.GA13548@dumpdata.com>
	 <20110705213243.GA3647@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 09:30:30 +0100
Message-ID: <1309941030.634.157.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [TOME] Re: [PATCH] Modpost section mismatch fix
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 22:32 +0100, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 05, 2011 at 10:48:46AM -0400, Konrad Rzeszutek Wilk wrote:
> > > >>xen_register_gsi and hence, xen_register_pirq are called from
> > > >>init (with xen_setup_acpi_sci) and non-init (with
> > > >>acpi_register_gsi_xen); since xen_set_acpi_sci calls it with gsi ==
> > > >>acpi_sci_override_gsi and is marked __init, the best way would be to
> > > >>call xen_register_gsi and xen_register_pirq with a boolean argument like
> > > >>sci_override to obviate the need to use acpi_sci_override_gsi in
> > > >>register_pirq. I will send the patch with this change if it looks good.
> > > >
> > > >Hold on, let me rebase #stable/pci.cleanups and see if the issue
> > > >here disappears.
> > > Thanks, will wait until the rebase and test after that.
> > 
> > Hm, it actually looks like it wont do the trick. Why don't you send
> > a patch against 3.0-rc6 with the outlined mechanism mentioned above.
> 
> Or this patch (against 3.0-rc6) might do the trick:

Based on my limited understanding it looks like it would to me.

But is there some downside to always unconditionally calling
acpi_gsi_to_irq in xen_register_pirq? It seems like it returns the
expected mapping except where explicit overrides (such as this SCI
thing) exist?

Ian.

> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index fe00830..f567965 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -327,13 +327,12 @@ int __init pci_xen_hvm_init(void)
>  }
>  
>  #ifdef CONFIG_XEN_DOM0
> -static int xen_register_pirq(u32 gsi, int triggering)
> +static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
>  {
>  	int rc, pirq, irq = -1;
>  	struct physdev_map_pirq map_irq;
>  	int shareable = 0;
>  	char *name;
> -	bool gsi_override = false;
>  
>  	if (!xen_pv_domain())
>  		return -1;
> @@ -345,31 +344,12 @@ static int xen_register_pirq(u32 gsi, int triggering)
>  		shareable = 1;
>  		name = "ioapic-level";
>  	}
> -
>  	pirq = xen_allocate_pirq_gsi(gsi);
>  	if (pirq < 0)
>  		goto out;
>  
> -	/* Before we bind the GSI to a Linux IRQ, check whether
> -	 * we need to override it with bus_irq (IRQ) value. Usually for
> -	 * IRQs below IRQ_LEGACY_IRQ this holds IRQ == GSI, as so:
> -	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> -	 * but there are oddballs where the IRQ != GSI:
> -	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
> -	 * which ends up being: gsi_to_irq[9] == 20
> -	 * (which is what acpi_gsi_to_irq ends up calling when starting the
> -	 * the ACPI interpreter and keels over since IRQ 9 has not been
> -	 * setup as we had setup IRQ 20 for it).
> -	 */
> -	if (gsi == acpi_sci_override_gsi) {
> -		/* Check whether the GSI != IRQ */
> -		acpi_gsi_to_irq(gsi, &irq);
> -		if (irq != gsi)
> -			/* Bugger, we MUST have that IRQ. */
> -			gsi_override = true;
> -	}
> -	if (gsi_override)
> -		irq = xen_bind_pirq_gsi_to_irq(irq, pirq, shareable, name);
> +	if (gsi_override >= 0)
> +		irq = xen_bind_pirq_gsi_to_irq(gsi_override, pirq, shareable, name);
>  	else
>  		irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
>  	if (irq < 0)
> @@ -392,7 +372,7 @@ out:
>  	return irq;
>  }
>  
> -static int xen_register_gsi(u32 gsi, int triggering, int polarity)
> +static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polarity)
>  {
>  	int rc, irq;
>  	struct physdev_setup_gsi setup_gsi;
> @@ -403,7 +383,7 @@ static int xen_register_gsi(u32 gsi, int triggering, int polarity)
>  	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
>  			gsi, triggering, polarity);
>  
> -	irq = xen_register_pirq(gsi, triggering);
> +	irq = xen_register_pirq(gsi, gsi_override, triggering);
>  
>  	setup_gsi.gsi = gsi;
>  	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
> @@ -425,6 +405,8 @@ static __init void xen_setup_acpi_sci(void)
>  	int rc;
>  	int trigger, polarity;
>  	int gsi = acpi_sci_override_gsi;
> +	int irq = -1;
> +	int gsi_override = -1;
>  
>  	if (!gsi)
>  		return;
> @@ -441,7 +423,25 @@ static __init void xen_setup_acpi_sci(void)
>  	printk(KERN_INFO "xen: sci override: global_irq=%d trigger=%d "
>  			"polarity=%d\n", gsi, trigger, polarity);
>  
> -	gsi = xen_register_gsi(gsi, trigger, polarity);
> +	/* Before we bind the GSI to a Linux IRQ, check whether
> +	 * we need to override it with bus_irq (IRQ) value. Usually for
> +	 * IRQs below IRQ_LEGACY_IRQ this holds IRQ == GSI, as so:
> +	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> +	 * but there are oddballs where the IRQ != GSI:
> +	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
> +	 * which ends up being: gsi_to_irq[9] == 20
> +	 * (which is what acpi_gsi_to_irq ends up calling when starting the
> +	 * the ACPI interpreter and keels over since IRQ 9 has not been
> +	 * setup as we had setup IRQ 20 for it).
> +	 */
> +	/* Check whether the GSI != IRQ */
> +	if (acpi_gsi_to_irq(gsi, &irq) == 0) {
> +		if (irq >= 0 && irq != gsi)
> +			/* Bugger, we MUST have that IRQ. */
> +			gsi_override = irq;
> +	}
> +
> +	gsi = xen_register_gsi(gsi, gsi_override, trigger, polarity);
>  	printk(KERN_INFO "xen: acpi sci %d\n", gsi);
>  
>  	return;
> @@ -450,7 +450,7 @@ static __init void xen_setup_acpi_sci(void)
>  static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
>  				 int trigger, int polarity)
>  {
> -	return xen_register_gsi(gsi, trigger, polarity);
> +	return xen_register_gsi(gsi, -1 /* no GSI override */, trigger, polarity);
>  }
>  
>  static int __init pci_xen_initial_domain(void)
> @@ -489,7 +489,7 @@ void __init xen_setup_pirqs(void)
>  		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
>  			continue;
>  
> -		xen_register_pirq(irq,
> +		xen_register_pirq(irq, -1 /* no GSI override */,
>  			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
>  	}
>  }
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

-- 
Ian Campbell

While having never invented a sin, I'm trying to perfect several.

