Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2GaXSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:18:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47661 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2GaXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:18:39 -0400
Message-ID: <501867CC.50909@wwwdotorg.org>
Date: Tue, 31 Jul 2012 17:18:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 3/3] regmap: enhance regmap-irq to handle 1 IRQ feeding
 n chips
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org> <1343415716-27134-3-git-send-email-swarren@wwwdotorg.org> <20120729203636.GE4384@opensource.wolfsonmicro.com> <5016BD94.4080302@wwwdotorg.org> <20120730172538.GM4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120730172538.GM4468@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 11:25 AM, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 11:00:04AM -0600, Stephen Warren wrote:
>> On 07/29/2012 02:36 PM, Mark Brown wrote:
>>> On Fri, Jul 27, 2012 at 01:01:56PM -0600, Stephen Warren wrote:
> 
>> I had implemented this in regmap since you'd specifically mentioned
>> doing that. If I convert the code not to use separate IRQ domains for
> 
> I think what I'd said was that we should factor it out rather than that
> it should be specifically done in regmap.
> 
>> this, would that be acceptable?
> 
> Probably.

The more I think about this, the more I prefer the way the way it is in
the patch I posted.

I don't think it's appropriate to put this support into the IRQ core.
The main issue is that all the handlers for any shared wired-or
interrupt line have to be registered before the IRQ is enabled, to avoid
some initially active interrupt continually firing before the IRQ is
enabled. Co-ordinating this when the wired-or line is on a board outside
a device driver rather than internal to a chip and one device driver is
a bit more than the IRQ core should probably be doing, hence I imagine
why it doesn't support it.

Co-ordinating this setup where all the sources of the wired-or are in
one chip seems to belong to the chip driver, which is where my patch did
this.

I guess I could modify regmaps_irq_thread() so that instead of:

	for (i = 0; i < d->nchips; i++)
		handle_nested_irq(irq_find_mapping(d->irqdom, i));

... it short-circuited and instead did something like:

	for (i = 0; i < d->nchips; i++)
		regmap_irq_thread(irq_find_mapping(d->irqdom, i),
			d->datas[i]);

but it seems a little hokey to short-circuit the IRQ core; it would
prevent execution of any statistics gathering or stuck interrupt
handling that handle_nested_irq() might do for example.

Now, if we made each child regmap_irq not be its own IRQ domain or
irq_chip, but simply had one top-level domain/chip that aggregated them,
that argument would be moot. However, that top-level domain/chip would
become rather complex and just end up doing a bunch of demultiplexing
code that's not needed if we do it like in my patch...
