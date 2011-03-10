Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1CJEBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:01:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38322 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1CJEBI (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 9 Mar 2011 23:01:08 -0500
Date: Wed, 9 Mar 2011 23:00:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 06/14] xen: events: refactor GSI pirq
 bindings functions
Message-ID: <20110310040042.GA7682@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
 <1299692486-28634-6-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299692486-28634-6-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D784CFA.0161,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:41:18PM +0000, Ian Campbell wrote:
> Following the example set by xen_allocate_pirq_msi and
> xen_bind_pirq_msi_to_irq:
> 
> xen_allocate_pirq becomes xen_allocate_pirq_gsi and now only allocates
> a pirq number and does not bind it.
> 
> xen_map_pirq_gsi becomes xen_bind_pirq_gsi_to_irq and binds an
> existing pirq.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  arch/x86/pci/xen.c   |   40 ++++++++++++++++++++++++++++------------
>  drivers/xen/events.c |    7 ++++---
>  include/xen/events.h |   10 +++++++---
>  3 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 8c4085a..b0fb79d 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -50,7 +50,7 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
>  		name = "ioapic-level";
>  	}
>  
> -	irq = xen_map_pirq_gsi(map_irq.pirq, gsi, shareable, name);
> +	irq = xen_bind_pirq_gsi_to_irq(gsi, map_irq.pirq, shareable, name);
>  
>  	printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
>  
> @@ -237,6 +237,7 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
>  {
>  	int rc;
>  	int share = 1;
> +	int pirq;
>  	u8 gsi;
>  
>  	rc = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
> @@ -246,13 +247,21 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
>  		return rc;
>  	}
>  
> +	rc = xen_allocate_pirq_gsi(gsi);
> +	if (rc < 0) {
> +		dev_warn(&dev->dev, "Xen PCI: failed to allocate a PIRQ for GSI%d: %d\n",
> +			 gsi, rc);
> +		return rc;
> +	}
> +	pirq = rc;
> +
>  	if (gsi < NR_IRQS_LEGACY)
>  		share = 0;
>  
> -	rc = xen_allocate_pirq(gsi, share, "pcifront");
> +	rc = xen_bind_pirq_gsi_to_irq(gsi, pirq, share, "pcifront");
>  	if (rc < 0) {
> -		dev_warn(&dev->dev, "Xen PCI: failed to register GSI%d: %d\n",
> -			 gsi, rc);
> +		dev_warn(&dev->dev, "Xen PCI: failed to bind GSI%d (PIRQ%d) to IRQ: %d\n",
> +			 gsi, pirq, rc);
>  		return rc;
>  	}
>  
> @@ -309,7 +318,7 @@ int __init pci_xen_hvm_init(void)
>  #ifdef CONFIG_XEN_DOM0
>  static int xen_register_pirq(u32 gsi, int triggering)
>  {
> -	int rc, irq;
> +	int rc, pirq, irq = -1;
>  	struct physdev_map_pirq map_irq;
>  	int shareable = 0;
>  	char *name;
> @@ -325,17 +334,20 @@ static int xen_register_pirq(u32 gsi, int triggering)
>  		name = "ioapic-level";
>  	}
>  
> -	irq = xen_allocate_pirq(gsi, shareable, name);
> -
> -	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
> +	pirq = xen_allocate_pirq_gsi(gsi);
> +	if (pirq < 0)
> +		goto out;
>  
> +	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
>  	if (irq < 0)
>  		goto out;
>  
> +	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d\n", pirq, irq);
> +
>  	map_irq.domid = DOMID_SELF;
>  	map_irq.type = MAP_PIRQ_TYPE_GSI;
>  	map_irq.index = gsi;
> -	map_irq.pirq = irq;
> +	map_irq.pirq = pirq;
>  
>  	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
>  	if (rc) {
> @@ -422,13 +434,17 @@ static int __init pci_xen_initial_domain(void)
>  
>  void __init xen_setup_pirqs(void)
>  {
> -	int irq;
> +	int pirq, irq;
>  
>  	pci_xen_initial_domain();
>  
>  	if (0 == nr_ioapics) {
> -		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
> -			xen_allocate_pirq(irq, 0, "xt-pic");
> +		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
> +			pirq = xen_allocate_pirq_gsi(irq);
> +			if (pirq < 0)
> +				break;

Would it make sense to print a warning here?
