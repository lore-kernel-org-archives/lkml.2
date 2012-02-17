Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2BQJ1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:27:21 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:24186 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2BQJ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:27:16 -0500
Message-ID: <4F3E1D38.7050404@atmel.com>
Date: Fri, 17 Feb 2012 10:26:16 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, grant.likely@secretlab.ca,
        plagnioj@jcrosoft.com, devicetree-discuss@lists.ozlabs.org
CC: linux-arm-kernel@lists.infradead.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, avictor.za@gmail.com
Subject: Re: [PATCH v5 1/9] ARM: at91/aic: add irq domain and device tree
 support
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com> <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com> <4F398A6E.8040905@gmail.com> <4F3A3678.8090706@atmel.com> <4F3A6B7B.9040406@gmail.com>
In-Reply-To: <4F3A6B7B.9040406@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 03:11 PM, Rob Herring :
> On 02/14/2012 04:24 AM, Nicolas Ferre wrote:
>> On 02/13/2012 11:10 PM, Rob Herring :
>>> On 02/13/2012 08:43 AM, Nicolas Ferre wrote:
>>>> Add an irqdomain for the AIC interrupt controller.
>>>> The device tree support is mapping the registers and
>>>> is using the irq_domain_add_legacy() to manage hwirq
>>>> translation.
>>>> The documentation is describing the meaning of the
>>>> two cells required for using this "interrupt-controller"
>>>> in a device tree node.
>>>>
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>>> ---
>>>> v5: - rebased on top of Grant's "irq_domain generalization and refinement"
>>>>       patch series
>>>>     - use of irq_domain_add_legacy() API
>>>>
>>>> v4: - use irq_alloc_descs() to find irq_base
>>>>     - add a new constant AIC_BASE_IRQ that will allow to skip
>>>>       first interrupt numbers (in the future)
>>>>
>>>> v3: - change number of cells to define an AIC interrupt (irq trigger type)
>>>>     - change current .dtsi files to match specification
>>>>     - use irq_domain_simple_ops (for DT mapping)
>>>>
>>>> v2: - use of_irq_init() function for device tree probing
>>>>     - add documentation
>>>>     - use own simple struct irq_domain_ops
>>>>
>>>>
>>>>  .../devicetree/bindings/arm/atmel-aic.txt          |   38 ++++++++++
>>>>  arch/arm/Kconfig                                   |    1 +
>>>>  arch/arm/boot/dts/at91sam9g20.dtsi                 |   18 +++---
>>>>  arch/arm/boot/dts/at91sam9g45.dtsi                 |   16 ++--
>>>>  arch/arm/mach-at91/include/mach/irqs.h             |    3 +-
>>>>  arch/arm/mach-at91/irq.c                           |   74 ++++++++++++++++----
>>>>  6 files changed, 119 insertions(+), 31 deletions(-)
>>>>  create mode 100644 Documentation/devicetree/bindings/arm/atmel-aic.txt
>>
>> [..]
>>
>>>> --- a/arch/arm/mach-at91/include/mach/irqs.h
>>>> +++ b/arch/arm/mach-at91/include/mach/irqs.h
>>>> @@ -25,6 +25,7 @@
>>>>  #include <mach/at91_aic.h>
>>>>  
>>>>  #define NR_AIC_IRQS 32
>>>> +#define AIC_BASE_IRQ 0
>>>>  
>>>>  
>>>>  /*
>>>> @@ -40,7 +41,7 @@
>>>>   * symbols in gpio.h for ones handled indirectly as GPIOs.
>>>>   * We make provision for 5 banks of GPIO.
>>>>   */
>>>> -#define	NR_IRQS		(NR_AIC_IRQS + (5 * 32))
>>>> +#define	NR_IRQS		(AIC_BASE_IRQ + NR_AIC_IRQS + (5 * 32))
>>>
>>> Why? You're not changing anything.
>>>
>>> You should turn on SPARSE_IRQ at some point and then this value goes away.
>>
>> Yes, my intention is to move to this step by step. I have tried hard to
>> rework completely the AIC driver without success so far. I plan:
>> - move the AIC_BASE_IRQ away from irq0
>>   => this is why I introduce a constant here
>> - use SPARSE_IRQ
>> - move to generic irq & irq domain helpers (move DT case to "linear")
>>
>> *once* the code for handling all this is stabilized and integrated in
>> mainline.
>>
>> This rework is designed for 3.4 and a lot of code depend on this for all
>> our at91 DT move.
> 
> In that case, NR_IRQS will be removed. You will get the default of 16
> (NR_LEGACY_IRQS) and they will get reserved so irq_alloc_descs will skip
> over them. So there is no reason for you to have AIC_BASE_IRQ.

