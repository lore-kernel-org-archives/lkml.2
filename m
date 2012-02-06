Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2BFPxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:53:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54712 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2BFPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:53:50 -0500
Date: Mon, 6 Feb 2012 15:53:18 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg
	and prep_dma_cyclic
Message-ID: <20120206155318.GA20852@flint.arm.linux.org.uk>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com> <1328529182.26182.92.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com> <1328542134.26182.111.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328542134.26182.111.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:58:54PM +0530, Vinod Koul wrote:
> On Mon, 2012-02-06 at 07:04 -0800, Bounine, Alexandre wrote:
> > I was thinking about keeping the original scatterlist for dmac unchanged,
> > but allocating another scatterlist in rio_dma_prep_slave_sg() and chaining
> > two lists together. After it passed to device specific function, it parses
> > first section of the chain for additional transfer parameters and use
> > following scatterlist as intended for dmac.
> hmmm, but that wouldn't make it generic for other systems like proposed
> MSM box mode..., right?
> > 
> > But Russell's idea (See https://lkml.org/lkml/2012/2/3/269 ) seems to be
> > a better way without added complexity and I am ready to take that path and
> > make new patches if you and Dan agree with it. 
> but it still doesn't fix his concerns for the using void pointer.

It helps because it makes it easier to find those drivers who are not
using the generic interface (and so would be tied to their particular
DMA engine.)

Let's take a step back.

One of the fundamental points for having a DMA engine API is to separate
the DMA users from the DMA engines, and make the two independent.  This
allows DMA users (like MMC, UARTs, etc) to be written in a way that they
are totally independent of the DMA engine.

Why is this important?  We're seeing an increasing number of SoCs with
the same peripheral IP integrated onto them but with different DMA
controllers.  Not only does that happen within an architecture, but you
can bet it'll start happening outside.  For example, AMBA Primecell
peripherals are not only found on ARM but also on SoCs with differing
CPUs.  Some PXA peripherals are now being found on x86 hardware.

So, we need a basic DMA engine API which ensures that users of the API
do not have to know any details about the DMA engine itself for them to
be able to get on with their business.

Now, if we start allowing a 'void *' per-transfer random pointer, then
what will happen is that we'll end up with people abusing it for passing
other stuff, maybe such as DMA request lines because they don't want to
bother with virtual channels in their DMA engine.  At that point, the
peripheral drivers gain knowledge about the DMA engine they're attached
to, and it becomes impossible to reuse them without resorting to ifdeffery
in the peripheral drivers.

This brings up a fundamental question: if you have a DMA engine which
has some unique specific feature, and needs extra data to use that funky
feature passed through the generic API, is it appropriate to use the
generic API, or does it make sense to augment the API in some way?

It might be that the peripherals of this funky feature are soo tied to
the DMA engine that it wouldn't ever be appropriate for them to live
with a different DMA engine.  In that case, does the DMA engine API
actually benefit them, or does it result in an erosion of the API
boundary, and therefore the separation of DMA engine from DMA user?

If the net result will be that the DMA engine API boundaries are blured,
then we've lost, because we need a replacement API to do the job that we
desperately need our existing API to be doing for us.

And that's my biggest concern about nebulous undefined 'void *'
arguments across this API.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
