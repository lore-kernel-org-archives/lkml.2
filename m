Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1IPQJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:09:54 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:35722 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1IPQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:09:53 -0400
Date: Fri, 16 Sep 2011 17:09:39 +0100
From: Dave Martin <dave.martin@linaro.org>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110916160939.GA2100@arm.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-6-git-send-email-robherring2@gmail.com>
 <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
 <4E71CE5D.9030900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E71CE5D.9030900@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 12:07:25PM +0200, Cousson, Benoit wrote:
> Hi Rob,
> 
> On 9/15/2011 9:55 AM, Thomas Abraham wrote:
> >Hi Rob,
> >
> >On 14 September 2011 22:01, Rob Herring<robherring2@gmail.com>  wrote:
> >>From: Rob Herring<rob.herring@calxeda.com>
> >>
> >>This adds gic initialization using device tree data. The initialization
> >>functions are intended to be called by a generic OF interrupt
> >>controller parsing function once the right pieces are in place.
> >>
> >>PPIs are handled using 3rd cell of interrupts properties to specify the cpu
> >>mask the PPI is assigned to.
> >>
> >>Signed-off-by: Rob Herring<rob.herring@calxeda.com>
> >>---
> >>  Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++++++++++++
> >>  arch/arm/common/gic.c                         |   55 +++++++++++++++++++++++--
> >>  arch/arm/include/asm/hardware/gic.h           |   10 +++++
> >>  3 files changed, 114 insertions(+), 4 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
> >
> >[...]
> >
> >
> >>diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> >>index d1ccc72..14de380 100644
> >>--- a/arch/arm/common/gic.c
> >>+++ b/arch/arm/common/gic.c
> >
> >[...]
> >
> >>+void __init gic_of_init(struct device_node *node, struct device_node *parent)
> >>+{
> >>+       void __iomem *cpu_base;
> >>+       void __iomem *dist_base;
> >>+       int irq;
> >>+       struct irq_domain *domain =&gic_data[gic_cnt].domain;
> >>+
> >>+       if (WARN_ON(!node))
> >>+               return;
> >>+
> >>+       dist_base = of_iomap(node, 0);
> >>+       WARN(!dist_base, "unable to map gic dist registers\n");
> >>+
> >>+       cpu_base = of_iomap(node, 1);
> >>+       WARN(!cpu_base, "unable to map gic cpu registers\n");
> >>+
> >>+       domain->nr_irq = gic_irq_count(dist_base);
> >>+       domain->irq_base = irq_alloc_descs(-1, 0, domain->nr_irq, numa_node_id());
> >
> >For exynos4, all the interrupts originating from GIC are statically
> >mapped to start from 32 in the linux virq space (GIC SPI interrupts
> >start from 64). In the above code, since irq_base would be 0 for
> >exynos4, the interrupt mapping is not working correctly. In your
> >previous version of the patch, you have given a option to the platform
> >code to choose the offset. Could that option be added to this series
> >also. Or a provision to use platform specific translate function
> >instead of the irq_domain_simple translator.
> 
> I have another concern on a similar topic.
> 
> On OMAP4 the SoC interrupts external to the MPU (SPI) have an offset
> of 32. Only the internal PPI are between 0 and 31.

On a similar theme, on Versatile express the motherboard and core-tiles
are independent things, and the GIC lives on the core-tile (the motherboard
has no interrupt controller of its owh).

This means that the mapping of motherboard peripheral interrupts onto
GIC inputs is dependent on the coretile.

Since the DT is supposed to be descrbing the hardware in a componentised
way, the motherboard description should be independent of the core-tile
description except for describing the interface between the two.


For now, we express the mapping by putting an interrupt-map in the
core-tile DT, but this feels inelegant as well as wasteful -- expressing
"+ 32" using a table which is about 1K in size and duplicates that
information 43 times.

Using a dedicated irq domain or a fake interrupt controller node to
encapsulate the motherboard interrupts feels like a cleaner approach,
but for now I'm not clear on the best way to do it.

Cheers
---Dave
