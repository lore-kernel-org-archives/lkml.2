Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2CGNuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:50:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2CGNuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:50:08 -0500
Date: Wed, 7 Mar 2012 14:49:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120307124620.GT17370@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
References: <1331022623.24656.191.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
 <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
 <20120307124620.GT17370@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:biEX8FWHFt6bBPy5Z0wSAY9uI8+MHkvBiA3zG3Sih5q
 QuUzP6jL+rw4o0XZDbfCRFgDQEbMz3Jh8v4F20RF1JUjTKrBoi
 NlBotMf6s3WSQwslWMzriS47DdFTfJc3jkdr0lXsCyYpDlsRmg
 q71PXrfhfHGwG6kfmMHiMqVVYwRreIpstjXlOzGSXyVY0sCg4r
 N5y+yLmDHcQEN+XbqyBQRlIozduTnp9mTF3/DdnQgrIQvxy1o9
 drAP/9ebEL2Z2VBlLRhku6ewyPGP3CN+w0FbBWIx8pgwPkVllB
 DNFBwQD0Hn3jvaIiwLouSl1H8dvCO5ZrVRrWzsPdiXBxHYBCm+
 Zoppwt9ZvfhIs5i5Zo/LUIIZpjzJbXgCWYkyuik7IhswOm1zxg
 AhYfOvCFNrp6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:

> On Wed, Mar 07, 2012 at 01:30:23PM +0100, Guennadi Liakhovetski wrote:
> > 1. The current scheme is:
> > 
> > (a) client issues
> > 	dma_request_channel()
> >     with an optional filter function as parameter
> > (b) the core picks up a suitable from its PoV DMA controller device and a 
> >     channel on it and calls the filter function with that channel as an 
> >     argument
> > (c) the filter function can verify, whether that channel is suitable or 
> >     not (*)
> > (d) the client driver then can call
> > 	dmaengine_slave_config()
> >     to provide any additional channel configuration information to the DMA 
> >     controller driver (**)
> > (e) if the filter has rejected this channel, the core jumps to the next 
> >     DMA controller instance (***)
> 
> No - if the filter function rejects the first free channel, the next free
> channel on the same controller will be tried.  When all channels have
> been tried, the next DMA controller is checked.

Right, sorry, I confused it with an error, returned by DMA driver's 
.device_alloc_chan_resources()

> > 2. (goal: eliminate filter function look-ups) proposed by Linus W
> > 
> > (a) client issues
> > 	dma_request_slave_channel(dev, "MMC-RX")
> > (b) the dmaengine core scans a platform-provided list of channel mappings 
> >     and picks up _the_ correct channel (****)
> 
> That doesn't work if you have multiple DMA controllers supporting the
> same client.

Right, that's why I was against it, but it would work with virtual 
channels (and virtual devices)?

> > 3. Jassi's idea with capabilities has been rejected by Russell
> >
> > 4. (goal: simplify the allocation and configuration procedure) proposed by 
> >    myself
> > 
> > (a) as in (1) client issues
> > 	dma_request_channel()
> >     with an additional slave configuration parameter
> > (b) the core picks up a suitable from its PoV DMA controller device and a 
> >     channel on it, (optionally) calls the filter
> 
> How can it work out what's a suitable DMA controller device?

It doesn't, it will have to probe all DMA devices, until 
.device_alloc_chan_resources() succeeds in (c) below.

> Even knowing
> where the DMA register is, the burst size and width doesn't really narrow
> down the selection of the DMA controller.
> 
> > (c) the core calls DMA controller driver's
> > 	.device_alloc_chan_resources()
> >     method, which verifies, whether the channel can be configured for the 
> >     requesting slave, if not, an error is returned and the next DMA 
> >     controller instance is checked by the core
> 
> And this effectively prevents a channel being reconfigured to target a
> different burst size or different transfer width without freeing and
> re-requesting it.

Cannot dmaengine_slave_config() be used for that?

> > Naturally, my preference goes for (4) because (a) I think, it is the DMA 
> > controller driver, that has to decide, whether the channel is suitable for 
> > a specific slave,
> 
> We already effectively do that with many of the DMA engine drivers.  The
> DMA engine drivers export their filter function which should be used when
> requesting a channel (if you care about the channel you end up with.)

This is one of the things I'd like to avoid - having to extend the 
standard API with hardware-specific methods... It's already bad enough, 
that client drivers often have to use DMA-controller specific types to 
configure transfers. Ideally I'd prefer to have 0 DMA device knowledge in 
client drivers. If needed, they should just pass DMA device data from 
platform code to the DMA controller driver as opaque handles.

> > (b) changes to the core are minimal, simple and 
> > trivially backwards-compatible, (c) the core is not cluttered with 
> > hw-specific channel mappings, (d) the additional call to 
> > dmaengine_slave_config() can be eliminated.
> 
> The call to dmaengine_slave_config() actually simplifies the DMA engine
> support for some drivers though, so eliminating it doesn't help.

Right, sorry, I didn't mean, that I'd like to get rid of it completely. I 
just meant, that being forced to use it for every slave channel allocation 
isn't very nice.

> What
> would be useful is to have a helper function along these lines:
> 
> struct dma_chan *dma_request_channel_config(mask, fn, data, config)
> {
> 	struct dma_chan *c = dma_request_channel(mask, fn, data);
> 
> 	if (c) {
> 		if (dmaengine_slave_config(c, config)) {
> 			dma_release_channel(c);
> 			c = NULL;
> 		}
> 	}
> 	return c;
> }

Hm, yeah... That seems like an over-complication to me: to "just" allocae 
a channel you cann dma_request_channel(), which scans your devices and 
channels on them, calls your filter, calls the DMA controller driver's 
allocation method, only to eventually call dmaengine_slave_config() and 
see it fail, after which you release the channel and start anew...

Ah, there's the problem actually: you cannot try to find another channel, 
if dmaengine_slave_config() fails - the scan will restart from the 
beginning and you end up with the same failure again. So, we cannot rely 
on dmaengine_slave_config() to be the first instance, where the DMA 
controller driver actually gets the channel configuration and has a chance 
to verify its suitability.

> which would simplify some of the DMA engine users.  There'll still be
> some though which would want to call dmaengine_slave_config() to change
> the channels configuration when the mode of the device switches.
> 
> However, I don't see anything in struct dma_slave_config which could be
> used to select an appropriate channel.

That's also my problem with it, and the reason, why I suggested, that it 
has to be embedded in a hardware-specific channel configuration type.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
