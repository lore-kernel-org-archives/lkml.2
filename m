Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2GaTZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:25:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45021 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2GaTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:25:18 -0400
Message-ID: <5018311B.8070202@wwwdotorg.org>
Date: Tue, 31 Jul 2012 13:25:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/3] regmap: implement irq chip suspend/resume operations
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org> <1343415716-27134-2-git-send-email-swarren@wwwdotorg.org> <20120729210410.GM4384@opensource.wolfsonmicro.com> <5016C006.80008@wwwdotorg.org> <20120730173822.GN4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120730173822.GN4468@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 11:38 AM, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 11:10:30AM -0600, Stephen Warren wrote:
> 
>> hence exit sleep. If we are to port that code into the regmap-irq core,
>> it seems to make sense to have enable_base==wake_base, since the same
>> register truly is being used for both enable/wakeup-enable, just
>> time-multiplexed.
> 
> This would mean that we have to go round every single driver that
> doesn't have physical wake support and add a setting for the wake
> registers (which seems pointless given that the core can just as well
> figure this out from the fact that it's not had any wake registers
> specified) and we then have to add special cases for this in the core
> code.  This doesn't seem like great API design, it's not conveneint for
> either side of the interface and it's error prone.
> 
>> Or, perhaps the IRQ core already disables all non-wake interrupts for
>> us, so the driver doesn't have to do this, and we can just drop that
>> code completely?
> 
> IIRC it does actually do this, I'd need to check though.

It looks like the answer here is to set irq_chip flags
IRQCHIP_MASK_ON_SUSPEND and IRQCHIP_SKIP_SET_WAKE. Perhaps regmap-irq
should do this automatically if (!regmap_irq_chip.wake_base)?

For reference, these flags are implemented in
kernel/irq/pm.c:check_wakeup_irqs() and
kernel/irq/manage.c:set_irq_wake_real().
