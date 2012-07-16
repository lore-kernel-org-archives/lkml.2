Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2GPHNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:13:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2GPHNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:13:40 -0400
Date: Mon, 16 Jul 2012 09:13:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
In-Reply-To: <1342421587.1726.49.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de> 
 <1342418828.1726.37.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
 <1342421587.1726.49.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:MQKaeAwjd6jGjmagtQNErTuXCmipufg65EzIOSD93L0
 LvNlQ7qarjIl7+L7Mw7bPaxa1EWQeGRisMerC3HnVzluZ3gIWe
 TwX5/yRjCh+WKX5s6iCjO0W3NylkeSQTW53ejjrwA6muG6zAGK
 9L3YQxuzdpebv/RTZvNUYyyHSp/y512drFnRgK4ThBwMWjhzYg
 bIlOySLAf06l6g8ALFO3LGahHe+z8VnhGIWrdcVUh57DFWMWm8
 +KYxSc6M/Qma4POO4wPYS36km25uph8y3ydJU8K0idJnUduMZo
 Ejz+EjkwWlWGJFlByJHGOC7hy5dywn2/6P0pHvWQxyloNpaoEP
 KCwdwey+5fjbd48+YUel/zSwhVB4dvasidKdwIxP5fYADxeuTL
 CmtJe3DwsjjeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Vinod Koul wrote:

> On Mon, 2012-07-16 at 08:37 +0200, Guennadi Liakhovetski wrote:
> > On Mon, 16 Jul 2012, Vinod Koul wrote:
> > 
> > > On Thu, 2012-07-05 at 12:29 +0200, Guennadi Liakhovetski wrote:
> > > > diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> > > > index a79f10a..4e83f3e 100644
> > > > --- a/include/linux/sh_dma.h
> > > > +++ b/include/linux/sh_dma.h
> > > > @@ -27,10 +27,10 @@ struct sh_dmae_slave {
> > > >   * a certain peripheral
> > > >   */
> > > >  struct sh_dmae_slave_config {
> > > > -       unsigned int                    slave_id;
> > > > -       dma_addr_t                      addr;
> > > > -       u32                             chcr;
> > > > -       char                            mid_rid;
> > > > +       int             slave_id;
> > > > +       dma_addr_t      addr;
> > > > +       u32             chcr;
> > > > +       char            mid_rid;
> > > >  }; 
> > > why would you want to keep your own slave_id and addr fields when they
> > > are already provided in struct dma_slave_config.
> > 
> > Modifying the driver's API would break all its clients.
> rightly so, they need to be moved too.

Sure, that's why patch 6/7 is "providing a migration path" for them.

> > > Also while at it, what
> > > would be the use of last tow fields, what do they describe?
> > 
> > They tell the driver how the channel has to be configured to support this 
> > specific client. They are values of two specific registers. In fact, CHCR 
> > means exactly that - CHannel Control Register.
> what exactly does the channel control register do in shdma? Should shdma
> driver deduce this value rather than client giving it?
> Same question for mid_rid?

See, e.g., arch/arm/mach-shmobile/setup-sh7372.c::sh7372_dmae_slaves[]. 
Platforms are supplying these values with shdma driver platform data, 
together with slave IDs. Them when slaves request channels and supply 
their slave IDs, the driver searches the above array, looking for the 
matching slave ID, then it uses the rest of the information in those 
structs to configure the channel for this client. Again, this is nothing 
new, this is how the driver has been functioning since a long time, this 
driver is not modifying anything there. Any changes to this procedure, 
like providing all thig information from clients themselves instead of 
keeping it with DMACs, requires these patches to be committed first.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
