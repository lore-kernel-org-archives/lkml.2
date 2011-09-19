Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1ISM77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 08:59:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46199 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1ISM76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 08:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110918061024.GD3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
	<1316017900-19918-6-git-send-email-robherring2@gmail.com>
	<CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
	<4E71F593.2040903@gmail.com>
	<CAJuYYwQ=tSh8k5ZOi2kx6KbMsQ4eVAvgE=T4kdckRSLjdj3dMQ@mail.gmail.com>
	<20110918061024.GD3523@ponder.secretlab.ca>
Date: Mon, 19 Sep 2011 18:29:58 +0530
Message-ID: <CAJuYYwSZkPCyJ0PrLV4ScyOnK1X-49jPFiXU3ioy_cY0Os3-HQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 18 September 2011 11:40, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Sep 16, 2011 at 03:04:11PM +0530, Thomas Abraham wrote:
>> Hi Rob,
>>
>> On 15 September 2011 18:24, Rob Herring <robherring2@gmail.com> wrote:
>> > On 09/15/2011 02:55 AM, Thomas Abraham wrote:
>> >>> +void __init gic_of_init(struct device_node *node, struct device_node *parent)
>> >>> +{
>> >>> +       void __iomem *cpu_base;
>> >>> +       void __iomem *dist_base;
>> >>> +       int irq;
>> >>> +       struct irq_domain *domain = &gic_data[gic_cnt].domain;
>> >>> +
>> >>> +       if (WARN_ON(!node))
>> >>> +               return;
>> >>> +
>> >>> +       dist_base = of_iomap(node, 0);
>> >>> +       WARN(!dist_base, "unable to map gic dist registers\n");
>> >>> +
>> >>> +       cpu_base = of_iomap(node, 1);
>> >>> +       WARN(!cpu_base, "unable to map gic cpu registers\n");
>> >>> +
>> >>> +       domain->nr_irq = gic_irq_count(dist_base);
>> >>> +       domain->irq_base = irq_alloc_descs(-1, 0, domain->nr_irq, numa_node_id());
>> >>
>> >> For exynos4, all the interrupts originating from GIC are statically
>> >> mapped to start from 32 in the linux virq space (GIC SPI interrupts
>> >> start from 64). In the above code, since irq_base would be 0 for
>> >> exynos4, the interrupt mapping is not working correctly. In your
>> >> previous version of the patch, you have given a option to the platform
>> >> code to choose the offset. Could that option be added to this series
>> >> also. Or a provision to use platform specific translate function
>> >> instead of the irq_domain_simple translator.
>> >>
>> >
>> > So I guess you have the A9 external nIRQ hooked up to another
>> > controller? Why can't the 0-31 interrupts get mapped to after the gic
>> > interrupts? Ultimately we want h/w irq numbers completely decoupled from
>> > linux irq numbers. So you will want to put that controller in devicetree
>> > and have an DT init function for it as well.
>>
>> There are chained interrupt handlers mapped in between linux irq
>> number 0 to 31. So the offset for GIC interrupts was set to 32 (SGI[0]
>> = 32). The interrupt chaining for the interrupts mapped between 0 to
>> 31 seems unnecessary though. I will try removing them and check.
>
> Please note; when using the DT, the linux virq number should be
> dynamically assigned and therefore will not matter.  Historically
> Exynos may have started from irq 32, but it doesn't really have any
> relevance when all IRQ references are via DT irq specifiers.

Ok. But the exynos4 modules that have dt support depend on other
modules that are yet to get dt support. Those modules still use static
linux interrupt numbers and so until all the modules get dt support,
interrupt number specified in dt would have to follow the static
numbering that the rest of the system uses.

So to use Rob's patches for exynos4 dt, the interrupts mapped in the
range 1 to 31 will have to be reworked or moved to some other irq
numbers.

>
> Plus, for dynamically allocated irq_descs, I really want to make sure
> that irq 0 never gets assigned.  We're not supposed to be using it,
> and that becomes an easy rule to enforce when interrupt numbers are no
> longer assigned with #defines.
>
> g.
>

Thanks,
Thomas.
