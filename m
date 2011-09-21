Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1IURQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:16:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44634 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IURQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:16:20 -0400
Message-ID: <4E7A1BCA.1090006@ti.com>
Date: Wed, 21 Sep 2011 19:15:54 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "dave.martin@linaro.org" <dave.martin@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <1316550244-3655-4-git-send-email-robherring2@gmail.com>
In-Reply-To: <1316550244-3655-4-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

I'm testing that series with OMAP4 but have some issues for the moment :-(

[    0.000000] WARNING: at kernel/irq/irqdomain.c:34 gic_of_init+0x10c/0x180()
[    0.000000] error: irq_desc already assigned to a domain
[    0.000000] Modules linked in:
[    0.000000] [<c001b284>] (unwind_backtrace+0x0/0xf0) from [<c0051c34>] (warn_slowpath_common+0x4c/0x64)
[    0.000000] [<c0051c34>] (warn_slowpath_common+0x4c/0x64) from [<c0051ce0>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c0051ce0>] (warn_slowpath_fmt+0x30/0x40) from [<c05f6874>] (gic_of_init+0x10c/0x180)
[    0.000000] [<c05f6874>] (gic_of_init+0x10c/0x180) from [<c05fa2e0>] (omap_gic_of_init+0x8/0x28)
[    0.000000] [<c05fa2e0>] (omap_gic_of_init+0x8/0x28) from [<c0616b44>] (of_irq_init+0x148/0x28c)
[    0.000000] [<c0616b44>] (of_irq_init+0x148/0x28c) from [<c05f3074>] (init_IRQ+0x14/0x1c)
[    0.000000] [<c05f3074>] (init_IRQ+0x14/0x1c) from [<c05f0650>] (start_kernel+0x184/0x2fc)
[    0.000000] [<c05f0650>] (start_kernel+0x184/0x2fc) from [<80008040>] (0x80008040)
 
I'm not super familiar with all the irq stuff but I'm wondering if there is not something wrong with the test that print that message:

