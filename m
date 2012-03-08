Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2CHMg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:36:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab2CHMg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:36:57 -0500
Date: Thu, 8 Mar 2012 13:36:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: Vinod Koul <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <CACRpkdY4y6Dj+G0zNoeY5DGWW1CRXez4pVCju2SXc=9oNyzdGw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1203081304300.29847@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
 <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
 <20120307124620.GT17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
 <20120307142634.GA18787@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
 <20120307162755.GB18787@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
 <1331188201.4657.51.camel@vkoul-udesk3> <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
 <CACRpkdY4y6Dj+G0zNoeY5DGWW1CRXez4pVCju2SXc=9oNyzdGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:jBm2Nr1WFmv5JpVPFL8qFTMQUQ8Ksys4KI5GMNq0siX
 rLFRMl3n4c+hA5X42yfrqZoeWY4rZqJZCjFneK95NFkS7nqeGZ
 CISwmyr99HDOP3D7Dy0EassL6D+lihKFeGh3XKTLuAPk9olNan
 I0iNTCCuf5YkQY9+BSgm6jREaQMykowgOjqY7ai3vt2vQNVLwM
 J2C7tfY66wdXSYE2Fj33xsN9NK5Syd6w/Q9Q84sGzOEjqjQ8lx
 citp+5uEiAK086ZWaj92xQrgtQmDTSCrvr3GmejMwuZoCUGto/
 P1CCz7Bofs7Q8Hov06/718ZfkR69zqIn1c1J/9rl86CpDHCFhF
 4vCuUAmowJzo4nU5zMlviunODjmwGVEiEO/jBxIIH4zRoMUQKY
 nidsPbmc3cLAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Linus Walleij wrote:

> On Thu, Mar 8, 2012 at 11:16 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> 
> >(...) our case can be handled _very_ easily:
> >
> > 1. a client requests a channel of a specific type
> > 2. one of channels of that type, residing on one of compatible
> >   controllers, is allocated, configured and handed in to the client
> >
> > That's it. No filtering, no post-allocation configuration - at least so
> > far. And penalising such a simple case by forcing it to use virtual
> > channels and filter through some unnatural mappings doesn't seem very
> > productive to me.
> 
> But you do realize that this increases the complexity of the
> dmaengine and means more maintenance burden for the
> subsystem maintainer that will after this have to think in two
> different sematic ways about channel retrieveal - yeah this one
> passes that as parameter and this one has a config struct
> provided, then this one use a filter function still - etc.

Yes, I do. This is why I've marked it an RFC - I'm open to a discussion, 
what's the best solution to suit us all.

> That is, of course, unless you convert all the existing DMA
> engines to do it the same way, then it's redesigning proper.

No, don't think it would be reasonable or maybe even possible to 
completely remove the filter. At least this wasn't an (immediate) goal of 
this patch. However, if we decide, that in principle such an API extension 
should make filters redundant, we can gradually over time look at various 
drivers and get rid of the filters.

> In that case I am much more positive to the change, even
> if it doesn't take us all the way to the new channel mappings
> we want to have.
> 
> You haven't stated whether you will go in and rewrite the other
> drivers to use this scheme or whether you will just add this one
> kludge to handle this one DMA controller, then just update
> all others to ignore the parameter. (You'd obviously have to
> do that to get this to even compile...)
> 
> So the *proper* way to refactor to using this scheme would
> be to introduce this new scheme *and* remove the filter
> function from all the other drivers and DMA engine at large,
> so it's not needed anymore. Which means a bit of refactoring.
> 
> Currently drivers have to pass a filter function from
> platform data to filter out relevant channels, and with
> the new style (this patch plus removing all filter functions)
> it will be passing something else instead. That's all
> fine, and actually an improvement, because passing around
> a filter function is not as good as passing some struct
> with data.

Agree in principle, but I don't think I can claim, that I'm sufficiently 
certain, that all drivers can be reasonably converted. At least, thinking 
again about Russell's approach to implementing filters in DMA device 
drivers themselves, it seems to me, it should indeed be possible to quite 
easily just pass the same argument, that's currently passed to the filter 
function, to the allocation request instead and call the filter internally 
in .device_alloc_chan_resources() in the very beginning instead.

> So does RFC patch mean you will fix this up for everyone
> or does it mean something else?

I currently count almost 40 calls to dma_request_channel() and around 
20-25 DMA drivers in the kernel... So, I'm not sure whether it's 
reasonable to try to pull such a change globally over one release cycle.

Thanks
Guennadi

> If you're not also planning to get rid of the filter functions
> for all other drivers I don't see this going anywhere right
> now. It is not beneficial for dmaengine, the only benefit
> is one more kludgy driver to maintain.
> 
> Yours,
> Linus Walleij

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
