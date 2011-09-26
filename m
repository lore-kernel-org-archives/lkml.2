Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1IZVLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:11:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44844 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1IZVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:11:31 -0400
Date: Mon, 26 Sep 2011 22:11:27 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, b-cousson@ti.com, shawn.guo@linaro.org,
        dave.martin@linaro.org, linux@arm.linux.org.uk,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
Message-ID: <20110926211127.GE9194@gallagher>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
 <1316550244-3655-4-git-send-email-robherring2@gmail.com>
 <20110926195704.GD9194@gallagher>
 <4E80E547.2080004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E80E547.2080004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 03:49:11PM -0500, Rob Herring wrote:
> On 09/26/2011 02:57 PM, Jamie Iles wrote:
> > Hi Rob,
> > 
> > On Tue, Sep 20, 2011 at 03:24:04PM -0500, Rob Herring wrote:
> > [...]
> >> +int __init gic_of_init(struct device_node *node, struct device_node *parent)
> >> +{
> >> +	void __iomem *cpu_base;
> >> +	void __iomem *dist_base;
> >> +	int irq;
> >> +	struct irq_domain *domain = &gic_data[gic_cnt].domain;
> >> +
> >> +	if (WARN_ON(!node))
> >> +		return -ENODEV;
> >> +
> >> +	dist_base = of_iomap(node, 0);
> >> +	WARN(!dist_base, "unable to map gic dist registers\n");
> >> +
> >> +	cpu_base = of_iomap(node, 1);
> >> +	WARN(!cpu_base, "unable to map gic cpu registers\n");
> >> +
> >> +	domain->nr_irq = gic_irq_count(dist_base);
> >> +	/* subtract off SGIs. Also subtract off PPIs for secondary GICs */
> >> +	if (parent)
> >> +		domain->nr_irq -= 32;
> >> +	else
> >> +		domain->nr_irq -= 16;
> >> +
> >> +	domain->irq_base = irq_alloc_descs(-1, 16, domain->nr_irq, numa_node_id());
> > 
> > The way I understand irq_alloc_descs() (probably not very well) is that 
> > having the irq parameter < 0 and the from parameter 16 means that it 
> > needs to find domain->nr_irq descs starting from at least 16.  But if 
> > the base is greater than 16, does this still work with the gic entry 
> > macros as they are?
> 
> No, but that would only happen if a platform calls irq_alloc_descs prior
> to this code. The root controller must be initialized first (for other
> reasons as well). There are no calls to irq_alloc_descs in arch/arm.
> 
> With the MULTI_IRQ GIC support Marc Z is working on, we could make the
> GIC irq mapping be completely dynamic. Although, there's probably not
> much reason to do so for the root controller.

OK, that makes sense.  I think that if you were to do 
irq_alloc_descs(16, 16, domain->nr_irqs, num_node_id()) then that will 
guarantee the descriptors start from 16 (if they are available) which is 
probably nicer.

Jamie
