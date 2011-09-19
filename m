Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1ISOdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:33:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50844 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab1ISOdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:33:11 -0400
Message-ID: <4E775294.10206@ti.com>
Date: Mon, 19 Sep 2011 16:32:52 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
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
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com> <4E71F978.6020402@gmail.com> <4E72030F.1090300@ti.com> <4E722B2D.4050307@gmail.com> <4E76615C.3000005@gmail.com> <4E77310A.3000106@ti.com> <4E774847.3020104@gmail.com>
In-Reply-To: <4E774847.3020104@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/2011 3:48 PM, Rob Herring wrote:
> On 09/19/2011 07:09 AM, Cousson, Benoit wrote:
>> On 9/18/2011 11:23 PM, Rob Herring wrote:
>>> On 09/15/2011 11:43 AM, Rob Herring wrote:
>>>> On 09/15/2011 08:52 AM, Cousson, Benoit wrote:
>>>>> On 9/15/2011 3:11 PM, Rob Herring wrote:
>>>>>> On 09/15/2011 05:07 AM, Cousson, Benoit wrote:
>>
>> [...]
>>
>>>>>>> I have another concern on a similar topic.
>>>>>>>
>>>>>>> On OMAP4 the SoC interrupts external to the MPU (SPI) have
>>>>>>> an offset of 32. Only the internal PPI are between 0 and
>>>>>>> 31.
>>>>>>>
>>>>>>> For the moment we add 32 to every SoC interrupts in the
>>>>>>> irq.h define,
>>>>>>
>>>>>> Those defines will not be used in the DT case. So the
>>>>>> question is whether to add 32 or not in the DT. Since we have
>>>>>> just a single node and a linear mapping of PPIs and SPIs, the
>>>>>> only choice is to have SPIs start at 32. And from the h/w
>>>>>> definition, SPIs always start at 32, so it's in agreement.
>>>>>
>>>>> This is a agreement inside the MPUSS, but not outside. Both
>>>>> Tegra and OMAP4 must add an offset to the HW irq number to
>>>>> deal with that today.
>>>>>
>>>>>>> but I'm assuming that this offset calculation should be
>>>>>>> done thanks to a dedicated irq domain for the SPI. The real
>>>>>>> HW physical number start at 0, and thus this is that value
>>>>>>> that should be in the irq binding of the device.
>>>>>>>
>>>>>>> So ideally we should have a irq domain for the PPI starting
>>>>>>> at 0 and another one for the SPI starting at 32. Or 32 and
>>>>>>> 64 for the exynos4 case, but it looks like the PPI/SPI
>>>>>>> offset is always 32.
>>>>>>>
>>>>>>
>>>>>> That offset of SPIs is always there. If you have a GIC as a
>>>>>> secondary controller, It will have 32 reserved interrupts and
>>>>>> the register layout is exactly the same as a cpu's GIC.
>>>>>
>>>>> Yep, but that's the GIC view and not the SoC one. My concern is
>>>>> to have to tweak the HW number provided by the HW spec in order
>>>>> to add that offset. If you look at SoC level, the MPUSS is just
>>>>> an IP that can be potentially replaced by other one that will
>>>>> not have a GIC. In that case you will not change the IRQ
>>>>> mapping at SoC level. For example if you replace the
>>>>> Dual-cortexA9 by a single CortexA8, then all the interrupts
>>>>> will have to be shifted by 32 just because the MPU subsystem is
>>>>> different.
>>>>>
>>>>
>>>> Is that a realistic case? That would be a new chip and new device
>>>> tree. You could argue that the whole peripheral subsystem DT
>>>> could be reused and the numbering needs to be the same. However,
>>>> there's one thing that would prevent that. The number of
>>>> interrupt cells is defined by the controller binding. So you have
>>>> to change the peripheral nodes anyway.
>>>>
>>>> It's good that OMAP is trying to standardize the peripheral
>>>> layout, but in my experience that's not something you can rely
>>>> on.
>>>>
>>>> At some point the interrupt numbering is going to differ from the
>>>> h/w documentation. If it's not in the DT, then it will be in
>>>> linux. Right now its just offset of 32, but if irqdescs get
>>>> assigned on demand as PPC is doing, then there will be no
>>>> relationship to the documentation.
>>>>
>>>>> Since that offset is dependent of the GIC internals and is not
>>>>> exposed outside the MPUSS, it should not be visible by the SoC
>>>>> IPs. And the HW spec is exposing exactly that.
>>>>>
>>>>>> Since the idea of splitting PPIs for each core out to a
>>>>>> flattened linux irq map has been abandoned, I see no reason
>>>>>> to have more than 1 domain with a simple linear translation.
>>>>>> Ultimately, domains will do dynamic irqdesc allocation and
>>>>>> the translation within the gic will be completely dynamic.
>>>>>
>>>>> I think the only reason to do that is to separate internal MPU
>>>>> interrupts with the external ones that should not have a clue
>>>>> about the GIC.
>>>>
>>>> I see 2 options (besides leaving it as is):
>>>>
>>>> - Revert back to my previous binding where PPIs are a sub-node
>>>> and a different interrupt parent.
>>>>
>>>> - Use the current binding, but allow SPIs to start at 0. We can
>>>> still distinguish PPIs and SPIs by the cpu mask cell. A cpu mask
>>>> of 0 is a SPI. If there was ever a reason to have a cpu mask for
>>>> an SPI, you would not be able to with this scheme.
>>>>
>>>> Either way you will still have the above issue with the cell size
>>>> changing.
>>>>
>>>
>>> I was headed down the path of implementing the 2nd option above,
>>> but had a dilemma. What would be the numbering base for PPIs in
>>> this case? Should it be 0 in the DT as proposed for SPIs or does it
>>> stay at 16?
>>
>> Both SGI and PPI are internal to the CortexA9 MP core, and referring
>> to the CortexA9 MP core TRM [1], you can see that the PPI# ->  ID#
>> mapping is already documented: - Private timer, PPI(2) Each Cortex-A9
>> processor has its own private timers that can generate interrupts,
>> using ID29. - Watchdog timers, PPI(3) Each Cortex-A9 processor has
>> its own watchdog timers that can generate interrupts, using ID30.
>>
>> So in that case, it can makes sense to use the ID. But it is
>> interesting to note that the PPI is identified with a 0 based index
>> number.
>>
> It's even worse than I thought: we could use 13 (ID16 == PPI0), 29 or 2
> for the timer interrupt. The first would match 0 based SPI convention.

