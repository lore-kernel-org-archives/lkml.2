Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1I3A2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:28:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55287 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1I3A2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:28:38 -0400
Date: Thu, 29 Sep 2011 18:27:51 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org
Subject: Re: [PATCH 1/2] ARM: gic: add irq_domain support
Message-ID: <20110930002751.GA12606@ponder.secretlab.ca>
References: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
 <1317268436-1613-2-git-send-email-robherring2@gmail.com>
 <20110929171540.GC6800@ponder.secretlab.ca>
 <4E84DCF4.4020904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E84DCF4.4020904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 04:02:44PM -0500, Rob Herring wrote:
> On 09/29/2011 12:15 PM, Grant Likely wrote:
> > On Wed, Sep 28, 2011 at 10:53:55PM -0500, Rob Herring wrote:
> >> From: Rob Herring <rob.herring@calxeda.com>
> >>
> >> Convert the gic interrupt controller to use irq domains in preparation
> >> for device-tree binding and MULTI_IRQ. This allows for translation between
> >> GIC interrupt IDs and Linux irq numbers.
> >>
> >> The meaning of irq_offset has changed. It now is just the number of skipped
> >> GIC interrupt IDs for the controller. It will be 16 for primary GIC and 32
> >> for secondary GICs.
> > 
> > [...]
> > 
> >>  /*
> >> @@ -81,7 +82,7 @@ static inline unsigned int gic_irq(struct irq_data *d)
> >>   */
> >>  static void gic_mask_irq(struct irq_data *d)
> >>  {
> >> -	u32 mask = 1 << (d->irq % 32);
> >> +	u32 mask = 1 << (gic_irq(d) % 32);
> > 
> > This can probably change simply to d->hwirq if irq_offset is
> > eliminated as I describe below.
> > 
> >>  void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
> >>  	void __iomem *dist_base, void __iomem *cpu_base)
> >>  {
> >>  	struct gic_chip_data *gic;
> >> +	struct irq_domain *domain;
> >> +	int gic_irqs;
> >>  
> >>  	BUG_ON(gic_nr >= MAX_GIC_NR);
> >>  
> >>  	gic = &gic_data[gic_nr];
> >> +	domain = &gic->domain;
> >>  	gic->dist_base = dist_base;
> >>  	gic->cpu_base = cpu_base;
> >> -	gic->irq_offset = (irq_start - 1) & ~31;
> >>  
> >> -	if (gic_nr == 0)
> >> +	/*
> >> +	 * For primary GICs, skip over SGIs.
> >> +	 * For secondary GICs, skip over PPIs, too.
> >> +	 */
> >> +	if (gic_nr == 0) {
> >>  		gic_cpu_base_addr = cpu_base;
> >> +		gic->irq_offset = 16;
> >> +		irq_start = (irq_start & ~31) + 16;
> > 
> > With the switch to irq_domain, there should no longer be any need for
> > a ~31 mask on the irq_start number.  Yes, you'll want to make sure
> > that it doesn't allocate below irq 16, but the driver should
> > completely use the irq_domain to manage the mapping from linux-irq
> > number to hwirq number.  The ~31 mask appears to have been an
> > optimization to quickly calculate hwirq number from the linux one, but
> > that value is now found in irq_data->hwirq.
> 
> I started out exactly this way removing irq_offset. The problem is the
> core irq domain code assumes that hwirq starts at 0, but for the gic it
> starts at 16 or 32.
> 
> It could be fixed in the domain core, but that would effectively mean
> moving irq_offset into the core.

Fix irq_domain.  If it cannot handle this trivial case, then it won't
be able to handle the complex powerpc use cases.

g.
