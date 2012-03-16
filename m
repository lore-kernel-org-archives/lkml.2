Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682Ab2CPJgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:36:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576Ab2CPJgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:36:53 -0400
Date: Fri, 16 Mar 2012 10:36:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1331520476.4657.79.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
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
  <1331204128.4657.54.camel@vkoul-udesk3>  <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
  <1331206459.4657.59.camel@vkoul-udesk3>  <1331211513.4657.67.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203081412550.29847@axis700.grange>  <1331284918.4657.69.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203091022200.7852@axis700.grange>  <1331285959.4657.76.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:adkqttu0rardil9c/yHw4Jl3kxazWzUbgPWmKn/0Pir
 DdtLkrEvU4tr8Ybf+frGuSqV5axwinylxVVn+4f0rgEdva8P2A
 CdnJlhiSUj1la5IKLnpxdBdcbbnmnb5VGAcFOUQvERAkwcRWUC
 J8jgRMirq1Bu/iIbtz8xXnP87UqGdRnOUX1fjO9PIRLAnoqL6q
 ab5RWOX4kv7BP7v1DjkD+KNZSCL0ufJG8vAsmJTiVGA16GjSgl
 VRhSf9Ee+tOva0qV4aMitazVtCqwT6tkS4UmAFiWSQ9p8iX/ME
 oaOTlCwO+psiKEMt/e+XR/v3A9nPWLNXsRzUmnNndsZZGJUhjN
 S2VE5rxO0oV7wBalUX+1CMnqzaf4WxHEOztONBgp6Zf2DWy8cT
 J2AZOFsw0yGjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Vinod Koul wrote:

> On Fri, 2012-03-09 at 13:20 +0100, Guennadi Liakhovetski wrote:
> > It can be made to work as long as there's only one DMAC group with 
> > configurable channels and all other DMACs are dedicated to specific 
> > peripherals, yes. I don't know whether there are already now or are 
> > approaching any platforms with multiple reconfigurable groups. 
> And that is what I am talking about.
> 
> Having specific channel mapping given by platform for all channels which
> are to be used dedicated. And a pool of channels which can be used by
> anyone (if they can be) on a platform.
> 
> Does this proposal sound good for others as well. I think we can target
> this for next merge cycle, we are too late for the current one.

Ok, let me try to summarise, what this would mean for sh-mobile:

1. this proposal introduces a new special case: with or without a mapping, 
that will have to be handled in affected client and DMA controller 
drivers. E.g., on sh-mobile some devices might on some systems use 
channels from "general purpose" DMA controllers (no mapping), on other 
systems it will be a dedicated controller (fixed mapping).

2. this will break, if we get more than 1 "general purpose" type with 
different supported client sets. So, we develop a new API with a 
pre-programmed limitation.

3. this will mean a substantial driver and platform code modification. 
Nothing super-complex, but still some.

4. we'll need a 3-stage channel allocation / configuration: request, 
filter, config. Whereas with my configuration-parameter proposal it's just 
one stage: allocate-and-configure.

So, yes, this would be doable, but it doesn't look like a very good 
solution to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
