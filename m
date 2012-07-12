Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2GLIfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:35:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab2GLIfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:35:03 -0400
Date: Thu, 12 Jul 2012 10:34:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Paul Mundt <lethal@linux-sh.org>
cc: Magnus Damm <magnus.damm@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-sh@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] dma: sh: provide a migration path for slave drivers
 to stop using .private
In-Reply-To: <20120712040018.GB11440@linux-sh.org>
Message-ID: <Pine.LNX.4.64.1207121025020.19866@axis700.grange>
References: <1341418663-24432-1-git-send-email-g.liakhovetski@gmx.de>
 <1341418663-24432-4-git-send-email-g.liakhovetski@gmx.de>
 <CANqRtoRz2NF6BEEYcy_BwZ7Hm5EF9zP2Z0eoQcbxaSfUuc2i9Q@mail.gmail.com>
 <20120712040018.GB11440@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:LanSnM8X/ZxxUyac6DknIdu8B8E3vO6hYNh6FwCyiBH
 tuYjqmvH+/l2mvJbVbqoX4qyeK+0la1XgJxA5HHG8mmfZtLGIg
 1tWEcyyPu0RGo2dupCVTBh/H6nJgP9fdfuCsY6iec6QZ25qgC7
 1OMyZtxT+U6EctOSIX9o5uPTIflvOAnToBiCmcjhwYgK65I/tj
 zDQ+J3m/PX7vLMUIJHn38QLWn/8S6BN247KlaKQhRw1R0+by/S
 Ccm8CFDY25mFKQv5WGD0bY9e6saF+73NZWL1zWqK7r+jyXIjsV
 rDCvl+QeSwGW4C8ARIUKQ0l23+6e76Ay9/AeteI/AkDSzyVId4
 NpLTRd6NvbKFLV4y4yfyrCvK8XQYgxo7AWCkMrAWK+zjPbJClB
 Qh0SUz9Tn2c7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, Magnus

On Thu, 12 Jul 2012, Paul Mundt wrote:

> On Thu, Jul 12, 2012 at 06:55:32AM +0900, Magnus Damm wrote:
> > Hi Guennadi,
> > 
> > [CC Paul]
> > 
> > On Thu, Jul 5, 2012 at 1:17 AM, Guennadi Liakhovetski
> > <g.liakhovetski@gmx.de> wrote:
> > > This patch extends the sh dmaengine driver to support the preferred channel
> > > selection and configuration method, instead of using the "private" field
> > > from struct dma_chan. We add a standard filter function to be used by
> > > slave drivers instead of implementing their own ones, and add support for
> > > the DMA_SLAVE_CONFIG control operation, which must accompany the new
> > > channel selection method. We still support the legacy .private channel
> > > allocation method to cater for a smooth driver migration.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > 
> > Thanks for your efforts on this. Something that caught my eye in this
> > patch is this portion:
> > 
> > +bool shdma_chan_filter(struct dma_chan *chan, void *arg);
> > 
> > If we would use this function in our DMA Engine slave drivers (MMCIF,
> > SDHI, SCIF, FSI, SIU and so on) then wouldn't we add a strict
> > dependency on this symbol provided by this particular DMA Engine
> > driver implementation for the DMAC hardware (that your patch
> > modifies)?

This dependency is nothing new. Now all those drivers depend on shdma too, 
though, in a softer way - by using struct sh_dmae_slave. That struct is 
defined in include/linux/sh_dma.h and so we _could_ reuse it between 
several sh(-mobile) DMAC variants, but IIUC, there's currently no truly 
reliable way to make DMA slave drive drivers completely generic. And this 
will remain this way as long as DMA channel filtering is relying on an 
opaque argument, specific to each DMAC driver.

Russell has shown in a mail, how this hard dependency can be sort of 
eliminated by passing a string as a filter parameter. But then again - 
this _only_ works with drivers, that use this method. Similarly any non 
hardware-specific type could be used, e.g., an integer slave ID.

Moreover, I've been told explicitly, that exporting filter functions from 
respective DMAC drivers _is_ the correct way to use the current API...

> > And what do we do if we want to use the same DMA Engine slave driver
> > with a different DMA Engine driver implementation?
> > 
> > From my point of view, there must be some better way to not have such
> > tight dependencies between the DMA Engine slave consumer and the DMA
> > Engine driver. Not sure what that looks like though. This symbol
> > dependency is pretty far from great IMO.
> > 
> I vaguely recall this coming up before, and it wasn't acceptable then
> either.
> 
> We will by no means be adding driver-specific hooks in to other drivers
> that really couldn't care less what the underlying DMA engine driving
> them is.
> 
> We already have CPUs with different DMA engines that can be used by the
> same drivers. As I said the last time, this needs to be fixed in the
> dmaengine framework, period.

Sure, that's what my DMA mux-driver idea [1] is aiming to achieve.

Thanks
Guennadi

[1] http://article.gmane.org/gmane.linux.ports.arm.omap/80357
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
