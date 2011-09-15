Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1IOKHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:07:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45841 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1IOKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:07:48 -0400
Message-ID: <4E71CE5D.9030900@ti.com>
Date: Thu, 15 Sep 2011 12:07:25 +0200
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
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
In-Reply-To: <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 9/15/2011 9:55 AM, Thomas Abraham wrote:
> Hi Rob,
>
> On 14 September 2011 22:01, Rob Herring<robherring2@gmail.com>  wrote:
>> From: Rob Herring<rob.herring@calxeda.com>
>>
>> This adds gic initialization using device tree data. The initialization
>> functions are intended to be called by a generic OF interrupt
>> controller parsing function once the right pieces are in place.
>>
>> PPIs are handled using 3rd cell of interrupts properties to specify the cpu
>> mask the PPI is assigned to.
>>
>> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
>> ---
>>   Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++++++++++++
>>   arch/arm/common/gic.c                         |   55 +++++++++++++++++++++++--
>>   arch/arm/include/asm/hardware/gic.h           |   10 +++++
>>   3 files changed, 114 insertions(+), 4 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
>
> [...]
>
>
>> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
>> index d1ccc72..14de380 100644
>> --- a/arch/arm/common/gic.c
>> +++ b/arch/arm/common/gic.c
>
> [...]
>
>> +void __init gic_of_init(struct device_node *node, struct device_node *parent)
>> +{
>> +       void __iomem *cpu_base;
>> +       void __iomem *dist_base;
>> +       int irq;
>> +       struct irq_domain *domain =&gic_data[gic_cnt].domain;
>> +
>> +       if (WARN_ON(!node))
>> +               return;
>> +
>> +       dist_base = of_iomap(node, 0);
>> +       WARN(!dist_base, "unable to map gic dist registers\n");
>> +
>> +       cpu_base = of_iomap(node, 1);
>> +       WARN(!cpu_base, "unable to map gic cpu registers\n");
>> +
>> +       domain->nr_irq = gic_irq_count(dist_base);
>> +       domain->irq_base = irq_alloc_descs(-1, 0, domain->nr_irq, numa_node_id());
>
> For exynos4, all the interrupts originating from GIC are statically
> mapped to start from 32 in the linux virq space (GIC SPI interrupts
> start from 64). In the above code, since irq_base would be 0 for
> exynos4, the interrupt mapping is not working correctly. In your
> previous version of the patch, you have given a option to the platform
> code to choose the offset. Could that option be added to this series
> also. Or a provision to use platform specific translate function
> instead of the irq_domain_simple translator.

I have another concern on a similar topic.

On OMAP4 the SoC interrupts external to the MPU (SPI) have an offset of 
32. Only the internal PPI are between 0 and 31.

For the moment we add 32 to every SoC interrupts in the irq.h define, 
but I'm assuming that this offset calculation should be done thanks to a 
dedicated irq domain for the SPI.
The real HW physical number start at 0, and thus this is that value that 
should be in the irq binding of the device.

So ideally we should have a irq domain for the PPI starting at 0 and 
another one for the SPI starting at 32. Or 32 and 64 for the exynos4 
case, but it looks like the PPI/SPI offset is always 32.

Regards,
Benoit
