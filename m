Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1JXVQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:16:41 -0400
Received: from smtp191.dfw.emailsrvr.com ([67.192.241.191]:43808 "EHLO
	smtp191.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1JXVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:16:39 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Oct 2011 17:16:39 EDT
Message-ID: <4EA5D3E8.9020602@calxeda.com>
Date: Mon, 24 Oct 2011 16:08:56 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
References: <20111025073946.019dca49157f5835e1394084@canb.auug.org.au> <20111024204824.GB32545@flint.arm.linux.org.uk>
In-Reply-To: <20111024204824.GB32545@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:48 PM, Russell King wrote:
> On Tue, Oct 25, 2011 at 07:39:46AM +1100, Stephen Rothwell wrote:
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/common/gic.c between commits 292b293ceef2 ("ARM: gic:
>> consolidate PPI handling") and 28af690a284d ("ARM: gic, local timers: use
>> the request_percpu_irq() interface") from the arm tree and commits
>> 2071a2a4b8ed ("ARM: gic: add irq_domain support") and e3f14d321b34 ("ARM:
>> gic: add OF based initialization") from the arm-soc tree.
>>
>> I hacked it up (almost certainly incorrectly - see below). Someone will
>> have to provide Linus with a fix for this.
> 
> Yes, this looks quite wrong:
> 
>> @@@ -332,29 -304,12 +325,22 @@@
>>   		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
>>   
>>   	/*
>> - 	 * Limit number of interrupts registered to the platform maximum
>> - 	 */
>> - 	irq_limit = gic->irq_offset + gic_irqs;
>> - 	if (WARN_ON(irq_limit > NR_IRQS))
>> - 		irq_limit = NR_IRQS;
>> - 
>> - 	/*
>>   	 * Setup the Linux IRQ subsystem.
>>   	 */
>>  +	for (i = 0; i < nrppis; i++) {
>>  +		int ppi = i + ppi_base;
>>  +
>>  +		irq_set_percpu_devid(ppi);
>>  +		irq_set_chip_and_handler(ppi, &gic_chip,
>>  +					 handle_percpu_devid_irq);
>>  +		irq_set_chip_data(ppi, gic);
>>  +		set_irq_flags(ppi, IRQF_VALID | IRQF_NOAUTOEN);
>>  +	}
>>  +
>> - 	for (i = irq_start + nrppis; i < irq_limit; i++) {
>> - 		irq_set_chip_and_handler(i, &gic_chip, handle_fasteoi_irq);
>> - 		irq_set_chip_data(i, gic);
>> - 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
>> + 	irq_domain_for_each_irq(domain, i, irq) {
>> + 		irq_set_chip_and_handler(irq, &gic_chip, handle_fasteoi_irq);
>> + 		irq_set_chip_data(irq, gic);
>> + 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>>   	}
>>   
>>   	writel_relaxed(1, base + GIC_DIST_CTRL);
> 
> We definitely need to sort this out before either tree gets pushed to
> Linus, otherwise we're going to end up annoying Linus... even if we
> provide a resolution.
> 
> I suspect I should've taken the GIC OF stuff via my tree...

Yes, as it turns out to be pretty dependent on your tree.

I'm testing the fix for this and will send a new pull request.

Rob


