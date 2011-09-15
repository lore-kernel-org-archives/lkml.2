Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab1IOQnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:43:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62566 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190Ab1IOQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:43:31 -0400
Message-ID: <4E722B2D.4050307@gmail.com>
Date: Thu, 15 Sep 2011 11:43:25 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110906 Thunderbird/7.0
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com> <4E71F978.6020402@gmail.com> <4E72030F.1090300@ti.com>
In-Reply-To: <4E72030F.1090300@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On 09/15/2011 08:52 AM, Cousson, Benoit wrote:
> On 9/15/2011 3:11 PM, Rob Herring wrote:
>> Benoit,
>>
>> On 09/15/2011 05:07 AM, Cousson, Benoit wrote:
>>> Hi Rob,
>>>
>>> On 9/15/2011 9:55 AM, Thomas Abraham wrote:
>>>> Hi Rob,
>>>>
>>>> On 14 September 2011 22:01, Rob Herring<robherring2@gmail.com>   wrote:
>>>>> From: Rob Herring<rob.herring@calxeda.com>
>>>>>
>>>>> This adds gic initialization using device tree data. The
>>>>> initialization
>>>>> functions are intended to be called by a generic OF interrupt
>>>>> controller parsing function once the right pieces are in place.
>>>>>
>>>>> PPIs are handled using 3rd cell of interrupts properties to specify
>>>>> the cpu
>>>>> mask the PPI is assigned to.
>>>>>
>>>>> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
>>>>> ---
>>>>>    Documentation/devicetree/bindings/arm/gic.txt |   53
>>>>> ++++++++++++++++++++++++
>>>>>    arch/arm/common/gic.c                         |   55
>>>>> +++++++++++++++++++++++--
>>>>>    arch/arm/include/asm/hardware/gic.h           |   10 +++++
>>>>>    3 files changed, 114 insertions(+), 4 deletions(-)
>>>>>    create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
>>>>
>>>> [...]
>>>>
>>>>
>>>>> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
>>>>> index d1ccc72..14de380 100644
>>>>> --- a/arch/arm/common/gic.c
>>>>> +++ b/arch/arm/common/gic.c
>>>>
>>>> [...]
>>>>
>>>>> +void __init gic_of_init(struct device_node *node, struct device_node
>>>>> *parent)
>>>>> +{
>>>>> +       void __iomem *cpu_base;
>>>>> +       void __iomem *dist_base;
>>>>> +       int irq;
>>>>> +       struct irq_domain *domain =&gic_data[gic_cnt].domain;
>>>>> +
>>>>> +       if (WARN_ON(!node))
>>>>> +               return;
>>>>> +
>>>>> +       dist_base = of_iomap(node, 0);
>>>>> +       WARN(!dist_base, "unable to map gic dist registers\n");
>>>>> +
>>>>> +       cpu_base = of_iomap(node, 1);
>>>>> +       WARN(!cpu_base, "unable to map gic cpu registers\n");
>>>>> +
>>>>> +       domain->nr_irq = gic_irq_count(dist_base);
>>>>> +       domain->irq_base = irq_alloc_descs(-1, 0, domain->nr_irq,
>>>>> numa_node_id());
>>>>
>>>> For exynos4, all the interrupts originating from GIC are statically
>>>> mapped to start from 32 in the linux virq space (GIC SPI interrupts
>>>> start from 64). In the above code, since irq_base would be 0 for
>>>> exynos4, the interrupt mapping is not working correctly. In your
>>>> previous version of the patch, you have given a option to the platform
>>>> code to choose the offset. Could that option be added to this series
>>>> also. Or a provision to use platform specific translate function
>>>> instead of the irq_domain_simple translator.
>>>
>>> I have another concern on a similar topic.
>>>
>>> On OMAP4 the SoC interrupts external to the MPU (SPI) have an offset of
>>> 32. Only the internal PPI are between 0 and 31.
>>>
>>> For the moment we add 32 to every SoC interrupts in the irq.h define,
>>
>> Those defines will not be used in the DT case. So the question is
>> whether to add 32 or not in the DT. Since we have just a single node and
>> a linear mapping of PPIs and SPIs, the only choice is to have SPIs start
>> at 32. And from the h/w definition, SPIs always start at 32, so it's in
>> agreement.
> 
> This is a agreement inside the MPUSS, but not outside.
> Both Tegra and OMAP4 must add an offset to the HW irq number to deal
> with that today.
> 
>>> but I'm assuming that this offset calculation should be done thanks to a
>>> dedicated irq domain for the SPI.
>>> The real HW physical number start at 0, and thus this is that value that
>>> should be in the irq binding of the device.
>>>
>>> So ideally we should have a irq domain for the PPI starting at 0 and
>>> another one for the SPI starting at 32. Or 32 and 64 for the exynos4
>>> case, but it looks like the PPI/SPI offset is always 32.
>>>
>>
>> That offset of SPIs is always there. If you have a GIC as a secondary
>> controller, It will have 32 reserved interrupts and the register layout
>> is exactly the same as a cpu's GIC.
> 
> Yep, but that's the GIC view and not the SoC one. My concern is to have
> to tweak the HW number provided by the HW spec in order to add that offset.
> If you look at SoC level, the MPUSS is just an IP that can be
> potentially replaced by other one that will not have a GIC. In that case
> you will not change the IRQ mapping at SoC level.
> For example if you replace the Dual-cortexA9 by a single CortexA8, then
> all the interrupts will have to be shifted by 32 just because the MPU
> subsystem is different.
> 

Is that a realistic case? That would be a new chip and new device tree.
You could argue that the whole peripheral subsystem DT could be reused
and the numbering needs to be the same. However, there's one thing that
would prevent that. The number of interrupt cells is defined by the
controller binding. So you have to change the peripheral nodes anyway.

It's good that OMAP is trying to standardize the peripheral layout, but
in my experience that's not something you can rely on.

At some point the interrupt numbering is going to differ from the h/w
documentation. If it's not in the DT, then it will be in linux. Right
now its just offset of 32, but if irqdescs get assigned on demand as PPC
is doing, then there will be no relationship to the documentation.

> Since that offset is dependent of the GIC internals and is not exposed
> outside the MPUSS, it should not be visible by the SoC IPs. And the HW
> spec is exposing exactly that.
> 
>> Since the idea of splitting PPIs for each core out to a flattened linux
>> irq map has been abandoned, I see no reason to have more than 1 domain
>> with a simple linear translation. Ultimately, domains will do dynamic
>> irqdesc allocation and the translation within the gic will be completely
>> dynamic.
> 
> I think the only reason to do that is to separate internal MPU
> interrupts with the external ones that should not have a clue about the
> GIC.

I see 2 options (besides leaving it as is):

- Revert back to my previous binding where PPIs are a sub-node and a
different interrupt parent.

- Use the current binding, but allow SPIs to start at 0. We can still
distinguish PPIs and SPIs by the cpu mask cell. A cpu mask of 0 is a
SPI. If there was ever a reason to have a cpu mask for an SPI, you would
not be able to with this scheme.

Either way you will still have the above issue with the cell size changing.

Rob
