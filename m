Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1BPWEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:04:34 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59181 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1BPWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:04:33 -0500
Date: Wed, 16 Feb 2011 15:04:28 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH TIP 10/14] x86/ioapic: Add OF bindings for IO-APIC
Message-ID: <20110216220428.GG22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-11-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295843342-1122-11-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:58:58AM +0530, Sebastian Andrzej Siewior wrote:
> ioapic_xlate provides a translation from the information in device tree
> to ioapic related informations. This includes
> - obtaining hw irq which is the vector number "=> pin number + gsi"
> - obtaining type (level/edge/..)
> - programming this information into ioapic
> 
> ioapic_add_ofnode adds an irq_domain based on informations from the device
> tree. This information (irq_domain) is required in order to map a device to
> its proper interrupt controller.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Looks fine to me.

g.

> ---
>  arch/x86/include/asm/io_apic.h |    7 +++
>  arch/x86/include/asm/prom.h    |    2 +
>  arch/x86/kernel/apic/io_apic.c |   99 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/irqinit.c      |    6 ++
>  arch/x86/kernel/prom.c         |   15 ++++++
>  5 files changed, 129 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index f327d38..5a8b950 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -177,6 +177,13 @@ struct mp_ioapic_gsi{
>  	u32 gsi_base;
>  	u32 gsi_end;
>  };
> +#ifdef CONFIG_X86_OF
> +struct mp_of_ioapic {
> +	struct device_node *node;
> +};
> +extern struct mp_of_ioapic mp_of_ioapic[MAX_IO_APICS];
> +void __init ioapic_add_ofnode(struct device_node *np);
> +#endif
>  extern struct mp_ioapic_gsi  mp_gsi_routing[];
>  extern u32 gsi_top;
>  int mp_find_ioapic(u32 gsi);
> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
> index 3ed0bd6..eea2839 100644
> --- a/arch/x86/include/asm/prom.h
> +++ b/arch/x86/include/asm/prom.h
> @@ -26,6 +26,7 @@
>  extern int of_ioapic;
>  extern u64 initial_dtb;
>  extern void add_dtb(u64 data);
> +extern void x86_add_irq_domains(void);
>  void x86_dtb_find_config(void);
>  void x86_dtb_get_config(unsigned int unused);
>  void add_interrupt_host(struct irq_domain *ih);
> @@ -46,6 +47,7 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
>  
>  #else
>  static inline void add_dtb(u64 data) { }
> +static inline void x86_add_irq_domains(void) { }
>  static inline void x86_of_pci_init(void) { }
>  #define x86_dtb_find_config x86_init_noop
>  #define x86_dtb_get_config x86_init_uint_noop
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 697dc34..be7417f 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -43,6 +43,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/dmar.h>
>  #include <linux/hpet.h>
> +#include <linux/of_address.h>
>  
>  #include <asm/idle.h>
>  #include <asm/io.h>
> @@ -60,6 +61,7 @@
>  #include <asm/irq_remapping.h>
>  #include <asm/hpet.h>
>  #include <asm/hw_irq.h>
> +#include <asm/irq_controller.h>
>  
>  #include <asm/apic.h>
>  
> @@ -88,6 +90,10 @@ int nr_ioapics;
>  /* IO APIC gsi routing info */
>  struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
>  
> +#ifdef CONFIG_X86_OF
> +/* OF -> IO APIC lookup */
> +struct mp_of_ioapic mp_of_ioapic[MAX_IO_APICS];
> +#endif
>  /* The one past the highest gsi number used */
>  u32 gsi_top;
>  
> @@ -4080,6 +4086,99 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
>  	nr_ioapics++;
>  }
>  
> +#ifdef CONFIG_X86_OF
> +static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
> +		u32 *out_hwirq, u32 *out_type)
> +{
> +	u32 line;
> +	u32 idx;
> +	u32 type;
> +	u32 trigger;
> +	u32 polarity;
> +	struct irq_cfg *cfg;
> +	struct irq_desc *desc;
> +
> +	if (intsize < 1)
> +		return -EINVAL;
> +
> +	line = *intspec;
> +	idx = (u32) id->priv;
> +	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
> +	if (intsize > 1) {
> +		intspec++;
> +		type = *intspec;
> +		switch (type) {
> +		case 0:
> +			*out_type = IRQ_TYPE_EDGE_RISING;
> +			trigger = IOAPIC_EDGE;
> +			polarity = 1;
> +			break;
> +		case 1:
> +			*out_type = IRQ_TYPE_LEVEL_LOW;
> +			trigger = IOAPIC_LEVEL;
> +			polarity = 0;
> +			break;
> +		case 2:
> +			*out_type = IRQ_TYPE_LEVEL_HIGH;
> +			trigger = IOAPIC_LEVEL;
> +			polarity = 1;
> +			break;
> +		case 3:
> +			*out_type = IRQ_TYPE_EDGE_FALLING;
> +			trigger = IOAPIC_EDGE;
> +			polarity = 0;
> +			break;
> +		default:
> +			*out_type = IRQ_TYPE_NONE;
> +			trigger = IOAPIC_AUTO;
> +			polarity = 0;
> +			break;
> +		};
> +	} else {
> +		*out_type = IRQ_TYPE_NONE;
> +		trigger = IOAPIC_AUTO;
> +		polarity = 0;
> +	}
> +	/* And now tell the IO APIC to make the line ready */
> +	desc = irq_to_desc_alloc_node(*out_hwirq, 0);
> +	cfg = irq_cfg(*out_hwirq);
> +	add_pin_to_irq_node(cfg, 0, idx, line);
> +	/* make it edge by default, settype will update it */
> +	setup_ioapic_irq(idx, line, *out_hwirq, cfg, trigger, polarity);
> +	return 0;
> +}
> +
> +void __init ioapic_add_ofnode(struct device_node *np)
> +{
> +	int i;
> +	int ret;
> +	struct resource r;
> +
> +	ret = of_address_to_resource(np, 0, &r);
> +	if (ret) {
> +		printk(KERN_ERR "Failed to obtain address for %s\n",
> +				np->full_name);
> +		return;
> +	}
> +
> +	for (i = 0; i < nr_ioapics; i++) {
> +		if (r.start == mp_ioapics[i].apicaddr) {
> +			struct irq_domain *id;
> +
> +			mp_of_ioapic[i].node = np;
> +			id = kzalloc(sizeof(*id), GFP_KERNEL);
> +			BUG_ON(!id);
> +			id->controller = np;
> +			id->xlate = ioapic_xlate;
> +			id->priv = (void *)i;
> +			add_interrupt_host(id);
> +			return;
> +		}
> +	}
> +	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
> +}
> +#endif
> +
>  /* Enable IOAPIC early just for system timer */
>  void __init pre_init_apic_IRQ0(void)
>  {
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index 4cadf86..9f76f89 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -119,6 +119,12 @@ void __init init_IRQ(void)
>  	int i;
>  
>  	/*
> +	 * We probably need a better place for this, but it works for
> +	 * now ...
> +	 */
> +	x86_add_irq_domains();
> +
> +	/*
>  	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
>  	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
>  	 * then this configuration will likely be static after the boot. If
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> index 8215e8a..83ab00a 100644
> --- a/arch/x86/kernel/prom.c
> +++ b/arch/x86/kernel/prom.c
> @@ -11,9 +11,11 @@
>  #include <linux/slab.h>
>  #include <linux/pci.h>
>  #include <linux/of_pci.h>
> +#include <linux/of_fdt.h>
>  
>  #include <asm/hpet.h>
>  #include <asm/irq_controller.h>
> +#include <asm/apic.h>
>  #include <asm/io_apic.h>
>  #include <asm/pci_x86.h>
>  
> @@ -320,3 +322,16 @@ void __init x86_dtb_get_config(unsigned int unused)
>  	dtb_setup_hpet();
>  	dtb_apic_setup();
>  }
> +
> +void __init x86_add_irq_domains(void)
> +{
> +	struct device_node *dp;
> +
> +	if (!initial_boot_params)
> +		return;
> +
> +	for_each_node_with_property(dp, "interrupt-controller") {
> +		if (of_device_is_compatible(dp, "intel,ioapic"))
> +			ioapic_add_ofnode(dp);
> +	}
> +}
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
