Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2GZVOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:14:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55206 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2GZVOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:14:25 -0400
Message-ID: <5011B32D.1080102@wwwdotorg.org>
Date: Thu, 26 Jul 2012 15:14:21 -0600
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

>> +		if (!irqd_irq_disabled(d) && (value & irq_data->offs)) {
> 
> This looks very suspicious...  why do we need to call 
> irqd_irq_disabled() here?

I believe the status register reflects the unmasked status, it's just
the interrupt signal that's affected by the mask.

>> +static void max8907_irq_enable(struct irq_data *data) +{ +	/*
>> Everything happens in max8907_irq_sync_unlock */ +}
> 
>> +static void max8907_irq_disable(struct irq_data *data) +{ +	/*
>> Everything happens in max8907_irq_sync_unlock */ +}
> 
> The fact that these functions are empty is the second part of the
> above suspicous check for disabled IRQs.  We're just completely
> ignoring the caller here.  What would idiomatically happen is that
> we'd update a variable here then write it out in the unmask.
> 
> If these functions really should be empty then they should be
> omitted.
> 
>> +static int max8907_irq_set_wake(struct irq_data *data, unsigned
>> int on) +{ +	/* Everything happens in max8907_irq_sync_unlock */ 
>> + +	return 0; +}
> 
> Again, this doesn't look clever at all.

So the idea here was that the IRQ core is already maintaining state
which describes which IRQs are enabled/disabled and wake/not. Rather
than have irq_enable/irq_disable/set_wake do nothing but save the same
state to irq_chip-specific structures, I removed the body of those
functions and instead just call irqd_irq_disabled() etc. wherever I
would have accessed the "local" state. Is that not a legitimate design
then?
