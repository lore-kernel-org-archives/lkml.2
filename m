Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1JXUsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:48:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1JXUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:48:41 -0400
Date: Mon, 24 Oct 2011 21:48:24 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111024204824.GB32545@flint.arm.linux.org.uk>
References: <20111025073946.019dca49157f5835e1394084@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025073946.019dca49157f5835e1394084@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 07:39:46AM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/common/gic.c between commits 292b293ceef2 ("ARM: gic:
> consolidate PPI handling") and 28af690a284d ("ARM: gic, local timers: use
> the request_percpu_irq() interface") from the arm tree and commits
> 2071a2a4b8ed ("ARM: gic: add irq_domain support") and e3f14d321b34 ("ARM:
> gic: add OF based initialization") from the arm-soc tree.
> 
> I hacked it up (almost certainly incorrectly - see below). Someone will
> have to provide Linus with a fix for this.

Yes, this looks quite wrong:

> @@@ -332,29 -304,12 +325,22 @@@
>   		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
>   
>   	/*
> - 	 * Limit number of interrupts registered to the platform maximum
> - 	 */
> - 	irq_limit = gic->irq_offset + gic_irqs;
> - 	if (WARN_ON(irq_limit > NR_IRQS))
> - 		irq_limit = NR_IRQS;
> - 
> - 	/*
>   	 * Setup the Linux IRQ subsystem.
>   	 */
>  +	for (i = 0; i < nrppis; i++) {
>  +		int ppi = i + ppi_base;
>  +
>  +		irq_set_percpu_devid(ppi);
>  +		irq_set_chip_and_handler(ppi, &gic_chip,
>  +					 handle_percpu_devid_irq);
>  +		irq_set_chip_data(ppi, gic);
>  +		set_irq_flags(ppi, IRQF_VALID | IRQF_NOAUTOEN);
>  +	}
>  +
> - 	for (i = irq_start + nrppis; i < irq_limit; i++) {
> - 		irq_set_chip_and_handler(i, &gic_chip, handle_fasteoi_irq);
> - 		irq_set_chip_data(i, gic);
> - 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
> + 	irq_domain_for_each_irq(domain, i, irq) {
> + 		irq_set_chip_and_handler(irq, &gic_chip, handle_fasteoi_irq);
> + 		irq_set_chip_data(irq, gic);
> + 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>   	}
>   
>   	writel_relaxed(1, base + GIC_DIST_CTRL);

We definitely need to sort this out before either tree gets pushed to
Linus, otherwise we're going to end up annoying Linus... even if we
provide a resolution.

I suspect I should've taken the GIC OF stuff via my tree...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