Fair enough, that indeed makes a lot of sense: I remove it.

>>>>  /* FIQ is AIC source 0. */
>>>>  #define FIQ_START AT91_ID_FIQ
>>>> diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
>>>> index be6b639..880da98 100644
>>>> --- a/arch/arm/mach-at91/irq.c
>>>> +++ b/arch/arm/mach-at91/irq.c
>>>> @@ -24,6 +24,12 @@
>>>>  #include <linux/module.h>
>>>>  #include <linux/mm.h>
>>>>  #include <linux/types.h>
>>>> +#include <linux/irq.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/of_address.h>
>>>> +#include <linux/of_irq.h>
>>>> +#include <linux/irqdomain.h>
>>>> +#include <linux/err.h>
>>>>  
>>>>  #include <mach/hardware.h>
>>>>  #include <asm/irq.h>
>>>> @@ -34,22 +40,24 @@
>>>>  #include <asm/mach/map.h>
>>>>  
>>>>  void __iomem *at91_aic_base;
>>>> +static struct irq_domain *at91_aic_domain;
>>>> +static struct device_node *at91_aic_np;
>>>>  
>>>>  static void at91_aic_mask_irq(struct irq_data *d)
>>>>  {
>>>>  	/* Disable interrupt on AIC */
>>>> -	at91_aic_write(AT91_AIC_IDCR, 1 << d->irq);
>>>> +	at91_aic_write(AT91_AIC_IDCR, 1 << d->hwirq);
>>>>  }
>>>>  
>>>>  static void at91_aic_unmask_irq(struct irq_data *d)
>>>>  {
>>>>  	/* Enable interrupt on AIC */
>>>> -	at91_aic_write(AT91_AIC_IECR, 1 << d->irq);
>>>> +	at91_aic_write(AT91_AIC_IECR, 1 << d->hwirq);
>>>>  }
>>>>  
>>>>  unsigned int at91_extern_irq;
>>>>  
>>>> -#define is_extern_irq(irq) ((1 << (irq)) & at91_extern_irq)
>>>> +#define is_extern_irq(hwirq) ((1 << (hwirq)) & at91_extern_irq)
>>>>  
>>>>  static int at91_aic_set_type(struct irq_data *d, unsigned type)
>>>>  {
>>>> @@ -63,13 +71,13 @@ static int at91_aic_set_type(struct irq_data *d, unsigned type)
>>>>  		srctype = AT91_AIC_SRCTYPE_RISING;
>>>>  		break;
>>>>  	case IRQ_TYPE_LEVEL_LOW:
>>>> -		if ((d->irq == AT91_ID_FIQ) || is_extern_irq(d->irq))		/* only supported on external interrupts */
>>>> +		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
>>>>  			srctype = AT91_AIC_SRCTYPE_LOW;
>>>>  		else
>>>>  			return -EINVAL;
>>>>  		break;
>>>>  	case IRQ_TYPE_EDGE_FALLING:
>>>> -		if ((d->irq == AT91_ID_FIQ) || is_extern_irq(d->irq))		/* only supported on external interrupts */
>>>> +		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
>>>>  			srctype = AT91_AIC_SRCTYPE_FALLING;
>>>>  		else
>>>>  			return -EINVAL;
>>>> @@ -78,8 +86,8 @@ static int at91_aic_set_type(struct irq_data *d, unsigned type)
>>>>  		return -EINVAL;
>>>>  	}
>>>>  
>>>> -	smr = at91_aic_read(AT91_AIC_SMR(d->irq)) & ~AT91_AIC_SRCTYPE;
>>>> -	at91_aic_write(AT91_AIC_SMR(d->irq), smr | srctype);
>>>> +	smr = at91_aic_read(AT91_AIC_SMR(d->hwirq)) & ~AT91_AIC_SRCTYPE;
>>>> +	at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -90,13 +98,13 @@ static u32 backups;
>>>>  
>>>>  static int at91_aic_set_wake(struct irq_data *d, unsigned value)
>>>>  {
>>>> -	if (unlikely(d->irq >= 32))
>>>> +	if (unlikely(d->hwirq >= NR_AIC_IRQS))
>>>>  		return -EINVAL;
>>>>  
>>>>  	if (value)
>>>> -		wakeups |= (1 << d->irq);
>>>> +		wakeups |= (1 << d->hwirq);
>>>>  	else
>>>> -		wakeups &= ~(1 << d->irq);
>>>> +		wakeups &= ~(1 << d->hwirq);
>>>>  
>>>>  	return 0;
>>>>  }
>>>> @@ -127,24 +135,64 @@ static struct irq_chip at91_aic_chip = {
>>>>  	.irq_set_wake	= at91_aic_set_wake,
>>>>  };
>>>>  
>>>> +#if defined(CONFIG_OF)
>>>> +static int __init __at91_aic_of_init(struct device_node *node,
>>>> +				     struct device_node *parent)
>>>> +{
>>>> +	at91_aic_base = of_iomap(node, 0);
>>>> +	at91_aic_np = node;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct of_device_id aic_ids[] __initconst = {
>>>> +	{ .compatible = "atmel,at91rm9200-aic", .data = __at91_aic_of_init },
>>>> +	{ /*sentinel*/ }
>>>> +};
>>>> +
>>>> +static void __init at91_aic_of_init(void)
>>>> +{
>>>> +	of_irq_init(aic_ids);
>>>
>>> This call and match str belongs in your board file (init_irq function)
>>> and you should be doing all setup in __at91_aic_of_init.
>>
>> It has already been discussed here:
>> http://article.gmane.org/gmane.linux.drivers.devicetree/9834
>>
>> I feel that this self-contained driver is the best solution for the
>> moment. Once the priorities will be encoded in the device tree (and
>> moreover once they will be useful for threaded interrupts), we may
>> re-consider this.
>>
> 
> Can you setup the priorities after init with a separate function? Then
> you can follow standard init flow and afterwards set the priorities.
> 
> BTW, We're probably going to start moving irqchips to a common
> drivers/irqchips. So it's important that init flow be consistent with
> other irqchips.

That is indeed a strong argument.

I have made a bit of renewal of the initialization process which should
now match the standard flow. I post real-soon-now an additional patch
that goes on top of this series to address your advice.

In this new patch, the priorities are not managed at the moment but we
plan to use a "default" priority table which will be part of the AIC
node and, as you suggested, an additional optional cell in the
"interrupts" property itself.
Before implementing this, I would like to have your feedback on the
whole series (together with its brand-new additional patch).


>>>> +}
>>>> +#else
>>>> +static void __init at91_aic_of_init(void) {}
>>>> +#endif
>>>> +
>>>>  /*
>>>>   * Initialize the AIC interrupt controller.
>>>>   */
>>>>  void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
>>>
>>> Perhaps the priority should be a cell in your interrupts property?
>>
>> Yes, it is a good idea. But that will prevent me from using a standard
>> irq_domain simple xlate operation... Maybe we can think about this a bit
>> more and implement it in the future.
> 
> That's not a good argument. What Linux has or doesn't have should not
> really influence your binding. What is the right thing to do?
> 
> You can put the priority into the upper half word of cell 2. The trigger
> type is masked. But you would still need a custom translate function to
> extract the priority and set it.
> 
> You could perhaps just put all the priorities as a property of the
> interrupt controller node. Then you don't have to increase the cell size.

Thank you for your thoughts about this: I will implement it soon (Cf.
above).


>>>>  {
>>>>  	unsigned int i;
>>>> +	int irq_base;
>>>>  
>>>> -	at91_aic_base = ioremap(AT91_AIC, 512);
>>>> +	if (of_have_populated_dt())
>>>> +		at91_aic_of_init();
>>>
>>> You should get to this point because of_irq_init called you and you
>>> should already have a node ptr at point.
>>>
>>>> +	else
>>>> +		at91_aic_base = ioremap(AT91_AIC, 512);
>>>>  
>>>>  	if (!at91_aic_base)
>>>> -		panic("Impossible to ioremap AT91_AIC\n");
>>>> +		panic("Unable to ioremap AIC registers\n");
>>>> +
>>>> +	/* Add irq domain for AIC */
>>>> +	irq_base = irq_alloc_descs(-1, AIC_BASE_IRQ, NR_AIC_IRQS, 0);
>>>
>>> Really, you don't want to use irq0, but that would break your irq entry
>>> code.
>>
>> Exactly. I have the code for switching to MULTI_IRQ_HANDLER ready. But
>> that will require a little modification of each board file. This
>> scattered modification is maybe a bit late for 3.4 inclusion...
>>
> 
> Okay. It's fine for now. Just making sure you're aware of the issue.
> 
> Rob
> 

Best regards,
-- 
Nicolas Ferre
