Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1IRGbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 02:31:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1IRGbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 02:31:21 -0400
Date: Sun, 18 Sep 2011 00:15:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110918061526.GE3523@ponder.secretlab.ca>
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
> 
> For the moment we add 32 to every SoC interrupts in the irq.h
> define, but I'm assuming that this offset calculation should be done
> thanks to a dedicated irq domain for the SPI.
> The real HW physical number start at 0, and thus this is that value
> that should be in the irq binding of the device.

Yes.

> So ideally we should have a irq domain for the PPI starting at 0 and
> another one for the SPI starting at 32. Or 32 and 64 for the exynos4
> case, but it looks like the PPI/SPI offset is always 32.

Part of the purpose behind irq_domains is to have a translator
callback that can take care of complex mappings, such as mapping each
of the GIC irq ranges onto the Linux irq space.  Plus, by being based
on the DT irq specifiers and dynamically assigning the linux numbers,
the actual mapping that the kernel chooses to use shouldn't actually
have any relevance.  So whether or not the driver uses an offset is 32
becomes an implementation detail.