I didn't even noticed that mess :-(
Maybe that PPI number is not that relevant in that case. It looks like 
there are using the last 4 lines (28-31).

> The last 2 would both match the documentation. We could never use 2 as
> this will for sure be different and the GIC code will have no way to
> know how to do the translation to ID. The only sane choice is using the
> ID as you say.

In that case, this is indeed the case.

> But you can't have it both ways. It does not make sense to use the ID
> for some interrupts and a different scheme for others.

Maybe not, the idea is to use the scheme that is the most relevant for a 
particular subsystem. Inside the CortexA9 MP the documentation clearly 
gives the mapping based on ID#. But for SPIs, it is just written start 
as ID32.

>>> Numbering PPIs at 0 will just cause confusion as will numbering
>>> differently from SPIs. There is absolutely no mention of SPI0 or
>>> SPIx numbering in the GIC spec.
>>
>> Probably because it is the generic GIC spec that focus on internals
>> stuff only, it not an integration spec that will show how the SPIs
>> are connected to the outside world. But it is clear that the SPIs are
>> identified as 0-XXX lines outside the Cortex MP core.
>>
>
> What if the A9 or some other implementation used some SPIs internally?
> Then the external connection would be shifted differently.

Potentially yes.

> The interrupt
> binding for a peripheral is defined by it's interrupt parent (the
> interrupt controller). The number of cells and what the values mean are
> defined by the interrupt controller binding. This is independent of any
> SOC. The binding must be defined from the perspective of the interrupt
> controller.

In fact, it is dependent on both the interrupt controller binding, and 
the way the interrupt controller is connected to the SoC. It should be 
defined as well based on the interface exposed to the outside of the 
subsystem.

>> In TRM [1] page 53: Shared Peripheral Interrupts (SPI): SPIs are
>> triggered by events generated on associated interrupt input lines.
>> The Interrupt Controller can support up to 224 interrupt input lines.
>> The interrupt input lines can be configured to be edge sensitive
>> (posedge) or level sensitive (high level). SPIs start at ID32.
>>
>>> All interrupt number references refer to the absolute interrupt ID,
>>> not a relative number based on the type. The fact that the
>>> Cortex-A9 implementation has interrupt lines numbered equal to the
>>> GIC SPI interrupts is an implementation detail of the A9.
>>
>>> Other cores could have different arrangement including bringing out
>>> PPI interrupts or reserving some SPIs.
>>
>> Absolutely, that's why we should not use that internal GIC convention
>> to capture external IRQ mapping. It you separate the PPI and the SPI
>> controller, you can allow any kind of internal mapping.
>>
>
> The GIC convention is the only part that is consistent and not dependent
> on the implementation.

