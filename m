Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2CGMqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:46:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36188 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2CGMqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:46:32 -0500
Date: Wed, 7 Mar 2012 12:46:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120307124620.GT17370@n2100.arm.linux.org.uk>
References: <1331022623.24656.191.camel@vkoul-udesk3> <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3> <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3> <Pine.LNX.4.64.1203070917380.19595@axis700.grange> <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange> <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:30:23PM +0100, Guennadi Liakhovetski wrote:
> 1. The current scheme is:
> 
> (a) client issues
> 	dma_request_channel()
>     with an optional filter function as parameter
> (b) the core picks up a suitable from its PoV DMA controller device and a 
>     channel on it and calls the filter function with that channel as an 
>     argument
> (c) the filter function can verify, whether that channel is suitable or 
>     not (*)
> (d) the client driver then can call
> 	dmaengine_slave_config()
>     to provide any additional channel configuration information to the DMA 
>     controller driver (**)
> (e) if the filter has rejected this channel, the core jumps to the next 
>     DMA controller instance (***)

No - if the filter function rejects the first free channel, the next free
channel on the same controller will be tried.  When all channels have
been tried, the next DMA controller is checked.

> 2. (goal: eliminate filter function look-ups) proposed by Linus W
> 
> (a) client issues
> 	dma_request_slave_channel(dev, "MMC-RX")
> (b) the dmaengine core scans a platform-provided list of channel mappings 
>     and picks up _the_ correct channel (****)

That doesn't work if you have multiple DMA controllers supporting the
same client.

> 3. Jassi's idea with capabilities has been rejected by Russell
>
> 4. (goal: simplify the allocation and configuration procedure) proposed by 
>    myself
> 
> (a) as in (1) client issues
> 	dma_request_channel()
>     with an additional slave configuration parameter
> (b) the core picks up a suitable from its PoV DMA controller device and a 
>     channel on it, (optionally) calls the filter

How can it work out what's a suitable DMA controller device?  Even knowing
where the DMA register is, the burst size and width doesn't really narrow
down the selection of the DMA controller.

> (c) the core calls DMA controller driver's
> 	.device_alloc_chan_resources()
>     method, which verifies, whether the channel can be configured for the 
>     requesting slave, if not, an error is returned and the next DMA 
>     controller instance is checked by the core

And this effectively prevents a channel being reconfigured to target a
different burst size or different transfer width without freeing and
re-requesting it.

> Naturally, my preference goes for (4) because (a) I think, it is the DMA 
> controller driver, that has to decide, whether the channel is suitable for 
> a specific slave,

We already effectively do that with many of the DMA engine drivers.  The
DMA engine drivers export their filter function which should be used when
requesting a channel (if you care about the channel you end up with.)

> (b) changes to the core are minimal, simple and 
> trivially backwards-compatible, (c) the core is not cluttered with 
> hw-specific channel mappings, (d) the additional call to 
> dmaengine_slave_config() can be eliminated.

The call to dmaengine_slave_config() actually simplifies the DMA engine
support for some drivers though, so eliminating it doesn't help.  What
would be useful is to have a helper function along these lines:

struct dma_chan *dma_request_channel_config(mask, fn, data, config)
{
	struct dma_chan *c = dma_request_channel(mask, fn, data);

	if (c) {
		if (dmaengine_slave_config(c, config)) {
			dma_release_channel(c);
			c = NULL;
		}
	}
	return c;
}

which would simplify some of the DMA engine users.  There'll still be
some though which would want to call dmaengine_slave_config() to change
the channels configuration when the mode of the device switches.

However, I don't see anything in struct dma_slave_config which could be
used to select an appropriate channel.
