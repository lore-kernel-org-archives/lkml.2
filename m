Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab2CSLeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:34:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:47302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2CSLen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:34:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120579251"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	 <20120307093026.GM17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	 <20120307103112.GP17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	 <20120307124620.GT17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	 <20120307142634.GA18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	 <20120307162755.GB18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	 <1331188201.4657.51.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	 <1331204128.4657.54.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	 <1331206459.4657.59.camel@vkoul-udesk3>
	 <1331211513.4657.67.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	 <1331284918.4657.69.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	 <1331285959.4657.76.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	 <1331520476.4657.79.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	 <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 17:09:04 +0530
Message-ID: <1332157144.7180.7.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 11:16 +0100, Linus Walleij wrote:
> On Fri, Mar 16, 2012 at 10:36 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> 
> > Ok, let me try to summarise, what this would mean for sh-mobile:
> >
> > 1. this proposal introduces a new special case: with or without a mapping,
> > that will have to be handled in affected client and DMA controller
> > drivers. E.g., on sh-mobile some devices might on some systems use
> > channels from "general purpose" DMA controllers (no mapping), on other
> > systems it will be a dedicated controller (fixed mapping).
> >
> > 2. this will break, if we get more than 1 "general purpose" type with
> > different supported client sets. So, we develop a new API with a
> > pre-programmed limitation.
> 
> I fail to see why this would not be solved by a one-to-many mapping?
> 
> Flag for each device which channels it may use in a mapping
> table in platform data or device tree, I don't see the problem.
> 
> You don't even have to specify that on a per-channel basis if
> you can come up with something more clever in the mapping
> table, such as "this device can use any channel on this DMAC,
> and channels 1-7 on that DMAC" - no problem?
Thats why added channel number to your proposal :)
> 
> > 3. this will mean a substantial driver and platform code modification.
> > Nothing super-complex, but still some.
> 
> Big deal. Refactoring is fun... ;-)
> 
> > 4. we'll need a 3-stage channel allocation / configuration: request,
> > filter, config.
> 
> In my world: channel request with *NO* filter function.
> 
> Filter functions are part of the problem. So we refactor these
> away as part of this change. That's the whole point...
> 
> The core gathers information from the platform and the
> DMAC driver(s) to build up the constraints necessary to
> hand out workling channels to each device that request
> one.
> 
> And Russell IIRC already suggested a request-and-config
> channel inline for the simple cases, and if you still need to
> explicitly runtime-reconfigure then that's for a good
> reason.
> 
> > Whereas with my configuration-parameter proposal it's just
> > one stage: allocate-and-configure.
> 
> For one specific hardware, yes. For DMAengine at large
> and the majority of the drivers, no.
right, and that is my main concern.
> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

