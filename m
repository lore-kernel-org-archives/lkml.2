Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0L3JFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 04:05:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0L3JFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 04:05:48 -0500
Date: Thu, 30 Dec 2010 02:05:45 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 12/15] of/address: use propper endianess in get_flags
Message-ID: <20101230090545.GH11721@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-13-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-13-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:50PM +0100, Sebastian Andrzej Siewior wrote:
> This patch changes u32 to __be32 for all "ranges", "prop" and "addr" and
> such. Those variables are pointing to the device tree which containts
> intergers in big endian format.
> Most functions are doing it right because they are using using
> of_read_number() which is doing the right thing. of_bus_isa_get_flags(),
> of_bus_pci_get_flags() and of_bus_isa_map() were accessing the data
> directly and were doing it wrong.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This one is already applied to my next-devicetree branch

g.

> ---
>  arch/powerpc/include/asm/prom.h |    2 +-
>  drivers/of/address.c            |   54 ++++++++++++++++++++------------------
>  include/linux/of_address.h      |    6 ++--
>  3 files changed, 32 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index 01c3302..b891fdc 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -42,7 +42,7 @@ extern void pci_create_OF_bus_map(void);
>  
>  /* Translate a DMA address from device space to CPU space */
>  extern u64 of_translate_dma_address(struct device_node *dev,
> -				    const u32 *in_addr);
> +				    const __be32 *in_addr);
>  
>  #ifdef CONFIG_PCI
>  extern unsigned long pci_address_to_pio(phys_addr_t address);
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 3a1c7e7..b4559c5 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -12,13 +12,13 @@
>  			(ns) > 0)
>  
>  static struct of_bus *of_match_bus(struct device_node *np);
> -static int __of_address_to_resource(struct device_node *dev, const u32 *addrp,
> -				    u64 size, unsigned int flags,
> +static int __of_address_to_resource(struct device_node *dev,
> +		const __be32 *addrp, u64 size, unsigned int flags,
>  				    struct resource *r);
>  
>  /* Debug utility */
>  #ifdef DEBUG
> -static void of_dump_addr(const char *s, const u32 *addr, int na)
> +static void of_dump_addr(const char *s, const __be32 *addr, int na)
>  {
>  	printk(KERN_DEBUG "%s", s);
>  	while (na--)
> @@ -26,7 +26,7 @@ static void of_dump_addr(const char *s, const u32 *addr, int na)
>  	printk("\n");
>  }
>  #else
> -static void of_dump_addr(const char *s, const u32 *addr, int na) { }
> +static void of_dump_addr(const char *s, const __be32 *addr, int na) { }
>  #endif
>  
>  /* Callbacks for bus specific translators */
> @@ -36,10 +36,10 @@ struct of_bus {
>  	int		(*match)(struct device_node *parent);
>  	void		(*count_cells)(struct device_node *child,
>  				       int *addrc, int *sizec);
> -	u64		(*map)(u32 *addr, const u32 *range,
> +	u64		(*map)(u32 *addr, const __be32 *range,
>  				int na, int ns, int pna);
>  	int		(*translate)(u32 *addr, u64 offset, int na);
> -	unsigned int	(*get_flags)(const u32 *addr);
> +	unsigned int	(*get_flags)(const __be32 *addr);
>  };
>  
>  /*
> @@ -55,7 +55,7 @@ static void of_bus_default_count_cells(struct device_node *dev,
>  		*sizec = of_n_size_cells(dev);
>  }
>  
> -static u64 of_bus_default_map(u32 *addr, const u32 *range,
> +static u64 of_bus_default_map(u32 *addr, const __be32 *range,
>  		int na, int ns, int pna)
>  {
>  	u64 cp, s, da;
> @@ -85,7 +85,7 @@ static int of_bus_default_translate(u32 *addr, u64 offset, int na)
>  	return 0;
>  }
>  
> -static unsigned int of_bus_default_get_flags(const u32 *addr)
> +static unsigned int of_bus_default_get_flags(const __be32 *addr)
>  {
>  	return IORESOURCE_MEM;
>  }
> @@ -110,10 +110,10 @@ static void of_bus_pci_count_cells(struct device_node *np,
>  		*sizec = 2;
>  }
>  
> -static unsigned int of_bus_pci_get_flags(const u32 *addr)
> +static unsigned int of_bus_pci_get_flags(const __be32 *addr)
>  {
>  	unsigned int flags = 0;
> -	u32 w = addr[0];
> +	u32 w = be32_to_cpup(addr);
>  
>  	switch((w >> 24) & 0x03) {
>  	case 0x01:
> @@ -129,7 +129,8 @@ static unsigned int of_bus_pci_get_flags(const u32 *addr)
>  	return flags;
>  }
>  
> -static u64 of_bus_pci_map(u32 *addr, const u32 *range, int na, int ns, int pna)
> +static u64 of_bus_pci_map(u32 *addr, const __be32 *range, int na, int ns,
> +		int pna)
>  {
>  	u64 cp, s, da;
>  	unsigned int af, rf;
> @@ -160,7 +161,7 @@ static int of_bus_pci_translate(u32 *addr, u64 offset, int na)
>  	return of_bus_default_translate(addr + 1, offset, na - 1);
>  }
>  
> -const u32 *of_get_pci_address(struct device_node *dev, int bar_no, u64 *size,
> +const __be32 *of_get_pci_address(struct device_node *dev, int bar_no, u64 *size,
>  			unsigned int *flags)
>  {
>  	const __be32 *prop;
> @@ -207,7 +208,7 @@ EXPORT_SYMBOL(of_get_pci_address);
>  int of_pci_address_to_resource(struct device_node *dev, int bar,
>  			       struct resource *r)
>  {
> -	const u32	*addrp;
> +	const __be32	*addrp;
>  	u64		size;
>  	unsigned int	flags;
>  
> @@ -237,12 +238,13 @@ static void of_bus_isa_count_cells(struct device_node *child,
>  		*sizec = 1;
>  }
>  
> -static u64 of_bus_isa_map(u32 *addr, const u32 *range, int na, int ns, int pna)
> +static u64 of_bus_isa_map(u32 *addr, const __be32 *range, int na, int ns,
> +		int pna)
>  {
>  	u64 cp, s, da;
>  
>  	/* Check address type match */
> -	if ((addr[0] ^ range[0]) & 0x00000001)
> +	if ((addr[0] ^ range[0]) & cpu_to_be32(1))
>  		return OF_BAD_ADDR;
>  
>  	/* Read address values, skipping high cell */
> @@ -264,10 +266,10 @@ static int of_bus_isa_translate(u32 *addr, u64 offset, int na)
>  	return of_bus_default_translate(addr + 1, offset, na - 1);
>  }
>  
> -static unsigned int of_bus_isa_get_flags(const u32 *addr)
> +static unsigned int of_bus_isa_get_flags(const __be32 *addr)
>  {
>  	unsigned int flags = 0;
> -	u32 w = addr[0];
> +	u32 w = be32_to_cpup(addr);
>  
>  	if (w & 1)
>  		flags |= IORESOURCE_IO;
> @@ -330,7 +332,7 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>  			    struct of_bus *pbus, u32 *addr,
>  			    int na, int ns, int pna, const char *rprop)
>  {
> -	const u32 *ranges;
> +	const __be32 *ranges;
>  	unsigned int rlen;
>  	int rone;
>  	u64 offset = OF_BAD_ADDR;
> @@ -398,7 +400,7 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>   * that can be mapped to a cpu physical address). This is not really specified
>   * that way, but this is traditionally the way IBM at least do things
>   */
> -u64 __of_translate_address(struct device_node *dev, const u32 *in_addr,
> +u64 __of_translate_address(struct device_node *dev, const __be32 *in_addr,
>  			   const char *rprop)
>  {
>  	struct device_node *parent = NULL;
> @@ -475,22 +477,22 @@ u64 __of_translate_address(struct device_node *dev, const u32 *in_addr,
>  	return result;
>  }
>  
> -u64 of_translate_address(struct device_node *dev, const u32 *in_addr)
> +u64 of_translate_address(struct device_node *dev, const __be32 *in_addr)
>  {
>  	return __of_translate_address(dev, in_addr, "ranges");
>  }
>  EXPORT_SYMBOL(of_translate_address);
>  
> -u64 of_translate_dma_address(struct device_node *dev, const u32 *in_addr)
> +u64 of_translate_dma_address(struct device_node *dev, const __be32 *in_addr)
>  {
>  	return __of_translate_address(dev, in_addr, "dma-ranges");
>  }
>  EXPORT_SYMBOL(of_translate_dma_address);
>  
> -const u32 *of_get_address(struct device_node *dev, int index, u64 *size,
> +const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
>  		    unsigned int *flags)
>  {
> -	const u32 *prop;
> +	const __be32 *prop;
>  	unsigned int psize;
>  	struct device_node *parent;
>  	struct of_bus *bus;
> @@ -525,8 +527,8 @@ const u32 *of_get_address(struct device_node *dev, int index, u64 *size,
>  }
>  EXPORT_SYMBOL(of_get_address);
>  
> -static int __of_address_to_resource(struct device_node *dev, const u32 *addrp,
> -				    u64 size, unsigned int flags,
> +static int __of_address_to_resource(struct device_node *dev,
> +		const __be32 *addrp, u64 size, unsigned int flags,
>  				    struct resource *r)
>  {
>  	u64 taddr;
> @@ -564,7 +566,7 @@ static int __of_address_to_resource(struct device_node *dev, const u32 *addrp,
>  int of_address_to_resource(struct device_node *dev, int index,
>  			   struct resource *r)
>  {
> -	const u32	*addrp;
> +	const __be32	*addrp;
>  	u64		size;
>  	unsigned int	flags;
>  
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 8aea06f..2feda6e 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -3,7 +3,7 @@
>  #include <linux/ioport.h>
>  #include <linux/of.h>
>  
> -extern u64 of_translate_address(struct device_node *np, const u32 *addr);
> +extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
>  extern int of_address_to_resource(struct device_node *dev, int index,
>  				  struct resource *r);
>  extern void __iomem *of_iomap(struct device_node *device, int index);
> @@ -21,7 +21,7 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
>  #endif
>  
>  #ifdef CONFIG_PCI
> -extern const u32 *of_get_pci_address(struct device_node *dev, int bar_no,
> +extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
>  			       u64 *size, unsigned int *flags);
>  extern int of_pci_address_to_resource(struct device_node *dev, int bar,
>  				      struct resource *r);
> @@ -32,7 +32,7 @@ static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
>  	return -ENOSYS;
>  }
>  
> -static inline const u32 *of_get_pci_address(struct device_node *dev,
> +static inline const __be32 *of_get_pci_address(struct device_node *dev,
>  		int bar_no, u64 *size, unsigned int *flags)
>  {
>  	return NULL;
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
