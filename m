Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2GZWHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:07:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57809 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2GZWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:07:16 -0400
Message-ID: <5011BF90.5030708@wwwdotorg.org>
Date: Thu, 26 Jul 2012 16:07:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
References: <1343331630-27126-1-git-send-email-swarren@wwwdotorg.org> <20120726203526.GD4560@opensource.wolfsonmicro.com>
In-Reply-To: <20120726203526.GD4560@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 02:35 PM, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 01:40:30PM -0600, Stephen Warren wrote:

>> +		if (irqd_is_wakeup_set(d)) {
>> +			/* 1 -- disable, 0 -- enable */
>> +			switch (irq_data->mask_reg) {
> 
> This loop we should just port over into the regmap code.

I assume the best way of doing this is to add new functions
regmap_irq_suspend()/regmap_irq_resume() (which would mask any enabled
interrupts that were not wake enabled); that way, the regmap_irq code
can loop over each register and just write it once. An alternative might
be to implement struct irq_chip's .irq_suspend/.irq_resume ops, but that
might worst-case end up with an I2C write per interrupt.

I see that the MAX8907 IRQ code does this in suspend:

	if (device_may_wakeup(chip->dev))
		enable_irq_wake(i2c->irq);
	else
		disable_irq(i2c->irq);

and this in resume:

	if (device_may_wakeup(chip->dev))
		disable_irq_wake(i2c->irq);
	else
		enable_irq(i2c->irq);

neither of which are done in regmap_irq, since it doesn't explicitly do
anything for suspend/resume at the moment. Are those code blocks
necessary? I see that regmap_irq_sync_unlock() is already calling
irq_set_irq_wake(), which implies that suspend/resume may have already
been completely taken care of?
