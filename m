Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2IUSwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:52:24 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53543 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2IUSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:52:21 -0400
Date: Fri, 21 Sep 2012 14:54:05 -0400
From: Matt Porter <mporter@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "S, Venkatraman" <svenkatr@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the EDMA
 DMAC
Message-ID: <20120921185405.GK16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-9-git-send-email-mporter@ti.com>
 <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
 <CANfBPZ-h7MD4X_NRYfwOmMnEyOKy0bTNNLNRmdbef2pe=2aHyg@mail.gmail.com>
 <20120921171840.GB10409@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921171840.GB10409@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 08:18:41PM +0300, Felipe Balbi wrote:
> On Fri, Sep 21, 2012 at 10:47:30PM +0530, S, Venkatraman wrote:
> > On Fri, Sep 21, 2012 at 10:45 PM, S, Venkatraman <svenkatr@ti.com> wrote:
> > > On Thu, Sep 20, 2012 at 8:13 PM, Matt Porter <mporter@ti.com> wrote:
> > >> The EDMA DMAC has a hardware limitation that prevents supporting
> > >> scatter gather lists with any number of segments. Since the EDMA
> > >> DMA Engine driver sets the maximum segments to 16, we do the
> > >> same.
> > >>
> > >> Note: this can be removed once the DMA Engine API supports an
> > >> API to query the DMAC's segment limitations.
> > >>
> > >
> > > I wouldn't want to bind the properties of EDMA to omap_hsmmc as this patch
> > > suggests. Why don't we have a max_segs property, which when explicitly specified
> > > in DT, will override the default ?
> > 
> > If you are adventurous, this can be a generic mmc DT binding instead
> > of restricting it to OMAP.
> 
> I say if it's a limitation in the DMAC, then DMAC's driver should handle
> it, no ? Meaning that in this case you would copy from one multi-segment
> sg into a one-segment sg and when transfer is complete, before calling
> user's callback, copy data the other way around (?)

With this DMAC, we would have to do a CPU-based copy or a series of
smaller DMA-based 16 segment copies with completion interrupts in between.

The reason the EDMA DMA Engine driver sets this limit is that we have
a hardware limitation preventing setting up a large multi-segment
transfer. The limitation is set by how many EDMA PaRaM slots are
available (varies based on how the hwmod is instantiated) but on AM335x
it's 256. You can't use all of those for just one slave device and so
the EDMA dmaengine driver arbitrarily hardcodes (atm) 16 as the max
any one channel can claim.  Even if you could use all of them, it's
common for an unrestricted scatter gather transfer to exceed even our
best case hardware limitation.

This is a case where asking the DMA Engine driver to handle any length
SG is going to result in a big peformance hit, since the MMC subsystem
provides this hook for a reason, we just need the proper DMA Engine API
to find out how to set it.

So I guess I'm going to need to write up an API proposal unless Vinod
has already been thinking about this...

-Matt
