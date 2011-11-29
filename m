Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab1K2OE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:04:26 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:9306 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab1K2OEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:04:25 -0500
Message-ID: <4ED4E4A7.80603@atmel.com>
Date: Tue, 29 Nov 2011 14:56:55 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/3] ARM: at91/aic: add device tree support for AIC
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com> <20111124222601.GA28582@gallagher> <20111125135106.GN15531@game.jcrosoft.org> <20111125152817.GA8866@totoro> <4ED4D858.40506@atmel.com>
In-Reply-To: <4ED4D858.40506@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 02:04 PM, Nicolas Ferre :
> On 11/25/2011 04:28 PM, Jamie Iles :
>> On Fri, Nov 25, 2011 at 02:51:06PM +0100, Jean-Christophe
>> PLAGNIOL-VILLARD wrote:
>>> On 22:26 Thu 24 Nov , Jamie Iles wrote:
>>>> Hi Nicolas,
>>>> On Thu, Nov 24, 2011 at 10:56:27PM +0100, Nicolas Ferre wrote:
>> [...]
>>>>> +#if defined(CONFIG_OF)
>>>>> +static struct of_device_id aic_ids[] = {
>>>>> + { .compatible = "atmel,at91rm9200-aic" },
>>>>> + { /*sentinel*/ }
>>>>> +};
>>>>> +
>>>>> +static int __init at91_aic_of_init(void)
>>>>> +{
>>>>> + struct device_node *np;
>>>>> +
>>>>> + np = of_find_matching_node(NULL, aic_ids);
>>>>> + if (np == NULL)
>>>>> + return -ENODEV;
>>>>> +
>>>>> + at91_aic_base = of_iomap(np, 0);
>>>>> + at91_aic_domain.of_node = np;
>>>>
>>>> I think this needs to be:
>>>>
>>>> at91_aic_domain.of_node = of_node_get(np);
>>>>
>>>> to keep the reference count.
>
> Well, in fact the of_find_matching_node() function already indent the
> ref. count...
>
>>>>> + /* Keep refcount of the node */
>
> ... That is why I added this comment ^^
>
> But maybe for sake of clarity, I may have used what you propose anyway.
> What it your opinion?
>
>>>>> +
>>>>> + return 0;
>>>>> +}
>>>>> +#else
>>>>> +static int __init at91_aic_of_init(void)
>>>>> +{
>>>>> + return -ENOSYS;
>>>>> +}
>>>>> +#endif
>>>>
>>>> I think it's preferred if you use of_irq_init() here as it can handle
>>>> the ordering of IRQ controllers. There are GIC and VIC bindings in
>>>> -next that use this and provide a way for non-DT platforms to still use
>>>> the drivers.
>>> which is the case here as if the of_init fail we failback to the
>>> non-dt init
>>>
>>> and this IP is AT91 only
>>
>> Right, but it's not using the of_irq_init() interface which is the
>> standard way of registering interrupt controllers and will correctly
>> dependencies for you.
>>
>> So if you could have something like:
>>
>> void __init __at91_aic_init(unsigned int priority[NR_AIC_IRQS],
>> void __iomem *regs,
>> struct device_node *np)
>> {
>> /*
>> * Do all of the writes to the AIC itself and configure
>> * the IRQ domain.
>> */
>> }
>>
>> void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
>> {
>> void __iomem *base = ioremap(AT91_AIC, 512);
>>
>> __at91_aic_init(priority, base, NULL);
>> }
>>
>> int __init at91_aic_of_init(struct device_node *node,
>> struct device_node *parent)
>> {
>> void __iomem *regs = of_iomap(node, 0);
>>
>> /*
>> * Get priorities from the DT. If this was an array of cells
>> * then that should be okay.
>> */
>> __at91_aic_init(dt_priorities, regs, node);
>> }
>>
>> Then the DT based board initialisation can do:
>>
>> static const struct of_device_id at91_irq_of_match[] __initconst = {
>> { .compatible = "atmel,at91-aic", .data = at91_aic_of_init },
>> {}
>> };
>>
>> static void __init at91_of_irq_init(void)
>> {
>> of_irq_init(at91_of_irq_init);
>> }
>
> That looks nice. I will try to implement this. I will try to figure out
> when of_irq_init() is called compared to the other init_IRQ() function.
>
>> Which is consistent with other platforms. However this does require
>> that the priorities are encoded in the device-tree, but I guess that's a
>> good thing anyway isn't it?
>
> That is a annoying point: I do not want to add all this "default"
> priority stuff in the DT. It is kind of useless until we use the
> threaded interrupts everywhere and may bloat the DT...
>
> I will try to find a way to pass the default priority table to the DT
> called function.

Well, I have better understood the way that all this functions are 
called. And I tend to find it not so nice: I prefer to have all this irq 
controller related details included in the driver itself.
So, I keep the basic structure of my first attempt but will correct it 
using the of_irq_init() API.

Bye,
-- 
Nicolas Ferre