void irq_domain_add(struct irq_domain *domain)
{
	struct irq_data *d;
	int hwirq;

	/*
	 * This assumes that the irq_domain owner has already allocated
	 * the irq_descs.  This block will be removed when support for dynamic
	 * allocation of irq_descs is added to irq_domain.
	 */
	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
		if (d || d->domain) {
			/* things are broken; just report, don't clean up */
			WARN(1, "error: irq_desc already assigned to a domain");
			return;
		}
[...]

Is the (d || d->domain) correct? Shouldn't it be (d && d->domain)?

But since that used to work properly, I have some doubt. Moreover the driver will not even get the proper interrupt later...

Do you have any clue?

Thanks,
Benoit


On 9/20/2011 10:24 PM, Rob Herring wrote:
> From: Rob Herring<rob.herring@calxeda.com>
> 
> This adds ARM gic interrupt controller initialization using device tree
> data.
> 
> The initialization function is intended to be called by of_irq_init
> function like this:
> 
> const static struct of_device_id irq_match[] = {
>          { .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
>          {}
> };
> 
> static void __init init_irqs(void)
> {
>          of_irq_init(irq_match);
> }
> 
> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
> ---
>   Documentation/devicetree/bindings/arm/gic.txt |   55 +++++++++++++++
>   arch/arm/common/gic.c                         |   89 +++++++++++++++++++++++-
>   arch/arm/include/asm/hardware/gic.h           |   12 ++++
>   3 files changed, 152 insertions(+), 4 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> new file mode 100644
> index 0000000..52916b4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -0,0 +1,55 @@
> +* ARM Generic Interrupt Controller
> +
> +ARM SMP cores are often associated with a GIC, providing per processor
> +interrupts (PPI), shared processor interrupts (SPI) and software
> +generated interrupts (SGI).
> +
> +Primary GIC is attached directly to the CPU and typically has PPIs and SGIs.
> +Secondary GICs are cascaded into the upward interrupt controller and do not
> +have PPIs or SGIs.
> +
> +Main node required properties:
> +
> +- compatible : should be one of:
> +	"arm,cortex-a9-gic"
> +	"arm,arm11mp-gic"
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +  interrupt source.  The type shall be a<u32>  and the value shall be 3.
> +
> +  The 1st cell is the interrupt type; 0 for SPI interrupts, 1 for PPI
> +  interrupts.
> +
> +  The 2nd cell contains the interrupt number for the interrupt type.
> +  SPI interrupts are in the range [0-987].  PPI interrupts are in the
> +  range [0-15].
> +
> +  The 3rd cell is the flags, encoded as follows:
> +	bits[3:0] trigger type and level flags.
> +		1 = low-to-high edge triggered
> +		2 = high-to-low edge triggered
> +		4 = active high level-sensitive
> +		8 = active low level-sensitive
> +	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
> +	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
> +	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
> +
> +- reg : Specifies base physical address(s) and size of the GIC registers. The
> +  first region is the GIC distributor register base and size. The 2nd region is
> +  the GIC cpu interface register base and size.
> +
> +Optional
> +- interrupts	: Interrupt source of the parent interrupt controller. Only
> +  present on secondary GICs.
> +
> +Example:
> +
> +	intc: interrupt-controller@fff11000 {
> +		compatible = "arm,cortex-a9-gic";
> +		#interrupt-cells =<3>;
> +		#address-cells =<1>;
> +		interrupt-controller;
> +		reg =<0xfff11000 0x1000>,
> +		<0xfff10100 0x100>;
> +	};
> +
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> index 666b278..84e69a4 100644
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@ -28,6 +28,10 @@
>   #include<linux/smp.h>
>   #include<linux/cpumask.h>
>   #include<linux/io.h>
> +#include<linux/of.h>
> +#include<linux/of_address.h>
> +#include<linux/of_irq.h>
> +#include<linux/irqdomain.h>
> 
>   #include<asm/irq.h>
>   #include<asm/mach/irq.h>
> @@ -255,6 +259,15 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>   	irq_set_chained_handler(irq, gic_handle_cascade_irq);
>   }
> 
> +static int gic_irq_count(void __iomem *dist_base)
> +{
> +	int gic_irqs = readl_relaxed(dist_base + GIC_DIST_CTR)&  0x1f;
> +	gic_irqs = (gic_irqs + 1) * 32;
> +	if (gic_irqs>  1020)
> +		gic_irqs = 1020;
> +	return gic_irqs;
> +}
> +
>   static void __init gic_dist_init(struct gic_chip_data *gic,
>   	unsigned int irq_start)
>   {
> @@ -277,10 +290,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
>   	 * Find out how many interrupts are supported.
>   	 * The GIC only supports up to 1020 interrupt sources.
>   	 */
> -	gic_irqs = readl_relaxed(base + GIC_DIST_CTR)&  0x1f;
> -	gic_irqs = (gic_irqs + 1) * 32;
> -	if (gic_irqs>  1020)
> -		gic_irqs = 1020;
> +	gic_irqs = gic_irq_count(base);
> 
>   	/*
>   	 * Set all global interrupts to be level triggered, active low.
> @@ -405,3 +415,74 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>   	writel_relaxed(map<<  16 | irq, gic_data[0].dist_base + GIC_DIST_SOFTINT);
>   }
>   #endif
> +
> +#ifdef CONFIG_OF
> +static int gic_cnt __initdata = 0;
> +
> +int gic_irq_domain_dt_translate(struct irq_domain *d,
> +			    struct device_node *controller,
> +			    const u32 *intspec, unsigned int intsize,
> +			    unsigned long *out_hwirq, unsigned int *out_type)
> +{
> +	struct gic_chip_data *gic_data = d->priv;
> +
> +	if (d->of_node != controller)
> +		return -EINVAL;
> +	if (intsize<  3)
> +		return -EINVAL;
> +
> +	*out_hwirq = intspec[1];
> +	/*
> +	 * We've already skipped over SGIs, so PPIs need no translation.
> +	 * For SPIs, we need to skip over 16 PPIs on primary GICs.
> +	 */
> +	if (!intspec[0]&&  !gic_data->irq_offset)
> +		*out_hwirq += 16;
> +
> +	*out_type = intspec[2]&  IRQ_TYPE_SENSE_MASK;
> +	return 0;
> +}
> +
> +struct irq_domain_ops gic_irq_domain_ops = {
> +	.dt_translate = gic_irq_domain_dt_translate,
> +};
> +
> +int __init gic_of_init(struct device_node *node, struct device_node *parent)
> +{
> +	void __iomem *cpu_base;
> +	void __iomem *dist_base;
> +	int irq;
> +	struct irq_domain *domain =&gic_data[gic_cnt].domain;
> +
> +	if (WARN_ON(!node))
> +		return -ENODEV;
> +
> +	dist_base = of_iomap(node, 0);
> +	WARN(!dist_base, "unable to map gic dist registers\n");
> +
> +	cpu_base = of_iomap(node, 1);
> +	WARN(!cpu_base, "unable to map gic cpu registers\n");
> +
> +	domain->nr_irq = gic_irq_count(dist_base);
> +	/* subtract off SGIs. Also subtract off PPIs for secondary GICs */
> +	if (parent)
> +		domain->nr_irq -= 32;
> +	else
> +		domain->nr_irq -= 16;
> +
> +	domain->irq_base = irq_alloc_descs(-1, 16, domain->nr_irq, numa_node_id());
> +	domain->of_node = of_node_get(node);
> +	domain->ops =&gic_irq_domain_ops;
> +	domain->priv =&gic_data[gic_cnt];
> +	irq_domain_add(domain);
> +
> +	gic_init(gic_cnt, domain->irq_base, dist_base, cpu_base);
> +
> +	if (parent) {
> +		irq = irq_of_parse_and_map(node, 0);
> +		gic_cascade_irq(gic_cnt, irq);
> +	}
> +	gic_cnt++;
> +	return 0;
> +}
> +#endif
> diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
> index 435d3f8..2862d0e 100644
> --- a/arch/arm/include/asm/hardware/gic.h
> +++ b/arch/arm/include/asm/hardware/gic.h
> @@ -33,10 +33,21 @@
>   #define GIC_DIST_SOFTINT		0xf00
> 
>   #ifndef __ASSEMBLY__
> +#include<linux/irqdomain.h>
> +
>   extern void __iomem *gic_cpu_base_addr;
>   extern struct irq_chip gic_arch_extn;
> 
>   void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
> +#ifdef CONFIG_OF
> +int gic_of_init(struct device_node *node, struct device_node *parent);
> +#else
> +static inline void gic_of_init(struct device_node *node,
> +			       struct device_node *parent)
> +{
> +	return -ENODEV;
> +}
> +#endif
>   void gic_secondary_init(unsigned int);
>   void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
>   void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
> @@ -46,6 +57,7 @@ struct gic_chip_data {
>   	unsigned int irq_offset;
>   	void __iomem *dist_base;
>   	void __iomem *cpu_base;
> +	struct irq_domain domain;
>   };
>   #endif
> 

