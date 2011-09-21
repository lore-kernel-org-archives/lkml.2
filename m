Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab1IUByo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 21:54:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37706 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1IUBym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 21:54:42 -0400
Message-ID: <4E7943DE.3040700@gmail.com>
Date: Tue, 20 Sep 2011 20:54:38 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, dave.martin@linaro.org, linux@arm.linux.org.uk,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <1316550244-3655-4-git-send-email-robherring2@gmail.com> <20110920230800.GS7781@ponder.secretlab.ca>
In-Reply-To: <20110920230800.GS7781@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 06:08 PM, Grant Likely wrote:
> On Tue, Sep 20, 2011 at 03:24:04PM -0500, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> This adds ARM gic interrupt controller initialization using device tree
>> data.
>>
>> The initialization function is intended to be called by of_irq_init
>> function like this:
>>
>> const static struct of_device_id irq_match[] = {
>>         { .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
>>         {}
>> };
>>
>> static void __init init_irqs(void)
>> {
>>         of_irq_init(irq_match);
>> }
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  Documentation/devicetree/bindings/arm/gic.txt |   55 +++++++++++++++
>>  arch/arm/common/gic.c                         |   89 +++++++++++++++++++++++-
>>  arch/arm/include/asm/hardware/gic.h           |   12 ++++
>>  3 files changed, 152 insertions(+), 4 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>> new file mode 100644
>> index 0000000..52916b4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>> @@ -0,0 +1,55 @@
>> +* ARM Generic Interrupt Controller
>> +
>> +ARM SMP cores are often associated with a GIC, providing per processor
>> +interrupts (PPI), shared processor interrupts (SPI) and software
>> +generated interrupts (SGI).
>> +
>> +Primary GIC is attached directly to the CPU and typically has PPIs and SGIs.
>> +Secondary GICs are cascaded into the upward interrupt controller and do not
>> +have PPIs or SGIs.
>> +
>> +Main node required properties:
>> +
>> +- compatible : should be one of:
>> +	"arm,cortex-a9-gic"
>> +	"arm,arm11mp-gic"
>> +- interrupt-controller : Identifies the node as an interrupt controller
>> +- #interrupt-cells : Specifies the number of cells needed to encode an
>> +  interrupt source.  The type shall be a <u32> and the value shall be 3.
>> +
>> +  The 1st cell is the interrupt type; 0 for SPI interrupts, 1 for PPI
>> +  interrupts.
>> +
>> +  The 2nd cell contains the interrupt number for the interrupt type.
>> +  SPI interrupts are in the range [0-987].  PPI interrupts are in the
>> +  range [0-15].
>> +
>> +  The 3rd cell is the flags, encoded as follows:
>> +	bits[3:0] trigger type and level flags.
>> +		1 = low-to-high edge triggered
>> +		2 = high-to-low edge triggered
>> +		4 = active high level-sensitive
>> +		8 = active low level-sensitive
>> +	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
>> +	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
>> +	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
>> +
>> +- reg : Specifies base physical address(s) and size of the GIC registers. The
>> +  first region is the GIC distributor register base and size. The 2nd region is
>> +  the GIC cpu interface register base and size.
>> +
>> +Optional
>> +- interrupts	: Interrupt source of the parent interrupt controller. Only
>> +  present on secondary GICs.
>> +
>> +Example:
>> +
>> +	intc: interrupt-controller@fff11000 {
>> +		compatible = "arm,cortex-a9-gic";
>> +		#interrupt-cells = <3>;
>> +		#address-cells = <1>;
>> +		interrupt-controller;
>> +		reg = <0xfff11000 0x1000>,
>> +		      <0xfff10100 0x100>;
>> +	};
>> +
> 
> Ack on the binding.
> 
>> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
>> index 666b278..84e69a4 100644
>> --- a/arch/arm/common/gic.c
>> +++ b/arch/arm/common/gic.c
>> @@ -28,6 +28,10 @@
>>  #include <linux/smp.h>
>>  #include <linux/cpumask.h>
>>  #include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/irqdomain.h>
>>  
>>  #include <asm/irq.h>
>>  #include <asm/mach/irq.h>
>> @@ -255,6 +259,15 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>>  	irq_set_chained_handler(irq, gic_handle_cascade_irq);
>>  }
>>  
>> +static int gic_irq_count(void __iomem *dist_base)
>> +{
>> +	int gic_irqs = readl_relaxed(dist_base + GIC_DIST_CTR) & 0x1f;
>> +	gic_irqs = (gic_irqs + 1) * 32;
>> +	if (gic_irqs > 1020)
>> +		gic_irqs = 1020;
>> +	return gic_irqs;
>> +}
>> +
>>  static void __init gic_dist_init(struct gic_chip_data *gic,
>>  	unsigned int irq_start)
>>  {
>> @@ -277,10 +290,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
>>  	 * Find out how many interrupts are supported.
>>  	 * The GIC only supports up to 1020 interrupt sources.
>>  	 */
>> -	gic_irqs = readl_relaxed(base + GIC_DIST_CTR) & 0x1f;
>> -	gic_irqs = (gic_irqs + 1) * 32;
>> -	if (gic_irqs > 1020)
>> -		gic_irqs = 1020;
>> +	gic_irqs = gic_irq_count(base);
>>  
>>  	/*
>>  	 * Set all global interrupts to be level triggered, active low.
>> @@ -405,3 +415,74 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>  	writel_relaxed(map << 16 | irq, gic_data[0].dist_base + GIC_DIST_SOFTINT);
>>  }
>>  #endif
>> +
>> +#ifdef CONFIG_OF
>> +static int gic_cnt __initdata = 0;
>> +
>> +int gic_irq_domain_dt_translate(struct irq_domain *d,
>> +			    struct device_node *controller,
>> +			    const u32 *intspec, unsigned int intsize,
>> +			    unsigned long *out_hwirq, unsigned int *out_type)
>> +{
>> +	struct gic_chip_data *gic_data = d->priv;
>> +
>> +	if (d->of_node != controller)
>> +		return -EINVAL;
>> +	if (intsize < 3)
>> +		return -EINVAL;
>> +
>> +	*out_hwirq = intspec[1];
>> +	/*
>> +	 * We've already skipped over SGIs, so PPIs need no translation.
>> +	 * For SPIs, we need to skip over 16 PPIs on primary GICs.
>> +	 */
>> +	if (!intspec[0] && !gic_data->irq_offset)
>> +		*out_hwirq += 16;
> 
> I though that the offset was 32 to get from SPI number to Interrrupt
> ID?  And that PPI interrupts start at Interrupt ID 16?  Or am I
> mistaken about the hwirq number that this driver uses internally?
> 

There's basically 2 cases to handle: primary and secondary controllers.

For primary ctrlrs, the domain irq_base is already 16 to skip over SGIs
and legacy ISA interrupts. So PPIs don't need any conversion and SPIs
only need 16 more added. I misspoke previously as it's not quite
independent of virq numbering because entry-macro-gic.S is still fixed
GIC ID = Linux virq (or offset of 32 in Exynos case).

For secondary ctrlrs, the gic code already accounts for 32 offset in ID
to Linux virq with the irq_offset field which is set to Linux virq base
- 32. So in this case, no conversion is needed.

I don't really see a better way without breaking non-DT use of the gic.

Rob