Again, for the point of view of the GIC, but not necessarily for the SoC 
point of view.

>>> As there are many users of the GIC, it makes more sense to align
>>> with the GIC documentation rather than the documentation of 1 SOC.
>>> BTW, I have the exact same issue in our documentation.
>>
>> It is not about one SoC, this is probably done like that for every
>> other SoCs. I do not have the TRM for the other SoCs, but here is how
>> it is done in various irqs.h file today:
>>
>> - arch/arm/mach-exynos4/include/mach
>>
>> /* PPI: Private Peripheral Interrupt */ #define IRQ_PPI(x)
>> S5P_IRQ(x+16)
>>
>> /* SPI: Shared Peripheral Interrupt */ #define IRQ_SPI(x)
>> S5P_IRQ(x+32)
>>
>> #define IRQ_EINT0             IRQ_SPI(16) #define IRQ_EINT1           IRQ_SPI(17) #define
>> IRQ_EINT2             IRQ_SPI(18) #define IRQ_EINT3           IRQ_SPI(19)
>>
>>
>> - arch/arm/mach-tegra/include/mach
>>
>> /* Primary Interrupt Controller */ #define INT_PRI_BASE
>> (INT_GIC_BASE + 32) #define INT_TMR1                  (INT_PRI_BASE + 0) #define
>> INT_TMR2                      (INT_PRI_BASE + 1) #define INT_RTC                              (INT_PRI_BASE + 2)
>> #define INT_I2S2                      (INT_PRI_BASE + 3)
>>
>>
>> - arch/arm/mach-ux500/include/mach
>>
>> /* Shared Peripheral Interrupt (SHPI) */ #define IRQ_SHPI_START                       32
>>
>> #define IRQ_MTU0              (IRQ_SHPI_START + 4)
>>
>>
>> - arch/arm/plat-omap/include/plat
>>
>> #define OMAP44XX_IRQ_GIC_START                        32
>>
>> #define OMAP44XX_IRQ_PL310                    (0 + OMAP44XX_IRQ_GIC_START) #define
>> OMAP44XX_IRQ_CTI0                     (1 + OMAP44XX_IRQ_GIC_START) #define
>> OMAP44XX_IRQ_CTI1                     (2 + OMAP44XX_IRQ_GIC_START) #define
>> OMAP44XX_IRQ_ELM                      (4 + OMAP44XX_IRQ_GIC_START)
>>
>>
>> Every CortexA9 based SoC have to add the 32 offset to the SoC level
>> interrupt number line. The ID numbering scheme is relevant only
>> inside the GIC, but at SoC level only the IRQ lines that entered the
>> MP core are relevant. That ID is a pure internal GIC encoding.
>>
> Exactly. For DT, the irq numbering is supposed to be local to the
> interrupt controller. So from a GIC perspective, what numbering makes sense?

The number relevant to the GIC will depend of the context.
Inside the Cortex MP, the ID# is relevant, outside, this is not the case 
anymore, because only the SPIs will be connected.

> It's also relevant to the software running on the system.

For the SW/driver case, it will be abstracted by the DT core code, so 
the real HW value should never matter.

Bottom-line: I understand your GIC centric point of view. At GIC level 
you have to handle a bunch of IDs.
And at Soc level we just want to handle a subset of them with a slightly 
different numbering scheme. So you're right, the GIC node is maybe not 
the proper place to handle that if you want the GIC code to be generic.

What is maybe just missing is a intermediate node in between to 
translate the SoC view to the GIC view.
This is probably the interrupt nexus Grant was referring to, the only 
issue today is the lack of easy support for basic translation.

>> If you refer to the GIC-400 spec [2] (Please note that I do not know
>> what that GIC is exactly...) p 25: "SPIs are triggered by events
>> generated on associated interrupt input lines. The GIC-400 can
>> support up to 480 SPIs corresponding to the external IRQS[479:0]
>> signal. The number of SPIs available depends on the implemented
>> configuration of the GIC-400. The permitted values are 0-480, in
>> steps of 32. SPIs start at ID32."
>>
>> In that case the external IRQS numbering scheme is clear: [479:0],
>> which is exactly what will be seen outside of the MP core.
>>
>> Having two interrupt controllers, one for SGIs + PPIs starting at 0
>> (hwirq#) and another one from SPIs starting at 32 (hwirq#), seems to
>> me a much better approach. Moreover, it will avoid exposing a cpumask
>> for SPIs.
>>
>
> Having implemented both ways already, I'm fine either way, but the
> current consensus seems to be to use the cpumask.

I missed that thread, what was the point? To have a more generic 
interface that can handle both cases?

Regards,
Benoit
