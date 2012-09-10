Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2IJUTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:19:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57164 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab2IJUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:19:11 -0400
Date: Mon, 10 Sep 2012 16:20:17 -0400
From: Matt Porter <mporter@ti.com>
To: Daniel Mack <zonque@gmail.com>
Cc: vinod.koul@intel.com, cjb@laptop.org, grant.likely@secretlab.ca,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v3 0/3] DaVinci DMA engine conversion
Message-ID: <20120910202017.GL27758@beef>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
 <503B933F.2030803@gmail.com>
 <5048A441.3010109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5048A441.3010109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:25:21PM +0200, Daniel Mack wrote:
> Hi Matt,
> 
> On 27.08.2012 17:33, Daniel Mack wrote:
> > On 23.08.2012 03:09, Matt Porter wrote:
> >> This series begins the conversion of the DaVinci private EDMA API
> >> implementation to a DMA engine driver and converts two of the three
> >> in-kernel users of the private EDMA API to DMA engine.
> >>
> >> The approach taken is similar to the recent OMAP DMA Engine
> >> conversion. The EDMA DMA Engine driver is a wrapper around the existing
> >> private EDMA implementation and registers the platform device within
> >> the driver.  This allows the conversion series to stand alone with just
> >> the drivers and no changes to platform code. It also allows peripheral
> >> drivers to continue to use the private EDMA implementation until they
> >> are converted.
> >>
> >> The EDMA DMA Engine driver supports slave transfers only at this time. It
> >> is planned to add cyclic transfers in support of audio peripherals.
> >>
> >> There are three users of the private EDMA API in the kernel now:
> >> davinci_mmc, spi-davinci, and davinci-mcasp.  This series provides DMA
> >> Engine conversions for the davinci_mmc and spi-davinci drivers which
> >> use the supported slave transfers.
> >>
> >> This series has been tested on an AM18x EVM and Hawkboard with
> >> driver performance comparable to that of the private EDMA API
> >> implementations. Both MMC0 and MMC1 are tested which handles the
> >> DA850/OMAP-L138/AM18x specific case where MMC1 uses DMA channels on
> >> a second EDMA channel controller.  All other platforms have a simpler
> >> design with just a single EDMA channel controller.
> >>
> >> For those wanting to easily test this series, I've pushed a branch for
> >> each version to my github tree at https://github.com/ohporter/linux. The
> >> current branch is edma-dmaengine-v3.
> >>
> >> After this series, the current plan is to complete the mcasp driver
> >> conversion which includes adding cyclic dma support. This will then
> >> enable the removal and refactoring of the private EDMA API functionality
> >> into the EDMA DMA Engine driver.  Since EDMA is also used on the AM33xx
> >> family of parts in mach-omap2/, the plan is to enable this driver on
> >> that platform as well.
> > 
> > Once you have a patch for the McASP driver conversion, I can happily
> > test this on a AM33xx board, together with Gururaja's latest McASP
> > refactoring series. Let me know how I can help you here.
> 
> Did you find some time yet to continue on this side? I don't want to
> appear pushy, but as I need to finish some DT transition on a
> AM33xx-based board, I would much like to help out here, in case I can do
> anything to help speed things along.
> 
> 
> Many thanks for your work!

Hi Daniel,

I'm working on porting this driver work to AM33xx right now. You can
take a look at an ugly but functional WIP version at the above repo
in the WIP/edma-dmaengine-am335x-v3.6-rc4-cpufreq branch. When I say
ugly, I mean ugly...there's a few hacks I'm resolving before I plan
to post an RFC series. However, I've been putting the slave sg transfer
through a workout on hsmmc and mcspi and it is solid now.

I don't expect to start on MCASP conversion until I get this AM33xx
enablement series posted. There's a couple things you could help with
here. First, I have done some preliminary work in understanding the
various "old" platforms in mach-davinci/ that we are going to have to
avoid breaking. The first big issue is that we have a split in h/w
capabilities between the old platforms that have no AFIFO and our newer
ones that do. Unless someone can convince me otherwise, the biggest
(and possibly *only*) driver behind the need for SRAM-based ping-pong
buffering. This SRAM-based ping-pong buffering is a PITA to deal with
atm mostly because we need to encapsulate this behind the cyclic dma
api. It's also IMHO, unneeded if you have one of the modern platforms
that added the AFIFO since you aren't having to feed the serializer at
an unreasonable rate...i.e. we can do fifo bursts.

Now, we *can* handle SRAM ping-pong buffering within the dmaengine
driver, however in the short-term it's a bit of a pain because of the
way the wrapper driver is instantiated and I'd like to avoid any
complication of having to feed it platform data until we absolutely have
to. That is, with SRAM ping-pong buffering, we now have to have
platform-specific data about the SRAM we can allocate. This is
complicated by the fact that 1) the ARM SRAM consolidation series
seemingly died last year...which btw, left some orphaned mcasp sram ping
pong enablement patch out of tree for mach-davinci/ 2) the latest SRAM
driver effort is specifically tied around DT atm which makes it
short-term problematic to leverage on mach-davinci/ platforms where we
really need it.

My best idea at this point is to approach the McASP conversion in a
couple stages. The first is to support cyclic dma in the dmaengine
wrapper driver in continuous mode such that only platforms with AFIFO
support (DA8xx/L138/AM180x and AM33xx/TI81xx to my knowledge) can
utilize it. Also part of the first stage, of course, is the mcasp driver
refactoring so that ping-pong buffering is an optional sub-config option
for those old Davinci boards and continues to use the private EDMA API
for now. I'm ok with this partially because those old platform seem to
be unmaintained (nobody stepped up to test DM644x etc) and the SRAM
ping-pong buffering code is completely unused in mainline right now.
If those !AFIFO platforms were removed from the kernel then we wouldn't
even have to deal with it.

There's a few things you can help with:

1) testing the WIP driver
2) add cyclic dma support
3) do the sram-less mcasp conversion

I'll get to #2 and #3 next, but I have no problem if you beat me to it.

-Matt
