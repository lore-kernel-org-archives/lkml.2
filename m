Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2CGO0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:26:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45081 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab2CGO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:26:48 -0500
Date: Wed, 7 Mar 2012 14:26:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120307142634.GA18787@n2100.arm.linux.org.uk>
References: <1331035739.24656.201.camel@vkoul-udesk3> <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3> <Pine.LNX.4.64.1203070917380.19595@axis700.grange> <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange> <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange> <20120307124620.GT17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:49:25PM +0100, Guennadi Liakhovetski wrote:
> On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:
> > What
> > would be useful is to have a helper function along these lines:
> > 
> > struct dma_chan *dma_request_channel_config(mask, fn, data, config)
> > {
> > 	struct dma_chan *c = dma_request_channel(mask, fn, data);
> > 
> > 	if (c) {
> > 		if (dmaengine_slave_config(c, config)) {
> > 			dma_release_channel(c);
> > 			c = NULL;
> > 		}
> > 	}
> > 	return c;
> > }
> 
> Hm, yeah... That seems like an over-complication to me: to "just" allocae 
> a channel you cann dma_request_channel(), which scans your devices and 
> channels on them, calls your filter, calls the DMA controller driver's 
> allocation method, only to eventually call dmaengine_slave_config() and 
> see it fail, after which you release the channel and start anew...

The point is _not_ that this uses dmaengine_slave_config() to find a
channel at all.  As I already said, there's nothing in dma_slave_config
which _could_ be used to decide whether a channel is suitable or not.

So to try to filter on the slave configuration is a pure red herring.
None of the DMA controllers I have access to (whether they be working
or not) could make any kind of decision about whether a particular
channel is suitable for the peripheral by looking at the dma_slave_config
structure - it's very much the case that the decision would be that
'any channel will do', which in reality it won't because there's other
information required to make the decision about which virtual channel
should be used.  Specifically, the request signal information.

Even more specifically, the request signal information may not be _just_
the request signal on the DMA controller but also incorporate an
external MUX like on the Realview boards (which pl08x handles itself.)

I do not see any milage in trying to select a channel based on "I want
a DMA engine to access register X, width Y, burst size Z."  As far as
I can see, the common situation is that there's nothing in that set of
information which would be useful to chose a specific channel on a
DMA engine.
