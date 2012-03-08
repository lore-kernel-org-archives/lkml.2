Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2CHLWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:22:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2CHLWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:22:04 -0500
Date: Thu, 8 Mar 2012 12:22:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1331204128.4657.54.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3> 
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange> 
 <20120307093026.GM17370@n2100.arm.linux.org.uk>  <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
  <20120307103112.GP17370@n2100.arm.linux.org.uk> 
 <Pine.LNX.4.64.1203071149190.19595@axis700.grange> 
 <20120307124620.GT17370@n2100.arm.linux.org.uk>  <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
  <20120307142634.GA18787@n2100.arm.linux.org.uk> 
 <Pine.LNX.4.64.1203071602330.19595@axis700.grange> 
 <20120307162755.GB18787@n2100.arm.linux.org.uk>  <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
  <1331188201.4657.51.camel@vkoul-udesk3>  <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
 <1331204128.4657.54.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:o9hmeHIcejlvBTsch9/e+uj7aw19/Ig8/UA/o5dNgcJ
 cc/bjKgHLqS9RWeCuN+oIrCnr3g/nCnM5OcqqAIk/xJ7nRPrxf
 b7BVRCCtFysUClW3qEw2OGVoI7MbL0K7QAJBTrsLycxZq14sOZ
 N3xST3cQCdqN6aSvxx6MUghnR6ZDNIXZkVKOLL+LktMCwtzHo9
 s+QH0Y2KSzLFRc37K9ZRg4KKmLKFTl3Y8hU3WiUAZaHedXAla9
 62t8f8skYWcR7hxz93plxMW7ywgWDFQLGLIbeUOAmgQGqrh9Zh
 5EbxjTK3Uap2YngPxFNEuj+kn8i4nAf1RzlTEJRxttFLH3LlwS
 9nNmVkddeArOB13g5p4OkHnU0yFBj0fO7ehv3eS6KRIUVfs7CW
 LBfBGyq5vOhdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Vinod Koul wrote:

> On Thu, 2012-03-08 at 11:16 +0100, Guennadi Liakhovetski wrote:
> > I still have the impression, that my specific use-case (sh-mobile), where 
> > channels can be freely configured for use by _ANY_ client on one of 
> > _SEVERAL_ DMAC instances, is not fully understood or taken into account. 
> > For this driver any kind of fixed mapping means, that we'd have to use 
> > both virtual channels and controllers, adding _a lot_ of complexity to the 
> > DMAC driver and making the dmaengine core just an "obfuscation layer." 
> > Yes, I remember Russell proposing core helpers for this. They would help, 
> > but (1) when would they be available, (2) how well would they be suitable 
> > for us, (3) they'd take the coding / maintainance burden away, but 
> > wouldn't reduce complexity and run-time overhead. 
> Lets try to address you case as well.
> On a typical platform

Let's take the mackerel board with the sh7372 SoC. it's not the state of 
the art, but that's what I'm currently working with and it should give us 
a good enough idea

> 1) how many dma controllers you have?

currently supported 5 of 3 types (3 of type A, 1 of each of the types B 
and C), all handled by the same driver

> 2) how many clients you have

huh... many. Maybe like 20 or more, and more, that are not yet supported, 
using type A, and 1 for each of types B and C

> 3) which client can use what controller channel? How is mapping decided,
> do you have a mux, is it hard wired by soc designers,....?

In general - with all the current sh-mobile hardware, that I'm aware of - 
there can be several controller instances on an SoC of each controller 
type. Inside each type all instances and all channels are freely 
configurable. So, of 20 Type A clients they can use any channels on any 
one of the 3 type A controllers. Types B and C are "degenerate" cases, 
there clients are practically hard-wired to a specific DMA controller.

So, we don't have to decide on mappings for type A. We just pick up any 
free channels on any controller and configure them accordingly. Whether 
there's a mux somewhere - you can say so, but it's all inside the SoC, and 
it's configured automatically ones you configure a physical channel to 
serve a specific client.

> Can you pls give a description so that we ensure all models fit in the
> final solution?

That's what I've been trying to do since several days now... I've been 
saying "multiple controllers with multiple channels all freely 
configurable for any device from a list" again and again... Seems I'm 
speaking some strange language, that noone understands.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
