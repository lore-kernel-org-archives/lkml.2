Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2GPKzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:55:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2GPKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:55:08 -0400
Date: Mon, 16 Jul 2012 12:55:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
In-Reply-To: <1342434256.1726.57.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207161249260.18978@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de> 
 <1342418828.1726.37.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
  <1342421587.1726.49.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
  <1342427305.1726.50.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
  <1342431452.1726.54.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161155280.12302@axis700.grange>
 <1342434256.1726.57.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:QcadsW7GALII0U5Ywa8SHl4zC2BJapinZXjWVJYcZ5Z
 oT/zi9iLDzuvmwFCqWZzHcE9litm0o9MWAePFdKGWnZs8iiD5h
 I3lpB96JMr1QCp7r0/SrgP8OnPlFgXBHY4SN2PGUZ3z2Wg3S4u
 lvBiL/J8qwHw9eTDz4dGH7/DkYG4QP0f34zKGXgeJypGe3ja6p
 sl4Pu83UZ/2jDGTbJWEWAl1eK1tanry42Juw5is6nLL1rDV9hN
 gGv6+e5I9vJJiypaHsTJ20Ve6+jVIK0yA88lj6grAI76pWlOhi
 R+EAlb24IXk3K4cUY8RGqVUuLHaMDg61egGLTZv1WJ3C9vF32t
 TpuwcoO8UTDoT+/VOtKtuWMTlP07IrZYXW0U9QRqnI8OMHIoBs
 Dbk0DJgHi5rKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Vinod Koul wrote:

> On Mon, 2012-07-16 at 12:01 +0200, Guennadi Liakhovetski wrote:
> > On Mon, 16 Jul 2012, Vinod Koul wrote:
> > 
> > > On Mon, 2012-07-16 at 10:47 +0200, Guennadi Liakhovetski wrote:
> > > > > I want to know what does ccr and mid_rid mean to dmac here?
> > > > 
> > > > CHCR contains a few fields, some enable various interrupt sources, some 
> > > > specify repeat- and renew-modes, others yet specify transfer size, source 
> > > > and destination address-modes (incrementing, constant, decrementing), 
> > > > others yet select a DMA client category (slave / memcpy / ...), and a 
> > > > transfer flag. Some of these fields could be calculated, others are 
> > > > pre-defined for various slaves, the exact layout of those fields can also 
> > > > vary between SoCs.
> > > I do not understand how clients would provide these values. 
> > > For pre-defined values, they should be dmac property why should client
> > > like spi or mmc have clue about it?
> > > 
> > > For others like you mentioned, i guess they could be easily calculated,
> > > right?
> > > 
> > > > MID_RID is actually a slave-selector, it contains a magic value, that 
> > > > cannot be calculated. 
> > > and again, how does client know this?
> > 
> > I might be misunderstanding you, but from earlier discussions I got an 
> > impression, that the DMAC should know nothing about clients, i.e., should 
> > receive no client-specific information from its platform data. Instead 
> > clients should provide it when configuring the channel. If this is 
> > correct, then the preferred way would be to specify these values in client 
> > platform data and then pass it to the DMAC with slave-config calls? Or 
> > have I misunderstood you and this per-client information should be kept in 
> > DMAC platform data?
> You haven't misunderstood me. dmacs should not know of client data and
> should be client agnostic. 
> 
> BUT, are these parameters ccr and mid_rid client data, i do not think
> so, they seem to be dmac controller parameters which you need to
> configure channel or is that not the case. If not why bother passing
> them to dmac?

Yes, that's right - these values have to be written to DMAC channel 
configuration registers, so, we do not have to change anything, those 
values can remain DMAC parameters and be passed to it directly from 
platform data.

> Either way something looks fishy to me.

You can always tell me what you don't like about the driver, but I don't 
see why this specific patch should cause any problem - it only changes the 
type of the slave-id variable from unsigned to signed to be able to pass 
negative error values in it too.

> > I.e., in both cases magic values are provided by platforms, the only 
> > difference is - either keep them in DMAC platform data or move them in 
> > each individual DMA client platform data.
> > 
> > Yes, some CHCR fields can be calculated, but location and width of those 
> > fields might vary between DMAC versions, so, they will have to be passed 
> > with DMAC platform data. But this definitely can be done in the future.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
