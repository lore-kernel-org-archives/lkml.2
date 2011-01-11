Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1AKX1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:27:38 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57597 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1AKX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:27:35 -0500
Date: Tue, 11 Jan 2011 16:27:26 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 07/15] of: move of_irq_map_pci() into generic code
Message-ID: <20110111232726.GD2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-8-git-send-email-bigeasy@linutronix.de>
 <1292620597.16694.541.camel@pasglop>
 <20110104142754.GD21359@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104142754.GD21359@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 03:27:54PM +0100, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> There is a tiny difference between PPC32 and PPC64. Microblaze uses the
> PPC32 variant.

Mostly looks good, but breaks both Sparc and microblaze which is kind
of important to fix before I merge it.  :-)

Sparc
-----
  CC      drivers/of/of_pci.o
/home/grant/hacking/linux-2.6/drivers/of/of_pci.c: In function 'of_irq_map_pci':
/home/grant/hacking/linux-2.6/drivers/of/of_pci.c:20: error: implicit declaration of function 'of_irq_map_one'
/home/grant/hacking/linux-2.6/drivers/of/of_pci.c:44: error: implicit declaration of function 'pci_bus_to_OF_node'
/home/grant/hacking/linux-2.6/drivers/of/of_pci.c:44: warning: assignment makes pointer from integer without a cast
/home/grant/hacking/linux-2.6/drivers/of/of_pci.c:78: error: implicit declaration of function 'of_irq_map_raw'
make[3]: *** [drivers/of/of_pci.o] Error 1


Microblaze
----------
  CC      arch/microblaze/kernel/prom.o
In file included from /home/grant/hacking/linux-2.6/arch/microblaze/include/asm/pci.h:23,
                 from /home/grant/hacking/linux-2.6/include/linux/pci.h:1230,
                 from /home/grant/hacking/linux-2.6/arch/microblaze/kernel/prom.c:23:
/home/grant/hacking/linux-2.6/arch/microblaze/include/asm/pci-bridge.h: In function 'pci_bus_to_OF_node':
/home/grant/hacking/linux-2.6/arch/microblaze/include/asm/pci-bridge.h:117: error: implicit declaration of function 'pci_device_to_OF_node'
/home/grant/hacking/linux-2.6/arch/microblaze/include/asm/pci-bridge.h:117: warning: return makes pointer from integer without a cast
make[2]: *** [arch/microblaze/kernel/prom.o] Error 1
make[1]: *** [arch/microblaze/kernel] Error 2
make: *** [sub-make] Error 2


> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/microblaze/include/asm/pci-bridge.h |   10 ++++
>  arch/microblaze/include/asm/prom.h       |   15 -----
>  arch/microblaze/kernel/prom_parse.c      |   77 ---------------------------
>  arch/microblaze/pci/pci-common.c         |    1 +
>  arch/powerpc/include/asm/pci-bridge.h    |   10 ++++
>  arch/powerpc/include/asm/prom.h          |   15 -----
>  arch/powerpc/kernel/pci-common.c         |    1 +
>  arch/powerpc/kernel/prom_parse.c         |   84 ------------------------------
>  drivers/of/Makefile                      |    1 +
>  drivers/of/of_pci.c                      |   80 ++++++++++++++++++++++++++++
>  include/linux/of_pci.h                   |   20 +++++++
>  11 files changed, 123 insertions(+), 191 deletions(-)
>  create mode 100644 drivers/of/of_pci.c
>  create mode 100644 include/linux/of_pci.h
> 
> diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
> index 0c68764..0808217 100644
> --- a/arch/microblaze/include/asm/pci-bridge.h
> +++ b/arch/microblaze/include/asm/pci-bridge.h
> @@ -109,6 +109,16 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
>  	return bus->sysdata;
>  }


