Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2CGKdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:33:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60849 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2CGKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:33:43 -0500
Date: Wed, 7 Mar 2012 10:31:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120307103112.GP17370@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange> <Pine.LNX.4.64.1203021341590.913@axis700.grange> <1331022623.24656.191.camel@vkoul-udesk3> <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3> <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3> <Pine.LNX.4.64.1203070917380.19595@axis700.grange> <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 11:02:46AM +0100, Guennadi Liakhovetski wrote:
> Right, I thought about virtual DMA channels, but I really hoped we 
> wouldn't have to do that;-)

We have to do it because on many systems, we have N request signals and
M channels, where M << N.  If we don't do that, then we run into problems
with tying up DMA channels when they're not being used.

For example, the SA11x0 IrDA driver uses two virtual channels, one for
receive and one for transmit.  The SA11x0 has a total of five DMA
channels.  To waste two of them on IrDA when it's half-duplex is just
silly.  Doing the whole 'request+free' thing is also silly because
switching between tx and rx mode is timing-critical.

Plus, it's a lot easier for driver writers to request their DMA channels
at the start, and hold them until they've completed - less complicated
error checking, less latency, more throughput etc.

> Would we then also have to use virtual DMAC 
> instances? Given that the core operates in terms of DMA-controller devices 
> and channels and the hardware is also built around those concepts, it 
> seems a natural choice to use a 1-to-1 correspondence.

That depends what you want from virtual DMA channels.  At the moment, most
setups are about virtual DMA channels within a DMA device itself.  So we
expose just the virtual DMA channels and hide the physical channels within
the depths of the driver.

> In the sh-mobile case, AFAIK, until now we can have N DMA controllers of M 
> types. Within each type the controllers are identical, meaning also, that 
> all channels on them can be configured to work with all the same devices. 
> Currently that's also what we present to the dmaengine core and to 
> clients: N controllers. Whereas it has been suggested a couple of times, 
> that neither the core nore clients should be bothered with specific DMA 
> controller instances, so, we might as well just present M virtual 
> controllers to the system - 1 of each type, each with a unique capability 
> set?

I am aware of these kinds of setup, but at the moment I think there's
enough of a big problem to solve with dmaengine without having it made
even bigger.  It's already a big enough headache trying to work out
sane ways to provide library based functionality which can be shared
between the DMA engine drivers...

I've been chipping away at this problem since Jan 2011 and so far all
I've managed to produce sanely is the consolidation of cookie handling.
I have two versions of virtual channels, one based on the PL08x code
and one based on my new SA11x0 code which will probably be shared with
an OMAP DMA engine driver I'm working on, but I haven't looked at making
all these drivers work with one set of virtual channel code yet (mainly
due to crippled PL08x hardware.)
