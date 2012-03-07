Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab2CGMaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:30:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2CGMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:30:38 -0500
Date: Wed, 7 Mar 2012 13:30:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120307103112.GP17370@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
 <Pine.LNX.4.64.1203021341590.913@axis700.grange> <1331022623.24656.191.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
 <20120307103112.GP17370@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4G9NCcgLeZM90SI3bw8h2YE5KJyaFxsWa57B/zDvhGB
 Xc7VWW3VZ5w7KSfP6RQwASqIAQo0ItZonMJIHEVies1oAL5A2X
 Ze0nX0dulYxj7bdyh4Ff/R4F/0tC9nRaJr0apoo+U7M+7nexvl
 yHADyZIbYPjLb4UoMf9XOM3HI30lYoFsyy00mKFyT451fdYWfD
 ZSI03KfLxzuiXoT75cW6ij9uvFsCh6rR4qDjUaeNfD2PgVJ8pJ
 O2nR3naqn1dsTdr4IVXOs2IybQYWN9Tj3JAW0OOo7DpUZGMII7
 ctfbpAFYFNF/BkdGku4o2ErlZ55uD1w19Bza0PVNSEbBcuCaPP
 IR/9CAc00y3rYudyuaNaWUOmouzuR4ND7qOwjlHvcw8ZGQ1BLh
 GxF3dEO/nhIpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:

> On Wed, Mar 07, 2012 at 11:02:46AM +0100, Guennadi Liakhovetski wrote:
> > Right, I thought about virtual DMA channels, but I really hoped we 
> > wouldn't have to do that;-)
> 
> We have to do it because on many systems, we have N request signals and
> M channels, where M << N.  If we don't do that, then we run into problems
> with tying up DMA channels when they're not being used.
> 
> For example, the SA11x0 IrDA driver uses two virtual channels, one for
> receive and one for transmit.  The SA11x0 has a total of five DMA
> channels.

Huh, that certainly justifies channel virtualisation, yes.

> To waste two of them on IrDA when it's half-duplex is just
> silly.  Doing the whole 'request+free' thing is also silly because
> switching between tx and rx mode is timing-critical.
> 
> Plus, it's a lot easier for driver writers to request their DMA channels
> at the start, and hold them until they've completed - less complicated
> error checking, less latency, more throughput etc.
> 
> > Would we then also have to use virtual DMAC 
> > instances? Given that the core operates in terms of DMA-controller devices 
> > and channels and the hardware is also built around those concepts, it 
> > seems a natural choice to use a 1-to-1 correspondence.
> 
> That depends what you want from virtual DMA channels.  At the moment, most
> setups are about virtual DMA channels within a DMA device itself.  So we
> expose just the virtual DMA channels and hide the physical channels within
> the depths of the driver.
> 
> > In the sh-mobile case, AFAIK, until now we can have N DMA controllers of M 
> > types. Within each type the controllers are identical, meaning also, that 
> > all channels on them can be configured to work with all the same devices. 
> > Currently that's also what we present to the dmaengine core and to 
> > clients: N controllers. Whereas it has been suggested a couple of times, 
> > that neither the core nore clients should be bothered with specific DMA 
> > controller instances, so, we might as well just present M virtual 
> > controllers to the system - 1 of each type, each with a unique capability 
> > set?
> 
> I am aware of these kinds of setup, but at the moment I think there's
> enough of a big problem to solve with dmaengine without having it made
> even bigger.  It's already a big enough headache trying to work out
> sane ways to provide library based functionality which can be shared
> between the DMA engine drivers...
> 
> I've been chipping away at this problem since Jan 2011 and so far all
> I've managed to produce sanely is the consolidation of cookie handling.
> I have two versions of virtual channels, one based on the PL08x code
> and one based on my new SA11x0 code which will probably be shared with
> an OMAP DMA engine driver I'm working on, but I haven't looked at making
> all these drivers work with one set of virtual channel code yet (mainly
> due to crippled PL08x hardware.)

Ok, let me try to begin a yet another attempt to describe possible DMA 
channel allocation and configuration possibilites. Please, add any missing 
ones, then we can hopefully select  the best one.

1. The current scheme is:

(a) client issues
	dma_request_channel()
    with an optional filter function as parameter
(b) the core picks up a suitable from its PoV DMA controller device and a 
    channel on it and calls the filter function with that channel as an 
    argument
(c) the filter function can verify, whether that channel is suitable or 
    not (*)
(d) the client driver then can call
	dmaengine_slave_config()
    to provide any additional channel configuration information to the DMA 
    controller driver (**)
(e) if the filter has rejected this channel, the core jumps to the next 
    DMA controller instance (***)

2. (goal: eliminate filter function look-ups) proposed by Linus W

(a) client issues
	dma_request_slave_channel(dev, "MMC-RX")
(b) the dmaengine core scans a platform-provided list of channel mappings 
    and picks up _the_ correct channel (****)

3. Jassi's idea with capabilities has been rejected by Russell

4. (goal: simplify the allocation and configuration procedure) proposed by 
   myself

(a) as in (1) client issues
	dma_request_channel()
    with an additional slave configuration parameter
(b) the core picks up a suitable from its PoV DMA controller device and a 
    channel on it, (optionally) calls the filter
(c) the core calls DMA controller driver's
	.device_alloc_chan_resources()
    method, which verifies, whether the channel can be configured for the 
    requesting slave, if not, an error is returned and the next DMA 
    controller instance is checked by the core

Naturally, my preference goes for (4) because (a) I think, it is the DMA 
controller driver, that has to decide, whether the channel is suitable for 
a specific slave, (b) changes to the core are minimal, simple and 
trivially backwards-compatible, (c) the core is not cluttered with 
hw-specific channel mappings, (d) the additional call to 
dmaengine_slave_config() can be eliminated.

Thanks
Guennadi

(*) in sh-mobile case this would translate to walking a list of DMAC 
instances, provided by the platform, and verifying, whether this channel 
is suitable for this client. E.g., on sh7372 we would have (at least, 
possibly more in the future) 2 such lists: type-A - for most clients, and 
type-B - for USB controllers, then each device, willing to use DMA would 
need a pointer to one of those two lists in their platform data...

(**) on sh-mobile struct dma_slave_config provides no useful information 
for this configuration task, so, it would have to be embedded in a larger 
hw-specific struct, with the actual struct dma_slave_config almost 
completely wasted...

(***) this is actually a "lucky" decision for sh-mobile, because once one 
channel turned out to be unsuitable for a client, all other channels on 
this controller will be unsuitable too.

(****) two comments here: (1) I'm not sure it's good enough to let the 
core select a channel, I'd rather DMA controller driver do that, (2) to 
make it work with non 1-to-1 mappings virtual channels _and_ controller 
instances have to be used.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