>  
> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> +{
> +	struct pci_controller *host;
> +
> +	if (bus->self)
> +		return pci_device_to_OF_node(bus->self);
> +	host = pci_bus_to_host(bus);
> +	return host ? host->dn : NULL;
> +}
> +
>  static inline int isa_vaddr_is_ioport(void __iomem *address)
>  {
>  	/* No specific ISA handling on ppc32 at this stage, it
> diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
> index bdc3831..aa3ab12 100644
> --- a/arch/microblaze/include/asm/prom.h
> +++ b/arch/microblaze/include/asm/prom.h
> @@ -67,21 +67,6 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
>  /* Get the MAC address */
>  extern const void *of_get_mac_address(struct device_node *np);
>  
> -/**
> - * of_irq_map_pci - Resolve the interrupt for a PCI device
> - * @pdev:	the device whose interrupt is to be resolved
> - * @out_irq:	structure of_irq filled by this function
> - *
> - * This function resolves the PCI interrupt for a given PCI device. If a
> - * device-node exists for a given pci_dev, it will use normal OF tree
> - * walking. If not, it will implement standard swizzling and walk up the
> - * PCI tree until an device-node is found, at which point it will finish
> - * resolving using the OF tree walking.
> - */
> -struct pci_dev;
> -struct of_irq;
> -extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> -
>  #endif /* __ASSEMBLY__ */
>  #endif /* __KERNEL__ */
>  
> diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
> index 99d9b61..306f41d 100644
> --- a/arch/microblaze/kernel/prom_parse.c
> +++ b/arch/microblaze/kernel/prom_parse.c
> @@ -2,88 +2,11 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> -#include <linux/pci_regs.h>
>  #include <linux/module.h>
>  #include <linux/ioport.h>
>  #include <linux/etherdevice.h>
>  #include <linux/of_address.h>
>  #include <asm/prom.h>
> -#include <asm/pci-bridge.h>
> -
> -#ifdef CONFIG_PCI
> -int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
> -{
> -	struct device_node *dn, *ppnode;
> -	struct pci_dev *ppdev;
> -	u32 lspec;
> -	u32 laddr[3];
> -	u8 pin;
> -	int rc;
> -
> -	/* Check if we have a device node, if yes, fallback to standard OF
> -	 * parsing
> -	 */
> -	dn = pci_device_to_OF_node(pdev);
> -	if (dn)
> -		return of_irq_map_one(dn, 0, out_irq);
> -
> -	/* Ok, we don't, time to have fun. Let's start by building up an
> -	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
> -	 * for PCI. If you do different, then don't use that routine.
> -	 */
> -	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> -	if (rc != 0)
> -		return rc;
> -	/* No pin, exit */
> -	if (pin == 0)
> -		return -ENODEV;
> -
> -	/* Now we walk up the PCI tree */
> -	lspec = pin;
> -	for (;;) {
> -		/* Get the pci_dev of our parent */
> -		ppdev = pdev->bus->self;
> -
> -		/* Ouch, it's a host bridge... */
> -		if (ppdev == NULL) {
> -			struct pci_controller *host;
> -			host = pci_bus_to_host(pdev->bus);
> -			ppnode = host ? host->dn : NULL;
> -			/* No node for host bridge ? give up */
> -			if (ppnode == NULL)
> -				return -EINVAL;
> -		} else
> -			/* We found a P2P bridge, check if it has a node */
> -			ppnode = pci_device_to_OF_node(ppdev);
> -
> -		/* Ok, we have found a parent with a device-node, hand over to
> -		 * the OF parsing code.
> -		 * We build a unit address from the linux device to be used for
> -		 * resolution. Note that we use the linux bus number which may
> -		 * not match your firmware bus numbering.
> -		 * Fortunately, in most cases, interrupt-map-mask doesn't
> -		 * include the bus number as part of the matching.
> -		 * You should still be careful about that though if you intend
> -		 * to rely on this function (you ship  a firmware that doesn't
> -		 * create device nodes for all PCI devices).
> -		 */
> -		if (ppnode)
> -			break;
> -
> -		/* We can only get here if we hit a P2P bridge with no node,
> -		 * let's do standard swizzling and try again
> -		 */
> -		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
> -		pdev = ppdev;
> -	}
> -
> -	laddr[0] = (pdev->bus->number << 16)
> -		| (pdev->devfn << 8);
> -	laddr[1]  = laddr[2] = 0;
> -	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
> -}
> -EXPORT_SYMBOL_GPL(of_irq_map_pci);
> -#endif /* CONFIG_PCI */
>  
>  void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
>  		unsigned long *busno, unsigned long *phys, unsigned long *size)
> diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
> index e363615..1e01a12 100644
> --- a/arch/microblaze/pci/pci-common.c
> +++ b/arch/microblaze/pci/pci-common.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/of_pci.h>
>  
>  #include <asm/processor.h>
>  #include <asm/io.h>
> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> index 51e9e6f..edeb80f 100644
> --- a/arch/powerpc/include/asm/pci-bridge.h
> +++ b/arch/powerpc/include/asm/pci-bridge.h
> @@ -171,6 +171,16 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
>  	return bus->sysdata;
>  }
>  
> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> +{
> +	struct pci_controller *host;
> +
> +	if (bus->self)
> +		return pci_device_to_OF_node(bus->self);
> +	host = pci_bus_to_host(bus);
> +	return host ? host->dn : NULL;
> +}
> +
>  static inline int isa_vaddr_is_ioport(void __iomem *address)
>  {
>  	/* No specific ISA handling on ppc32 at this stage, it
> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index ae26f2e..01c3302 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -73,21 +73,6 @@ static inline int of_node_to_nid(struct device_node *device) { return 0; }
>  #endif
>  #define of_node_to_nid of_node_to_nid
>  
> -/**
> - * of_irq_map_pci - Resolve the interrupt for a PCI device
> - * @pdev:	the device whose interrupt is to be resolved
> - * @out_irq:	structure of_irq filled by this function
> - *
> - * This function resolves the PCI interrupt for a given PCI device. If a
> - * device-node exists for a given pci_dev, it will use normal OF tree
> - * walking. If not, it will implement standard swizzling and walk up the
> - * PCI tree until an device-node is found, at which point it will finish
> - * resolving using the OF tree walking.
> - */
> -struct pci_dev;
> -struct of_irq;
> -extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> -
>  extern void of_instantiate_rtc(void);
>  
>  /* These includes are put at the bottom because they may contain things
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 10a44e6..eb341be 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -22,6 +22,7 @@
>  #include <linux/init.h>
>  #include <linux/bootmem.h>
>  #include <linux/of_address.h>
> +#include <linux/of_pci.h>
>  #include <linux/mm.h>
>  #include <linux/list.h>
>  #include <linux/syscalls.h>
> diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
> index 88334af..306f41d 100644
> --- a/arch/powerpc/kernel/prom_parse.c
> +++ b/arch/powerpc/kernel/prom_parse.c
> @@ -2,95 +2,11 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> -#include <linux/pci_regs.h>
>  #include <linux/module.h>
>  #include <linux/ioport.h>
>  #include <linux/etherdevice.h>
>  #include <linux/of_address.h>
>  #include <asm/prom.h>
> -#include <asm/pci-bridge.h>
> -
> -#ifdef CONFIG_PCI
> -int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
> -{
> -	struct device_node *dn, *ppnode;
> -	struct pci_dev *ppdev;
> -	u32 lspec;
> -	u32 laddr[3];
> -	u8 pin;
> -	int rc;
> -
> -	/* Check if we have a device node, if yes, fallback to standard OF
> -	 * parsing
> -	 */
> -	dn = pci_device_to_OF_node(pdev);
> -	if (dn) {
> -		rc = of_irq_map_one(dn, 0, out_irq);
> -		if (!rc)
> -			return rc;
> -	}
> -
> -	/* Ok, we don't, time to have fun. Let's start by building up an
> -	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
> -	 * for PCI. If you do different, then don't use that routine.
> -	 */
> -	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> -	if (rc != 0)
> -		return rc;
> -	/* No pin, exit */
> -	if (pin == 0)
> -		return -ENODEV;
> -
> -	/* Now we walk up the PCI tree */
> -	lspec = pin;
> -	for (;;) {
> -		/* Get the pci_dev of our parent */
> -		ppdev = pdev->bus->self;
> -
> -		/* Ouch, it's a host bridge... */
> -		if (ppdev == NULL) {
> -#ifdef CONFIG_PPC64
> -			ppnode = pci_bus_to_OF_node(pdev->bus);
> -#else
> -			struct pci_controller *host;
> -			host = pci_bus_to_host(pdev->bus);
> -			ppnode = host ? host->dn : NULL;
> -#endif
> -			/* No node for host bridge ? give up */
> -			if (ppnode == NULL)
> -				return -EINVAL;
> -		} else
> -			/* We found a P2P bridge, check if it has a node */
> -			ppnode = pci_device_to_OF_node(ppdev);
> -
> -		/* Ok, we have found a parent with a device-node, hand over to
> -		 * the OF parsing code.
> -		 * We build a unit address from the linux device to be used for
> -		 * resolution. Note that we use the linux bus number which may
> -		 * not match your firmware bus numbering.
> -		 * Fortunately, in most cases, interrupt-map-mask doesn't include
> -		 * the bus number as part of the matching.
> -		 * You should still be careful about that though if you intend
> -		 * to rely on this function (you ship  a firmware that doesn't
> -		 * create device nodes for all PCI devices).
> -		 */
> -		if (ppnode)
> -			break;
> -
> -		/* We can only get here if we hit a P2P bridge with no node,
> -		 * let's do standard swizzling and try again
> -		 */
> -		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
> -		pdev = ppdev;
> -	}
> -
> -	laddr[0] = (pdev->bus->number << 16)
> -		| (pdev->devfn << 8);
> -	laddr[1]  = laddr[2] = 0;
> -	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
> -}
> -EXPORT_SYMBOL_GPL(of_irq_map_pci);
> -#endif /* CONFIG_PCI */
>  
>  void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
>  		unsigned long *busno, unsigned long *phys, unsigned long *size)
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 7888155..4dcb177 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_OF_GPIO)   += gpio.o
>  obj-$(CONFIG_OF_I2C)	+= of_i2c.o
>  obj-$(CONFIG_OF_SPI)	+= of_spi.o
>  obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
> +obj-$(CONFIG_PCI)	+= of_pci.o
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> new file mode 100644
> index 0000000..dd862d2
> --- /dev/null
> +++ b/drivers/of/of_pci.c
> @@ -0,0 +1,80 @@
> +#include <linux/kernel.h>
> +#include <linux/of_pci.h>
> +#include <asm/prom.h>
> +
> +int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
> +{
> +	struct device_node *dn, *ppnode;
> +	struct pci_dev *ppdev;
> +	u32 lspec;
> +	__be32 lspec_be;
> +	__be32 laddr[3];
> +	u8 pin;
> +	int rc;
> +
> +	/* Check if we have a device node, if yes, fallback to standard OF
> +	 * parsing
> +	 */
> +	dn = pci_device_to_OF_node(pdev);
> +	if (dn) {
> +		rc = of_irq_map_one(dn, 0, out_irq);
> +		if (!rc)
> +			return rc;
> +	}
> +
> +	/* Ok, we don't, time to have fun. Let's start by building up an
> +	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
> +	 * for PCI. If you do different, then don't use that routine.
> +	 */
> +	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> +	if (rc != 0)
> +		return rc;
> +	/* No pin, exit */
> +	if (pin == 0)
> +		return -ENODEV;
> +
> +	/* Now we walk up the PCI tree */
> +	lspec = pin;
> +	for (;;) {
> +		/* Get the pci_dev of our parent */
> +		ppdev = pdev->bus->self;
> +
> +		/* Ouch, it's a host bridge... */
> +		if (ppdev == NULL) {
> +			ppnode = pci_bus_to_OF_node(pdev->bus);
> +
> +			/* No node for host bridge ? give up */
> +			if (ppnode == NULL)
> +				return -EINVAL;
> +		} else {
> +			/* We found a P2P bridge, check if it has a node */
> +			ppnode = pci_device_to_OF_node(ppdev);
> +		}
> +
> +		/* Ok, we have found a parent with a device-node, hand over to
> +		 * the OF parsing code.
> +		 * We build a unit address from the linux device to be used for
> +		 * resolution. Note that we use the linux bus number which may
> +		 * not match your firmware bus numbering.
> +		 * Fortunately, in most cases, interrupt-map-mask doesn't
> +		 * include the bus number as part of the matching.
> +		 * You should still be careful about that though if you intend
> +		 * to rely on this function (you ship  a firmware that doesn't
> +		 * create device nodes for all PCI devices).
> +		 */
> +		if (ppnode)
> +			break;
> +
> +		/* We can only get here if we hit a P2P bridge with no node,
> +		 * let's do standard swizzling and try again
> +		 */
> +		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
> +		pdev = ppdev;
> +	}
> +
> +	lspec_be = cpu_to_be32(lspec);
> +	laddr[0] = cpu_to_be32((pdev->bus->number << 16) | (pdev->devfn << 8));
> +	laddr[1]  = laddr[2] = cpu_to_be32(0);
> +	return of_irq_map_raw(ppnode, &lspec_be, 1, laddr, out_irq);
> +}
> +EXPORT_SYMBOL_GPL(of_irq_map_pci);
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> new file mode 100644
> index 0000000..9b0ba67
> --- /dev/null
> +++ b/include/linux/of_pci.h
> @@ -0,0 +1,20 @@
> +#ifndef __OF_PCI_H
> +#define __OF_PCI_H
> +
> +#include <linux/pci.h>
> +
> +/**
> + * of_irq_map_pci - Resolve the interrupt for a PCI device
> + * @pdev:       the device whose interrupt is to be resolved
> + * @out_irq:    structure of_irq filled by this function
> + *
> + * This function resolves the PCI interrupt for a given PCI device. If a
> + * device-node exists for a given pci_dev, it will use normal OF tree
> + * walking. If not, it will implement standard swizzling and walk up the
> + * PCI tree until an device-node is found, at which point it will finish
> + * resolving using the OF tree walking.
> + */
> +struct pci_dev;
> +struct of_irq;
> +int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> +#endif
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
