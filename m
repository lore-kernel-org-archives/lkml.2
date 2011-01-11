Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1AKXrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:47:24 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43640 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1AKXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:47:22 -0500
Date: Tue, 11 Jan 2011 16:47:16 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 08/15] x86/dtb: add support for PCI devices backed by
 dtb nodes
Message-ID: <20110111234716.GE2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-9-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-9-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:46PM +0100, Sebastian Andrzej Siewior wrote:
> x86_of_pci_init() does two things:
> - it provides a generic irq enable and disable function. enable queries
>   the device tree for the interrupt information, calls ->xlate on the
>   irq host and updates the pci->irq information for the device.
> 
> - it walks through PCI buss(es) in the device tree and adds its children
>   (devices) nodes to appropriate pci_dev nodes in kernel. So the dtb
>   node information is available at probe time of the PCI device.
> 
> Adding a PCI bus based on the information in the device tree is
> currently not supported. Right now direct access via ioports is used.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/include/asm/prom.h |   17 +++++++++
>  arch/x86/kernel/prom.c      |   80 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
> index 3bc8ed5..9f7484e 100644
> --- a/arch/x86/include/asm/prom.h
> +++ b/arch/x86/include/asm/prom.h
> @@ -16,6 +16,7 @@
>  
>  #include <linux/of.h>
>  #include <linux/types.h>
> +#include <linux/pci.h>
>  #include <asm/irq.h>
>  #include <asm/atomic.h>
>  #include <asm/setup.h>
> @@ -28,8 +29,24 @@ extern void add_dtb(u64 data);
>  void x86_dtb_find_config(void);
>  void x86_dtb_get_config(unsigned int unused);
>  void add_interrupt_host(struct irq_domain *ih);
> +void __cpuinit x86_of_pci_init(void);
> +
> +static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
> +{
> +	return pdev->dev.of_node;
> +}
> +
> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> +{
> +	if (bus->self)
> +		return pci_device_to_OF_node(bus->self);
> +	else
> +		return NULL;
> +}
> +

Hmmm, maybe pci_device_to_OF_node() should be checking for
bus->self == NULL.  It would probably be safer overall.

Otherwise, the patch looks good to me.

g.


>  #else
>  static inline void add_dtb(u64 data) { }
> +static inline void x86_of_pci_init(void) { }
>  #define x86_dtb_find_config x86_init_noop
>  #define x86_dtb_get_config x86_init_uint_noop
>  #define of_ioapic 0
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> index 40ad8c0..a449dc6 100644
> --- a/arch/x86/kernel/prom.c
> +++ b/arch/x86/kernel/prom.c
> @@ -9,10 +9,13 @@
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
>  #include <linux/slab.h>
> +#include <linux/pci.h>
> +#include <linux/of_pci.h>
>  
>  #include <asm/hpet.h>
>  #include <asm/irq_controller.h>
>  #include <asm/io_apic.h>
> +#include <asm/pci_x86.h>
>  
>  __initdata u64 initial_dtb;
>  char __initdata cmd_line[COMMAND_LINE_SIZE];
> @@ -102,6 +105,83 @@ void __init add_dtb(u64 data)
>  	initial_dtb = data + offsetof(struct setup_data, data);
>  }
>  
> +static int x86_of_pci_irq_enable(struct pci_dev *dev)
> +{
> +	struct of_irq oirq;
> +	u32 virq;
> +	int ret;
> +	u8 pin;
> +
> +	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> +	if (ret)
> +		return ret;
> +	if (!pin)
> +		return 0;
> +
> +	ret = of_irq_map_pci(dev, &oirq);
> +	if (ret)
> +		return ret;
> +
> +	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
> +			oirq.size);
> +	if (virq == NO_IRQ)
> +		return -EINVAL;
> +	dev->irq = virq;
> +	return 0;
> +}
> +
> +static void x86_of_pci_irq_disable(struct pci_dev *dev)
> +{
> +}
> +
> +void __cpuinit x86_of_pci_init(void)
> +{
> +	struct device_node *np;
> +
> +	pcibios_enable_irq = x86_of_pci_irq_enable;
> +	pcibios_disable_irq = x86_of_pci_irq_disable;
> +
> +	for_each_node_by_type(np, "pci") {
> +		const void *prop;
> +		struct pci_bus *bus;
> +		unsigned int bus_min;
> +		struct device_node *child;
> +
> +		prop = of_get_property(np, "bus-range", NULL);
> +		if (!prop)
> +			continue;
> +		bus_min = be32_to_cpup(prop);
> +
> +		bus = pci_find_bus(0, bus_min);
> +		if (!bus) {
> +			printk(KERN_ERR "Can't find a node for bus %s.\n",
> +					np->full_name);
> +			continue;
> +		}
> +
> +		if (bus->self)
> +			bus->self->dev.of_node = np;
> +		else
> +			bus->dev.of_node = np;
> +
> +		for_each_child_of_node(np, child) {
> +			struct pci_dev *dev;
> +			u32 devfn;
> +
> +			prop = of_get_property(child, "reg", NULL);
> +			if (!prop)
> +				continue;
> +
> +			devfn = (be32_to_cpup(prop) >> 8) & 0xff;
> +			dev = pci_get_slot(bus, devfn);
> +			if (!dev)
> +				continue;
> +			dev->dev.of_node = child;
> +			pci_dev_put(dev);
> +		}
> +	}
> +}
> +
>  static void __init dtb_setup_hpet(void)
>  {
>  	struct device_node *dn;
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
