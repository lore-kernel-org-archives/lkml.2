Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2G3RAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:00:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56764 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2G3RAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:00:07 -0400
Message-ID: <5016BD94.4080302@wwwdotorg.org>
Date: Mon, 30 Jul 2012 11:00:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 3/3] regmap: enhance regmap-irq to handle 1 IRQ feeding
 n chips
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org> <1343415716-27134-3-git-send-email-swarren@wwwdotorg.org> <20120729203636.GE4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729203636.GE4384@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 02:36 PM, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:01:56PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Some devices contain a single interrupt output, and multiple separate
>> interrupt controllers that all trigger that interrupt output, yet provide
>> no top-level interrupt controller/registers to allow determination of
>> which child interrupt controller caused the interrupt.
> 
> This isn't really anything to do with regmap, it's about implementing
> shared IRQ support for threaded interrupts.  This is generally useful
> and shouldn't be tied to regmap, it's common enough for hardware
> designers to want to use wired or interrupts and it's a limitation of
> Linux that it can't cope currently.
> 
> If are were going to implement it in regmap we shouldn't be faffing
> around setting up the virtual interrupts, we should just do the right
> thing and call round all the chips without bouncing it through the IRQ
> core.

OK, so more like how the max8907.c patch I posted did it than the
pre-existing arizona.c that I converted did it.

I had implemented this in regmap since you'd specifically mentioned
doing that. If I convert the code not to use separate IRQ domains for
this, would that be acceptable?

>> +static irqreturn_t regmaps_irq_thread(int irq, void *data)
>> +{
>> +	struct regmap_irq_chips_data *d = data;
>> +	int ret, i;
>> +
>> +	ret = pm_runtime_get_sync(d->dev);
>> +	if (ret < 0) {
> 
> This is conditional in the core regmap runtime PM support, it may be
> actively harmful if the device doesn't need it.

Hmmm. I actually don't see any pm_*() usage in regmap right now. I
assume this /is/ needed to convert arizona.c, since it's making these
calls today. I don't need it for max8907.c. Should I add another flag to
regmap_add_irq_chips() indicating whether this is needed, or ...?
